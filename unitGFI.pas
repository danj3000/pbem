unit unitGFI;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmGFI = class(TForm)
    lblPlayer: TLabel;
    lblTriesToTxt: TLabel;
    lblRollNeeded: TLabel;
    butGFIRoll: TButton;
    butsurefeetSkill: TButton;
    butTeamReroll: TButton;
    butKnockDown: TButton;
    cbBlizzard: TCheckBox;
    txtGFIRollNeeded: TEdit;
    cbBigGuyAlly: TCheckBox;
    cbGFIInjury: TCheckBox;
    lblGFIFailed: TLabel;
    cbSprint: TCheckBox;
    butPro: TButton;
    procedure butGFIRollClick(Sender: TObject);
    procedure butsurefeetSkillClick(Sender: TObject);
    procedure butProClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butKnockDownClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbBlizzardClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmGFI: TfrmGFI;

procedure ShowGFIWindow(g, f: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitMarker, unitBall, unitPass, unitLog, 
     unitTeam, unitArmourRoll, unitSettings, unitPlayAction;

{$R *.DFM}

var TeamPlayer, NumberPlayer, GFIRollNeeded: integer;
    CanHide: boolean;

procedure CalculateGFIRollNeeded;
var r: integer;
begin
  r := 2;
  if frmGFI.cbBlizzard.checked then r := r + 1;
  if frmSettings.cbPGFI.checked then r := r + player[TeamPlayer,NumberPlayer].GFI;
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  GFIRollNeeded := r;

  frmGFI.txtGFIRollNeeded.text := IntToStr(r) + '+';
end;

procedure ShowGFIWindow(g, f: integer);
begin
  TeamPlayer := g;
  NumberPlayer := f;
  frmGFI.lblPlayer.caption := player[TeamPlayer,NumberPlayer].GetPlayerName;
  frmGFI.lblPlayer.font.color := colorarray[g,0,0];

  frmGFI.cbBlizzard.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) = 'BLIZZARD')
     and not ((player[g,f].hasSkill('Weather Immunity')) or
     (player[g,f].hasSkill('Cold Resistant'))) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 7)) = 'MONSOON') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 16)) = 'TORRENTIAL RAINS') and
    not (player[g,f].hasSkill('Weather Immunity'));

  frmGFI.cbGFIInjury.visible := frmSettings.cbGFIInjury.checked;
  frmGFI.cbGFIInjury.checked := (player[g,f].hasSkill('GFI Injury')) and
     (frmSettings.cbGFIInjury.checked);

  frmGFI.cbSprint.Visible := frmSettings.cbPGFI.checked;
  frmGFI.cbSprint.Checked := (frmSettings.cbPGFI.Checked) and
    (player[g,f].hasSkill('Sprint')) and (not(player[g,f].usedSkill('Sprint')));

  frmGFI.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (frmSettings.rgBGA4th.ItemIndex >= 1));

  CalculateGFIRollNeeded;

  frmGFI.butGFIRoll.enabled := true;
  frmGFI.height := 220;
  try
    frmGFI.ShowModal;
  except
    on EInvalidOperation do CanHide := false;
  end;
end;

function WorkOutGFIResult(i: integer): boolean;
var s: string;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll >= GFIRollNeeded then begin
    WorkOutGFIResult := true;
    if frmSettings.cbPGFI.checked then begin
      if CanWriteToLog then begin
        s := 'QP' + Chr(curteam + 48) + Chr(curplayer + 64);
        LogWrite(s);
        PlayActionPGFI(s, 1);
      end;
    end;
  end else if (lastroll+1 >= GFIRollNeeded) and (lastroll<>1) and
    (frmGFI.cbSprint.Checked) then begin
    player[TeamPlayer,NumberPlayer].UseSkill('Sprint');
    WorkOutGFIResult := true;
    if frmSettings.cbPGFI.checked then begin
      if CanWriteToLog then begin
        s := 'QP' + Chr(curteam + 48) + Chr(curplayer + 64);
        LogWrite(s);
        PlayActionPGFI(s, 1);
      end;
    end;
  end else begin
    if i = 0 then Bloodbowl.comment.text := 'GFI roll failed!'
             else Bloodbowl.comment.text := 'GFI RE-ROLL failed!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutGFIResult := false;
  end;
end;

procedure TfrmGFI.butGFIRollClick(Sender: TObject);
var s: string;
begin
  s := player[TeamPlayer, NumberPlayer].GetPlayerName +
         ' tries to Go For It (';
  if cbBlizzard.checked then s := s + 'Blizzard, ';
  s := s + txtGFIRollNeeded.text + ')';

  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);

  butGFIRoll.enabled := false;
  if WorkOutGFIResult(0) then begin
    ModalResult := 1;
    Hide;
  end else begin
    butSureFeetSkill.enabled :=
       player[TeamPlayer, NumberPlayer].hasSkill('Sure Feet') and
       not(player[TeamPlayer,NumberPlayer].usedSkill('Sure Feet'));
    butPro.enabled :=
       player[TeamPlayer, NumberPlayer].hasSkill('Pro') and
       not(player[TeamPlayer,NumberPlayer].usedSkill('Pro'));
    butTeamReroll.enabled := false;
    if (TeamPlayer = curmove) and CanUseTeamReroll(cbBigGuyAlly.checked)
      then butTeamReroll.enabled := true;
    height := 369;
  end;
end;

procedure MakeGFIReroll;
begin
  if WorkOutGFIResult(1) then begin
    frmGFI.ModalResult := 1;
    frmGFI.Hide;
  end else begin
    frmGFI.butPro.Enabled := false;
    frmGFI.butSureFeetSkill.enabled := false;
    frmGFI.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmGFI.butProClick(Sender: TObject);
begin
  player[TeamPlayer,NumberPlayer].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPlayer,NumberPlayer);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeGFIReroll;
  end else begin
    frmGFI.butPro.enabled := false;
    frmGFI.butSureFeetSkill.enabled := false;
    frmGFI.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmGFI.butsurefeetSkillClick(Sender: TObject);
begin
  player[TeamPlayer,NumberPlayer].UseSkill('Sure Feet');
  MakeGFIReroll;
end;

procedure TfrmGFI.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakeGFIReroll else begin
    frmGFI.butPro.Enabled := false;
    frmGFI.butSureFeetSkill.enabled := false;
    frmGFI.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmGFI.butKnockDownClick(Sender: TObject);
var v, w, ploc, qloc: integer;
    ballscatter: boolean;
begin
  frmGFI.ModalResult := 1;
  frmGFI.Hide;
  curteam := TeamPlayer;
  curplayer := NumberPlayer;
  Ballscatter := false;
  v := curteam;
  w := curplayer;
  if cbGFIInjury.checked then InjurySettings(v,w) else
    ArmourSettings(v,w,v,w,0);
  if player[v,w].status < InjuryStatus then begin
    if player[v,w].status=2 then begin
      ploc := player[v,w].p;
      qloc := player[v,w].q;
      player[v,w].SetStatus(InjuryStatus);
      BallScatter := true;
    end else player[v,w].SetStatus(InjuryStatus);
  end;
  InjuryStatus := 0;
  if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
end;

procedure TfrmGFI.FormCreate(Sender: TObject);
begin
  CanHide := true;
end;

procedure TfrmGFI.cbBlizzardClick(Sender: TObject);
begin
  CalculateGFIRollNeeded;
end;

end.