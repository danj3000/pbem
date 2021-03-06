unit unitPlayerStatsChange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bbalg, unitLog, bbunit;

type
  TfrmPlayerStatsChange = class(TForm)
    NameLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    butReset: TButton;
    MADef: TEdit;
    STDef: TEdit;
    AGDef: TEdit;
    AVDef: TEdit;
    SkillsDef: TMemo;
    MANew: TEdit;
    STNew: TEdit;
    AGNew: TEdit;
    AVNew: TEdit;
    SkillsNew: TMemo;
    butUseCurrent: TButton;
    Label6: TLabel;
    PNameNew: TEdit;
    PNameDef: TEdit;
    Label7: TLabel;
    PNoNew: TEdit;
    PNoDef: TEdit;
    ValueNew: TEdit;
    Label8: TLabel;
    ValueDef: TEdit;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    PictureNew: TEdit;
    IconNew: TEdit;
    PictureDef: TEdit;
    IconDef: TEdit;
    butSelectFile: TButton;
    dlgPic: TOpenDialog;
    dlgPic2: TOpenDialog;
    Button1: TButton;
    Label13: TLabel;
    PositionNew: TEdit;
    PositionDef: TEdit;
    procedure FormActivate(Sender: TObject);
    procedure butResetClick(Sender: TObject);
    procedure butSelectFileClick(Sender: TObject);
    procedure butUseCurrentClick(Sender: TObject);
    procedure txtNumberExit(Sender: TObject);
    procedure txtStatExit2(Sender: TObject);
    procedure txtValueExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPlayerStatsChange: TfrmPlayerStatsChange;
  TeamChanged, PlayerChanged: integer;

implementation

{$R *.DFM}

uses unitPlayer;

procedure TfrmPlayerStatsChange.FormActivate(Sender: TObject);
begin
  NameLabel.caption := allPlayers[TeamChanged, PlayerChanged].GetPlayerName;
  NameLabel.font.color := colorarray[TeamChanged,0,0];
  MADef.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].ma0);
  STDef.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].st0);
  AGDef.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].ag0);
  AVDef.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].av0);
  ValueDef.Text := InttoStr(allPlayers[TeamChanged, PlayerChanged].value0);
  PNameDef.Text := allPlayers[TeamChanged, PlayerChanged].name0;
  PNoDef.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].cnumber0);
  PositionDef.text := allPlayers[TeamChanged, PlayerChanged].position0;
  IconDef.text := 'Yet to be Enabled';
  PictureDef.text := allPlayers[TeamChanged, PlayerChanged].picture0;
  SkillsDef.Lines.clear;
  SkillsDef.Lines.add(allPlayers[TeamChanged, PlayerChanged].getSkillString(-2));
  MANew.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].ma);
  STNew.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].st);
  AGNew.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].ag);
  AVNew.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].av);
  ValueNew.Text := InttoStr(allPlayers[TeamChanged, PlayerChanged].value);
  PNameNew.Text := allPlayers[TeamChanged, PlayerChanged].name;
  PNoNew.text := IntToStr(allPlayers[TeamChanged, PlayerChanged].cnumber);
  PositionNew.text := allPlayers[TeamChanged, PlayerChanged].position;
  IconNew.text := 'Yet to be Enabled';
  PictureNew.text := allPlayers[TeamChanged, PlayerChanged].picture;
  SkillsNew.Lines.clear;
  SkillsNew.Lines.add(allPlayers[TeamChanged, PlayerChanged].getSkillString(-1));
end;

procedure TfrmPlayerStatsChange.butResetClick(Sender: TObject);
var s: string;
begin
  if CanWriteToLog then begin
    s := 'u' + Chr(TeamChanged + 48) + Chr(PlayerChanged + 64) +
        Chr(allPlayers[TeamChanged, PlayerChanged].ma + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].st + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].ag + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].av + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].cnumber + 64) +
        Chr(allPlayers[TeamChanged, PlayerChanged].value div 5 + 48) +
        allPlayers[TeamChanged, PlayerChanged].name + '$' +
        allPlayers[TeamChanged, PlayerChanged].position + '$' +
        allPlayers[TeamChanged, PlayerChanged].picture + '$' +
        allPlayers[TeamChanged, PlayerChanged].icon + '$' +
        allPlayers[TeamChanged, PlayerChanged].GetSkillString(1) + '|' +
        Chr(allPlayers[TeamChanged, PlayerChanged].ma0 + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].st0 + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].ag0 + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].av0 + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].cnumber0 + 64) +
        Chr(allPlayers[TeamChanged, PlayerChanged].value0 div 5 + 48) +
        allPlayers[TeamChanged, PlayerChanged].name0 + '$' +
        allPlayers[TeamChanged, PlayerChanged].position0 + '$' +
        allPlayers[TeamChanged, PlayerChanged].picture0 + '$' +
        allPlayers[TeamChanged, PlayerChanged].icon0 + '$' +
        allPlayers[TeamChanged, PlayerChanged].GetSkillString(2);
    LogWrite(s);
    PlayActionPlayerStatChange(s, 1);
    frmPlayerStatsChange.Hide;
  end;
end;

procedure TfrmPlayerStatsChange.txtNumberExit(Sender: TObject);
var f, m: integer;
begin
  m := FVal(PNoNew.text);
  if (m < 1) or (m > 99) then begin
    ShowMessage('Number must be between 1 and 99.');
    PNoNew.SetFocus;
  end else begin
    for f := 1 to team[TeamChanged].numplayers do begin
      if (allPlayers[TeamChanged, f].cnumber = m)
       and (allPlayers[TeamChanged, f].status <> 11) then begin
        ShowMessage('That number is already being used!');
        PNoNew.SetFocus;
      end;
    end;
  end;
  PNoNew.text := IntToStr(m);
end;

procedure TfrmPlayerStatsChange.txtStatExit2(Sender: TObject);
var i: integer;
begin
  i := FVal((Sender as TEdit).text);
  if (i < 1) and (((Sender as TEdit).text)<>'0') then begin
    ShowMessage('You must fill in a numeric value!');
    (Sender as TEdit).SetFocus;
  end;
  (Sender as TEdit).text := IntToStr(i);
end;

procedure TfrmPlayerStatsChange.txtValueExit(Sender: TObject);
var v: integer;
begin
  v := FVal(ValueNew.text);
  if 5 * (v div 5) <> v then begin
    ShowMessage('Value must be a multiple of 5k');
    ValueNew.SetFocus;
  end;
  ValueNew.text := IntToStr(5 * (v div 5));
end;



procedure TfrmPlayerStatsChange.butSelectFileClick(Sender: TObject);
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
      PictureNew.text := s;
    end else begin
      ShowMessage('Pictures must be put in directory ' + curdir + 'roster');
    end;
  end;
end;

procedure TfrmPlayerStatsChange.butUseCurrentClick(Sender: TObject);
var i: integer;
    s, ls: string;
begin
  if CanWriteToLog then begin
    ls := 'u' + Chr(TeamChanged + 48) + Chr(PlayerChanged + 64) +
        Chr(allPlayers[TeamChanged, PlayerChanged].ma + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].st + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].ag + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].av + 48) +
        Chr(allPlayers[TeamChanged, PlayerChanged].cnumber + 64) +
        Chr(allPlayers[TeamChanged, PlayerChanged].value div 5 + 48) +
        allPlayers[TeamChanged, PlayerChanged].name + '$' +
        allPlayers[TeamChanged, PlayerChanged].position + '$' +
        allPlayers[TeamChanged, PlayerChanged].picture + '$' +
        allPlayers[TeamChanged, PlayerChanged].icon + '$' +
        allPlayers[TeamChanged, PlayerChanged].GetSkillString(1) + '|' +
        Chr(FVal(MANew.text) + 48) +
        Chr(FVal(STNew.text) + 48) +
        Chr(FVal(AGNew.text) + 48) +
        Chr(FVal(AVNew.text) + 48) +
        Chr(FVal(PNoNew.Text) + 64) +
        Chr(FVal(ValueNew.text) div 5 + 48) +
        PNameNew.text + '$' +
        PositionNew.text + '$' +
        PictureNew.text + '$' +
        IconNew.text + '$';
    s := '';
    for i := 0 to SkillsNew.lines.count - 1 do s := s + SkillsNew.Lines[i];
    allPlayers[TeamChanged, PlayerChanged].SetSkill(s, true);
    ls := ls + allPlayers[TeamChanged, PlayerChanged].GetSkillString(1);
    LogWrite(ls);
    PlayActionPlayerStatChange(ls, 1);
    frmPlayerStatsChange.Hide;
  end;
end;

end.
