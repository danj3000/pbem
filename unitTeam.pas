unit unitTeam;

interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const MaxNumPlayersInTeam = 40;

type
  TmodTeam = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TTeam = class(TLabel)
public
  name, race, email, coach, treasury, treasury0, logo, homefield: string;
  number, ff, ff0, reroll, reroll0, apot, wiz, asstcoaches, cheerleaders,
  winmod, tr, bonusCards, bonusMVP, rerollcost,
  matchwinnings, matchwinningsmod, numplayers: integer;
  UsedLeaderReroll, HeadCoach: boolean;
  constructor New(form: TForm; nr: integer);
  procedure ShowTeamDetails;
  procedure TeamMouseMove(Sender: TObject; Shift: TShiftState;
                            X, Y: Integer);
end;

var
  modTeam: TmodTeam;

procedure ResetTeam(g: integer);
function TranslateTeamStatChange(s: string): string;
procedure PlayActionTeamStatChange(s: string; dir: integer);
procedure PlayActionRemoveACCH(s: string; dir: integer);
function CanUseTeamReroll(bga: boolean): boolean;
procedure TeamRerollPro(g,f: integer);
function UseTeamReroll: boolean;

implementation

uses bbalg, unitPlayer, bbunit, unitPlayAction, unitLog, unitMarker, unitField,
  unitMessage, unitSettings, unitRandom;

{$R *.DFM}

constructor TTeam.New(form: TForm; nr: integer);
begin
  inherited Create(form);
  number := nr;
  autosize := false;
  top := Bloodbowl.ScoreLabel.top + 3;
  height := 40;
  width := marker[0, MT_Leader].left - field[0,0].left - 4;
  alignment := taCenter;
  font.color := TeamTextColor[nr];
  if nr = 0 then begin
    left := field[0,0].left;
  end else begin
    left := marker[1, MT_Leader].left + marker[1, MT_Leader].width + 3;
  end;
  color := Bloodbowl.color;
  font.size := 12;
  font.style := [fsBold];
  wordwrap := true;
  OnMouseMove := TeamMouseMove;
  parent := Bloodbowl;
end;

procedure ResetTeam(g: integer);
var f, i: integer;
begin
    team[g].name := '';
    team[g].race := '';
    team[g].coach := '';
    team[g].treasury := '';
    team[g].ff := 0;
    team[g].reroll := 0;
    team[g].treasury0 := '';
    team[g].ff0 := 0;
    team[g].reroll0 := 0;
    team[g].rerollcost := 0;
    team[g].apot := 0;
    team[g].wiz := 0;
    team[g].asstcoaches := 0;
    team[g].cheerleaders := 0;
    team[g].winmod := 0;
    team[g].tr := 0;
    team[g].bonusCards := 0;
    team[g].bonusMVP := 0;
    team[g].rerollcost := 0;
    team[g].matchwinnings := 0;
    team[g].matchwinningsmod := 0;
    team[g].UsedLeaderReroll := false;
    team[g].HeadCoach := true;
    team[g].numplayers := 0;
    team[g].logo := '';
    team[g].homefield := '';
    for f := 1 to MaxNumPlayersInTeam do begin
      player[g,f].teamnr := g;
      player[g,f].number := f;
      player[g,f].name := '';
      player[g,f].name0 := '';
      player[g,f].position := '';
      player[g,f].position0 := '';
      player[g,f].inj := '';
      player[g,f].p := -1;
      player[g,f].q := -1;
      player[g,f].status := 11;
      player[g,f].SIstatus := 0;
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
      player[g,f].ma := 0;
      player[g,f].st := 0;
      player[g,f].ag := 0;
      player[g,f].av := 0;
      player[g,f].BigGuy := false;
      player[g,f].Ally := false;
      for i := 1 to 15 do player[g,f].skill[i] := '';
      player[g,f].ma0 := 0;
      player[g,f].st0 := 0;
      player[g,f].ag0 := 0;
      player[g,f].av0 := 0;
      player[g,f].BigGuy0 := false;
      player[g,f].Ally0 := false;
      for i := 1 to 15 do player[g,f].skill0[i] := '';
      player[g,f].value := 0;
      player[g,f].value0 := 0;
      player[g,f].skillrolls := 0;
      player[g,f].tz := 0;
      player[g,f].peaked := false;
      player[g,f].picture := '';
      player[g,f].picture0 := '';
    end;
end;

function TranslateTeamStatChange(s: string): string;
var g, r, f, p: integer;
    t: string;
begin
  g := Ord(s[2]) - 48;
  p := Pos('|', s);
  r := Ord(s[p+1]) - 48;
  f := Ord(s[p+2]) - 48;
  t := Copy(s, p+3, Length(s) - p - 2);
  TranslateTeamStatChange := team[g].name + ' stats changed (RR: ' +
         IntToStr(r) + ', FF: ' + IntToStr(f) + ', Treasury: ' + t + ')';
end;

procedure PlayActionTeamStatChange(s: string; dir: integer);
var g, r, f, p, p2: integer;
    t: string;
begin
  if s[2]<>'S' then begin
    g := Ord(s[2]) - 48;
    p := Pos('|', s);
    if dir = 1 then begin
      r := Ord(s[p+1]) - 48;
      f := Ord(s[p+2]) - 48;
      t := Copy(s, p+3, Length(s) - p - 2);
      DefaultAction(TranslateTeamStatChange(s));
    end else begin
      r := Ord(s[3]) - 48;
      f := Ord(s[4]) - 48;
      t := Copy(s, 5, p - 5);
      BackLog;
    end;
    team[g].reroll := r;
    team[g].ff := f;
    team[g].treasury := t;
    p2 := Pos('fans', Bloodbowl.GateLabel.caption);
    Bloodbowl.GateLabel.caption := Copy(Bloodbowl.GateLabel.caption, 1, (p2 + 4))
                           + Chr(13) +
                          'Home Eff FF ' + IntToStr(team[0].ff) + '/' +
                          'Away Eff FF ' +  IntToStr(team[1].ff);
  end else begin
    if dir = 1 then begin
      if s[3] = '1' then begin
        Gate := Gate + 1;
        AddLog('Gate increased by 1000 Fans');
      end;
      if s[3] = '2' then begin
        Gate := Gate + 5;
        AddLog('Gate increased by 5000 Fans');
      end;
      if s[3] = '3' then begin
        Gate := Gate - 1;
        AddLog('Gate decreased by 1000 Fans');
      end;
      if s[3] = '4' then begin
        Gate := Gate - 5;
        AddLog('Gate decreased by 5000 Fans');
      end;
    end else begin
      BackLog;
      if s[3] = '1' then Gate := Gate - 1;
      if s[3] = '2' then Gate := Gate - 5;
      if s[3] = '3' then Gate := Gate + 1;
      if s[3] = '4' then Gate := Gate + 5;
    end;
    p2 := Pos('fans', Bloodbowl.GateLabel.caption);
    p := Pos(Chr(13),Copy(Bloodbowl.GateLabel.caption, p2-20, 20));
    Bloodbowl.GateLabel.caption := Copy(Bloodbowl.GateLabel.caption, 1, p+(p2-21))+
      IntToStr(Gate) + '.000 cheering ' +
      Copy(Bloodbowl.GateLabel.caption,p2,length(Bloodbowl.GateLabel.caption));
  end;
end;

function CanUseTeamReroll(bga: boolean): boolean;
{bga indicates that a 4th edition BigGuy or Ally is trying to use a reroll;
 they can only use the Leader reroll, not normal team rerolls}
var b: boolean;
    f: integer;
begin
  if not(bga) and (marker[curmove, MT_Reroll].Font.size = 12) then begin
    if (marker[curmove, MT_Reroll].value > 0) then CanUseTeamReroll := true
    else begin
      b := ((marker[curmove, MT_Leader].value > 0)
            and not(team[curmove].UsedLeaderReroll));
      if b then begin
        b := false;
        for f := 1 to team[curmove].numplayers do begin
          if (player[curmove, f].status >= 1)
           and (player[curmove, f].status <= 3)
           and (player[curmove, f].HasSkill('Leader')) then b := true;
        end;
      end;
      CanUseTeamReroll := b;
    end;
  end else
  if (bga) and (marker[curmove, MT_Reroll].Font.size = 12) then begin
    if (true) then // big guy
    begin
      b := ((marker[curmove, MT_Leader].value > 0)
            and not(team[curmove].UsedLeaderReroll));
      if b then begin
        b := false;
        for f := 1 to team[curmove].numplayers do begin
          if (player[curmove, f].status >= 1)
           and (player[curmove, f].status <= 3)
           and (player[curmove, f].HasSkill('Leader')) then b := true;
        end;
      end;
      CanUseTeamReroll := b;
    end;
    if (false) then CanUseTeamReRoll := false;     // big guy
    if (true)                            // big guy
      and (player[curmove,curplayer].BigGuy) then CanUseTeamReRoll := false;
    if (true)                          // big guy
      and (player[curmove,curplayer].Ally) then CanUseTeamReRoll := true;
  end else CanUseTeamReroll := false;
end;

function UseTeamReroll: boolean;
var b: boolean;
    f, curmove2, r2, r3: integer;
begin
  if (curteam<>-1) and (curmove=-1) then curmove2 := curteam else
  if (curteam=-1) and (curmove=-1) then curmove2 := 0 else
    curmove2 := curmove;
  b := ((marker[curmove2, MT_Leader].value > 0)
        and not(team[curmove2].UsedLeaderReroll));
  if b then begin
    b := false;
    for f := 1 to team[curmove2].numplayers do begin
      if (player[curmove2, f].status >= 1) and (player[curmove2, f].status <= 3)
      and (player[curmove2, f].HasSkill('Leader')) then b := true;
    end;
    for f := 1 to team[curmove2].numplayers do begin
      if (marker[curmove2, MT_Reroll].value > 0) and
        (player[curmove2, f].status >= 1) and (player[curmove2, f].status <= 3)
        and (((player[curmove2, f].BigGuy) or (player[curmove2,f].Ally)) and
          (false)) then begin     // bigguy
          b := false;
          if (((player[curmove2,curplayer].BigGuy) or
            (player[curmove2,curplayer].Ally)) and
            (true)) then b := true;     // bigguy
      end;
    end;
  end;
  UseTeamReroll := true;
  if (true) and (player[curmove2,curplayer].Ally) then   // bigguy
    begin
      r3 := Rnd(6,3) + 1;
      Bloodbowl.comment.text := 'Roll to use Team Re-roll: '+InttoStr(r3);
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if r3 <= 3 then begin
        if (player[curmove2,curplayer].HasSkill('Pro')) and
        (not (player[curmove2,curplayer].usedSkill('Pro'))) then begin
          player[curmove2,curplayer].UseSkill('Pro');
          r2 := Rnd(6,3) + 1;
          Bloodbowl.comment.text := 'Pro Roll: '+InttoStr(r2);
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          if (r2 >= 4) then begin
            r3 := Rnd(6,3) + 1;
            Bloodbowl.comment.text := 'Pro Re-roll of Loner/Ally: '+InttoStr(r3);
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.text := 'Pro fails';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
        end;
      end;
      if r3 <= 3 then begin
        Bloodbowl.comment.text := 'Loner/Ally Roll fails! Re-roll wasted!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        UseTeamReroll := false;
      end else begin
        Bloodbowl.comment.text := 'Team Re-roll can be used';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        UseTeamReroll := true;
      end;
    end;
  if b then
    marker[curmove2, MT_Leader].MarkerMouseUp(Bloodbowl, mbRight, [], 0, 0)
  else
    marker[curmove2, MT_Reroll].MarkerMouseUp(Bloodbowl, mbRight, [], 0, 0);
end;

procedure TeamRerollPro(g,f:integer);
var bga, reroll, UReroll: boolean;
    ProAnswer: string;
begin
  bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
    and (true));  // bigguy
  reroll := CanUseTeamReroll(bga);
  if reroll then begin
    ProAnswer := 'Fail Roll';
    ProAnswer := FlexMessageBox('Pro roll failed!', 'Pro Failure',
      'Team Reroll,Fail Roll');
    if ProAnswer = 'Team Reroll' then begin
      UReroll := UseTeamReroll;
      if UReroll then begin
        Bloodbowl.comment.text := 'Pro roll failed!  Using Team Reroll to reroll Pro roll';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      end;
    end;
  end;
end;

procedure TTeam.ShowTeamDetails;
begin
  PlayerData[number,1].caption := 'Fan factor: ' + IntToStr(ff);
  PlayerData[number,2].caption := 'Asst. coaches: ' + IntToStr(asstcoaches);
  PlayerData[number,3].caption := 'Cheerleaders: ' + IntToStr(cheerleaders);
  PlayerData[number,4].caption := 'Team Rating: ' + IntToStr(tr);
  PlayerData[number,5].caption := 'Treasury: ' + treasury;
  if ((number=0) and (logo<>HomePic)) or
     ((number<>0) and (logo<>AwayPic)) then begin
    if logo = '' then begin
      if number = 0 then Bloodbowl.imPlayerImageRed.visible := false
                    else Bloodbowl.imPlayerImageBlue.visible := false;
    end else begin
      if number = 0 then begin
        if FileExists(curdir + 'roster\' + logo) then
          Bloodbowl.imPlayerImageRed.picture.LoadFromFile(curdir +
                                                         'roster\' + logo)
        else
          Bloodbowl.imPlayerImageRed.picture.LoadFromFile(
                                 curdir + 'images\noteampic.jpg');
          Bloodbowl.imPlayerImageRed.visible := true;
      end else begin
        if FileExists(curdir + 'roster\' + logo) then
          Bloodbowl.imPlayerImageBlue.picture.LoadFromFile(curdir +
                                                         'roster\' + logo)
        else
          Bloodbowl.imPlayerImageBlue.picture.LoadFromFile(
                                 curdir + 'images\noteampic.jpg');
          Bloodbowl.imPlayerImageBlue.visible := true;
      end;
    end;
    if number=0 then HomePic := logo else AwayPic := logo;
  end;
end;

procedure TTeam.TeamMouseMove(Sender: TObject; Shift: TShiftState;
                            X, Y: Integer);
begin
  ShowTeamDetails;
end;

procedure PlayActionRemoveACCH(s: string; dir: integer);
var g: integer;
    f: string;
begin
  g := Ord(s[2]) - 48;
  f := s[3];
  if dir = 1 then begin
    if f = 'C' then begin
      team[g].cheerleaders := team[g].cheerleaders - 1;
      AddLog('Cheerleader removed from ' + team[g].name);
    end;
    if f = 'A' then begin
      team[g].asstcoaches := team[g].asstcoaches - 1;
      AddLog('Assistant Coach removed from ' + team[g].name);
    end;
  end else begin
    if f = 'C' then begin
      team[g].cheerleaders := team[g].cheerleaders + 1;
    end;
    if f = 'A' then begin
      team[g].asstcoaches := team[g].asstcoaches + 1;
    end;
    BackLog;
  end;
end;

end.
