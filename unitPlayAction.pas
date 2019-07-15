unit unitPlayAction;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

var
  WaitLength: integer;
const
  DIR_FORWARD = 1;

procedure Wait;
procedure DefaultAction(s: string);

procedure PlayActionNote(s: string; dir: integer);
procedure PlayActionComment(s: string; dir, tm: integer);
procedure PlayActionRoll1Die(s: string; dir: integer);
procedure PlayActionRoll2Dice(s: string; dir: integer);
procedure PlayActionRollScatter(s: string; dir: integer);
procedure PlayActionRollBlockDice(s: string; dir, num: integer);
procedure PlayActionThrowIn(s: string; dir: integer);
procedure PlayActionKickOff(s: string; dir: integer);
procedure PlayActionArmourRoll(s: string; dir: integer);
procedure PlayActionInjuryRoll(s: string; dir: integer);
procedure PlayActionFoulRoll(s: string; dir: integer);

procedure PlayActionUseWiz(s: string; dir: integer);
procedure PlayActionRandomPlayer(s: string; dir: integer);
procedure PlayActionSetIGMEOY(s: string; dir: integer);
procedure PlayActionCheat(s: string);
procedure PlayActionPGFI(s: string; dir: integer);
procedure PlayActionDeStun(s: string; dir: integer);
procedure PlayActionCoachRef(s: string; dir: integer);
procedure PlayActionComputerID(s: string; dir: integer);
procedure PlayActionLuck(s: string; dir: integer);
procedure PlayActionPlayBook(s: string; dir: integer);

implementation

uses bbunit, unitLog, bbalg, unitNotes, unitThrowIn, unitBall, unitPlayer,
     unitField, unitSettings;

procedure Wait;
var h, m, s, ms: word;
    wt: TDateTime;
begin
  DecodeTime(time, h, m, s, ms);
  ms := ms + WaitLength;
  s := s + ms div 1000;
  ms := ms mod 1000;
  m := m + s div 60;
  s := s mod 60;
  h := h + m div 60;
  m := m mod 60;
  wt := EncodeTime(h, m, s, ms);
  while Time < wt do ;
end;

procedure DefaultAction(s: string);
begin
  AddLog(s);
  if WaitLength > 0 then
    Wait;
end;

procedure PlayActionNote(s: string; dir: integer);
begin
  if dir = DIR_FORWARD then begin
    AddNote(Copy(s, 2, length(s) - 2));
    DefaultAction('Note: "' + Copy(s, 2, length(s) - 2) + '"');
  end else begin
    RemoveNote;
    BackLog;
  end;
end;

procedure PlayActionComment(s: string; dir, tm: integer);
begin
  if dir = DIR_FORWARD then begin
    if tm < 2 then
       DefaultAction(ffcl[tm] + ': "' + Copy(s, 2, length(s) - 2) + '"')
    else
       DefaultAction('"' + Copy(s, 2, length(s) - 2) + '"')
  end else begin
    BackLog;
  end;
end;

procedure PlayActionRoll1Die(s: string; dir: integer);
begin
  DiceRollShow(Ord(s[2]) - 48, 0);
  if dir = DIR_FORWARD then begin
    DefaultAction('Roll: ' + s[2]);
  end else begin
    BackLog;
  end;
end;

procedure PlayActionRoll2Dice(s: string; dir: integer);
begin
  DiceRollShow(Ord(s[3]) - 48, Ord(s[2]) - 48);
  if dir = DIR_FORWARD then begin
    DefaultAction('Roll: (' + s[2] + ',' + s[3] +
                  ') = ' + IntToStr(Ord(s[2]) + Ord(s[3]) - 96));
  end else begin
    BackLog;
  end;
end;

procedure PlayActionRollScatter(s: string; dir: integer);
begin
  ScatterRollShow(Ord(s[2]) - 48);
  if dir = DIR_FORWARD then begin
    DefaultAction('Scatter: ' + s[2]);
  end else begin
    BackLog;
  end;
end;

procedure PlayActionRollBlockDice(s: string; dir, num: integer);
var s0: string;
    d1, d2, d3: integer;
begin
  d2 := 0;
  d3 := 0;
  d1 := Ord(s[2]) - 48;
  s0 := 'Block roll: ' + DBroll[d1];
  if num > 1 then begin
    d2 := Ord(s[3]) - 48;
    s0 := s0 + ' , ' + DBRoll[d2];
  end;
  if num > 2 then begin
    d3 := Ord(s[4]) - 48;
    s0 := s0 + ' , ' + DBRoll[d3];
  end;
  BlockRollShow(d1, d2, d3);
  if dir = DIR_FORWARD then begin
    DefaultAction(s0);
  end else begin
    BackLog;
  end;
end;

procedure PlayActionThrowIn(s: string; dir: integer);
begin
  if dir = DIR_FORWARD then begin
    DefaultAction(TranslateThrowIn(s));
  end else begin
    BackLog;
  end;
end;


procedure PlayActionKickOff(s: string; dir: integer);
var f, g: integer;
begin
  if dir = DIR_FORWARD then begin
    f := Ord(s[3]) - 48;
    g := Ord(s[4]) - 48;
    DefaultAction('(' + IntToStr(f) + ',' + IntToStr(g) + ') : ' +
      KickoffTable[(f*10) + g]);
  end else begin
    BackLog;
  end;
end;

procedure PlayActionArmourRoll(s: string; dir: integer);
begin
  if dir = DIR_FORWARD then begin
    DefaultAction(ArmourRollToText(Copy(s,2,length(s))));
  end else begin
    BackLog;
  end;
end;

procedure PlayActionInjuryRoll(s: string; dir: integer);
begin
  if dir = DIR_FORWARD then begin
    DefaultAction(InjuryRollToText(Copy(s,2,length(s))));
  end else begin
    BackLog;
  end;
end;

procedure PlayActionFoulRoll(s: string; dir: integer);
begin
  if dir = DIR_FORWARD then begin
    DefaultAction(FoulRollToText(Copy(s,2,length(s))));
  end else begin
    BackLog;
  end;
end;


procedure PlayActionUseWiz(s: string; dir: integer);
var g: integer;
begin
  g := Ord(s[2]) - 48;
  if dir = DIR_FORWARD then begin
    wiz[g].color := colorarray[g, 4, 0];
    wiz[g].font.color := colorarray[g, 4, 1];
    DefaultAction(ffcl[g] + '''s Wizard casts a spell');
  end else begin
    BackLog;
    wiz[g].color := colorarray[g, 0, 0];
    wiz[g].font.color := colorarray[g, 0, 1];
  end;
end;

procedure PlayActionRandomPlayer(s: string; dir: integer);
var f, g: integer;
begin
  if dir = DIR_FORWARD then begin
    g := Ord(s[2]) - 48;
    f := Ord(s[3]) - 64;
    DefaultAction('Randomly chosen player: ' + allPlayers[g,f].GetPlayerName);
  end else begin
    BackLog;
  end;
end;

procedure PlayActionSetIGMEOY(s: string; dir: integer);
var g: integer;
    s0: string;
begin
  if dir = DIR_FORWARD then begin
    g := Ord(s[3]) - 66;
    SetIGMEOY(g);
    if g = -1 then s0 := 'Reset' else s0 := ffcl[g];
    DefaultAction('I Got My Eye On You: ' + s0);
  end else begin
    g := Ord(s[2]) - 66;
    SetIGMEOY(g);
    BackLog;
  end;
end;

procedure PlayActionCheat(s: string);
var t: string;
    p, p2, p3: integer;
    Loadtest: boolean;
begin
  if CheckFileOpen then begin
    Loadtest := false;
    if s[1] = '+' then t := 'Edit';
    if s[1] = '/' then t := 'Int';
    if s[1] = '=' then begin
      if s[2] = 'N' then t := 'New Computer ID detected' else
      if s[2] = 'S' then t := 'Save' else begin
        Loadtest := true;
        p := Ord(s[3]) - 48;
        if p = 0 then t := 'Load' else
          t := 'RE-load ' + IntToStr(p);
      end;
      s := Copy(s, 3, length(s) - 2);
    end;
    p := Pos('@', s);
    p2 := Pos('%', s);
    p3 := Pos('$', s);
    if Loadtest then t := t + ' by ' + Copy(s, 2, p-2) + ' at ' + Copy(s, p+1, p2-p-1) +
      ' -- Save time: ' + Copy(s, p2+1, p3-p2-1) + ' -- Ver: ' +
        Copy(s, p3+1, Length(s) - p3) else
      t := t + ' by ' + Copy(s, 2, p-2) + ' at ' + Copy(s, p+1, p2-p-1);
    writeln(CheckFile, '***ALERT*** ' + t);
  end;
end;

procedure PlayActionComputerID(s: string; dir: integer);
var g: integer;
    nextopenSlot: boolean;
begin
  if dir = DIR_FORWARD then begin
    nextopenSlot := true;
    for g := 1 to 500 do begin
      if (nextopenSlot) and (ComputerID[g]=' ') then begin
        ComputerID[g] := Copy(s , 2, length(s)-1);
        nextopenSlot := false;
      end;
    end;
  end;
end;

procedure PlayActionLuck(s: string; dir: integer);
var x,y: integer;
    nextopenSlot: boolean;
begin
  if dir = DIR_FORWARD then begin
    if s[2]='R' then begin
      x := Pos('|', s);
      y := Pos('~', s);
      if D3RollRed < FVal((Copy(s, x+1, y-(x+1)))) then
        D3RollRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('~', s);
      y := Pos('!', s);
      if D3RollTOTRed < FVal((Copy(s, x+1, y-(x+1)))) then
        D3RollTOTRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('!', s);
      y := Pos('=', s);
      if KDownRed < FVal((Copy(s, x+1, y-(x+1)))) then
        KDownRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('=', s);
      y := Pos('?', s);
      if KDownTOTRed < FVal((Copy(s, x+1, y-(x+1)))) then
        KDownTOTRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('?', s);
      y := Pos('<', s);
      if AVBreakRed < FVal((Copy(s, x+1, y-(x+1)))) then
        AVBreakRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('<', s);
      y := Pos('>', s);
      if AVBreakTOTRed < FVal((Copy(s, x+1, y-(x+1)))) then
        AVBreakTOTRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('>', s);
      y := Pos('*', s);
      if KOInjRed < FVal((Copy(s, x+1, y-(x+1)))) then
        KOInjRed := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('*', s);
      y := Pos('+', s);
      if KOInjTOTRed < FVal((Copy(s, x+1, y-(x+1)))) then
        KOInjTOTRed := FVal((Copy(s, x+1, y-(x+1))));
    end else begin
      x := Pos('|', s);
      y := Pos('~', s);
      if D3RollBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        D3RollBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('~', s);
      y := Pos('!', s);
      if D3RollTOTBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        D3RollTOTBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('!', s);
      y := Pos('=', s);
      if KDownBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        KDownBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('=', s);
      y := Pos('?', s);
      if KDownTOTBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        KDownTOTBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('?', s);
      y := Pos('<', s);
      if AVBreakBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        AVBreakBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('<', s);
      y := Pos('>', s);
      if AVBreakTOTBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        AVBreakTOTBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('>', s);
      y := Pos('*', s);
      if KOInjBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        KOInjBlue := FVal((Copy(s, x+1, y-(x+1))));
      x := Pos('*', s);
      y := Pos('+', s);
      if KOInjTOTBlue < FVal((Copy(s, x+1, y-(x+1)))) then
        KOInjTOTBlue := FVal((Copy(s, x+1, y-(x+1))));
    end;
  end;
end;

procedure PlayActionPlayBook(s: string; dir: integer);
var x,y,z: integer;
    s2, s3: string;
begin
  if dir = DIR_FORWARD then begin
    if s[2]='R' then begin
      x := Pos(':',s);
      s2 := Copy(s, 3, (x-3));
      y := FVal(s2);
      z := Pos('/',s);
      s3 := Copy(s, x+1, z-(x+1));
      if y=1 then begin
        BloodBowl.RPB1.Caption := s3;
        BloodBowl.RPB1.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB1.visible := true;
      end else if y=2 then begin
        BloodBowl.RPB2.Caption := s3;
        BloodBowl.RPB2.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB2.visible := true;
      end else if y=3 then begin
        BloodBowl.RPB3.Caption := s3;
        BloodBowl.RPB3.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB3.visible := true;
      end else if y=4 then begin
        BloodBowl.RPB4.Caption := s3;
        BloodBowl.RPB4.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB4.visible := true;
      end else if y=5 then begin
        BloodBowl.RPB5.Caption := s3;
        BloodBowl.RPB5.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB5.visible := true;
      end else if y=6 then begin
        BloodBowl.RPB6.Caption := s3;
        BloodBowl.RPB6.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB6.visible := true;
      end else if y=7 then begin
        BloodBowl.RPB7.Caption := s3;
        BloodBowl.RPB7.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB7.visible := true;
      end else if y=8 then begin
        BloodBowl.RPB8.Caption := s3;
        BloodBowl.RPB8.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB8.visible := true;
      end else if y=9 then begin
        BloodBowl.RPB9.Caption := s3;
        BloodBowl.RPB9.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB9.visible := true;
      end else if y=10 then begin
        BloodBowl.RPB10.Caption := s3;
        BloodBowl.RPB10.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.RPB10.visible := true;
      end;
    end else begin
      x := Pos(':',s);
      s2 := Copy(s, 3, (x-3));
      y := FVal(s2);
      z := Pos('/',s);
      s3 := Copy(s, x+1, z-(x+1));
      if y=1 then begin
        BloodBowl.BPB1.Caption := s3;
        BloodBowl.BPB1.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB1.visible := true;
      end else if y=2 then begin
        BloodBowl.BPB2.Caption := s3;
        BloodBowl.BPB2.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB2.visible := true;
      end else if y=3 then begin
        BloodBowl.BPB3.Caption := s3;
        BloodBowl.BPB3.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB3.visible := true;
      end else if y=4 then begin
        BloodBowl.BPB4.Caption := s3;
        BloodBowl.BPB4.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB4.visible := true;
      end else if y=5 then begin
        BloodBowl.BPB5.Caption := s3;
        BloodBowl.BPB5.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB5.visible := true;
      end else if y=6 then begin
        BloodBowl.BPB6.Caption := s3;
        BloodBowl.BPB6.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB6.visible := true;
      end else if y=7 then begin
        BloodBowl.BPB7.Caption := s3;
        BloodBowl.BPB7.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB7.visible := true;
      end else if y=8 then begin
        BloodBowl.BPB8.Caption := s3;
        BloodBowl.BPB8.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB8.visible := true;
      end else if y=9 then begin
        BloodBowl.BPB9.Caption := s3;
        BloodBowl.BPB9.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB9.visible := true;
      end else if y=10 then begin
        BloodBowl.BPB10.Caption := s3;
        BloodBowl.BPB10.Hint := Copy(s, z+1, length(s)-z);
        BloodBowl.BPB10.visible := true;
      end;
    end;
  end;
end;

procedure PlayActionPGFI(s: string; dir: integer);
var g, f: integer;
begin
  if dir = DIR_FORWARD then begin
    g := Ord(s[3]) - 48;
    f := Ord(s[4]) - 64;
    allPlayers[g,f].GFI := allPlayers[g,f].GFI + 1;
  end else begin
    g := Ord(s[3]) - 48;
    f := Ord(s[4]) - 64;
    allPlayers[g,f].GFI := allPlayers[g,f].GFI - 1;
  end;
end;

procedure PlayActionDeStun(s: string; dir: integer);
var g, f, increment: integer;
begin
  if dir = DIR_FORWARD then begin
    g := Ord(s[3]) - 48;
    f := Ord(s[4]) - 64;
    increment := Ord(s[5]) - 48;
    allPlayers[g,f].StunStatus := allPlayers[g,f].StunStatus + increment;
  end else begin
    g := Ord(s[3]) - 48;
    f := Ord(s[4]) - 64;
    increment := Ord(s[5]) - 48;
    allPlayers[g,f].StunStatus := allPlayers[g,f].StunStatus - increment;
  end;
end;

procedure PlayActionCoachRef(s: string; dir: integer);
var g, ArgueCall: integer;
begin
  if dir = DIR_FORWARD then begin
    if s[2]='C' then begin
      g := Ord(s[3]) - 48;
      ArgueCall := Ord(s[4]) - 48;
      if ArgueCall = 1 then begin
        team[g].HeadCoach := false;
        Bloodbowl.ArgueCallSB.Visible := false;
      end;
    end else begin
      g := Ord(s[3]) - 48;
      GettheRef := g;
    end;
  end else begin
    if s[2]='C' then begin
      g := Ord(s[3]) - 48;
      ArgueCall := Ord(s[4]) - 48;
      if ArgueCall = 1 then begin
        team[g].HeadCoach := true;
        Bloodbowl.ArgueCallSB.Visible := true;
      end;
    end else begin
      GettheRef := 3;
    end;
  end;
end;

function RefereeRollToText(s: string): string;
var Refroll, refpos: integer;
    t: string;
begin

end;

end.
