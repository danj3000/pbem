unit unitLanding;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmLanding = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    gbPass: TGroupBox;
    rgAccPassBB: TRadioGroup;
    lblPassFailed: TLabel;
    Label7: TLabel;
    butLandingRoll: TButton;
    butTeamReroll: TButton;
    butBounce: TButton;
    cbBigGuyAlly: TCheckBox;
    butProSkill: TButton;
    lblLandinger: TLabel;
    txtLandingerAG: TEdit;
    txtLandingerTZ: TEdit;
    txtLandingRollNeeded: TEdit;
    procedure LandingSkillClick(Sender: TObject);
    procedure rgAccPassBBClick(Sender: TObject);
    procedure butProSkillClick(Sender: TObject);
    procedure butLandingRollClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butBounceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLanding: TfrmLanding;

procedure ShowLandingWindow(g, f, p, q, acc: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitTeam, unitMarker, unitBall, unitLog, unitPass,
  unitSettings, unitArmourRoll;

{$R *.DFM}

var TeamLandinger, NumberLandinger, LandingRollNeeded, FieldP, FieldQ: integer;
    CanHide: boolean;

procedure CalculateLandingRollNeeded;
var r: integer;
begin
  r := 7 - player[TeamLandinger, NumberLandinger].ag;
  if frmLanding.rgAccPassBB.ItemIndex = 0 then r := r - 1;
  if frmLanding.rgAccPassBB.ItemIndex = 2 then r := r + 2;

  r := r + FVal(frmLanding.txtLandingerTZ.text);
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  LandingRollNeeded := r;

  frmLanding.txtLandingRollNeeded.text := IntToStr(r) + '+';
end;

procedure ShowLandingWindow(g, f, p, q, acc: integer);
var tz: TackleZones;
begin
  TeamLandinger := g;
  NumberLandinger := f;
  FieldP := p;
  FieldQ := q;
  frmLanding.lblLandinger.caption := player[g,f].GetPlayerName;
  frmLanding.lblLandinger.font.color := colorarray[g,0,0];
  if acc= 1 then frmLanding.rgAccPassBB.ItemIndex := 0
    else if acc=0 then frmLanding.rgAccPassBB.ItemIndex := 1
    else frmLanding.rgAccPassBB.ItemIndex := 2;
  frmLanding.txtLandingerAG.text := IntToStr(player[g,f].ag);
  tz := CountTZEmpty(g, p, q);
  frmLanding.txtLandingerTZ.text := IntToStr(tz.num);

  frmLanding.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (true));  // big guy

  CalculateLandingRollNeeded;

  frmLanding.butLandingRoll.enabled := true;
  frmLanding.height := 330;
  try
    frmLanding.ShowModal;
  except
    on EInvalidOperation do CanHide := false;
  end;
end;

function WorkOutLandingResult(i: integer): boolean;
var BallScat: boolean;
begin
  BallScat := false;
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll >= LandingRollNeeded then begin
    Bloodbowl.comment.text := 'Landing roll SUCCESS!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    if (FieldP=ball.p) and (FieldQ=ball.q) then BallScat := true;
    PlacePlayer(NumberLandinger, TeamLandinger, FieldP, FieldQ);
    if BallScat then ScatterBallFrom(FieldP, FieldQ, 1, 0);
    WorkOutLandingResult := true;
  end else begin
    if (i = 0)  and (frmLanding.rgAccPassBB.ItemIndex < 2)
        then Bloodbowl.comment.text := 'Landing roll failed!'
        else if (i <> 0) and (frmLanding.rgAccPassBB.ItemIndex < 2) then
          Bloodbowl.comment.text := 'Landing RE-ROLL failed!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutLandingResult := false;
  end;
end;

procedure TfrmLanding.rgAccPassBBClick(Sender: TObject);
begin
  CalculateLandingRollNeeded;
end;

procedure TfrmLanding.LandingSkillClick(Sender: TObject);
begin
  CalculateLandingRollNeeded;
end;

procedure TfrmLanding.butLandingRollClick(Sender: TObject);
var s: string;
begin
  s := player[TeamLandinger, NumberLandinger].GetPlayerName +
       ' tries to Land (';
  if rgAccPassBB.ItemIndex = 0 then s := s + 'Accurate Pass, '
          else s := s + 'Inaccurate Pass, ';

  if txtLandingerTZ.Text <> '0' then s := s + txtLandingerTZ.text + ' TZ, ';
  s := s + txtLandingRollNeeded.text + ')';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);

  butLandingRoll.enabled := false;
  if WorkOutLandingResult(0) then begin
    ModalResult := 1;
    Hide;
  end else begin
    butTeamReroll.enabled := false;
    if (TeamLandinger = activeTeam) and CanUseTeamReroll(cbBigGuyAlly.checked)
      then butTeamReroll.enabled := true;
    butProSkill.enabled := player[TeamLandinger, NumberLandinger].hasSkill('Pro')
      and (not (player[TeamLandinger,NumberLandinger].usedSkill('Pro')));
    height := 460;
    frmLanding.butBounce.enabled := true;
  end;
end;

procedure MakeLandingReroll;
begin
  if WorkOutLandingResult(1) then begin
    frmLanding.ModalResult := 1;
    frmLanding.Hide;
  end else begin
    frmLanding.butTeamReroll.enabled := false;
    frmLanding.butProSkill.enabled := false;
  end;
end;

procedure MakeFailedProLandingReroll;
begin
  frmLanding.butTeamReroll.enabled := false;
  frmLanding.butProSkill.enabled := false;
end;

procedure TfrmLanding.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakeLandingReroll else begin
    frmLanding.butTeamReroll.enabled := false;
    frmLanding.butProSkill.enabled := false;
  end;
end;

procedure TfrmLanding.butProSkillClick(Sender: TObject);
begin
  player[TeamLandinger,NumberLandinger].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamLandinger,NumberLandinger);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeLandingReroll;
  end else MakeFailedProLandingReroll;
end;

procedure TfrmLanding.butBounceClick(Sender: TObject);
var v, w, ploc, qloc: integer;
    ballscatter: boolean;
begin
  CanHide := true;
  if CanHide then begin
    ModalResult := 1;
    Hide;
  end;
  if (FieldP=ball.p) and (FieldQ=ball.q) then ballscatter := true;
  PlacePlayer(NumberLandinger, TeamLandinger, FieldP, FieldQ);
  curteam := TeamLandinger;
  curplayer := NumberLandinger;
  Ballscatter := false;
  v := curteam;
  w := curplayer;
  if frmLanding.rgAccPassBB.ItemIndex = 2 then AVBreak := true;
  ArmourSettings(v,w,v,w,0);
  if frmLanding.rgAccPassBB.ItemIndex = 2 then AVBreak := false;
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

procedure TfrmLanding.FormCreate(Sender: TObject);
begin
  CanHide := true;
end;

end.
