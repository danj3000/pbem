unit unitPlayer;
                                                                                                     
interface

uses Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

const STATUS_BALL_CARRIER = 2;

type
  TmodPlayer = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  modPlayer: TmodPlayer;

type TPlayer = class(TLabel)
  private
    function GetPlayerSPP() : Integer;
public

  {default things}
  teamnr, number, cnumber, cnumber0: integer;
  name, name0, position, position0, picture, picture0, icon, icon0: string;
  {injuries?}
  inj: string;
  {position on field}
  p, q: integer;
  {status of player}
  status, SIstatus, SOstatus, SOSIstatus, SIAgestatus: integer;
  {SPP scored during match}
  int, td, cas, comp, mvp, otherSPP, exp: integer;
  {SPP at start of the match}
  int0, td0, cas0, comp0, mvp0, otherSPP0, exp0: integer;
  {current stats}
  ma, st, ag, av: integer;
  skill: array [1..15] of string;
  BigGuy, Ally: boolean;
  {stats at start of match}
  ma0, st0, ag0, av0: integer;
  skill0: array [1..15] of string;
  BigGuy0, Ally0: boolean;
  {value of player x 5k}
  value, value0: integer;
  {number of skillrolls earned}
  skillrolls: integer;
  {skill rolls already made... max 3 skill rolls available per player}
  SkillRollsMade: array [1..3, 0..1] of integer;
  SkillsGained: array [1..3] of string;
  {Level of skill gained and any aging effect from the skill?}
  SkillLevel: array [1..3] of integer;
  SkillAging: array [1..3] of string;
  SkillAgingRollsMade: array [1..3, 0..1] of integer;
  SkillAgingEffectRollsMade: array [1..3, 0..1] of integer;
  {Side Step programming}
  SideStep: array[1..3] of integer;
  {indicator: has player a tacklezone?}
  tz: integer;
  {is player peaked?}
  peaked: boolean;
  {match markers}
  PlayedThisDrive, PlayedThisMatch, UsedRegeneration: boolean;
  {turn markers}
  uskill: array [1..15] of boolean;
  UsedMA, LastAction, FirstBlock, SecondBlock, TIKSTPK, GFI, StunStatus: integer;
    {LastAction: 0=status change, 1=move, 2=block}
    {FirstBlock: 0=no block yet, 1=blitzing, 2=blocking}
    {SecondBlock: 0=if not blocked yet, 1=if already blocked}
    {TIKSTPK is used to track the blow up a Gnomish Contraption}
    {GFI is used to track Progressive GFI}
    {StunStatus is used to track players automatically turning from Stun
      to prone}

  function GetStartingSPP(): Integer;
  function GetMatchSPP(): Integer;
  constructor New(form: TForm; tm, nr: integer);

  procedure PlayerMouseDown(Sender: TObject; Button: TMouseButton;
                            Shift: TShiftState; X, Y: Integer);
  procedure PlayerStartDrag(Sender: TObject; var DragObject: TDragObject);
  procedure PlayerEndDrag(Sender, Target: TObject; X, Y: Integer);
  procedure PlayerDragDrop(Sender, Source: TObject; X, Y: Integer);
  procedure PlayerMouseMove(Sender: TObject; Shift: TShiftState;
                            X, Y: Integer);
  procedure PlayerDragOver(Sender, Source: TObject; X, Y: Integer;
                           State: TDragState; var Accept: Boolean);
  procedure StartMoveToField;
  procedure MoveToField(p0, q0, st: integer);
  procedure SetStatusDef(st: integer);
  procedure SetStatus(newStatus: integer);
  function MakeCurrent: string;
  procedure ShowPlayerDetails;
  procedure Redraw;
  function GetPlayerName: string;
  procedure SetSkill(s: string; translate: boolean); overload;
  procedure SetSkill(s: string); overload;
  function GetSkillString(i: integer): string;
  function hasSkill(s: string): boolean;
  function Get1Skill(s: string): string;
  function hasNewSkills: boolean;
  procedure RestoreSkills;
  procedure SetSkillsToDefault;
  function usedSkill(s: string): boolean;
  procedure UseSkill(s: string);
  function GetSaveString: string;
end;

procedure RedrawDugout;
procedure PlayActionMakeCurrent(s: string; dir: integer);
procedure PlayActionUncur(s: string; dir: integer);
procedure UnCur;
function UnCurSub: string;
procedure PlayActionUseSkill(s: string; dir: integer);
procedure PlayActionFieldPlayer(s: string; dir: integer);
procedure PlayActionMoveToReserve(s: string; dir: integer);
procedure PlayActionBlockMove(s: string; dir: integer);
procedure PlayActionEndOfMove(s: string; dir: integer);
procedure PlayActionResetMove(s: string; dir: integer);
procedure PlayActionPlayerMove(s: string; dir: integer);
procedure PlayActionBombPlayer(s: string; dir: integer);
procedure PlacePlayer(f, g, p, q: integer);
function TranslateSetStatus(s: string): string;
procedure PlayActionSetStatus(s: string; dir: integer);
procedure PlayActionSPP(s: string; dir: integer);
procedure PlayActionReverseSPP(s: string; dir: integer);
procedure PlayActionToggleTackleZone(s: string; dir: integer);
procedure PlayActionPlayerStatChange(s: string; dir: integer);
procedure PlayActionColorChange(s: string; dir: integer);
procedure LeftClickPlayer(g,f: integer);

implementation

uses bbunit, bbalg, unitLog, unitPlayAction, unitBall, unitField,
     unitMarker, unitPass, unitKick, unitPickUp, unitSettings, unitRandom,
     unitCatch, unitArmourRoll, unitTeam, unitLanguage, unitThrowTeamMate,
     unitThrowStuff, unitMessage;

{$R *.DFM}

var curbefore: integer;

constructor TPlayer.New(form: TForm; tm, nr: integer);
begin
  inherited Create(form);

  {Label settings}
  autosize := false;
  caption := IntToStr(nr);
  height := 19;
  width := 19;
  visible := true;
  Transparent := false;
  alignment := taCenter;
  font.size := 12;
  showhint := true;
  DragMode := dmAutomatic;
  OnMouseDown := PlayerMouseDown;
  OnMouseMove := PlayerMouseMove;
{  OnMouseUp := PlayerMouseUp;}
{  OnClick := PlayerClick;
  OnDblClick := PlayerClick;}
  OnStartDrag := PlayerStartDrag;
  OnEndDrag := PlayerEndDrag;
  OnDragOver := PlayerDragOver;
  OnDragDrop := PlayerDragDrop;
  parent := form;

  {other settings}
  teamnr := tm;
  number := nr;
  cnumber := nr;
  status := 0;
  PlayedThisMatch := false;
  PlayedThisDrive := false;
  UsedRegeneration := false;
  TIKSTPK := 0;
  UsedMA := 0;
end;

procedure ShowCurrentPlayer(g, f: integer);
begin
  case player[g,f].status of
    0: player[g,f].popupmenu := Bloodbowl.reservePopup;
    1, 2, 3, 4: player[g,f].popupmenu := Bloodbowl.playerPopup;
    5, 6, 7, 8, 9, 10, 11, 12, 13, 14: player[g,f].popupmenu := Bloodbowl.koPopup;
  end;
  
  player[g,f].ShowPlayerDetails;
  Bloodbowl.CurBox.left := player[g,f].left - 1;
  Bloodbowl.CurBox.top := player[g,f].top - 1;
  Bloodbowl.CurBox.visible := true;
  Bloodbowl.CurBox.Parent := player[g,f].parent;
  Bloodbowl.CurBox.BringToFront;
  if ref then Bloodbowl.CurBox.Refresh;
  player[g,f].BringToFront;
  if ref then player[g,f].Refresh;
end;

procedure TPlayer.PlayerStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var s, lostcontrol, BANG, RerollAnswer, s2, WAAnswer: string;
    f, g, f0, f2, Bhead, RSHelp, curturn, playermovement, r, btr, StunNo,
      WATarget: integer;
    WACheck, GGCheck, BaCCheck, bga, proskill, reroll, WARoll, UReroll: boolean;
begin
  if (GameStatus <> 'Pass') and (GameStatus <> 'HGaze')
    and (GameStatus <> 'Chill') and (GameStatus <> 'Ethereal')
    and (GameStatus <> 'Mace Tail') and (GameStatus <> 'Shadow')
    and (GameStatus <> 'ThrowTeamMate1') and (GameStatus <> 'ThrowTeamMate2') and
    (GameStatus <> 'Kick') and (GameStatus <> 'PitchPlayer1') and
    (GameStatus <> 'Dirty Kick') and (GameStatus <> 'Bear Hug') and
    (GameStatus <> 'Punt') and (GameStatus <> 'BulletThrow') and
    (GameStatus <> 'Dig1') and (GameStatus <> 'Bomb') and
    (GameStatus <> 'StinkBomb') and (GameStatus <> 'BigBomb') and
    (GameStatus <> 'Net') and  (GameStatus <> 'Stab') and
    (GameStatus <> 'ThrowinMovement') and (GameStatus <> 'AccurateKick') and
    (GameStatus <> 'Apoth1') and (GameStatus <> 'Apoth2') and
    (GameStatus <> 'Apoth4') and (GameStatus <> 'Apoth5')
    then begin
    Bloodbowl.comment.Text := '';
    curbefore := 50 * curteam + curplayer;
    if frmSettings.cbDeStun.Checked then StunNo := 3 else StunNo := 4;
    {D6 Movement code}
    f := (Sender as TPlayer).number;
    g := (Sender as TPlayer).teamnr;
    Bhead := 0;
    s := (Sender As TPlayer).MakeCurrent;
    if (s <> '') and CanWriteToLog then LogWrite(s);
    if (player[g,f].HasSkill('MA D6')) and
     (not (player[g,f].usedSkill('MA D6'))) and (g = curmove)
       then begin
         Bloodbowl.comment.text := 'Roll for D6 Movement for this player:';
         Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         player[g,f].UseSkill('MA D6');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         if CanWriteToLog then begin
           s := 'u' + Chr(g + 48) + Chr(f + 64) +
             Chr(player[g,f].ma + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1) + '|' +
             Chr(lastroll + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1);
           LogWrite(s);
           PlayActionPlayerStatChange(s, 1);
         end;
       end;
    {End D6 Movement Code}
    if (player[g,f].HasSkill('MA D6+1')) and
     (not (player[g,f].usedSkill('MA D6+1'))) and (g = curmove)
       then begin
         Bloodbowl.comment.text := 'Roll for D6+1 Movement for this player:';
         Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         player[g,f].UseSkill('MA D6+1');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         if CanWriteToLog then begin
           s := 'u' + Chr(g + 48) + Chr(f + 64) +
             Chr(player[g,f].ma + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1) + '|' +
             Chr((lastroll+1) + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1);
           LogWrite(s);
           PlayActionPlayerStatChange(s, 1);
         end;
       end;
    {End D6+1 Movement Code}
    {TIKSTPK}
    if ((player[g,f].HasSkill('TIKSTPK')) and
      (not (player[g,f].usedSkill('TIKSTPK'))) and (g = curmove))
      then begin
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));   // big guy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll <= 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('TIKSTPK roll has failed!'
               , 'TIKSTPK roll Failure',
               'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('TIKSTPK roll failed!'
               , 'TIKSTPK Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'TIKSTPK reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
       if (lastroll <= 1) then begin
          if CanWriteToLog then begin
            s := 'U-' + Chr(g + 48) + Chr(f + 64);
            LogWrite(s);
            PlayActionToggleTackleZone(s, 1);
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
          curturn := 0;
          for f2 := 1 to 8 do begin
            if turn[g,f2].color = clYellow then curturn := (HalfNo * 10) + f2;
          end;
          BANG := '';
          if curturn <= (player[g,f].TIKSTPK + 1) then begin
            BANG := player[g,f].name + ' EXPLODES!!!';
            Bloodbowl.comment.text := BANG;
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            player[g,f].SetStatus(8);
          end;
        end;
        player[g,f].UseSkill('TIKSTPK');
      end;
     {End of TIKSTPK}
    {Bone-head/Really Stupid}
    if (((player[g,f].HasSkill('Bonehead')) and
      (not (player[g,f].usedSkill('Bonehead'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Bone-head')) and
      (not (player[g,f].usedSkill('Bone-head'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Really Stupid')) and
      (not (player[g,f].usedSkill('Really Stupid'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Cold Blooded')) and
      (not (player[g,f].usedSkill('Cold Blooded'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Cold Natured')) and
      (not (player[g,f].usedSkill('Cold Natured'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Stone Cold Stupid')) and
      (not (player[g,f].usedSkill('Stone Cold Stupid'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Pride')) and
      (not (player[g,f].usedSkill('Pride'))) and (g = curmove)))
      and (player[g,f].status >= 1) and (player[g,f].status <= StunNo)
      and (player[g,f].UsedMA <> 15)
      then begin
        if (player[g,f].HasSkill('Bonehead')) then begin
          player[g,f].UseSkill('Bonehead');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Bone-head')) then begin
          player[g,f].UseSkill('Bone-head');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Really Stupid')) then begin
          player[g,f].UseSkill('Really Stupid');
          Bhead := 3;
        end else
        if (player[g,f].HasSkill('Pride')) then begin
          player[g,f].UseSkill('Pride');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Cold Natured')) then begin
          player[g,f].UseSkill('Cold Natured');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Cold Blooded')) then begin
          player[g,f].UseSkill('Cold Blooded');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Stone Cold Stupid')) then begin
          player[g,f].UseSkill('Stone Cold Stupid');
          Bhead := 3;
        end;
        if (player[g,f].HasSkill('Really Stupid')) or
          (player[g,f].HasSkill('Stone Cold Stupid')) then begin
          RSHelp := CountNoBhead(g, f);
          if RSHelp > 0 then Bhead := 1;
        end;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));   // big guy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= Bhead) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll <= Bhead then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Bone-head/Stupid roll has failed!'
               , 'Bone-head/Stupid roll Failure',
               'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Bone-head/Stupid roll failed!'
               , 'Bone-Head/Stupid Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Bone-head/Stupid reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
        if (lastroll > Bhead) and (player[g, f].tz > 0) then begin
          if CanWriteToLog then begin
            s := 'U+' + Chr(g + 48) + Chr(f + 64);
            LogWrite(s);
            PlayActionToggleTackleZone(s, 1);
          end;
        end else if (lastroll <= Bhead) and (player[g, f].tz = 0) then begin
          if CanWriteToLog then begin
            s := 'U-' + Chr(g + 48) + Chr(f + 64);
            LogWrite(s);
            PlayActionToggleTackleZone(s, 1);
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
        end else if (lastroll <= Bhead) then begin
          if CanWriteToLog then begin
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
        end;
      end;
    {End of Bone-head/Really Stupid}
    {Greater Glory Check}
    GGCheck := false;
    if (not(player[g,f].HasSkill('Greater Glory'))) and (g = curmove) then begin
      GGCheck := false;
      for f0 := 1 to team[g].numplayers do begin
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Greater Glory')) and
          (player[g,f0].font.size = 12)
          then GGCheck := true;
      end;
      if GGCheck then
        Bloodbowl.Loglabel.caption :=
          'YOU HAVE FORGOTTEN TO MOVE A GREATER GLORY PLAYER BEFORE THIS ' +
          'PLAYER!';
    end;
    if (Bloodbowl.Loglabel.caption =
      'YOU HAVE FORGOTTEN TO MOVE A GREATER GLORY PLAYER BEFORE THIS PLAYER!') and
      not(GGCheck) then Bloodbowl.Loglabel.caption := '';
    {End of Greater Glory Check}
    {Wild Animal - Old Check}
    WACheck := false;
    if (not(player[g,f].HasSkill('Wild Animal')))
      and ((not(player[g,f].HasSkill('Maniac')))
      and (not(player[g,f].HasSkill('Easily Confused'))))
      and (g = curmove) then begin
      WACheck := false;
      for f0 := 1 to team[g].numplayers do begin
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Wild Animal')) and
          (player[g,f0].font.size = 12) and (false) // Wild animal
          then WACheck := true;
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Maniac')) and
          (player[g,f0].font.size = 12)
          then WACheck := true;
      end;
      if WACheck then
        Bloodbowl.Loglabel.caption :=
          'YOU HAVE FORGOTTEN TO MOVE A WILD ANIMAL or MANIAC PLAYER BEFORE THIS PLAYER!';
    end;
    if (Bloodbowl.Loglabel.caption =
      'YOU HAVE FORGOTTEN TO MOVE A WILD ANIMAL PLAYER or MANIAC BEFORE THIS PLAYER!') and
      not(WACheck) then Bloodbowl.Loglabel.caption := '';
    {End of Wild Animal - Old Check}
    {Wild Animal - New Check}
    if (player[g,f].HasSkill('Wild Animal')) and
      (not (player[g,f].usedSkill('Wild Animal'))) and (g = curmove)
      and (player[g,f].status >= 1) and (player[g,f].status <= StunNo) and
      (true)  // Wild animal
      and (player[g,f].UsedMA <> 15)
      then begin
        WAAnswer :=
          FlexMessageBox('Are you Blocking or Blitzing with this Wild Animal?'
          , 'Wild Animal Question',
          'Yes,No');
        if WAAnswer='Yes' then begin
          WATarget := 2;
          Bloodbowl.comment.text := 'Wild Animal is blocking or blitzing';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else WATarget := 4;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));    // bigguy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll < WATarget) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll < WATarget then begin
          ReRollAnswer := 'Fail Roll';
          if reroll and proskill then begin
            ReRollAnswer := FlexMessageBox('Wild Animal roll has failed!'
             , 'Wild Animal roll Failure',
             'Use Pro,Team Reroll,Fail Roll');
          end else if proskill then ReRollAnswer := 'Use Pro' else
          if reroll then begin
            ReRollAnswer := FlexMessageBox('Wild Animal roll failed!'
             , 'Wild Animal Failure', 'Fail Roll,Team Reroll');
          end;
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Wild Animal reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[g,f].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(g,f);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if (lastroll < WATarget) then begin
          player[g,f].UseSkill('Wild Animal');
          if CanWriteToLog then begin
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
        end else begin
          player[g,f].UseSkill('Wild Animal');
        end;
    end;
    {End of Wild Animal - New Check}
    {Ball and Chain Check}
    BaCCheck := false;
    if (not(player[g,f].HasSkill('Ball and Chain'))) and (g = curmove) then begin
      BaCCheck := false;
      for f0 := 1 to team[g].numplayers do begin
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Ball and Chain')) and
          (player[g,f0].font.size = 12)
          then BaCCheck := true;
      end;
      if BaCCheck then
        Bloodbowl.Loglabel.caption :=
          'YOU HAVE FORGOTTEN TO MOVE A BALL AND CHAIN PLAYER BEFORE THIS ' +
          'PLAYER!';
    end;
    if (Bloodbowl.Loglabel.caption =
      'YOU HAVE FORGOTTEN TO MOVE A BALL AND CHAIN PLAYER BEFORE THIS PLAYER!') and
      not(BaCCheck) then Bloodbowl.Loglabel.caption := '';
    {End of Ball and Chain Check}
    {Uncontrollable}
    if ((player[g,f].HasSkill('Uncontrollable')) and
      (not (player[g,f].usedSkill('Uncontrollable'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= 3) and
      (player[g,f].UsedMA <> 15)
      then begin
         player[g,f].UseSkill('Uncontrollable');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         lostcontrol := '';
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
             and (true));   // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
             (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll <= 1 then begin
            ReRollAnswer := 'Fail Roll';
            if reroll and proskill then begin
              ReRollAnswer := FlexMessageBox('Uncontrollable roll has failed!'
                , 'Uncontrollable Failure',
                'Use Pro,Team Reroll,Fail Roll');
            end else if proskill then ReRollAnswer := 'Use Pro' else
            if reroll then begin
              ReRollAnswer := FlexMessageBox('Uncontrollable roll failed!'
                , 'Uncontrollable Failure', 'Fail Roll,Team Reroll');
            end;
          end;
          if ReRollAnswer='Team Reroll' then begin
            UReroll := UseTeamReroll;
            if UReroll then begin
              Bloodbowl.comment.text := 'Uncontrollable reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
          end;
          if ReRollAnswer='Use Pro' then begin
             player[g,f].UseSkill('Pro');
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
             if lastroll <= 3 then TeamRerollPro(g,f);
             if (lastroll <= 3) then lastroll := 1;
             if (lastroll >= 4) then begin
               Bloodbowl.comment.text := 'Pro reroll';
               Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
               Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
             end;
          end;
         if lastroll = 1 then begin
           lastroll := Rnd(8,6) + 1;
           lostcontrol := 'Uncontrollable roll failed -- Random Movement: ';
           if lastroll = 1 then lostcontrol := lostcontrol + 'Up Left ' else
           if lastroll = 2 then lostcontrol := lostcontrol + 'Up ' else
           if lastroll = 3 then lostcontrol := lostcontrol + 'Up Right ' else
           if lastroll = 4 then lostcontrol := lostcontrol + 'Left ' else
           if lastroll = 5 then lostcontrol := lostcontrol + 'Right ' else
           if lastroll = 6 then lostcontrol := lostcontrol + 'Down Left ' else
           if lastroll = 7 then lostcontrol := lostcontrol + 'Down ' else
           if lastroll = 8 then lostcontrol := lostcontrol + 'Down Right ';
           lastroll := Rnd(6,6) + 1;
           lostcontrol := lostcontrol + InttoStr(lastroll) + ' squares';
           Bloodbowl.comment.text := lostcontrol;
           Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         end;
      end;
    {End of Uncontrollable}
    {Blood Lust}
    if ((player[g,f].HasSkill('Blood Lust')) and
      (not (player[g,f].usedSkill('Blood Lust'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= 3)
      then begin
         player[g,f].UseSkill('Blood Lust');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));     // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll = 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Blood Lust roll failed!'
               , 'Blood Lust Failure', 'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Blood Lust roll failed!'
               , 'Blood Lust Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Blood Lust reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
         if lastroll = 1 then begin
            Bloodbowl.comment.text := player[g,f].name + ' fails his Blood Lust' +
              ' roll and must feed off off another player from your team or leave' +
              ' the pitch!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
      end;
    {End of Blood Lust}
    {Bloodthirst}
    if ((player[g,f].HasSkill('Bloodthirst')) and
      (not (player[g,f].usedSkill('Bloodthirst'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= 3)
      then begin
         player[g,f].UseSkill('Bloodthirst');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));    // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll = 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Bloodthirst roll failed!'
               , 'Bloodthirst Failure', 'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Bloodthirst roll failed!'
               , 'Bloodthirst Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Bloodthirst reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
         if lastroll = 1 then begin
            Bloodbowl.comment.text := player[g,f].name + ' fails his Bloodthirst' +
              ' roll and must feed off off another player from your team or leave' +
              ' the pitch!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
      end;
    {End of Bloodthirst}
    {On Pitch Take Root}
    if ((player[g,f].HasSkill('Take Root')) and
      (not (player[g,f].usedSkill('Take Root'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= StunNo) and
      (frmSettings.cbOPTakeRoot.checked) and (player[g,f].ma <> 0) and
      (player[g,f].font.size = 12)
      then begin
         player[g,f].UseSkill('Take Root');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));          // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll = 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Take Root roll failed!'
               , 'Take Root Failure', 'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Take Root roll failed!'
               , 'Take Root Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Take Root reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
         if lastroll = 1 then begin
           if CanWriteToLog then begin
             Bloodbowl.comment.text := player[g,f].name + ' fails his Take Root ' +
               'roll and has MA zero for the rest of this drive! (he cannot GFI ' +
               'or follow-up on blocks either!';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
               Chr(player[g, f].ma + 48) +
               Chr(player[g, f].st + 48) +
               Chr(player[g, f].ag + 48) +
               Chr(player[g, f].av + 48) +
               Chr(player[g,f].cnumber + 64) +
               Chr(player[g,f].value div 5 + 48) +
               player[g,f].name + '$' +
               player[g,f].position + '$' +
               player[g,f].picture + '$' +
               player[g,f].icon + '$' +
               player[g, f].GetSkillString(1) + '|' +
               Chr(0 + 48) +
               Chr(player[g, f].st + 48) +
               Chr(player[g, f].ag + 48) +
               Chr(player[g, f].av + 48) +
               Chr(player[g,f].cnumber + 64) +
               Chr(player[g,f].value div 5 + 48) +
               player[g,f].name + '$' +
               player[g,f].position + '$' +
               player[g,f].picture + '$' +
               player[g,f].icon + '$' +
               player[g, f].GetSkillString(1);
             LogWrite(s2);
             PlayActionPlayerStatChange(s2, 1);
           end;
         end;
      end;
    {Start of Ball and Chain TZ check}
    if ((player[g,f].HasSkill('Ball and Chain')) and (player[g,f].status >= 0)
      and (player[g,f].status <= 4) and (player[g, f].tz = 0))
      then begin
        if CanWriteToLog then begin
          s := 'U-' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s);
          PlayActionToggleTackleZone(s, 1);
        end;
      end;
    {End of Ball and Chain TZ check}
    {Rooted, Swamped, Netted}
    if (((player[g,f].HasSkill('Rooted')) and (not (player[g,f].usedSkill('Rooted'))))
     or ((player[g,f].HasSkill('Swamped')) and (not (player[g,f].usedSkill('Swamped'))))
     or ((player[g,f].HasSkill('Netted')) and (not (player[g,f].usedSkill('Netted')))))
      and (g = curmove) and (player[g,f].status >= 1) and (player[g,f].status <= 3)
      then begin
        r := 7 - (player[g,f].st);
        if player[g,f].HasSkill('Swamped') then begin
          player[g,f].UseSkill('Swamped');
        end else if player[g,f].HasSkill('Rooted') then begin
          player[g,f].UseSkill('Rooted');
        end else begin
          player[g,f].UseSkill('Netted');
        end;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if (player[g,f].HasSkill('Rooted')) and (lastroll<>1) and (lastroll<>6)
          then begin
            lastroll := lastroll - 1;
            Bloodbowl.comment.text := '-1 modifier to roll for Call Roots spell';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;

        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true));    // bigguy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll < r) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll < r then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Strength roll to move has failed!'
               , 'Strength roll Failure',
               'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Strength roll to move has failed!'
               , 'Strength roll Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Strength roll reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
             if (player[g,f].HasSkill('Rooted')) and (lastroll<>1) and (lastroll<>6)
               then begin
               lastroll := lastroll - 1;
               Bloodbowl.comment.text := '-1 modifier to roll for Call Roots spell';
               Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             end;
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              if (player[g,f].HasSkill('Rooted')) and (lastroll<>1) and (lastroll<>6)
                 then begin
                 lastroll := lastroll - 1;
                 Bloodbowl.comment.text := '-1 modifier to roll for Call Roots spell';
                 Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              end;
            end;
         end;
         if lastroll>=r then begin
          if player[g,f].HasSkill('Swamped') then begin
              Bloodbowl.comment.text := player[g,f].name + ' breaks free of the ' +
                'of the Swamped spell, Stats Change to remove Swamped skill';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
              Bloodbowl.comment.text := player[g,f].name + ' roll successful, player ' +
                'moves normally this turn';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
        end else begin
          if player[g,f].HasSkill('Netted') then begin
            Bloodbowl.comment.text := player[g,f].name + ' roll FAILED!, player ' +
             'movement halved this turn and player CANNOT GFI';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.text := player[g,f].name + ' roll FAILED!, player ' +
             'movement zero for this turn';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
          if player[g,f].HasSkill('Netted') then begin
            playermovement := (player[g,f].ma div 2);
            if (player[g,f].ma mod 2)<>0 then playermovement := playermovement + 1;
          end else playermovement := player[g,f].ma + 3;
          s := 'M' + Chr(g + 48) + Chr(f + 65) +
             Chr(player[g,f].p + 65) +
             Chr(player[g,f].q + 65) +
             Chr(player[g,f].p + 65) + Chr(player[g,f].q + 65) +
             Chr(player[g,f].UsedMA + 65) + Chr(playermovement + 65);
          LogWrite(s);
          PlayActionPlayerMove(s, 1);
        end;
    end;
    {End of Rooted, Swamped, and Netted}
  end;
end;

function TPlayer.GetStartingSPP : Integer;
begin
    Result := comp0 + 3 * td0 +
          2 * cas0 + 2 * int0 +
          bbalg.MVPValue * mvp0 + otherSPP0 +
          exp0;
end;

function TPlayer.GetMatchSPP : Integer;
begin
   Result := comp + 3 * td +
          2 * cas + 2 * int +
          bbalg.MVPValue * mvp + otherSPP +
          exp;
end;

procedure TPlayer.PlayerMouseDown(Sender: TObject; Button: TMouseButton;
                                  Shift: TShiftState; X, Y: Integer);
var f, g, k, l: integer;
    s: string;
begin
  f := (Sender as TPlayer).number;
  g := (Sender as TPlayer).teamnr;
  s := player[g,f].MakeCurrent;
end;

procedure TPlayer.PlayerEndDrag(Sender, Target: TObject; X,
  Y: Integer);
var f, g, f0, g0, pb, k, l, targetaction, test1, test2, r, p,
    NiggleCount, totspp, Shadowroll, pplace, qplace, assa, assd,
    ascount, dist1, dist2, finaldist, t, u, v, w, ploc, qloc, arrow,
    dk1, dk2, dk3, TestP, TestQ, NewP, NewQ, NewP2, NewQ2, NewP3, NewQ3,
    FinalP, FinalQ, FinalDK, RollNeed, KickP, KickQ, DKRoll, HGazeTarget: integer;
  test3, test4, test5, test6, SPP4th, b, bx, BThrow, bga, reroll, proskill,
    Ballscatter, UReroll: boolean;
  s, BlockDie, RerollAnswer, StatTemp: string;
  tz,  tz0: TackleZones;
begin
  if (GameStatus = 'Pass') or (GameStatus = 'BulletThrow') then begin
    Bthrow := GameStatus = 'BulletThrow';
    if ((Sender as TPlayer).status = 1) then begin
      g := 0;
      while (g <= 1) do begin
        f := 1;
        while (g <= 1) and (f <= team[g].numplayers) do begin
          if player[g,f].status = 2 then begin
            Bloodbowl.Endofmove1Click(Bloodbowl);
            pb := CountPB(g, f, player[(Sender as TPlayer).teamnr,
              (Sender as TPlayer).number].p, player[(Sender as TPlayer).teamnr,
              (Sender as TPlayer).number].q, true);
            if (pb > 0) and not(Bthrow) then begin
              Application.Messagebox('Opponent might be able to Pass Block!',
               'Bloodbowl Pass Block Warning', MB_OK);
            end;
            ActionTeam := g;
            ActionPlayer := f;
            if (not(frmSettings.cbLateInt.checked)) and (not(Bthrow)) then
              DetermineInterceptors(g, f, player[(Sender as TPlayer).teamnr,
              (Sender as TPlayer).number].p, player[(Sender as TPlayer).teamnr,
              (Sender as TPlayer).number].q);
            if player[g,f].status = 2 then
              ShowPassPlayerToPlayer(g, f,
              (Sender as TPlayer).teamnr, (Sender as TPlayer).number, Bthrow);
            g := 2;
            f := 99;
            ActionTeam := 0;
            ActionPlayer := 0;
          end;
          f := f + 1;
        end;
        g := g + 1;
      end;
    end;
    GameStatus := '';
    if frmPass.txtBulletThrow.Visible then begin
      frmPass.txtBulletThrow.Visible := false;
      frmArmourRoll.txtDPInjMod.text := '+' + bbAlg.DirtyPlayerInjuryModifier.ToString();
    end;

  end else if (GameStatus = 'Bomb') or (GameStatus = 'BigBomb') or
    (GameStatus = 'Net') or (GameStatus = 'StinkBomb') then begin
    StatTemp := GameStatus;
    Bloodbowl.Endofmove1Click(Bloodbowl);
    if StatTemp = 'Bomb' then
      ShowStuffPlayerToPlayer(ActionTeam, ActionPlayer,
        (Sender as TPlayer).teamnr, (Sender as TPlayer).number, 1)
    else if StatTemp = 'StinkBomb' then
      ShowStuffPlayerToPlayer(ActionTeam, ActionPlayer,
        (Sender as TPlayer).teamnr, (Sender as TPlayer).number, 2)
    else if StatTemp = 'BigBomb' then
      ShowStuffPlayerToPlayer(ActionTeam, ActionPlayer,
        (Sender as TPlayer).teamnr, (Sender as TPlayer).number, 3)
    else if StatTemp = 'Net' then
      ShowStuffPlayerToPlayer(ActionTeam, ActionPlayer,
        (Sender as TPlayer).teamnr, (Sender as TPlayer).number, 4);
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if (GameStatus = 'ThrowTeamMate2') and
    (player[ThrownTeam,ThrownPlayer].hasSkill('Flyer')) then begin
    Bloodbowl.Endofmove1Click(Bloodbowl);
    ShowThrowPlayer(ActionTeam, ActionPlayer, ThrownTeam, ThrownPlayer,
       (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].p),
       (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].q));
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus = 'Kick' then begin
    pplace := abs((player[(Sender as TPlayer).teamnr,
                (Sender as TPlayer).number].p) - (player[curteam,curplayer].p));
    qplace := abs((player[(Sender as TPlayer).teamnr,
                (Sender as TPlayer).number].q) - (player[curteam,curplayer].q));
    if (pplace <= 1) and (qplace<=1) and not((pplace=0) and (qplace=0)) then
    begin
      if ((Sender as TPlayer).status >= 1) and ((Sender as TPlayer).status <= 4)
      then begin
        g := 0;
        while (g <= 1) do begin
          f := 1;
          while (g <= 1) and (f <= team[g].numplayers) do begin
            if player[g,f].status = 2 then begin
              Bloodbowl.Endofmove1Click(Bloodbowl);
              pb := CountPB(g, f, player[g,f].p, player[g,f].q, false);
              if pb > 0 then begin
                Application.Messagebox('Opponent might be able to Pass Block!',
                 'Bloodbowl Pass Block Warning', MB_OK);
              end;
              ShowKickToField(g, f, player[(Sender as TPlayer).teamnr,
                (Sender as TPlayer).number].p, player[(Sender as TPlayer).teamnr,
                (Sender as TPlayer).number].q);
              g := 2;
              f := 99;
              if GameStatus = 'Field Goal' then begin
               Bloodbowl.Loglabel.caption := 'FIELD GOAL!!!!  Set-up for new drive';
              end;
            end;
            f := f + 1;
          end;
          g := g + 1;
        end;
      end;
      frmKick.cbFGAttempt.Checked := false;
      if (GameStatus <> 'AccurateKick') and (GameStatus<>'PoochKick') then begin
        for g := 0 to 14 do begin
          for f := 0 to 25 do begin
            KickField[g,f] := 0;
            field[g,f].color := clGreen;
            field[g,f].transparent := true;
          end;
        end;
        GameStatus := '';
        ActionTeam := 0;
        ActionPlayer := 0;
      end else begin
        Bloodbowl.Loglabel.caption := 'Click the Yellow square or player in the '
          + 'identified range to kick to.  Squares less than the distance kicked '
          + 'next to sideline if selected indicates the ball is kicked out of bounds';
      end;
    end;

  end else if GameStatus='HGaze' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  ((player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 1) and (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 2));
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be gazing an adjacent standing opponent',
       'Bloodbowl Hypnotic Gaze Warning', MB_OK);
    end else begin
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if ((Uppercase(team[ActionTeam].race) = 'VAMPIRE - LAHMIAN') or
        (Uppercase(team[ActionTeam].race) = 'VAMPIRE-LAHMIAN')) and
        (frmSettings.cbVampireLahmian.checked) and
        (Pos('VAMPIRE', Uppercase(player[ActionTeam,ActionPlayer].position)) > 0)
          then begin
          if (lastroll<>1) and (lastroll<>6) then begin
            lastroll := lastroll + 1;
            Bloodbowl.comment.Text := '+1 bonus to dice roll for Lahmian Vampire team';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
      end;
      bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
        (player[ActionTeam,ActionPlayer].Ally))
        and (true)); // bigguy
      proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
        and (lastroll <= 1) and
        (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
        and (ActionTeam = curmove);
      reroll := CanUseTeamReroll(bga);
      tz := CountTZBlockCA(ActionTeam,ActionPlayer);
      if (frmSettings.rgHGaze.ItemIndex=1) then HGazeTarget := 1 else
      if (frmSettings.rgHGaze.ItemIndex=2) then
        HGazeTarget := 6 - player[ActionTeam,ActionPlayer].ag + (tz.num - 1) else
        HGazeTarget := player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].ag;
      if lastroll <= HGazeTarget then begin
        ReRollAnswer := 'Fail Roll';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Hypnotic Gaze roll has failed!'
            , 'Hypnotic Gaze Failure',
            'Use Pro,Team Reroll,Fail Roll');
        end else if proskill then begin
          ReRollAnswer := FlexMessageBox('Hypnotic Gaze roll has failed!'
            , 'Hypnotic Gaze Failure',
            'Use Pro,Fail Roll');
        end else if reroll then begin
          ReRollAnswer := FlexMessageBox('Hypnotic Gaze roll failed!'
            , 'Hypnotic Gaze Failure', 'Fail Roll,Team Reroll');
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Hypnotic Gaze reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[ActionTeam,ActionPlayer].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
      end;
      if lastroll>HGazeTarget then begin
        player[ActionTeam,ActionPlayer].UseSkill('Hypnotic Gaze');
        Bloodbowl.comment.text := 'Hypnotic Gaze successful';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        s := 'U-' + Chr((Sender as Tplayer).teamnr + 48) +
           Chr((Sender as Tplayer).number + 64);
        LogWrite(s);
        PlayActionToggleTackleZone(s, 1);
      end else begin
        player[ActionTeam,ActionPlayer].UseSkill('Hypnotic Gaze');
        Bloodbowl.comment.text := 'Hypnotic Gaze failed';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      if (frmSettings.rgHGaze.ItemIndex=2) then begin
        s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
          Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
        LogWrite(s);
        PlayActionEndOfMove(s, 1);
      end;
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Stab' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  ((player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 1) and (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 2));
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be stabbing an adjacent standing opponent',
       'Bloodbowl Stab Gaze Warning', MB_OK);
    end else begin
      BallScatter := false;
      v:= (Sender as TPlayer).teamnr;
      w:= (Sender as Tplayer).number;
      ArmourSettings(ActionTeam,ActionPlayer,v,w,0);
      if InjuryStatus = 3 then begin
        BloodBowl.comment.Text :=
          'Prone result means that Stab fails to break armour and has no effect!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      if InjuryStatus >= 4 then begin
        if player[v,w].status < InjuryStatus then begin
          if player[v,w].status=2 then begin
            ploc := player[v,w].p;
            qloc := player[v,w].q;
            player[v,w].SetStatus(InjuryStatus);
            BallScatter := true;
          end else player[v,w].SetStatus(InjuryStatus);
        end;
      end;
      InjuryStatus := 0;
      if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='AccurateKick' then begin
    KickP := player[(Sender as TPlayer).teamnr, (Sender as TPlayer).number].p;
    KickQ := player[(Sender as TPlayer).teamnr, (Sender as TPlayer).number].q;
    if KickField[KickP, KickQ] = 2 then
      begin
        dist1 := abs(player[ActionTeam,ActionPlayer].p - KickP);
        dist2 := abs(player[ActionTeam,ActionPlayer].q - KickQ);
        if dist1 >= dist2 then finaldist := dist1 else finaldist := dist2;
        if finaldist<KickDist then begin
          if (KickP = 0) and (KickQ = 0) then
            ScatterBallFrom(KickP, KickQ, 1, 1) else
          if (KickP = 0) and (KickQ = 25) then
             ScatterBallFrom(KickP, KickQ, 1, 3) else
          if (KickP = 14) and (KickQ = 0) then
             ScatterBallFrom(KickP, KickQ, 1, 6) else
          if (KickP = 14) and (KickQ = 25) then
             ScatterBallFrom(KickP, KickQ, 1, 8) else
          if (KickP = 0) then
             ScatterBallFrom(KickP, KickQ, 1, 2) else
          if (KickP = 14) then
             ScatterBallFrom(KickP, KickQ, 1, 7) else
          if (KickQ = 0) then
             ScatterBallFrom(KickP, KickQ, 1, 4) else
          if (KickQ = 25) then
             ScatterBallFrom(KickP, KickQ, 1, 5);
        end else
           ShowCatchWindow((Sender as TPlayer).teamnr, (Sender as TPlayer).number,
             0, false, false);
        for g := 0 to 14 do begin
          for f := 0 to 25 do begin
            KickField[g,f] := 0;
            field[g,f].color := clGreen;
            field[g,f].transparent := true;
          end;
        end;
        GameStatus := '';
        ActionTeam := 0;
        ActionPlayer := 0;
        Bloodbowl.Loglabel.caption := ' ';
      end;

  end else if GameStatus='PoochKick' then begin
    KickP := player[(Sender as TPlayer).teamnr, (Sender as TPlayer).number].p;
    KickQ := player[(Sender as TPlayer).teamnr, (Sender as TPlayer).number].q;
    if KickField[KickP, KickQ] = 2 then
      begin
        ShowCatchWindow((Sender as TPlayer).teamnr, (Sender as TPlayer).number,
           0, false, false);
        for g := 0 to 14 do begin
          for f := 0 to 25 do begin
            KickField[g,f] := 0;
            field[g,f].color := clGreen;
            field[g,f].transparent := true;
          end;
        end;
        GameStatus := '';
        ActionTeam := 0;
        ActionPlayer := 0;
        Bloodbowl.Loglabel.caption := ' ';
      end;

  end else if (GameStatus='Apoth1')
  then begin
    if CanWriteToLog then begin
      if not (player[(Sender as TPlayer).teamnr,
      (Sender as TPlayer).number].hasSkill('Undead')) then begin
        if (not(frmSettings.cbUpApoth.checked)) then begin
          LogWrite('a' + Chr(ActionTeam + 48));
          AddLog(ffcl[ActionTeam] + ' uses the Apothecary');
          apo[ActionTeam].color := colorarray[ActionTeam, 4, 0];
          apo[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];

          if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status = 9)
          then begin
            player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(0);
          end else begin
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll = 1 then begin
              BloodBowl.comment.Text := 'Apothecary FAILS!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end else begin
              if frmSettings.cmbLeague.Items[frmSettings.cmbLeague.ItemIndex] = 'LUSTRIAN'
              then begin
                player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(5);
              end else begin
                if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status >= 1)
                and (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status <= 4)
                then begin
                  player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(3);
                end else begin
                  player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(0);
                end;
              end;
              BloodBowl.comment.Text := 'Apothecary heals the player!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end;
          end;
          GameStatus := '';
          ActionTeam := -1;
        end else begin
          LogWrite('a' + Chr(ActionTeam + 48) + '1');
          AddLog(ffcl[ActionTeam] + ' uses the Level 1 Apothecary');
          apo1[ActionTeam].color := colorarray[ActionTeam, 4, 0];
          apo1[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];
          if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status = 9)
          then begin
            player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(0);
          end else begin
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if (Uppercase(team[(Sender as TPlayer).teamnr].race) = 'SHALLYA') and
              (lastroll=1) then lastroll := 2;
            if lastroll = 1 then begin
              BloodBowl.comment.Text := 'Apothecary FAILS!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end else begin
              if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status >= 1)
              and (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status <= 4)
              then begin
                player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(3);
              end else begin
                player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(0);
              end;
              BloodBowl.comment.Text := 'Apothecary heals the player!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end;
          end;
          GameStatus := '';
          ActionTeam := -1;
        end;
      end else begin
        Bloodbowl.Loglabel.caption := 'APOTHECARIES CANNOT HEAL THE UNDEAD';
        GameStatus := '';
        ActionTeam := -1;
      end;
    end;

  end else if (GameStatus='Apoth2')
  then begin
    if not (player[(Sender as TPlayer).teamnr,
    (Sender as TPlayer).number].hasSkill('Undead')) then begin
      if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status = 9)
      then begin
        if CanWriteToLog then begin
          LogWrite('a' + Chr(ActionTeam + 48) + '2');
          AddLog(ffcl[ActionTeam] + ' uses the Level 2 Apothecary');
          apo2[ActionTeam].color := colorarray[ActionTeam, 4, 0];
          apo2[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];
          player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(0);
          GameStatus := '';
          ActionTeam := -1;
        end;
      end;
    end else begin
      Bloodbowl.Loglabel.caption := 'APOTHECARIES CANNOT HEAL THE UNDEAD';
      GameStatus := '';
      ActionTeam := -1;
    end;

  end else if (GameStatus='Apoth4')
  then begin
    if not (player[(Sender as TPlayer).teamnr,
    (Sender as TPlayer).number].hasSkill('Undead')) then begin
      if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status = 7)
      then begin
        if CanWriteToLog then begin
          LogWrite('a' + Chr(ActionTeam + 48) + '4');
          AddLog(ffcl[(Sender as TPlayer).teamnr] + ' uses the Level 4 Apothecary');
          apo4[ActionTeam].color := colorarray[ActionTeam, 4, 0];
          apo4[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];
          player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(6);
          GameStatus := '';
          ActionTeam := -1;
        end;
      end;
    end else begin
      Bloodbowl.Loglabel.caption := 'APOTHECARIES CANNOT HEAL THE UNDEAD';
      GameStatus := '';
      ActionTeam := -1;
    end;

  end else if (GameStatus='Apoth5')
  then begin
    if not (player[(Sender as TPlayer).teamnr,
    (Sender as TPlayer).number].hasSkill('Undead')) then begin
      if (player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].status = 8)
      then begin
        if CanWriteToLog then begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if (Uppercase(team[(Sender as TPlayer).teamnr].race) = 'SHALLYA') and
              (lastroll<=3) then lastroll := 4;
          if lastroll <= 3 then begin
            LogWrite('a' + Chr(ActionTeam + 48) + '5');
            AddLog(ffcl[ActionTeam] + ' uses the Level 5 Apothecary');
            apo5[ActionTeam].color := colorarray[ActionTeam, 4, 0];
            apo5[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];
            BloodBowl.comment.Text := 'Apothecary FAILS!  Hes dead, Jim!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            GameStatus := '';
            ActionTeam := -1;
          end else begin
            LogWrite('a' + Chr(ActionTeam + 48) + '5');
            AddLog(ffcl[ActionTeam] + ' uses the Level 5 Apothecary');
            apo5[ActionTeam].color := colorarray[ActionTeam, 4, 0];
            apo5[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];
            player[(Sender as TPlayer).teamnr,(Sender as TPlayer).number].SetStatus(70);
            BloodBowl.comment.Text := 'SUCCESS!  The Apothecary earns his paycheck!'+
              '  This dead player will play again after a one game rest period!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            GameStatus := '';
            ActionTeam := -1;
          end;
        end;
      end;
    end else begin
      Bloodbowl.Loglabel.caption := 'APOTHECARIES CANNOT HEAL THE UNDEAD';
      GameStatus := '';
      ActionTeam := -1;
    end;

  end else if GameStatus='ThrowinMovement' then begin
    ThrownTeam := (Sender as TPlayer).teamnr;
    ThrownPlayer := (Sender as TPlayer).number;
    pplace := player[ThrownTeam,ThrownPlayer].p -
             player[ActionTeam,ActionPlayer].p;
    qplace := player[ThrownTeam,ThrownPlayer].q -
             player[ActionTeam,ActionPlayer].q;
    TestP := player[ActionTeam,ActionPlayer].p;
    TestQ := player[ActionTeam,ActionPlayer].q;
    NewP := TestP + pplace;
    NewQ := TestQ + qplace;
    dk1 := 1;
    if (NewP<0) or (NewP>14) or (NewQ<0) or (NewQ>25) then dk1 := 3;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if (player[g,f].p = NewP) and (player[g,f].q = NewQ) then begin
          dk1 := 2;
        end;
       end;
    end;
    if (qplace = 0) and (pplace = -1) then begin
      NewP2 := TestP - 1;
      NewQ2 := TestQ - 1;
      NewP3 := TestP - 1;
      NewQ3 := TestQ + 1;
    end else if (qplace = 0) and (pplace = 1) then begin
      NewP2 := TestP + 1;
      NewQ2 := TestQ + 1;
      NewP3 := TestP + 1;
      NewQ3 := TestQ - 1;
    end else if (qplace = 1) and (pplace = 0) then begin
      NewP2 := TestP - 1;
      NewQ2 := TestQ + 1;
      NewP3 := TestP + 1;
      NewQ3 := TestQ + 1;
    end else if (qplace = -1) and (pplace = 0) then begin
      NewP2 := TestP + 1;
      NewQ2 := TestQ - 1;
      NewP3 := TestP - 1;
      NewQ3 := TestQ - 1;
    end else if (qplace = 1) and (pplace = -1) then begin
      NewP2 := TestP - 1;
      NewQ2 := TestQ + 0;
      NewP3 := TestP + 0;
      NewQ3 := TestQ + 1;
    end else if (qplace = 1) and (pplace = 1) then begin
      NewP2 := TestP + 0;
      NewQ2 := TestQ + 1;
      NewP3 := TestP + 1;
      NewQ3 := TestQ + 0;
    end else if (qplace = -1) and (pplace = 1) then begin
      NewP2 := TestP + 1;
      NewQ2 := TestQ + 0;
      NewP3 := TestP + 0;
      NewQ3 := TestQ - 1;
    end else if (qplace = -1) and (pplace = -1) then begin
      NewP2 := TestP + 0;
      NewQ2 := TestQ - 1;
      NewP3 := TestP - 1;
      NewQ3 := TestQ + 0;
    end;
    dk2 := 1;
    dk3 := 1;
    if (NewP2<0) or (NewP2>14) or (NewQ2<0) or (NewQ2>25) then dk2 := 3;
    if (NewP3<0) or (NewP3>14) or (NewQ3<0) or (NewQ3>25) then dk3 := 3;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if (player[g,f].p = NewP2) and (player[g,f].q = NewQ2) then begin
          dk2 := 2;
        end;
        if (player[g,f].p = NewP3) and (player[g,f].q = NewQ3) then begin
          dk3 := 2;
        end;
      end;
    end;
    Bloodbowl.comment.text := 'Throw-in Movement roll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    if lastroll<3 then begin
      FinalP := NewP2;
      FinalQ := NewQ2;
      FinalDK := dk2;
    end else if (lastroll>2) and (lastroll<5) then begin
      FinalP := NewP;
      FinalQ := NewQ;
      FinalDK := dk1;
    end else begin
      FinalP := NewP3;
      FinalQ := NewQ3;
      FinalDK := dk3;
    end;
    if FinalDK=1 then PlacePlayer(ActionPlayer, ActionTeam, FinalP, FinalQ) else
    if FinalDK=3 then begin
      Bloodbowl.comment.text := 'Player runs out of bounds!  Roll for injury';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    end else begin
      for g := 0 to 1 do begin
        for f := 1 to team[g].numplayers do begin
          if (player[g,f].p = FinalP) and (player[g,f].q = FinalQ) then begin
            BloodBowl.comment.Text := 'You must throw a block at #'
              +InttoStr(player[g,f].cnumber)+'-'+player[g,f].name;
          end;
        end;
      end;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Chill' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 3;
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be using Chill an adjacent prone opponent',
       'Bloodbowl Chill Warning', MB_OK);
    end else begin
      player[ActionTeam,ActionPlayer].UseSkill('Chill');
      Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
      if lastroll>player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].av then begin
        Bloodbowl.comment.text := 'Chill successful';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].SetStatus(4);
      end else begin
        Bloodbowl.comment.text := 'Chill failed';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Dig1' then begin
    if (ABS((player[ActionTeam,ActionPlayer].p)-
       player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)<=1) and
      (ABS((player[ActionTeam,ActionPlayer].q)-
      player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)<=1) and
      ((ABS((player[ActionTeam,ActionPlayer].p)-
      player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)<>0) or
      (ABS((player[ActionTeam,ActionPlayer].q)-
      player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)<>0))
      then begin
        DigP := player[(Sender as TPlayer).teamnr,
          (Sender as Tplayer).number].p;
        DigQ := player[(Sender as TPlayer).teamnr,
           (Sender as Tplayer).number].q;
        DigStrength := player[(Sender as TPlayer).teamnr,
         (Sender as Tplayer).number].st;
        GameStatus := 'Dig2';
        Bloodbowl.Loglabel.caption :=
          'CLICK ON THE EMPTY SQUARE TO DIG TO';
    end else
      Application.Messagebox('You must dig under an adjacent square!',
       'Bloodbowl Dig Warning', MB_OK);

  end else if GameStatus='ThrowTeamMate1' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 1) and
      (player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].status <> 2);
    test4 := ActionTeam <> (Sender as Tplayer).teamnr;
    test5 := not (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].hasSkill('Right Stuff'));
    if (test1>1) or (test2>1) or (test3) or (test4) or (test5) then begin
       Application.Messagebox('You must be throwing an adjacent standing teammate'+
       ' that has Right Stuff','Bloodbowl Throw Team-Mate Warning', MB_OK);
       GameStatus := '';
       ActionTeam := 0;
       ActionPlayer := 0;
    end else begin
      ThrownTeam := (Sender as TPlayer).teamnr;
      ThrownPlayer := (Sender as Tplayer).number;
      GameStatus := 'ThrowTeamMate2';
      Bloodbowl.Loglabel.caption := 'CLICK ON THE SQUARE TO THROW THE PLAYER TO';
    end;

  end else if GameStatus='PitchPlayer1' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status <> 1) and
      (player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].status <> 2);
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be throwing an adjacent standing' +
         ' opponent','Bloodbowl Pitch Player Warning', MB_OK);
       GameStatus := '';
       ActionTeam := 0;
       ActionPlayer := 0;
    end else begin
      ThrownTeam := (Sender as TPlayer).teamnr;
      ThrownPlayer := (Sender as Tplayer).number;
      GameStatus := 'PitchPlayer2';
      Bloodbowl.Loglabel.caption := 'CLICK ON THE SQUARE TO THROW THE PLAYER TO';
    end;

  end else if GameStatus='Dirty Kick' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status < 1) or
      (player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].status > 2);
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be using Dirty Kick on an adjacent standing opponent',
       'Bloodbowl Dirty Kick Warning', MB_OK);
    end else begin
      ThrownTeam := (Sender as TPlayer).teamnr;
      ThrownPlayer := (Sender as Tplayer).number;
      Bloodbowl.OneDBButtonClick(Bloodbowl);
      if lastroll = 1 then BlockDie := 'Kicker Down';
      if lastroll = 2 then BlockDie := 'Nothing Happened';
      if (lastroll = 3) or (lastroll = 4) then BlockDie := 'Opponent Pushed';
      if lastroll = 5 then BlockDie := 'Opponent Prone';
      if lastroll = 6 then BlockDie := 'Opponent Stunned';
      Bloodbowl.comment.text := BlockDie;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
        (player[ActionTeam,ActionPlayer].Ally))
        and (true)); // bigguy
      proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
        and (lastroll <= 1) and
        (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
        and (ActionTeam = curmove);
      reroll := CanUseTeamReroll(bga);
      if lastroll<6 then begin
        DKRoll := lastroll;
        ReRollAnswer := 'Continue';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Reroll Dirty Kick?'
            , 'Dirty Kick Question',
            'Use Pro,Team Reroll,Continue');
        end else if proskill then begin
          ReRollAnswer := FlexMessageBox('Reroll Dirty Kick?'
            , 'Dirty Kick Question',
            'Use Pro,Continue');
        end else if reroll then begin
          ReRollAnswer := FlexMessageBox('Reroll Dirty Kick?'
            , 'Dirty Kick Question', 'Team Reroll,Continue');
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Dirty Kick reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[ActionTeam,ActionPlayer].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
          if (lastroll <= 3) then lastroll := DKRoll;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if lastroll = 1 then BlockDie := 'Kicker Down';
        if lastroll = 2 then BlockDie := 'Nothing Happened';
        if (lastroll = 3) or (lastroll = 4) then BlockDie := 'Opponent Pushed';
        if lastroll = 5 then BlockDie := 'Opponent Prone';
        if lastroll = 6 then BlockDie := 'Opponent Stunned';
        Bloodbowl.comment.text := BlockDie;
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      player[ActionTeam,ActionPlayer].UseSkill('Dirty Kick');
      if BlockDie = 'Kicker Down' then
        player[ActionTeam, ActionPlayer].SetStatus(3)
      else if BlockDie = 'Opponent Prone' then
        player[ThrownTeam,ThrownPlayer].SetStatus(3)
      else if BlockDie = 'Opponent Stunned' then
        player[ThrownTeam,ThrownPlayer].SetStatus(4)
      else if BlockDie = 'Opponent Pushed' then begin
        lastroll := Rnd(6,6)+1;
        pplace := player[ThrownTeam,ThrownPlayer].p -
           player[ActionTeam,ActionPlayer].p;
        qplace := player[ThrownTeam,ThrownPlayer].q -
           player[ActionTeam,ActionPlayer].q;
        TestP := player[ThrownTeam,ThrownPlayer].p;
        TestQ := player[ThrownTeam,ThrownPlayer].q;
        NewP := TestP + pplace;
        NewQ := TestQ + qplace;
        dk1 := 1;
        if (NewP<0) or (NewP>14) or (NewQ<0) or (NewQ>25) then dk1 := 3;
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if (player[g,f].p = NewP) and (player[g,f].q = NewQ) then begin
              dk1 := 2;
            end;
          end;
        end;
        if (qplace = 0) and (pplace = -1) then begin
           NewP2 := TestP - 1;
           NewQ2 := TestQ - 1;
           NewP3 := TestP - 1;
           NewQ3 := TestQ + 1;
        end else if (qplace = 0) and (pplace = 1) then begin
           NewP2 := TestP + 1;
           NewQ2 := TestQ + 1;
           NewP3 := TestP + 1;
           NewQ3 := TestQ - 1;
        end else if (qplace = 1) and (pplace = 0) then begin
           NewP2 := TestP + 1;
           NewQ2 := TestQ + 1;
           NewP3 := TestP - 1;
           NewQ3 := TestQ + 1;
        end else if (qplace = -1) and (pplace = 0) then begin
           NewP2 := TestP + 1;
           NewQ2 := TestQ - 1;
           NewP3 := TestP - 1;
           NewQ3 := TestQ - 1;
        end else if (qplace = 1) and (pplace = -1) then begin
           NewP2 := TestP + 0;
           NewQ2 := TestQ + 1;
           NewP3 := TestP - 1;
           NewQ3 := TestQ + 0;
        end else if (qplace = 1) and (pplace = 1) then begin
           NewP2 := TestP + 1;
           NewQ2 := TestQ + 0;
           NewP3 := TestP + 0;
           NewQ3 := TestQ + 1;
        end else if (qplace = -1) and (pplace = 1) then begin
           NewP2 := TestP + 1;
           NewQ2 := TestQ + 0;
           NewP3 := TestP + 0;
           NewQ3 := TestQ - 1;
        end else if (qplace = -1) and (pplace = -1) then begin
           NewP2 := TestP - 1;
           NewQ2 := TestQ + 0;
           NewP3 := TestP + 0;
           NewQ3 := TestQ - 1;
        end;
        dk2 := 1;
        dk3 := 1;
        if (NewP2<0) or (NewP2>14) or (NewQ2<0) or (NewQ2>25) then dk2 := 3;
        if (NewP3<0) or (NewP3>14) or (NewQ3<0) or (NewQ3>25) then dk3 := 3;
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if (player[g,f].p = NewP2) and (player[g,f].q = NewQ2) then begin
              dk2 := 2;
            end;
            if (player[g,f].p = NewP3) and (player[g,f].q = NewQ3) then begin
              dk3 := 2;
            end;
          end;
        end;
        if ((dk1=1) and ((dk2=2) or (dk2=3)) and ((dk3=2) or (dk3=3))) or
          ((dk1=1) and (dk2=1) and ((dk3=2) or (dk3=3)) and (lastroll<4)) or
          ((dk1=1) and ((dk2=2) or (dk2=3)) and (dk3=1) and (lastroll<4)) or
          ((dk1=1) and (dk2=1) and (dk3=1) and (lastroll<3)) then begin
            FinalP := NewP;
            FinalQ := NewQ;
        end else
        if ((dk2=1) and ((dk1=2) or (dk1=3)) and ((dk3=2) or (dk3=3))) or
          ((dk2=1) and (dk1=1) and ((dk3=2) or (dk3=3)) and (lastroll>3)) or
          ((dk2=1) and ((dk1=2) or (dk1=3)) and (dk3=1) and (lastroll<4)) or
          ((dk2=1) and (dk1=1) and (dk3=1) and (lastroll>2) and (lastroll<4)) then begin
            FinalP := NewP2;
            FinalQ := NewQ2;
        end else
        if ((dk3=1) and ((dk2=2) or (dk2=3)) and ((dk1=2) or (dk1=3))) or
          ((dk3=1) and (dk2=1) and ((dk1=2) or (dk1=3)) and (lastroll>3)) or
          ((dk3=1) and ((dk2=2) or (dk2=3)) and (dk1=1) and (lastroll>3)) or
          ((dk3=1) and (dk2=1) and (dk1=1) and (lastroll>4)) then begin
            FinalP := NewP3;
            FinalQ := NewQ3;
        end else
        if ((dk1=3) and ((dk2=3) or (dk2=2)) and ((dk3=3) or (dk3=2))) or
           ((dk2=3) and ((dk1=3) or (dk1=2)) and ((dk3=3) or (dk3=2))) or
           ((dk3=3) and ((dk2=3) or (dk2=2)) and ((dk1=3) or (dk1=2)))
         then begin
            FinalP := 99;
            FinalQ := 99;
        end else begin
            FinalP := 100;
            FinalQ := 100;
        end;
        if FinalP = 100 then begin
          Bloodbowl.comment.text := 'All squares blocked, Dirty Kick has no Effect';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else if FinalP = 99 then begin
          Bloodbowl.comment.text := 'Player is Dirty Kicked out of bounds';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else begin
          PlacePlayer(ThrownPlayer, ThrownTeam, FinalP, FinalQ);
        end;
      end;
      s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
        Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
      LogWrite(s);
      PlayActionEndOfMove(s, 1);
      if FinalP = 100 then
        Bloodbowl.Loglabel.caption := 'All squares blocked, Dirty Kick has no Effect';
      if FinalP = 99 then begin
        InjurySettings(curteam, curplayer);
        if InjuryStatus = 4 then InjuryStatus := 0;
        if player[curteam,curplayer].status=2 then begin
          ploc := player[curteam,curplayer].p;
          qloc := player[curteam,curplayer].q;
          player[curteam,curplayer].SetStatus(InjuryStatus);
          if ploc = 0 then arrow := 2;
          if ploc = 14 then arrow := 7;
          if qloc = 0 then arrow := 4;
          if qloc = 25 then arrow := 5;
          ScatterBallFrom(ploc, qloc, 1, arrow);
        end else player[curteam,curplayer].SetStatus(InjuryStatus);
        InjuryStatus := 0;
      end;
    end;

    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Mace Tail' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status < 1) or
      (player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].status > 2);
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be using Mace Tail on an adjacent standing opponent',
       'Bloodbowl Mace Tail Warning', MB_OK);
    end else begin
      if lastroll<(4 + (player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].ag) - (player[ActionTeam,ActionPlayer].ag))
        then begin
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
          (player[ActionTeam,ActionPlayer].Ally))
          and (true)); // bigguy
        proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
          and (lastroll <= 1) and
          (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
          and (ActionTeam = curmove);
        reroll := CanUseTeamReroll(bga);
        ReRollAnswer := 'Fail Roll';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Mace Tail roll has failed!'
            , 'Mace Tail Failure',
            'Use Pro,Team Reroll,Fail Roll');
        end else if proskill then begin
          ReRollAnswer := FlexMessageBox('Mace Tail roll has failed!'
            , 'Mace Tail Failure',
            'Use Pro,Fail Roll');
        end else if reroll then begin
          ReRollAnswer := FlexMessageBox('Mace Tail roll failed!'
            , 'Mace Tail Failure', 'Fail Roll,Team Reroll');
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Mace Tail reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[ActionTeam,ActionPlayer].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
      end;
      if lastroll>=(4 + (player[(Sender as TPlayer).teamnr,
       (Sender as Tplayer).number].ag) - (player[ActionTeam,ActionPlayer].ag))
       then begin
       player[ActionTeam,ActionPlayer].UseSkill('Mace Tail');
       Bloodbowl.comment.text := 'Mace Tail successful';
       Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
       Ballscatter := false;
       v := (Sender as TPlayer).teamnr;
       w := (Sender as TPlayer).number;
       AVBreak := true;
       ArmourSettings(Actionteam,Actionplayer,v,w,2);
       AVBreak := false;
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
       s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
       Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
       LogWrite(s);
       PlayActionEndOfMove(s, 1);
      end else begin
        player[ActionTeam,ActionPlayer].UseSkill('Mace Tail');
        Bloodbowl.comment.text := 'Mace Tail failed';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
           Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
        LogWrite(s);
        PlayActionEndOfMove(s, 1);
      end;
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Bear Hug' then begin
    test1 := ((abs(player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := ((abs(player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 :=  (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].status < 1) or
      (player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].status > 2);
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (test1>1) or (test2>1) or (test3) or (test4) then begin
       Application.Messagebox('You must be using Bear Hug on an adjacent standing opponent',
       'Bloodbowl Bear Hug Warning', MB_OK);
    end else begin
      g := ActionTeam;
      f := ActionPlayer;
      g0 := (Sender as TPlayer).teamnr;
      f0 := (Sender as Tplayer).number;
      BlockTeam := g0;
      BlockPlayer := f0;
      HitTeam := g;
      HitPlayer := f;
      {count assists}
      if (not((false)    // Wild animal
                       and (player[g,f].hasSkill('Wild Animal'))))
        and (not((player[g,f].hasSkill('Ball and Chain'))))
        and (not((player[g,f].hasSkill('Maniac')))) then begin
        tz := CountTZBlockA(g0, f0);
        bx := false;
        for p := 1 to tz.num do begin
          if tz.pl[p] <> f then begin
            if player[g,tz.pl[p]].hasSkill('Guard') then b := true
            else begin
              tz0 := CountTZBlockCA(g, tz.pl[p]);
              b := (tz0.num = 0);
         {     b := ((tz0.num = 1) and (player[g0,f0].tz = 0))
                or ((tz0.num = 0) and (player[g0,f0].tz <> 0)) or
                ((tz0.num = 1) and (frmSettings.cbNoTZAssist.checked));  }
            end;
            if b then begin
              assa := assa + 1;
              if not(bx) then begin
                bx := true;
              end;
            end;
          end;
        end;
      end;
      assd := 0;
      {count counterassists}
      if (not((player[g,f].hasSkill('Ball and Chain')))) then begin
        tz := CountTZBlockCA2(g, f);
        bx := false;
        for p := 1 to tz.num do begin
          if tz.pl[p] <> f0 then begin
            if player[g0,tz.pl[p]].hasSkill('Guard') then b := true
            else begin
              tz0 := CountTZBlockCA(g0, tz.pl[p]);
              b := (tz0.num = 0);
              {b := ((tz0.num = 1) and (player[g,f].tz = 0))
                or ((tz0.num = 0) and (player[g,f].tz <> 0));}
            end;
            if b then begin
              assd := assd + 1;
              if not(bx) then begin
                bx := true;
              end;
            end;
          end;
        end;
      end;
      RollNeed := (4 + (player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].st) - (player[ActionTeam,ActionPlayer].st)
        + (assd) - (assa));
      If RollNeed>6 then RollNeed := 6;
      if RollNeed<2 then RollNeed := 2;
      s := 'Bear Hug roll needed: ' + InttoStr(RollNeed) + '+';
      Bloodbowl.comment.text := s;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);

      if lastroll<(4 + (player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].st) - (player[ActionTeam,ActionPlayer].st)
        + (assd) - (assa))
        then begin
        bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
          (player[ActionTeam,ActionPlayer].Ally))
          and (true)); // bigguy
        proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
          and (lastroll <= 1) and
          (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
          and (ActionTeam = curmove);
        reroll := CanUseTeamReroll(bga);
        ReRollAnswer := 'Fail Roll';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Bear Hug roll has failed!'
            , 'Bear Hug Failure',
            'Use Pro,Team Reroll,Fail Roll');
        end else if proskill then begin
          ReRollAnswer := FlexMessageBox('Bear Hug roll has failed!'
            , 'Bear Hug Failure',
            'Use Pro,Fail Roll');
        end else if reroll then begin
          ReRollAnswer := FlexMessageBox('Bear Hug roll failed!'
            , 'Bear Hug Failure', 'Fail Roll,Team Reroll');
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Bear Hug reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[ActionTeam,ActionPlayer].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
      end;

      if lastroll>=(4 + (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].st) - (player[ActionTeam,ActionPlayer].st)
      + (assd) - (assa))
      then begin
        player[ActionTeam,ActionPlayer].UseSkill('Bear Hug');
        Bloodbowl.comment.text := 'Bear Hug Armour Roll';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
        if curmove = 0 then begin
          AVBreakTOTRed := AVBreakTOTRed + 1;
        end else if curmove = 1 then begin
          AVBreakTOTBlue := AVBreakTOTBlue + 1;
        end;
        if (player[(Sender as TPlayer).teamnr,
          (Sender as Tplayer).number].av) >= lastroll then begin
          Bloodbowl.comment.text := 'Bear Hug fails to break armour; nothing happens!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else begin
          if curmove = 0 then begin
            AVBreakRed := AVBreakRed + 1;
          end else if curmove = 1 then begin
            AVBreakBlue := AVBreakBlue + 1;
          end;
          Bloodbowl.comment.text := 'Bear Hug successful and breaks armour';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          frmArmourRoll.txtArmourValue.text :=
            IntToStr(player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].av);
          frmArmourRoll.txtAssists.text := IntToStr(0);
          frmArmourRoll.cbPulledPunches.checked :=
            (player[ActionTeam,ActionPlayer].hasSkill('Pulled Punches'));
          frmArmourRoll.cbThickSkull.checked :=
           (player[(Sender as TPlayer).teamnr,
           (Sender as Tplayer).number].hasSkill('Thick Skull'));
          frmArmourRoll.cbProSkill.checked := (player[(Sender as TPlayer).teamnr,
           (Sender as Tplayer).number].hasSkill('Pro'));
          frmArmourRoll.cbIRDaura.checked := (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Daemonic Aura'));
          for t := 1 to team[(Sender as TPlayer).teamnr].numplayers do begin
            if (player[(Sender as TPlayer).teamnr,t].hasSkill('Conjure 3+'))
            and (player[(Sender as TPlayer).teamnr,t].status >= 1)
            and (player[(Sender as TPlayer).teamnr,t].status <= 4) then
              frmArmourRoll.cbIRDaura.checked := False;
          end;
          frmArmourRoll.cbWaaaghArmour.checked :=
            (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Waaagh Armour'));
          if (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('TITCHY')) and
            (frmSettings.rgTitchy.ItemIndex=1) then begin
             frmArmourRoll.rbTitchyPlayer.checked := true;
            end else if ((Pos('HALFLING', Uppercase(player[(Sender as TPlayer).teamnr,
             (Sender as Tplayer).number].position)) > 0) or
             ((Pos('GOBLIN', Uppercase(player[(Sender as TPlayer).teamnr,
             (Sender as Tplayer).number].position)) > 0)
             and not (Pos('HOBGOBLIN', Uppercase(player[(Sender as TPlayer).teamnr,
             (Sender as Tplayer).number].position)) > 0)))
           then begin
             frmArmourRoll.rbWeakPlayer.checked := true;
          end else if (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('STUNTY'))
             and frmSettings.cbWeakStunty.checked then begin
            frmArmourRoll.rbWeakPlayer.checked := true;
          end else if (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Easily Injured')) then begin
            frmArmourRoll.rbWeakPlayer.checked := true;
          end else frmArmourRoll.rbNoStunty.checked := true;
          frmArmourRoll.cbBrittle.checked := (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Brittle'));
          frmArmourRoll.cbNoDeath.checked := (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Amateur'))
             or (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('NoDeath'));
          frmArmourRoll.cbIronMan.checked := (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Iron Man'));
          frmArmourRoll.cbDecay.checked := (player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Decay'));
          totspp :=
            player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].GetStartingSPP() +
            player[(Sender as TPlayer).teamnr,(Sender as Tplayer).number].GetMatchSPP();

          SPP4th := (frmSettings.rgSkillRollsAt.ItemIndex = 1);
          frmArmourRoll.cbLBanish.checked :=
            ((player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Banishment')) and (totspp < 26) and
            not (SPP4th)) or
            ((player[(Sender as TPlayer).teamnr,
            (Sender as Tplayer).number].hasSkill('Banishment')) and (totspp < 31) and
            (SPP4th));
          frmArmourRoll.cbLBanish2.checked :=
           ((player[(Sender as TPlayer).teamnr,
           (Sender as Tplayer).number].hasSkill('Banishment')) and (totspp >= 26) and
            not (SPP4th)) or
           ((player[(Sender as TPlayer).teamnr,
           (Sender as Tplayer).number].hasSkill('Banishment')) and (totspp >= 31) and
           (SPP4th));
          if frmSettings.cbNiggleUp.checked then begin
            s := player[(Sender as TPlayer).teamnr,
              (Sender as Tplayer).number].inj;
            p := Pos('N', Uppercase(s));
            {roll for each N until all done, or 1 rolled}
            NiggleCount := 0;
            repeat begin
              if p<>0 then NiggleCount := NiggleCount + 1;
              s := Copy(s, p+1, Length(s) - p);
              p := Pos('N', Uppercase(s));
            end until (p = 0);
            frmArmourRoll.txtNiggles.text := IntToStr(NiggleCount);
          end;
          s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
          Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
          LogWrite(s);
          PlayActionEndOfMove(s, 1);
          ShowHurtForm('I');
          BallScatter := false;
          v:= (Sender as TPlayer).teamnr;
          w:= (Sender as Tplayer).number;
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
      end else begin
        player[ActionTeam,ActionPlayer].UseSkill('Bear Hug');
        Bloodbowl.comment.text := 'Bear Hug failed';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
           Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
        LogWrite(s);
        PlayActionEndOfMove(s, 1);
      end;
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus = 'Punt' then begin
    Bloodbowl.Endofmove1Click(Bloodbowl);
    {tz := CountTZ(ActionTeam, ActionPlayer);}
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    {if lastroll-tz.num >= 2 then begin}

    if lastroll<2 then begin
      bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
        (player[ActionTeam,ActionPlayer].Ally))
        and (true)); // bigguy
      proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
        and (lastroll <= 1) and
        (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
        and (ActionTeam = curmove);
      reroll := CanUseTeamReroll(bga);
      ReRollAnswer := 'Fail Roll';
      if reroll and proskill then begin
        ReRollAnswer := FlexMessageBox('Punt roll has failed!'
          , 'Punt Failure',
          'Use Pro,Team Reroll,Fail Roll');
      end else if proskill then begin
        ReRollAnswer := FlexMessageBox('Punt roll has failed!'
          , 'Punt Failure',
          'Use Pro,Fail Roll');
      end else if reroll then begin
        ReRollAnswer := FlexMessageBox('Punt roll failed!'
          , 'Punt Failure', 'Fail Roll,Team Reroll');
      end;
      if ReRollAnswer='Team Reroll' then begin
        UReroll := UseTeamReroll;
        if UReroll then begin
          Bloodbowl.comment.text := 'Punt reroll';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        end;
      end;
      if ReRollAnswer='Use Pro' then begin
        player[ActionTeam,ActionPlayer].UseSkill('Pro');
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
        if (lastroll <= 3) then lastroll := 1;
        if (lastroll >= 4) then begin
          Bloodbowl.comment.text := 'Pro reroll';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        end;
      end;
    end;

    if lastroll >= 2 then begin
      Bloodbowl.comment.text := 'Punt is successful';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      ScatterD8D6(player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].p, player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].q,false,false);
    end else begin
      Bloodbowl.comment.text := 'Punt is fumbled!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      ScatterBallFrom(player[ActionTeam, ActionPlayer].p,
        player[ActionTeam, ActionPlayer].q, 1, 0);
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Ethereal' then begin
    test1 := (((player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := (((player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 := false;
    for k := 0 to 1 do
    for l := 1 to team[1-k].numplayers do begin
       if (player[k,l].p = player[ActionTeam,ActionPlayer].p+(-2*test1)) and
          (player[k,l].q = player[ActionTeam,ActionPlayer].q+(-2*test2)) then
            test3 := true;
    end;
    if (player[ActionTeam,ActionPlayer].p+(-2*test1) < 0) or
       (player[ActionTeam,ActionPlayer].p+(-2*test1) > 14) then test3 := true;
    if (player[ActionTeam,ActionPlayer].q+(-2*test2) < 0) or
       (player[ActionTeam,ActionPlayer].q+(-2*test2) > 25) then test3 := true;
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    if (abs(test1)>1) or (abs(test2)>1) or (test3) or (test4) then begin
       Application.Messagebox('Ethereal moves must pass straight through an adjacent '+
       'opponent into an empty square on the pitch',
       'Bloodbowl Ethereal Warning', MB_OK);
    end else begin
      r := 7 - (player[ActionTeam,ActionPlayer].ag);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);

      if lastroll<r then begin
        bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
          (player[ActionTeam,ActionPlayer].Ally))
          and (false)); // bigguy
        proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
          and (lastroll <= 1) and
          (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
          and (ActionTeam = curmove);
        reroll := CanUseTeamReroll(bga);
        ReRollAnswer := 'Fail Roll';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Ethereal roll has failed!'
            , 'Ethereal Failure',
            'Use Pro,Team Reroll,Fail Roll');
        end else if proskill then begin
          ReRollAnswer := FlexMessageBox('Ethereal roll has failed!'
            , 'Ethereal Failure',
            'Use Pro,Fail Roll');
        end else if reroll then begin
          ReRollAnswer := FlexMessageBox('Ethereal roll failed!'
            , 'Ethereal Failure', 'Fail Roll,Team Reroll');
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Ethereal reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[ActionTeam,ActionPlayer].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
      end;

      if lastroll>=r then begin
        player[ActionTeam,ActionPlayer].UseSkill('Ethereal');
        Bloodbowl.comment.text := 'Ethereal successful';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        PlacePlayer(ActionPlayer, ActionTeam,
          (player[ActionTeam,ActionPlayer].p+(-2*test1)),
          (player[ActionTeam,ActionPlayer].q+(-2*test2)));
      end else begin
        Bloodbowl.comment.text := 'Ethereal failed!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        player[ActionTeam,ActionPlayer].UseSkill('Ethereal');
        s := 'x' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 65) +
           Chr(player[ActionTeam,ActionPlayer].UsedMA + 64);
        LogWrite(s);
        PlayActionEndOfMove(s, 1);
      end;
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else if GameStatus='Shadow' then begin
    test1 := (((player[ActionTeam,ActionPlayer].p-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].p)));
    test2 := (((player[ActionTeam,ActionPlayer].q-player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].q)));
    test3 := false;
    for k := 0 to 1 do
    for l := 1 to team[1-k].numplayers do begin
       if (player[k,l].p = LastFieldP) and
          (player[k,l].q = LastFieldQ) then
            test3 := true;
    end;
    test4 := ActionTeam = (Sender as Tplayer).teamnr;
    test5 := true;
    test6 := (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].hasSkill('Shado*'));
    if (abs(test1)<=2) and (abs(test2)<=2) and (LastFieldP<>-1)
      then test5 := false;
    if (test5) or (test3) or (test4) then begin
       Application.Messagebox('Opponent must have Shadowing and be moving into '+
       'the empty square you just left',
       'Bloodbowl Shadowing Warning', MB_OK);
    end else begin
      r := 8 + (player[(Sender as TPlayer).teamnr,
      (Sender as Tplayer).number].ma) - (player[ActionTeam,ActionPlayer].ma);
      Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
      Shadowroll := lastroll;
      if (player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].hasSkill('Pro')) and (lastroll>=r) and not
        (player[(Sender as TPlayer).teamnr,
        (Sender as Tplayer).number].usedSkill('Pro')) then begin
            player[(Sender as TPlayer).teamnr,
             (Sender as Tplayer).number].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro((Sender as TPlayer).teamnr,
              (Sender as TPlayer).number);
            if (lastroll <= 3) then lastroll := Shadowroll;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Opponent Pro skill forces reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
            end;
      end;

      if lastroll<r then begin
        bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
          (player[ActionTeam,ActionPlayer].Ally))
          and (true)); // bigguy
        proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro')))
          and (lastroll <= 1) and
          (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
          and (ActionTeam = curmove);
        reroll := CanUseTeamReroll(bga);
        ReRollAnswer := 'Fail Roll';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Shadowing Escape roll has failed!'
            , 'Shadowing Failure',
            'Use Pro,Team Reroll,Fail Roll');
        end else if proskill then begin
          ReRollAnswer := FlexMessageBox('Shadowing Escape roll has failed!'
            , 'Shadowing Failure',
            'Use Pro,Fail Roll');
        end else if reroll then begin
          ReRollAnswer := FlexMessageBox('Shadowing Escape roll failed!'
            , 'Shadowing Failure', 'Fail Roll,Team Reroll');
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Shadowing reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);;
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[ActionTeam,ActionPlayer].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
          end;
        end;
      end;

      if lastroll>=r then begin
        Bloodbowl.comment.text := InttoStr(r)+'+ roll successful. ' +
          'You avoid the Shadowing player';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else begin
        Bloodbowl.comment.text := InttoStr(r)+'+ Shadow roll failed!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        PlacePlayer((Sender as Tplayer).number, (Sender as TPlayer).teamnr,
          LastFieldP, LastFieldQ);
        LastFieldP := -1;
        LastFieldQ := -1;
      end;
    end;
    GameStatus := '';
    ActionTeam := 0;
    ActionPlayer := 0;

  end else begin
    if (Target is TPlayer) then begin
      {drop on player}
      if (Target = Sender) then begin
        {click on player: toggle cur}
        if 50 * teamnr + number = curbefore then LogWrite(UnCurSub);
      end else begin
      {drop on other player: handled in PlayerDragDrop}
      end;
    end else if (Target is TFieldLabel) then begin
      PlacePlayer((Sender as TPlayer).number, (Sender as TPlayer).teamnr,
                  (Target as TFieldLabel).p, (Target as TFieldLabel).q);
      {when player is dropped on field check if ball is here too,
        because now the ball is 'under' the field}
      if ((Target as TFieldLabel).p = ball.p)
       and ((Target as TFieldLabel).q = ball.q) then begin
        Continuing := true;
        (Sender as TPlayer).SetStatus(2);
        Continuing := false;
        ShowPickUpWindow((Sender as TPlayer).teamnr,
                           (Sender as TPlayer).number);
      end;
    end else if (Target is TImage) then begin
      {drop on ball}
      {this part is becoming obsolete because of change above}
      if (Sender as TPlayer).status = 1 then begin
        PlacePlayer((Sender as TPlayer).number, (Sender as TPlayer).teamnr,
                    ball.p, ball.q);
        Continuing := true;
        (Sender as TPlayer).SetStatus(2);
        Continuing := false;
        ShowPickUpWindow((Sender as TPlayer).teamnr,
                           (Sender as TPlayer).number);
      end;
    end;
  end;
end;

procedure TPlayer.PlayerDragDrop(Sender, Source: TObject; X, Y: Integer);
var f, g, f0, g0, status: integer;
    s: string;
begin
  f := (Sender as TPlayer).number;
  g := (Sender as TPlayer).teamnr;
  if Source is TImage then begin
    {ball dropped on player}
    if player[g,f].status = 1 then player[g,f].SetStatus(2);
  end
  else
  begin
    {player dropped on player}
    f0 := (Source as TPlayer).number;
    g0 := (Source as TPlayer).teamnr;
    if (player[g0,f0].status = 1)
    or (player[g0,f0].status = 2) then begin
      if g <> g0 then begin
        if (Abs(player[g,f].p - player[g0,f0].p) <= 1)
        and (Abs(player[g,f].q - player[g0,f0].q) <= 1) then begin
          {The following tests to see if this is a blitz or a
          second or more block for this player}
          if (player[g,f].status = 1) or (player[g,f].status = 2) then
          begin
            if (player[g0, f0].LastAction = 1)
            and (player[g0, f0].FirstBlock = 0) then
               player[g0, f0].FirstBlock := 1;
            if (player[g0, f0].LastAction <> 1)
            and (player[g0, f0].FirstBlock = 0) then
               player[g0, f0].FirstBlock := 2;
            WorkOutBlock(g0, f0, g, f);
            if CanWriteToLog then begin
              s := 'b' + Chr(g0 + 48) + Chr(f0 + 65) +
                   Chr(player[g0,f0].UsedMA + 64) + Chr(player[g,f].p + 65) +
                   Chr(player[g,f].q + 65);
              LogWrite('(' + s);
              PlayActionBlockMove(s, 1);
            end;
            if player[g0, f0].SecondBlock = 0 then
               player[g0, f0].SecondBlock := 1;

          end
          else
          // is it a foul?
          if (player[g,f].status = 3) or (player[g,f].status = 4) then
          begin
            WorkOutFoul(g0, f0, g, f);
            if CanWriteToLog then begin
              s := 'b' + Chr(g0 + 48) + Chr(f0 + 65) +
                   Chr(player[g0,f0].UsedMA + 64);
              LogWrite('(' + s);
              PlayActionBlockMove(s, 1);
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TPlayer.PlayerMouseMove(Sender: TObject; Shift: TShiftState;
                                  X, Y: Integer);
begin
  ShowPlayerDetails;
end;

procedure TPlayer.PlayerDragOver(Sender, Source: TObject; X, Y: Integer;
                                 State: TDragState; var Accept: Boolean);
var g, f, g0, f0, assa, assd, p, db, dd, st, sa, stx, std, st0, lastact,
    fblock, horns: integer;
    tz, tz0: TackleZones;
    b, bx: boolean;
    daunt: string;
begin
  daunt := '';
  f0 := (Sender as TPlayer).number;
  g0 := (Sender as TPlayer).teamnr;
  if (Sender <> Source) and (Source is TPlayer) then begin
    f := (Source as TPlayer).number;
    g := (Source as TPlayer).teamnr;
    if (g <> g0) and (abs(player[1-g0,f].p - player[g0,f0].p) <= 1)
      and (abs(player[1-g0,f].q - player[g0,f0].q) <= 1) and
      (player[g0,f0].status >= 1) and (player[g0,f0].status <= 2) then begin
      FBlock := 0;
      horns := 0;
      sa := 0;
      std := player[g0,f0].st;
      stx := player[g,f].st;
      if (player[g,f].hasSkill('Ball and Chain')) then begin
       stx := 6;
      end;
      if (player[g,f].status = 1)
        or (player[g,f].status = 2) then begin
          if (player[g, f].LastAction = 1)
          and ((player[g, f].FirstBlock = 0) or (player[g,f].FirstBlock=1)) then
            FBlock := 1;
          if (player[g,f].FirstBlock =1) and ((player[g,f].LastAction = 1) or
          ((player[g,f].LastAction = 2) and (true)))// horns 2nd block
            then FBlock := 1;
          if (player[g, f].LastAction <> 1)
          and (player[g, f].FirstBlock = 0) then
            FBlock := 2;
        end;
      if player[g,f].font.size <> 12 then begin
        if (FBlock = 1)
          then begin
          if (player[g0,f0].hasSkill('Stiff Arm')) and
          (player[g,f].SecondBlock = 0) then begin
            sa := -1;
          end;
          {End Stiff Arm skill add}
          if player[g,f].hasSkill('Horns') then begin
            horns := 1;
          end;
          if player[g,f].hasSkill('Horn') then begin
            horns := 1;
          end;
        end;
      end;
      assa := horns + sa;
      BlockTeam := g0;
      BlockPlayer := f0;
      HitTeam := g;
      HitPlayer := f;

      {count assists}
      if (not((false)                   // Wild animal
                       and (player[g,f].hasSkill('Wild Animal'))))
        and (not((player[g,f].hasSkill('Ball and Chain'))))
        and (not((player[g,f].hasSkill('Maniac')))) then begin
        tz := CountTZBlockA(g0, f0);
        bx := false;
        for p := 1 to tz.num do begin
          if tz.pl[p] <> f then begin
            if player[g,tz.pl[p]].hasSkill('Guard') then b := true
            else begin
              tz0 := CountTZBlockCA(g, tz.pl[p]);
              b := (tz0.num = 0);
         {     b := ((tz0.num = 1) and (player[g0,f0].tz = 0))
                or ((tz0.num = 0) and (player[g0,f0].tz <> 0)) or
                ((tz0.num = 1) and (frmSettings.cbNoTZAssist.checked));  }
            end;
            if b then begin
              assa := assa + 1;
              if not(bx) then begin
                bx := true;
              end;
            end;
          end;
        end;
      end;
      assd := 0;
      {count counterassists}
      if (not((player[g,f].hasSkill('Ball and Chain')))) then begin
        tz := CountTZBlockCA2(g, f);
        bx := false;
        for p := 1 to tz.num do begin
          if tz.pl[p] <> f0 then begin
            if player[g0,tz.pl[p]].hasSkill('Guard') then b := true
            else begin
              tz0 := CountTZBlockCA(g0, tz.pl[p]);
              b := (tz0.num = 0);
              {b := ((tz0.num = 1) and (player[g,f].tz = 0))
                or ((tz0.num = 0) and (player[g,f].tz <> 0));}
            end;
            if b then begin
              assd := assd + 1;
              if not(bx) then begin
                bx := true;
              end;
            end;
          end;
        end;
      end;
      if (stx + assa < 1) and (player[g,f].st > 0) then begin
        assa := 0;
      end;
      if (player[g,f].hasSkill('Dauntless')) then
        daunt := ' -- Blocker Dauntless not applied' else
        if (player[g0,f0].hasSkill('Double Dauntless')) then
        daunt := daunt + ' -- Defender Double Dauntless not applied';
      if stx + assa > 2 * (std + assd) then begin
        Bloodbowl.comment.Text := '3 Dice Block' + daunt;
      end else if stx + assa > std + assd then begin
        Bloodbowl.comment.Text := '2 Dice Block' + daunt;
      end else if stx + assa = std + assd then begin
        Bloodbowl.comment.Text := '1 Dice Block' + daunt;
      end else
       if 2 * (stx + assa) < std + assd then begin
        Bloodbowl.comment.Text := '3 Dice Block (DEFENDERS CHOICE)' + daunt;
      end else begin
        Bloodbowl.comment.Text := '2 Dice Block (DEFENDERS CHOICE)' + daunt;
      end;
    end;
  end;
end;

procedure TPlayer.StartMoveToField;
var s: string;
begin
  s := MakeCurrent;
  if s <> '' then LogWrite(s);
  GameStatus := 'Field player';
end;

procedure TPlayer.MoveToField(p0, q0, st: integer);
begin
  parent := Bloodbowl;
  status := st;
  p := p0;
  q := q0;
  top := field[p0,q0].top;
  left := field[p0,q0].left;
  Redraw;
  ShowCurrentPlayer(teamnr, number);
end;

procedure TPlayer.SetStatusDef(st: integer);
begin
  if status <> st then begin
    if (status = 2) or (st = 2) then ClearBall;
    if st >= 70 then begin
      status := 7;
      SIstatus := st - 70;
    end else if st = 12 then begin
      SOstatus := status;
      SOSIstatus := SIstatus;
      status := 12;
    end else begin
      status := st;
      if st = 0 then begin
        SOstatus := 0;
        SOSIstatus := 0;
      end;
    end;
    if (st = 0) or (st >= 5) then begin
      p := -1;
      q := -1;
    end else begin
      if st = 2 then begin
        ball.p := teamnr - 3;
        ball.q := number;
      end;
    end;
  end;
end;

procedure TPlayer.SetStatus(newStatus: integer);
var s, s2: string;
    st0,g,f: integer;
begin
  st0 := status;
  if newStatus <> st0 then begin
    g := teamnr;
    f := number;
    if (st0 = 2) or (newStatus = 2) then s := ClearBall else s := '';
    if (teamnr = curmove) and (font.size > 8) then begin
      if not(((st0 = 3) and (newStatus = 1) and hasSkill('JUMP UP'))
             or (st0 = 2) or (newStatus = 2))
      then s := s + '-';
    end;
    s := 'P' + Chr(teamnr + 48) + Chr(number + 65) + Chr(p + 65) +
         Chr(q + 65) + Chr(st0 + 48) + Chr(newStatus + 48) + s;
    if CanWriteToLog then begin
      LogWrite(s);
      PlayActionSetStatus(s, 1);
    end;
    if (newStatus = 4) and (frmSettings.cbDeStun.Checked) then begin
      if (g=curmove) then
        s2 := 'QS' + Chr(g + 48) + Chr(f + 64) + Chr(50)
        else if (turn[0,1].Font.Size = 12) and (turn[1,1].Font.Size = 12) and
          (g=(1-KickOffTeam)) then s2 := 'QS' + Chr(g + 48) + Chr(f + 64) + Chr(50)
        else s2 := 'QS' + Chr(g + 48) + Chr(f + 64) + Chr(49);
      LogWrite(s2);
      PlayActionDeStun(s2, 1);
      if (g=curmove) then begin
        s2 := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
        LogWrite(s2);
        PlayActionEndOfMove(s2, 1);
      end;
    end;
    if (player[g,f].HasSkill('Take Root')) and
      (frmSettings.cbOPTakeRoot.checked) and (player[g,f].ma = 0) and ((st0 = 1)
      or (st0 = 2)) and ((newStatus = 3) or (newStatus = 4)) then begin
      s := 'u' + Chr(g + 48) + Chr(f + 64) +
           Chr(0 + 48) +
           Chr(player[g, f].st + 48) +
           Chr(player[g, f].ag + 48) +
           Chr(player[g, f].av + 48) +
           Chr(player[g,f].cnumber + 64) +
           Chr(player[g,f].value div 5 + 48) +
           player[g,f].name + '$' +
           player[g,f].position + '$' +
           player[g,f].picture + '$' +
           player[g,f].icon + '$' +
           player[g, f].GetSkillString(1) + '|' +
           Chr(player[g, f].ma0 + 48) +
           Chr(player[g, f].st + 48) +
           Chr(player[g, f].ag + 48) +
           Chr(player[g, f].av + 48) +
           Chr(player[g,f].cnumber + 64) +
           Chr(player[g,f].value div 5 + 48) +
           player[g,f].name + '$' +
           player[g,f].position + '$' +
           player[g,f].picture + '$' +
           player[g,f].icon + '$' +
           player[g, f].GetSkillString(1);
      if CanWriteToLog then begin
        LogWrite(s);
        PlayActionPlayerStatChange(s, 1);
      end;
    end;
  end;
end;

procedure TPlayer.ShowPlayerDetails;
var h, txtlen, p, p2, p3: integer;
    s2, t, t2: string;
begin
  if (LoadedFileFirstBlood) and (LoadedFlag) then begin
    s2 := LoadedFile;
    p := Ord(s2[3]) - 48;
    if p = 0 then t2 := 'Load' else
      t2 := '*** ALERT *** RE-load ' + IntToStr(p);
    s2 := Copy(s2, 3, length(s2) - 2);
    p := Pos('@', s2);
    p2 := Pos('%', s2);
    p3 := Pos('$', s2);
    t2 := t2 + ' by ' + Copy(s2, 2, p-2) + ' at ' + Copy(s2, p+1, p2-p-1) +
      ' -- Save time: ' + Copy(s2, p2+1, p3-p2-1) + ' -- Ver: ' +
      Copy(s2, p3+1, Length(s2) - p3);
    if Bloodbowl.SpeakLabel.caption[1] = 'H' then t := Chr(253)
      else t := Chr(254);
    LogWrite(t + t2 + Chr(255));
    if Bloodbowl.SpeakLabel.caption[1] = 'H' then t := ffcl[0]
      else t := ffcl[1];
    AddLog(t + ': "' + t2 + '"');
    LoadedFileFirstBlood := false;
    LoadedFlag := false;
  end;
  if av > 0 then begin
    PlayerData[teamnr,1].caption := IntToStr(cnumber);
    txtlen := Length(name);
    if txtlen>25 then PlayerData[teamnr,2].font.size := 9 else
      if txtlen>20 then PlayerData[teamnr,2].font.size := 10 else
      PlayerData[teamnr,2].font.size := 12;
    PlayerData[teamnr,2].caption := name;
    txtlen := Length(position);
    if txtlen>25 then PlayerData[teamnr,3].font.size := 9 else
      if txtlen>20 then PlayerData[teamnr,3].font.size := 10 else
        PlayerData[teamnr,3].font.size := 12;
    PlayerData[teamnr,3].caption := position;
    PlayerData[teamnr,4].caption := IntToStr(ma) + ' ' +
       IntToStr(st) + ' ' + IntToStr(ag) + ' ' + IntToStr(av);
    txtlen := Length(GetSkillString(-1));
    if txtlen>100 then
      PlayerData[teamnr,5].font.size := 9
    else
      PlayerData[teamnr,5].font.size := 10;

    PlayerData[teamnr,5].caption := GetSkillString(-1);
    if Trim(PlayerData[teamnr,5].caption) <> '' then
      PlayerData[teamnr,5].caption := PlayerData[teamnr,5].caption + Chr(13);

    PlayerData[teamnr,5].caption := PlayerData[teamnr,5].caption + 'Total SPP: ' + IntToStr(GetPlayerSPP());
    if ((teamnr=0) and (HomePic<>picture)) or
       ((teamnr<>0) and (AwayPic<>picture)) then begin
      if picture = '' then begin
        if teamnr = 0 then Bloodbowl.imPlayerImageRed.visible := false
                      else Bloodbowl.imPlayerImageBlue.visible := false;
      end else begin
       if teamnr = 0 then begin
         if FileExists(curdir + 'roster\' + picture) then
             Bloodbowl.imPlayerImageRed.picture.LoadFromFile(curdir +
                                                          'roster\' + picture)
         else
             Bloodbowl.imPlayerImageRed.picture.LoadFromFile(
                                  curdir + 'images\noplaypic.jpg');
           Bloodbowl.imPlayerImageRed.visible := true;
        end else begin
         if FileExists(curdir + 'roster\' + picture) then
             Bloodbowl.imPlayerImageBlue.picture.LoadFromFile(curdir +
                                                          'roster\' + picture)
         else
             Bloodbowl.imPlayerImageBlue.picture.LoadFromFile(
                                  curdir + 'images\noplaypic.jpg');
          Bloodbowl.imPlayerImageBlue.visible := true;
        end;
      end;
      if teamnr=0 then HomePic := picture else AwayPic := picture;
    end;
  end
  else
  begin
    for h := 1 to 5 do PlayerData[teamnr,h].caption := '';
    if teamnr = 0 then Bloodbowl.imPlayerImageRed.visible := false
                  else Bloodbowl.imPlayerImageBlue.visible := false;
  end;
end;

function STinColor(f, g: integer; ci: TColor): TColor;
type cr = array [0..3] of byte;
var c: TColor;
    r: ^cr;
    i, st, x: integer;
begin
  c := ci;
  r := Addr(c);
{  i := -1;
  if (r^[0] = 255) and (r^[1] = 0) and (r^[2] = 0) and (r^[3] = 0) then i := 0
  else
   if (r^[0] = 0) and (r^[1] = 0) and (r^[2] = 255) and (r^[3] = 0) then i := 2;
  if (i >= 0) and (player[g,f].st > 2) and (player[g,f].st < 9) then
             r^[i] := 255 - 32 * (player[g,f].st - 2);
  if (i >= 0) and (player[g,f].st > 8) then
             r^[i] := 255 - 32 * 6;
  STinColor := c;}

  if player[g,f].st > 2 then begin
    st := 10 - player[g,f].st;
    if st < 2 then st := 2;
    for i := 0 to 2 do begin
      x := (r^[i] * st) div 8;
      r^[i] := x;
    end;
    STinColor := c;
  end else begin
    STinColor := ci;
  end;
end;

procedure TPlayer.Redraw;
{var f, g: integer;}
begin
{  f := number;
  g := teamnr;
  if (f < 1) or (f > 16) or (g < 0) or (g > 1) then begin
    hint := 'ERROR';
  end;}
  if (status <= 1) or ((status >= 5) and (status <= 8)) then
    color := STinColor(number, teamnr,
                     colorarray[teamnr, player[teamnr,number].status, 0])
  else color := colorarray[teamnr, player[teamnr,number].status, 0];
  font.color := colorarray[teamnr, player[teamnr,number].status, 1];
  if (status < 5) and (tz > 0) then
     font.color := clBlack;
  hint := statusarray[status];
  if status = 7 then
    hint := hint + SIstatusarray[SIstatus];
{  case status of
    0: popupmenu := Bloodbowl.reservePopup;
    1, 2, 3, 4: popupmenu := Bloodbowl.playerPopup;
    5, 6, 7, 8, 9, 10, 11, 12, 13, 14: popupmenu := Bloodbowl.koPopup;
  end;}
  BringToFront;
  if ref then Refresh;
end;

procedure RedrawDugout;
var f, k, h, l, d, tp, lf: integer;
    t: array [1..3] of integer;
begin
  k := 0;
  while k < 2 do begin
    for h := 1 to 3 do t[h] := 0;
    for f := 1 to team[k].numplayers do begin
      if player[k,f].status = 0 then t[1] := t[1] + 1;
      if player[k,f].status = 5 then t[2] := t[2] + 1;
      if (player[k,f].status > 5) and (player[k,f].status <> 11)
       then t[3] := t[3] + 1;
    end;
    for h := 1 to 3 do begin
      d := 1;
      if (h = 1) and (t[h] > 8) then d := 1 + t[h] div 8;
      if t[h] > 12 then d := 1 + t[h] div 11;
      l := (t[h] + d - 1) div d;
      t[h] := t[h] - l;
      tp := 0;
      lf := pnlDugOut[k,h].width div 2 - 10 * l;
      for f := 1 to team[k].numplayers do begin
        if ((h = 1) and (player[k,f].status = 0))
        or ((h = 2) and (player[k,f].status = 5))
        or ((h = 3) and (player[k,f].status > 5) and (player[k,f].status <> 11))
        then begin
          player[k,f].parent := pnlDugOut[k,h];
          player[k,f].top := tp;
          player[k,f].left := lf;
          lf := lf + 20;
          l := l - 1;
          if (l = 0) and (t[h] > 0) then begin
            tp := tp + 20;
            d := d - 1;
            l := (t[h] + d - 1) div d;
            t[h] := t[h] - l;
            lf := pnlDugOut[k,h].width div 2 - 10 * l;
          end;
        end;
      end;
    end;
    k := k + 1;
  end;
  for k := 0 to 1 do
   for f := 1 to team[k].numplayers do begin
     if player[k,f].status = 11 then player[k,f].visible := false;
     player[k,f].Redraw;
   end;
end;

procedure PlayActionMakeCurrent(s: string; dir: integer);
begin
  UnCur;
  if ((dir = DIR_FORWARD) or ((dir = -1) and (Length(s) > 3))) {and ref} then begin
    Bloodbowl.Completion1.enabled := true;
    Bloodbowl.Interception1.enabled := true;
    Bloodbowl.Touchdown1.enabled := true;
    Bloodbowl.Casualty1.enabled := true;
    Bloodbowl.OtherSPP1.enabled := true;
    Bloodbowl.MVPAward1.enabled := true;
    Bloodbowl.sbOtherSPP.enabled := true;
    Bloodbowl.compSB.enabled := true;
    Bloodbowl.interceptionSB.enabled := true;
    Bloodbowl.touchdownSB.enabled := true;
    Bloodbowl.casualtySB.enabled := true;
    Bloodbowl.SBMVP.enabled := true;
    if dir = DIR_FORWARD then begin
      curteam := Ord(s[2]) - 48;
      curplayer := Ord(s[3]) - 64;
    end else begin
      curteam := Ord(s[5]) - 48;
      curplayer := Ord(s[6]) - 64;
    end;
    ShowCurrentPlayer(curteam, curplayer);
    if (dir = DIR_FORWARD) and (Length(s) > 6) then
      RemoveMultipleNumOnField(Copy(s, 7, Length(s) - 6));
    if (dir = -1) and (Length(s) > 6) then
      PutMultipleNumOnField(Copy(s, 7, Length(s) - 6));
  end;
end;

function TPlayer.MakeCurrent: string;
var s: string;
begin
  s := '';
  if (curteam <> teamnr) or (curplayer <> number) then begin
    s := ';' + Chr(teamnr + 48) + Chr(number + 64) + UnCurSub;
    PlayActionMakeCurrent(s, 1);
  end;
  ShowCurrentPlayer(teamnr, number);
  if s <> '' then s := ')' + s;
  MakeCurrent := s;
end;

procedure PlayActionUncur(s: string; dir: integer);
var f, g: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  if (dir = 1) {and ref} then begin
    Bloodbowl.Completion1.enabled := false;
    Bloodbowl.Interception1.enabled := false;
    Bloodbowl.Touchdown1.enabled := false;
    Bloodbowl.Casualty1.enabled := false;
    Bloodbowl.OtherSPP1.enabled := false;
    Bloodbowl.MVPAward1.enabled := false;
    Bloodbowl.sbOtherSPP.enabled := false;
    Bloodbowl.compSB.enabled := false;
    Bloodbowl.interceptionSB.enabled := false;
    Bloodbowl.touchdownSB.enabled := false;
    Bloodbowl.casualtySB.enabled := false;
    Bloodbowl.SBMVP.enabled := false;
    player[g,f].Redraw;
    player[g,f].PopupMenu := nil;
    Bloodbowl.CurBox.visible := false;
    if ref then Bloodbowl.CurBox.Refresh;
    curteam := -1;
    GameStatus := '';
  end else begin
    player[g,f].MakeCurrent;
    PutMultipleNumOnField(Copy(s, 4, Length(s) - 3));
  end;
end;

procedure UnCur;
begin
  if curteam > -1 then begin
    PlayActionUnCur(',' + Chr(curteam + 48) + Chr(curplayer + 64), 1);
  end;
end;

function UnCurSub: string;
var s: string;
begin
  if curteam > -1 then begin
    s := ',' + Chr(curteam + 48) + Chr(curplayer + 64) + SubtractAllNumOnField;
    PlayActionUnCur(s, 1);
  end else s := '';
  UnCurSub := s;
end;

function TPlayer.GetPlayerName: string;
var s: string;
begin
  s := ffcl[teamnr] + ' #' + IntToStr(cnumber);
  if name <> '' then
    s := s + ' (' + name + ')';
  GetPlayerName := s;
end;

procedure TPlayer.SetSkill(s: string; translate: boolean);
var s0, t: string;
    f, p: integer;
begin
  BigGuy := false;
  Ally := false;
  for f := 1 to 15 do skill[f] := '';
  s0 := Trim(s);
  f := 0;
  while Length(s0) > 0 do begin
    p := Pos(',', s0);
    if p = 0 then p := Length(s0) + 1;
    t := Trim(Copy(s0, 1, p - 1));
    if t <> '' then begin
      if translate then t := TranslateSkillToEnglish(t);
      if Uppercase(t) = 'ALLY' then Ally := true else
      if Uppercase(t) = 'LONER' then Ally := true else
      if Uppercase(t) = 'BIG GUY' then BigGuy := true else begin
        f := f + 1;
        if f < 15 then skill[f] := t;
      end;
    end;
    s0 := Copy(s0, p + 1, length(s0) - p);
  end;
  while f < 15 do begin
    f := f + 1;
    skill[f] := '';
  end;
end;

procedure TPlayer.SetSkill(s: string);
begin
  SetSkill(s, false);
end;

function TPlayer.GetSkillString(i: integer): string;
var s: string;
    f: integer;

   procedure Add(t: string);
   begin
     if t <> '' then begin
       if i < 0 then t := TranslateSkillToLanguage(t);
       if s = '' then s := t else s := s + ', ' + t;
     end;
   end;

begin
  s := '';
  if Abs(i) <> 2 then begin
    if Ally then begin
      Add('LONER');
    end;
    if BigGuy then Add('BIG GUY');
    for f := 1 to 15 do Add(skill[f]);
  end else begin
    if Ally0 then begin
      Add('LONER');
    end;
    if BigGuy0 then Add('BIG GUY');
    for f := 1 to 15 do Add(skill0[f]);
  end;
  GetSkillString := s;
end;

function TPlayer.hasSkill(s: string): boolean;
var f: integer;
    t: string;
begin
  t := Uppercase(s);
  f := 1;
  if t[Length(t)] = '*' then begin
    t := Copy(t, 1, Length(t) - 1);
    while (f <= 15) and (t <> Copy(Uppercase(skill[f]), 1, Length(t))) do
       f := f + 1;
  end else begin
    while (f <= 15) and (t <> Uppercase(skill[f])) do f := f + 1;
  end;
  hasSkill := (f <= 15);
end;

function TPlayer.Get1Skill(s: string): string;
var f: integer;
    t: string;
begin
  t := Uppercase(s);
  f := 1;
  if t[Length(t)] = '*' then begin
    t := Copy(t, 1, Length(t) - 1);
    while (f <= 15) and (t <> Copy(Uppercase(skill[f]), 1, Length(t))) do
       f := f + 1;
  end else begin
    while (f <= 15) and (t <> Uppercase(skill[f])) do f := f + 1;
  end;
  if f <= 15 then Get1Skill := skill[f] else Get1Skill := '';
end;

function TPlayer.hasNewSkills: boolean;
var f: integer;
begin
  if (BigGuy0 <> BigGuy) or (Ally0 <> Ally) then hasNewSkills := true
  else begin
    f := 1;
    while (f <= 15) and (skill[f] = skill0[f]) do f := f + 1;
    hasNewSkills := (f <= 15);
  end;
end;

procedure TPlayer.RestoreSkills;
var f: integer;
begin
  BigGuy := BigGuy0;
  Ally := Ally0;
  for f := 1 to 15 do skill[f] := skill0[f];
end;

procedure TPlayer.SetSkillsToDefault;
var f: integer;
begin
  BigGuy0 := BigGuy;
  Ally0 := Ally;
  for f := 1 to 15 do skill0[f] := skill[f];
end;

function TPlayer.usedSkill(s: string): boolean;
var f: integer;
    t: string;
begin
  t := Uppercase(s);
  f := 1;
  while (f <= 15) and (t <> Uppercase(skill[f])) do f := f + 1;
  if f > 15 then begin
    ShowMessage('ERROR on using skill ' + s + Chr(13) +
                             'Send bbm file to ' + EMailAddress + '!!!');
    f := 1;
  end;
  usedSkill := uskill[f];
end;

procedure TPlayer.UseSkill(s: string);
var f: integer;
    t: string;
begin
  t := Uppercase(s);
  f := 1;
  if t[Length(t)] = '*' then begin
    t := Copy(t, 1, Length(t) - 1);
    while (f <= 15) and (t <> Copy(Uppercase(skill[f]), 1, Length(t))) do
       f := f + 1;
  end else begin
    while (f <= 15) and (t <> Uppercase(skill[f])) do f := f + 1;
  end;
  if f > 15 then ShowMessage('ERROR on using skill ' + s + Chr(13) +
                             'Send bbm file to ' + EMailAddress + '!!!')
  else begin
    t := 'k' + Chr(teamnr + 48) + Chr(number + 65) + Chr(f + 65);
    if CanWriteToLog then begin
      LogWrite(t);
      PlayActionUseSkill(t, 1);
    end;
  end;
end;

procedure PlayActionUseSkill(s: string; dir: integer);
var f, g, i, curturn, f2: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  i := Ord(s[4]) - 65;
  if dir = DIR_FORWARD then begin
    DefaultAction(player[g,f].GetPlayerName + ' uses ' +
                  player[g,f].skill[i] + ' skill');
    player[g,f].uskill[i] := true;
    if UpperCase(Copy(player[g,f].skill[i], 1, 5)) = 'REGEN' then
        player[g,f].UsedRegeneration := true;
    if (player[g,f].skill[i] = 'TIKSTPK') and (player[g, f].tz > 0) then begin
      curturn := 0;
      for f2 := 1 to 8 do begin
        if turn[g,f2].color = clYellow then curturn := f2;
      end;
      player[g,f].TIKSTPK := (HalfNo * 10) + curturn;
    end;
  end else begin
    BackLog;
    player[g,f].uskill[i] := false;
    if UpperCase(Copy(player[g,f].skill[i], 1, 5)) = 'REGEN' then
        player[g,f].UsedRegeneration := false;
  end;
end;

function TranslateFieldPlayer(s: string): string;
begin
  TranslateFieldPlayer :=
       player[Ord(s[2]) - 48, Ord(s[3]) - 64].GetPlayerName +
       ' enters field at ' +
       field[Ord(s[4]) - 65, Ord(s[5]) - 65].hint;
end;

procedure PlayActionFieldPlayer(s: string; dir: integer);
var f, g, p, q, v: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  p := Ord(s[4]) - 65;
  q := Ord(s[5]) - 65;
  if dir = DIR_FORWARD then begin
    DefaultAction(TranslateFieldPlayer(s));
    player[g,f].MoveToField(p, q, 1);
    v := Ord(s[6]) - 65;
    if v >= 0 then RemoveNumOnField(v);
    player[g,f].PlayedThisMatch := true;
    player[g,f].PlayedThisDrive := true;
  end else begin
    BackLog;
    v := Ord(s[6]) - 65;
    if v >= 0 then begin
      PutNumOnField(p, q, v, Ord(s[7]) - 65);
    end else field[p,q].caption := '';
    player[g,f].status := 0;
    player[g,f].PlayedThisMatch := false;
    player[g,f].PlayedThisDrive := false;
  end;
  RedrawDugOut;
  ShowCurrentPlayer(g,f);
end;

function TranslateMoveToReserve(s: string): string;
begin
    if s[1] = 'r' then
      TranslateMoveToReserve :=
          player[Ord(s[2]) - 48, Ord(s[3]) - 64].GetPlayerName +
          ' from KO to reserve'
    else
      TranslateMoveToReserve :=
          player[Ord(s[2]) - 48, Ord(s[3]) - 64].GetPlayerName +
          ' from Out to reserve';
end;

procedure PlayActionMoveToReserve(s: string; dir: integer);
var f, g, h: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  if dir = DIR_FORWARD then begin
    DefaultAction(TranslateMoveToReserve(s));
    UnCur;
    player[g,f].SetStatusDef(0);
  end else begin
    BackLog;
    if s[1] = 'r' then h := 5 else h := Ord(s[4]) - 48;
    player[g,f].SetStatusDef(h);
    player[g,f].MakeCurrent;
  end;
end;

procedure PlayActionEndOfMove(s: string; dir: integer);
var f, g: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  if dir = DIR_FORWARD then begin
    player[g,f].font.size := 8;
    player[g,f].UsedMA := 15;
    DefaultAction(player[g,f].GetPlayerName + ' end of move');
    UnCur;
  end else begin
    BackLog;
    player[g,f].font.size := 12;
    player[g,f].UsedMA := Ord(s[4]) - 64;
    player[g,f].MakeCurrent;
  end;
  player[g,f].Redraw;
end;

procedure PlayActionResetMove(s: string; dir: integer);
var f, g: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  if dir = DIR_FORWARD then begin
    player[g,f].font.size := 12;
    player[g,f].UsedMA := 0;
  end else begin
    player[g,f].font.size := 8;
    player[g,f].UsedMA := Ord(s[4]) - 64;
  end;
  player[g,f].Redraw;
end;

procedure PlayActionBlockMove(s: string; dir: integer);
var f, g: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  if dir = DIR_FORWARD then begin
    player[g,f].font.size := 8;
    player[g,f].UsedMA := Ord(s[4]) - 63;
    if Length(s) > 4 then FollowUp := s[2] + s[3] + s[5] + s[6];
{    DefaultAction(player[g,f].GetPlayerName + ' blocks/fouls');}
    UnCur;
  end else begin
{    BackLog;}
    player[g,f].UsedMA := Ord(s[4]) - 64;
    if player[g,f].UsedMA = 0 then player[g,f].font.size := 12;
    player[g,f].MakeCurrent;
  end;
  player[g,f].Redraw;
end;

procedure PlayActionColorChange(s: string; dir: integer);
var g: integer;
begin
  g := Ord(s[2]) - 48;
  FillColorArray(g, StringToColor((Copy(s, 3, 9))));
  RepaintColor(g);
end;

procedure PlayActionPlayerMove(s: string; dir: integer);
var f, g, p, q, v: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  if dir = DIR_FORWARD then begin
    p := Ord(s[6]) - 65;
    q := Ord(s[7]) - 65;
    DefaultAction(player[g,f].GetPlayerName + ' moves to ' + field[p,q].hint);
    v := Ord(s[9]) - 65;
    if (v >= 0) and (v < 15) then player[g,f].UsedMA := v;
    if s[length(s)] = '-' then begin
      player[g,f].font.size := 8;
      s := Copy(s, 1, length(s) - 1);
    end;
    RemoveMultipleNumOnField(Copy(s, 10, length(s) - 9));
    player[g,f].MoveToField(p, q, player[g,f].status);
    player[g,f].LastAction := 1;
    GameStatus := '';
  end else begin
    p := Ord(s[4]) - 65;
    q := Ord(s[5]) - 65;
    BackLog;
    if s[length(s)] = '-' then begin
      player[g,f].font.size := 12;
      s := Copy(s, 1, length(s) - 1);
    end;
    player[g,f].MoveToField(p, q, player[g,f].status);
    v := Ord(s[8]) - 65;
    if (v >= 0) and (v < 15) then player[g,f].UsedMA := v;
    PutMultipleNumOnField(Copy(s, 10, Length(s) - 9));
  end;
end;

procedure PlacePlayer(f, g, p, q: integer);
var s: string;
    tz: TackleZones;
    v, c: integer;
begin
  c := 0;
  if field[p,q].caption = 'X' then v := 15
            else v := FVal(field[p,q].caption) - 1;
  if player[g, f].status = 0 then begin
    if CanWriteToLog then begin
      if v > -1 then c := NumOnFieldColor(v);
      s := 'F' + Chr(g + 48) + Chr(f + 64) +
           Chr(p + 65) + Chr(q + 65) + Chr(v + 65) + Chr(c + 65);
      LogWrite(s);
      PlayActionFieldPlayer(s, 1);
      if player[g,f].HasSkill('Leader') and not(team[g].UsedLeaderReroll)
      and (marker[g, MT_Leader].value = 0) then begin
        marker[g, MT_Leader].MarkerMouseUp(
              marker[g, MT_Leader], mbLeft, [], 0, 0);
      end;
    end;
  end else if player[g, f].status < 5 then begin
    if (player[g, f].status = 3) and (g = curteam) then begin
      if not(DodgeNoStand) then begin
        if Application.MessageBox('Player stands up?', 'Player move',
                MB_OKCANCEL) = IDOK then begin
          player[g, f].SetStatus(1);
        end;
      end;
    end;
    if ((player[g, f].hasSkill('Stand Firm')) and (g <> curmove)) or
       ((player[g, f].hasSkill('Side Step')) and (g <> curmove) and
       (SideStepStop)) then begin
         Application.Messagebox('Opponent just moved has Stand Firm' +
                ' or Side Step!', 'Bloodbowl Movement Warning', MB_OK);
    end;
    if not(SideStepStop) then SideStepStop := true;
    tz := CountTZDTS(g, f);
    if ((tz.num > 0) and ((tz.num < 10) or (tz.num >= 100))
      and (g = curmove)) then begin
          Application.Messagebox('Adjacent opponent had Trip Up or ' +
                 'Shadowing!', 'Bloodbowl Movement Warning', MB_OK);
          LastFieldP := player[g,f].p;
          LastFieldQ := player[g,f].q;
    end;
    if ((tz.num >= 10) and (tz.num < 100) and (g = curmove)) then
        Application.Messagebox('Reminder:  Place Diving Tackle opponent prone' +
                ' in the square you LEFT if the skill was used!',
                'Bloodbowl Movement Warning', MB_OK);
    if CanWriteToLog then begin
      if v > -1 then s := ClearNumOnFieldUpTo(v + 1) else begin
        s := ClearAllNumOnField;
        if FollowUp = '' then v := player[g,f].UsedMA else begin
          if FollowUp[1] = Chr(g + 48) then begin
            if FollowUp = Chr(g + 48) + Chr(f + 65) + Chr(p + 65) + Chr(q + 65)
            then begin
              v := player[g,f].UsedMA - 1;
            end else begin
              FollowUp := '';
              v := player[g,f].UsedMA;
            end;
          end;  
        end;
      end;
      if (g = curmove)
       and (player[g,f].font.size > 8) then begin
        player[g,f].font.size := 8;
        s := s + '-';
      end;
      s := 'M' + Chr(g + 48) + Chr(f + 65) +
               Chr(player[g,f].p + 65) +
               Chr(player[g,f].q + 65) +
               Chr(p + 65) + Chr(q + 65) +
               Chr(player[g,f].UsedMA + 65) + Chr(v + 66) + s;
      LogWrite(s);
      PlayActionPlayerMove(s, 1);
    end;
  end;
end;

function TranslateSetStatus(s: string): string;
var v, sv: integer;
    s0: string;
begin
  sv := 0;
  v := Ord(s[7]) - 48;
  if v >= 70 then begin
    sv := v - 70;
    v := 7;
  end;
  s0 := player[Ord(s[2]) - 48, Ord(s[3]) - 65].GetPlayerName +
       ' ' + statusarray[v];
  if v = 7 then s0 := s0 + SIstatusarray[sv];
  TranslateSetStatus := s0;
end;

procedure PlayActionSetStatus(s: string; dir: integer);
var f, g, p, q, sto, stn: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  sto := Ord(s[6]) - 48;
  stn := Ord(s[7]) - 48;
  if dir = DIR_FORWARD then begin
    DefaultAction(TranslateSetStatus(s));
    player[g,f].SetStatusDef(stn);
    if s[length(s)] = '-' then player[g,f].font.size := 8;
    player[g,f].Redraw;
    if (stn = 0) or (stn >= 5) or (sto = 0) or (sto >= 5) then RedrawDugOut;
    player[g,f].LastAction := 0;
    if player[g,f].HasSkill('Regen*') and (stn = 0) and (sto >= 6) and
      (sto <= 8) then
      player[g,f].UsedRegeneration := false;
    {UnCur;}
  end else begin
    p := Ord(s[4]) - 65;
    q := Ord(s[5]) - 65;
    if stn >= 70 then stn := 7;
    BackLog;
    if s[length(s)] = '-' then player[g,f].font.size := 12;
    if (sto >= 1) and (sto <= 4) then player[g,f].MoveToField(p, q, sto)
     else player[g,f].SetStatusDef(sto);
    if (stn = 0) or (stn >= 5) or (sto = 0) or (sto >= 5) then RedrawDugOut;
    if (sto = 2) or (stn = 2) then GiveBall(Copy(s,8,3));
    if player[g,f].HasSkill('Regen*') and (sto = 0) and (stn >= 6) and
      (stn <= 8) then
      player[g,f].UsedRegeneration := true;
  end;
end;

procedure PlayActionSPP(s: string; dir: integer);
var f, g: integer;
    s0: string;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  if dir = DIR_FORWARD then begin
    case s[4] of
      'c': begin
             s0 := 'Completion';
             player[g,f].comp := player[g,f].comp + 1;
           end;
      'I': begin
             s0 := 'Interception';
             player[g,f].int := player[g,f].int + 1;
           end;
      'T': begin
             s0 := 'Touchdown';
             player[g,f].td := player[g,f].td + 1;
           end;
      'C': begin
             s0 := 'Casualty';
             player[g,f].cas := player[g,f].cas + 1;
           end;
      'O': begin
             s0 := '1 other SPP';
             player[g,f].otherSPP := player[g,f].otherSPP + 1;
           end;
      'E': begin
             s0 := 'EXP point';
             player[g,f].exp := player[g,f].exp + 1;
           end;
      'M': begin
             s0 := 'MVP Award';
             player[g,f].mvp := player[g,f].mvp + 1;
           end;
    end;
    AddLog(s0 + ' for ' + player[g,f].GetPlayerName);
    if WaitLength > 0 then Wait;
  end else begin
    case s[4] of
      'c': player[g,f].comp := player[g,f].comp - 1;
      'I': player[g,f].int := player[g,f].int - 1;
      'T': player[g,f].td := player[g,f].td - 1;
      'C': player[g,f].cas := player[g,f].cas - 1;
      'O': player[g,f].otherSPP := player[g,f].otherSPP - 1;
      'M': player[g,f].mvp := player[g,f].mvp - 1;
      'E': player[g,f].exp := player[g,f].exp - 1;
    end;
    BackLog;
  end;
end;

procedure PlayActionReverseSPP(s: string; dir: integer);
var f, g: integer;
    s0: string;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 65;
  if dir = DIR_FORWARD then begin
    case s[4] of
      'c': begin
             s0 := 'Completion';
             player[g,f].comp := player[g,f].comp - 1;
           end;
      'I': begin
             s0 := 'Interception';
             player[g,f].int := player[g,f].int - 1;
           end;
      'T': begin
             s0 := 'Touchdown';
             player[g,f].td := player[g,f].td - 1;
           end;
      'C': begin
             s0 := 'Casualty';
             player[g,f].cas := player[g,f].cas - 1;
           end;
      'O': begin
             s0 := '1 other SPP';
             player[g,f].otherSPP := player[g,f].otherSPP - 1;
           end;
      'E': begin
             s0 := 'EXP point';
             player[g,f].exp := player[g,f].exp - 1;
           end;
      'M': begin
             s0 := 'MVP Award';
             player[g,f].mvp := player[g,f].mvp - 1;
           end;
    end;
    AddLog('Remove ' + s0 + ' for ' + player[g,f].GetPlayerName);
    if WaitLength > 0 then Wait;
  end else begin
    case s[4] of
      'c': player[g,f].comp := player[g,f].comp + 1;
      'I': player[g,f].int := player[g,f].int + 1;
      'T': player[g,f].td := player[g,f].td + 1;
      'C': player[g,f].cas := player[g,f].cas + 1;
      'O': player[g,f].otherSPP := player[g,f].otherSPP + 1;
      'M': player[g,f].mvp := player[g,f].mvp + 1;
      'E': player[g,f].exp := player[g,f].exp + 1;
    end;
    BackLog;
  end;
end;

procedure PlayActionToggleTackleZone(s: string; dir: integer);
var f, g: integer;
    s0: string;
begin
  g := Ord(s[3]) - 48;
  f := Ord(s[4]) - 64;
  if dir = DIR_FORWARD then begin
    if s[2] = '+' then begin
      player[g, f].tz := 0;
      s0 := player[g,f].GetPlayerName + ' regains tackle zone';
    end else if s[2] = '-' then begin
      player[g, f].tz := 1;
      s0 := player[g,f].GetPlayerName + ' loses tackle zone';
    end;
    player[g,f].Redraw;
    DefaultAction(s0);
  end else begin
    if s[2] = '+' then player[g, f].tz := 1 else
     if s[2] = '-' then player[g, f].tz := 0;
    player[g,f].Redraw;
    BackLog;
  end;
end;

procedure PlayActionBombPlayer(s: string; dir: integer);
begin
  if dir = DIR_FORWARD then begin
    BombTeam := Ord(s[2]) - 48;
    BombPlayer := Ord(s[3]) -64;
  end else begin
    BombTeam := Ord(s[4]) - 48;
    BombPlayer := Ord(s[5]) -64;
  end;
end;

procedure PlayActionPlayerStatChange(s: string; dir: integer);
var f, g, p, p1, p2, p3, p4, p21, p22, p23, p24: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  p := pos('|', s);
  p21 := pos('$', Copy(s,p+7,length(s)))+p+6;
  p22 := pos('$', Copy(s,p21+1,length(s)))+p21;
  p23 := pos('$', Copy(s,p22+1,length(s)))+p22;
  p24 := pos('$', Copy(s,p23+1,length(s)))+p23;
  p1 := pos('$', Copy(s,10,length(s)))+9;
  p2 := pos('$', Copy(s,p1+1,length(s)))+p1;
  p3 := pos('$', Copy(s,p2+1,length(s)))+p2;
  p4 := pos('$', Copy(s,p3+1,length(s)))+p3;
  if dir = 1 then begin
    player[g,f].ma := Ord(s[p+1]) - 48;
    player[g,f].st := Ord(s[p+2]) - 48;
    player[g,f].ag := Ord(s[p+3]) - 48;
    player[g,f].av := Ord(s[p+4]) - 48;
    player[g,f].cnumber := Ord(s[p+5]) - 64;
    player[g,f].value := (Ord(s[p+6]) - 48) * 5;
    player[g,f].name := Copy(s,p+7,p21-(p+7));
    player[g,f].position := Copy(s,p21+1,p22-(p21+1));
    player[g,f].picture := Copy(s,p22+1,p23-(p22+1));
    player[g,f].icon := Copy(s,p23+1,p24-(p23+1));
    player[g,f].SetSkill(Copy(s, p24+1, length(s)));
    DefaultAction(player[g,f].GetPlayerName + ' stats changed');
  end else begin
    player[g,f].ma := Ord(s[4]) - 48;
    player[g,f].st := Ord(s[5]) - 48;
    player[g,f].ag := Ord(s[6]) - 48;
    player[g,f].av := Ord(s[7]) - 48;
    player[g,f].cnumber := Ord(s[8]) - 64;
    player[g,f].value := (Ord(s[9]) - 48) * 5;
    player[g,f].name := Copy(s,10,p1-10);
    player[g,f].position := Copy(s,p1+1,p2-(p1+1));
    player[g,f].picture := Copy(s,p2+1,p3-(p2+1));
    player[g,f].icon := Copy(s,p3+1,p4-(p3+1));
    player[g,f].SetSkill(Copy(s, p4+1, p-(p4+1)));
    BackLog;
  end;
  player[g,f].Redraw;
  player[g,f].caption := IntToStr(player[g,f].cnumber);
  player[g,f].visible := true;
  player[g,f].ShowPlayerDetails;
end;

function TPlayer.GetSaveString: string;
var s0: string;
begin
  s0 := Chr(teamnr + 48) + Chr(number + 64) +
        trim(name) + Chr(255) + trim(position) + Chr(255) +
        trim(GetSkillString(1)) + Chr(255) + trim(inj) + Chr(255) +
        Chr(ma + 48) + Chr(st + 48) + Chr(ag + 48) + Chr(av + 48) +
        Chr(int0 + 48) + Chr(td0 + 48) + Chr(cas0 + 48) +
        Chr(comp0 + 48) + Chr(mvp0 + 48);
  if peaked then s0 := s0 + 'P' else s0 := s0 + '-';
  s0 := s0 + Chr(value div 10 + 48) + Chr(cnumber + 48);
  if frmSettings.cbUseOtherSPP.checked then s0 := s0 + Chr(otherSPP0 + 48);
  s0 := s0 + Chr(255) + picture;
  GetSaveString := s0;
end;

function TPlayer.GetPlayerSPP(): integer;
var spp: integer;
begin
  spp := 0;
  // always show SPP details
  spp := comp + 3 * td + 2 * cas + 2 * int + bbalg.MVPValue * mvp + otherspp + exp;
  spp := spp + comp0 + 3 * td0 + 2 * cas0 + 2 * int0 + bbalg.MVPValue * mvp0 + otherspp0 + exp0;
  Result := spp;
end;

procedure LeftClickPlayer(g,f: integer);
var s, lostcontrol, BANG, RerollAnswer, s2, WAAnswer: string;
    f0, f2, Bhead, RSHelp, curturn, playermovement, r, btr, StunNo,
      WATarget: integer;
    WACheck, GGCheck, BaCCheck, bga, proskill, reroll, WARoll, UReroll: boolean;
begin
  if (GameStatus <> 'Pass') and (GameStatus <> 'HGaze')
    and (GameStatus <> 'Chill') and (GameStatus <> 'Ethereal')
    and (GameStatus <> 'Mace Tail') and (GameStatus <> 'Shadow')
    and (GameStatus <> 'ThrowTeamMate1') and (GameStatus <> 'ThrowTeamMate2') and
    (GameStatus <> 'Kick') and (GameStatus <> 'PitchPlayer1') and
    (GameStatus <> 'Dirty Kick') and (GameStatus <> 'Bear Hug') and
    (GameStatus <> 'Punt') and (GameStatus <> 'BulletThrow') and
    (GameStatus <> 'Dig1') and
    (GameStatus <> 'ThrowinMovement') and (GameStatus <> 'AccurateKick') then begin
    Bloodbowl.comment.Text := '';
    curbefore := 50 * curteam + curplayer;
    if frmSettings.cbDeStun.Checked then StunNo := 3 else StunNo := 4;
    {D6 Movement code}
    Bhead := 0;
    if (player[g,f].HasSkill('MA D6')) and
     (not (player[g,f].usedSkill('MA D6'))) and (g = curmove)
       then begin
         Bloodbowl.comment.text := 'Roll for D6 Movement for this player:';
         Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         player[g,f].UseSkill('MA D6');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         if CanWriteToLog then begin
           s := 'u' + Chr(g + 48) + Chr(f + 64) +
             Chr(player[g,f].ma + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1) + '|' +
             Chr(lastroll + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1);
           LogWrite(s);
           PlayActionPlayerStatChange(s, 1);
         end;
       end;
    {End D6 Movement Code}
    if (player[g,f].HasSkill('MA D6+1')) and
     (not (player[g,f].usedSkill('MA D6+1'))) and (g = curmove)
       then begin
         Bloodbowl.comment.text := 'Roll for D6+1 Movement for this player:';
         Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         player[g,f].UseSkill('MA D6+1');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         if CanWriteToLog then begin
           s := 'u' + Chr(g + 48) + Chr(f + 64) +
             Chr(player[g,f].ma + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1) + '|' +
             Chr((lastroll+1) + 48) +
             Chr(player[g,f].st + 48) +
             Chr(player[g,f].ag + 48) +
             Chr(player[g,f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
             player[g,f].GetSkillString(1);
           LogWrite(s);
           PlayActionPlayerStatChange(s, 1);
         end;
       end;
    {End D6+1 Movement Code}
    {TIKSTPK}
    if ((player[g,f].HasSkill('TIKSTPK')) and
      (not (player[g,f].usedSkill('TIKSTPK'))) and (g = curmove))
      then begin
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll <= 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('TIKSTPK roll has failed!'
               , 'TIKSTPK roll Failure',
               'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('TIKSTPK roll failed!'
               , 'TIKSTPK Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'TIKSTPK reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
       if (lastroll <= 1) then begin
          if CanWriteToLog then begin
            s := 'U-' + Chr(g + 48) + Chr(f + 64);
            LogWrite(s);
            PlayActionToggleTackleZone(s, 1);
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
          curturn := 0;
          for f2 := 1 to 8 do begin
            if turn[g,f2].color = clYellow then curturn := (HalfNo * 10) + f2;
          end;
          BANG := '';
          if curturn <= (player[g,f].TIKSTPK + 1) then begin
            BANG := player[g,f].name + ' EXPLODES!!!';
            Bloodbowl.comment.text := BANG;
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            player[g,f].SetStatus(8);
          end;
        end;
        player[g,f].UseSkill('TIKSTPK');
      end;
     {End of TIKSTPK}
    {Bone-head/Really Stupid}
    if (((player[g,f].HasSkill('Bonehead')) and
      (not (player[g,f].usedSkill('Bonehead'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Bone-head')) and
      (not (player[g,f].usedSkill('Bone-head'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Really Stupid')) and
      (not (player[g,f].usedSkill('Really Stupid'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Cold Blooded')) and
      (not (player[g,f].usedSkill('Cold Blooded'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Cold Natured')) and
      (not (player[g,f].usedSkill('Cold Natured'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Stone Cold Stupid')) and
      (not (player[g,f].usedSkill('Stone Cold Stupid'))) and (g = curmove)) or
      ((player[g,f].HasSkill('Pride')) and
      (not (player[g,f].usedSkill('Pride'))) and (g = curmove)))
      and (player[g,f].status >= 1) and (player[g,f].status <= StunNo)
      and (player[g,f].UsedMA <> 15) 
      then begin
        if (player[g,f].HasSkill('Bonehead')) then begin
          player[g,f].UseSkill('Bonehead');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Bone-head')) then begin
          player[g,f].UseSkill('Bone-head');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Really Stupid')) then begin
          player[g,f].UseSkill('Really Stupid');
          Bhead := 3;
        end else
        if (player[g,f].HasSkill('Pride')) then begin
          player[g,f].UseSkill('Pride');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Cold Natured')) then begin
          player[g,f].UseSkill('Cold Natured');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Cold Blooded')) then begin
          player[g,f].UseSkill('Cold Blooded');
          Bhead := 1;
        end else
        if (player[g,f].HasSkill('Stone Cold Stupid')) then begin
          player[g,f].UseSkill('Stone Cold Stupid');
          Bhead := 3;
        end;
        if (player[g,f].HasSkill('Really Stupid')) or
          (player[g,f].HasSkill('Stone Cold Stupid')) then begin
          RSHelp := CountNoBhead(g, f);
          if RSHelp > 0 then Bhead := 1;
        end;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= Bhead) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll <= Bhead then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Bone-head/Stupid roll has failed!'
               , 'Bone-head/Stupid roll Failure',
               'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Bone-head/Stupid roll failed!'
               , 'Bone-head/Stupid Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Bone-head/Stupid reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
        if (lastroll > Bhead) and (player[g, f].tz > 0) then begin
          if CanWriteToLog then begin
            s := 'U+' + Chr(g + 48) + Chr(f + 64);
            LogWrite(s);
            PlayActionToggleTackleZone(s, 1);
          end;
        end else if (lastroll <= Bhead) and (player[g, f].tz = 0) then begin
          if CanWriteToLog then begin
            s := 'U-' + Chr(g + 48) + Chr(f + 64);
            LogWrite(s);
            PlayActionToggleTackleZone(s, 1);
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
        end else if (lastroll <= Bhead) then begin
          if CanWriteToLog then begin
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
        end;
      end;
    {End of Bone-head/Really Stupid}
    {Greater Glory Check}
    GGCheck := false;
    if (not(player[g,f].HasSkill('Greater Glory'))) and (g = curmove) then begin
      GGCheck := false;
      for f0 := 1 to team[g].numplayers do begin
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Greater Glory')) and
          (player[g,f0].font.size = 12)
          then GGCheck := true;
      end;
      if GGCheck then
        Bloodbowl.Loglabel.caption :=
          'YOU HAVE FORGOTTEN TO MOVE A GREATER GLORY PLAYER BEFORE THIS ' +
          'PLAYER!';
    end;
    if (Bloodbowl.Loglabel.caption =
      'YOU HAVE FORGOTTEN TO MOVE A GREATER GLORY PLAYER BEFORE THIS PLAYER!') and
      not(GGCheck) then Bloodbowl.Loglabel.caption := '';
    {End of Greater Glory Check}
    {Wild Animal - Old Check}
    WACheck := false;
    if (not(player[g,f].HasSkill('Wild Animal')))
      and ((not(player[g,f].HasSkill('Maniac')))
      and (not(player[g,f].HasSkill('Easily Confused'))))
      and (g = curmove) then begin
      WACheck := false;
      for f0 := 1 to team[g].numplayers do begin
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Wild Animal')) and
          (player[g,f0].font.size = 12) and (false)      // Wild animal
          then WACheck := true;
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Maniac')) and
          (player[g,f0].font.size = 12)
          then WACheck := true;
      end;
      if WACheck then
        Bloodbowl.Loglabel.caption :=
          'YOU HAVE FORGOTTEN TO MOVE A WILD ANIMAL or MANIAC PLAYER BEFORE THIS ' +
          'PLAYER!';
    end;
    if (Bloodbowl.Loglabel.caption =
      'YOU HAVE FORGOTTEN TO MOVE A WILD ANIMAL PLAYER or MANIAC BEFORE THIS PLAYER!') and
      not(WACheck) then Bloodbowl.Loglabel.caption := '';
    {End of Wild Animal - Old Check}
    {Wild Animal - New Check}
    if (player[g,f].HasSkill('Wild Animal')) and
      (not (player[g,f].usedSkill('Wild Animal'))) and (g = curmove)
      and (player[g,f].status >= 1) and (player[g,f].status <= StunNo) and
      (true)        // Wild animal
      and (player[g,f].UsedMA <> 15)
      then begin
        WAAnswer :=
          FlexMessageBox('Are you Blocking or Blitzing with this Wild Animal?'
          , 'Wild Animal Question',
          'Yes,No');
        if WAAnswer='Yes' then begin
          WATarget := 2;
          Bloodbowl.comment.text := 'Wild Animal is blocking or blitzing';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end else WATarget := 4;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll < WATarget) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll < WATarget then begin
          ReRollAnswer := 'Fail Roll';
          if reroll and proskill then begin
            ReRollAnswer := FlexMessageBox('Wild Animal roll has failed!'
             , 'Wild Animal roll Failure',
             'Use Pro,Team Reroll,Fail Roll');
          end else if proskill then ReRollAnswer := 'Use Pro' else
          if reroll then begin
            ReRollAnswer := FlexMessageBox('Wild Animal roll failed!'
             , 'Wild Animal Failure', 'Fail Roll,Team Reroll');
          end;
        end;
        if ReRollAnswer='Team Reroll' then begin
          UReroll := UseTeamReroll;
          if UReroll then begin
            Bloodbowl.comment.text := 'Wild Animal reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer='Use Pro' then begin
          player[g,f].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then TeamRerollPro(g,f);
          if (lastroll <= 3) then lastroll := 1;
          if (lastroll >= 4) then begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if (lastroll < WATarget) then begin
          player[g,f].UseSkill('Wild Animal');
          if CanWriteToLog then begin
            s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
            LogWrite(s);
            PlayActionEndOfMove(s, 1);
          end;
        end else begin
          player[g,f].UseSkill('Wild Animal');
        end;
    end;
    {End of Wild Animal - New Check}
    {Ball and Chain Check}
    BaCCheck := false;
    if (not(player[g,f].HasSkill('Ball and Chain'))) and (g = curmove) then begin
      BaCCheck := false;
      for f0 := 1 to team[g].numplayers do begin
        if (player[g,f0].status >= 1) and (player[g,f0].status <= StunNo) and
          (player[g,f0].HasSkill('Ball and Chain')) and
          (player[g,f0].font.size = 12)
          then BaCCheck := true;
      end;
      if BaCCheck then
        Bloodbowl.Loglabel.caption :=
          'YOU HAVE FORGOTTEN TO MOVE A BALL AND CHAIN PLAYER BEFORE THIS ' +
          'PLAYER!';
    end;
    if (Bloodbowl.Loglabel.caption =
      'YOU HAVE FORGOTTEN TO MOVE A BALL AND CHAIN PLAYER BEFORE THIS PLAYER!') and
      not(BaCCheck) then Bloodbowl.Loglabel.caption := '';
    {End of Ball and Chain Check}
    {Uncontrollable}
    if ((player[g,f].HasSkill('Uncontrollable')) and
      (not (player[g,f].usedSkill('Uncontrollable'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= 3) and
      (player[g,f].UsedMA <> 15)
      then begin
         player[g,f].UseSkill('Uncontrollable');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         lostcontrol := '';
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
             and (true)); // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
             (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll <= 1 then begin
            ReRollAnswer := 'Fail Roll';
            if reroll and proskill then begin
              ReRollAnswer := FlexMessageBox('Uncontrollable roll has failed!'
                , 'Uncontrollable Failure',
                'Use Pro,Team Reroll,Fail Roll');
            end else if proskill then ReRollAnswer := 'Use Pro' else
            if reroll then begin
              ReRollAnswer := FlexMessageBox('Uncontrollable roll failed!'
                , 'Uncontrollable Failure', 'Fail Roll,Team Reroll');
            end;
          end;
          if ReRollAnswer='Team Reroll' then begin
            UReroll := UseTeamReroll;
            if UReroll then begin
              Bloodbowl.comment.text := 'Uncontrollable reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
          end;
          if ReRollAnswer='Use Pro' then begin
             player[g,f].UseSkill('Pro');
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
             if lastroll <= 3 then TeamRerollPro(g,f);
             if (lastroll <= 3) then lastroll := 1;
             if (lastroll >= 4) then begin
               Bloodbowl.comment.text := 'Pro reroll';
               Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
               Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
             end;
          end;
         if lastroll = 1 then begin
           lastroll := Rnd(8,6) + 1;
           lostcontrol := 'Uncontrollable roll failed -- Random Movement: ';
           if lastroll = 1 then lostcontrol := lostcontrol + 'Up Left ' else
           if lastroll = 2 then lostcontrol := lostcontrol + 'Up ' else
           if lastroll = 3 then lostcontrol := lostcontrol + 'Up Right ' else
           if lastroll = 4 then lostcontrol := lostcontrol + 'Left ' else
           if lastroll = 5 then lostcontrol := lostcontrol + 'Right ' else
           if lastroll = 6 then lostcontrol := lostcontrol + 'Down Left ' else
           if lastroll = 7 then lostcontrol := lostcontrol + 'Down ' else
           if lastroll = 8 then lostcontrol := lostcontrol + 'Down Right ';
           lastroll := Rnd(6,6) + 1;
           lostcontrol := lostcontrol + InttoStr(lastroll) + ' squares';
           Bloodbowl.comment.text := lostcontrol;
           Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         end;
      end;
    {End of Uncontrollable}
    {Blood Lust}
    if ((player[g,f].HasSkill('Blood Lust')) and
      (not (player[g,f].usedSkill('Blood Lust'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= 3)
      then begin
         player[g,f].UseSkill('Blood Lust');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll = 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Blood Lust roll failed!'
               , 'Blood Lust Failure', 'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Blood Lust roll failed!'
               , 'Blood Lust Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Blood Lust reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
         if lastroll = 1 then begin
            Bloodbowl.comment.text := player[g,f].name + ' fails his Blood Lust' +
              ' roll and must feed off off a Thrall from your team or leave' +
              ' the pitch!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
      end;
    {End of Blood Lust}
    {Bloodthirst}
    if ((player[g,f].HasSkill('Bloodthirst')) and
      (not (player[g,f].usedSkill('Bloodthirst'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= 3)
      then begin
         player[g,f].UseSkill('Bloodthirst');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll = 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Bloodthirst roll failed!'
               , 'Bloodthirst Failure', 'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Bloodthirst roll failed!'
               , 'Bloodthirst Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Bloodthirst reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
         if lastroll = 1 then begin
            Bloodbowl.comment.text := player[g,f].name + ' fails his Bloodthirst' +
              ' roll and must feed off off another player from your team or leave' +
              ' the pitch!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
      end;
    {End of Bloodthirst}
    {On Pitch Take Root}
    if ((player[g,f].HasSkill('Take Root')) and
      (not (player[g,f].usedSkill('Take Root'))) and (g = curmove))
      and (player[g,f].status >= 1) and (player[g,f].status <= StunNo) and
      (frmSettings.cbOPTakeRoot.checked) and (player[g,f].ma <> 0) and
      (player[g,f].font.size = 12)
      then begin
         player[g,f].UseSkill('Take Root');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
         proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 1) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
         reroll := CanUseTeamReroll(bga);
         if lastroll = 1 then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Take Root roll failed!'
               , 'Take Root Failure', 'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Take Root roll failed!'
               , 'Take Root Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Take Root reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
         if lastroll = 1 then begin
           if CanWriteToLog then begin
             Bloodbowl.comment.text := player[g,f].name + ' fails his Take Root ' +
               'roll and has MA zero for the rest of this drive! (he cannot GFI ' +
               'or follow-up on blocks either!';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
               Chr(player[g, f].ma + 48) +
               Chr(player[g, f].st + 48) +
               Chr(player[g, f].ag + 48) +
               Chr(player[g, f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
               player[g, f].GetSkillString(1) + '|' +
               Chr(0 + 48) +
               Chr(player[g, f].st + 48) +
               Chr(player[g, f].ag + 48) +
               Chr(player[g, f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
               player[g, f].GetSkillString(1);
             LogWrite(s2);
             PlayActionPlayerStatChange(s2, 1);
           end;
         end;
      end;
    {Start of Ball and Chain TZ check}
    if ((player[g,f].HasSkill('Ball and Chain')) and (player[g,f].status >= 0)
      and (player[g,f].status <= 4) and (player[g, f].tz = 0))
      then begin
        if CanWriteToLog then begin
          s := 'U-' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s);
          PlayActionToggleTackleZone(s, 1);
        end;
      end;
    {End of Ball and Chain TZ check}
    {Rooted, Swamped, Netted}
    if (((player[g,f].HasSkill('Rooted')) and (not (player[g,f].usedSkill('Rooted'))))
     or ((player[g,f].HasSkill('Swamped')) and (not (player[g,f].usedSkill('Swamped'))))
     or ((player[g,f].HasSkill('Netted')) and (not (player[g,f].usedSkill('Netted')))))
      and (g = curmove) and (player[g,f].status >= 1) and (player[g,f].status <= 3)
      then begin
        r := 7 - (player[g,f].st);
        if player[g,f].HasSkill('Swamped') then begin
          player[g,f].UseSkill('Swamped');
        end else if player[g,f].HasSkill('Rooted') then begin
          player[g,f].UseSkill('Rooted');
        end else begin
          player[g,f].UseSkill('Netted');
        end;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if (player[g,f].HasSkill('Rooted')) and (lastroll<>1) and (lastroll<>6)
          then begin
            lastroll := lastroll - 1;
            Bloodbowl.comment.text := '-1 modifier to roll for Call Roots spell';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;

        bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
            and (true)); // bigguy
        proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll < r) and
            (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
        reroll := CanUseTeamReroll(bga);
        if lastroll < r then begin
           ReRollAnswer := 'Fail Roll';
           if reroll and proskill then begin
             ReRollAnswer := FlexMessageBox('Strength roll to move has failed!'
               , 'Strength roll Failure',
               'Use Pro,Team Reroll,Fail Roll');
           end else if proskill then ReRollAnswer := 'Use Pro' else
           if reroll then begin
             ReRollAnswer := FlexMessageBox('Strength roll to move has failed!'
               , 'Strength roll Failure', 'Fail Roll,Team Reroll');
           end;
         end;
         if ReRollAnswer='Team Reroll' then begin
           UReroll := UseTeamReroll;
           if UReroll then begin
             Bloodbowl.comment.text := 'Strength roll reroll';
             Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
             if (player[g,f].HasSkill('Rooted')) and (lastroll<>1) and (lastroll<>6)
               then begin
               lastroll := lastroll - 1;
               Bloodbowl.comment.text := '-1 modifier to roll for Call Roots spell';
               Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
             end;
           end;
         end;
         if ReRollAnswer='Use Pro' then begin
            player[g,f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(g,f);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              if (player[g,f].HasSkill('Rooted')) and (lastroll<>1) and (lastroll<>6)
                 then begin
                 lastroll := lastroll - 1;
                 Bloodbowl.comment.text := '-1 modifier to roll for Call Roots spell';
                 Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              end;
            end;
         end;
         if lastroll>=r then begin
          if player[g,f].HasSkill('Swamped') then begin
              Bloodbowl.comment.text := player[g,f].name + ' breaks free of the ' +
                'of the Swamped spell, Stats Change to remove Swamped skill';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
              Bloodbowl.comment.text := player[g,f].name + ' roll successful, player ' +
                'moves normally this turn';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
        end else begin
          if player[g,f].HasSkill('Netted') then begin
            Bloodbowl.comment.text := player[g,f].name + ' roll FAILED!, player ' +
             'movement halved this turn and player CANNOT GFI';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.text := player[g,f].name + ' roll FAILED!, player ' +
             'movement zero for this turn';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
          if player[g,f].HasSkill('Netted') then begin
            playermovement := (player[g,f].ma div 2);
            if (player[g,f].ma mod 2)<>0 then playermovement := playermovement + 1;
          end else playermovement := player[g,f].ma + 3;
          s := 'M' + Chr(g + 48) + Chr(f + 65) +
             Chr(player[g,f].p + 65) +
             Chr(player[g,f].q + 65) +
             Chr(player[g,f].p + 65) + Chr(player[g,f].q + 65) +
             Chr(player[g,f].UsedMA + 65) + Chr(playermovement + 65);
          LogWrite(s);
          PlayActionPlayerMove(s, 1);
        end;
    end;
    {End of Rooted, Swamped, and Netted}
  end;
end;

end.
