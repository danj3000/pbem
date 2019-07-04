unit unitThrowStuff;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmThrowStuff = class(TForm)
    gbPass: TGroupBox;
    Label1: TLabel;
    txtPassTZ: TEdit;
    cbAccurate: TCheckBox;
    cbStrongArm: TCheckBox;
    cbHailMaryPass: TCheckBox;
    cbNervesOfSteel: TCheckBox;
    Label2: TLabel;
    GroupBox3: TGroupBox;
    rbQuickPass: TRadioButton;
    rbShortPass: TRadioButton;
    rbLongPass: TRadioButton;
    rbLongBomb: TRadioButton;
    rbHailMaryPass: TRadioButton;
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
    cbTitchy: TCheckBox;
    Label3: TLabel;
    txtPassFA: TEdit;
    cbBigGuyAlly: TCheckBox;
    cbHFHead: TCheckBox;
    cbBlizzard: TCheckBox;
    cbImpossible: TCheckBox;
    cbSingleEye: TCheckBox;
    cbThirdEye: TCheckBox;
    cb3EyePlus: TCheckBox;
    cb3EyeMinus: TCheckBox;
    butPro: TButton;
    butProLight: TButton;
    butRerollLight: TButton;
    butLightFuse: TButton;
    cbNet: TCheckBox;
    procedure PassSkillClick(Sender: TObject);
    procedure butPassRollClick(Sender: TObject);
    procedure butPassSkillClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butProClick(Sender: TObject);
    procedure butFumbleInaccurateClick(Sender: TObject);
    procedure butLightFuseClick(Sender: TObject);
    procedure butRerollLightClick(Sender: TObject);
    procedure butProLightClick(Sender: TObject);
    procedure cbTitchyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmThrowStuff: TfrmThrowStuff;

procedure ShowStuffPlayerToPlayer(g, f, g0, f0, StuffType: integer);
procedure ShowStuffPlayerToField(g, f, p, q, StuffType: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitMarker, unitBall, unitLog, unitCatchStuff,
     unitRandom, unitTeam, unitSettings, unitArmourRoll;

{$R *.DFM}

var PassRollNeeded, PassRollMod, PassTZMod, TeamPasser, NumberPasser,
    TeamCatcher, NumberCatcher, dist, FieldP, FieldQ, squaredist,
    ThrowStuff: integer;
    TheThing: string;

procedure CalculatePassRollNeeded;
var r, m: integer;
begin
  m := 0;
  if (frmThrowStuff.cbHailMaryPass.checked) and
    not(player[TeamPasser,NumberPasser].hasSkill('Hail Mary Pass')) then
    frmThrowStuff.cbHailMaryPass.checked := false;
  if frmThrowStuff.cbHailMaryPass.checked then begin
    r := 2;
  end else begin
    r := 7 - FVal(frmThrowStuff.txtThrowerAG.text);
    if frmThrowStuff.rbQuickPass.checked then m := m + 1;
    if frmThrowStuff.rbLongPass.checked then m := m - 1;
    if frmThrowStuff.rbLongBomb.checked then m := m - 2;
    if frmThrowStuff.cbAccurate.checked then m := m + 1;
    if frmThrowStuff.cbStrongArm.checked
    and not(frmThrowStuff.rbQuickPass.checked) then m := m + 1;
  end;
  if ThrowStuff = 3 then m := m - 1;
  if frmThrowStuff.cbVerySunny.checked then m := m - 1;
  if frmThrowStuff.cbHFHead.checked then m := m - 2;
  frmThrowStuff.cb3EyePlus.checked := false;
  frmThrowStuff.cb3EyeMinus.checked := false;
  if (frmThrowStuff.cbThirdEye.checked) and (squaredist<=1)  then
    frmThrowStuff.cb3EyePlus.checked := true else
    if (frmThrowStuff.cbThirdEye.checked) then frmThrowStuff.cb3EyeMinus.checked := true;
  if frmThrowStuff.cb3EyeMinus.checked then m := m - 1;
  if frmThrowStuff.cb3EyePlus.checked then m := m + 1;
  if not(frmThrowStuff.cbBlizzard.checked) and
     not(frmThrowStuff.cbNet.checked) then frmThrowStuff.cbImpossible.checked := false;
  PassTZMod := 0;
  if not(frmThrowStuff.cbNervesOfSteel.checked) then begin
      m := m - FVal(frmThrowStuff.txtPassTZ.text);
      PassTZMod := 0 - FVal(frmThrowStuff.txtPassTZ.text);
  end;
  m := m - FVal(frmThrowStuff.txtPassFA.text);
  PassRollNeeded := r - m;
  PassRollMod := m;
  if PassRollNeeded < 2 then PassRollNeeded := 2;
  if PassRollNeeded > 6 then PassRollNeeded := 6;
  frmThrowStuff.txtPassRollNeeded.text := IntToStr(PassRollNeeded) + '+';

  frmThrowStuff.butPassRoll.enabled :=
         ((frmThrowStuff.cbHailMaryPass.checked) and
         not(frmThrowStuff.cbImpossible.checked)) or
         (not(frmThrowStuff.rbHailMaryPass.checked) and
         not(frmThrowStuff.cbImpossible.checked));

  if not(frmThrowStuff.butPassRoll.enabled) then frmThrowStuff.txtPassRollNeeded.text := '';
end;

procedure BlowUpBomb;
var BallScatter, Whiff, NetHit: boolean;
    t, u, v, w, pplace, qplace, ploc, qloc, BombDist: integer;
    s, s2: string;
begin
  pplace := StuffP;
  qplace := StuffQ;
  LogWrite('e' + Chr(47) + Chr(63) + Chr(BombTeam+48) + Chr(BombPlayer+64));
  BombTeam := -1;
  BombPlayer := -1;
  BallScatter := false;
  Whiff := true;
  if ThrowStuff = 1 then begin
    for t := 1 to 3 do begin
      for u := 1 to 3 do begin
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = pplace + (t-2)) and (player[v,w].q = qplace + (u-2))
              then begin
                Whiff := false;
                if (t=2) and (u=2) then begin
                  Bloodbowl.comment.Text := 'Bomb blast HITS #' +
                    player[v,w].GetPlayerName;
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
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
                end else begin
                  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                  if lastroll > 3 then begin
                     Bloodbowl.comment.Text := 'Bomb blast HITS #' +
                       player[v,w].GetPlayerName;
                     Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
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
                  end else begin
                    Bloodbowl.comment.Text := 'Bomb blast misses #' +
                      player[v,w].GetPlayerName;
                    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                  end;
                end;
            end;
          end;
        end;
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else if ThrowStuff=2 then begin
    for t := 1 to 3 do begin
      for u := 1 to 3 do begin
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = pplace + (t-2)) and (player[v,w].q = qplace + (u-2))
            then begin
              Whiff := false;
              Bloodbowl.comment.Text := 'Stink Bomb blast HITS #' +
                player[v,w].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              InjuryStatus := 3;
              if player[v,w].status < InjuryStatus then begin
                if player[v,w].status=2 then begin
                  ploc := player[v,w].p;
                  qloc := player[v,w].q;
                  player[v,w].SetStatus(InjuryStatus);
                  BallScatter := true;
                end else player[v,w].SetStatus(InjuryStatus);
              end;
              InjuryStatus := 0;
            end;
          end;
        end;
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else if ThrowStuff=3 then begin
    for v := 0 to 1 do begin
      for w := 1 to team[v].numplayers do begin
        Bombdist := RangeRulerRange(player[v,w].p, player[v,w].q,
          pplace,qplace);
        if Bombdist = 0 then begin
          Whiff := false;
          if (player[v,w].p = StuffP) and (player[v,w].q = StuffQ) then begin
            Bloodbowl.comment.Text := 'Big Bomb blast HITS #' +
              player[v,w].GetPlayerName;
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
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
          end else begin
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll > 3 then begin
              Bloodbowl.comment.Text := 'Big Bomb blast HITS #' +
                player[v,w].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
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
            end else begin
              Bloodbowl.comment.Text := 'Big Bomb blast misses #' +
                player[v,w].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end;
          end;
        end;
        if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
      end;
    end;
    Bloodbowl.comment.Text := 'Player originally throwing the Big Bomb is ' +
      'ejected and this call cannot be argued!  Please Send Off the player!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end else if ThrowStuff=4 then begin
    for v := 0 to 1 do begin
      for w := 1 to team[v].numplayers do begin
        if (player[v,w].p = StuffP) and (player[v,w].q = StuffQ) then begin
          Whiff := false;
          NetHit := true;
          if (player[v,w].hasSkill('Dodge')) or (player[v,w].hasSkill('Side Step'))
          then begin
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if (lastroll >= 9-player[v,w].ag) or (lastroll=6) then begin
              Bloodbowl.comment.Text := player[v,w].GetPlayerName + ' DODGES the'+
                ' Net.  No Effect!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              NetHit := false;
            end else begin
               Bloodbowl.comment.Text := player[v,w].GetPlayerName + ' fails to ' +
                 'dodge the Net!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end;
          end;
          if NetHit then begin
            s2 := '';
            s2 := 'u' + Chr(v + 48) + Chr(w + 64) +
              Chr(player[v,w].ma + 48) +
              Chr(player[v,w].st + 48) +
              Chr(player[v,w].ag + 48) +
              Chr(player[v,w].av + 48) +
             Chr(player[v,w].cnumber + 64) +
             Chr(player[v,w].value div 5 + 48) +
             player[v,w].name + '$' +
             player[v,w].position + '$' +
             player[v,w].picture + '$' +
             player[v,w].icon + '$' +
              player[v,w].GetSkillString(1) + '|' +
              Chr(player[v,w].ma + 48) +
              Chr(player[v,w].st + 48) +
              Chr(player[v,w].ag + 48) +
              Chr(player[v,w].av + 48) +
              Chr(player[v,w].cnumber + 64) +
             Chr(player[v,w].value div 5 + 48) +
             player[v,w].name + '$' +
             player[v,w].position + '$' +
             player[v,w].picture + '$' +
             player[v,w].icon + '$';
            s := '';
            s := player[v,w].GetSkillString(1) + ', Netted';
            player[v,w].SetSkill(s);
            s2 := s2 + player[v,w].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end;
        end;
      end;
    end;
  end;
  if Whiff then begin
    Bloodbowl.comment.Text := TheThing + ' misses everybody!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
end;

procedure ShowPass(g, f: integer);
{(g,f) passes}
var tz: TackleZones;

begin
  TeamPasser := g;
  NumberPasser := f;
  frmThrowStuff.Height := 425;
  if (ThrowStuff = 4) or (BombTeam<>-1) then  frmThrowStuff.Height := 490;
  begin
    if squaredist = 0 then frmThrowStuff.rbQuickPass.checked := true else
    if squaredist = 1 then frmThrowStuff.rbShortPass.checked := true else
    if squaredist = 2 then frmThrowStuff.rbLongPass.checked := true else
    if squaredist = 3 then frmThrowStuff.rbLongBomb.checked := true else
    frmThrowStuff.rbHailMaryPass.checked := true;
  end;

  frmThrowStuff.gbPass.enabled := true;
  frmThrowStuff.lblPasser.caption := player[g,f].GetPlayerName;
  frmThrowStuff.lblPasser.font.color := colorarray[g,0,0];
  frmThrowStuff.txtThrowerAG.text := IntToStr(player[g,f].ag);
  tz := CountTZ(g, f);
  frmThrowStuff.txtPassTZ.text := IntToStr(tz.num);
  frmThrowStuff.txtPassFA.text := IntToStr(CountFA(g, f));
  frmThrowStuff.cbStrongArm.checked := player[g,f].hasSkill('Strong Arm');
  frmThrowStuff.cbAccurate.checked := player[g,f].hasSkill('Accurate');
  frmThrowStuff.cbNervesOfSteel.checked := player[g,f].hasSkill('Nerves of Steel');
  frmThrowStuff.cbHFHead.checked := player[g,f].hasSkill('House Fly Head');
  frmThrowStuff.cbSingleEye.checked := player[g,f].hasSkill('Single Eye');
  frmThrowStuff.cbThirdEye.checked := player[g,f].hasSkill('Third Eye');
  frmThrowStuff.cb3EyePlus.checked := false;
  frmThrowStuff.cb3EyeMinus.checked := false;
  if (frmThrowStuff.cbThirdEye.checked) and
  ((squaredist<=1) ) then
    frmThrowStuff.cb3EyePlus.checked := true else
    if (frmThrowStuff.cbThirdEye.checked) then frmThrowStuff.cb3EyeMinus.checked := true;
  if not (frmSettings.cbHouseFlyHead.checked) then begin
    frmThrowStuff.cbHFHead.Checked := false;
    frmThrowStuff.cbHFHead.Visible := false;
  end;
  if not (frmSettings.cbSingleEye.checked) then begin
    frmThrowStuff.cbSingleEye.Checked := false;
    frmThrowStuff.cbSingleEye.Visible := false;
  end;
  if not (frmSettings.cbThirdEye.checked) then begin
    frmThrowStuff.cbThirdEye.Checked := false;
    frmThrowStuff.cbThirdEye.Visible := false;
    frmThrowStuff.cb3EyePlus.checked := false;
    frmThrowStuff.cb3EyeMinus.checked := false;
  end;
  frmThrowStuff.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (true));      // bigguy
  frmThrowStuff.cbTitchy.checked :=
      (Pos('HALFLING', Uppercase(player[g,f].position)) > 0) or
      ((Pos('GOBLIN', Uppercase(player[g,f].position)) > 0)
        and not (Pos('HOBGOBLIN', Uppercase(player[g,f].position)) > 0)) or
      ((player[g,f].hasSkill('Stunty')) );
  if (frmThrowStuff.cbTitchy.checked) then
    begin
        begin
          if frmThrowStuff.cbTitchy.checked then
            begin
              begin
                if squaredist = 0 then frmThrowStuff.rbShortPass.checked := true else
                if squaredist = 1 then frmThrowStuff.rbLongPass.checked := true else
                if squaredist = 2 then frmThrowStuff.rbLongBomb.checked := true else
                frmThrowStuff.rbHailMaryPass.checked := true;
              end;
          end else
            begin
              begin
                if squaredist = 0 then frmThrowStuff.rbQuickPass.checked := true else
                if squaredist = 1 then frmThrowStuff.rbShortPass.checked := true else
                if squaredist = 2 then frmThrowStuff.rbLongPass.checked := true else
                if squaredist = 3 then frmThrowStuff.rbLongBomb.checked := true else
                frmThrowStuff.rbHailMaryPass.checked := true;
              end;
            end
        end;
      CalculatePassRollNeeded;
    end;


  frmThrowStuff.cbVerySunny.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) = 'VERY SUNNY') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 3)) = 'FOG') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) = 'BLUSTERY') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 14)) = 'MOONLESS NIGHT') and
    not (player[g,f].hasSkill('Weather Immunity'));

  frmThrowStuff.cbBlizzard.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) = 'BLIZZARD') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 7)) = 'MONSOON') and
    not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 16)) = 'TORRENTIAL RAINS') and
    not (player[g,f].hasSkill('Weather Immunity'));

  frmThrowStuff.cbNet.checked := ThrowStuff = 4;

  CalculatePassRollNeeded;

  frmThrowStuff.cbImpossible.checked := false;
  if (     ((squaredist > 1) ))
     and (((frmThrowStuff.cbBlizzard.checked) and not
     (player[g,f].hasSkill('Cold Resistant')) or (frmThrowStuff.cbNet.Checked)))
        then frmThrowStuff.cbImpossible.checked := true;
  if (   (squaredist >= 2) )
    and (frmThrowStuff.cbBlizzard.checked)
        then frmThrowStuff.cbImpossible.checked := true;

  frmThrowStuff.butPassRoll.enabled :=
         ((frmThrowStuff.cbHailMaryPass.checked) and
         not(frmThrowStuff.cbImpossible.checked)) or
         (not(frmThrowStuff.rbHailMaryPass.checked) and
         not(frmThrowStuff.cbImpossible.checked));

  frmThrowStuff.lblPassFailed.visible := true;
  frmThrowStuff.ShowModal;
end;

procedure ShowStuffPlayerToPlayer(g, f, g0, f0, StuffType: integer);
{(g,f) passes to (g0,f0)}
begin
  squaredist := -1;
  TeamCatcher := g0;
  NumberCatcher := f0;
  frmThrowStuff.Height := 425;
  AccuratePassPlay := false;
  ThrowStuff := StuffType;
  dist := (player[g,f].p - player[g0,f0].p) * (player[g,f].p - player[g0,f0].p)
        + (player[g,f].q - player[g0,f0].q) * (player[g,f].q - player[g0,f0].q);

    squaredist := RangeRulerRange(player[g,f].p, player[g,f].q,
      player[g0,f0].p, player[g0,f0].q);
  frmThrowStuff.lblCatcher.caption := player[g0,f0].GetPlayerName;
  frmThrowStuff.lblCatcher.font.color := colorarray[g0,0,0];
  if StuffType = 1 then TheThing := 'Bomb' else
    if StuffType = 2 then TheThing := 'Stink Bomb' else
    if StuffType = 3 then TheThing := 'BIG Bomb' else TheThing := 'Net';
  frmThrowStuff.butLightFuse.enabled := true;
  frmThrowStuff.butRerollLight.enabled := false;
  frmThrowStuff.butProLight.enabled := false;
  frmThrowStuff.butLightFuse.visible := true;
  frmThrowStuff.butRerollLight.visible := true;
  frmThrowStuff.butProLight.visible := true;
  if (StuffType = 4) or (BombTeam<>-1) then begin
    frmThrowStuff.butPassRoll.enabled := true;
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butRerollLight.enabled := false;
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.lblPassFailed.visible := true;
    frmThrowStuff.butLightFuse.visible := false;
    frmThrowStuff.butRerollLight.visible := false;
    frmThrowStuff.butProLight.visible := false;
    frmThrowStuff.Height := 490;
  end;
  ShowPass(g,f);
end;

procedure ShowStuffPlayerToField(g, f, p, q, StuffType: integer);
{(g,f) passes to (p,q)}
begin
  TeamCatcher := -1;
  squaredist := -1;
  FieldP := p;
  FieldQ := q;
  AccuratePassPlay := false;
  ThrowStuff := StuffType;
  dist := (player[g,f].p - p) * (player[g,f].p - p)
        + (player[g,f].q - q) * (player[g,f].q - q);

    squaredist := RangeRulerRange(player[g,f].p, player[g,f].q, p, q);
  frmThrowStuff.lblCatcher.caption := 'Field position ' + Chr(65+q) + IntToStr(p+1);
  frmThrowStuff.lblCatcher.font.color := clPurple;
  if StuffType = 1 then TheThing := 'Bomb' else
    if StuffType = 2 then TheThing := 'Stink Bomb' else
    if StuffType = 3 then TheThing := 'BIG Bomb' else TheThing := 'Net';
  frmThrowStuff.butLightFuse.enabled := true;
  frmThrowStuff.butRerollLight.enabled := false;
  frmThrowStuff.butProLight.enabled := false;
  frmThrowStuff.butLightFuse.visible := true;
  frmThrowStuff.butRerollLight.visible := true;
  frmThrowStuff.butProLight.visible := true;
  if (StuffType = 4) or (BombTeam<>-1) then begin
    frmThrowStuff.butPassRoll.enabled := true;
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butRerollLight.enabled := false;
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.lblPassFailed.visible := true;
    frmThrowStuff.butLightFuse.visible := false;
    frmThrowStuff.butRerollLight.visible := false;
    frmThrowStuff.butProLight.visible := false;
    frmThrowStuff.Height := 490;
  end;
  ShowPass(g,f);
end;

procedure TfrmThrowStuff.PassSkillClick(Sender: TObject);
begin
  CalculatePassRollNeeded;
end;

function WorkOutPassResult: boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if (lastroll >= PassRollNeeded) and (lastroll <> 1) then begin
    if frmThrowStuff.cbHailMaryPass.checked then begin
      Bloodbowl.comment.text := 'Hail Mary Pass is successful!';
      frmThrowStuff.butFumbleInaccurate.caption := 'Throw inaccurate pass';
    end else begin
      Bloodbowl.comment.text := 'Pass is accurate';
    end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutPassResult := true;
  end else begin
    if ((lastroll + PassRollMod <= 1) and (frmSettings.rgPassFumble.ItemIndex=0))
       or ((lastroll + PassTZMod <= 1) and (frmSettings.rgPassFumble.ItemIndex=1))
       or (lastroll = 1)  then begin
      Bloodbowl.comment.text := 'Pass is fumbled!';
      frmThrowStuff.butFumbleInaccurate.caption := 'Fumble';
    end else begin
      Bloodbowl.comment.text := 'Pass is inaccurate!';
      frmThrowStuff.butFumbleInaccurate.caption := 'Throw inaccurate pass';
    end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutPassResult := false;
  end;
end;

procedure TfrmThrowStuff.butPassRollClick(Sender: TObject);
var s: string;
    PassResult, BTCheck: boolean;
begin
  s := lblPasser.caption + ' throws a '+TheThing+' at '+ lblCatcher.caption + '(';
  if cbHailMaryPass.checked then s := s + 'Hail Mary Pass, ' else begin
    if rbQuickPass.checked then s := s + 'Quick pass, ';
    if rbShortPass.checked then s := s + 'Short pass, ';
    if rbLongPass.checked then s := s + 'Long pass, ';
    if rbLongBomb.checked then s := s + 'Long bomb, ';
    if cbAccurate.checked then s := s + 'Accurate, ';
    if cbStrongArm.checked then s := s + 'Strong Arm, ';
    if cbHFHead.checked then s := s + 'House Fly Head, ';
    if cbSingleEye.checked then s := s + 'Single Eye, ';
    if cbThirdEye.checked then s := s + 'Third Eye, ';
  end;
  if cbNervesOfSteel.checked then s := s + 'Nerves of Steel, ' else
   if txtPassTZ.text <> '0' then s := s + txtPassTZ.text + ' TZ, ';
  if txtPassFA.text <> '0' then s := s + txtPassFA.text + ' FA, ';
  if cbVerySunny.checked then s := s + 'Very Sunny, ';
  s := s + txtPassRollNeeded.text + ')';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  PassResult := WorkOutPassResult;
  if (PassResult) and not (frmThrowStuff.cbSingleEye.checked) then begin
    if cbHailMaryPass.checked then begin
      butPassRoll.enabled := false;
      butPassSkill.enabled := false;
      butTeamReroll.enabled := false;
      butPro.Enabled := false;
      lblPassFailed.visible := false;
      Height := 585;
    end else begin
      ModalResult := 1;
      Hide;
      if TeamCatcher = -1 then begin
        StuffP := FieldP;
        StuffQ := FieldQ;
        ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
        If StuffP = -1 then begin
          Bloodbowl.comment.text :=  TheThing +
           ' lands in the crowd.  No Effect!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else begin
          BlowUpBomb;
        end;
      end else begin
        if ThrowStuff <> 4 then
          ShowCatchStuffWindow(TeamCatcher, NumberCatcher, 1, ThrowStuff)
        else begin
          StuffP := player[TeamCatcher, NumberCatcher].p;
          StuffQ := player[TeamCatcher, NumberCatcher].q;
          BlowUpBomb;
        end;
      end;
    end;
  end else if (frmThrowStuff.cbSingleEye.checked) and (PassResult) then begin
    frmThrowStuff.cbSingleEye.checked := false;
    Bloodbowl.comment.text :=
      'Accurate Pass must be re-rolled due to Single Eye';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    if WorkOutPassResult then begin
      ModalResult := 1;
      Hide;
      if TeamCatcher = -1 then begin
        StuffP := FieldP;
        StuffQ := FieldQ;
        ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
        If StuffP = -1 then begin
          Bloodbowl.comment.text :=  TheThing +
           ' lands in the crowd.  No Effect!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else begin
          BlowUpBomb;
        end;
      end else begin
        if ThrowStuff <> 4 then
          ShowCatchStuffWindow(TeamCatcher, NumberCatcher, 1, ThrowStuff)
        else begin
          StuffP := player[TeamCatcher, NumberCatcher].p;
          StuffQ := player[TeamCatcher, NumberCatcher].q;
          BlowUpBomb;
        end;
      end;
    end else begin
      butPassRoll.enabled := false;
      butPassSkill.enabled := player[TeamPasser,NumberPasser].hasSkill('Pass');
      butPro.enabled :=
         player[TeamPasser, NumberPasser].hasSkill('Pro') and
         not(player[TeamPasser,NumberPasser].usedSkill('Pro'));
      butTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
      frmThrowStuff.height := 585;
    end;
  end else begin
    butPassRoll.enabled := false;
    butPassSkill.enabled := player[TeamPasser,NumberPasser].hasSkill('Pass');
    butPro.enabled :=
       player[TeamPasser, NumberPasser].hasSkill('Pro') and
       not(player[TeamPasser,NumberPasser].usedSkill('Pro'));
    butTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
    frmThrowStuff.height := 585;
  end;
end;

procedure MakePassReroll;
var PassResult, BTcheck: boolean;
    v, w: integer;
begin
  PassResult := WorkOutPassResult;
  if (PassResult) and not (frmThrowStuff.cbSingleEye.checked) then begin
    if frmThrowStuff.cbHailMaryPass.checked then begin
      frmThrowStuff.butPassRoll.enabled := false;
      frmThrowStuff.butPassSkill.enabled := false;
      frmThrowStuff.butTeamReroll.enabled := false;
      frmThrowStuff.lblPassFailed.visible := false;
      frmThrowStuff.butPro.Enabled := false;
      frmThrowStuff.Height := 585;
    end else begin
      frmThrowStuff.ModalResult := 1;
      frmThrowStuff.Hide;
      if TeamCatcher = -1 then begin
        StuffP := FieldP;
        StuffQ := FieldQ;
        ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
        If StuffP = -1 then begin
          Bloodbowl.comment.text :=  TheThing +
           ' lands in the crowd.  No Effect!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else begin
          BlowUpBomb;
        end;
      end else begin
        if ThrowStuff <> 4 then
          ShowCatchStuffWindow(TeamCatcher, NumberCatcher, 1, ThrowStuff)
        else begin
          StuffP := player[TeamCatcher, NumberCatcher].p;
          StuffQ := player[TeamCatcher, NumberCatcher].q;
          BlowUpBomb;
        end;
      end;
    end;
  end else if (frmThrowStuff.cbSingleEye.checked) and (PassResult) then begin
    frmThrowStuff.cbSingleEye.checked := false;
    Bloodbowl.comment.text :=
      'Accurate Pass must be re-rolled due to Single Eye';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    if WorkOutPassResult then begin
      frmThrowStuff.ModalResult := 1;
      frmThrowStuff.Hide;
      if TeamCatcher = -1 then begin
        StuffP := FieldP;
        StuffQ := FieldQ;
        ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
        If StuffP = -1 then begin
          Bloodbowl.comment.text :=  TheThing +
           ' lands in the crowd.  No Effect!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else begin
          BlowUpBomb;
        end;
      end else begin
        if ThrowStuff <> 4 then
          ShowCatchStuffWindow(TeamCatcher, NumberCatcher, 1, ThrowStuff)
        else begin
          StuffP := player[TeamCatcher, NumberCatcher].p;
          StuffQ := player[TeamCatcher, NumberCatcher].q;
          BlowUpBomb;
        end;
      end;
    end else begin
      frmThrowStuff.butPassRoll.enabled := false;
      frmThrowStuff.butPassSkill.enabled := false;
      frmThrowStuff.butTeamReroll.enabled := false;
      frmThrowStuff.butPro.enabled := false;
    end;
  end else begin
    frmThrowStuff.butPassRoll.enabled := false;
    frmThrowStuff.butPassSkill.enabled := false;
    frmThrowStuff.butTeamReroll.enabled := false;
    frmThrowStuff.butPro.Enabled := false;
  end;
end;

procedure TfrmThrowStuff.butLightFuseClick(Sender: TObject);
var targetroll: integer;
begin
  targetroll := 2;
  if ThrowStuff = 3 then targetroll := 3;
  Bloodbowl.comment.text := 'Lite Bomb Fuse roll';
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll>=targetroll then begin
    frmThrowStuff.butPassRoll.enabled := true;
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butRerollLight.enabled := false;
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.lblPassFailed.visible := true;
    frmThrowStuff.Height := 490;
  end else begin
    Bloodbowl.comment.text := 'Lite Fuse roll FAILED!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butRerollLight.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
    butFumbleInaccurate.caption := 'Bomb Explodes!';
    frmThrowStuff.butProLight.enabled := (player[TeamPasser,NumberPasser].hasSkill('Pro'))
      and (not (player[TeamPasser,NumberPasser].usedSkill('Pro')));
    frmThrowStuff.butPassRoll.enabled := false;
    frmThrowStuff.butPassSkill.enabled := false;
    frmThrowStuff.butTeamReroll.enabled := false;
    frmThrowStuff.butPro.enabled := false;
    frmThrowStuff.Height := 585;
  end;
end;

procedure TfrmThrowStuff.butRerollLightClick(Sender: TObject);
var targetroll: integer;
    UReroll: boolean;
begin
  targetroll := 2;
  if ThrowStuff = 3 then targetroll := 3;
  UReroll := UseTeamReroll;
  if UReroll then begin
    Bloodbowl.comment.text := 'Lite Fuse RE-roll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  end;
  if lastroll>=targetroll then begin
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butPassRoll.enabled := true;
    frmThrowStuff.butRerollLight.enabled := false;
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.Height := 490;
  end else begin
    Bloodbowl.comment.text := 'Lite Fuse RE-roll FAILED!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butRerollLight.enabled := false;
    butFumbleInaccurate.caption := 'Bomb Explodes!';
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.butPassRoll.enabled := false;
    frmThrowStuff.butPassSkill.enabled := false;
    frmThrowStuff.butTeamReroll.enabled := false;
    frmThrowStuff.butPro.enabled := false;
    frmThrowStuff.Height := 585;
  end;
end;

procedure TfrmThrowStuff.butProLightClick(Sender: TObject);
var targetroll: integer;
begin
  targetroll := 2;
  if ThrowStuff = 3 then targetroll := 3;
  player[TeamPasser,NumberPasser].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPasser,NumberPasser);
  if (lastroll <= 3) then lastroll := 1;
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  end;
  if lastroll>=targetroll then begin
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butPassRoll.enabled := true;
    frmThrowStuff.butRerollLight.enabled := false;
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.Height := 490;
  end else begin
    Bloodbowl.comment.text := 'Lite Fuse PRO RE-roll FAILED!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    frmThrowStuff.butLightFuse.enabled := false;
    frmThrowStuff.butRerollLight.enabled := false;
    butFumbleInaccurate.caption := 'Bomb Explodes!';
    frmThrowStuff.butProLight.enabled := false;
    frmThrowStuff.butPassRoll.enabled := false;
    frmThrowStuff.butPassSkill.enabled := false;
    frmThrowStuff.butTeamReroll.enabled := false;
    frmThrowStuff.butPro.enabled := false;
    frmThrowStuff.Height := 585;
  end;
end;

procedure TfrmThrowStuff.butPassSkillClick(Sender: TObject);
begin
  player[TeamPasser,NumberPasser].UseSkill('Pass');
  MakePassReroll;
end;

procedure TfrmThrowStuff.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakePassReroll else begin
    frmThrowStuff.butPassRoll.enabled := false;
    frmThrowStuff.butPassSkill.enabled := false;
    frmThrowStuff.butTeamReroll.enabled := false;
    frmThrowStuff.butPro.Enabled := false;
  end;
end;

procedure TfrmThrowStuff.butProClick(Sender: TObject);
begin
  player[TeamPasser,NumberPasser].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPasser,NumberPasser);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakePassReroll;
  end else begin
    frmThrowStuff.butPro.enabled := false;
    frmThrowStuff.butPassSkill.enabled := false;
    frmThrowStuff.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmThrowStuff.butFumbleInaccurateClick(Sender: TObject);
var v, w: integer;
    NoPlayers: boolean;
begin
  ModalResult := 1;
  frmThrowStuff.Hide;
  AccuratePassPlay := false;
  if butFumbleInaccurate.caption = 'Bomb Explodes!' then begin
    StuffP := player[TeamPasser, NumberPasser].p;
    StuffQ := player[TeamPasser, NumberPasser].q;
    BlowUpBomb;
  end else if butFumbleInaccurate.caption = 'Fumble' then begin
    StuffP := player[TeamPasser, NumberPasser].p;
    StuffQ := player[TeamPasser, NumberPasser].q;
    ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
    If StuffP = -1 then begin
      Bloodbowl.comment.text :=  TheThing +
        ' lands in the crowd.  No Effect!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    end else begin
      BlowUpBomb;
    end;
  end else begin
    if TeamCatcher = -1 then begin
      StuffP := FieldP;
      StuffQ := FieldQ;
      ScatterStuffFrom(Stuffp, Stuffq, 3, 0, TheThing);
      If StuffP = -1 then begin
        Bloodbowl.comment.text :=  TheThing +
          ' lands in the crowd.  No Effect!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else begin
        NoPlayers := true;
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p=StuffP) and (player[v,w].q=StuffQ) and
            (player[v,w].status >= 1) and (player[v,w].status <= 4) then begin
              NoPlayers := false;
              if (player[v,w].status = 1) or (player[v,w].status = 2) then begin
                if ThrowStuff <> 4 then
                  ShowCatchStuffWindow(v,w, 2, ThrowStuff)
                else begin
                  StuffP := player[v,w].p;
                  StuffQ := player[v,w].q;
                  BlowUpBomb;
                end;
              end else begin
                StuffP := player[v,w].p;
                StuffQ := player[v,w].q;
                ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
                If StuffP = -1 then begin
                  Bloodbowl.comment.text :=  TheThing +
                    ' lands in the crowd.  No Effect!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else begin
                  BlowUpBomb;
                end;
              end;
            end;
          end;
        end;
        if NoPlayers then begin
          ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
          If StuffP = -1 then begin
            Bloodbowl.comment.text :=  TheThing +
              ' lands in the crowd.  No Effect!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            BlowUpBomb;
          end;
        end;
      end;
    end else begin
      StuffP := player[TeamCatcher, NumberCatcher].p;
      StuffQ := player[TeamCatcher, NumberCatcher].q;
      ScatterStuffFrom(Stuffp, Stuffq, 3, 0, TheThing);
      If StuffP = -1 then begin
        Bloodbowl.comment.text :=  TheThing +
          ' lands in the crowd.  No Effect!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else begin
        NoPlayers := true;
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p=StuffP) and (player[v,w].q=StuffQ) and
            (player[v,w].status >= 1) and (player[v,w].status <= 4) then begin
              NoPlayers := false;
              if (player[v,w].status = 1) or (player[v,w].status = 2) then begin
                if ThrowStuff <> 4 then
                  ShowCatchStuffWindow(v,w, 2, ThrowStuff)
                else begin
                  StuffP := player[v,w].p;
                  StuffQ := player[v,w].q;
                  BlowUpBomb;
                end;
              end else begin
                StuffP := player[v,w].p;
                StuffQ := player[v,w].q;
                ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
                If StuffP = -1 then begin
                  Bloodbowl.comment.text :=  TheThing +
                    ' lands in the crowd.  No Effect!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else begin
                  BlowUpBomb;
                end;
              end;
            end;
          end;
        end;
        if NoPlayers then begin
          ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
          If StuffP = -1 then begin
            Bloodbowl.comment.text :=  TheThing +
              ' lands in the crowd.  No Effect!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            BlowUpBomb;
          end;
        end;
      end;
    end;
  end;
end;

procedure TfrmThrowStuff.cbTitchyClick(Sender: TObject);
begin
  if frmThrowStuff.cbTitchy.checked then
        begin
begin
            if squaredist = 0 then frmThrowStuff.rbShortPass.checked := true else
            if squaredist = 1 then frmThrowStuff.rbLongPass.checked := true else
            if squaredist = 2 then frmThrowStuff.rbLongBomb.checked := true else
            frmThrowStuff.rbHailMaryPass.checked := true;
          end;
      end
      else
        begin
begin
            if squaredist = 0 then frmThrowStuff.rbQuickPass.checked := true else
            if squaredist = 1 then frmThrowStuff.rbShortPass.checked := true else
            if squaredist = 2 then frmThrowStuff.rbLongPass.checked := true else
            if squaredist = 3 then frmThrowStuff.rbLongBomb.checked := true else
            frmThrowStuff.rbHailMaryPass.checked := true;
          end;
        end;

  CalculatePassRollNeeded;
end;


end.
