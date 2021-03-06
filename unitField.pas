unit unitField;

interface

uses Windows, Messages, SysUtils, Classes, Controls, Forms, Dialogs, StdCtrls;

type TFieldLabel = class(TLabel)
  private
    procedure DoThrowInMovementMouseUp(f: Integer; g: Integer);

  public
    p, q, cl: integer;

    constructor Create(form: TForm; f, g: integer);

    procedure FieldMouseUp(Sender: TObject;
               Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FieldDragOver(Sender, Source: TObject; X,
               Y: Integer; State: TDragState; var Accept: Boolean);
    procedure FieldDragDrop(Sender, Source: TObject; X, Y: Integer);
{    procedure FieldMouseMove(Sender: TObject; Shift: TShiftState;
                             X, Y: Integer);}
  end;

var field: array [0..14, 0..25] of TFieldLabel;

procedure PlayActionClearNumOnField(s: string; dir: integer);
procedure PlayActionNumOnField(s: string; dir: integer);
procedure PlayActionHideBall(s: string; dir: integer);
procedure PlayActionSideStep(s: string; dir: integer);

procedure PutNumOnField(f, g, v, c: integer);
procedure PutMultipleNumOnField(s: string);
procedure RPBCall(s: string);
procedure BPBCall(s: string);
{function AnyNumOnField: boolean;}
function GetNextNumOnField: integer;
function NumOnFieldColor(v: integer): integer;
procedure RemoveNumOnField(v: integer);
procedure RemoveMultipleNumOnField(s: string);
function ClearNumOnFieldUpTo(upto: integer): string;
function ClearAllNumOnField: string;
function SubtractAllNumOnField: string;

implementation

uses Graphics, ExtCtrls, bbalg, bbunit, unitPlayer, unitLog, unitBall,
     unitPass, unitThrowTeamMate, unitArmourRoll, unitTeam,
     unitMessage, unitThrowStuff, unitPickUp, unitSettings;

var NumOnField: array [0..15,0..1] of integer;

constructor TFieldLabel.Create(form: TForm; f, g: integer);
begin
  inherited Create(form);

  {label settings}
  autosize := false;
  left := (Bloodbowl.width - 8) div 2 + (g - 13) * 20 + 1;
  top := Bloodbowl.TurnPanel.Height + Bloodbowl.toolbar1.Height + 4 + f * 20;
  height := 19;
  width := 19;
  caption := '';
  alignment := taCenter;
  color := clGreen;
  font.color := clWhite;
  font.size := 12;
  parent := Bloodbowl;
  hint := chr(ord('A') + g) + IntToStr(f+1);
  ShowHint := true;
  popupmenu := Bloodbowl.fieldPopup;
  OnMouseUp := FieldMouseUp;
  OnDragOver := FieldDragOver;
  OnDragDrop := FieldDragDrop;
{  OnMouseMove := FieldMouseMove;}

  {other settings}
  p := f;
  q := g;
end;

function GetNextNumOnField: integer;
var v: integer;
begin
  if curteam >= 0 then begin
    if (allPlayers[curteam, curplayer].status > 0)
    and (allPlayers[curteam, curplayer].status < 4) then begin
      if (allPlayers[curteam, curplayer].status = 3)
      and not(allPlayers[curteam, curplayer].hasSkill('Jump Up')) then v := 3
      else v := allPlayers[curteam, curplayer].UsedMA;
      while (v < 15) and (NumOnField[v,0] > -1) do v := v + 1;
      if v < 15 then GetNextNumOnField := v
                else GetNextNumOnField := 15;
    end else GetNextNumOnField := 15;
  end else GetNextNumOnField := 15;
end;

procedure PlayActionClearNumOnField(s: string; dir: integer);
begin
  if dir = 1 then begin
    ClearAllNumOnField;
  end else begin
    PutMultipleNumOnField(Copy(s, 2, Length(s) - 1));
  end;
end;

procedure PlayActionNumOnField(s: string; dir: integer);
{PlayActionNumOnField changes a position on the field on position (s[2],s[3])
 from (s[4]) to (s[5])}
var f, g, v, c: integer;
begin
  f := Ord(s[2]) - 65;
  g := Ord(s[3]) - 65;
  if dir = 1 then begin
    if s[5] = '@' then begin
      {remove number from field}
      v := Ord(s[4]) - 65;
      RemoveNumOnField(v);
    end else begin
      v := Ord(s[5]) - 65;
      c := Ord(s[6]) - 65;
      PutNumOnField(f, g, v, c);
    end;
  end else begin
    if s[4] = '@' then begin
      v := Ord(s[5]) - 65;
      RemoveNumOnField(v);
    end else begin
      v := Ord(s[4]) - 65;
      c := Ord(s[6]) - 65;
      PutNumOnField(f, g, v, c);
    end;
  end;
end;

procedure TFieldLabel.FieldMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var h, pb, f, g, r, fieldcheck, leap, r2,
    dist1, dist2, finaldist, KickP, KickQ,
    v, w, ploc, qloc: integer;
    SPP4th, b, bga, proskill, reroll, Ballscatter, UReroll: boolean;
    s, LeapType, ReRollAnswer, StatTemp: string;
    tz, tz0: TackleZones;
begin
  if (CanWriteToLog) and not(FirstLoad) then begin

    if Button = mbLeft then begin
      if GameStatus = '' then begin
        // movement planning numbers
        if caption = '' then begin
          h := GetNextNumOnField;
          if FollowUp <> '' then begin
            if (FollowUp = Chr(curteam + 48) + Chr(curplayer + 65) +
                Chr(p + 65) + Chr(q + 65))
            and (h = allPlayers[curteam,curplayer].UsedMA) then h := h - 1;
          end;
          if h = 15 then begin
            if NumOnField[15,0] >= 0 then begin
              s := '.' + Chr(NumOnField[15,0] + 65) +
                   Chr(NumOnField[15,1] + 65) + Chr(80) + Chr(64) + 'A';
              LogWrite(s);
              PlayActionNumOnField(s, 1);
              Continuing := true;
            end;
          end;
          s := '.' + Chr(p + 65) + Chr(q + 65) + Chr(64) + Chr(h + 65);
          tz.num := 0;
          if h = 0 then tz := CountTZ(curteam,curplayer) else begin
            fieldcheck :=0;
            for f := 0 to 14 do
              begin
                for g := 0 to 25 do
                  begin
                    if FVal(field[f,g].caption) = (h) then begin
                      tz := CountTZEmpty(curteam,f,g);
                      fieldcheck := 1;
                    end;
                  end;
              end;
            if (fieldcheck = 0) and (curteam >= 0) and (curteam <= 1)
               then tz := CountTZ(curteam,curplayer);
            end;
          if (h < 15) and (h + 1 > allPlayers[curteam, curplayer].ma) then begin
             if (allPlayers[curteam,curplayer].hasSkill('Pogo Stick')) then begin
              if (h >= allPlayers[curteam, curplayer].ma + 4) then begin
                 s := s + 'C';
              end else begin
                if tz.num <> 0 then s := s + 'E' else s := s + 'B';
              end;
            end else begin
              if (h > allPlayers[curteam, curplayer].ma + 2)
              or ((h = allPlayers[curteam, curplayer].ma + 2) and
                  not(allPlayers[curteam, curplayer].hasSkill('Sprint')))
              or ((allPlayers[curteam, curplayer].HasSkill('Take Root')) and
                (curteam = activeTeam) and (allPlayers[curteam,curplayer].status >= 1)
                and (allPlayers[curteam,curplayer].status <= 4) and
                (allPlayers[curteam,curplayer].ma = 0))
              or (allPlayers[curteam, curplayer].hasSkill('Ball and Chain'))
              then
                begin
                   s := s + 'C';
                end
                else
                begin
                  if tz.num <> 0 then s := s + 'E' else s := s + 'B';
                end;
            end;
          end else begin
            if tz.num <> 0 then s := s + 'D' else s := s + 'A';
          end;
          LogWrite(s);
          PlayActionNumOnField(s, 1);
          Continuing := false;
        end else begin
          if caption = 'X' then h := 15 else h := FVal(caption) - 1;
          s := '.' + Chr(p + 65) + Chr(q + 65) + Chr(h + 65) + Chr(64) +
               Chr(field[p,q].cl + 65);
          LogWrite(s);
          PlayActionNumOnField(s, 1);
        end;

      end else if GameStatus = 'Field player' then begin
        PlacePlayer(curplayer, curteam, p, q);

      end else if GameStatus = 'Move player' then begin
        PlacePlayer(curplayer, curteam, p, q);

      end else if GameStatus = 'Pass' then begin
        ActionTeam := curteam;
        ActionPlayer := curplayer;
        pb := CountPB(curteam, curplayer, p, q, true);
        if pb > 0 then
          Application.Messagebox('Opponent might be able to Pass Block!',
          'Bloodbowl Pass Block Warning', MB_OK);
        DetermineInterceptors(curteam, curplayer, p, q);
        if allPlayers[ActionTeam,ActionPlayer].status = 2 then
           ShowPassPlayerToField(ActionTeam, ActionPlayer, p, q);
        Bloodbowl.Endofmove1Click(Bloodbowl);
        ActionTeam := 0;
        ActionPlayer := 0;

      end else if (GameStatus = 'Bomb') or (GameStatus = 'BigBomb') or
        (GameStatus = 'StinkBomb') then begin
        StatTemp := GameStatus;
        Bloodbowl.Endofmove1Click(Bloodbowl);
        if StatTemp = 'Bomb' then
          ShowStuffPlayerToField(ActionTeam, ActionPlayer, p, q, 1)
        else if StatTemp = 'StinkBomb' then
          ShowStuffPlayerToField(ActionTeam, ActionPlayer, p, q, 2)
        else if StatTemp = 'BigBomb' then
          ShowStuffPlayerToField(ActionTeam, ActionPlayer, p, q, 3);
        GameStatus := '';
        ActionTeam := 0;
        ActionPlayer := 0;

      end else if GameStatus = 'ThrowTeamMate2' then begin
        Bloodbowl.Endofmove1Click(Bloodbowl);
        ShowThrowPlayer(ActionTeam, ActionPlayer, ThrownTeam, ThrownPlayer, p, q);

      end else if GameStatus='ThrowinMovement' then begin
        DoThrowInMovementMouseUp(f, g);

      end else if GameStatus = 'Side Step' then begin
        if (ABS((allPlayers[ActionTeam,ActionPlayer].p)-p)<=1) and
          (ABS((allPlayers[ActionTeam,ActionPlayer].q)-q)<=1) and
          ((ABS((allPlayers[ActionTeam,ActionPlayer].p)-p)<>0) or
          (ABS((allPlayers[ActionTeam,ActionPlayer].q)-q)<>0))
          then begin
          s := 'QF' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 64) + Chr(1+48)
            + Chr(p+64) + Chr(q+64)
            + Chr(allPlayers[ActionTeam,ActionPlayer].SideStep[1]+48)
            + Chr(allPlayers[ActionTeam,ActionPlayer].SideStep[2]+64)
            + Chr(allPlayers[ActionTeam,ActionPlayer].SideStep[3]+64);
          LogWrite(s);
          PlayActionSideStep(s, 1);
          Bloodbowl.Loglabel.caption := 'Square accepted for next turn Side Step';
        end else begin
          Application.Messagebox('You must Side Step to an adjacent square!',
             'Bloodbowl Side Step Warning', MB_OK);
          Bloodbowl.Loglabel.caption := '';
        end;
        GameStatus := '';
        ActionTeam := 0;
        ActionPlayer := 0;

      end else if GameStatus = 'Dig1' then begin
        if (ABS((allPlayers[ActionTeam,ActionPlayer].p)-p)<=1) and
          (ABS((allPlayers[ActionTeam,ActionPlayer].q)-q)<=1) and
          ((ABS((allPlayers[ActionTeam,ActionPlayer].p)-p)<>0) or
          (ABS((allPlayers[ActionTeam,ActionPlayer].q)-q)<>0))
          then begin
          DigP := p;
          DigQ := q;
          DigStrength := 0;
          GameStatus := 'Dig2';
          Bloodbowl.Loglabel.caption :=
             'CLICK ON THE EMPTY SQUARE TO DIG TO';
        end else
          Application.Messagebox('You must dig under an adjacent square!',
             'Bloodbowl Dig Warning', MB_OK);

      end else if (GameStatus = 'Leap') then begin
        leap := 0;
        r := 0;
        begin
          r := 7 - (allPlayers[curteam,curplayer].ag);
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          r2 := lastroll;

          if lastroll < r then begin
            bga := (((allPlayers[ActionTeam,ActionPlayer].BigGuy) or
              (allPlayers[ActionTeam,ActionPlayer].Ally))
              and (true));  // bigguy
            proskill := ((allPlayers[ActionTeam,ActionPlayer].HasSkill('Pro')))
              and (lastroll <= 1) and
              (not (allPlayers[ActionTeam,ActionPlayer].usedSkill('Pro')))
              and (ActionTeam = activeTeam);
            reroll := CanUseTeamReroll(bga);
            ReRollAnswer := 'Fail Roll';
            if reroll and proskill then begin
              ReRollAnswer := FlexMessageBox(LeapType + 'roll has failed!'
                , LeapType + 'Failure',
                'Use Pro,Team Reroll,Fail Roll');
            end else if proskill then begin
              ReRollAnswer := FlexMessageBox(LeapType + 'roll has failed!'
                , LeapType + 'Failure',
                'Use Pro,Fail Roll');
            end else if reroll then begin
              ReRollAnswer := FlexMessageBox(LeapType + 'roll failed!'
                , LeapType + 'Failure', 'Fail Roll,Team Reroll');
            end;
            if ReRollAnswer='Team Reroll' then begin
              UReroll := UseTeamReroll;
              if UReroll then begin
                Bloodbowl.comment.text := LeapType + 'reroll';
                Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);

              end;
            end;
            if ReRollAnswer='Use Pro' then begin
              allPlayers[ActionTeam,ActionPlayer].UseSkill('Pro');
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
              if (lastroll <= 3) then lastroll := r2;
              if (lastroll >= 4) then begin
                Bloodbowl.comment.text := 'Pro reroll';
                Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);

              end;
            end;
          end;

          if lastroll>=r then begin
            if (GameStatus = 'Leap') then
               allPlayers[curteam,curplayer].UseSkill('Leap');

            Bloodbowl.comment.text := 'Leap successful';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Ballscatter := false;
            if (p=ball.p) and (q=ball.q) then BallScatter := true;
            PlacePlayer(curplayer, curteam, p, q);
            if BallScatter then ShowPickUpWindow(curteam, curplayer);
          end else
          begin
            Bloodbowl.comment.text := 'Leap failed';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            if  (GameStatus = 'Leap') then
              allPlayers[ActionTeam,ActionPlayer].UseSkill('Leap');

            PlacePlayer(ActionPlayer, ActionTeam, p, q);
            Ballscatter := false;
            if (p=ball.p) and (q=ball.q) then BallScatter := true;
            v := Actionteam;
            w := Actionplayer;
            if BallScatter then begin
              ploc := allPlayers[v,w].p;
              qloc := allPlayers[v,w].q;
            end;
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
        end;
      end;
    end;
  end;
  FirstLoad := false;
end;

procedure TFieldLabel.FieldDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
// var l: TLabel;
begin
  // l := (Sender as TLabel);
end;

procedure TFieldLabel.FieldDragDrop(Sender, Source: TObject; X, Y: Integer);
{var p, q: integer;}
begin
{  p := 0;
  q := 0;
  while (Sender as TLabel). <> field[q,p] do begin
    q := q + 1;
    if q > 14 then begin
      q := 0;
      p := p + 1;
    end;
  end;}
  if (Source is TImage) then begin
    PlaceBall((Sender as TFieldLabel).p, (Sender as TFieldLabel).q);
  end;
end;

procedure TFieldLabel.DoThrowInMovementMouseUp(f: Integer; g: Integer);
var
  pplace: Integer;
  qplace: Integer;
  TestP: Integer;
  TestQ: Integer;
  NewP: Integer;
  NewQ: Integer;
  dk1: Integer;
  NewP2: Integer;
  NewQ2: Integer;
  NewP3: Integer;
  NewQ3: Integer;
  dk2: Integer;
  dk3: Integer;
  FinalP: Integer;
  FinalQ: Integer;
  FinalDK: Integer;
  Local_g: Integer;
  Local_f: Integer;
  Local_g1: Integer;
  Local_f1: Integer;
  Local_g2: Integer;
  Local_f2: Integer;
begin
  pplace := p - allPlayers[ActionTeam, ActionPlayer].p;
  qplace := q - allPlayers[ActionTeam, ActionPlayer].q;
  if ((pplace = 0) or (qplace = 0)) then
  begin
    TestP := allPlayers[ActionTeam, ActionPlayer].p;
    TestQ := allPlayers[ActionTeam, ActionPlayer].q;
    NewP := TestP + pplace;
    NewQ := TestQ + qplace;
    dk1 := 1;
    if (NewP < 0) or (NewP > 14) or (NewQ < 0) or (NewQ > 25) then
      dk1 := 3;
    for Local_g := 0 to 1 do
    begin
      for Local_f := 1 to team[Local_g].numplayers do
      begin
        if (allPlayers[Local_g, Local_f].p = NewP) and (allPlayers[Local_g, Local_f].q = NewQ) then
        begin
          dk1 := 2;
        end;
      end;
    end;
    if (qplace = 0) and (pplace = -1) then
    begin
      NewP2 := TestP - 1;
      NewQ2 := TestQ - 1;
      NewP3 := TestP - 1;
      NewQ3 := TestQ + 1;
    end
    else if (qplace = 0) and (pplace = 1) then
    begin
      NewP2 := TestP + 1;
      NewQ2 := TestQ + 1;
      NewP3 := TestP + 1;
      NewQ3 := TestQ - 1;
    end
    else if (qplace = 1) and (pplace = 0) then
    begin
      NewP2 := TestP - 1;
      NewQ2 := TestQ + 1;
      NewP3 := TestP + 1;
      NewQ3 := TestQ + 1;
    end
    else if (qplace = -1) and (pplace = 0) then
    begin
      NewP2 := TestP + 1;
      NewQ2 := TestQ - 1;
      NewP3 := TestP - 1;
      NewQ3 := TestQ - 1;
    end
    else if (qplace = 1) and (pplace = -1) then
    begin
      NewP2 := TestP - 1;
      NewQ2 := TestQ + 0;
      NewP3 := TestP + 0;
      NewQ3 := TestQ + 1;
    end
    else if (qplace = 1) and (pplace = 1) then
    begin
      NewP2 := TestP + 0;
      NewQ2 := TestQ + 1;
      NewP3 := TestP + 1;
      NewQ3 := TestQ + 0;
    end
    else if (qplace = -1) and (pplace = 1) then
    begin
      NewP2 := TestP + 1;
      NewQ2 := TestQ + 0;
      NewP3 := TestP + 0;
      NewQ3 := TestQ - 1;
    end
    else if (qplace = -1) and (pplace = -1) then
    begin
      NewP2 := TestP + 0;
      NewQ2 := TestQ - 1;
      NewP3 := TestP - 1;
      NewQ3 := TestQ + 0;
    end;
    dk2 := 1;
    dk3 := 1;
    if (NewP2 < 0) or (NewP2 > 14) or (NewQ2 < 0) or (NewQ2 > 25) then
      dk2 := 3;
    if (NewP3 < 0) or (NewP3 > 14) or (NewQ3 < 0) or (NewQ3 > 25) then
      dk3 := 3;
    for Local_g1 := 0 to 1 do
    begin
      for Local_f1 := 1 to team[Local_g1].numplayers do
      begin
        if (allPlayers[Local_g1, Local_f1].p = NewP2) and (allPlayers[Local_g1, Local_f1].q = NewQ2) then
        begin
          dk2 := 2;
        end;
        if (allPlayers[Local_g1, Local_f1].p = NewP3) and (allPlayers[Local_g1, Local_f1].q = NewQ3) then
        begin
          dk3 := 2;
        end;
      end;
    end;
    Bloodbowl.comment.text := 'Throw-in Movement roll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    if lastroll < 3 then
    begin
      FinalP := NewP2;
      FinalQ := NewQ2;
      FinalDK := dk2;
    end
    else if (lastroll > 2) and (lastroll < 5) then
    begin
      FinalP := NewP;
      FinalQ := NewQ;
      FinalDK := dk1;
    end
    else
    begin
      FinalP := NewP3;
      FinalQ := NewQ3;
      FinalDK := dk3;
    end;
    if FinalDK = 1 then
      PlacePlayer(ActionPlayer, ActionTeam, FinalP, FinalQ)
    else if FinalDK = 3 then
    begin
      Bloodbowl.comment.text := 'Player runs out of bounds!  Roll for injury';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    end
    else
    begin
      for Local_g2 := 0 to 1 do
      begin
        for Local_f2 := 1 to team[Local_g2].numplayers do
        begin
          if (allPlayers[Local_g2, Local_f2].p = FinalP) and (allPlayers[Local_g2, Local_f2].q = FinalQ) then
          begin
            BloodBowl.comment.Text := 'You must throw a block at #' + InttoStr(allPlayers[Local_g2, Local_f2].cnumber) + '-' + allPlayers[Local_g2, Local_f2].name;
          end;
        end;
      end;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    end;
  end
  else
  begin
    Application.Messagebox('Throw-in Movement cannot be aimed ' + 'diagonally!', 'Bloodbowl Throw-In Movement Warning', MB_OK);
  end;
  GameStatus := '';
  ActionTeam := 0;
  ActionPlayer := 0;
end;

{procedure TFieldLabel.FieldMouseMove(Sender: TObject; Shift: TShiftState;
                                     X, Y: Integer);

begin
  if GameStatus = 'Plot move' then begin
  end;
end;}

procedure PutNumOnField(f, g, v, c: integer);
begin
  if v = 15 then field[f,g].caption := 'X' else
    field[f,g].caption := IntToStr(v+1);
  case c of
    0: field[f,g].font.color := clWhite;
    1: field[f,g].font.color := clYellow;
    2: field[f,g].font.color := clPurple;
    3: field[f,g].font.color := $00FFFF80;
    4: field[f,g].font.color := $000099FF;
  end;
  if (c=0) and (frmSettings.cbBlackIce.checked) then
    field[f,g].font.color := clBlack;
  if (c=2) and (frmSettings.cbBlackIce.checked) then
    field[f,g].font.color := clRed;
  field[f,g].cl := c;
  NumOnField[v,0] := f;
  NumOnField[v,1] := g;
  if ref then field[f,g].Refresh;
end;

procedure PutMultipleNumOnField(s: string);
var h: integer;
begin
  h := 1;
  while h < length(s) do begin
    PutNumOnField(Ord(s[h]) - 65, Ord(s[h+1]) - 65,
                  Ord(s[h+2]) - 65, Ord(s[h+3]) - 65);
    h := h + 4;
  end;
end;

function NumOnFieldColor(v: integer): integer;
begin
  NumOnFieldColor := field[NumOnField[v,0], NumOnField[v,1]].cl;
end;

procedure RemoveNumOnField(v: integer);
begin
  if NumOnField[v,0] >= 0 then begin
    field[NumOnField[v,0], NumOnField[v,1]].caption := '';
    if ref then field[NumOnField[v,0], NumOnField[v,1]].Refresh;
    NumOnField[v,0] := -1;
  end;
end;

procedure RemoveMultipleNumOnField(s: string);
var h: integer;
begin
  h := 1;
  while h < length(s) do begin
    RemoveNumOnField(Ord(s[h+2]) - 65);
    h := h + 4;
  end;
end;

function ClearNumOnFieldUpTo(upto: integer): string;
var s: string;
    f: integer;
begin
  s := '';
  for f := 0 to upto - 1 do if NumOnField[f,0] <> - 1 then begin
    s := s + Chr(NumOnField[f,0] + 65) + Chr(NumOnField[f,1] + 65) +
            Chr(f + 65) + Chr(field[NumOnField[f,0],NumOnField[f,1]].cl + 65);
    RemoveNumOnField(f);
  end;
  ClearNumOnFieldUpTo := s;
end;

function ClearAllNumOnField: string;
var f, g: integer;
begin
  ClearAllNumOnField := ClearNumOnFieldUpTo(16);
  {The following is a pure hack job by Tom to get
   rid of the ocassional number that sticks on the
   field}
  for f := 0 to 14 do
    begin
      for g := 0 to 25 do
        begin
          field[f,g].caption := '';
        end;
    end;
  {End of Hack Job}
end;

function SubtractAllNumOnField: string;
var s: string;
begin
  s := GetPreviousGameLog;
  while (s[1] = '.') and (s[5] <> '@') do begin
    s := LogSubtractLast;
    PlayActionNumOnField(s, -1);
    s := GetPreviousGameLog;
  end;
  SubtractAllNumOnField := ClearAllNumOnField;
end;

procedure PlayActionHideBall(s: string; dir: integer);
begin
  if ((dir = 1) and (s[4]<>'E')) or ((dir = -1) and (s[4]='E')) then begin
    HideBallp := Ord(s[2]) - 65;
    HideBallq := Ord(s[3]) - 65;
  end else begin
    HideBallp := -1;
    HideBallq := -1;
  end;
end;

procedure PlayActionSideStep(s: string; dir: integer);
var g, f, p, q, TurnOn: integer;
begin
  if dir = 1 then begin
    g := Ord(s[3]) - 48;
    f := Ord(s[4]) - 64;
    TurnOn := Ord(s[5]) - 48;
    p := Ord(s[6]) - 64;
    q := Ord(s[7]) - 64;
    allPlayers[g,f].SideStep[1] := TurnOn;
    allPlayers[g,f].SideStep[2] := p;
    allPlayers[g,f].SideStep[3] := q;
  end else begin
    g := Ord(s[3]) - 48;
    f := Ord(s[4]) - 64;
    TurnOn := Ord(s[8]) - 48;
    p := Ord(s[9]) - 64;
    q := Ord(s[10]) - 64;
    allPlayers[g,f].SideStep[1] := TurnOn;
    allPlayers[g,f].SideStep[2] := p;
    allPlayers[g,f].SideStep[3] := q;
  end;
end;

procedure RPBCall(s: string);
var p, q, pno, y, z, f, g: integer;
    s2, s3, s4, s5: string;
    playerhere: boolean;
begin
  p := Pos('/', s);
  s2 := Copy(s, 1, p-1);
  while p > 0 do begin
    q := Pos('-', s2);
    s3 := Copy(s2, 1, q-1);
    s4 := Copy(s2, q+1, length(s2)-q);
    s5 := Copy(s4, 2, length(s4)-1);
    pno := FVal(s3);
    y := FVal(s5)-1;
    if Ord(s4[1])-65 > 12 then
      z := 25 - (Ord(s4[1])-65)
    else
      z:=Ord(s4[1])-65;

    if (pno >= 1) and (pno<=32) then
    begin
      if (allPlayers[0,pno].status = 0)
        and (y>=0) and (y<=14)
        and (z>=0) and (z<=25) then
      begin
        playerhere := false;
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if (allPlayers[g,f].p=y) and (allPlayers[g,f].q=z) then playerhere := true;
          end;
        end;
        if not(playerhere) then PlacePlayer(pno, 0, y, z);
      end;
    end;
    s := Copy(s, p+1, length(s)-p);
    p := Pos('/', s);
    s2 := Copy(s, 1, p-1);
  end;
  Bloodbowl.ViewRedPB1.Visible := false;
end;

procedure BPBCall(s: string);
var p, q, pno, y, z, f, g: integer;
    s2, s3, s4, s5: string;
    playerhere: boolean;
begin
  p := Pos('/', s);
  s2 := Copy(s, 1, p-1);
  while p > 0 do begin
    q := Pos('-', s2);
    s3 := Copy(s2, 1, q-1);
    s4 := Copy(s2, q+1, length(s2)-q);
    s5 := Copy(s4, 2, length(s4)-1);
    pno := FVal(s3);
    y := FVal(s5)-1;
    if Ord(s4[1])-65 < 13 then z := 25 - (Ord(s4[1])-65) else z:=Ord(s4[1])-65;
    if (pno >= 1) and (pno<=32) then begin
      if (allPlayers[1,pno].status = 0) and (y>=0) and (y<=14) and (z>=0)
      and (z<=25) then begin
        playerhere := false;
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if (allPlayers[g,f].p=y) and (allPlayers[g,f].q=z) then playerhere := true;
          end;
        end;
        if not(playerhere) then PlacePlayer(pno, 1, y, z);
      end;
    end;
    s := Copy(s, p+1, length(s)-p);
    p := Pos('/', s);
    s2 := Copy(s, 1, p-1);
  end;
  Bloodbowl.ViewBluePB1.Visible := false;
end;

end.
