unit unitPass;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmPass = class(TForm)
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
    cbBlizzard: TCheckBox;
    butPro: TButton;
    cbImpossible: TCheckBox;
    procedure PassSkillClick(Sender: TObject);
    procedure butPassRollClick(Sender: TObject);
    procedure butPassSkillClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butProClick(Sender: TObject);
    procedure butFumbleInaccurateClick(Sender: TObject);
    procedure cbTitchyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPass: TfrmPass;

procedure ShowPassPlayerToPlayer(g, f, g0, f0: integer);
procedure ShowPassPlayerToField(g, f, p, q: integer);
procedure DetermineInterceptors(g, f, p, q: integer);
function DetermineDivingCatch(p, q, cancatch, catchtype: integer): boolean;

implementation

uses bbunit, bbalg, unitPlayer, unitMarker, unitBall, unitLog, unitCatch,
     unitRandom, unitTeam, unitSettings, unitArmourRoll;

{$R *.DFM}

var PassRollNeeded, PassRollMod, PassTZMod, TeamPasser, NumberPasser,
    TeamCatcher, NumberCatcher, FieldP, FieldQ, squaredist: integer;

procedure CalculatePassRollNeeded;
var r, m: integer;
begin
  m := 0;
  if (frmPass.cbHailMaryPass.checked) and
    not(allPlayers[TeamPasser,NumberPasser].hasSkill('Hail Mary Pass')) then
    frmPass.cbHailMaryPass.checked := false;
  if frmPass.cbHailMaryPass.checked then begin
    r := 2;
  end else begin
    r := 7 - FVal(frmPass.txtThrowerAG.text);
    if frmPass.rbQuickPass.checked then m := m + 1;
    if frmPass.rbLongPass.checked then m := m - 1;
    if frmPass.rbLongBomb.checked then m := m - 2;
    if frmPass.cbAccurate.checked then m := m + 1;
    if frmPass.cbStrongArm.checked
    and not(frmPass.rbQuickPass.checked) then m := m + 1;
  end;
  if frmPass.cbVerySunny.checked then m := m - 1;
  if not(frmPass.cbBlizzard.checked) then
    frmPass.cbImpossible.checked := false;

  PassTZMod := 0;
  if not(frmPass.cbNervesOfSteel.checked) then begin
      m := m - FVal(frmPass.txtPassTZ.text);
      PassTZMod := 0 - FVal(frmPass.txtPassTZ.text);
  end;
  m := m - FVal(frmPass.txtPassFA.text);
  PassRollNeeded := r - m;
  PassRollMod := m;
  if PassRollNeeded < 2 then PassRollNeeded := 2;
  if PassRollNeeded > 6 then PassRollNeeded := 6;
  frmPass.txtPassRollNeeded.text := IntToStr(PassRollNeeded) + '+';

  frmPass.butPassRoll.enabled :=
         ((frmPass.cbHailMaryPass.checked) and
         not(frmPass.cbImpossible.checked)) or
         (not(frmPass.rbHailMaryPass.checked) and
         not(frmPass.cbImpossible.checked));

  if not(frmPass.butPassRoll.enabled) then frmPass.txtPassRollNeeded.text := '';
end;

procedure ShowPass(g, f: integer);
{(g,f) passes}
var tz: TackleZones;

begin
  TeamPasser := g;
  NumberPasser := f;
  frmPass.Height := 428;
  begin
    if squaredist = 0 then frmPass.rbQuickPass.checked := true else
    if squaredist = 1 then frmPass.rbShortPass.checked := true else
    if squaredist = 2 then frmPass.rbLongPass.checked := true else
    if squaredist = 3 then frmPass.rbLongBomb.checked := true else
    frmPass.rbHailMaryPass.checked := true;
  end;

  frmPass.gbPass.enabled := true;
  frmPass.lblPasser.caption := allPlayers[g,f].GetPlayerName;
  frmPass.lblPasser.font.color := colorarray[g,0,0];
  frmPass.txtThrowerAG.text := IntToStr(allPlayers[g,f].ag);
  tz := CountTZ(g, f);
  frmPass.txtPassTZ.text := IntToStr(tz.num);
  frmPass.txtPassFA.text := IntToStr(CountFA(g, f));
  frmPass.cbStrongArm.checked := allPlayers[g,f].hasSkill('Strong Arm');
  frmPass.cbAccurate.checked := allPlayers[g,f].hasSkill('Accurate');
  frmPass.cbNervesOfSteel.checked := allPlayers[g,f].hasSkill('Nerves of Steel');


  frmPass.cbBigGuyAlly.checked := (((allPlayers[g,f].BigGuy) or
      (allPlayers[g,f].Ally)) and (true));     // big guy
  frmPass.cbTitchy.checked :=
      (Pos('HALFLING', Uppercase(allPlayers[g,f].position)) > 0) or
      ((Pos('GOBLIN', Uppercase(allPlayers[g,f].position)) > 0)
        and not (Pos('HOBGOBLIN', Uppercase(allPlayers[g,f].position)) > 0)) or
      ((allPlayers[g,f].hasSkill('Stunty')));
  if  (frmPass.cbTitchy.checked) then
    begin

        begin
          if frmPass.cbTitchy.checked then
            begin
              begin
                if squaredist = 0 then frmPass.rbShortPass.checked := true else
                if squaredist = 1 then frmPass.rbLongPass.checked := true else
                if squaredist = 2 then frmPass.rbLongBomb.checked := true else
                frmPass.rbHailMaryPass.checked := true;
              end;
          end
          else
            begin
              begin
                if squaredist = 0 then frmPass.rbQuickPass.checked := true else
                if squaredist = 1 then frmPass.rbShortPass.checked := true else
                if squaredist = 2 then frmPass.rbLongPass.checked := true else
                if squaredist = 3 then frmPass.rbLongBomb.checked := true else
                frmPass.rbHailMaryPass.checked := true;
              end;
            end
        end;
      CalculatePassRollNeeded;
    end;

  frmPass.cbVerySunny.checked := Bloodbowl.GetWeather() = TWeatherState.Sunny;
  frmPass.cbBlizzard.checked := Bloodbowl.GetWeather() = TWeatherState.Blizzard;

  CalculatePassRollNeeded;

  frmPass.cbHailMaryPass.checked := ((allPlayers[g,f].hasSkill('Hail Mary Pass')) or
    (allPlayers[g,f].hasSkill('HMP'))) and (frmPass.rbHailMaryPass.checked);

  // can't throw in a blizzard
  frmPass.cbImpossible.checked := (squaredist > 1) and (frmPass.cbBlizzard.checked);

  frmPass.butPassRoll.enabled := frmPass.cbImpossible.checked;

  frmPass.lblPassFailed.visible := true;
  frmPass.ShowModal;
end;

procedure InjuryPlayer;
var Injmod, totspp, NiggleCount, p, t: integer;
  s: string;
begin
  allPlayers[TeamCatcher,NumberCatcher].SetStatus(3);
  if (frmPass.rbQuickPass.checked) then Injmod := 2 else
  if (frmPass.rbShortPass.checked) then Injmod := 1 else
  if (frmPass.rbLongPass.checked) then Injmod := 0 else Injmod := -1;
  if (allPlayers[TeamPasser,NumberPasser].hasSkill('Strong Arm')) then
    Injmod := Injmod +1;
  frmArmourRoll.rbIRDirtyPlayer.checked := true;
  if Injmod >= 0 then frmArmourRoll.txtDPInjMod.text := '+'+InttoStr(Injmod) else
    frmArmourRoll.txtDPInjMod.text := InttoStr(Injmod);
  frmArmourRoll.cbThickSkull.checked := (allPlayers[TeamCatcher,NumberCatcher].hasSkill('Thick Skull'));
  frmArmourRoll.cbProSkill.checked := (allPlayers[TeamCatcher,NumberCatcher].hasSkill('Pro'));


  if ((Pos('HALFLING', Uppercase(allPlayers[TeamCatcher,NumberCatcher].position)) > 0) or
      ((Pos('GOBLIN', Uppercase(allPlayers[TeamCatcher,NumberCatcher].position)) > 0)
        and not (Pos('HOBGOBLIN', Uppercase(allPlayers[TeamCatcher,NumberCatcher].position)) > 0)))
        then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else if (allPlayers[TeamCatcher,NumberCatcher].hasSkill('STUNTY')) then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else
      frmArmourRoll.rbNoStunty.checked := true;
  
  frmArmourRoll.cbDecay.checked := (allPlayers[TeamCatcher,NumberCatcher].hasSkill('Decay'));

  totspp := allPlayers[TeamCatcher,NumberCatcher].GetStartingSPP() +
            allPlayers[TeamCatcher,NumberCatcher].GetMatchSPP();

    s := allPlayers[TeamCatcher,NumberCatcher].inj;
    p := Pos('N', Uppercase(s));
    {roll for each N until all done, or 1 rolled}
    NiggleCount := 0;
    repeat begin
      if p<>0 then NiggleCount := NiggleCount + 1;
      s := Copy(s, p+1, Length(s) - p);
      p := Pos('N', Uppercase(s));
    end until (p = 0);
    frmArmourRoll.txtNiggles.text := IntToStr(NiggleCount);

  ShowHurtForm('I');
end;

procedure DetermineInterceptors(g, f, p, q: integer);
var
  loopPlayer: unitPlayer.TPlayer;
  d, dp, dq, dist9, r2, r3, catchodds, bestplayer: real;
  h, besth, bestodds, r, r4, r5, r6, bestmove, bestst, bestspp, bptz, disttoTD,
    totspp: integer;
  s: string;
  safethrow, pspiral, TZone, GoodPlayer, HMPPass: boolean;
  tz: TackleZones;
begin
  s := '';
  besth := 0;
  bestodds := 6;
  bestplayer := 0;
  catchodds := 0;
  r2 := 0;
  r3 := 0;
  HMPPass := false;
  //dist := (player[g, f].p - p) * (player[g, f].p - p) + (player[g, f].q - q) * (player[g, f].q - q);
  squaredist := RangeRulerRange(allPlayers[g, f].p, allPlayers[g, f].q, p, q);
  begin
    if squaredist > 3 then
      HMPPass := true;
  end;

  if not(HMPPass) then
  begin
    for h := 1 to team[1 - g].numplayers do
    begin
      { check if player is on field and standing }
      TZone := true;
      loopPlayer := allPlayers[1 - g, h];
      if (loopPlayer.tz > 0)  then
        TZone := false;
      if (loopPlayer.hasSkill('Nonball Handler')) then
        TZone := false;
      if (loopPlayer.status = 1) and (TZone) then
      begin
        { calculate closest point on pass-line to opponent }
        d := ((allPlayers[g, f].p - p) * (allPlayers[g, f].p - loopPlayer.p) +
          (allPlayers[g, f].q - q) * (allPlayers[g, f].q - loopPlayer.q)) /
          ((allPlayers[g, f].p - p) * (allPlayers[g, f].p - p) + (allPlayers[g, f].q - q) *
          (allPlayers[g, f].q - q));
        { if d<0 or d>1 then the opponent is not between passer and catcher }
        if (d > 0) and (d < 1) then
        begin
          { (dp,dq) is point on pass-line closest to opponent }
          dp := allPlayers[g, f].p + d * (p - allPlayers[g, f].p);
          dq := allPlayers[g, f].q + d * (q - allPlayers[g, f].q);
          { calculate distance from (dp,dq) to opponent }
          dist9 := Sqrt((loopPlayer.p - dp) * (loopPlayer.p - dp) +
            (loopPlayer.q - dq) * (loopPlayer.q - dq));
          { the range ruler is 1.9 inches wide, a player's base is 1 inch wide
            so if the distance is at most 2.9/2 = 1.45 inch then the opponent
            can intercept... but squares are 1.1 inch wide so dist must be
            smaller than 1.45/1.1=1.318 }

          GoodPlayer := CanIntercept(allPlayers[g, f].p, allPlayers[g, f].q, p, q,
            loopPlayer.p, loopPlayer.q);
          if GoodPlayer then
            dist9 := 1;

          if dist9 <= 1.318 then
          begin
            if s <> '' then
            begin
              s := s + ', ';
              r := 7 - loopPlayer.ag + 2;

              if loopPlayer.hasSkill('Extra Arms') then
                r := r - 1;
              if (loopPlayer.hasSkill('Very Long Legs')) or
                (loopPlayer.hasSkill('VLL')) then
                r := r - 1;

              if Bloodbowl.GetWeather() = TWeatherState.Raining then
                r := r + 1;

              tz := CountTZ(1 - g, h);
              if not(loopPlayer.hasSkill('Nerves of Steel')) then
                r := r + tz.num;
              bptz := tz.num;
              r := r + CountFA(1 - g, h);
              if r < 2 then
                r := 2;
              if r > 6 then
                r := 6;
              r2 := r;
              r3 := r;
              if loopPlayer.hasSkill('Catch') then
                r2 := r2 - 1.5;

              if bptz = 0 then
                r3 := r3 - 2;
              if (bptz <> 0) and (loopPlayer.hasSkill('Dodge')) then
                r3 := r3 - 1;

              if g = 0 then
                disttoTD := 25 - loopPlayer.q
              else
                disttoTD := loopPlayer.q;
              if disttoTD <= loopPlayer.ma then
                r4 := 1
              else if (disttoTD <= loopPlayer.ma + 1) and
                (loopPlayer.hasSkill('Sure Feet')) then
                r4 := 2
              else if (disttoTD <= loopPlayer.ma + 1) then
                r4 := 3
              else if (disttoTD <= loopPlayer.ma + 2) and
                (loopPlayer.hasSkill('Sure Feet')) then
                r4 := 4
              else if (disttoTD <= loopPlayer.ma + 2) then
                r4 := 5
              else if (disttoTD <= loopPlayer.ma + 3) and
                (loopPlayer.hasSkill('Sure Feet')) and
                (loopPlayer.hasSkill('Sprint')) then
                r4 := 6
              else if (disttoTD <= loopPlayer.ma + 3) and
                (loopPlayer.hasSkill('Sprint')) then
                r4 := 7
              else
                r4 := 8;

              r5 := 20 - loopPlayer.st;

              totspp := loopPlayer.GetStartingSPP() + loopPlayer.GetMatchSPP();
              r6 := bbalg.GetR6Value( totspp );

              if r6 = 1 then
                r6 := 2
              else if r6 = 2 then
                r6 := 1;
              if (r2 = catchodds) and (r3 = bestplayer) and (r4 = bestmove) and
                (r5 = bestst) and (r6 < bestspp) then
              begin
                besth := h;
                bestodds := r;
                bestspp := r6;
              end;
              if (r2 = catchodds) and (r3 = bestplayer) and (r4 = bestmove) and
                (r5 < bestst) then
              begin
                besth := h;
                bestodds := r;
                bestst := r5;
                bestspp := r6;
              end;
              if (r2 = catchodds) and (r4 = bestmove) and (r3 < bestplayer) then
              begin
                besth := h;
                bestodds := r;
                bestplayer := r3;
                bestst := r5;
                bestspp := r6;
              end;
              if (r2 = catchodds) and (r4 < bestmove) then
              begin
                besth := h;
                bestodds := r;
                bestplayer := r3;
                bestmove := r4;
                bestst := r5;
                bestspp := r6;
              end;
              if r2 < catchodds then
              begin
                besth := h;
                bestodds := r;
                catchodds := r2;
                bestplayer := r3;
                bestmove := r4;
                bestst := r5;
                bestspp := r6;
              end;
            end
            else
            begin
              r := 7 - loopPlayer.ag + 2;

              if loopPlayer.hasSkill('Extra Arms') then
                r := r - 1;
              if (loopPlayer.hasSkill('Very Long Legs')) or
                (loopPlayer.hasSkill('VLL')) then
                r := r - 1;

              if Bloodbowl.GetWeather() = TWeatherState.Raining        then
                r := r + 1;

              tz := CountTZ(1 - g, h);
              if not(loopPlayer.hasSkill('Nerves of Steel')) then
                r := r + tz.num;
              r := r + CountFA(1 - g, h);
              if r < 2 then
                r := 2;
              if r > 6 then
                r := 6;
              r2 := r;
              r3 := r;
              if loopPlayer.hasSkill('Catch') then
                r2 := r2 - 1.5;
              if tz.num = 0 then
                r3 := r3 - 2;
              if (tz.num <> 0) and (loopPlayer.hasSkill('Dodge')) then
                r3 := r3 - 1;
              if g = 0 then
                disttoTD := 25 - loopPlayer.q
              else
                disttoTD := loopPlayer.q;
              if disttoTD <= loopPlayer.ma then
                r4 := 1
              else if (disttoTD <= loopPlayer.ma + 1) and
                (loopPlayer.hasSkill('Sure Feet')) then
                r4 := 2
              else if (disttoTD <= loopPlayer.ma + 1) then
                r4 := 3
              else if (disttoTD <= loopPlayer.ma + 2) and
                (loopPlayer.hasSkill('Sure Feet')) then
                r4 := 4
              else if (disttoTD <= loopPlayer.ma + 2) then
                r4 := 5
              else if (disttoTD <= loopPlayer.ma + 3) and
                (loopPlayer.hasSkill('Sure Feet')) and
                (loopPlayer.hasSkill('Sprint')) then
                r4 := 6
              else if (disttoTD <= loopPlayer.ma + 3) and
                (loopPlayer.hasSkill('Sprint')) then
                r4 := 7
              else
                r4 := 8;
              r5 := 20 - loopPlayer.st;
              totspp := loopPlayer.GetStartingSPP() + loopPlayer.GetMatchSPP();
              r6 := bbalg.GetR6Value(totspp);

              if r6 = 1 then
                r6 := 2
              else if r6 = 2 then
                r6 := 1;
              bestodds := r;
              besth := h;
              catchodds := r2;
              bestplayer := r3;
              bestmove := r4;
              bestst := r5;
              bestspp := r6;
            end;
            s := s + '#' + IntToStr(loopPlayer.cnumber);
          end;
        end;
      end;
    end;
    if s <> '' then
    begin
      Bloodbowl.comment.text := 'The pass can be intercepted by: ' + s;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      safethrow := allPlayers[g, f].hasSkill('Safe Throw');
      ShowCatchWindow(1 - g, besth, 2, pspiral, safethrow);
    end;
  end;
end;

function DetermineDivingCatch(p, q, cancatch, catchtype: integer): boolean;
var d, dp, dq, dist9, r2, r3, catchodds, bestplayer: real;
    g, h, besth, bestodds, r, r4, r5, r6, bestmove, bestst, bestspp, bptz,
    disttoTD, totspp, bestg: integer;
    s: string;
    safethrow, pspiral, TZone, GoodPlayer, BlueTeam, RedTeam,
      DCCatch: boolean;
    tz: TackleZones;
begin
  DetermineDivingCatch := false;
  s := '';
  bestg := 0;
  besth := 0;
  bestodds := 6;
  bestplayer := 0;
  catchodds := 0;
  r2 := 0;
  r3 := 0;
  BlueTeam := False;
  RedTeam := False;
  DCCatch := false;
  for g := 0 to 1 do begin
    for h := 1 to team[g].numplayers do begin
      if (allPlayers[g,h].hasSkill('Diving Catch')) and (abs(allPlayers[g,h].p-p)<=1)
        and (abs(allPlayers[g,h].q-q)<=1) and (allPlayers[g,h].tz = 0) and
        (not(allPlayers[g,h].hasSkill('Nonball Handler'))) and
        (not(allPlayers[g,h].hasSkill('No Hands')))
        then begin
          if g = 0 then RedTeam := true;
          if g = 1 then BlueTeam := true;
          DCCatch := true;
      end;
    end;
  end;
  if (RedTeam) and (BlueTeam) then DCCatch := false;
  if DCCatch then begin
    for g := 0 to 1 do begin
      for h := 1 to team[1-g].numplayers do begin
        {check if player is on field and standing}
        TZone := True;
        if (allPlayers[1-g,h].tz > 0)
         then TZone := False;
        if (allPlayers[1-g,h].hasSkill('Nonball Handler')) or
          (allPlayers[1-g,h].hasSkill('No Hands')) then TZone := False;
        if (allPlayers[1-g,h].status = 1) and (TZone) then begin
          d := 2;
          if (abs(allPlayers[1-g,h].p-p)<=1) and (abs(allPlayers[1-g,h].q-q)<=1) and
            (allPlayers[1-g,h].hasSkill('Diving Catch')) then d := 1;
          {if d is 1 then the player can Diving Catch}
          if d = 1 then begin
            dist9 := 1;
            if dist9 <= 1.318 then begin
              if s <> '' then begin
                s := s + ', ';
                r := 7 - allPlayers[1-g, h].ag + 0;
                if allPlayers[1-g, h].hasSkill('Extra Arms') then r := r - 1;

                if Bloodbowl.GetWeather() = TWeatherState.Raining
                  then r := r + 1;

                tz := CountTZ(1-g, h);
                if not(allPlayers[1-g, h].hasSkill('Nerves of Steel')) then
                  r := r + tz.num;
                bptz := tz.num;
                r := r + CountFA(1-g, h);
                if r < 2 then r := 2;
                if r > 6 then r := 6;
                r2 := r;
                r3 := r;
                if allPlayers[1-g, h].hasSkill('Catch') then r2 := r2 - 1.5;
                if bptz = 0 then r3 := r3 - 2;
                if (bptz <> 0) and (allPlayers[1-g,h].hasSkill('Dodge')) then
                   r3 := r3 - 1;
                if g=0 then disttoTD := 25 - allPlayers[1-g,h].q else
                  disttoTD := allPlayers[1-g,h].q;
                if disttoTD <= allPlayers[1-g,h].ma then r4 := 1 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 1) and
                    (allPlayers[1-g,h].hasSkill('Sure Feet')) then r4 := 2 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 1) then r4 := 3 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 2) and
                    (allPlayers[1-g,h].hasSkill('Sure Feet')) then r4 := 4 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 2) then r4 := 5 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 3) and
                    (allPlayers[1-g,h].hasSkill('Sure Feet')) and
                    (allPlayers[1-g,h].hasSkill('Sprint')) then r4 := 6 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 3) and
                    (allPlayers[1-g,h].hasSkill('Sprint')) then r4 := 7 else r4 := 8;
                r5 := 20 - allPlayers[1-g,h].st;
                totspp := allPlayers[1-g,h].GetStartingSPP() + allPlayers[1-g,h].GetMatchSPP();

                begin
                  if totspp >= 176 then r6 := 100 else
                    if totspp >= 76 then r6 := 126 - totspp else
                    if totspp >= 51 then r6 := 76 - totspp else
                    if totspp >= 31 then r6 := 51 - totspp else
                    if totspp >= 16 then r6 := 31 - totspp else
                    if totspp >= 6 then r6 := 16 - totspp else
                    r6 := 6 - totspp;
                end;

                if r6 = 1 then r6 := 2 else
                  if r6 = 2 then r6 := 1;
                if (r2=catchodds) and (r3=bestplayer) and (r4=bestmove) and
                  (r5=bestst) and (r6<bestspp) then begin
                  bestg := 1-g;
                  besth := h;
                  bestodds := r;
                  bestspp := r6;
                end;
                if (r2=catchodds) and (r3=bestplayer) and (r4=bestmove) and
                  (r5<bestst) then begin
                  bestg := 1-g;
                  besth := h;
                  bestodds := r;
                  bestst := r5;
                  bestspp := r6;
                end;
                if (r2=catchodds) and (r4=bestmove) and (r3<bestplayer) then begin
                  bestg := 1-g;
                  besth := h;
                  bestodds := r;
                  bestplayer := r3;
                  bestst := r5;
                  bestspp := r6;
                end;
                if (r2=catchodds) and (r4<bestmove) then begin
                  bestg := 1-g;
                  besth := h;
                  bestodds := r;
                  bestplayer := r3;
                  bestmove := r4;
                  bestst := r5;
                  bestspp := r6;
                end;
                if r2<catchodds then begin
                  bestg := 1-g;
                  besth := h;
                  bestodds := r;
                  catchodds := r2;
                  bestplayer := r3;
                  bestmove := r4;
                  bestst := r5;
                  bestspp := r6;
                end;
              end else begin
                r := 7 - allPlayers[1-g, h].ag + 0;

                if Bloodbowl.GetWeather() = TWeatherState.Raining then
                   r := r + 1;
                tz := CountTZ(1-g, h);
                if not(allPlayers[1-g, h].hasSkill('Nerves of Steel')) then
                   r := r + tz.num;
                r := r + CountFA(1-g, h);
                if r < 2 then r := 2;
                if r > 6 then r := 6;
                r2 := r;
                r3 := r;
                if allPlayers[1-g, h].hasSkill('Catch') then r2 := r2 - 1.5;
                if tz.num = 0 then r3 := r3 - 2;
                if (tz.num <> 0) and (allPlayers[1-g,h].hasSkill('Dodge')) then
                   r3 := r3 - 1;
                if g=0 then disttoTD := 25 - allPlayers[1-g,h].q else
                  disttoTD := allPlayers[1-g,h].q;
                if disttoTD <= allPlayers[1-g,h].ma then r4 := 1 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 1) and
                    (allPlayers[1-g,h].hasSkill('Sure Feet')) then r4 := 2 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 1) then r4 := 3 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 2) and
                    (allPlayers[1-g,h].hasSkill('Sure Feet')) then r4 := 4 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 2) then r4 := 5 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 3) and
                    (allPlayers[1-g,h].hasSkill('Sure Feet')) and
                    (allPlayers[1-g,h].hasSkill('Sprint')) then r4 := 6 else
                  if (disttoTD <= allPlayers[1-g,h].ma + 3) and
                    (allPlayers[1-g,h].hasSkill('Sprint')) then r4 := 7 else r4 := 8;
                r5 := 20 - allPlayers[1-g,h].st;
                totspp := allPlayers[1-g,h].GetStartingSPP() + allPlayers[1-g,h].GetMatchSPP();

                r6 := bbalg.GetR6Value(totspp);
                
                if r6 = 1 then r6 := 2 else
                  if r6 = 2 then r6 := 1;
                bestodds := r;
                bestg := 1-g;
                besth := h;
                catchodds := r2;
                bestplayer := r3;
                bestmove := r4;
                bestst := r5;
                bestspp := r6;
              end;
              s := s + '#' + IntToStr(allPlayers[1-g,h].cnumber);
            end;
          end;
        end;
      end;
    end;
    if s <> '' then begin
      DetermineDivingCatch := true;
      Bloodbowl.comment.text := 'These players could use Diving Catch: ' + s;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if cancatch=1 then ShowCatchWindow(bestg, besth, catchtype, false, false);
      if cancatch=0 then begin
        Bloodbowl.comment.text := allPlayers[bestg,besth].GetPlayerName +
          ' can catch the ball after the kick-off result has been resolved';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        KoCatcherTeam := bestg;
        KoCatcherPlayer := besth;
        ball.p := allPlayers[bestg,besth].p;
        ball.q := allPlayers[bestg,besth].q;
      end;
    end;
  end;
end;

procedure ShowPassPlayerToPlayer(g, f, g0, f0: integer);
{(g,f) passes to (g0,f0)}
begin
  squaredist := -1;
  TeamCatcher := g0;
  NumberCatcher := f0;
  frmPass.Height := 425;
  AccuratePassPlay := false;
//  dist := (player[g,f].p - player[g0,f0].p) * (player[g,f].p - player[g0,f0].p)
//        + (player[g,f].q - player[g0,f0].q) * (player[g,f].q - player[g0,f0].q);

    squaredist := RangeRulerRange(allPlayers[g,f].p, allPlayers[g,f].q,
      allPlayers[g0,f0].p, allPlayers[g0,f0].q);
  frmPass.lblCatcher.caption := allPlayers[g0,f0].GetPlayerName;
  frmPass.lblCatcher.font.color := colorarray[g0,0,0];
  ShowPass(g,f);
end;

procedure ShowPassPlayerToField(g, f, p, q: integer);
{(g,f) passes to (p,q)}
begin
  TeamCatcher := -1;
  squaredist := -1;
  FieldP := p;
  FieldQ := q;
  AccuratePassPlay := false;
//  dist := (player[g,f].p - p) * (player[g,f].p - p)
//        + (player[g,f].q - q) * (player[g,f].q - q);

    squaredist := RangeRulerRange(allPlayers[g,f].p, allPlayers[g,f].q, p, q);
  frmPass.lblCatcher.caption := 'Field position ' + Chr(65+q) + IntToStr(p+1);
  frmPass.lblCatcher.font.color := clPurple;
  ShowPass(g,f);
end;

procedure TfrmPass.PassSkillClick(Sender: TObject);
begin
  CalculatePassRollNeeded;
end;

function BulletThrowCheck: boolean;
var rollneed, stroll: integer;
begin
  rollneed := 7 - allPlayers[TeamCatcher,NumberCatcher].st + 1;
  if allPlayers[TeamPasser,NumberPasser].hasSkill('Strong Arm') then
    rollneed := rollneed + 1;
  if rollneed > 6 then rollneed := 6;
  if rollneed < 2 then rollneed := 2;
  Bloodbowl.comment.text := 'Strength Roll to catch Bullet Throw.  Roll '+
    'Needed: ' + InttoStr(rollneed) + '+';
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  stroll := lastroll;
  if (lastroll<rollneed) and (allPlayers[TeamCatcher,NumberCatcher].hasSkill('Pro'))
    and not(allPlayers[TeamCatcher,NumberCatcher].usedSkill('Pro')) then begin
      Bloodbowl.comment.text := 'Pro roll to reroll failed Strength roll';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if lastroll>3 then begin
        Bloodbowl.comment.text := 'Pro succeeds, rerolling failed Strength roll';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        stroll := lastroll;
      end else begin
        Bloodbowl.comment.text := 'Pro failed!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
  end;
  if stroll>=rollneed then BulletThrowCheck := true else
    BulletThrowCheck := false;
end;

function WorkOutPassResult: boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if (lastroll >= PassRollNeeded) and (lastroll <> 1) then begin
    if frmPass.cbHailMaryPass.checked then begin
      Bloodbowl.comment.text := 'Hail Mary Pass is successful!';
      frmPass.butFumbleInaccurate.caption := 'Throw inaccurate pass';
    end else begin
      Bloodbowl.comment.text := 'Pass is accurate';
    end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutPassResult := true;
  end else begin
    if (lastroll + PassRollMod <= 1)
       or (lastroll = 1)  then begin
      Bloodbowl.comment.text := 'Pass is fumbled!';
      frmPass.butFumbleInaccurate.caption := 'Fumble';
    end else begin
      Bloodbowl.comment.text := 'Pass is inaccurate!';
      frmPass.butFumbleInaccurate.caption := 'Throw inaccurate pass';
    end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutPassResult := false;
  end;
end;

procedure TfrmPass.butPassRollClick(Sender: TObject);
var s: string;
    PassResult, DCCheck: boolean;
begin
  DCCheck := false;
  s := lblPasser.caption + ' passes to ' + lblCatcher.caption + '(';
  if cbHailMaryPass.checked then s := s + 'Hail Mary Pass, ' else begin
    if rbQuickPass.checked then s := s + 'Quick pass, ';
    if rbShortPass.checked then s := s + 'Short pass, ';
    if rbLongPass.checked then s := s + 'Long pass, ';
    if rbLongBomb.checked then s := s + 'Long bomb, ';
    if cbAccurate.checked then s := s + 'Accurate, ';
    if cbStrongArm.checked then s := s + 'Strong Arm, ';

  end;
  if cbNervesOfSteel.checked then s := s + 'Nerves of Steel, ' else
   if txtPassTZ.text <> '0' then s := s + txtPassTZ.text + ' TZ, ';
  if txtPassFA.text <> '0' then s := s + txtPassFA.text + ' FA, ';
  if cbVerySunny.checked then s := s + 'Very Sunny, ';
  s := s + txtPassRollNeeded.text + ')';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  PassResult := WorkOutPassResult;
  if (PassResult)  then begin
    if cbHailMaryPass.checked then begin
      butPassRoll.enabled := false;
      butPassSkill.enabled := false;
      butTeamReroll.enabled := false;
      butPro.Enabled := false;
      lblPassFailed.visible := false;
      Height := 530;
    end else begin
      ModalResult := 1;
      Hide;
      if TeamCatcher = -1 then begin

        if (allPlayers[TeamPasser, NumberPasser].status = 2) and
          (frmSettings.cbDC.checked) then
          DCCheck := DetermineDivingCatch(FieldP, FieldQ, 1, 1);
        if allPlayers[TeamPasser, NumberPasser].status = 2 then
          ScatterBallFrom(FieldP, FieldQ, 1, 0);
      end else begin

          AVBreak := true;
          InjuryPlayer;
          AVBreak := false;
          ScatterBallFrom((allPlayers[TeamCatcher,NumberCatcher].p),
          (allPlayers[TeamCatcher,NumberCatcher].q), 1, 0);
      end;
    end;
  end
  else
   begin
    butPassRoll.enabled := false;
    butPassSkill.enabled := allPlayers[TeamPasser,NumberPasser].hasSkill('Pass');
    butPro.enabled :=
       allPlayers[TeamPasser, NumberPasser].hasSkill('Pro') and
       not(allPlayers[TeamPasser,NumberPasser].usedSkill('Pro'));
    butTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
    frmPass.height := 530;
  end;
end;

procedure MakePassReroll;
var PassResult, BTcheck, DCCheck: boolean;
begin
  PassResult := WorkOutPassResult;
  if (PassResult) then begin
    if frmPass.cbHailMaryPass.checked then begin
      frmPass.butPassRoll.enabled := false;
      frmPass.butPassSkill.enabled := false;
      frmPass.butTeamReroll.enabled := false;
      frmPass.lblPassFailed.visible := false;
      frmPass.butPro.Enabled := false;
      frmPass.Height := 530;
    end else begin
      frmPass.ModalResult := 1;
      frmPass.Hide;
      if TeamCatcher = -1 then begin
        if (allPlayers[TeamPasser, NumberPasser].status = 2) and
          (frmSettings.cbDC.checked) then
          DCCheck := DetermineDivingCatch(FieldP, FieldQ, 1, 1);
        if allPlayers[TeamPasser, NumberPasser].status = 2 then
          ScatterBallFrom(FieldP, FieldQ, 1, 0);
      end else begin
        BTCheck := true;

        if BTCheck then begin
          if allPlayers[TeamPasser, NumberPasser].status = 2 then begin
            AccuratePassPlay := true;
            AccurateTeam := TeamPasser;
            AccuratePlayer := NumberPasser;
            ShowCatchWindow(TeamCatcher, NumberCatcher, 1,
              false, false);
          end;
        end else begin
          AVBreak := true;
          InjuryPlayer;
          AVBreak := false;
          ScatterBallFrom((allPlayers[TeamCatcher,NumberCatcher].p),
          (allPlayers[TeamCatcher,NumberCatcher].q), 1, 0);
        end;
      end;
    end;
  end
  else
   begin
    frmPass.butPassRoll.enabled := false;
    frmPass.butPassSkill.enabled := false;
    frmPass.butTeamReroll.enabled := false;
    frmPass.butPro.Enabled := false;
  end;
end;

procedure TfrmPass.butPassSkillClick(Sender: TObject);
begin
  allPlayers[TeamPasser,NumberPasser].UseSkill('Pass');
  MakePassReroll;
end;

procedure TfrmPass.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakePassReroll else begin
    frmPass.butPassRoll.enabled := false;
    frmPass.butPassSkill.enabled := false;
    frmPass.butTeamReroll.enabled := false;
    frmPass.butPro.Enabled := false;
  end;
end;

procedure TfrmPass.butProClick(Sender: TObject);
begin
  allPlayers[TeamPasser,NumberPasser].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPasser,NumberPasser);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakePassReroll;
  end else begin
    frmPass.butPro.enabled := false;
    frmPass.butPassSkill.enabled := false;
    frmPass.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmPass.butFumbleInaccurateClick(Sender: TObject);
begin
  ModalResult := 1;
  frmPass.Hide;
  AccuratePassPlay := false;
  if butFumbleInaccurate.caption = 'Fumble' then begin
    ScatterBallFrom(allPlayers[TeamPasser, NumberPasser].p,
                    allPlayers[TeamPasser, NumberPasser].q, 1, 0);
  end else begin
    if TeamCatcher = -1 then begin

      if allPlayers[TeamPasser, NumberPasser].status = 2 then
          ScatterBallFrom(FieldP, FieldQ, 3, 0);
    end else begin
      if allPlayers[TeamPasser, NumberPasser].status = 2 then
        ScatterBallFrom(allPlayers[TeamCatcher, NumberCatcher].p,
                      allPlayers[TeamCatcher, NumberCatcher].q, 3, 0);
    end;
  end;
end;

procedure TfrmPass.cbTitchyClick(Sender: TObject);
begin

    begin
      if frmPass.cbTitchy.checked then
        begin
          begin
            if squaredist = 0 then frmPass.rbShortPass.checked := true else
            if squaredist = 1 then frmPass.rbLongPass.checked := true else
            if squaredist = 2 then frmPass.rbLongBomb.checked := true else
            frmPass.rbHailMaryPass.checked := true;
          end;
      end else
        begin
          begin
            if squaredist = 0 then frmPass.rbQuickPass.checked := true else
            if squaredist = 1 then frmPass.rbShortPass.checked := true else
            if squaredist = 2 then frmPass.rbLongPass.checked := true else
            if squaredist = 3 then frmPass.rbLongBomb.checked := true else
            frmPass.rbHailMaryPass.checked := true;
          end;
        end
    end;
  frmPass.cbHailMaryPass.checked :=
    ((allPlayers[TeamPasser, NumberPasser].hasSkill('Hail Mary Pass')) or
    (allPlayers[TeamPasser, NumberPasser].hasSkill('HMP'))) and
    (frmPass.rbHailMaryPass.checked);
  CalculatePassRollNeeded;
end;

end.
