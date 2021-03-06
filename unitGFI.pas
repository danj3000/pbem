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
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  GFIRollNeeded := r;

  frmGFI.txtGFIRollNeeded.text := IntToStr(r) + '+';
end;

procedure ShowGFIWindow(g, f: integer);
begin
  TeamPlayer := g;
  NumberPlayer := f;
  frmGFI.lblPlayer.caption := allPlayers[TeamPlayer,NumberPlayer].GetPlayerName;
  frmGFI.lblPlayer.font.color := colorarray[g,0,0];

  frmGFI.cbBlizzard.checked := Bloodbowl.GetWeather() = TWeatherState.Blizzard;

  frmGFI.cbSprint.Visible := false;
  frmGFI.cbSprint.Checked := (false);

  frmGFI.cbBigGuyAlly.checked := (((allPlayers[g,f].BigGuy) or
      (allPlayers[g,f].Ally)) and (true));    // big guy

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
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll >= GFIRollNeeded then begin
    WorkOutGFIResult := true;

  end else if (lastroll+1 >= GFIRollNeeded) and (lastroll<>1) and
    (frmGFI.cbSprint.Checked) then begin
    allPlayers[TeamPlayer,NumberPlayer].UseSkill('Sprint');
    WorkOutGFIResult := true;
    
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
  s := allPlayers[TeamPlayer, NumberPlayer].GetPlayerName +
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
       allPlayers[TeamPlayer, NumberPlayer].hasSkill('Sure Feet') and
       not(allPlayers[TeamPlayer,NumberPlayer].usedSkill('Sure Feet'));
    butPro.enabled :=
       allPlayers[TeamPlayer, NumberPlayer].hasSkill('Pro') and
       not(allPlayers[TeamPlayer,NumberPlayer].usedSkill('Pro'));
    butTeamReroll.enabled := false;
    if (TeamPlayer = activeTeam) and CanUseTeamReroll(cbBigGuyAlly.checked)
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
  allPlayers[TeamPlayer,NumberPlayer].UseSkill('Pro');
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
  allPlayers[TeamPlayer,NumberPlayer].UseSkill('Sure Feet');
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

    ArmourSettings(v,w,v,w,0);
  if allPlayers[v,w].status < InjuryStatus then begin
    if allPlayers[v,w].status=2 then begin
      ploc := allPlayers[v,w].p;
      qloc := allPlayers[v,w].q;
      allPlayers[v,w].SetStatus(InjuryStatus);
      BallScatter := true;
    end else allPlayers[v,w].SetStatus(InjuryStatus);
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
