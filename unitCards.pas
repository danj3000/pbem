unit unitCards;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bbalg;

type
  TfrmCards = class(TForm)
    Label4: TLabel;
    passwordLabel: TLabel;
    password: TEdit;
    DrawButton: TButton;
    GroupBox1: TGroupBox;
    RedRB: TRadioButton;
    BlueRB: TRadioButton;
    procedure InitForm;
    procedure numChange(Sender: TObject);
    procedure DrawButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type cardlines = record
                   num: integer;
                   color: array [1..25] of TColor;
                   cset, cnum: array [1..25] of integer;
                 end;

type TCardLabel = class(TLabel)
  private
  public
    cset, cnum: integer;
  end;

var
  frmCards: TfrmCards;
  pw: array [0..1] of string;
  plcards: array [0..1] of string;
  playedcardsset, playedcardsnum: array [0..1, 1..25] of integer;
  DecodedCards: array [0..1, 1..25] of integer;
  DecodedCardsSet: array [0..1, 1..25] of integer;
  cardset: array [1..8,1..50] of string;
  cardhint: array [1..8, 1..50] of string;
  numset: integer;
  setnum: array [1..8] of integer;
  setnm: array [1..8] of string;
  setabbr: array [1..8] of string[2];
  setcolor: array [1..8] of TColor;
  setlabel: array [1..8] of TLabel;
  setselnum: array [1..8] of TEdit;
  DrawNewCards: boolean;

function DecodeCards(g: integer; decode: boolean): cardlines;
procedure RemoveCard(g, f: integer);
procedure RestoreCard(g, f: integer);
procedure RollForCards(g: integer);
function TranslateCardsRoll(cr: string): string;
function TranslateCardsRollLong(cr: string): string;
procedure ShowCards(decode: integer);
procedure PlayActionCardsRoll(s: string; dir: integer);
procedure PlayActionDrawCards(s: string; dir: integer; bbcards: boolean);
procedure PlayActionAddCard(s: string; dir: integer; bbcards: boolean);
procedure PlayActionPlayCard(s: string; dir: integer);

implementation

uses bbunit, unitPregame, unitLog, unitPlayAction, unitRandom, unitSettings;

{$R *.DFM}

procedure ReadCards;
var ff: TextFile;
    s, s0: string;
    p: integer;

begin
  numset := 0;
  AssignFile(ff, curdir + 'ini/' + frmSettings.txtCardsIniFile.text);
  Reset(ff);
  ReadLn(ff, s);
  while not(eof(ff)) do begin
    if Copy(s, 1, 8) = 'CardSet=' then begin
      numset := numset + 1;
      setnm[numset] := Copy(s, 9, length(s) - 8);
      p := Pos(',', setnm[numset]);
      setabbr[numset] := Copy(setnm[numset], p+1, 2);
      setcolor[numset] := FVal(Copy(setnm[numset], p+4, 7));
      setnm[numset] := Copy(setnm[numset], 1, p-1);
      setnum[numset] := 0;
      ReadLn(ff, s);
      while not(Copy(s, 1, 6) = 'EndSet') do begin
        setnum[numset] := setnum[numset] + 1;
        cardset[numset, setnum[numset]] := Trim(s);
        ReadLn(ff, s);
        cardhint[numset, setnum[numset]] := '';
        s0 := '';
        while (s[1] = '=') do begin
          s := Copy(s, 2, length(s) - 1);
          if s = '=' then begin
            cardhint[numset, setnum[numset]] :=
              cardhint[numset, setnum[numset] - 1]
          end else begin
            cardhint[numset, setnum[numset]] :=
              cardhint[numset, setnum[numset]] + s0 + Trim(s);
            s0 := ' ';
            if s = '' then begin
              cardhint[numset, setnum[numset]] :=
                 cardhint[numset, setnum[numset]] + Chr(13) + Chr(13);
              s0 := '';
            end;
          end;
          ReadLn(ff, s);
        end;
      end;
    end;
    ReadLn(ff, s);
  end;
  CloseFile(ff);
end;

procedure TfrmCards.InitForm;
var f, g: integer;
begin
  ReadCards;
  plcards[0] := '00';
  plcards[1] := '00';
  for g := 0 to 1 do
   for f := 1 to 25 do playedcardsset[g,f] := 0;
  pw[0] := '';
  pw[1] := '';
  for g := 1 to numset do begin
    setlabel[g] := TLabel.Create(frmCards);
    setlabel[g].autosize := false;
    setlabel[g].left := 8;
    setlabel[g].top := 40 + g * 28;
    setlabel[g].height := 13;
    setlabel[g].width := 106;
    setlabel[g].alignment := taRightJustify;
    setlabel[g].caption := setnm[g];
    setlabel[g].font.color := setcolor[g];
    setlabel[g].color := clBtnFace;
    setlabel[g].font.size := 8;
    setlabel[g].parent := frmCards;
    setselnum[g] := TEdit.Create(frmCards);
    setselnum[g].autosize := false;
    setselnum[g].left := 120;
    setselnum[g].top := 36 + g * 28;
    setselnum[g].height := 21;
    setselnum[g].width := 33;
    setselnum[g].OnChange := numChange;
    setselnum[g].parent := frmCards;
  end;
  passwordLabel.top := 64 + 28 * numset;
  password.top := passwordLabel.top + 16;
  DrawButton.top := password.top + 28;
  frmCards.height := 164 + 28 * numset;
end;

procedure TfrmCards.numChange(Sender: TObject);
var f, g, t, t1: integer;
    b: boolean;
    s: string;
    old: array[1..25] of integer;
begin
  b := true;
  t := 0;
  g := 0;
  for f := 1 to 25 do old[f] := 0;
  if RedRB.checked then g := 0 else
   if BlueRB.checked then g := 1 else b := false;
  if b then begin
    if not(DrawNewCards) then begin
      b := (plcards[g][1] = '0') or (pw[g] <> '');
      for f := 1 to 25 do begin
        if DecodedCardsSet[g, f] > 0 then begin
          t := t + 1;
          old[f] := old[f] + 1;
        end;
      end;
    end;
  end;
  if b then begin
    t1 := t;
    s := Trim(password.text);
    for f := 1 to numset do
      if (FVal(setselnum[f].text) < 0)
        then b := false
        else t := t + FVal(setselnum[f].text);
    if t > 25 then b := false;
    if (t - t1 <> 1) and not(DrawNewCards) then b := false;
    if (length(s) > 0) and (length(s) < t) then b := false;
  end;
  DrawButton.enabled := b;
end;

procedure TfrmCards.DrawButtonClick(Sender: TObject);
var DrawnCards: array [1..25] of integer;
    DrawnCardsSet: array [1..25] of integer;
    DS, r, f, g, n, i, t: integer;
    found: boolean;
    s, code: string;
begin
  if RedRB.checked then g := 0 else g := 1;
  if DrawNewCards then begin
    for f := 1 to 25 do begin
      DecodedCardsSet[g, f] := 0;
      DecodedCards[g, f] := 0;
    end;
  end;
  DS := 0;
  while (DS < 25) and (DecodedCardsSet[g, DS + 1] > 0) do begin
    DS := DS + 1;
    DrawnCardsSet[DS] := DecodedCardsSet[g, DS];
    DrawnCards[DS] := DecodedCards[g, DS];
  end;
  for n := 1 to numset do begin
    t := FVal(setselnum[n].text);
    f := 0;
    while f < t do begin
      r := Rnd(setnum[n],6) + 1;
      found := false;
      for i := 1 to DS do
       if (DrawnCardsSet[i] = n) and (DrawnCards[i] = r) then found := true;
      if not(found) then begin
        DS := DS + 1;
        DrawnCardsSet[DS] := n;
        DrawnCards[DS] := r;
        f := f + 1;
      end;
    end;
  end;
  s := Trim(password.text);
  t := 0;
  if length(s) > 0 then begin
    code := '1';
    for f := 1 to length(s) do t := (t + Ord(s[f])) mod 26;
    code := code + Chr(t + 65);
    for n := 1 to DS do begin
      r := (DrawnCards[n] + Ord(s[n])) mod setnum[DrawnCardsSet[n]];
      code := code + setabbr[DrawnCardsSet[n]][1] + Chr(65 + r);
    end;
  end else begin
    code := '00';
    for n := 1 to DS do begin
      code := code + setabbr[DrawnCardsSet[n]][1] + Chr(64 + DrawnCards[n]);
    end;
  end;
  pw[g] := s;
  plcards[g] := code;
  for n := 1 to 25 do if playedcardsset[g, n] > 0 then
      RemoveCard(g, n);
  Bloodbowl.comment.text := '* c@rds' + Chr(48 + g);
  frmCards.Hide;
  Bloodbowl.EnterButtonClick(Sender);
  RedRB.checked := false;
  BlueRB.checked := false;
  for g := 1 to numset do setselnum[g].text := '';
  password.text := '';
  if Bloodbowl.visible then begin
    NigglesOrStart;
  end;
end;

function DecodeCards(g: integer; decode: boolean): cardlines;
var
  setAbbrLocal: string;
  f, t, i: integer;
  s: string;
  cl: cardlines;
begin
  cl.num := 0;
  s := plcards[g];
  if s <> '' then
  begin
    if decode and (s[1] = '1') then
    begin
      if pw[g] = '' then
      begin
        pw[g] := InputBox('Password: ', 'Bloodbowl Cards', '');
        t := 0;
        for f := 1 to length(pw[g]) do
          t := (t + Ord(pw[g][f])) mod 26;
        if t <> Ord(s[2]) - 65 then
          pw[g] := '';
      end;
    end;
  end;
  f := 1;
  while (f * 2 + 2) <= length(s) do
  begin
    cl.num := cl.num + 1;
    if s[1] = '0' then
      t := Ord(s[f * 2 + 2]) - 64
    else
    begin
      if pw[g] = '' then
      begin
        if playedcardsset[g, f] = 0 then
          t := 0
        else
          t := -1;
      end
      else
      begin
        t := Ord(s[f * 2 + 2]) - 65 - Ord(pw[g][f]);
        setAbbrLocal := setabbr[i][1];
        for i := 1 to numset do
          if UpCase(s[f * 2 + 1]) = setAbbrLocal then
          begin
            while t <= 0 do
              t := t + setnum[i];
          end;
      end;
    end;
    for i := 1 to numset do
      setAbbrLocal := setabbr[i][1];
      if UpCase(s[f * 2 + 1]) = setAbbrLocal then
      begin
        cl.color[cl.num] := setcolor[i];
        cl.cset[cl.num] := i;
        if t > 0 then
        begin
          cl.cset[cl.num] := i;
          cl.cnum[cl.num] := t;
          DecodedCards[g, cl.num] := t;
          DecodedCardsSet[g, cl.num] := i;
        end;
      end;
    if t = -1 then
    begin
      cl.cset[cl.num] := playedcardsset[g, f];
      cl.cnum[cl.num] := playedcardsnum[g, f];
    end;
    if t = 0 then
      cl.cnum[cl.num] := 0;
    if s[f * 2 + 1] = Lowercase(s[f * 2 + 1]) then
      cl.color[cl.num] := clSilver;
    f := f + 1;
  end;
  DecodeCards := cl;
end;

procedure RemoveCard(g, f: integer);
var cardlen: integer;
begin
  {This code was added by Tom ... the old code did not have the below
    if statement and in the plcards[g] := an 18 appeared where the
    variable cardlen is now.  This prevented a player from being able
    to add a card if they already had 9 cards, the new code allows the
    player to draw the 10th card.}
  if length(plcards[g]) <= 21 then cardlen := 18 else
     cardlen := 18 + (length(plcards[g]) - 21);
  plcards[g] := Copy(plcards[g], 1, f * 2) +
                Lowercase(plcards[g][f * 2 + 1]) +
                Copy(plcards[g], f * 2 + 2, cardlen);
  playedcardsset[g,f] := CardsData[g,f].cset;
  playedcardsnum[g,f] := CardsData[g,f].cnum;
end;

procedure RestoreCard(g, f: integer);
var cardlen: integer;
begin
  {This code was added by Tom ... the old code did not have the below
    if statement and in the plcards[g] := an 18 appeared where the
    variable cardlen is now.  This prevented a player from being able
    to add a card if they already had 9 cards, the new code allows the
    player to draw the 10th card.}
  if length(plcards[g]) <= 21 then cardlen := 18 else
     cardlen := 18 + (length(plcards[g]) - 21);
  plcards[g] := Copy(plcards[g], 1, f * 2) +
                Uppercase(plcards[g][f * 2 + 1]) +
                Copy(plcards[g], f * 2 + 2, cardlen);
end;

procedure RollForCards(g: integer);
var r: integer;
    s: string;
begin
  r := Rnd(6,6) + 1;
  s := 'DC' + Chr(48+g) + Chr(48+r);
  if CanWriteToLog then begin
    LogWrite(s);
    AddLog(TranslateCardsRollLong(s));
  end;
end;

function TranslateCardsRoll(cr: string): string;
var s: string;
    g: integer;
begin
  g := Ord(cr[3]) - 48;
  if frmSettings.rgCardSystem.ItemIndex = 0 then
    begin
      case cr[4] of
        '1': s := '1 card';
        '2', '3', '4', '5': s := '2 cards';
        '6': s := '3 cards';
      end;
    end;
  if frmSettings.rgCardSystem.ItemIndex = 1 then
    begin
      case cr[4] of
        '1', '2', '3', '4', '5': s := '0 cards';
        '6': s := '1 card';
      end;
    end;
  if frmSettings.rgCardSystem.ItemIndex = 2 then
    begin
      case cr[4] of
        '1', '2', '3', '4', '5': s := '1 card';
        '6': s := '2 cards';
      end;
    end;
  if team[g].bonuscards > 0 then
     s := s + ' + ' + IntToStr(team[g].bonuscards) + ' bonus cards';
  TranslateCardsRoll := s;
end;

function TranslateCardsRollLong(cr: string): string;
var g, r: integer;
    s: string;
begin
  s := TranslateCardsRoll(cr);
  g := Ord(cr[3]) - 48;
  r := Ord(cr[4]) - 48;
  if g = 0 then begin
    Bloodbowl.LblCardsRed.caption := s;
    Bloodbowl.ImRedDie.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + '.bmp');
    Bloodbowl.ImRedDie.visible := true;
  end else begin
    Bloodbowl.LblCardsBlue.caption := s;
    Bloodbowl.ImBlueDie.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + 'b.bmp');
    Bloodbowl.ImBlueDie.visible := true;
  end;
  TranslateCardsRollLong := 'Cards roll for ' + ffcl[g] + ': ' + cr[4] +
    ' (' + s + ')';
end;

procedure ShowCards(decode: integer);
var cl: cardlines;
    f, g: integer;
begin
  for g := 0 to 1 do begin
    cl := DecodeCards(g, (g = decode));
    for f := 1 to cl.num do begin
      CardsData[g,f].font.color := cl.color[f];
      CardsData[g,f].OnClick := Bloodbowl.cardPlayClick;
      CardsData[g,f].cset := cl.cset[f];
      CardsData[g,f].cnum := cl.cnum[f];
      if cl.cset[f] > 0 then begin
        if cl.cnum[f] > 0 then begin
          CardsData[g,f].caption := '#' + IntToStr(cl.cnum[f]) + ' ' +
                    cardset[cl.cset[f], cl.cnum[f]];
        end else begin
          CardsData[g,f].caption := setabbr[cl.cset[f]] + ' ?????????';
        end;
      end;
      CardsData[g,f].visible := true;
    end;
    for f := cl.num + 1 to 25 do begin
      CardsData[g,f].caption := '';
      CardsData[g,f].visible := false;
    end;
  end;
end;

procedure PlayActionCardsRoll(s: string; dir: integer);
var g: integer;
begin
  g := Ord(s[3]) - 48;
  if dir = DIR_FORWARD then begin
    DefaultAction(TranslateCardsRollLong(s));
    if g = 0 then Bloodbowl.ButCardsRed.enabled := false
             else Bloodbowl.ButCardsBlue.enabled := false;
    DrawNewCards := true;
    frmCards.Show;
    if g = 0 then frmCards.RedRB.checked := true
             else frmCards.BlueRB.checked := true;
  end else begin
    if g = 0 then begin
      Bloodbowl.LblCardsRed.caption := '';
      Bloodbowl.ImRedDie.visible := false;
      Bloodbowl.ButCardsRed.enabled := true;
    end else begin
      Bloodbowl.LblCardsBlue.caption := '';
      Bloodbowl.ImBlueDie.visible := false;
      Bloodbowl.ButCardsBlue.enabled := true;
    end;
    frmCards.Hide;
    BackLog;
  end;
end;

procedure PlayActionDrawCards(s: string; dir: integer; bbcards: boolean);
var f, g, r: integer;
    s0, setAbbrLocal: string;
begin
  g := Ord(s[2]) - 48;
  if dir = DIR_FORWARD then begin
    frmCards.Hide;
    plcards[g] := Copy(s, 3, length(s));
    f := 3;
    s0 := '';
    while f < length(plcards[g]) do begin
      for r := 1 to numset do
        setAbbrLocal := setabbr[r][1];
        if plcards[g][f] = setAbbrLocal then
          begin
           s0 := s0 + ' ' + setabbr[r];
          end;
        f := f + 2;
      end;
    if g = 0 then Bloodbowl.LblCardsRed.caption := Trim(s0)
             else Bloodbowl.LblCardsBlue.caption := Trim(s0);
    s0 := 'Cards for ' + ffcl[g] + ':' + s0;
    if bbcards then s0 := s0 + ' (cards from ' +
                                frmSettings.txtCardsIniFile.text + ')';
    DefaultAction(s0);
    if not(Bloodbowl.ButCardsRed.enabled)
    and not(Bloodbowl.ButCardsBlue.enabled) then begin
      NigglesOrStart;
    end;
  end else begin
    BackLog;
    plcards[g] := '';
    DrawNewCards := true;
    frmCards.Show;
    if g = 0 then frmCards.RedRB.checked := true
             else frmCards.BlueRB.checked := true;

    Bloodbowl.ButToss.enabled := false;
  end;
  ShowCards(2);
end;

procedure PlayActionAddCard(s: string; dir: integer; bbcards: boolean);
var
  setAbbrLocal: string;
  g, q, r: integer;
  s0: string;
begin
  g := Ord(s[2]) - 48;
  if dir = DIR_FORWARD then
  begin
    plcards[g] := Copy(s, 3, length(s));
    q := length(plcards[g]) - 1;
    s0 := 'Extra Card for ' + ffcl[g] + ':';
    setAbbrLocal := setabbr[r][1];
    for r := 1 to numset do
      if plcards[g][q] = setAbbrLocal then
      begin
        s0 := s0 + ' ' + setabbr[r];
      end;
    if bbcards then
      s0 := s0 + ' (cards from ' + frmSettings.txtCardsIniFile.text + ')';
    DefaultAction(s0);
  end
  else
  begin
    BackLog;
    plcards[g] := Copy(plcards[g], 1, length(plcards[g]) - 2);
  end;
  ShowCards(2);
end;

procedure PlayActionPlayCard(s: string; dir: integer);
var f, g, cs, cn: integer;
    s0: string;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  cs := Ord(s[4]) - 64;
  cn := Ord(s[5]) - 64;
  if dir = DIR_FORWARD then begin
    s0 := cardset[cs, cn];
    CardsData[g,f].cset := cs;
    CardsData[g,f].cnum := cn;
    RemoveCard(g, f);
    ShowCards(2);
    DefaultAction(ffcl[g] + ' plays card "#' + IntToStr(cn) + ' ' + s0 + '"');
  end else begin
    RestoreCard(g, f);
    ShowCards(2);
    BackLog;
  end;
end;

end.
