unit unitKick;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmKick = class(TForm)
    gbKick: TGroupBox;
    Label1: TLabel;
    txtKickTZ: TEdit;
    cbStrongLeg: TCheckBox;
    cbNervesOfSteel: TCheckBox;
    Label2: TLabel;
    lblKicker: TLabel;
    lblCatcher: TLabel;
    butKickRoll: TButton;
    butKickSkill: TButton;
    butTeamReroll: TButton;
    butFumbleInaccurate: TButton;
    lblKickFailed: TLabel;
    Label7: TLabel;
    txtKickRollNeeded: TEdit;
    Label6: TLabel;
    txtThrowerAG: TEdit;
    cbVerySunny: TCheckBox;
    Label3: TLabel;
    txtKickFA: TEdit;
    cbBigGuyAlly: TCheckBox;
    cbHFHead: TCheckBox;
    cbHookKick: TCheckBox;
    Label4: TLabel;
    txtDistanceNeeded: TEdit;
    cbPoochKick: TCheckBox;
    cbExtraLeg: TCheckBox;
    butProKick: TButton;
    butDistance: TButton;
    cbWideZone: TCheckBox;
    butDistanceTeamReroll: TButton;
    butDistancePro: TButton;
    Label8: TLabel;
    txtThrowerST: TEdit;
    cbFGAttempt: TCheckBox;
    Label5: TLabel;
    txtDistanceKicked: TEdit;
    procedure KickSkillClick(Sender: TObject);
    procedure FGAttemptClick(Sender: TObject);
    procedure PoochKickClick(Sender: TObject);
    procedure butKickRollClick(Sender: TObject);
    procedure butKickSkillClick(Sender: TObject);
    procedure butKickReRollClick(Sender: TObject);
    procedure butProKickRerollClick(Sender: TObject);
    procedure butFumbleInaccurateClick(Sender: TObject);
    procedure butDistanceRollClick(Sender: TObject);
    procedure butDistanceRollReRollClick(Sender: TObject);
    procedure butDistanceRollProClick(Sender: TObject);
    
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmKick: TfrmKick;

procedure ShowKickToField(g, f, p, q: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitMarker, unitBall, unitLog, unitCatch,
     unitRandom, unitTeam, unitSettings, unitPass, unitField;

{$R *.DFM}

var KickRollNeeded, KickRollMod, TeamKicker, NumberKicker,
    FieldP, FieldQ, KickDistNeeded,
    KickP, KickQ, PaintDist: integer;

procedure CalculateKickRollNeeded;
var r, m: integer;
begin
  m := 0;
  r := 7 - FVal(frmKick.txtThrowerAG.text);
  if frmKick.cbFGAttempt.checked then m := m - 1;
  if frmKick.cbExtraLeg.checked then m := m + 1;
  if frmKick.cbVerySunny.checked then m := m - 1;
  if frmKick.cbHFHead.checked then m := m - 2;
  if (frmKick.cbWideZone.checked) and not(frmKick.cbHookKick.checked) then
    m := m - 1;
  if not(frmKick.cbNervesOfSteel.checked) then
      m := m - FVal(frmKick.txtKickTZ.text);
  m := m - FVal(frmKick.txtKickFA.text);
  KickRollNeeded := r - m;
  KickRollMod := m;
  if KickRollNeeded < 2 then KickRollNeeded := 2;
  if KickRollNeeded > 6 then KickRollNeeded := 6;
  frmKick.txtKickRollNeeded.text := IntToStr(KickRollNeeded) + '+';

  frmKick.butKickRoll.enabled := true;
end;

procedure ShowKick(g, f: integer);
{(g,f) Kicks}
var tz: TackleZones;
    dist1, dist2, dist3, qplace, pplace, NewP2, NewQ2, NewP3, NewQ3, f0, g0,
      PaintP, PaintQ, StartP, StartQ, EndP, EndQ: integer;
    CouldKick: boolean;

begin
  TeamKicker := g;
  NumberKicker := f;
  frmKick.Height := 345;

  if frmSettings.cbNoFieldGoals.checked then begin
    frmKick.cbFGAttempt.Checked := false;
    frmKick.cbFGAttempt.Visible := false;
    frmKick.cbWideZone.checked := false;
    frmKick.cbWideZone.Visible := false;
    frmKick.cbHookKick.Visible := false;
    frmKick.cbHookKick.Checked := false;
    frmKick.Label4.Visible := false;
    frmKick.txtDistanceNeeded.Visible := false;
  end;
  frmKick.gbKick.enabled := true;
  frmKick.lblKicker.caption := player[g,f].GetPlayerName;
  frmKick.lblKicker.font.color := colorarray[g,0,0];
  frmKick.txtThrowerAG.text := IntToStr(player[g,f].ag);
  frmKick.txtThrowerST.text := IntToStr(player[g,f].st);
  tz := CountTZ(g, f);
  frmKick.txtKickTZ.text := IntToStr(tz.num);
  frmKick.txtKickFA.text := IntToStr(CountFA(g, f));
  if g=0 then begin
    dist1 := 26-player[g,f].q;
    if player[g,f].p < 7 then dist2 := 6 - player[g,f].p + 1 else
       dist2 := player[g,f].p - 7;
  end else begin
    dist1 := player[g,f].q+1;
    if player[g,f].p < 7 then dist2 := 6 - player[g,f].p + 1 else
       dist2 := player[g,f].p - 7;
  end;
  if dist1 >= dist2 then dist3 := dist1 else dist3 := dist2;
  KickDistNeeded := dist3;
  frmKick.txtDistanceNeeded.text := IntToStr(dist3);
  frmKick.cbStrongLeg.checked := player[g,f].hasSkill('Strong Leg');
  frmKick.cbExtraLeg.checked := player[g,f].hasSkill('Extra Leg');
  frmKick.cbHookKick.checked := player[g,f].hasSkill('Hook Kick');
  frmKick.cbNervesOfSteel.checked := player[g,f].hasSkill('Nerves of Steel');
  {frmKick.cbPoochKick.checked := player[g,f].hasSkill('Pooch Kick');}
  frmKick.cbHFHead.checked := player[g,f].hasSkill('House Fly Head');
  frmKick.cbWideZone.checked := ((player[g,f].p <= 3) or (player[g,f].p >= 11))
    and (frmKick.cbFGAttempt.Checked);
  if not (frmSettings.cbHouseFlyHead.checked) then begin
    frmKick.cbHFHead.Checked := false;
    frmKick.cbHFHead.Visible := false;
  end;
  frmKick.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (true)); // big guy

  frmKick.cbVerySunny.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) = 'VERY SUNNY') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 3)) = 'FOG') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) = 'BLUSTERY') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 14)) = 'MOONLESS NIGHT') and
    not (player[g,f].hasSkill('Weather Immunity'));

  for g0 := 0 to 14 do begin
    for f0 := 0 to 25 do begin
      KickField[g0,f0] := 0;
    end;
  end;
  pplace := FieldP - player[TeamKicker,NumberKicker].p;
  qplace := FieldQ - player[TeamKicker,NumberKicker].q;
  if (qplace = 0) and (pplace = -1) then begin
    NewP2 := -1;
    NewQ2 := -1;
    NewP3 := -1;
    NewQ3 := 1;
  end else if (qplace = 0) and (pplace = 1) then begin
    NewP2 := 1;
    NewQ2 := 1;
    NewP3 := 1;
    NewQ3 := -1;
  end else if (qplace = 1) and (pplace = 0) then begin
    NewP2 := -1;
    NewQ2 := 1;
    NewP3 := 1;
    NewQ3 := 1;
  end else if (qplace = -1) and (pplace = 0) then begin
    NewP2 := 1;
    NewQ2 := -1;
    NewP3 := -1;
    NewQ3 := -1;
  end else if (qplace = 1) and (pplace = -1) then begin
    NewP2 := -1;
    NewQ2 := 0;
    NewP3 := 0;
    NewQ3 := 1;
  end else if (qplace = 1) and (pplace = 1) then begin
    NewP2 := 0;
    NewQ2 := 1;
    NewP3 := 1;
    NewQ3 := 0;
  end else if (qplace = -1) and (pplace = 1) then begin
    NewP2 := 1;
    NewQ2 := 0;
    NewP3 := 0;
    NewQ3 := -1;
  end else if (qplace = -1) and (pplace = -1) then begin
    NewP2 := 0;
    NewQ2 := -1;
    NewP3 := -1;
    NewQ3 := 0;
  end;
  if player[TeamKicker,NumberKicker].hasSkill('Strong Leg') then
    PaintDist := 6 + player[TeamKicker,NumberKicker].st +
      player[TeamKicker,NumberKicker].st
    else PaintDist := 6 + player[TeamKicker,NumberKicker].st;
  if (qplace = 0) then begin
    for g0:= 1 to PaintDist do begin
      for f0:= (g0 * (-1)) to g0 do begin
        PaintP := player[TeamKicker,NumberKicker].p + (NewP2 * g0);
        PaintQ := player[TeamKicker,NumberKicker].q + f0;
        if PaintP < 0 then PaintP := 0;
        if PaintP > 14 then PaintP := 14;
        if PaintQ < 0 then PaintQ := 0;
        if PaintQ > 25 then PaintQ := 25;
        KickField[PaintP, PaintQ] := 1;
      end;
    end;
  end else if (pplace = 0) then begin
    for g0:= 1 to PaintDist do begin
      for f0:= (g0 * (-1)) to g0 do begin
        PaintP := player[TeamKicker,NumberKicker].p + f0;
        PaintQ := player[TeamKicker,NumberKicker].q + (NewQ2 * g0);
        if PaintP < 0 then PaintP := 0;
        if PaintP > 14 then PaintP := 14;
        if PaintQ < 0 then PaintQ := 0;
        if PaintQ > 25 then PaintQ := 25;
        KickField[PaintP, PaintQ] := 1;
      end;
    end;
  end else begin
    if (NewP2 = -1) or (NewP3 = -1) then begin
      StartP := 0;
      EndP := player[TeamKicker,NumberKicker].p;
    end;
    if (NewP2 = 1) or (NewP3 = 1) then begin
      StartP := player[TeamKicker,NumberKicker].p;
      EndP := 14;
    end;
    if (NewQ2 = -1) or (NewQ3 = -1) then begin
      StartQ := 0;
      EndQ := player[TeamKicker,NumberKicker].q;
    end;
    if (NewQ2= 1) or (NewQ3 = 1) then begin
      StartQ := player[TeamKicker,NumberKicker].q;
      EndQ := 25;
    end;
    for g0 := StartP to EndP do begin
      for f0 := StartQ to EndQ do begin
        if (player[TeamKicker,NumberKicker].p<>g0) or
           (player[TeamKicker,NumberKicker].q<>f0) then
          KickField[g0,f0] := 1;
      end;
    end;
  end;
  CouldKick := false;
  for g0 := 0 to 14 do begin
    for f0 := 0 to 25 do begin
      if (PaintDist>=KickDistNeeded) and (TeamKicker=1) and (f0=0) and
        (g0>=6) and (g0<=8) and (KickField[g0,f0]=1) then CouldKick := true
      else if (PaintDist>=KickDistNeeded) and (TeamKicker=0) and (f0=25) and
        (g0>=6) and (g0<=8) and (KickField[g0,f0]=1) then CouldKick := true;
    end;
  end;
  if not(CouldKick) then begin
    frmKick.cbFGAttempt.Checked := false;
    frmKick.cbWideZone.checked := false;
    frmKick.cbWideZone.Visible := false;
    frmKick.cbPoochKick.Visible := true;
  end else begin
    frmKick.cbFGAttempt.Checked := true;
    frmKick.cbWideZone.Visible := true;
    frmKick.cbPoochKick.Visible := false;
  end;

  CalculateKickRollNeeded;

  frmKick.ShowModal;
end;

procedure DetermineInterceptors(g, f, p, q: integer);
var h, pplace, qplace: integer;
    s: string;
    intercept: boolean;
begin
  s := '';
  for h := 1 to team[1-g].numplayers do begin
    {check if player is on field and standing}
    intercept := false;
    if player[1-g,h].status = 1 then begin
      pplace := p - player[g,f].p;
      qplace := q - player[g,f].q;
      if ((qplace = 0) and (pplace = -1)) or
         ((qplace = 0) and (pplace = 1)) then begin
        intercept := ((player[1-g,h].p = p) and (player[1-g,h].q + 1 = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q - 1 = q));
      end else if ((qplace = 1) and (pplace = 0)) or
        ((qplace = -1) and (pplace = 0)) then begin
        intercept := ((player[1-g,h].p + 1 = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p - 1 = p) and (player[1-g,h].q = q));
      end else if (qplace = 1) and (pplace = -1) then begin
        intercept := ((player[1-g,h].p = p) and (player[1-g,h].q + 1 = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p - 1 = p) and (player[1-g,h].q = q));
      end else if (qplace = 1) and (pplace = 1) then begin
        intercept := ((player[1-g,h].p + 1 = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q + 1 = q));
      end else if (qplace = -1) and (pplace = 1) then begin
        intercept := ((player[1-g,h].p + 1 = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q - 1 = q));
      end else if (qplace = -1) and (pplace = -1) then begin
        intercept := ((player[1-g,h].p - 1 = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q = q)) or
          ((player[1-g,h].p = p) and (player[1-g,h].q - 1 = q));
      end;
      if intercept then begin
          if s <> '' then s := s + ', ';
          s := s + '#' + IntToStr(player[1-g,h].cnumber);
      end;
    end;
  end;
  if s <> '' then begin
    Bloodbowl.comment.text := 'The kick can be intercepted by: ' + s;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
end;

procedure TfrmKick.FGAttemptClick(Sender: TObject);
var f, g: integer;
    CouldKick: boolean;
begin
  if frmKick.cbFGAttempt.Checked then begin
    frmKick.cbWideZone.Visible := true;
    frmKick.cbWideZone.checked := (player[TeamKicker,NumberKicker].p <= 3) or
      (player[TeamKicker,NumberKicker].p >= 11);
    frmKick.cbPoochKick.checked := false;
    frmKick.cbPoochKick.Visible := false;
    CouldKick := false;
    for g := 0 to 14 do begin
      for f := 0 to 25 do begin
        if (PaintDist>=KickDistNeeded) and (TeamKicker=1) and (f=0) and
          (g>=6) and (g<=8) and (KickField[g,f]=1) then CouldKick := true
        else if (PaintDist>=KickDistNeeded) and (TeamKicker=0) and (f=25) and
          (g>=6) and (g<=8) and (KickField[g,f]=1) then CouldKick := true;
      end;
    end;
    if not(CouldKick) then begin
      frmKick.cbFGAttempt.Checked := false;
      frmKick.cbWideZone.checked := false;
      frmKick.cbWideZone.Visible := false;
      frmKick.cbPoochKick.Visible := true;
    end;
  end else begin
    frmKick.cbWideZone.checked := false;
    frmKick.cbWideZone.Visible := false;
    frmKick.cbPoochKick.Visible := true;
  end;
  CalculateKickRollNeeded;
end;

procedure ShowKickToField(g, f, p, q: integer);
{(g,f) kicks to (p,q)}
begin
  FieldP := p;
  FieldQ := q;
  frmKick.lblCatcher.caption := 'Field position ' + Chr(65+q) + IntToStr(p+1);
  frmKick.lblCatcher.font.color := clPurple;
  DetermineInterceptors(g,f,p,q);
  KickP := player[g,f].p;
  KickQ := player[g,f].q;
  KickDist := 0;
  frmKick.butFumbleInaccurate.caption := 'Kick Accurate kick';
  frmKick.cbPoochKick.checked := false;
  frmKick.txtDistanceKicked.text := ' ';
  frmKick.cbWideZone.visible := false;
  frmKick.lblKickFailed.visible := true;
  frmKick.cbFGAttempt.Checked := true;
  frmKick.cbWideZone.Visible := true;
  frmKick.cbWideZone.checked := (player[TeamKicker,NumberKicker].p <= 3) or
    (player[TeamKicker,NumberKicker].p >= 11);
  frmKick.cbPoochKick.checked := false;
  frmKick.cbPoochKick.Visible := false;
  ShowKick(g,f);
end;

procedure TfrmKick.KickSkillClick(Sender: TObject);
begin
  CalculateKickRollNeeded;
end;

procedure TfrmKick.PoochKickClick(Sender: TObject);
begin
  if not(player[TeamKicker,NumberKicker].hasSkill('Pooch Kick')) then
    frmKick.cbPoochKick.checked := false;
  if frmKick.cbPoochKick.Checked then begin
    frmKick.cbWideZone.checked := false;
    frmKick.cbWideZone.Visible := false;
    frmKick.cbFGAttempt.checked := false;
    frmKick.cbFGAttempt.Visible := false;
  end else begin
    frmKick.cbWideZone.Visible := false;
    frmKick.cbWideZone.checked := false;
    frmKick.cbFGAttempt.Visible := true;
  end;
  CalculateKickRollNeeded;
end;

function WorkOutKickResult: boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if (lastroll >= KickRollNeeded) and (lastroll <> 1) then begin
    Bloodbowl.comment.text := 'Kick is accurate';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutKickResult := true;
    frmKick.butFumbleInaccurate.caption := 'Kick Accurate kick';

  end else begin
    if (lastroll + KickRollMod <= 1) or (lastroll = 1)  then begin
      Bloodbowl.comment.text := 'Kick is fumbled!';
      frmKick.butFumbleInaccurate.caption := 'Fumble';

    end else begin
      Bloodbowl.comment.text := 'Kick is shanked!';
      frmKick.butFumbleInaccurate.caption := 'Kick shanked kick';
    end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutKickResult := false;
  end;
end;

procedure TfrmKick.butKickRollClick(Sender: TObject);
var s: string;
    KickResult: boolean;
begin
  s := lblKicker.caption + ' kicks to ' + lblCatcher.caption + '(';
  if cbWideZone.checked then s := s + 'from Wide Zone with: ';
  if cbExtraLeg.checked then s := s + 'Extra Leg, ';
  if cbStrongLeg.checked then s := s + 'Strong Leg, ';
  if cbHookKick.checked then s := s + 'Hook Kick, ';
  if cbPoochKick.checked then s := s + 'Pooch Kick, ';
  if cbHFHead.checked then s := s + 'House Fly Head, ';
  if cbNervesOfSteel.checked then s := s + 'Nerves of Steel, ' else
   if txtKickTZ.text <> '0' then s := s + txtKickTZ.text + ' TZ, ';
  if txtKickFA.text <> '0' then s := s + txtKickFA.text + ' FA, ';
  if cbVerySunny.checked then s := s + 'Very Sunny, ';
  s := s + txtKickRollNeeded.text + ')';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  KickResult := WorkOutKickResult;
  if (KickResult) then begin
    lblKickFailed.visible := false;
    butKickRoll.enabled := false;
    butKickSkill.enabled := false;
    butTeamReRoll.enabled := false;
    butProKick.enabled := false;
    butDistance.enabled := true;
    butDistanceTeamReroll.enabled := false;
    butDistancePro.enabled := false;
    butFumbleInaccurate.Enabled := false;
    frmKick.height := 505;
  end else begin
    butKickRoll.enabled := false;
    butKickSkill.enabled := player[TeamKicker,NumberKicker].hasSkill('Kick')
       and (not (player[TeamKicker,NumberKicker].usedSkill('Kick')));
    butTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
    butProKick.enabled := (player[TeamKicker,NumberKicker].hasSkill('Pro'))
      and (not (player[TeamKicker,NumberKicker].usedSkill('Pro')));
    if butFumbleInaccurate.caption = 'Fumble' then begin
      butDistance.enabled := false;
      butDistanceTeamReroll.enabled := false;
      butDistancePro.enabled := false;
      butFumbleInaccurate.Enabled := true;
      frmKick.height := 505;
    end else begin
      butDistance.enabled := true;
      butDistanceTeamReroll.enabled := false;
      butDistancePro.enabled := false;
      butFumbleInaccurate.Enabled := false;
      frmKick.height := 505;
    end;
  end;
end;

procedure MakeKickReroll;
var KickResult: boolean;
begin
  KickResult := WorkOutKickResult;
  if (KickResult) then begin
    frmKick.lblKickFailed.visible := false;
    frmKick.butKickRoll.enabled := false;
    frmKick.butKickSkill.enabled := false;
    frmKick.butTeamReroll.enabled := false;
    frmKick.butProKick.enabled := false;
    frmKick.butDistance.enabled := true;
    frmKick.butDistanceTeamReroll.enabled := false;
    frmKick.butDistancePro.enabled := false;
    frmKick.butFumbleInaccurate.Enabled := false;
    GameStatus := 'Kick';
  end else begin
    if frmKick.butFumbleInaccurate.caption = 'Fumble' then begin
      frmKick.butKickRoll.enabled := false;
      frmKick.butKickSkill.enabled := false;
      frmKick.butTeamReroll.enabled := false;
      frmKick.butProKick.enabled := false;
      frmKick.butDistance.enabled := false;
      frmKick.butDistanceTeamReroll.enabled := false;
      frmKick.butDistancePro.enabled := false;
      frmKick.butFumbleInaccurate.Enabled := true;
    end else begin
      frmKick.butKickRoll.enabled := false;
      frmKick.butKickSkill.enabled := false;
      frmKick.butTeamReroll.enabled := false;
      frmKick.butProKick.enabled := false;
      frmKick.butDistance.enabled := true;
      frmKick.butDistanceTeamReroll.enabled := false;
      frmKick.butDistancePro.enabled := false;
      frmKick.butFumbleInaccurate.Enabled := false;
    end;
  end;
end;

procedure TfrmKick.butKickSkillClick(Sender: TObject);
begin
  player[TeamKicker,NumberKicker].UseSkill('Kick');
  MakeKickReroll;
end;

procedure TfrmKick.butKickRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakeKickReroll else begin
    if frmKick.butFumbleInaccurate.caption = 'Fumble' then begin
      frmKick.butKickRoll.enabled := false;
      frmKick.butKickSkill.enabled := false;
      frmKick.butTeamReroll.enabled := false;
      frmKick.butProKick.enabled := false;
      frmKick.butDistance.enabled := false;
      frmKick.butDistanceTeamReroll.enabled := false;
      frmKick.butDistancePro.enabled := false;
      frmKick.butFumbleInaccurate.Enabled := true;
    end else begin
      frmKick.butKickRoll.enabled := false;
      frmKick.butKickSkill.enabled := false;
      frmKick.butTeamReroll.enabled := false;
      frmKick.butProKick.enabled := false;
      frmKick.butDistance.enabled := true;
      frmKick.butDistanceTeamReroll.enabled := false;
      frmKick.butDistancePro.enabled := false;
      frmKick.butFumbleInaccurate.Enabled := false;
    end;
  end;
end;

procedure TfrmKick.butDistanceRollClick(Sender: TObject);
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if player[TeamKicker,NumberKicker].hasSkill('Strong Leg')
    then KickDist := lastroll + player[TeamKicker, NumberKicker].st +
       player[TeamKicker, NumberKicker].st else
       KickDist := lastroll + player[TeamKicker, NumberKicker].st;
  if frmKick.butFumbleInaccurate.caption = 'Kick shanked kick' then
    KickDist := KickDist div 2;
  frmKick.txtDistanceKicked.text := IntToStr(KickDist);
  frmKick.butDistanceTeamReroll.enabled :=
    CanUseTeamReroll(frmKick.cbBigGuyAlly.checked);
  frmKick.butDistancePro.enabled := (player[TeamKicker,NumberKicker].hasSkill('Pro'))
      and (not (player[TeamKicker,NumberKicker].usedSkill('Pro')));
  frmKick.butDistance.enabled := false;
  frmKick.butKickSkill.enabled := false;
  frmKick.butTeamReroll.Enabled := false;
  frmKick.butProKick.Enabled := false;
  frmKick.butFumbleInaccurate.enabled := true;
  if (KickDist >=  KickDistNeeded) and (frmKick.butFumbleInaccurate.caption =
    'Kick Accurate kick') and (frmKick.cbFGAttempt.checked) then begin
    frmKick.butFumbleInaccurate.caption := 'Kick Field Goal';
    frmKick.butDistanceTeamReroll.enabled := false;
    frmKick.butDistancePro.enabled := false;
  end;
end;

procedure TfrmKick.butDistanceRollReRollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if player[TeamKicker,NumberKicker].hasSkill('Strong Leg')
    then KickDist := lastroll + player[TeamKicker, NumberKicker].st +
       player[TeamKicker, NumberKicker].st else
       KickDist := lastroll + player[TeamKicker, NumberKicker].st;
  if frmKick.butFumbleInaccurate.caption = 'Kick shanked kick' then
    KickDist := KickDist div 2;
  frmKick.txtDistanceKicked.text := IntToStr(KickDist);
  frmKick.butDistance.enabled := false;
  frmKick.butDistanceTeamReroll.enabled := false;
  frmKick.butDistancePro.Enabled := false;
  frmKick.butFumbleInaccurate.enabled := true;
  if (KickDist >=  KickDistNeeded) and (frmKick.butFumbleInaccurate.caption =
    'Kick Accurate kick') and (frmKick.cbFGAttempt.checked) then begin
    frmKick.butFumbleInaccurate.caption := 'Kick Field Goal';
    frmKick.butDistanceTeamReroll.enabled := false;
    frmKick.butDistancePro.enabled := false;
  end;
end;

procedure TfrmKick.butDistanceRollProClick(Sender: TObject);
begin
  player[TeamKicker,NumberKicker].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamKicker,NumberKicker);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    if player[TeamKicker,NumberKicker].hasSkill('Strong Leg')
      then KickDist := lastroll + player[TeamKicker, NumberKicker].st +
         player[TeamKicker, NumberKicker].st else
         KickDist := lastroll + player[TeamKicker, NumberKicker].st;
    if frmKick.butFumbleInaccurate.caption = 'Kick shanked kick' then
      KickDist := KickDist div 2;
    frmKick.txtDistanceKicked.text := IntToStr(KickDist);
  end;
  frmKick.butDistance.enabled := false;
  frmKick.butDistanceTeamReroll.enabled := false;
  frmKick.butDistancePro.Enabled := false;
  frmKick.butFumbleInaccurate.enabled := true;
  if (KickDist >=  KickDistNeeded) and (frmKick.butFumbleInaccurate.caption =
    'Kick Accurate kick') and (frmKick.cbFGAttempt.checked) then begin
    frmKick.butFumbleInaccurate.caption := 'Kick Field Goal';
    frmKick.butDistanceTeamReroll.enabled := false;
    frmKick.butDistancePro.enabled := false;
  end;
end;

procedure TfrmKick.butProKickRerollClick(Sender: TObject);
begin
  player[TeamKicker,NumberKicker].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamKicker,NumberKicker);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeKickReroll;
  end else begin
    if butFumbleInaccurate.caption = 'Fumble' then begin
      frmKick.butKickRoll.enabled := false;
      frmKick.butKickSkill.enabled := false;
      frmKick.butTeamReroll.enabled := false;
      frmKick.butProKick.enabled := false;
      frmKick.butDistance.enabled := false;
      frmKick.butDistanceTeamReroll.enabled := false;
      frmKick.butDistancePro.enabled := false;
      frmKick.butFumbleInaccurate.Enabled := true;
    end else begin
      frmKick.butKickRoll.enabled := false;
      frmKick.butKickSkill.enabled := false;
      frmKick.butTeamReroll.enabled := false;
      frmKick.butProKick.enabled := false;
      frmKick.butDistance.enabled := true;
      frmKick.butDistanceTeamReroll.enabled := false;
      frmKick.butDistancePro.enabled := false;
      frmKick.butFumbleInaccurate.Enabled := false;
    end;
  end;
end;

procedure TfrmKick.butFumbleInaccurateClick(Sender: TObject);
  var arrowp, arrowq, pplace, qplace, lastp, lastq, scat, g, f, g0, f0,
        dist1, dist2, finaldist: integer;
      oob, catchit: boolean;
      s: string;
begin
  Bloodbowl.comment.text := 'Ball was kicked '+InttoStr(KickDist)+' squares';
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  ClearBall;
  if butFumbleInaccurate.caption = 'Kick Field Goal' then begin
    ModalResult := 1;
    if CanWriteToLog then begin
      if frmSettings.cbFG1PT.checked then begin
        player[TeamKicker, NumberKicker].td :=
          player[TeamKicker, NumberKicker].td + 1;
        LogWrite('p' + Chr(TeamKicker + 48) + chr(NumberKicker + 65) + 'T');
      end else begin
        player[TeamKicker, NumberKicker].int :=
          player[TeamKicker, NumberKicker].int + 1;
        LogWrite('p' + Chr(TeamKicker + 48) + chr(NumberKicker + 65) + 'I');
      end;
      AddLog('Field Goal for ' +
        player[TeamKicker, NumberKicker].GetPlayerName);
      {increase score marker}
      marker[TeamKicker, MT_Score].MarkerMouseUp(
        marker[curteam, MT_Score], mbLeft, [], 0, 0);
      if not(frmSettings.cbFG1PT.Checked) then
         marker[TeamKicker, MT_Score].MarkerMouseUp(
           marker[TeamKicker, MT_Score], mbLeft, [], 0, 0);
      GameStatus := 'Field Goal';
    end;

  end else
  if butFumbleInaccurate.caption = 'Kick Accurate kick' then begin
    ModalResult := 1;
    for g := 0 to 14 do begin
      for f := 0 to 25 do begin
        dist1 := abs(player[TeamKicker,NumberKicker].p - g);
        dist2 := abs(player[TeamKicker,NumberKicker].q - f);
        if dist1 >= dist2 then finaldist := dist1 else finaldist := dist2;
        if (finaldist<KickDist) and ((g=0) or (g=14) or (f=0) or (f=25))
          then finaldist := KickDist;
        if ((KickField[g,f] = 1) and (finaldist = KickDist) and
          not(frmKick.cbPoochKick.Checked)) or ((KickField[g,f] = 1) and
          (finaldist <= KickDist) and (frmKick.cbPoochKick.Checked))
          then begin
          field[g,f].color := clYellow;
          field[g,f].transparent := false;
          KickField[g,f] := 2;
        end;
      end;
    end;
    GameStatus := 'AccurateKick';
    if frmKick.cbPoochKick.checked then GameStatus := 'PoochKick';
    ActionTeam := TeamKicker;
    ActionPlayer := NumberKicker;

  end else
  if butFumbleInaccurate.caption = 'Fumble' then begin
    ModalResult := 1;
    ScatterBallFrom(player[TeamKicker, NumberKicker].p,
                    player[TeamKicker, NumberKicker].q, 1, 0);
  end else begin
     ModalResult := 1;
     oob := false;
     Bloodbowl.comment.text := 'Shank Direction Roll - Distance: '+
       InttoStr(KickDist);
     Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
     Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
     pplace := FieldP - KickP;
     qplace := FieldQ - KickQ;
     if ((pplace = -1) and (qplace = 0) and (lastroll <=3)) or
        ((pplace = 0)  and (qplace = -1) and (lastroll >=4)) then begin
          arrowp := -1;
          arrowq := -1;
     end else
       if ((pplace = -1) and (qplace = 1) and (lastroll <=3)) or
          ((pplace = -1)  and (qplace = -1) and (lastroll >=4)) then begin
            arrowp := -1;
            arrowq := 0;
       end else
       if ((pplace = 0) and (qplace = 1) and (lastroll <=3)) or
          ((pplace = -1)  and (qplace = 0) and (lastroll >=4)) then begin
            arrowp := -1;
            arrowq := 1;
       end else
       if ((pplace = 1) and (qplace = 1) and (lastroll <=3)) or
          ((pplace = -1)  and (qplace = 1) and (lastroll >=4)) then begin
            arrowp := 0;
            arrowq := 1;
       end else
       if ((pplace = 1) and (qplace = 0) and (lastroll <=3)) or
          ((pplace = 0)  and (qplace = 1) and (lastroll >=4)) then begin
            arrowp := 1;
            arrowq := 1;
       end else
       if ((pplace = 1) and (qplace = -1) and (lastroll <=3)) or
          ((pplace = 1)  and (qplace = 1) and (lastroll >=4)) then begin
            arrowp := 1;
            arrowq := 0;
       end else
       if ((pplace = 0) and (qplace = -1) and (lastroll <=3)) or
          ((pplace = 1)  and (qplace = 0) and (lastroll >=4)) then begin
            arrowp := 1;
            arrowq := -1;
       end else
       if ((pplace = -1) and (qplace = -1) and (lastroll <=3)) or
          ((pplace = 1)  and (qplace = -1) and (lastroll >=4)) then begin
            arrowp := 0;
            arrowq := -1;
       end;
     scat := 0;
     while (scat < KickDist) and not (oob) do begin
       LastP := KickP;
       LastQ := KickQ;
       KickP := KickP + arrowp;
       KickQ := KickQ + arrowq;
       if (KickP < 0) or (KickP > 14) or (KickQ < 0) or (KickQ > 25) then
         oob := true;
       scat := scat + 1;
     end;
     CatchIt := false;
     if not (oob) then begin
       s := 'Shanked Kick lands in ' + Chr(KickQ+65) + InttoStr(KickP+1);
       Bloodbowl.comment.text := s;
       Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
       {but first see if a player can catch the ball}
       for g := 0 to 1 do begin
         for f := 1 to team[g].numplayers do begin
           if (player[g,f].p = Kickp) and (player[g,f].q = Kickq) then begin
             if player[g,f].status < 3 then begin
               Catchit := true;
               Bloodbowl.comment.text := player[g,f].GetPlayerName +
                   ' can catch the ball';
               Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
               ShowCatchWindow(g, f, 0, false, false);
             end else begin
               Bloodbowl.comment.text := 'Ball bounces on ' +
                   player[g,f].GetPlayerName;
               Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             end;
           end;
         end;
       end;
       if not(CatchIt) and (frmSettings.cbDC.Checked) then begin
         CatchIt := DetermineDivingCatch(KickP,KickQ,0,0);
       end;
       if not(CatchIt) then ScatterBallFrom(KickP, KickQ, 1, 0);
     end else begin
       if ((KickQ < 0) and (LastP>=6) and (LastP<=8) and
         (TeamKicker=1) and (frmKick.cbFGAttempt.checked)) or
         ((KickQ > 25) and (LastP>=6) and (LastP<=8) and
         (TeamKicker=0) and (frmKick.cbFGAttempt.checked)) then begin
           if CanWriteToLog then begin
             if not(frmSettings.cbFG1PT.checked) then begin
               player[TeamKicker, NumberKicker].int :=
                  player[TeamKicker, NumberKicker].int + 1;
               LogWrite('p' + Chr(TeamKicker + 48) + chr(NumberKicker + 65) + 'I');
               AddLog('Field Goal for ' +
                 player[TeamKicker, NumberKicker].GetPlayerName);
               {increase score marker}
               marker[TeamKicker, MT_Score].MarkerMouseUp(
                 marker[curteam, MT_Score], mbLeft, [], 0, 0);
               marker[TeamKicker, MT_Score].MarkerMouseUp(
                 marker[TeamKicker, MT_Score], mbLeft, [], 0, 0);
               GameStatus := 'Field Goal';
             end else begin
               player[TeamKicker, NumberKicker].td :=
                  player[TeamKicker, NumberKicker].td + 1;
               LogWrite('p' + Chr(TeamKicker + 48) + chr(NumberKicker + 65) + 'T');
               AddLog('Field Goal for ' +
                 player[TeamKicker, NumberKicker].GetPlayerName);
               {increase score marker}
               marker[TeamKicker, MT_Score].MarkerMouseUp(
                 marker[curteam, MT_Score], mbLeft, [], 0, 0);
               GameStatus := 'Field Goal';
             end;
           end;
       end else begin
         if (KickP < 0) and (KickQ < 0) then
           ScatterBallFrom(LastP, LastQ, 1, 1) else
         if (KickP < 0) and (KickQ > 25) then
            ScatterBallFrom(LastP, LastQ, 1, 3) else
         if (KickP > 14) and (KickQ < 0) then
            ScatterBallFrom(LastP, LastQ, 1, 6) else
         if (KickP > 14) and (KickQ > 25) then
            ScatterBallFrom(LastP, LastQ, 1, 8) else
         if (KickP < 0) then
            ScatterBallFrom(LastP, LastQ, 1, 2) else
         if (KickP > 14) then
            ScatterBallFrom(LastP, LastQ, 1, 7) else
         if (KickQ < 0) then
            ScatterBallFrom(LastP, LastQ, 1, 4) else
         if (KickQ > 25) then
            ScatterBallFrom(LastP, LastQ, 1, 5);
       end;
     end;
  end;
end;

end.
