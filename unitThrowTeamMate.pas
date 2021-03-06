unit unitThrowTeamMate;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmTTM = class(TForm)
    gbPass: TGroupBox;
    Label1: TLabel;
    txtPassTZ: TEdit;
    cbAlwaysHungry: TCheckBox;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    rbShortPass: TRadioButton;
    rbLongPass: TRadioButton;
    rbLongBomb: TRadioButton;
    lblPasser: TLabel;
    lblCatcher: TLabel;
    butPassRoll: TButton;
    butPassSkill: TButton;
    butTeamReroll: TButton;
    butFumbleInaccurate: TButton;
    lblPassFailed: TLabel;
    Label7: TLabel;
    txtPassRollNeeded: TEdit;
    Label6: TLabel;
    txtThrowerAG: TEdit;
    cbVerySunny: TCheckBox;
    Label3: TLabel;
    txtPassFA: TEdit;
    cbBigGuyAlly: TCheckBox;
    cbBlizzard: TCheckBox;
    cbImpossible: TCheckBox;
    butAlwaysHungry: TButton;
    butAHTeamReroll: TButton;
    butAHPro: TButton;
    lblAlwaysHungry: TLabel;
    butPassPro: TButton;
    rbImpossible: TRadioButton;
    Label5: TLabel;
    lblThrowee: TLabel;
    rbQuickPass: TRadioButton;
    procedure TTMSkillClick(Sender: TObject);
    procedure butAlwaysHungryRollClick(Sender: TObject);
    procedure butTTMRollClick(Sender: TObject);
    procedure butTTMSkillClick(Sender: TObject);
    procedure butAHTeamRerollClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butAHProRerollClick(Sender: TObject);
    procedure butProRerollClick(Sender: TObject);
    procedure butFumbleInaccurateClick(Sender: TObject);
    procedure cbStuntyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmTTM: TfrmTTM;

procedure ShowThrowPlayer(g, f, g2, f2, p, q: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitMarker, unitBall, unitLog,
     unitRandom, unitTeam, unitLanding, unitCatch, unitSettings;

{$R *.DFM}

var TTMRollNeeded, TTMRollMod, TTMTZMod, TeamPasser, NumberPasser, TeamThrowee,
    NumberThrowee, TeamCatcher, dist, squaredist, FieldP,
    FieldQ: integer;

procedure CalculateTTMRollNeeded;
var r, m: integer;
begin
  m := 0;
  r := 7 - FVal(frmTTM.txtThrowerAG.text);
  if frmTTM.rbQuickPass.checked then m := m + 1;
  if frmTTM.rbLongPass.checked then m := m - 1;
  if frmTTM.rbLongBomb.checked then m := m - 2;
  if frmTTM.cbVerySunny.checked then m := m - 1;

  if not(frmTTM.cbBlizzard.checked) then frmTTM.cbImpossible.checked := false;
  TTMTZMod := 0;
  m := m - FVal(frmTTM.txtPassTZ.text);
  TTMTZMod := 0 - FVal(frmTTM.txtPassTZ.text);
  m := m - FVal(frmTTM.txtPassFA.text);
  TTMRollNeeded := r - m;
  TTMRollMod := m;
  if TTMRollNeeded < 2 then TTMRollNeeded := 2;
  if TTMRollNeeded > 6 then TTMRollNeeded := 6;
  frmTTM.txtPassRollNeeded.text := IntToStr(TTMRollNeeded) + '+';

  frmTTM.butPassRoll.enabled := (not(frmTTM.cbImpossible.checked)) and
    (not(frmTTM.rbImpossible.checked));

  if not(frmTTM.butPassRoll.enabled) then frmTTM.txtPassRollNeeded.text := '';
end;

procedure ShowTTM(g, f, g2, f2: integer);
{(g,f) passes}
var tz: TackleZones;

begin
  TeamPasser := g;
  NumberPasser := f;
  TeamThrowee := g2;
  NumberThrowee := f2;
  if (allPlayers[g,f].hasSkill('Toss Team-Mate')) then begin
    begin
      if squaredist = 0 then frmTTM.rbShortPass.checked := true else
      frmTTM.rbImpossible.checked := true;
    end;
  end else begin
    begin
      if squaredist = 0 then frmTTM.rbShortPass.checked := true else
      if squaredist = 1 then frmTTM.rbLongPass.checked := true else
      if squaredist = 2 then frmTTM.rbLongBomb.checked := true else
      frmTTM.rbImpossible.checked := true;
    end;
  end;
  frmTTM.gbPass.enabled := true;
  frmTTM.lblPasser.caption := allPlayers[g,f].GetPlayerName;
  frmTTM.lblPasser.font.color := colorarray[g,0,0];
  frmTTM.txtThrowerAG.text := IntToStr(allPlayers[g,f].ag);
  tz := CountTZ(g, f);
  frmTTM.txtPassTZ.text := IntToStr(tz.num);
  frmTTM.txtPassFA.text := IntToStr(CountFA(g, f));

  frmTTM.cbBigGuyAlly.checked := (((allPlayers[g,f].BigGuy) or
      (allPlayers[g,f].Ally)) and (true));// big guy

  begin
    if (allPlayers[g,f].hasSkill('Toss Team-Mate')) then begin
      begin
        if squaredist = 0 then frmTTM.rbShortPass.checked := true else
        frmTTM.rbImpossible.checked := true;
      end;
    end else begin
      begin
        if squaredist = 0 then frmTTM.rbShortPass.checked := true else
        if squaredist = 1 then frmTTM.rbLongPass.checked := true else
        if squaredist = 2 then frmTTM.rbLongBomb.checked := true else
        frmTTM.rbImpossible.checked := true;
      end;
    end;
  end;

  CalculateTTMRollNeeded;

  frmTTM.cbVerySunny.checked := Bloodbowl.GetWeather() = TWeatherState.Sunny;
  frmTTM.cbBlizzard.checked :=Bloodbowl.GetWeather() = TWeatherState.Blizzard;

  CalculateTTMRollNeeded;

  frmTTM.cbImpossible.checked := false;
  if (((dist > 56) and (false)) or
     ((squaredist > 1) ))
     and (frmTTM.cbBlizzard.checked) then
        frmTTM.cbImpossible.checked := true;
  if (((dist >= 121) and (false)) or
    ((squaredist >= 2) ))
    and (frmTTM.cbBlizzard.checked)
        then frmTTM.cbImpossible.checked := true;

  if frmTTM.cbAlwaysHungry.checked then begin
     frmTTM.butAlwaysHungry.enabled := (not(frmTTM.rbImpossible.checked) and
         not(frmTTM.cbImpossible.checked));
     frmTTM.butPassRoll.enabled := false;
     frmTTM.butAHPro.enabled := false;
     frmTTM.butAHTeamReroll.enabled := false;
     frmTTM.lblPassFailed.visible := false;
     frmTTM.Height := 395;
  end else begin
     frmTTM.butPassRoll.enabled :=
         (not(frmTTM.rbImpossible.checked) and
         not(frmTTM.cbImpossible.checked));
     frmTTM.butAlwaysHungry.enabled := false;
     frmTTM.butAHTeamReroll.enabled := false;
     frmTTM.butAHPro.enabled := false;
     frmTTM.Height := 425;
  end;
  frmTTM.lblPassFailed.visible := true;
  frmTTM.lblAlwaysHungry.visible := false;
  frmTTM.ShowModal;
end;

procedure ShowThrowPlayer(g, f, g2, f2, p, q: integer);
{(g,f) passes player (g2,f2) to (p,q)}
begin
  TeamCatcher := -1;
  squaredist := -1;
  FieldP := p;
  FieldQ := q;
  frmTTM.Height := 425;
  dist := (allPlayers[g,f].p - p) * (allPlayers[g,f].p - p)
        + (allPlayers[g,f].q - q) * (allPlayers[g,f].q - q);


    squaredist := RangeRulerRange(allPlayers[g,f].p, allPlayers[g,f].q, p, q);
  frmTTM.lblCatcher.caption := 'Field position ' + Chr(65+q) + IntToStr(p+1);
  frmTTM.lblCatcher.font.color := clPurple;
  frmTTM.lblThrowee.caption := '#'+InttoStr((allPlayers[g2,f2].cnumber))+' '+
    allPlayers[g2,f2].name;
  frmTTM.lblThrowee.font.color := clYellow;
  ShowTTM(g,f,g2,f2);
end;

procedure TfrmTTM.TTMSkillClick(Sender: TObject);
begin
  CalculateTTMRollNeeded;
end;

function WorkOutTTMResult: boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if (lastroll >= TTMRollNeeded) and (lastroll <> 1) then begin
    Bloodbowl.comment.text := 'Pass is accurate';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutTTMResult := true;
  end else begin
    if ((lastroll + TTMRollMod <= 1) )
       or (lastroll = 1)  then begin
      Bloodbowl.comment.text := 'Pass is fumbled!';
      frmTTM.butFumbleInaccurate.caption := 'Fumble';
    end else begin
      Bloodbowl.comment.text := 'Pass is inaccurate!';
      frmTTM.butFumbleInaccurate.caption := 'Throw inaccurate pass';
    end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutTTMResult := false;
  end;
end;

procedure TfrmTTM.butTTMRollClick(Sender: TObject);
var s: string;
    acc, k, l, k2, l2, p, q: integer;
    TTMResult, test3, ballhandler: boolean;
begin
  if allPlayers[TeamPasser,NumberPasser].hasSkill('Throw TeamMate') then
    allPlayers[TeamPasser,NumberPasser].UseSkill('Throw TeamMate');
  if allPlayers[TeamPasser,NumberPasser].hasSkill('Toss Team-Mate') then
    allPlayers[TeamPasser,NumberPasser].UseSkill('Toss Team-Mate');
  if allPlayers[TeamPasser,NumberPasser].hasSkill('Throw Team-Mate') then
    allPlayers[TeamPasser,NumberPasser].UseSkill('Throw Team-Mate');
  s := lblPasser.caption + ' throws ' + lblThrowee.caption + ' to '
      + lblCatcher.caption + ' (';
  if rbQuickPass.checked then s := s + 'Quick pass, ';
  if rbShortPass.checked then s := s + 'Short pass, ';
  if rbLongPass.checked then s := s + 'Long pass, ';
  if rbLongBomb.checked then s := s + 'Long bomb, ';

  if txtPassTZ.text <> '0' then s := s + txtPassTZ.text + ' TZ, ';
  if cbVerySunny.checked then s := s + 'Very Sunny, ';
  s := s + txtPassRollNeeded.text + ')';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  TTMResult := WorkOutTTMResult;
  if (TTMResult)  then begin
    ModalResult := 1;
    Hide;
    if GameStatus = 'PitchPlayer2' then acc := 2 else acc := 1;
    p := FieldP;
    q := FieldQ;
    ballhandler := false;
    if allPlayers[TeamThrowee,NumberThrowee].status = 2 then ballhandler := true;
    test3 := false;
    for k := 0 to 1 do
    for l := 1 to team[k].numplayers do begin
      if (allPlayers[k,l].p = p) and (allPlayers[k,l].q = q) and not
        ((k=TeamThrowee) and (l=NumberThrowee)) then begin
        k2 := k;
        l2 := l;
        test3 := true;
      end;
    end;
    if test3 then begin
      Bloodbowl.comment.text := '#'+
        InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
        allPlayers[TeamThrowee,NumberThrowee].name + ' lands on top of '+
        '#'+InttoStr((allPlayers[k2,l2].cnumber))+
        ' '+ allPlayers[k2,l2].name +'!  Push back '+ allPlayers[k2,l2].name + '!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      Bloodbowl.comment.text := allPlayers[TeamThrowee,NumberThrowee].name +
        ' lands in ' + allPlayers[k2,l2].name + 's square.  Place both prone' +
        ' and make armour/injury rolls for both!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if ballhandler then begin
        Bloodbowl.comment.text := 'Manually handle the ball bounce';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
    end else begin
      allPlayers[TeamThrowee,NumberThrowee].UsedMA :=
        allPlayers[TeamThrowee,NumberThrowee].UsedMA - 1;
      ShowLandingWindow(TeamThrowee, NumberThrowee, FieldP, FieldQ, acc);
    end;
  end
  else
   begin
    butPassRoll.enabled := false;
    butPassSkill.enabled := allPlayers[TeamPasser,NumberPasser].hasSkill('Pass');
    butTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
    butPassPro.enabled := (allPlayers[TeamPasser,NumberPasser].hasSkill('Pro'))
        and not (allPlayers[TeamPasser,NumberPasser].usedSkill('Pro'));
    frmTTM.height := 530;
  end;
end;

procedure MakeTTMReroll;
var TTMResult, test3, ballhandler: boolean;
    acc, k, l, k2, l2, p, q: integer;
begin
  TTMResult := WorkOutTTMResult;
  if (TTMResult) then begin
    frmTTM.ModalResult := 1;
    frmTTM.Hide;
    if GameStatus = 'PitchPlayer2' then acc := 2 else acc := 1;
    p := FieldP;
    q := FieldQ;
    ballhandler := false;
    if allPlayers[TeamThrowee,NumberThrowee].status = 2 then ballhandler := true;
    test3 := false;
    for k := 0 to 1 do
    for l := 1 to team[k].numplayers do begin
      if (allPlayers[k,l].p = p) and (allPlayers[k,l].q = q) and not
        ((k=TeamThrowee) and (l=NumberThrowee)) then begin
        k2 := k;
        l2 := l;
        test3 := true;
      end;
    end;
    if test3 then begin
      Bloodbowl.comment.text := '#'+
        InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
        allPlayers[TeamThrowee,NumberThrowee].name + ' lands on top of '+
        '#'+InttoStr((allPlayers[k2,l2].cnumber))+
        ' '+ allPlayers[k2,l2].name +'!  Push back '+ allPlayers[k2,l2].name + '!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      Bloodbowl.comment.text := allPlayers[TeamThrowee,NumberThrowee].name +
        ' lands in ' + allPlayers[k2,l2].name + 's square.  Place both prone' +
        ' and make armour/injury rolls for both!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if ballhandler then begin
        Bloodbowl.comment.text := 'Manually handle the ball bounce';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
    end else begin
      allPlayers[TeamThrowee,NumberThrowee].UsedMA :=
        allPlayers[TeamThrowee,NumberThrowee].UsedMA - 1;
      ShowLandingWindow(TeamThrowee, NumberThrowee, FieldP, FieldQ, acc);
    end;
  end else
  begin
    frmTTM.butPassRoll.enabled := false;
    frmTTM.butPassSkill.enabled := false;
    frmTTM.butTeamReroll.enabled := false;
    frmTTM.butPassPro.enabled := false;
  end;
end;

procedure MakeFailedProTTMReroll;
begin
  frmTTM.butPassRoll.enabled := false;
  frmTTM.butPassSkill.enabled := false;
  frmTTM.butTeamReroll.enabled := false;
  frmTTM.butPassPro.enabled := false;
end;

procedure TfrmTTM.butTTMSkillClick(Sender: TObject);
begin
  allPlayers[TeamPasser,NumberPasser].UseSkill('Pass');
  MakeTTMReroll;
end;

procedure TfrmTTM.butAlwaysHungryRollClick(Sender: TObject);
begin
  Bloodbowl.comment.text := 'Always Hungry roll';
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll>1 then begin
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butPassRoll.enabled := true;
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butAHTeamReroll.enabled := false;
    frmTTM.butAHPro.enabled := false;
    frmTTM.lblPassFailed.visible := true;
    frmTTM.Height := 425;
  end else begin
    Bloodbowl.comment.text := 'Always Hungry roll FAILED!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butAHTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
    butFumbleInaccurate.caption := 'Try to Eat Player';
    frmTTM.butAHPro.enabled := (allPlayers[TeamPasser,NumberPasser].hasSkill('Pro'))
      and (not (allPlayers[TeamPasser,NumberPasser].usedSkill('Pro')));
    frmTTM.butPassRoll.enabled := false;
    frmTTM.butPassSkill.enabled := false;
    frmTTM.butTeamReroll.enabled := false;
    frmTTM.butPassPro.enabled := false;
    frmTTM.Height := 525;
  end;
end;

procedure TfrmTTM.butAHTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then begin
    Bloodbowl.comment.text := 'Always Hungry RE-roll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  end;
  if lastroll>1 then begin
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butPassRoll.enabled := true;
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butAHTeamReroll.enabled := false;
    frmTTM.butAHPro.enabled := false;
    frmTTM.Height := 425;
  end else begin
    Bloodbowl.comment.text := 'Always Hungry RE-roll FAILED!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butAHTeamReroll.enabled := false;
    butFumbleInaccurate.caption := 'Try to Eat Player';
    frmTTM.butAHPro.enabled := false;
    frmTTM.butPassRoll.enabled := false;
    frmTTM.butPassSkill.enabled := false;
    frmTTM.butTeamReroll.enabled := false;
    frmTTM.butPassPro.enabled := false;
    frmTTM.Height := 525;
  end;
end;

procedure TfrmTTM.butAHProRerollClick(Sender: TObject);
begin
  allPlayers[TeamPasser,NumberPasser].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPasser,NumberPasser);
  if (lastroll <= 3) then lastroll := 1;
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  end;
  if lastroll>1 then begin
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butPassRoll.enabled := true;
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butAHTeamReroll.enabled := false;
    frmTTM.butAHPro.enabled := false;
    frmTTM.Height := 425;
  end else begin
    Bloodbowl.comment.text := 'Always Hungry PRO RE-roll FAILED!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    frmTTM.butAlwaysHungry.enabled := false;
    frmTTM.butAHTeamReroll.enabled := false;
    butFumbleInaccurate.caption := 'Try to Eat Player';
    frmTTM.butAHPro.enabled := false;
    frmTTM.butPassRoll.enabled := false;
    frmTTM.butPassSkill.enabled := false;
    frmTTM.butTeamReroll.enabled := false;
    frmTTM.butPassPro.enabled := false;
    frmTTM.Height := 525;
  end;
end;

procedure TfrmTTM.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakeTTMReroll else begin
    frmTTM.butPassRoll.enabled := false;
    frmTTM.butPassSkill.enabled := false;
    frmTTM.butTeamReroll.enabled := false;
    frmTTM.butPassPro.enabled := false;
  end;
end;

procedure TfrmTTM.butProRerollClick(Sender: TObject);
begin
  allPlayers[TeamPasser,NumberPasser].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPasser,NumberPasser);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeTTMReroll;
  end else MakeFailedProTTMReroll;
end;

procedure TfrmTTM.butFumbleInaccurateClick(Sender: TObject);
var p, q, k, l, k2, l2, i, acc, v, w,
    ploc, qloc: integer;
    ballhandler, test3, outofbounds, BallScatter: boolean;
begin
  ballhandler := false;
  if allPlayers[TeamThrowee,NumberThrowee].status = 2 then ballhandler := true;
  ModalResult := 1;
  if butFumbleInaccurate.caption = 'Fumble' then begin
    Bloodbowl.comment.text := '#'+
      InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
      allPlayers[TeamThrowee,NumberThrowee].name + 'lands face first from the Fumble';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Ballscatter := false;
    v := TeamThrowee;
    w := NumberThrowee;
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
  end else if butFumbleInaccurate.caption = 'Try to Eat Player' then begin
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    if (lastroll=1) and (allPlayers[TeamPasser,NumberPasser].hasSkill('Pro'))
      and not (allPlayers[TeamPasser,NumberPasser].usedSkill('Pro'))
      then begin
      allPlayers[TeamPasser,NumberPasser].UseSkill('Pro');
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if lastroll <= 3 then TeamRerollPro(TeamPasser,NumberPasser);
      if (lastroll >= 4) then begin
        Bloodbowl.comment.text := 'Pro reroll';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      end else lastroll := 1;
    end;
    if lastroll<>1 then begin
      Bloodbowl.D8ButtonClick(Bloodbowl.D8Button);
      p := allPlayers[TeamPasser,NumberPasser].p;
      q := allPlayers[TeamPasser,NumberPasser].q;
      NewPosInDir(p, q, lastroll);
      if (p < 0) or (p > 14) or (q < 0) or (q > 25) then begin
        Bloodbowl.comment.text := '#'+
           InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
           allPlayers[TeamThrowee,NumberThrowee].name + ' squirms free out of bounds!'
           + ' Make Injury roll!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        if ballhandler then begin
          Bloodbowl.comment.text := 'Manually handle the ball throw-in';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
       end;

      end else begin
        test3 := false;
        for k := 0 to 1 do
        for l := 1 to team[k].numplayers do begin
          if (allPlayers[k,l].p = p) and (allPlayers[k,l].q = q) and not
            ((k=TeamThrowee) and (l=NumberThrowee)) then begin
            k2 := k;
            l2 := l;
            test3 := true;
          end;
        end;
        if test3 then begin
          Bloodbowl.comment.text := '#'+
            InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
            allPlayers[TeamThrowee,NumberThrowee].name + ' lands on top of '+
            '#'+InttoStr((allPlayers[k2,l2].cnumber))+
            ' '+ allPlayers[k2,l2].name +'!  Push back '+ allPlayers[k2,l2].name + '!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          Bloodbowl.comment.text := allPlayers[TeamThrowee,NumberThrowee].name +
            ' lands in ' + allPlayers[k2,l2].name + 's square.  Place both prone' +
            ' and make armour/injury rolls for both!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        if ballhandler then begin
          Bloodbowl.comment.text := 'Manually handle the ball bounce';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end;
        end else begin
          PlacePlayer(NumberThrowee,TeamThrowee,p,q);
          allPlayers[TeamThrowee,NumberThrowee].SetStatus(3);
          Bloodbowl.comment.text := '#'+
            InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
            allPlayers[TeamThrowee,NumberThrowee].name + 'lands face first!  Make'
            + ' armour/injury rolls!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          if ballhandler then ScatterBallFrom(p,q,1,0);
        end;
      end;
    end else begin
      Bloodbowl.comment.text := '#'+
        InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
      allPlayers[TeamThrowee,NumberThrowee].name + 'is EATEN!!!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      allPlayers[TeamThrowee,NumberThrowee].SetStatus(8);
      if ballhandler then ScatterBallFrom((allPlayers[TeamPasser,NumberPasser].p),
        (allPlayers[TeamPasser,NumberPasser].q),1,0);
    end;
  end else begin
   {Inaccurate Throw}
    outofbounds := false;
    p := FieldP;
    q := FieldQ;
    for i := 1 to 3 do begin
      if not (outofbounds) then begin
        Bloodbowl.D8ButtonClick(Bloodbowl.D8Button);
        NewPosInDir(p, q, lastroll);
        if (p < 0) or (p > 14) or (q < 0) or (q > 25) then outofbounds := true;
      end;
    end;
    if outofbounds then begin
      Bloodbowl.comment.text := '#'+
        InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
      allPlayers[TeamThrowee,NumberThrowee].name + ' is thrown out of bounds!'
           + ' Make Injury roll!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if ballhandler then begin
        Bloodbowl.comment.text := 'Manually handle the ball throw-in';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
     end;
    end else begin
      test3 := false;
      for k := 0 to 1 do
      for l := 1 to team[k].numplayers do begin
        if (allPlayers[k,l].p = p) and (allPlayers[k,l].q = q) and not
          ((k=TeamThrowee) and (l=NumberThrowee)) then begin
          k2 := k;
          l2 := l;
          test3 := true;
        end;
      end;
      if test3 then begin
        Bloodbowl.comment.text := '#'+
          InttoStr((allPlayers[TeamThrowee,NumberThrowee].cnumber))+' '+
          allPlayers[TeamThrowee,NumberThrowee].name + ' lands on top of '+
          '#'+InttoStr((allPlayers[k2,l2].cnumber))+' '+
          allPlayers[k2,l2].name +'!  Push back '+
          allPlayers[k2,l2].name + '!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := allPlayers[TeamThrowee,NumberThrowee].name +
          ' lands in ' + allPlayers[k2,l2].name + 's square.  Place both prone' +
          ' and make armour/injury rolls for both!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        if ballhandler then begin
          Bloodbowl.comment.text := 'Manually handle the ball bounce';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
       end;
      end else begin
        frmTTM.Hide;
        if GameStatus = 'PitchPlayer2' then acc := 2 else acc := 0;
        allPlayers[TeamThrowee,NumberThrowee].UsedMA :=
          allPlayers[TeamThrowee,NumberThrowee].UsedMA - 1;
        ShowLandingWindow(TeamThrowee, NumberThrowee, p, q, acc);
      end;
    end;
  end;
end;

procedure TfrmTTM.cbStuntyClick(Sender: TObject);
begin
  begin
    if (allPlayers[ActionTeam,ActionPlayer].hasSkill('Toss Team-Mate')) then begin
      if false then begin
        if dist < 16 then frmTTM.rbShortPass.checked := true else
        frmTTM.rbImpossible.checked := true;
      end else begin
        if squaredist = 0 then frmTTM.rbShortPass.checked := true else
        frmTTM.rbImpossible.checked := true;
      end;
    end else begin
      if false then begin
        if dist < 16 then frmTTM.rbShortPass.checked := true else
        if dist <= 56 then frmTTM.rbLongPass.checked := true else
        if dist < 121 then frmTTM.rbLongBomb.checked := true else
        frmTTM.rbImpossible.checked := true;
      end else begin
        if squaredist = 0 then frmTTM.rbShortPass.checked := true else
        if squaredist = 1 then frmTTM.rbLongPass.checked := true else
        if squaredist = 2 then frmTTM.rbLongBomb.checked := true else
        frmTTM.rbImpossible.checked := true;
      end;
    end;
  end;

  CalculateTTMRollNeeded;
end;

end.
