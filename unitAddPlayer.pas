unit unitAddPlayer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmAddPlayer = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    lblTeamName: TLabel;
    cmdAddPlayer: TButton;
    cmbRosterSlot: TComboBox;
    txtNumber: TEdit;
    txtName: TEdit;
    txtPosition: TEdit;
    txtMA: TEdit;
    txtST: TEdit;
    txtAG: TEdit;
    txtAV: TEdit;
    txtCost: TEdit;
    memSkills: TMemo;
    cbPeaked: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    txtValue: TEdit;
    Label13: TLabel;
    Label14: TLabel;
    txtPicture: TEdit;
    dlgPic: TOpenDialog;
    butSelectFile: TButton;
    procedure txtNumberExit(Sender: TObject);
    procedure txtStatExit(Sender: TObject);
    procedure txtStatExit2(Sender: TObject);
    procedure txtCostExit(Sender: TObject);
    procedure txtValueExit(Sender: TObject);
    procedure cmdAddPlayerClick(Sender: TObject);
    procedure butSelectFileClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAddPlayer: TfrmAddPlayer;

procedure ShowAddPlayerWindow(g: integer);
function TranslateAddPlayer(s: string): string;
procedure PlayActionAddPlayer(s: string; dir: integer);

implementation

uses bbunit, bbalg, unitTeam, unitLog, unitPlayer, unitPlayAction,
     unitRoster;

{$R *.DFM}

var curroster: integer;

procedure ShowAddPlayerWindow(g: integer);
var f, m: integer;
begin
  curroster := g;
  frmAddPlayer.lblTeamName.caption := team[g].name;
  frmAddPlayer.lblTeamName.font.color := colorarray[g,0,0];
  frmAddPlayer.cmbRosterSlot.clear;
  for f := 1 to team[g].numplayers do if player[g,f].status = 11 then begin
    frmAddPlayer.cmbRosterSlot.Items.Add(IntToStr(f));
  end;
  if team[g].numplayers < MaxNumPlayersInTeam then
    frmAddPlayer.cmbRosterSlot.Items.Add(IntToStr(team[g].numplayers + 1));
  frmAddPlayer.cmbRosterSlot.ItemIndex := 0;
  m := FVal(frmAddPlayer.cmbRosterSlot.Items[0]);
  f := 1;
  while f <= team[g].numplayers do begin
    if (player[g,f].cnumber <> m) or (player[g,f].status = 11)
     then f := f + 1 else begin
      m := m + 1;
      f := 1;
    end;
  end;
  frmAddPlayer.txtNumber.text := IntToStr(m);
  frmAddPlayer.txtName.text := 'Rookie #' + IntToStr(m);
  frmAddPlayer.ShowModal;
end;

procedure TfrmAddPlayer.txtNumberExit(Sender: TObject);
var f, m: integer;
begin
  m := FVal(txtNumber.text);
  if (m < 1) or (m > 99) then begin
    ShowMessage('Number must be between 1 and 99.');
    txtNumber.SetFocus;
  end else begin
    for f := 1 to team[curroster].numplayers do begin
      if (player[curroster,f].cnumber = m)
       and (player[curroster,f].status <> 11) then begin
        ShowMessage('That number is already being used!');
        txtNumber.SetFocus;
      end;
    end;
  end;
  txtNumber.text := IntToStr(m);
end;

procedure TfrmAddPlayer.txtStatExit(Sender: TObject);
var i: integer;
begin
  i := FVal((Sender as TEdit).text);
  if i < 1 then begin
    ShowMessage('You must fill in a value of at least 1!');
    (Sender as TEdit).SetFocus;
  end;
  (Sender as TEdit).text := IntToStr(i);
end;

procedure TfrmAddPlayer.txtStatExit2(Sender: TObject);
var i: integer;
begin
  i := FVal((Sender as TEdit).text);
  if (i < 1) and (((Sender as TEdit).text)<>'0') then begin
    ShowMessage('You must fill in a numeric value!');
    (Sender as TEdit).SetFocus;
  end;
  (Sender as TEdit).text := IntToStr(i);
end;

procedure TfrmAddPlayer.txtCostExit(Sender: TObject);
var v: integer;
begin
  v := FVal(txtCost.text);
  if 5 * (v div 5) <> v then begin
    ShowMessage('Cost must be a multiple of 5k');
    txtCost.SetFocus;
  end;
  if v > MoneyVal(team[curroster].treasury) then begin
    ShowMessage('You don''t have enough goldpieces in your treasury!');
    txtCost.SetFocus;
  end;
  txtCost.text := IntToStr(5 * (v div 5));
end;

procedure TfrmAddPlayer.txtValueExit(Sender: TObject);
var v: integer;
begin
  v := FVal(txtValue.text);
  if 5 * (v div 5) <> v then begin
    ShowMessage('Value must be a multiple of 5k');
    txtValue.SetFocus;
  end;
  txtValue.text := IntToStr(5 * (v div 5));
  if txtCost.text = '' then txtCost.text := txtValue.text;
end;

function TranslateAddPlayer(s: string): string;
var f, g: integer;
    s0, t, t0: string;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  t := 'Player added to ' + team[g].name + ' (';
  s0 := Copy(s, 5, Length(s) - 4);
  SplitTextAtChr255(s0, t0);
  t := t + t0 + ', ';
  SplitTextAtChr255(s0, t0);
  t := t + t0 + ', ';
  SplitTextAtChr255(s0, t0);
  t := t + IntToStr(Ord(s0[1]) - 48) + ' ' +  IntToStr(Ord(s0[2]) - 48) + ' ' +
           IntToStr(Ord(s0[3]) - 48) + ' ' + IntToStr(Ord(s0[4]) - 48);
  t := t + ' ' + t0;
  if s0[5] = 'P' then t := t + ' (peaked)';
  t := t + ', cost: ' + IntToStr(5 * (Ord(s0[6]) - 48)) + 'k)';
  TranslateAddPlayer := t;
end;

procedure PlayActionAddPlayer(s: string; dir: integer);
var f, g: integer;
    s0, t: string;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  if dir = 1 then begin
    if s[4] = '+' then team[g].numplayers := team[g].numplayers + 1;
    s0 := Copy(s, 5, Length(s) - 4);
    SplitTextAtChr255(s0, player[g,f].name);
    SplitTextAtChr255(s0, player[g,f].position);
    SplitTextAtChr255(s0, t);
    player[g,f].SetSkill(t);
    player[g,f].inj := '';
    player[g,f].ma := Ord(s0[1]) - 48;
    player[g,f].st := Ord(s0[2]) - 48;
    player[g,f].ag := Ord(s0[3]) - 48;
    player[g,f].av := Ord(s0[4]) - 48;
    player[g,f].ma0 := player[g,f].ma;
    player[g,f].st0 := player[g,f].st;
    player[g,f].ag0 := player[g,f].ag;
    player[g,f].av0 := player[g,f].av;
    player[g,f].SetSkillsToDefault;
    player[g,f].int := 0;
    player[g,f].td := 0;
    player[g,f].cas := 0;
    player[g,f].comp := 0;
    player[g,f].mvp := 0;
    player[g,f].otherSPP := 0;
    player[g,f].int0 := 0;
    player[g,f].td0 := 0;
    player[g,f].cas0 := 0;
    player[g,f].comp0 := 0;
    player[g,f].mvp0 := 0;
    player[g,f].otherSPP0 := 0;
    player[g,f].picture := '';
    player[g,f].peaked := (s0[5] = 'P');
    if Length(s0) > 8 then begin
      player[g,f].value := 5 * (Ord(s0[9]) - 48);
      if Length(s0) > 9 then
        player[g,f].picture := Copy(s0, 10, length(s0) - 9);
    end else player[g,f].value := 10 * (Ord(s0[7]) - 48);
    player[g,f].cnumber := Ord(s0[8]) - 64;
    player[g,f].caption := IntToStr(player[g,f].cnumber);
    player[g,f].SetStatusDef(0);
    team[g].treasury :=
       IntToStr(MoneyVal(team[g].treasury) - 5 * (Ord(s0[6]) - 48)) + 'k';
    player[g,f].visible := true;
    DefaultAction(TranslateAddPlayer(s));
  end else begin
    if s[4] = '+' then team[g].numplayers := team[g].numplayers - 1;
    player[g,f].status := 11;
    player[g,f].visible := false;
    s0 := Copy(s, 5, Length(s) - 4);
    SplitTextAtChr255(s0, t);
    SplitTextAtChr255(s0, t);
    SplitTextAtChr255(s0, t);
    team[g].treasury :=
       IntToStr(MoneyVal(team[g].treasury) + 5 * (Ord(s0[6]) - 48)) + 'k';
    BackLog;
  end;
  RedrawDugOut;
end;

procedure TfrmAddPlayer.cmdAddPlayerClick(Sender: TObject);
var f, rs, v: integer;
    s: string;
begin
  v := FVal(txtCost.text);
  if v > MoneyVal(team[curroster].treasury) then begin
    ShowMessage('You don''t have enough goldpieces in your treasury!');
    txtCost.SetFocus;
  end else begin
    rs := FVal(cmbRosterSlot.Items[cmbRosterSlot.ItemIndex]);
    s := 'N' + Chr(curroster + 48) + Chr(rs + 64);
    if rs > team[curroster].numplayers then s := s + '+' else s := s + '=';
    s := s + Trim(txtName.text) + Chr(255);
    s := s + Trim(txtPosition.text) + Chr(255);
    for f := 0 to memSkills.lines.count - 1 do
      s := s + Trim(memSkills.lines[f]) + ' ';
    s := Trim(s) + Chr(255);
    s := s + Chr(FVal(txtMA.text) + 48);
    s := s + Chr(FVal(txtST.text) + 48);
    s := s + Chr(FVal(txtAG.text) + 48);
    s := s + Chr(FVal(txtAV.text) + 48);
    if cbPeaked.Checked then s := s + 'P' else s := s + '+';
    s := s + Chr(FVal(txtCost.text) div 5 + 48);
    s := s + Chr(FVal(txtValue.text) div 10 + 48);
      {the line above is obsolete but left in for backward compatibility}
    s := s + Chr(FVal(txtNumber.text) + 64);
    s := s + Chr(FVal(txtValue.text) div 5 + 48);
    s := s + Trim(txtPicture.text);
    if CanWriteToLog then begin
      LogWrite(s);
      PlayActionAddPlayer(s, 1);
    end;
    ShowTeam(curroster);
    frmAddPlayer.ModalResult := mrOk;
  end;
end;

{procedure TfrmAddPlayer.butSelectFileClick(Sender: TObject);
var s, t: string;
    f: integer;
begin
  t := curdir + 'roster\';
  dlgPic.InitialDir := t;
  dlgPic.Filename := '';
  dlgPic.Options := [ofFileMustExist];
  dlgPic.Execute;
  if dlgPic.Filename <> '' then begin
    s := dlgPic.Filename;
    f := 1;
    while (f <= length(t)) and (f <= length(s))
    and (Uppercase(t[f]) = Uppercase(s[f])) do f := f + 1;
    if f > length(t) then begin
      txtPicture.text := s;
    end else begin
      ShowMessage('Pictures must be put in directory ' + curdir + 'roster');
    end;
  end;
end; }

procedure TfrmAddPlayer.butSelectFileClick(Sender: TObject);
var s: string;
begin
  dlgPic.InitialDir := curdir + 'roster\';
  dlgPic.Filename := '';
  dlgPic.Options := [ofFileMustExist];
  dlgPic.Execute;
  if dlgPic.Filename <> '' then begin
    s := dlgPic.Filename;
    while Pos('roster\', s) > 0 do s := Copy(s, Pos('roster\', s) + 7, Length(s));
    if FileExists(curdir + 'roster\' + s) then begin
      txtPicture.text := s;
    end else begin
      ShowMessage('Pictures must be put in directory ' + curdir + 'roster');
    end;
  end;
end;

end.
