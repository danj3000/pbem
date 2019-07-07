unit unitWelcome;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmWelcome = class(TForm)
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    ButStartNew: TButton;
    ButLoad: TButton;
    cbCoachName: TComboBox;
    Label4: TLabel;
    procedure ButStartNewClick(Sender: TObject);
    procedure ButLoadClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbCoachNameChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmWelcome: TfrmWelcome;

implementation

uses bbalg, bbunit, unitLog, unitCheckFile, unitExtern, unitSettings,
     unitRandom {Ronald added}, unitMessage, unitLanguage;

{$R *.DFM}

procedure CheckName;
begin
  if frmWelcome.cbCoachName.ItemIndex = -1 then begin
    AddCoachName(frmWelcome.cbCoachName.Text);
  end;
  LoggedCoach := frmWelcome.cbCoachName.Text;
end;

procedure TfrmWelcome.ButStartNewClick(Sender: TObject);
var dtNow: TDateTime;
    h, m, s, ms: Word;
    LRoll : integer;
begin
  CheckName;
  if Bloodbowl.Viewlog1.Checked then frmLog.Show;
  frmWelcome.Hide;
  dtNow := Now;
  InEditMode := true;
  DecodeTime(dtNow, h, m, s, ms);
  LogWrite(DateTimeToStr(dtNow) + '.' + IntToStr(ms) + ' by ' + LoggedCoach);
  for h := 1 to 9 do LogWrite('');
  RecordInRegistry(GetGameLog(0), GameLogLength);
  RLCoach[0] := '';
  RLCoach[1] := '';
  LRoll := Rnd(8,6)+3;
  LustrianRoll := 'W'+ InttoStr(LRoll);
  LustrianRoll2 := 'KO' + InttoStr(Lroll);
  frmSettings.ShowModal;
  frmSettings.BringToFront;
end;

procedure TfrmWelcome.ButLoadClick(Sender: TObject);
begin
  CheckName;
  if Bloodbowl.Viewlog1.Checked then frmLog.Show;
  Bloodbowl.Show;
  Bloodbowl.BringToFront;
  FormReset(false, false);
  Bloodbowl.LoadGame1Click(Bloodbowl);
  frmWelcome.Hide;
end;

procedure TfrmWelcome.FormCreate(Sender: TObject);
var f: integer;
begin
  ReadCoach;
  for f := 1 to Length(CoachNames) do begin
    cbCoachName.Items.Add(CoachNames[f-1]);
  end;
  if Length(CoachNames) > 0 then begin
    cbCoachName.ItemIndex := 0;
    butStartNew.Enabled := true;
    butLoad.Enabled := true;
  end;
end;

procedure TfrmWelcome.cbCoachNameChange(Sender: TObject);
begin
  butStartNew.Enabled := (cbCoachName.Text <> '');
  butLoad.Enabled := butStartNew.Enabled;
end;

end.
