unit unitHandicapTable;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, Variants;

type
  TfrmHandicapTable = class(TForm)
    pnlSingleHandicapTable: TPanel;
    lblChangeDice: TLabel;
    butAcceptDice: TButton;
    pnlMultipleHandicapTables: TPanel;
    Label1: TLabel;
    lblPointsToSpend: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure DiceClick(Sender: TObject);
    procedure butAcceptDiceClick(Sender: TObject);
    procedure butHandicapBuyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmHandicapTable: TfrmHandicapTable;

procedure MakeHandicapRolls;
function TranslateHandicapRolls(s: string): string;
procedure PlayActionHandicapRolls(s: string; dir: integer);
procedure OtherHandicapSetup;
procedure ShowHandicapTablesForm;

implementation

{$R *.DFM}

uses bbalg, bbunit, unitRandom, unitPlayAction, unitLog, unitPregame,
  unitSettings;

const MaxNumHandicapBuyButtons = 5;
      MaxNumHandicap4Memos = 10;

var HRDice: array [0..4, 0..1] of TImage;
    HandicapMemo: array [0..4] of TMemo;
    r1, r2, PointsToSpend, NumHandicapBuyButtons, NumRollsMade: integer;
    RollMade: array [1..6, 1..6] of boolean;
    ScaledRollMade: array [1..5, 1..66] of boolean;
    HRDescr: array [1..6, 1..6] of string;
    ShortDes: array [1..6, 1..6] of string;
    DesUsed: array [1..36] of boolean;
    DesInTable: array [1..36] of string;
    btnHandicapBuy: array [1..MaxNumHandicapBuyButtons] of TButton;
    HandicapCost: array [1..MaxNumHandicapBuyButtons] of integer;
    HandicapDesc: array [1..MaxNumHandicapBuyButtons] of string;
    Handicap4Memo: array [1..MaxNumHandicap4Memos] of TMemo;
    BufferStringAskHandicapDesc, BufferStringHandicapDesc: string;


procedure TfrmHandicapTable.FormCreate(Sender: TObject);
var f, g, i, j, p: integer;
    FoundIt: boolean;
    gg, hh: TextFile;
    s: string;
begin
  for f := 0 to 4 do begin
    for g := 0 to 1 do begin
      HRDice[f,g] := TImage.Create(frmHandicapTable);
      HRDice[f,g].Left := 8 + 40 * g;
      HRDice[f,g].top := 12 + 68 * f;
      HRDice[f,g].Width := 33;
      HRDice[f,g].height := 33;
      HRDice[f,g].parent := pnlSingleHandicapTable;
      HRDice[f,g].stretch := true;
      HRDice[f,g].visible := true;
      if f = 4 then begin
        HRDice[f,g].onclick := DiceClick;
      end;
    end;
    HandicapMemo[f] := TMemo.Create(frmHandicapTable);
    HandicapMemo[f].left := 88;
    HandicapMemo[f].top := 12 + 68 * f;
    HandicapMemo[f].width := 593;
    HandicapMemo[f].Height := 49;
    HandicapMemo[f].parent := pnlSingleHandicapTable;
    HandicapMemo[f].WordWrap := true;
    HandicapMemo[f].scrollbars := ssVertical;
    HandicapMemo[f].readonly := true;
    HandicapMemo[f].color := clSilver;
    HandicapMemo[f].visible := true;
  end;

  AssignFile(gg, curdir + 'ini/bbhandicap.ini');
  Reset(gg);
  for f := 1 to 6 do begin
    for g := 1 to 6 do begin
      Readln(gg, s);
      HRDescr[f,g] := Copy(s, 4, Length(s) - 3);
      p := Pos(':',s);
      ShortDes[f,g] := Copy(s, 4, (p-4));
    end;
  end;
  CloseFile(gg);
  for i := 1 to 36 do begin
    DesInTable[i] := 'XYZDFG';
    DesUsed[i] := False;
  end;
  j := 0;
  for f := 1 to 6 do begin
    for g := 1 to 6 do begin
      Foundit := False;
      for i := 1 to 36 do begin
        if DesInTable[i] = ShortDes[f,g] then FoundIt := True;
      end;
      if not(FoundIt) then begin
        j := j + 1;
        DesInTable[j] := ShortDes[f,g];
      end;
    end;
  end;

  AssignFile(hh, curdir + 'ini/bbhandicap_Scaled.ini');
  Reset(hh);
  f := 0;
  while not(eof(hh)) do begin
    ReadLn(hh, s);
    s := Trim(s) + '*'; {so next test won't raise an error when s = ''}
    if s[1] = '[' then begin
      f := f + 1;
      btnHandicapBuy[f] := TButton.Create(frmHandicapTable);
      p := Pos('---', s);
      HandicapCost[f] := FVal(Trim(Copy(s, Length(s)-4, 3)));
      HandicapDesc[f] := Copy(s, 8, p-9);
      btnHandicapBuy[f].Caption := HandicapDesc[f] + ' (Cost: ' +
                IntToStr(HandicapCost[f]) + ')';
      btnHandicapBuy[f].Left := 8;
      btnHandicapBuy[f].Top := f * 30 + 10;
      btnHandicapBuy[f].Width := 250;
      btnHandicapBuy[f].Parent := pnlMultipleHandicapTables;
      btnHandicapBuy[f].visible := true;
      btnHandicapBuy[f].OnClick := butHandicapBuyClick;
    end;
  end;
  NumHandicapBuyButtons := f;
  CloseFile(hh);

  PointsToSpend := 9999; {initial value}
  NumRollsMade := 0;
end;

procedure OtherHandicapSetup;
var f, g, p, j, i: integer;
    gg: TextFile;
    s: string;
    FoundIt: boolean;
begin
  AssignFile(gg, curdir + 'ini/' + frmSettings.txtHandicapIniFile.text);
  Reset(gg);
  for f := 1 to 6 do begin
    for g := 1 to 6 do begin
      Readln(gg, s);
      HRDescr[f,g] := Copy(s, 4, Length(s) - 3);
      p := Pos(':',s);
      ShortDes[f,g] := Copy(s, 4, (p-4));
    end;
  end;
  for i := 1 to 36 do begin
    DesInTable[i] := 'XYZDFG';
    DesUsed[i] := False;
  end;
  j := 0;
  for f := 1 to 6 do begin
    for g := 1 to 6 do begin
      Foundit := False;
      for i := 1 to 36 do begin
        if DesInTable[i] = ShortDes[f,g] then FoundIt := True;
      end;
      if not(FoundIt) then begin
        j := j + 1;
        DesInTable[j] := ShortDes[f,g];
      end;
    end;
  end;
end;

procedure FillMemo(f: integer);
var i, TestThis: integer;
    KeepGoing: boolean;
begin
  HRDice[f,0].Picture.LoadFromFile(
                curdir + 'images\die' + IntToStr(r1) + 'b.bmp');
  HRDice[f,1].Picture.LoadFromFile(
                curdir + 'images\die' + IntToStr(r2) + '.bmp');
  if f = 4 then begin
    KeepGoing := True;
    for i := 1 to 36 do begin
      if DesInTable[i] = ShortDes[r1,r2] then TestThis := i;
    end;
    if DesUsed[TestThis] then KeepGoing := False;
    frmHandicapTable.butAcceptDice.enabled := KeepGoing;
  end;
  HandicapMemo[f].Text := HRDescr[r1, r2];
end;

procedure TfrmHandicapTable.DiceClick(Sender: TObject);
begin
  if (Sender as TImage) = HRDice[4,0] then begin
    r1 := r1 mod 6 + 1;
  end else begin
    r2 := r2 mod 6 + 1;
  end;
  FillMemo(4);
end;

procedure MakeHandicapRolls3;
var f, g, numrolls, j, TestThis, i, t, z: integer;
    s: string;
    KeepGoing: Boolean;
begin
  s := 'HG';
  SmellingSalts := false;
  BribeTheAnnouncers := false;
  PalmedCoin := false;
  ArgueMod := 0;
  RefMod := 0;
  for f := 1 to 6 do
    for g := 1 to 6 do
      RollMade[f,g] := false;
  if numHandicaps > 4 then numrolls := 4 else numrolls := numHandicaps;
  for f := 0 to numrolls - 1 do begin
    r1 := Rnd(6,6) + 1;
    r2 := Rnd(6,6) + 1;
    KeepGoing := False;
    for i := 1 to 36 do begin
      if DesInTable[i] = ShortDes[r1,r2] then TestThis := i;
    end;
    if DesUsed[TestThis] then KeepGoing := True;
    while KeepGoing do begin
      r1 := Rnd(6,6) + 1;
      r2 := Rnd(6,6) + 1;
      for i := 1 to 36 do begin
        if DesInTable[i] = ShortDes[r1,r2] then TestThis := i;
      end;
      if not(DesUsed[TestThis]) then KeepGoing := False;
      for t := 1 to 6 do begin
        for z := 1 to 6 do begin
          if RollMade[t,z] then begin
            if ShortDes[r1,r2] = ShortDes[t,z] then KeepGoing := True;
          end;
        end;
      end;
    end;
    RollMade[r1,r2] := true;
    DesUsed[TestThis] := true;
    s := s + Chr(r1 + 48) + Chr(r2 + 48);
  end;
  for f := 1 to 6 do begin
    for g := 1 to 6 do begin
      if RollMade[f,g] then begin
        if ShortDes[f,g] = 'SMELLING SALTS' then SmellingSalts := True;
        if ShortDes[f,g] = 'BRIBE THE ANNOUNCERS' then BribeTheAnnouncers := True;
        if ShortDes[f,g] = 'PALMED COIN' then PalmedCoin := True;
        if (ShortDes[f,g] = 'BIASED REFEREE') and
          (frmSettings.cbBiasedReferee.checked) then ArgueMod := 2;
        if (ShortDes[f,g] = 'UNDER SCRUNTIY') and
          (frmSettings.txtHandicapIniFile.text='bbhandicap_MBBL2.ini') then
          RefMod := 1;
      end;
    end;
  end;
  if CanWriteToLog then begin
    LogWrite(s);
    PlayActionHandicapRolls(s, 1);
  end;
end;

procedure MakeHandicapRolls4;
var f, g, numrolls, j, TestThis, i: integer;
begin
  for f := 1 to 5 do
    for g := 1 to 66 do
      ScaledRollMade[f,g] := false;
  if PointsToSpend = 9999 then begin
    if CanWriteToLog then begin
      LogWrite('(Hs' + IntToStr(numHandicaps));
      PlayActionHandicapRolls('Hs' + IntToStr(numHandicaps), 1);
    end;
  end;
  frmHandicapTable.lblPointsToSpend.Caption := IntToStr(PointsToSpend);  
end;

procedure MakeHandicapRolls;
begin
  if frmSettings.rgCardSystem.ItemIndex = 3 then begin
    MakeHandicapRolls3;
  end;
  if frmSettings.rgCardSystem.ItemIndex = 4 then begin
    MakeHandicapRolls4;
  end;
  ShowHandicapTablesForm;
end;

function TranslateHandicapRolls3(s: string): string;
var i: integer;
    sh: string;
begin
  if s[2] = 'G' then begin
    i := 3;
    sh := 'Handicap Rolls: ';
    while i < Length(s) do begin
      sh := sh + ' (' + s[i] + ',' + s[i+1] + ')';
      i := i + 2;
    end;
    TranslateHandicapRolls3 := sh;
  end else begin
    TranslateHandicapRolls3 := 'Selected Handicap Roll: (' +
                s[3] + ',' + s[4] + ')';
  end;
end;

function GetHandicap4Desc(s: string): string;
var hh: TextFile;
    s0: string;
    f, g, h, i: integer;
begin
  if BufferStringAskHandicapDesc = s then begin
    GetHandicap4Desc := BufferStringHandicapDesc;
  end else begin
    BufferStringAskHandicapDesc := s;
    AssignFile(hh, curdir + 'ini/bbhandicap_Scaled.ini');
    Reset(hh);
    f := 0;
    g := Ord(s[3]) - 48;
    i := Ord(s[4]) - 48;
    while not(eof(hh)) and (f < g) do begin
      ReadLn(hh, s0);
      s0 := Trim(s0) + '*'; {so next test won't raise an error when s = ''}
      if s0[1] = '[' then begin
        f := f + 1;
        if f = g then begin
          h := -1;
          while not(eof(hh)) and (h < i) do begin
            h := h + 1;
            ReadLn(hh, s0);
          end;
        end;
      end;
    end;
    CloseFile(hh);
    BufferStringHandicapDesc := s0;
    GetHandicap4Desc := s0;
  end;
end;

function TranslateHandicapRolls4(s: string): string;
begin
  TranslateHandicapRolls4 := 'Selected handicap: ' + GetHandicap4Desc(s);
end;

function TranslateHandicapRolls(s: string): string;
begin
  if frmSettings.rgCardSystem.ItemIndex = 3 then begin
    TranslateHandicapRolls := TranslateHandicapRolls3(s);
  end;
  if frmSettings.rgCardSystem.ItemIndex = 4 then begin
    TranslateHandicapRolls := TranslateHandicapRolls4(s);
  end;
end;

procedure PlayActionHandicapRolls3(s: string; dir: integer);
var i, j, g, f: integer;
    b: boolean;
begin
  if dir = 1 then begin
    if s[2] = 'G' then begin
      for i := 1 to 6 do begin
        for j := 1 to 6 do begin
          RollMade[i,j] := false;
        end;
      end;
      SmellingSalts := false;
      BribeTheAnnouncers := false;
      PalmedCoin := false;
      ArgueMod := 0;
      RefMod := 0;
      i := 3;
      j := 0;
      while i < Length(s) do begin
        r1 := Ord(s[i]) - 48;
        r2 := Ord(s[i+1]) - 48;
        RollMade[r1,r2] := true;
        FillMemo(j);
        j := j + 1;
        i := i + 2;
      end;
      for f := 1 to 6 do begin
        for g := 1 to 6 do begin
          if RollMade[f, g] then begin
            if ShortDes[f,g] = 'SMELLING SALTS' then SmellingSalts := True;
            if ShortDes[f,g] = 'BRIBE THE ANNOUNCERS' then BribeTheAnnouncers := True;
            if ShortDes[f,g] = 'PALMED COIN' then PalmedCoin := True;
            if (ShortDes[f,g] = 'BIASED REFEREE') and
              (frmSettings.cbBiasedReferee.checked) then ArgueMod := 2;
            if (ShortDes[f,g] = 'UNDER SCRUNTIY') and
              (frmSettings.txtHandicapIniFile.text='bbhandicap_MBBL2.ini') then
              RefMod := 1;
          end;
        end;
      end;
      if NumHandicaps > 4 then begin
        frmHandicapTable.height := 395;
        b := true;
        r1 := 1;
        r2 := 1;
        FillMemo(4);
      end else begin
        frmHandicapTable.height := 68 * j + 25;
        Bloodbowl.butMakeHandicapRolls.enabled := false;
        b := false;
        NigglesOrStart;
      end;
    end else begin
      r1 := Ord(s[3]) - 48;
      r2 := Ord(s[4]) - 48;
      RollMade[r1,r2] := true;
      FillMemo(4);
      b := false;
      Bloodbowl.butMakeHandicapRolls.enabled := false;
      NigglesOrStart;
    end;
    HRDice[4,0].enabled := b;
    HRDice[4,1].enabled := b;
    frmHandicapTable.lblChangeDice.visible := b;
    frmHandicapTable.butAcceptDice.enabled := b;
    if (numHandicaps > 4) and (DesUsed[1]) then
      frmHandicapTable.butAcceptDice.enabled := False;
    DefaultAction(TranslateHandicapRolls(s));
    Bloodbowl.HandicapRolls1.enabled := true;
  end else begin
    BackLog;
    Bloodbowl.butMakeHandicapRolls.enabled := true;
    Bloodbowl.ButNiggles.enabled := false;
    Bloodbowl.ButToss.enabled := false;
    Bloodbowl.HandicapRolls1.enabled := false;
  end;
end;

procedure PlayActionHandicapRolls4(s: string; dir: integer);
var f: integer;
begin
  if s[2] = 's' then begin
    PointsToSpend := FVal(Copy(s,3,3));
  end else begin
    f := Ord(s[3]) - 48;
    if dir = 1 then begin
      NumRollsMade := NumRollsMade + 1;
      PointsToSpend := PointsToSpend - HandicapCost[f];

      Handicap4Memo[NumRollsMade] := TMemo.Create(frmHandicapTable);
      Handicap4Memo[NumRollsMade].left := 16;
      Handicap4Memo[NumRollsMade].top := 68 + 68 * NumRollsMade;
      Handicap4Memo[NumRollsMade].width := 665;
      Handicap4Memo[NumRollsMade].Height := 49;
      Handicap4Memo[NumRollsMade].parent := frmHandicapTable.pnlMultipleHandicapTables;
      Handicap4Memo[NumRollsMade].WordWrap := true;
      Handicap4Memo[NumRollsMade].scrollbars := ssVertical;
      Handicap4Memo[NumRollsMade].readonly := true;
      Handicap4Memo[NumRollsMade].color := clSilver;
      Handicap4Memo[NumRollsMade].visible := true;

      Handicap4Memo[NumRollsMade].Text := GetHandicap4Desc(s);
      if Pos('SMELLING SALTS',Handicap4Memo[NumRollsMade].Text)<>0
        then SmellingSalts := True;
      if Pos('PALMED COIN',Handicap4Memo[NumRollsMade].Text)<>0
        then PalmedCoin := True;
      if PointsToSpend < 10 then begin
        Bloodbowl.butMakeHandicapRolls.enabled := false;
        NigglesOrStart;
      end;
      DefaultAction(TranslateHandicapRolls(s));
      Bloodbowl.HandicapRolls1.enabled := true;
    end else begin
      BackLog;
      Bloodbowl.butMakeHandicapRolls.enabled := true;
      Bloodbowl.ButNiggles.enabled := false;
      Bloodbowl.ButToss.enabled := false;
      Bloodbowl.HandicapRolls1.enabled := false;
      Handicap4Memo[NumRollsMade].Free;
      NumRollsMade := NumRollsMade - 1;
      PointsToSpend := PointsToSpend + HandicapCost[f];
      SmellingSalts := False;
      PalmedCoin := False;
    end;

    frmHandicapTable.Height := 68 * NumRollsMade + 160;
    frmHandicapTable.pnlMultipleHandicapTables.Height := frmHandicapTable.ClientHeight;
    frmHandicapTable.lblPointsToSpend.caption := IntToStr(PointsToSpend);
    for f := 1 to NumHandicapBuyButtons do begin
      btnHandicapBuy[f].enabled := (PointsToSpend >= HandicapCost[f]);
    end;
  end;
end;

procedure PlayActionHandicapRolls(s: string; dir: integer);
begin
  if frmSettings.rgCardSystem.ItemIndex = 3 then begin
    PlayActionHandicapRolls3(s, dir);
  end;
  if frmSettings.rgCardSystem.ItemIndex = 4 then begin
    PlayActionHandicapRolls4(s, dir);
  end;
end;

procedure TfrmHandicapTable.butAcceptDiceClick(Sender: TObject);
var s: string;
    f, g: integer;
begin
  RollMade[r1,r2] := true;
  for f := 1 to 6 do begin
    for g := 1 to 6 do begin
      if RollMade[f,g] then begin
        if ShortDes[f,g] = 'SMELLING SALTS' then SmellingSalts := True;
        if ShortDes[f,g] = 'BRIBE THE ANNOUNCERS' then BribeTheAnnouncers := True;
        if ShortDes[f,g] = 'PALMED COIN' then PalmedCoin := True;
        if (ShortDes[f,g] = 'BIASED REFEREE') and
          (frmSettings.cbBiasedReferee.checked) then ArgueMod := 2;
        if (ShortDes[f,g] = 'UNDER SCRUNTIY') and
          (frmSettings.txtHandicapIniFile.text='bbhandicap_MBBL2.ini') then
          RefMod := 1;
      end;
    end;
  end;
  HRDice[4,0].enabled := false;
  HRDice[4,1].enabled := false;
  lblChangeDice.visible := false;
  butAcceptDice.Enabled := false;
  frmHandicapTable.hide;
  s := 'HR' + Chr(r1 + 48) + Chr(r2 + 48);
  if CanWriteToLog then begin
    LogWrite(s);
    PlayActionHandicapRolls(s, 1);
  end;
end;

procedure TfrmHandicapTable.butHandicapBuyClick(Sender: TObject);
var f, g, r: integer;
    PurchaseOk, AllGone: boolean;
    hh: TextFile;
    s: string;
begin
  g := 1;
  while btnHandicapBuy[g] <> (Sender as TButton) do g := g + 1;

  AssignFile(hh, curdir + 'ini/bbhandicap_Scaled.ini');
  Reset(hh);
  f := 0;
  while not(eof(hh)) do begin
    ReadLn(hh, s);
    s := Trim(s) + '*'; {so next test won't raise an error when s = ''}
    if s[1] = '[' then begin
      f := f + 1;
      if f = g then begin
        r := -1;
        while not(eof(hh)) and (s <> '') do begin
          r := r + 1;
          ReadLn(hh, s);
        end;
      end;
    end;
  end;
  CloseFile(hh);
  PurchaseOk := false;
  while not(PurchaseOk) do begin
    r1 := Rnd(r, 6);
    if not(ScaledRollMade[g,(r1+1)]) then begin
      ScaledRollMade[g,(r1+1)] := true;
      PurchaseOk := true;
    end;
  end;
  s := 'HB' + Chr(g + 48) + Chr(r1 + 48);
  if CanWriteToLog then begin
    LogWrite(s);
    PlayActionHandicapRolls(s, 1);
  end;
  AllGone := true;
  for f := 1 to r do begin
    if not(ScaledRollMade[g,f]) then AllGone := false;
  end;
  if AllGone then btnHandicapBuy[g].enabled := false;
end;

procedure ShowHandicapTablesForm;
var f: integer;
begin
  frmHandicapTable.pnlSingleHandicapTable.BringToFront;
  frmHandicapTable.pnlMultipleHandicapTables.BringToFront;
  frmHandicapTable.pnlSingleHandicapTable.Visible :=
        (frmSettings.rgCardSystem.ItemIndex = 3);
  frmHandicapTable.pnlMultipleHandicapTables.Visible :=
        (frmSettings.rgCardSystem.ItemIndex = 4);
  for f := 1 to NumHandicapBuyButtons do begin
    btnHandicapBuy[f].enabled := (PointsToSpend >= HandicapCost[f]);
  end;
  frmHandicapTable.Show;
end;

end.
