unit bbalg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const
  EMailAddress = 'bbtool@yahoogroups.com';
  PBeMVersion = '2.5b';
  PBeMVerText = 'Ronald Lokers Bloodbowl Tool version 2.5b Release';
  MVPValue = 5;
  DirtyPlayerArmourModifier = 1;
  DirtyPlayerInjuryModifier = 1;
  RegenRollNeeded = 4;

type
  TPlayerStatus = (
  PLAYER_STATUS_BALL_CARRIER = 2,
  PLAYER_STATUS_PRONE = 3);

type
  TWeather = (Sweltering, Sunny, Nice, Raining, Blizzard);
  function ParseWeather(s: string): TWeather;

type
  TmodAlg = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TackleZones = record
                     num: integer;
                     pl: array [1..8] of integer;
                   end;

var
  modAlg: TmodAlg;
  colorarray: array [0..1,0..14,0..1] of TColor;
  RLCoach: array [0..1] of string;
  LoggedCoach: string;
  statusarray: array [0..14] of string;
  SIstatusarray: array [0..24] of string;
  DBroll: array [1..6] of string;
  KickoffTable: array [11..66] of string;
  WeatherTable: array [2..12] of string;
  Gate, diecolor, PlayButtonDelay, NumNiggles: integer;
  curdir: string;
  ffcl: array [0..1] of string;
  DBrolls: array [1..3] of integer;
  PassRangeShowing, PassBlockRangeShowing, DivingTackleRangeShowing,
  TackleRangeShowing, MakeCheckFile, CheckFileOpen,
  InEditMode, MakeExportLog, ExportFileOpen: boolean;
  CheckFile, ExportLog: TextFile;

procedure NewPosInDir(var p, q: integer; d: integer);
function MoneyVal(s: string): integer;
function IntToStr(i: integer): string;
function FVal(s: string): integer;
procedure SplitTextAtChr255(var s0, t: string);
procedure FillColorArray(g: integer; cBase: TColor);
procedure InitTables;
procedure FillKOTable;
procedure FillWTable;
procedure DiceRollShow(r1, r2: integer);
procedure ScatterRollShow(r: integer);
procedure BlockRollShow(r1, r2, r3: integer);
function InjuryRollToText(s: string): string;
function ArmourRollToText(s: string): string;
function FoulRollToText(s: string): string;
function InjuryRoll(injmod: integer): string;
function ArmourRoll(av, armod, injmod: integer): string;
function FoulRoll(av, armod, injmod: integer; eye: boolean): string;
function TranslateHandicap: string;
function TranslateNiggle(nr: string): string;
function TranslateNiggleResult(nr: string): string;
function CountTZ(g0, f0: integer): TackleZones;
function CountOpponents(g0, f0: integer): integer;
function CountTZSlow(g0, f0: integer): TackleZones;
function CountTZEmpty(g0, p, q: integer): TackleZones;
function CountTZBlockA(g0, f0: integer): TackleZones;
function CountTZBlockCA(g0, f0: integer): TackleZones;
function CountTZBlockCA2(g0, f0: integer): TackleZones;
function CountTZFoul(g0, f0: integer): TackleZones;
function CountTZDTS(g0, f0: integer): TackleZones;
function CountNoBhead(g0, f0: integer): integer;
function CountFA(g0, f0: integer): integer;
function CountPB(g0, f0, CatcherP, CatcherQ: integer; PassPB: boolean): integer;
function RangeRulerRange(p,q,p0,q0: integer): integer;
function CanIntercept(p,q,p0,q0,i,j: integer): boolean;
procedure WorkOutBlock(g, f, g0, f0: integer);
procedure WorkOutFoul(g, f, g0, f0: integer);
procedure SetIGMEOY(g: integer);
procedure InjurySettings(g0, f0: integer);
procedure ArmourSettings(g, f, g0, f0, special: integer);
procedure ResetPlayers;
function GetR6Value(totspp: integer): integer;

implementation

uses unitLog, bbunit, unitNotes, unitBall, unitPlayer, unitTeam,
     unitField, unitMarker, unitRandom, unitArmourRoll, unitSettings,
     unitMessage;

{$R *.DFM}

function ParseWeather(s: string): TWeather;
begin
  if s = 'SWELTERING HEAT' then
    Result := Sweltering
  else if s = 'VERY SUNNY' then
    Result := Sunny
  else if s = 'POURING RAIN'  then
    Result := Raining
  else if s = 'BLIZZARD' then
    Result := Blizzard
  else
    Result := Nice;
end;


function GetR6Value(totspp: integer): integer;
var r6: integer;
begin
  if totspp >= 176 then r6 := 100 else
    if totspp >= 76 then r6 := 126 - totspp else
    if totspp >= 51 then r6 := 76 - totspp else
    if totspp >= 31 then r6 := 51 - totspp else
    if totspp >= 16 then r6 := 31 - totspp else
    if totspp >= 6 then r6 := 16 - totspp else
    r6 := 6 - totspp;

    Result := r6;
end;


procedure NewPosInDir(var p, q: integer; d: integer);
begin
  case d of
    1: begin
         p := p - 1;
         q := q - 1;
       end;
    2: p := p - 1;
    3: begin
         p := p - 1;
         q := q + 1;
       end;
    4: q := q - 1;
    5: q := q + 1;
    6: begin
         p := p + 1;
         q := q - 1;
       end;
    7: p := p + 1;
    8: begin
         p := p + 1;
         q := q + 1;
       end;
  end;
end;

function MoneyVal(s: string): integer;
var p: integer;
begin
  p := 1;
  s := s + 'x0x';  {om lege string af te vangen}
  while (p <= Length(s)) and (((s[p] < '0') or (s[p] > '9'))
    and (s[p] <> '-')) do
    p := p + 1;
  s := Trim(Copy(s, p, Length(s) - p + 1));
  p := 1;
  while (p <= Length(s)) and (((s[p] >= '0')
    and (s[p] <= '9')) or (s[p]='-')) do
    p := p + 1;
  s := Trim(Copy(s, 1, p-1));
  p := Pos('000', s);
  if p > 0 then MoneyVal := FVal(Copy(s, 1, Length(s) - 3))
           else MoneyVal := FVal(s);
end;

function IntToStr(i: integer): string;
var s: string;
begin
  Str(i, s);
  IntToStr := s;
end;

function FVal(s: string): integer;
var w, c: integer;
begin
  Val(s, w, c);
  FVal := w;
end;

procedure SplitTextAtChr255(var s0, t: string);
var p: integer;
begin
  p := Pos(Chr(255), s0);
  if p = 0 then begin
    t := s0;
    s0 := '';
  end else begin
    t := Copy(s0, 1, p-1);
    s0 := Copy(s0, p+1, length(s0));
  end;
end;

procedure FillColorArray(g: integer; cBase: TColor);
begin
  TeamTextColor[g] := cBase;
  colorarray[g,0,0] := cBase;        colorarray[g,0,1] := clWhite;
  colorarray[g,1,0] := cBase;        colorarray[g,1,1] := clWhite;
  colorarray[g,2,0] := cBase or $00888888;
  if (colorarray[g,2,0] = cBase) then
      colorarray[g,2,0] := cBase xor $00888888;
                                     colorarray[g,2,1] := clWhite;
  colorarray[g,3,0] := clSilver;     colorarray[g,3,1] := cBase;
  colorarray[g,4,0] := clGray;       colorarray[g,4,1] := cBase;
  colorarray[g,5,0] := cBase;        colorarray[g,5,1] := clWhite;
  colorarray[g,6,0] := cBase;        colorarray[g,6,1] := clWhite;
  colorarray[g,7,0] := cBase;        colorarray[g,7,1] := clSilver;
  colorarray[g,8,0] := cBase;        colorarray[g,8,1] := clBlack;
  colorarray[g,9,0] := clGray;       colorarray[g,9,1] := cBase;
  colorarray[g,10,0] := clSilver;    colorarray[g,10,1] := cBase;
  colorarray[g,11,0] := clWhite;     colorarray[g,11,1] := cBase;
  colorarray[g,12,0] := clBlack;     colorarray[g,12,1] := cBase;
  colorarray[g,13,0] := clFuchsia;   colorarray[g,13,1] := cBase;
  colorarray[g,14,0] := clYellow;    colorarray[g,14,1] := cBase;
end;

procedure InitTables;
begin
  ffcl[0] := 'Home';
  ffcl[1] := 'Away';
  FillColorArray(0, TeamTextColor[0]);
  FillColorArray(1, TeamTextColor[1]);

  statusarray[0] := 'reserve';
  statusarray[1] := 'is standing';
  statusarray[2] := 'gets the ball';
  statusarray[3] := 'is prone';
  statusarray[4] := 'is stunned';
  statusarray[5] := 'Knocked Out';
  statusarray[6] := 'Badly Hurt';
  statusarray[7] := 'Seriously Injured';
  statusarray[8] := 'DEAD!';
  statusarray[9] := 'Niggled Out';
  statusarray[10] := 'Misses Game';
  statusarray[11] := 'Empty Roster Slot';
  statusarray[12] := 'Sent Off';
  statusarray[13] := 'Temporarily Out';
  statusarray[14] := 'Heat Exhaustion';
  SIstatusarray[0] := ' (Miss Next Game)';
  SIstatusarray[1] := ' (Niggling Injury)';
  SIstatusarray[2] := ' (-1 MA)';
  SIstatusarray[3] := ' (-1 ST)';
  SIstatusarray[4] := ' (-1 AG)';
  SIstatusarray[5] := ' (-1 AV)';
  SIstatusarray[10] := ' (2 Niggling Injuries)';
  SIstatusarray[11] := ' (Niggling Injury and -1 MA)';
  SIstatusarray[12] := ' (Niggling Injury and -1 ST)';
  SIstatusarray[13] := ' (Niggling Injury and -1 AG)';
  SIstatusarray[14] := ' (Niggling Injury and -1 AV)';
  SIstatusarray[15] := ' (-1 MA and -1 ST)';
  SIstatusarray[16] := ' (-1 MA and -1 AG)';
  SIstatusarray[17] := ' (-1 MA and -1 MA)';
  SIstatusarray[18] := ' (-1 MA and -1 AV)';
  SIstatusarray[19] := ' (-1 ST and -1 ST)';
  SIstatusarray[20] := ' (-1 ST and -1 AG)';
  SIstatusarray[21] := ' (-1 ST and -1 AV)';
  SIstatusarray[22] := ' (-1 AG and -1 AG)';
  SIstatusarray[23] := ' (-1 AG and -1 AV)';
  SIstatusarray[24] := ' (-1 AV and -1 AV)';
  DBroll[1] := 'Skull';
  DBroll[2] := 'POW/Skull';
  DBroll[3] := 'Pushback';
  DBroll[4] := 'Pushback';
  DBroll[5] := 'Pushback/POW';
  DBroll[6] := 'POW';
  diecolor := 0;
end;

procedure FillKOTable;
var gg: Textfile;
    g, h, i: integer;
    s, KOT: string;

begin
  AssignFile(gg, curdir + 'ini/bbtables.ini');
  Reset(gg);
  ReadLn(gg, s);
  KOT := Trim(frmSettings.txtKOTable.text);
  while Copy(s, 2, length(KOT)) <> KOT do ReadLn(gg, s);
  for g := 1 to 6 do begin
    for h := 1 to 6 do begin
      i := (g * 10) + h;
      ReadLn(gg, s);
      KickoffTable[i] := Trim(Copy(s, 4, Length(s) - 3));
    end;
  end;
  CloseFile(gg);
end;

procedure FillWTable;
var gg: Textfile;
    g, menucount, p, i: integer;
    s, WT, s0, s2, s3: string;
    newtype: boolean;
    NewTable: array [2..12] of string;

begin
  AssignFile(gg, curdir + 'ini/bbtables.ini');
  Reset(gg);
  ReadLn(gg, s);
  WT := Trim(frmSettings.txtWeatherTable.text);
  while Copy(s, 2, length(WT)) <> WT do ReadLn(gg, s);
  for g := 2 to 12 do begin
    ReadLn(gg, s);
    WeatherTable[g] := Trim(Copy(s, 4, Length(s) - 3));
  end;
  menucount := 1;
  for g := 2 to 12 do begin
    if menucount = 1 then begin
      s0 := WeatherTable[g];
      p := Pos('.', s0);
      Bloodbowl.PWeather1.Caption :=  Copy(s0,1,p-1);
      NewTable[menucount] := Copy(s0,1,p-1);
      menucount := menucount +1;
    end else begin
      newtype := true;
      s0 := WeatherTable[g];
      p := Pos('.', s0);
      s2 := Copy(s0, 1, p-1);
      for i := 1 to menucount do begin
        s3 := NewTable[i];
        if s2=s3 then newtype := false;
      end;
      if newtype then begin
        if menucount=2 then Bloodbowl.PWeather2.Caption :=  s2 else
        if menucount=3 then Bloodbowl.PWeather3.Caption :=  s2 else
        if menucount=4 then Bloodbowl.PWeather4.Caption :=  s2 else
        if menucount=5 then Bloodbowl.PWeather5.Caption :=  s2 else
        if menucount=6 then Bloodbowl.PWeather6.Caption :=  s2 else
        if menucount=7 then Bloodbowl.PWeather7.Caption :=  s2 else
        if menucount=8 then Bloodbowl.PWeather8.Caption :=  s2 else
        if menucount=9 then Bloodbowl.PWeather9.Caption :=  s2 else
        if menucount=10 then Bloodbowl.PWeather10.Caption :=  s2 else
        if menucount=11 then Bloodbowl.PWeather11.Caption :=  s2;
        NewTable[menucount] := s2;
        menucount := menucount + 1;
      end;
    end;
  end;
  if menucount < 12 then Bloodbowl.PWeather11.Visible := false;
  if menucount < 11 then Bloodbowl.PWeather10.Visible := false;
  if menucount < 10 then Bloodbowl.PWeather9.Visible := false;
  if menucount < 9 then Bloodbowl.PWeather8.Visible := false;
  if menucount < 8 then Bloodbowl.PWeather7.Visible := false;
  if menucount < 7 then Bloodbowl.PWeather6.Visible := false;
  if menucount < 6 then Bloodbowl.PWeather5.Visible := false;
  if menucount < 5 then Bloodbowl.PWeather4.Visible := false;
  if menucount < 4 then Bloodbowl.PWeather3.Visible := false;
  if menucount < 3 then Bloodbowl.PWeather2.Visible := false;
  if menucount < 2 then Bloodbowl.PWeather1.Visible := false;
  CloseFile(gg);
end;

function DicePic(r: integer): string;
begin
  if diecolor = 0 then DicePic := 'die' + IntToStr(r) + '.bmp'
     else DicePic := 'die' + IntToStr(r) + 'b.bmp';
end;

procedure DiceRollShow(r1, r2: integer);
begin
  Bloodbowl.DiceRoll1.picture.LoadFromFile(curdir + 'images\' + DicePic(r1));
  if r2 > 0 then begin
    Bloodbowl.DiceRoll2.picture.LoadFromFile(curdir + 'images\' + DicePic(r2));
    Bloodbowl.DiceRoll2.visible := true;
  end else Bloodbowl.DiceRoll2.visible := false;
  if ref then begin
    Bloodbowl.DiceRoll1.Refresh;
    Bloodbowl.DiceRoll2.Refresh;
  end;
  diecolor := 1 - diecolor;
end;

procedure ScatterRollShow(r: integer);
begin
  Bloodbowl.DiceRoll1.picture.LoadFromFile(curdir +
           'images\scatter' + IntToStr(r) + '.bmp');
  Bloodbowl.DiceRoll2.visible := false;
  if ref then begin
    Bloodbowl.DiceRoll1.Refresh;
    Bloodbowl.DiceRoll2.Refresh;
  end;
end;

function BlockPic(r: integer): string;
begin
  case r of
   1: BlockPic := 'skull.bmp';
   2: BlockPic := 'powskull.bmp';
   3: BlockPic := 'pushback.bmp';
   4: BlockPic := 'pushback.bmp';
   5: BlockPic := 'powpush.bmp';
   6: BlockPic := 'pow.bmp';
  end;
end;

procedure BlockRollShow(r1, r2, r3: integer);
begin
  DBrolls[1] := r1;
  DBrolls[2] := r2;
  DBrolls[3] := r3;
  Bloodbowl.BlockRoll1.picture.LoadFromFile(curdir + 'images\' + BlockPic(r1));
  if r2 > 0 then begin
    Bloodbowl.BlockRoll2.picture.LoadFromFile(
                curdir +  'images\' + BlockPic(r2));
    Bloodbowl.BlockRoll2.visible := true;
  end else Bloodbowl.BlockRoll2.visible := false;
  if r3 > 0 then begin
    Bloodbowl.BlockRoll3.picture.LoadFromFile(
                curdir + 'images\' + BlockPic(r3));
    Bloodbowl.BlockRoll3.visible := true;
  end else Bloodbowl.BlockRoll3.visible := false;
  if ref then begin
    Bloodbowl.BlockRoll1.Refresh;
    Bloodbowl.BlockRoll2.Refresh;
    Bloodbowl.BlockRoll3.Refresh;
  end;
end;

function InjuryRollToText(s: string): string;
var r, r2, r3, injmod: integer;
    t, Pro_TS: string;
    PDag, TSkull, IMan, PPunches: boolean;
begin
  {Ronald: next line added for backward compatibility}
  if not((s[3] = 'I') or (s[3] = ' ')) then
      s := s[1] + s[2] + '  ' + Copy(s, 3, Length(s) - 2);
  if s[1] = 'P' then PDag := true else PDag := false;
  if s[2] = 'T' then Tskull := true else Tskull := false;
  if s[3] = 'I' then Iman := true else Iman := false;
  if s[4] = 'U' then PPunches := true else PPunches := false;
  injmod := Ord(s[5]) - 48;
{  t := s + '~';
  t := t+'Injury Roll (' + s[6] + ',' + s[7] + ')'; }
  t := 'Injury Roll (' + s[6] + ',' + s[7] + ')';
  if injmod > 0 then t := t + '+' + IntToStr(injmod);
  if injmod < 0 then t := t + IntToStr(injmod);
  r := FVal(s[6]) + FVal(s[7]) + injmod;
  t := t + '=' + IntToStr(r);
  if r < 8 then begin
    t := t + ' Stunned';
    InjuryStatus := 4;
    if PDag then begin
      t := t + ', Poisoned Dagger turns to Knocked Out';
      InjuryStatus := 5;
    end;
    if (PDag) and (TSkull) and (not (ProSkill)) and
      (not (IMan)) then begin
        t := t + ', manually roll for Thick Skull save';
        InjuryStatus := 4;
      end;
    if (PDag) and (TSkull) and (ProSkill) and
      (not (IMan)) then begin
        t := t + ', manually roll for Thick Skull save (remember Pro for failure)';
        InjuryStatus := 4;
      end;
    if (PDag) and (IMan) then begin
      t := t + ', Iron Man converts to Stunned';
      InjuryStatus := 4;
    end;
  end else if r < 10 then begin
    if TSkull then begin
      if s[8]='A' then Pro_TS := '1' else
      if s[8]='B' then Pro_TS := '2' else
      if s[8]='C' then Pro_TS := '3' else
      if s[8]='D' then Pro_TS := '4' else
      if s[8]='E' then Pro_TS := '5' else
      if s[8]='F' then Pro_TS := '6' else Pro_TS := s[8];
      if (s[8] > '3') and (s[8] <= '6') then begin
        t := t + ' Knocked Out, Thick Skull: ' + s[8] + ' = Stunned';
        InjuryStatus := 4;
      end else if (s[8] >= 'A') and (s[8] <='C') then begin
        t := t + ' Knocked Out, Thick Skull after Pro: ' + Pro_TS + ' fails';
        InjuryStatus := 5;
      end else if (s[8] >= 'D') and (s[8] <='F') then begin
        t := t + ' Knocked Out, Thick Skull after Pro: ' + Pro_TS + ' = Stunned';
        InjuryStatus := 4;
      end else begin
        t := t + ' Knocked Out, Thick Skull: ' + s[8] + ' fails';
        InjuryStatus := 5;
      end;
    end else begin
      t := t + ' Knocked Out';
      InjuryStatus := 5;
    end;
  end else begin
      t := t + ' Sigurd''s Roll (' + s[8] + ') ';
      if s[14] = 'D' then t := t + ' 2nd Sigurd Roll (' + s[11] + ') ';
      r2 := FVal(s[8]);
      if s[14] = 'D' then begin
        r3 := FVal(s[11]);
        if r3 > 5 then r2 := 6;
        if r2 < 4 then r2 := r3;
      end;
      if r2 < 4 then begin
        t := t + 'Badly Hurt';
        InjuryStatus := 6;
      end else if r2 < 6 then begin
        if (FVal(s[8]) > 3) then t := t + ' SI Roll (' + s[9] + ',' + s[10] + ') ';
        if (s[14] = 'D') and (r3>3) then
          t := t + ' 2nd SI Roll (' + s[12] + ',' + s[13] + ') ';
        InjuryStatus := 70;
        if (FVal(s[8]) > 3) then begin
          case s[9] of
           '1': begin
                  if s[10] < '4' then t := t + 'Concussion; Miss Next Game'
                                else t := t + 'Broken Ribs; Miss Next Game';
                  InjuryStatus := 70;
                end;
           '2': begin
                  if s[10] < '4' then t := t + 'Groin Strain; Miss Next Game'
                                else t := t + 'Gouged Eye; Miss Next Game';
                  InjuryStatus := 70;
                end;
           '3': begin
                  if s[10] < '4' then t := t + 'Broken Jaw; Miss Next Game'
                                else t := t + 'Fractured Arm; Miss Next Game';
                  InjuryStatus := 70;
                end;
           '4': begin
                  if s[10] < '4' then t := t + 'Fractured Leg; '
                                else t := t + 'Smashed Hand; ';
                  begin
                    t := t + 'Miss Next Game';
                    InjuryStatus := 70;
                  end;
                end;
           '5': begin
                  case s[10] of
                    '1', '2': t :=  t + 'Damaged Back; Niggling Injury';
                    '3', '4': t :=  t + 'Smashed Knee; Niggling Injury';
                    '5', '6': t :=  t + 'Pinched Nerve; Niggling Injury';
                  end;
                  InjuryStatus := 71;
                end;
           '6': begin
                  case s[10] of
                   '1': begin
                          t :=  t + 'Smashed Hip; -1 MA';
                          InjuryStatus := 72;
                        end;
                   '2': begin
                          t :=  t + 'Smashed Ankle; -1 MA';
                          InjuryStatus := 72;
                        end;
                   '3': begin
                          t :=  t + 'Smashed Collar Bone; -1 ST';
                          InjuryStatus := 73;
                        end;
                   '4': begin
                          t :=  t + 'Broken Neck; -1 AG';
                          InjuryStatus := 74;
                        end;
                   '5': begin
                          t :=  t + 'Serious Concussion; -1 AV';
                          InjuryStatus := 75;
                        end;
                   '6': begin
                          t :=  t + 'Fractured Skull; -1 AV';
                          InjuryStatus := 75;
                       end;
                  end;
                end;
          end;
        end;
        if (s[14] = 'D') and (r3 > 3) and (r3 < 6)  then begin
          case s[12] of
           '1': begin
                  if s[13] < '4' then t := t + ' Concussion; Miss Next Game'
                                else t := t + ' Broken Ribs; Miss Next Game';
                  InjuryStatus := InjuryStatus;
                end;
           '2': begin
                  if s[13] < '4' then t := t + ' Groin Strain; Miss Next Game'
                                else t := t + ' Gouged Eye; Miss Next Game';
                  InjuryStatus := InjuryStatus;
                end;
           '3': begin
                  if s[13] < '4' then t := t + ' Broken Jaw; Miss Next Game'
                                else t := t + ' Fractured Arm; Miss Next Game';
                  InjuryStatus := InjuryStatus;
                end;
           '4': begin
                  if s[13] < '4' then t := t + ' Fractured Leg; '
                                else t := t + ' Smashed Hand; ';
                  begin
                    t := t + ' Miss Next Game';
                    InjuryStatus := InjuryStatus;
                  end;
                end;
           '5': begin
                  case s[13] of
                   '1', '2': t :=  t + ' Damaged Back; Niggling Injury';
                   '3', '4': t :=  t + ' Smashed Knee; Niggling Injury';
                   '5', '6': t :=  t + ' Pinched Nerve; Niggling Injury';
                  end;
                  if InjuryStatus = 71 then InjuryStatus := 80;
                  if InjuryStatus = 70 then InjuryStatus := 71;
                  if InjuryStatus = 72 then InjuryStatus := 81;
                  if InjuryStatus = 73 then InjuryStatus := 82;
                  if InjuryStatus = 74 then InjuryStatus := 83;
                  if InjuryStatus = 75 then InjuryStatus := 84;
                end;
           '6': begin
                  case s[13] of
                   '1': begin
                          t :=  t + ' Smashed Hip; -1 MA';
                          if InjuryStatus = 71 then InjuryStatus := 81;
                          if InjuryStatus = 72 then InjuryStatus := 87;
                          if InjuryStatus = 70 then InjuryStatus := 72;
                          if InjuryStatus = 73 then InjuryStatus := 85;
                          if InjuryStatus = 74 then InjuryStatus := 86;
                          if InjuryStatus = 75 then InjuryStatus := 88;
                        end;
                   '2': begin
                          t :=  t + ' Smashed Ankle; -1 MA';
                          if InjuryStatus = 71 then InjuryStatus := 81;
                          if InjuryStatus = 72 then InjuryStatus := 87;
                          if InjuryStatus = 70 then InjuryStatus := 72;
                          if InjuryStatus = 73 then InjuryStatus := 85;
                          if InjuryStatus = 74 then InjuryStatus := 86;
                          if InjuryStatus = 75 then InjuryStatus := 88;
                        end;
                   '3': begin
                          t :=  t + ' Smashed Collar Bone; -1 ST';
                          if InjuryStatus = 71 then InjuryStatus := 82;
                          if InjuryStatus = 72 then InjuryStatus := 85;
                          if InjuryStatus = 73 then InjuryStatus := 89;
                          if InjuryStatus = 70 then InjuryStatus := 73;
                          if InjuryStatus = 74 then InjuryStatus := 90;
                          if InjuryStatus = 75 then InjuryStatus := 91;
                        end;
                   '4': begin
                          t :=  t + ' Broken Neck; -1 AG';
                          if InjuryStatus = 71 then InjuryStatus := 83;
                          if InjuryStatus = 72 then InjuryStatus := 86;
                          if InjuryStatus = 73 then InjuryStatus := 90;
                          if InjuryStatus = 74 then InjuryStatus := 92;
                          if InjuryStatus = 70 then InjuryStatus := 74;
                          if InjuryStatus = 75 then InjuryStatus := 93;
                        end;
                   '5': begin
                          t :=  t + ' Serious Concussion; -1 AV';
                          if InjuryStatus = 71 then InjuryStatus := 84;
                          if InjuryStatus = 72 then InjuryStatus := 88;
                          if InjuryStatus = 73 then InjuryStatus := 91;
                          if InjuryStatus = 74 then InjuryStatus := 93;
                          if InjuryStatus = 75 then InjuryStatus := 94;
                          if InjuryStatus = 70 then InjuryStatus := 75;
                        end;
                   '6': begin
                          t :=  t + ' Fractured Skull; -1 AV';
                          if InjuryStatus = 71 then InjuryStatus := 84;
                          if InjuryStatus = 72 then InjuryStatus := 88;
                          if InjuryStatus = 73 then InjuryStatus := 91;
                          if InjuryStatus = 74 then InjuryStatus := 93;
                          if InjuryStatus = 75 then InjuryStatus := 94;
                          if InjuryStatus = 70 then InjuryStatus := 75;
                        end;
                  end;
                end;
          end;
        end;
      end else begin
        t := t + 'DEAD!';
        InjuryStatus := 8;
      end;
  end;
  if (r >= 8) and (Iman) then begin
     t := t + ' - Iron Man result is now Stunned';
     InjuryStatus := 4;
  end;
  if (r >= 8) and (PPunches) then begin
    t := t + ' - Pulled Punches result is now Stunned';
    InjuryStatus := 4;
  end;
  if (r < 8) and (Iman) and (PDag)  then begin
    t := t + ' - Iron Man result is now Stunned';
    InjuryStatus := 4;
  end;
  if (r < 8) and (PPunches) and (PDag) then begin
    t := t + ' - Pulled Punches result is now Stunned';
    InjuryStatus := 4;
  end;
  if PDag then t := t +
    ' - Poison wiped off, stats change player to Normal Dagger';
  InjuryRollToText := t;
end;

function ArmourRollToText(s: string): string;
var r, av, armod: integer;
    t: string;
    Pdag, Cskin, PileOn: boolean;
begin
  {Ronald: next line added for backward compatibility}
  if not((s[2] = 'P') or (s[2] = ' ')) then
     s := s[1] + '   ' + Copy(s, 2, Length(s) - 1);
  if not((s[4] = 'O') or (s[4] = ' ')) then
     s := s[1] + s[2] + s[3] + ' ' + Copy(s, 4, Length(s) - 3);
  if s[2] = 'P' then PDag := true else PDag := false;
  if s[3] = 'C' then Cskin := true else Cskin := false;
  if s[4] = 'O' then PileOn := true else PileOn := false;
  av := Ord(s[1]) - 48;
  armod := Ord(s[5]) - 48;
  t := 'Armour Roll (AV ' + IntToStr(av) + ') ';
  r := FVal(s[6]) + FVal(s[7]) + armod;
  t := t + '(' + s[6] + ',' + s[7] + ')';
  if (armod > 0) then t := t + '+' + IntToStr(armod);
  if (armod < 0) then t := t + IntToStr(armod);
  t := t + '=' + IntToStr(r);
  if PileOn then t := t + ' Piling On used; ';
  if r <= av then begin
    if PDag then t := t + ' Poisoned Dagger failed'
                      else t := t + ' Prone';
  end else begin
    if CSkin then
      t := t + ' ' + InjuryRollToText(Copy(s, 8, length(s))) +
           '- Crystal Skin=Re-roll Armour/Choose worst injury if success'
    else t := t + ' ' + InjuryRollToText(Copy(s, 8, length(s)));
  end;
  ArmourRollToText := t;
end;

function FoulRollToText(s: string): string;
var r, av, armod, frno: integer;
    t: string;
begin
  {BugString := s;}
  {Ronald: next line added for backward compatibility}
  if not((s[2] = 'C') or (s[2] = ' ')) then
           s := s[1] + ' ' + Copy(s, 2, Length(s) - 1);

  av := Ord(s[1]) - 48;
  armod := Ord(s[3]) - 48;
  t := 'Foul Roll (AV ' + IntToStr(av) + ') ';
  r := FVal(s[4]) + FVal(s[5]) + armod;
  t := t + '(' + s[4] + ',' + s[5] + ')';
  if armod > 0 then t := t + '+' + IntToStr(armod);
  if armod < 0 then t := t + IntToStr(armod);
  t := t + '=' + IntToStr(r);
  if r > av then
    t := t + ' Foul successful. '
  else
    t := t + ' Foul failed. ';


    frno := 0;
    if s.IndexOf('S') > 0 then
      t := t + 'The referee has spotted the foul! Fouler Sent Off';

    // add injury roll text if appropriate ?
    if r <= av then
      t := t + ' '
    else
      t := t + ' ' + InjuryRollToText(Copy(s, 6, length(s)));

  Result := t;
end;

function InjuryRoll(injmod: integer): string;
var s, PD, TS, PP, IM: string;
    r, r1, r2, sr, sr2, SIdie1, SIdie2, SIdie3, SIdie4, NoDdie, Proll,
      CAS, CAS2, ploc, qloc: integer;
    PDag, TSkull, IMan, PPunches: boolean;
begin
  r1 := Rnd(6,5) + 1;
  r2 := Rnd(6,4) + 1;
  Cas := 0;
  CAS2 := 0;
  SIdie1 := 0;
  SIdie2 := 0;
  if r1 + r2 + injmod >= 10 then begin
    begin
      sr := Rnd(6,3) + 1;
      sr2 := Rnd(6,3) + 1;
    end;

    s := Chr(sr + 48);
    Cas := sr;
    CAS2 := sr2;
    if (sr = 4) or (sr = 5) then begin

      SIdie1 := Rnd(6,3);
      if SIdie1 > 5 then SIdie1 := 5;
      SIdie2 := Rnd(6,3);
      s := s + Chr(SIdie1 + 49) + Chr(SIdie2 + 49);
    end else begin
      s := s + '.' + '.';
    end;
    if (sr2 = 4) or (sr2 = 5) then begin
      SIdie3 := Rnd(6,3) ;
      if SIdie3 > 5 then SIdie3 := 5;
      SIdie4 := Rnd(6,3);
      s := s + Chr(sr2 + 48) + Chr(SIdie3 + 49) + Chr(SIdie4 + 49);
    end else begin
      s := s + Chr(sr2 + 48) + '.' + '.';
    end;
    if Decay then s := s + 'D' else s := s + '.';
  end else if (r1 + r2 + injmod >= 8) and ThickSkull then begin
    sr := Rnd(6,3) + 1;
    s := Chr(sr + 48);
    if (ProSkill) and (sr<4) then begin
      Proll := Rnd(6,1) + 1;
      if Proll > 3 then begin
        sr := Rnd(6,2) + 1;
      end;
      if sr = 1 then s := 'A' else
      if sr = 2 then s := 'B' else
      if sr = 3 then s := 'C' else
      if sr = 4 then s := 'D' else
      if sr = 5 then s := 'E' else s := 'F';
    end;
  end;
  if IronMan then IM := 'I' else IM := ' ';
  PP := ' ';
  PD := ' ';
  if ThickSkull then TS := 'T' else TS := ' ';
  InjuryRoll := PD + TS + IM + PP +
       Chr(injmod + 48) + Chr(r1 + 48) + Chr(r2 + 48) + s;
  if AVBreak then begin
    if activeTeam = 0 then begin
      KOInjTOTRed := KOInjTOTRed + 1;
    end else if activeTeam = 1 then begin
      KOInjTOTBlue := KOInjTOTBlue + 1;
    end;
    if (r1 + r2 + injmod >= 8) then begin
      if ((ThickSkull) and (sr<=3)) or (not(ThickSkull)) then begin
        if activeTeam = 0 then begin
          KOInjRed := KOInjRed + 1;
        end else if activeTeam = 1 then begin
          KOInjBlue := KOInjBlue + 1;
        end;
      end
    end;
  end;
  if (DownTeam<> -1) and (DownPlayer<> -1) then begin
    if PD = 'P' then PDag := true else PDag := false;
    if TS = 'T' then Tskull := true else Tskull := false;
    if IM = 'I' then Iman := true else Iman := false;
    if PP = 'U' then PPunches := true else PPunches := false;
    r := r1 + r2 + injmod;
    if r < 8 then begin
      InjuryStatus := 4;
      if PDag then begin
        InjuryStatus := 5;
      end;
      if (PDag) and (TSkull) and (not (ProSkill)) and
          (not (IMan)) then begin
          InjuryStatus := 4;
        end;
      if (PDag) and (TSkull) and (ProSkill) and
        (not (IMan)) then begin
          InjuryStatus := 4;
        end;
      if (PDag) and (IMan) then begin
        InjuryStatus := 4;
      end;
    end else if r < 10 then begin
      if TSkull then begin
        if sr > 3 then begin
          InjuryStatus := 4;
        end else InjuryStatus := 5;
      end else begin
        InjuryStatus := 5;
      end;
    end else begin
        r2 := Cas;
        if r2 < 4 then begin
          InjuryStatus := 6;
        end else
        if r2 < 6 then begin
          case (SIdie1+1) of
           1: begin
                  InjuryStatus := 70;
                end;
           2: begin
                  InjuryStatus := 70;
                end;
           3: begin
                  InjuryStatus := 70;
                end;
           4: begin
                  begin
                    InjuryStatus := 70;
                  end;
                end;
           5: begin
                  InjuryStatus := 71;
                end;
           6: begin
                  case (SIdie2+1) of
                   1: begin
                          InjuryStatus := 72;
                        end;
                   2: begin
                          InjuryStatus := 72;
                        end;
                   3: begin
                          InjuryStatus := 73;
                        end;
                   4: begin
                          InjuryStatus := 74;
                        end;
                   5: begin
                          InjuryStatus := 75;
                        end;
                   6: begin
                          InjuryStatus := 75;
                        end;
                  end;
                end;
          end;
        end else begin
          InjuryStatus := 8;
        end;
        if (Decay) then begin
          if (CAS2 > 3) and (CAS2 < 6) and (CAS < 4) then begin
            case (SIdie3+1) of
             1: begin
                    InjuryStatus := 70;
                  end;
             2: begin
                    InjuryStatus := 70;
                  end;
             3: begin
                    InjuryStatus := 70;
                  end;
             4: begin
                    begin
                      InjuryStatus := 70;
                    end;
                  end;
             5: begin
                    InjuryStatus := 71;
                  end;
             6: begin
                    case (SIdie4+1) of
                     1: begin
                            InjuryStatus := 72;
                          end;
                     2: begin
                            InjuryStatus := 72;
                          end;
                     3: begin
                            InjuryStatus := 73;
                          end;
                     4: begin
                            InjuryStatus := 74;
                        end;
                     5: begin
                            InjuryStatus := 75;
                          end;
                     6: begin
                            InjuryStatus := 75;
                          end;
                    end;
                  end;
            end;
          end;
          if (CAS2 > 3) and (CAS2 < 6) and (CAS > 3) and (CAS < 6) then begin
            case (SIdie3+1) of
             1: begin
                    InjuryStatus := InjuryStatus;
                  end;
             2: begin
                    InjuryStatus := InjuryStatus;
                  end;
             3: begin
                    InjuryStatus := InjuryStatus;
                  end;
             4: begin
                    begin
                      InjuryStatus := InjuryStatus;
                    end;
                  end;
             5: begin
                  if InjuryStatus = 71 then InjuryStatus := 80;
                  if InjuryStatus = 70 then InjuryStatus := 71;
                  if InjuryStatus = 72 then InjuryStatus := 81;
                  if InjuryStatus = 73 then InjuryStatus := 82;
                  if InjuryStatus = 74 then InjuryStatus := 83;
                  if InjuryStatus = 75 then InjuryStatus := 84;
                  end;
             6: begin
                    case (SIdie4+1) of
                     1: begin
                            if InjuryStatus = 71 then InjuryStatus := 81;
                            if InjuryStatus = 72 then InjuryStatus := 87;
                            if InjuryStatus = 70 then InjuryStatus := 72;
                            if InjuryStatus = 73 then InjuryStatus := 85;
                            if InjuryStatus = 74 then InjuryStatus := 86;
                            if InjuryStatus = 75 then InjuryStatus := 88;
                          end;
                     2: begin
                            if InjuryStatus = 71 then InjuryStatus := 81;
                            if InjuryStatus = 72 then InjuryStatus := 87;
                            if InjuryStatus = 70 then InjuryStatus := 72;
                            if InjuryStatus = 73 then InjuryStatus := 85;
                            if InjuryStatus = 74 then InjuryStatus := 86;
                            if InjuryStatus = 75 then InjuryStatus := 88;
                          end;
                     3: begin
                            if InjuryStatus = 71 then InjuryStatus := 82;
                            if InjuryStatus = 72 then InjuryStatus := 85;
                            if InjuryStatus = 73 then InjuryStatus := 89;
                            if InjuryStatus = 70 then InjuryStatus := 73;
                            if InjuryStatus = 74 then InjuryStatus := 90;
                            if InjuryStatus = 75 then InjuryStatus := 91;
                          end;
                     4: begin
                            if InjuryStatus = 71 then InjuryStatus := 83;
                            if InjuryStatus = 72 then InjuryStatus := 86;
                            if InjuryStatus = 73 then InjuryStatus := 90;
                            if InjuryStatus = 74 then InjuryStatus := 92;
                            if InjuryStatus = 70 then InjuryStatus := 74;
                            if InjuryStatus = 75 then InjuryStatus := 93;
                        end;
                     5: begin
                            if InjuryStatus = 71 then InjuryStatus := 84;
                            if InjuryStatus = 72 then InjuryStatus := 88;
                            if InjuryStatus = 73 then InjuryStatus := 91;
                            if InjuryStatus = 74 then InjuryStatus := 93;
                            if InjuryStatus = 75 then InjuryStatus := 94;
                            if InjuryStatus = 70 then InjuryStatus := 75;
                          end;
                     6: begin
                            if InjuryStatus = 71 then InjuryStatus := 84;
                            if InjuryStatus = 72 then InjuryStatus := 88;
                            if InjuryStatus = 73 then InjuryStatus := 91;
                            if InjuryStatus = 74 then InjuryStatus := 93;
                            if InjuryStatus = 75 then InjuryStatus := 94;
                            if InjuryStatus = 70 then InjuryStatus := 75;
                          end;
                    end;
                  end;
            end;
          end;
          if (CAS2 > 5) then InjuryStatus := 8;
        end;
      end;
    if (r >= 8) and (Iman) then begin
       InjuryStatus := 4;
    end;
    if (r >= 8) and (PPunches) then begin
      InjuryStatus := 4;
    end;
    if (r < 8) and (Iman) and (PDag)  then begin
      InjuryStatus := 4;
    end;
    if (r < 8) and (PPunches) and (PDag) then begin
      InjuryStatus := 4;
    end;
    if allPlayers[DownTeam,DownPlayer].status=2 then begin
      ploc := allPlayers[DownTeam,DownPlayer].p;
      qloc := allPlayers[DownTeam,DownPlayer].q;
      allPlayers[DownTeam,DownPlayer].SetStatus(InjuryStatus);
      ScatterBallFrom(ploc, qloc, 1, 0);
    end else allPlayers[DownTeam,DownPlayer].SetStatus(InjuryStatus);
    if (GetCas) and (InjuryStatus>=6) then begin
      if CanWriteToLog then begin
        allPlayers[BashTeam, BashPlayer].cas := allPlayers[BashTeam, BashPlayer].cas + 1;
        LogWrite('p' + Chr(BashTeam + 48) + chr(BashPlayer + 65) + 'C');
        AddLog('Casualty for ' + allPlayers[BashTeam, BashPlayer].GetPlayerName);
        {increase casscore marker}
        marker[BashTeam, MT_CasScore].MarkerMouseUp(
                  marker[BashTeam, MT_CasScore], mbLeft, [], 0, 0);
      end;
    end;
    InjuryStatus := 0;
    GetCas := false;
    DownTeam := -1;
    DownPlayer := -1;
    BashTeam := -1;
    BashPlayer := -1;
  end;
end;

function ArmourRoll(av, armod, injmod: integer): string;
var s, PD, CS, PO, t: string;
    r1, r2, am, im, r, ploc, qloc: integer;
    InjuryFlag: boolean;
begin
  InjuryFlag := false;
  if AVBreak then begin
    if activeTeam = 0 then begin
      AVBreakTOTRed := AVBreakTOTRed + 1;
    end else if activeTeam = 1 then begin
      AVBreakTOTBlue := AVBreakTOTBlue + 1;
    end;
  end;
  {Test for 4th edition Mighty Blow}
  if (injmod < 0) and (injmod >= -6) then am := armod - 1 else
    if PilingOn=1 then am := 0 else am := armod;
  r1 := Rnd(6,3) + 1;
  r2 := Rnd(6,5) + 1;
  PO := ' ';
  if r1 + r2 + am > av then begin
    im := abs(injmod);
    if im = 9 then im := 1;
    if im = 8 then im := 0;
    if im = 7 then im := -1;
    s := InjuryRoll(im);
    InjuryFlag := true;
    if AVBreak then begin
      if activeTeam = 0 then begin
        AVBreakRed := AVBreakRed + 1;
      end else if activeTeam = 1 then begin
        AVBreakBlue := AVBreakBlue + 1;
      end;
    end;
  end else begin
    am := armod;
    if (r1 + r2 + am <= av) and (PilingOn=2) then begin
      PO := 'O';
      t := 'Armour Roll (AV ' + IntToStr(av) + ') ';
      r := r1 + r2 + armod;
      t := t + '(' + InttoStr(r1) + ',' + InttoStr(r2) + ')';
      if (armod > 0) then t := t + '+' + IntToStr(armod);
      if (armod < 0) then t := t + IntToStr(armod);
      t := t + '=' + IntToStr(r) +
        '; AV not broken - AV mod skills saved for later - now using Piling On';
      Bloodbowl.comment.text := t;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      r1 := Rnd(6,3) + 1;
      r2 := Rnd(6,5) + 1;
      if (HitTeam <> -1) and (HitPlayer <> -1) then begin
        if allPlayers[HitTeam,HitPlayer].status=2 then begin
          allPlayers[HitTeam,HitPlayer].SetStatus(3);
          ScatterBallFrom((allPlayers[HitTeam,HitPlayer].p),
            (allPlayers[HitTeam,HitPlayer].q), 1, 0);
        end else allPlayers[HitTeam,HitPlayer].SetStatus(3);
      end;
    end;
    if (r1 + r2 + am > av) then begin
      if PilingOn<=0 then im := abs(injmod) - 1 else im := abs(injmod);
      if (PilingOn=2) and (r1 + r2 > av) and (MBPO) and (am=1) then begin
        im := abs(injmod);
        am := 0;
      end else if (PilingOn=2) and (r1 + r2 + 1 > av) and (MBPO) and (am=1) then begin
        im := abs(injmod) - 1;
        am := 1;
      end;
      if (PilingOn=1) and (r1 + r2 + 1 > av) and (MBPO)
      then begin
        im := abs(injmod) - 1;
        am := 1;
      end else if PilingOn=1 then PO := 'O';
      s := InjuryRoll(im);
      InjuryFlag := true;
      if AVBreak then begin
        if activeTeam = 0 then begin
          AVBreakRed := AVBreakRed + 1;
        end else if activeTeam = 1 then begin
          AVBreakBlue := AVBreakBlue + 1;
        end;
      end;
    end else begin
      s := '';
      if PilingOn=1 then am := 0;
    end;
  end;
  if PilingOn=0 then PO := 'O';
  PD := ' ';
  if CrystalSkin then CS := 'C' else CS := ' ';
  ArmourRoll := PD + CS + PO + Chr(am + 48) + Chr(r1 + 48) + Chr(r2 + 48) + s;
  if not(InjuryFlag) and (DownTeam<> -1) and (DownPlayer<> -1) then begin
    if allPlayers[DownTeam,DownPlayer].status=2 then begin
      ploc := allPlayers[DownTeam,DownPlayer].p;
      qloc := allPlayers[DownTeam,DownPlayer].q;
      allPlayers[DownTeam,DownPlayer].SetStatus(3);
      ScatterBallFrom(ploc, qloc, 1, 0);
    end else allPlayers[DownTeam,DownPlayer].SetStatus(3);
    DownTeam := -1;
    DownPlayer := -1;
    BashTeam := -1;
    BashPlayer := -1;
  end;
  AVBreak := false;
end;

function FoulRoll(av, armod, injmod: integer; eye: boolean): string;
var s: string;
    r1, r2, am, im, ploc, qloc: integer;
begin
  // how is AVBreak set?
  if AVBreak then begin
    if activeTeam = 0 then begin
      AVBreakTOTRed := AVBreakTOTRed + 1;
    end else if activeTeam = 1 then begin
      AVBreakTOTBlue := AVBreakTOTBlue + 1;
    end;
  end;

  // dice rolls
  r1 := Rnd(6,5) + 1;
  r2 := Rnd(6,2) + 1;

  s := '';

  am := armod;
  if (r1 + r2 + am > av) then
  begin
    im := abs(injmod) - 1;
    s := InjuryRoll(im);
    if AVBreak then begin
      if activeTeam = 0 then begin
        AVBreakRed := AVBreakRed + 1;
      end else if activeTeam = 1 then begin
        AVBreakBlue := AVBreakBlue + 1;
      end;
    end;
  end
  else
    s := '';

  if(r1 = r2) then
    s := s + 'S';

  if (HitPlayer<> -1) and (HitTeam<> -1) then begin
    if allPlayers[HitTeam,HitPlayer].status = STATUS_BALL_CARRIER then
    begin
      ploc := allPlayers[HitTeam,HitPlayer].p;
      qloc := allPlayers[HitTeam,HitPlayer].q;
      allPlayers[HitTeam,HitPlayer].SOstatus := allPlayers[HitTeam,HitPlayer].status;
      allPlayers[HitTeam,HitPlayer].SOSIstatus := allPlayers[HitTeam,HitPlayer].SIstatus;
      allPlayers[HitTeam,HitPlayer].SetStatus(12);
      ScatterBallFrom(ploc, qloc, 1, 0);
    end
    else
    begin
      allPlayers[HitTeam,HitPlayer].SOstatus := allPlayers[HitTeam,HitPlayer].status;
      allPlayers[HitTeam,HitPlayer].SOSIstatus := allPlayers[HitTeam,HitPlayer].SIstatus;
      allPlayers[HitTeam,HitPlayer].SetStatus(12);
    end;
    HitTeam := -1;
    HitPlayer := -1;
  end;

  AVBreak := false;
  Result := ' ' + Chr(am + 48) + Chr(r1 + 48) + Chr(r2 + 48) + s;
end;

function TranslateHandicap: string;
var s, t: string;
    bm, bc, m: integer;
begin
  if team[0].bonusCards + team[0].bonusMVP > 0 then m := 0 else
   if team[1].bonusCards + team[1].bonusMVP > 0 then m := 1 else m := 2;
  bm := team[0].bonusMVP + team[1].bonusMVP;
  bc := team[0].bonuscards + team[1].bonuscards;
  if bc > 0 then s := IntToStr(bc) + ' bonus card';
  if bc > 1 then s := s + 's';
  if Trim(frmSettings.txtHandicapTable.text) = 'H5' then begin
    if bm > 0 then s := Trim(s + '   ' + IntToStr(bm) + '0k bonus Gold');
  end else begin
    if bm > 0 then s := Trim(s + '   ' + IntToStr(bm) + ' bonus MVP');
    if bm > 1 then s := s + 's';
  end;
  if bc + bm = 0 then s := 'No handicap';
  Bloodbowl.LblHandicap.caption := s;
  if m < 2 then Bloodbowl.LblHandicap.font.color := colorarray[m,0,0] else
    Bloodbowl.LblHandicap.font.color := clPurple;
  t := 'Handicaps: TR ' + IntToStr(team[0].tr) + ' vs TR ' +
       IntToStr(team[1].tr) + ' = ';
  if bc + bm = 0 then s := t + s else s := t + ffcl[m] + ' gets ' + s;
  TranslateHandicap := s;
end;

function TranslateNiggle(nr: string): string;
var f, g, r: integer;
    s: string;
begin
  g := Ord(nr[3]) - 48;
  f := Ord(nr[4]) - 64;
  r := Ord(nr[5]) - 48;
  s := 'Roll for Niggling Injury for ' +
                                allPlayers[g,f].GetPlayerName + ': ' + IntToStr(r);
  TranslateNiggle := s;
end;

function TranslateNiggleResult(nr: string): string;
var f, g, r: integer;
    s: string;
begin
  NumNiggles := NumNiggles + 1;
  if (NumNiggles > 3) and (NumNiggles mod 3 = 1) then begin
    Bloodbowl.LblNiggles.height := Bloodbowl.LblNiggles.height + 15;
    Bloodbowl.LblNiggles.top := Bloodbowl.LblNiggles.top - 7;
  end;
  g := Ord(nr[3]) - 48;
  f := Ord(nr[4]) - 64;
  r := Ord(nr[5]) - 48;
  s := allPlayers[g,f].GetPlayerName;
  if (r = 0) or (r = 9) then s := s + ' can play normally.'
           else s := s + ' must miss the match!';
  if (r = 0) or (r = 9) then
     Bloodbowl.LblNiggles.caption := Bloodbowl.LblNiggles.caption +
                             ffc[g] + IntToStr(f) + ' plays. '
  else
     Bloodbowl.LblNiggles.caption := Bloodbowl.LblNiggles.caption +
                             ffc[g] + IntToStr(f) + ' is OUT! ';
  TranslateNiggleResult := s;
end;

function CountTZ(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (allPlayers[1-g0,f].status = 1)
    or (allPlayers[1-g0,f].status = 2) then
       begin
      if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
      and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
      and (allPlayers[1-g0,f].tz = 0) then begin
        tz.num := tz.num + 1;
        tz.pl[tz.num] := f;
      end;
    end;
  end;
  CountTZ := tz;
end;

function CountOpponents(g0, f0: integer): integer;
var f, z: integer;
begin
  z := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (allPlayers[1-g0,f].status = 1)
    or (allPlayers[1-g0,f].status = 2) then begin
      if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
      and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
      then begin
        z := z + 1;
      end;
    end;
  end;
  CountOpponents := z;
end;

function CountTZSlow(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[g0].numplayers do begin
    if (allPlayers[g0,f].status = 1) or (allPlayers[g0,f].status = 2) then begin
      if (abs(allPlayers[g0,f].p - allPlayers[g0,f0].p) <= 1)
      and (abs(allPlayers[g0,f].q - allPlayers[g0,f0].q) <= 1)
      and (allPlayers[g0,f].tz = 0) then begin
        tz.num := tz.num + 1;
        tz.pl[tz.num] := f;
      end;
    end;
  end;
  CountTZSlow := tz;
end;

function CountTZEmpty(g0, p, q: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (allPlayers[1-g0,f].status = 1)
    or (allPlayers[1-g0,f].status = 2)
    or ((allPlayers[1-g0,f].status = 3) and
       (allPlayers[1-g0,f].hasSkill('Trip Up'))) then begin
      if (abs(allPlayers[1-g0,f].p - p) <= 1)
      and (abs(allPlayers[1-g0,f].q - q) <= 1)
      and (allPlayers[1-g0,f].tz = 0) then begin
        tz.num := tz.num + 1;
        tz.pl[tz.num] := f;
      end;
    end;
  end;
  CountTZEmpty := tz;
end;

function CountTZDTS(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (((allPlayers[1-g0,f].status = 1) or (allPlayers[1-g0,f].status = 2))
      and ((allPlayers[1-g0,f].hasSkill('Shadow*')) or
           ((allPlayers[1-g0,f].hasSkill('Diving Tackle'))
                               )))then
                               begin
      if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
      and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
      and (allPlayers[1-g0,f].tz = 0) then begin
        if (allPlayers[1-g0,f].hasSkill('Diving Tackle')) and
          (allPlayers[1-g0,f].status = 1) then
          tz.num := tz.num + 10
           else tz.num := tz.num + 1;
        {tz.pl[tz.num] := f;}
      end;
    end;
  end;
  CountTZDTS := tz;
end;

function CountTZBlockCA(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (not((1-g0=BlockTeam) and (f=BlockPlayer)))
    and (not((1-g0=HitTeam) and (f=HitPlayer)))
    then begin
      if (allPlayers[1-g0,f].status = 1)
      or (allPlayers[1-g0,f].status = 2) then begin
        if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
        and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
        and (allPlayers[1-g0,f].tz = 0)
        {and ((player[1-g0,f].tz = 0)
        or ((player[1-g0,f].tz <> 0)
        and (frmSettings.cbNoTZAssist.checked)))}
        then begin
          tz.num := tz.num + 1;
          tz.pl[tz.num] := f;
        end;
      end;
    end;
  end;
  CountTZBlockCA := tz;
end;

function CountTZBlockCA2(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (not((1-g0=BlockTeam) and (f=BlockPlayer)))
    and (not((1-g0=HitTeam) and (f=HitPlayer)))
    then begin
      if (allPlayers[1-g0,f].status = 1)
      or (allPlayers[1-g0,f].status = 2) then begin
        if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
        and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
        and ((allPlayers[1-g0,f].tz = 0))
        then begin
          tz.num := tz.num + 1;
          tz.pl[tz.num] := f;
        end;
      end;
    end;
  end;
  CountTZBlockCA2 := tz;
end;

function CountTZBlockA(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if (allPlayers[1-g0,f].status = 1)
    or (allPlayers[1-g0,f].status = 2) then begin
      if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
      and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
      and (allPlayers[1-g0,f].tz = 0) then begin
        tz.num := tz.num + 1;
        tz.pl[tz.num] := f;
      end;

    end;
  end;
  CountTZBlockA := tz;
end;



function CountTZFoul(g0, f0: integer): TackleZones;
var f: integer;
    tz: TackleZones;
begin
  tz.num := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if ((allPlayers[1-g0,f].status = 1) and not
         (allPlayers[1-g0,f].hasSkill('Honorable')))
    or ((allPlayers[1-g0,f].status = 2) and not
         (allPlayers[1-g0,f].hasSkill('Honorable')))
    then begin
      if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p) <= 1)
      and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q) <= 1)
      and (allPlayers[1-g0,f].tz = 0) then begin
        tz.num := tz.num + 1;
        tz.pl[tz.num] := f;
      end;

    end;
  end;
  CountTZFoul := tz;
end;

function CountNoBhead(g0, f0: integer): integer;
var f, a: integer;
    Bhead, Rstupid, TZone: Boolean;
begin
  a := 0;
  for f := 1 to team[g0].numplayers do begin
    if f <> f0 then begin
      if ((allPlayers[g0,f].status = 1) or (allPlayers[g0,f].status = 2)) then begin
        if (abs(allPlayers[g0,f].p - allPlayers[g0,f0].p) <= 1)
        and (abs(allPlayers[g0,f].q - allPlayers[g0,f0].q) <= 1) then begin
          Bhead := False;
          Rstupid := False;
          TZone := True;
          if (allPlayers[g0,f].HasSkill('Bonehead')) or
             (allPlayers[g0,f].hasSkill('Bone-head'))
              then Bhead := True;
          if (allPlayers[g0,f].HasSkill('Really Stupid')) then
              RStupid := True;
          if (allPlayers[g0,f].tz > 0)
            then TZone := False;
          if TZone and not RStupid then
            a := a + 1;

        end;
      end;
    end;
  end;
  CountNoBhead := a;
end;

function CountPB(g0, f0, CatcherP, CatcherQ: integer; PassPB: boolean): integer;
var f, a, ThrowerP, ThrowerQ, OpponentP, OpponentQ, dp2, dq2, bigd, littled: integer;
    d, dp, dq, dist, dmod: real;
begin
  a := 0;
  for f := 1 to team[1-g0].numplayers do begin
    ThrowerP := allPlayers[g0,f0].p;
    ThrowerQ := allPlayers[g0,f0].q;
    OpponentP := allPlayers[1-g0,f].p;
    OpponentQ := allPlayers[1-g0,f].q;
    dp2 := abs(CatcherP - ThrowerP);
    dq2 := abs(CatcherQ - ThrowerQ);
    if dp2 >= dq2 then begin
      bigd := dp2;
      littled := dq2;
    end else begin
      bigd := dq2;
      littled := dp2;
    end;
    if ((allPlayers[1-g0,f].status = 1)
        and (allPlayers[1-g0,f].hasSkill('Pass Block')))
    then
    begin
      if (allPlayers[1-g0,f].tz = 0)  then
       begin
        if ((abs(OpponentP - ThrowerP)) <= 4) and
           ((abs(OpponentQ - ThrowerQ)) <= 4) then a := a + 1;
        if ((abs(OpponentP - CatcherP)) <= 4) and
           ((abs(OpponentQ - CatcherQ)) <= 4) then a := a + 1;
        if PassPB then begin
          d := ((ThrowerP - CatcherP) * (ThrowerP - OpponentP) +
                (ThrowerQ - CatcherQ) * (ThrowerQ - OpponentQ)) /
               ((ThrowerP - CatcherP) * (ThrowerP - CatcherP) +
                (ThrowerQ - CatcherQ) * (ThrowerQ - CatcherQ));
          {if d<0 or d>1 then the opponent is not between passer and catcher}
          if (d >= 0) and (d <= 1) then begin
             {(dp,dq) is point on pass-line closest to opponent}
            dp := ThrowerP + d * (CatcherP - ThrowerP);
            dq := ThrowerQ + d * (CatcherQ - ThrowerQ);
            {calculate distance from (dp,dq) to opponent}
            dist := Sqrt((OpponentP - dp) * (OpponentP - dp) +
                         (OpponentQ - dq) * (OpponentQ - dq));
            {4.95 is the distance for a perpendicular line to the line of the
             pass}
            if (littled = 0) or (bigd=0) then dmod := 4.999
              else if bigd=littled then dmod := 5.657
              else dmod := 4.999 + ((0.658/bigd)*littled);

              if dist <= dmod then a := a + 1;

          end;
        end;
      end;
    end;
  end;
  CountPB := a;
end;

function CountFA(g0, f0: integer): integer;
var f, a: integer;
begin
  a := 0;
  for f := 1 to team[1-g0].numplayers do begin
    if ((allPlayers[1-g0,f].status = 1)
        or (allPlayers[1-g0,f].status = 2)
        or (((allPlayers[1-g0,f].status=3) or (allPlayers[1-g0,f].status=4)) and
        (true)))     // foul prone
        and (allPlayers[1-g0,f].hasSkill('Foul Appearanc*')) then begin
    {TOM CHANGE:  Original code had the sum of the ABS <=3
     when it should be each condition being <= 3}
      if ((abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p)) <= 3) and
         ((abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q)) <= 3) then a := a + 1;
    end;
  end;
  CountFA := a;
end;

procedure WorkOutBlock(g, f, g0, f0: integer);
var
  TargetPlayer: unitPlayer.TPlayer;
  assa, assd, p, db, dd, st, sa, stx, std, st0, horns, dl, NiggleCount, totspp,
    t, z, squaredist: integer;
  tz, tz0: TackleZones;
  s, BlockAnswer, ReRollAnswer: string;
  b, bx, fa, bga, bnc, SPP4th, HitBlock, VicBlock, HitTackle,
    VicDodge, HitJugger, BlockCount, PowDCount, DownHeGoes, ProSkill, reroll,
    UReroll, NoDumpOff, QuickPass: boolean;
begin
  dl := 0;
  dd := 0;
  std := allPlayers[g0, f0].st;
  assa := 0;
  bga := (((allPlayers[g, f].BigGuy) or (allPlayers[g, f].Ally)) and (true));
  BlockTeam := g0;
  BlockPlayer := f0;
  HitTeam := g;
  HitPlayer := f;
  GetCas := false;
  AVBreak := false;
  NoDumpOff := true;
  TargetPlayer := allPlayers[g0, f0];
  if TargetPlayer.hasDumpOff() then
  begin
    for z := 1 to team[g0].numplayers do
    begin
      squaredist := RangeRulerRange(allPlayers[g0, z].p, allPlayers[g0, z].q,
                                    TargetPlayer.p, TargetPlayer.q);
      QuickPass := squaredist = 0;
      if (QuickPass) and (f0 <> z) then
        NoDumpOff := false;
    end;
  end;
  if not(NoDumpOff) then
  begin
    ReRollAnswer := FlexMessageBox('Player can use Dump Off!',
      'Dump Off Warning', 'Stop,Continue');
    if ReRollAnswer = 'Continue' then
      NoDumpOff := true;
  end;
  { Ball and Chain }
  if (TargetPlayer.hasSkill('Ball and Chain')) and
    not(allPlayers[g, f].hasSkill('Ball and Chain')) then
    bnc := false
  else
    bnc := true;
  { Foul Appearance }
  fa := true;
  { only need to roll for FA if not Ball & Chain }
  if (bnc) and (NoDumpOff) then
  begin
    if TargetPlayer.hasSkill('Foul Appearanc*') then
    begin
      fa := false;
      if TargetPlayer.hasSkill('Foul Appearance L*') then
      begin
        s := TargetPlayer.Get1Skill('Foul Appearance L*');
        p := FVal(Copy(s, 18, Length(s) - 17));
      end
      else
        p := 2;
      Bloodbowl.comment.text := allPlayers[g, f].GetPlayerName +
        ' has to beat Foul Appearance (' + IntToStr(p) + '+)';
      Bloodbowl.EnterButtonClick(Bloodbowl);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if lastroll >= p then
        fa := true
      else
      begin
        bga := (((allPlayers[g, f].BigGuy) or (allPlayers[g, f].Ally)) and (true));
        ProSkill := ((allPlayers[g, f].hasSkill('Pro'))) and (lastroll <= 1) and
          (not(allPlayers[g, f].usedSkill('Pro'))) and (g = activeTeam);
        reroll := CanUseTeamReroll(bga);
        ReRollAnswer := 'Fail Roll';
        if reroll and ProSkill then
        begin
          ReRollAnswer := FlexMessageBox('Foul Appearance roll has failed!',
            'Foul Appearance Failure', 'Use Pro,Team Reroll,Fail Roll');
        end
        else if ProSkill then
        begin
          ReRollAnswer := FlexMessageBox('Foul Appearance roll has failed!',
            'Foul Appearance Failure', 'Use Pro,Fail Roll');
        end
        else if reroll then
        begin
          ReRollAnswer := FlexMessageBox('Foul Appearance roll failed!',
            'Foul Appearance Failure', 'Fail Roll,Team Reroll');
        end;
        if ReRollAnswer = 'Team Reroll' then
        begin
          UReroll := UseTeamReroll;
          if UReroll then
          begin
            Bloodbowl.comment.text := 'Foul Appearance reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if ReRollAnswer = 'Use Pro' then
        begin
          allPlayers[g, f].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then
            TeamRerollPro(g, f);
          if (lastroll <= 3) then
            lastroll := 1;
          if (lastroll >= 4) then
          begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          end;
        end;
        if lastroll >= p then
          fa := true;
      end;
    end;
  end;
  if not(fa) then
  begin
    Bloodbowl.comment.text := allPlayers[g, f].GetPlayerName +
      ' is too revolted to make the block!';
    Bloodbowl.EnterButtonClick(Bloodbowl);
  end;
  if not(bnc) then
  begin
    Bloodbowl.comment.text := allPlayers[g, f].GetPlayerName +
      ' cannot block a Ball and Chain player!';
    Bloodbowl.EnterButtonClick(Bloodbowl);
  end;
  if (fa) and (bnc) and (NoDumpOff) then
  begin
    { Dauntless }
    if TargetPlayer.st > allPlayers[g, f].st then
    begin
      if (allPlayers[g, f].hasSkill('Dauntless')) then
      begin
        Bloodbowl.comment.text := allPlayers[g, f].GetPlayerName +
          ' Dauntless roll';
        Bloodbowl.EnterButtonClick(Bloodbowl);
        Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
        if lastroll > allPlayers[g0, f0].st then
          dl := 1
        else
        begin
          bga := (((allPlayers[g, f].BigGuy) or (allPlayers[g, f].Ally)) and (true));
          ProSkill := ((allPlayers[g, f].hasSkill('Pro'))) and (lastroll <= 1) and
            (not(allPlayers[g, f].usedSkill('Pro'))) and (g = activeTeam);
          reroll := CanUseTeamReroll(bga);
          ReRollAnswer := 'Fail Roll';
          if reroll and ProSkill then
          begin
            ReRollAnswer := FlexMessageBox('Dauntless roll has failed!',
              'Dauntless Failure', 'Use Pro,Team Reroll,Fail Roll');
          end
          else if ProSkill then
          begin
            ReRollAnswer := FlexMessageBox('Dauntless roll has failed!',
              'Dauntless Failure', 'Use Pro,Fail Roll');
          end
          else if reroll then
          begin
            ReRollAnswer := FlexMessageBox('Dauntless roll failed!',
              'Dauntless Failure', 'Fail Roll,Team Reroll');
          end;
          if ReRollAnswer = 'Team Reroll' then
          begin
            UReroll := UseTeamReroll;
            if UReroll then
            begin
              Bloodbowl.comment.text := 'Dauntless reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
            end;
          end;
          if ReRollAnswer = 'Use Pro' then
          begin
            allPlayers[g, f].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then
              TeamRerollPro(g, f);
            if (lastroll <= 3) then
              lastroll := 1;
            if (lastroll >= 4) then
            begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
            end;
          end;
          if lastroll > allPlayers[g0, f0].st then
            dl := 1
          else
            dl := 0;
        end;
      end;
    end;
  end;

  if (fa) and (bnc) and (NoDumpOff) and (dl < 2) then
  begin
    sa := 0;
    horns := 0;
    s := '#' + IntToStr(allPlayers[g, f].cnumber) + ' (ST ';
    if dl = 1 then
    begin
      s := s + '*' + IntToStr(TargetPlayer.st) + '*';
      stx := TargetPlayer.st;
    end
    else if (allPlayers[g, f].hasSkill('Ball and Chain')) then
    begin
      s := s + '*' + IntToStr(6) + '*';
      stx := 6;
    end
    else
    begin
      s := s + IntToStr(allPlayers[g, f].st);
      stx := allPlayers[g, f].st;
    end;
    if allPlayers[g, f].font.size = 12 then
      s := s + ') b '
    else
    begin
      if (allPlayers[g, f].FirstBlock = 1) and
        ((allPlayers[g, f].LastAction = 1) or (allPlayers[g, f].LastAction = 2)) then
      begin // horns 2nd
        if allPlayers[g, f].hasSkill('Horns') then
        begin
          s := s + ',horns';
          horns := 1;
        end;
        if allPlayers[g, f].hasSkill('Horn') then
        begin
          s := s + ',horn';
          horns := 1;
        end;
      end;
      s := s + ') blitz ';
    end;
    if dd = 1 then
    begin
      s := s + '#' + IntToStr(TargetPlayer.cnumber) + ' (ST ' + '*' +
        IntToStr(allPlayers[g, f].st) + '*)';
    end
    else
    begin
      s := s + '#' + IntToStr(TargetPlayer.cnumber) + ' (ST ' +
        IntToStr(TargetPlayer.st) + ')';
    end;
    assa := horns + sa;
    { count assists }
    if (not((allPlayers[g, f].hasSkill('Ball and Chain')))) then
    begin
      tz := CountTZBlockA(g0, f0);
      bx := false;
      for p := 1 to tz.num do
      begin
        if tz.pl[p] <> f then
        begin
          if allPlayers[g, tz.pl[p]].hasSkill('Guard') then
            b := true
          else
          begin
            tz0 := CountTZBlockCA(g, tz.pl[p]);
            b := (tz0.num = 0);
            { b := ((tz0.num = 1) and (player[g0,f0].tz = 0))
              or ((tz0.num = 0) and (player[g0,f0].tz <> 0)) or
              ((tz0.num = 1) and (frmSettings.cbNoTZAssist.checked)); }
          end;
          if b then
          begin
            assa := assa + 1;
            if not(bx) then
            begin
              s := s + ' a ';
              bx := true;
            end
            else
              s := s + ',';
            s := s + IntToStr(allPlayers[g, tz.pl[p]].cnumber);
          end;
        end;
      end;
    end;
    assd := 0;
    { count counterassists }
    if (not((allPlayers[g, f].hasSkill('Ball and Chain')))) then
    begin
      tz := CountTZBlockCA2(g, f);
      bx := false;
      for p := 1 to tz.num do
      begin
        if tz.pl[p] <> f0 then
        begin
          if allPlayers[g0, tz.pl[p]].hasSkill('Guard') then
            b := true
          else
          begin
            tz0 := CountTZBlockCA(g0, tz.pl[p]);
            b := (tz0.num = 0);
            { b := ((tz0.num = 1) and (player[g,f].tz = 0))
              or ((tz0.num = 0) and (player[g,f].tz <> 0)); }
          end;
          if b then
          begin
            assd := assd + 1;
            if not(bx) then
            begin
              s := s + ' ca ';
              bx := true;
            end
            else
              s := s + ',';
            s := s + IntToStr(allPlayers[g0, tz.pl[p]].cnumber);
          end;
        end;
      end;
    end;
    if (stx + assa < 1) and (allPlayers[g, f].st > 0) then
    begin
      assa := 0;
    end;
    if stx + assa > 2 * (std + assd) then
    begin
      s := s + ' (3 block dice)';
      db := 3;
    end
    else if stx + assa > std + assd then
    begin
      s := s + ' (2 block dice)';
      db := 2;
    end
    else if stx + assa = std + assd then
    begin
      s := s + ' (1 block die)';
      db := 1;
    end
    else if 2 * (stx + assa) < std + assd then
    begin
      s := s + ' (3 block dice DEFENDER''S CHOICE)';
      db := -3;
    end
    else
    begin
      s := s + ' (2 block dice DEFENDER''S CHOICE)';
      db := -2;
    end;
    // log action type
    Bloodbowl.comment.text := s;
    Bloodbowl.EnterButtonClick(Bloodbowl);
    lastroll := 0;
    lastroll2 := 0;
    lastroll3 := 0;
    if db = 1 then
      Bloodbowl.OneDBButtonClick(Bloodbowl);
    if abs(db) = 2 then
      Bloodbowl.TwoDBButtonClick(Bloodbowl);
    if abs(db) = 3 then
      Bloodbowl.ThreeDBButtonClick(Bloodbowl);
    HitBlock := allPlayers[g, f].hasSkill('Block');
    VicBlock := TargetPlayer.hasSkill('Block');
    HitTackle := allPlayers[g, f].hasSkill('Tackle');
    VicDodge := TargetPlayer.hasSkill('Dodge');
    HitJugger := (allPlayers[g, f].hasSkill('Juggernaut')) and
      (allPlayers[g, f].FirstBlock = 1) and (allPlayers[g, f].LastAction = 1);
    BlockCount := ((HitBlock) and not(VicBlock)) or (HitJugger);
    PowDCount := (not(VicDodge)) or (HitTackle);
    DownHeGoes := false;
    if lastroll2 = 0 then
    begin
      if (lastroll = 6) or ((lastroll = 5) and (PowDCount)) or
        ((lastroll = 2) and (BlockCount)) then
        DownHeGoes := true;
    end
    else if (lastroll3 = 0) and (db = 2) then
    begin
      if (lastroll = 6) or (lastroll2 = 6) then
        DownHeGoes := true
      else if ((lastroll = 5) or (lastroll2 = 5)) and (PowDCount) then
        DownHeGoes := true
      else if ((lastroll = 2) or (lastroll2 = 2)) and (BlockCount) then
        DownHeGoes := true;
    end
    else if (lastroll3 <> 0) and (db = 3) then
    begin
      if (lastroll = 6) or (lastroll2 = 6) or (lastroll3 = 6) then
        DownHeGoes := true
      else if ((lastroll = 5) or (lastroll2 = 5) or (lastroll3 = 5)) and
        (PowDCount) then
        DownHeGoes := true
      else if ((lastroll = 2) or (lastroll2 = 2) or (lastroll3 = 2)) and
        (BlockCount) then
        DownHeGoes := true;
    end
    else if (lastroll3 = 0) and (db = -2) then
    begin
      if (lastroll = 6) and (lastroll2 = 6) then
        DownHeGoes := true
      else if (lastroll = 6) and (lastroll2 = 5) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 5) and (lastroll2 = 6) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 5) and (lastroll2 = 5) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 6) and (lastroll2 = 2) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 2) and (lastroll2 = 6) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 2) and (lastroll2 = 2) and (BlockCount) then
        DownHeGoes := true
      else if (lastroll = 2) and (lastroll2 = 5) and (BlockCount) and (PowDCount)
      then
        DownHeGoes := true
      else if (lastroll = 5) and (lastroll2 = 2) and (BlockCount) and (PowDCount)
      then
        DownHeGoes := true;
    end
    else if (lastroll3 <> 0) and (db = -3) then
    begin
      DownHeGoes := true;
      if (lastroll = 1) or (lastroll2 = 1) or (lastroll3 = 1) then
        DownHeGoes := false
      else if ((lastroll = 2) or (lastroll2 = 2) or (lastroll3 = 2)) and
        not(BlockCount) then
        DownHeGoes := false
      else if (lastroll = 3) or (lastroll = 4) or (lastroll2 = 3) or
        (lastroll2 = 4) or (lastroll3 = 3) or (lastroll3 = 4) then
        DownHeGoes := false
      else if ((lastroll = 5) or (lastroll2 = 5) or (lastroll3 = 5)) and
        not(PowDCount) then
        DownHeGoes := false;
    end;
    if not(DownHeGoes) then
    begin
      if CanUseTeamReroll(bga) or ((allPlayers[g, f].hasSkill('Pro')) and
        not(allPlayers[g, f].usedSkill('Pro'))) then
      begin
        BlockAnswer := 'No';
        if (allPlayers[g, f].hasSkill('Pro')) and not(allPlayers[g, f].usedSkill('Pro'))
          and (CanUseTeamReroll(bga)) then
          BlockAnswer := FlexMessageBox
            ('Block fails to knock down and/or knocked down ' +
            'your player! Use Team Reroll or Pro?', 'Knock Down Failure',
            'No,Team Reroll,Pro')
        else if (allPlayers[g, f].hasSkill('Pro')) and
          not(allPlayers[g, f].usedSkill('Pro')) then
          BlockAnswer := FlexMessageBox
            ('Block fails to knock down and/or knocked down ' +
            'your player! Use Pro?', 'Knock Down Failure', 'No,Pro')
        else
          BlockAnswer := FlexMessageBox
            ('Block fails to knock down and/or knocked down ' +
            'your player! Use Team Reroll?', 'Knock Down Failure',
            'No,Team Reroll');
        if BlockAnswer = 'Team Reroll' then
        begin
          UReroll := UseTeamReroll;
          if UReroll then
          begin
            if (lastroll3 = 0) and (lastroll2 = 0) then
              Bloodbowl.OneDBButtonClick(Bloodbowl)
            else if (lastroll3 = 0) then
              Bloodbowl.TwoDBButtonClick(Bloodbowl)
            else
              Bloodbowl.ThreeDBButtonClick(Bloodbowl);
          end;
        end
        else if BlockAnswer = 'Pro' then
        begin
          allPlayers[g, f].UseSkill('Pro');
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= 3 then
            TeamRerollPro(g, f);
          if (lastroll >= 4) then
          begin
            Bloodbowl.comment.text := 'Pro reroll';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            if (lastroll3 = 0) and (lastroll2 = 0) then
              Bloodbowl.OneDBButtonClick(Bloodbowl)
            else if (lastroll3 = 0) then
              Bloodbowl.TwoDBButtonClick(Bloodbowl)
            else
              Bloodbowl.ThreeDBButtonClick(Bloodbowl);
          end;
        end;
      end;
    end;
    if lastroll2 = 0 then
    begin
      if (lastroll = 6) or ((lastroll = 5) and (PowDCount)) or
        ((lastroll = 2) and (BlockCount)) then
        DownHeGoes := true;
    end
    else if (lastroll3 = 0) and (db = 2) then
    begin
      if (lastroll = 6) or (lastroll2 = 6) then
        DownHeGoes := true
      else if ((lastroll = 5) or (lastroll2 = 5)) and (PowDCount) then
        DownHeGoes := true
      else if ((lastroll = 2) or (lastroll2 = 2)) and (BlockCount) then
        DownHeGoes := true;
    end
    else if (lastroll3 <> 0) and (db = 3) then
    begin
      if (lastroll = 6) or (lastroll2 = 6) or (lastroll3 = 6) then
        DownHeGoes := true
      else if ((lastroll = 5) or (lastroll2 = 5) or (lastroll3 = 5)) and
        (PowDCount) then
        DownHeGoes := true
      else if ((lastroll = 2) or (lastroll2 = 2) or (lastroll3 = 2)) and
        (BlockCount) then
        DownHeGoes := true;
    end
    else if (lastroll3 = 0) and (db = -2) then
    begin
      if (lastroll = 6) and (lastroll2 = 6) then
        DownHeGoes := true
      else if (lastroll = 6) and (lastroll2 = 5) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 5) and (lastroll2 = 6) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 5) and (lastroll2 = 5) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 6) and (lastroll2 = 2) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 2) and (lastroll2 = 6) and (PowDCount) then
        DownHeGoes := true
      else if (lastroll = 2) and (lastroll2 = 2) and (BlockCount) then
        DownHeGoes := true
      else if (lastroll = 2) and (lastroll2 = 5) and (BlockCount) and (PowDCount)
      then
        DownHeGoes := true
      else if (lastroll = 5) and (lastroll2 = 2) and (BlockCount) and (PowDCount)
      then
        DownHeGoes := true;
    end
    else if (lastroll3 <> 0) and (db = -3) then
    begin
      DownHeGoes := true;
      if (lastroll = 1) or (lastroll2 = 1) or (lastroll3 = 1) then
        DownHeGoes := false
      else if ((lastroll = 2) or (lastroll2 = 2) or (lastroll3 = 2)) and
        not(BlockCount) then
        DownHeGoes := false
      else if (lastroll = 3) or (lastroll = 4) or (lastroll2 = 3) or
        (lastroll2 = 4) or (lastroll3 = 3) or (lastroll3 = 4) then
        DownHeGoes := false
      else if ((lastroll = 5) or (lastroll2 = 5) or (lastroll3 = 5)) and
        not(PowDCount) then
        DownHeGoes := false;
    end;
    if DownHeGoes then
    begin
      if activeTeam = 0 then
      begin
        KDownRed := KDownRed + 1;
      end
      else if activeTeam = 1 then
      begin
        KDownBlue := KDownBlue + 1;
      end;
      BashTeam := g;
      BashPlayer := f;
      DownTeam := g0;
      DownPlayer := f0;
      GetCas := true;
      AVBreak := true;
    end
    else
    begin
      HitTeam := -1;
      HitPlayer := -1;
      BlockTeam := -1;
      BlockPlayer := -1;
      BashTeam := -1;
      BashPlayer := -1;
      DownTeam := -1;
      DownPlayer := -1;
      GetCas := false;
      AVBreak := false;
    end;
    allPlayers[g, f].LastAction := 2;
  end
  else
  begin
    HitTeam := -1;
    HitPlayer := -1;
    BlockTeam := -1;
    BlockPlayer := -1;
    BashTeam := -1;
    BashPlayer := -1;
    DownTeam := -1;
    DownPlayer := -1;
    GetCas := false;
  end;
  if activeTeam = 0 then
  begin
    KDownTOTRed := KDownTOTRed + 1;
  end
  else if activeTeam = 1 then
  begin
    KDownTOTBlue := KDownTOTBlue + 1;
  end;
  frmArmourRoll.txtArmourValue.text := IntToStr(TargetPlayer.av);
  frmArmourRoll.txtAssists.text := IntToStr(assa);
  frmArmourRoll.rbARNoSkill.checked := true;
  frmArmourRoll.rbIRNoSkill.checked := true;
  if allPlayers[g, f].hasSkill('Mighty Blow') then
  begin
    frmArmourRoll.rbARMightyBlow.checked := true;
    frmArmourRoll.rbIRMightyBlow.checked := true;
  end;
  if allPlayers[g, f].hasSkill('Claw') then
    frmArmourRoll.rbClaw.checked := true;
  if TargetPlayer.hasSkill('Running Chainsaw') then
    frmArmourRoll.cbChainsawKD.checked := true;
  frmArmourRoll.cbProSkill.checked := (TargetPlayer.hasSkill('Pro'));
  frmArmourRoll.cbThickSkull.checked :=
    (TargetPlayer.hasSkill('Thick Skull'));
  if ((Pos('HALFLING', Uppercase(TargetPlayer.position)) > 0) or
    ((Pos('GOBLIN', Uppercase(TargetPlayer.position)) > 0) and
    not(Pos('HOBGOBLIN', Uppercase(TargetPlayer.position)) > 0))) then
  begin
    frmArmourRoll.rbWeakPlayer.checked := true;
  end
  else if (TargetPlayer.hasSkill('STUNTY')) then
  begin
    frmArmourRoll.rbWeakPlayer.checked := true;
  end
  else
    frmArmourRoll.rbNoStunty.checked := true;
  frmArmourRoll.cbDecay.checked := (TargetPlayer.hasSkill('Decay'));
  frmArmourRoll.rbAVNegOne.checked := false;
  totspp := TargetPlayer.GetStartingSPP + TargetPlayer.GetMatchSPP();
  s := TargetPlayer.inj;
  p := Pos('N', Uppercase(s));
  { roll for each N until all done, or 1 rolled }
  NiggleCount := 0;
  repeat
  begin
    if p <> 0 then
      NiggleCount := NiggleCount + 1;
    s := Copy(s, p + 1, Length(s) - p);
    p := Pos('N', Uppercase(s));
  end
  until (p = 0);
  frmArmourRoll.txtNiggles.text := IntToStr(NiggleCount);
end;

procedure WorkOutFoul(g, f, g0, f0: integer);
var assa, assd, p,  NiggleCount: integer;
    tz, tz0: TackleZones;
    s: string;
    b, bx: boolean;
begin
  GetCAS := false;
  s := IntToStr(allPlayers[g,f].cnumber) + ' fouls ' +
    IntToStr(allPlayers[g0,f0].cnumber);
  {count assists}
  assa := 0;

  BlockTeam := g0;
  BlockPlayer := f0;
  HitTeam := g;
  HitPlayer := f;

  if not(allPlayers[g,f].hasSkill('Maniac'))
      then begin
    tz := CountTZFoul(g0, f0);
    bx := false;
    for p := 1 to tz.num do begin
      if tz.pl[p] <> f then begin
        b := false;

          tz0 := CountTZBlockCA(g, tz.pl[p]);
          if tz0.num = 0 then b := true;

        if b then begin
          assa := assa + 1;
          if allPlayers[g,tz.pl[p]].hasSkill('Running Chainsaw') then
             assa := assa + 2;
          if not(bx) then begin
            s := s + ' a ';
            bx := true;
          end else s := s + ',';
            s := s + InttoStr(allPlayers[g,tz.pl[p]].cnumber);
        end;
      end;
    end;
  end;
  assd := 0;

    {count counterassists}
    tz := CountTZBlockCA2(g, f);
    bx := false;
    for p := 1 to tz.num do begin
      if tz.pl[p] <> f0 then begin
        tz0 := CountTZBlockCA(g0, tz.pl[p]);
        b := (tz0.num = 0);
        {b := ((tz0.num = 1) and (player[g,f].tz = 0))
            or ((tz0.num = 0) and (player[g,f].tz <> 0));}
        if b then begin
          assd := assd + 1;
          if not(bx) then begin
            s := s + ' ca ';
            bx := true;
          end else s := s + ',';
            s := s + InttoStr(allPlayers[g0,tz.pl[p]].cnumber);
        end;
      end;
    end;

  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl);

  frmArmourRoll.txtArmourValue.text := IntToStr(allPlayers[g0,f0].av);
  frmArmourRoll.txtAssists.text := IntToStr((assa-assd));
  frmArmourRoll.rbARNoSkill.checked := true;
  frmArmourRoll.rbIRNoSkill.checked := true;
  if allPlayers[g,f].hasSkill('Mighty Blow') then begin
    frmArmourRoll.rbARMightyBlow.checked := true;
    frmArmourRoll.rbIRMightyBlow.checked := true;
  end;
  if allPlayers[g,f].hasSkill('Claw') then
    frmArmourRoll.rbClaw.checked := true;

  if allPlayers[g,f].hasSkill('Running Chainsaw') then
    frmArmourRoll.rbChainsaw.checked := true;
  if allPlayers[g,f].hasSkill('Dirty Player') then begin
    frmArmourRoll.rbDirtyPlayer.checked := true;
    frmArmourRoll.rbIRDirtyPlayer.checked := true;
  end;

  frmArmourRoll.cbThickSkull.checked :=
     (allPlayers[g0,f0].hasSkill('Thick Skull'));
  frmArmourRoll.cbProSkill.checked := (allPlayers[g0,f0].hasSkill('Pro'));

  if ((Pos('HALFLING', Uppercase(allPlayers[g0,f0].position)) > 0) or
      ((Pos('GOBLIN', Uppercase(allPlayers[g0,f0].position)) > 0)
        and not (Pos('HOBGOBLIN', Uppercase(allPlayers[g0,f0].position)) > 0)))
        then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else if (allPlayers[g0,f0].hasSkill('STUNTY')) then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else
   frmArmourRoll.rbNoStunty.checked := true;

  frmArmourRoll.cbDecay.checked := (allPlayers[g0,f0].hasSkill('Decay'));
  frmArmourRoll.cbIGMEOY.checked := (g = IGMEOY);
  frmArmourRoll.rbDeathRoller.checked := (allPlayers[g,f].hasSkill('Deathroller'));

    s := allPlayers[g0,f0].inj;
    p := Pos('N', Uppercase(s));
    {roll for each N until all done, or 1 rolled}
    NiggleCount := 0;
    repeat begin
      if p<>0 then NiggleCount := NiggleCount + 1;
      s := Copy(s, p+1, Length(s) - p);
      p := Pos('N', Uppercase(s));
    end until (p = 0);
    frmArmourRoll.txtNiggles.text := IntToStr(NiggleCount);

  HitTeam := -1;
  HitPlayer := -1;
  BlockTeam := -1;
  BlockPlayer := -1;
  BashTeam := g;
  BashPlayer := f;
  DownTeam := g0;
  DownPlayer := f0;
  GetCAS := false;
  AVBreak := true;
  ShowHurtForm('F');
end;

//todo: remove this
procedure SetIGMEOY(g: integer);
begin
  if IGMEOY = 0 then begin
    Bloodbowl.ImIGMEOYL.Visible := false;
    team[0].left := team[0].left - 32;
    team[0].width := team[0].width + 32;
  end;
  if IGMEOY = 1 then begin
    Bloodbowl.ImIGMEOYR.Visible := false;
    team[1].width := team[1].width + 32;
  end;
  IGMEOY := g;
  if g = 0 then begin
    team[0].left := team[0].left + 32;
    team[0].width := team[0].width - 32;
    Bloodbowl.ImIGMEOYL.Visible := true;
  end;
  if g = 1 then begin
    team[1].width := team[1].width - 32;
    Bloodbowl.ImIGMEOYR.Visible := true;
  end;
end;

procedure InjurySettings(g0, f0:integer);
var p, NiggleCount: integer;
    s: string;
begin
  frmArmourRoll.rbARNoSkill.checked := true;
  frmArmourRoll.rbIRNoSkill.checked := true;
  frmArmourRoll.cbThickSkull.checked := (allPlayers[g0,f0].hasSkill('Thick Skull'));
  frmArmourRoll.cbProSkill.checked := (allPlayers[g0,f0].hasSkill('Pro'));

  if ((Pos('HALFLING', Uppercase(allPlayers[g0,f0].position)) > 0) or
      ((Pos('GOBLIN', Uppercase(allPlayers[g0,f0].position)) > 0)
        and not (Pos('HOBGOBLIN', Uppercase(allPlayers[g0,f0].position)) > 0)))
        then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else if (allPlayers[g0,f0].hasSkill('STUNTY')) then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else if (allPlayers[g0,f0].hasSkill('Easily Injured')) then begin
          frmArmourRoll.rbWeakPlayer.checked := true;
  end else frmArmourRoll.rbNoStunty.checked := true;

  frmArmourRoll.cbDecay.checked := (allPlayers[g0,f0].hasSkill('Decay'));

    s := allPlayers[g0,f0].inj;
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

procedure ArmourSettings(g, f, g0, f0, special:integer);
var p2, NiggleCount: integer;
    s: string;

begin
  {special of 1 is a Mighty Blow hit, 2 is Mace Tail}
  ActionTeam := g;
  ActionPlayer := f;
  curteam := g0;
  curplayer := f0;
  frmArmourRoll.txtArmourValue.Text :=
     IntToStr(allPlayers[curteam,curplayer].av);
  if special=0 then begin
    frmArmourRoll.rbARNoSkill.Checked := true;
    frmArmourRoll.rbIRNoSkill.Checked := true;
  end else if special=2 then begin
    frmArmourRoll.rbAVNegOne.checked := true;
    frmArmourRoll.rbIRMightyBlow.checked := true;
    frmArmourRoll.txtAssists.text := IntToStr(0);

  end else begin
    frmArmourRoll.rbARMightyBlow.checked := true;
    frmArmourRoll.rbIRMightyBlow.checked := true;
  end;
  frmArmourRoll.cbThickSkull.checked :=
    (allPlayers[curteam,curplayer].hasSkill('Thick Skull'));
  frmArmourRoll.cbProSkill.checked := (allPlayers[curteam,curplayer].hasSkill('Pro'));
  if allPlayers[curteam,curplayer].hasSkill('Running Chainsaw') then
    frmArmourRoll.cbChainsawKD.checked := true;

  if
   ((Pos('HALFLING', Uppercase(allPlayers[curteam,curplayer].position)) > 0) or
   ((Pos('GOBLIN', Uppercase(allPlayers[curteam,curplayer].position)) > 0)
   and not (Pos('HOBGOBLIN', Uppercase(allPlayers[curteam,curplayer].position)) > 0)))
   then begin
     frmArmourRoll.rbWeakPlayer.checked := true;
  end else if (allPlayers[curteam,curplayer].hasSkill('STUNTY')) then begin
    frmArmourRoll.rbWeakPlayer.checked := true;
  end
   else frmArmourRoll.rbNoStunty.checked := true;

  frmArmourRoll.cbDecay.checked := (allPlayers[curteam,curplayer].hasSkill('Decay'));

    s := allPlayers[curteam,curplayer].inj;
    p2 := Pos('N', Uppercase(s));
    {roll for each N until all done, or 1 rolled}
    NiggleCount := 0;
    repeat begin
    if p2<>0 then NiggleCount := NiggleCount + 1;
    s := Copy(s, p2+1, Length(s) - p2);
    p2 := Pos('N', Uppercase(s));
    end until (p2 = 0);
    frmArmourRoll.txtNiggles.text := IntToStr(NiggleCount);

  ShowHurtForm('A');
end;

function RangeRulerRange(p,q,p0,q0: integer): integer;
{This function will return the range on the range ruler when measured
 from square (p,q) to square (p0,q0).
 Return values:
 0: quick pass
 1: short pass
 2: long pass
 3: long bomb
 4: out of range

 The calculation is done like this:
 first I draw a line through (p,q) and (p0,q0). In math:
 (dp = p0-p, dq = q0-q)
 (p,q) + x * (dp,dq)

 Then I draw a line squared (is that the expression?) to that line. In math:
 y*(-dq,dp)

 This last line should intersect the corner of the square of (p0,q0)
 that is farthest away from (p,q). So if p0>p and q0>q then the line
 should intersect (p0+0.5,q0+0.5). So:
 (p,q) + x * (dp,dq) + y * (-dq,dp) = (p0+0.5,q0+0.5)

 The final distance is the distance from (p,q) to the line.
 This is x * dp. With some math x can be calculated like this:
 x = 1 + 0.5*(dp+dq)/(dp^2+dq^2)

 We need to compare x*dp with the range ruler. For this I used the
 following values:
 size of a square = 2.9 cm
 distance for quick pass = 11.3 cm
 distance for short pass = 21.35 cm
 distance for long pass = 31.4 cm
 distance for long bomb = 39.9 cm
}
var dist, dmod: real;
    dp, dq, bigd, littled: integer;
begin
{abs used to force p0>p,q0>q}
  dp := abs(p0 - p);
  dq := abs(q0 - q);
{  dist := dp * (1 + 0.5 * (dp + dq) / (dp * dp + dq * dq));}
  if dp >= dq then begin
    bigd := dp;
    littled := dq;
  end else begin
    bigd := dq;
    littled := dp;
  end;
  if (littled = 0) or (bigd=0) then dmod := 0.5
  else if bigd=littled then dmod := 0.7285
  else dmod := 0.5 + ((0.2285/bigd)*littled);
  dist := sqrt((littled*littled)+((bigd+dmod)*(bigd+dmod)));
  if dist < 11.3/2.9 then RangeRulerRange := 0 else
  if dist < 21.35/2.9 then RangeRulerRange := 1 else
  if dist < 31.4/2.9 then RangeRulerRange := 2 else
  if dist < 39.9/2.9 then RangeRulerRange := 3 else
  RangeRulerRange := 4;
end;

function CanIntercept(p,q,p0,q0,i,j: integer): boolean;
{CanIntercept will return true if a player at position (i,j) can
 intercept a pass from (p,q) to (p0,q0).
 Again I draw two lines: one from (p,q) to (p0,q0) and one squared
 to that one, which goes through (i,j). So:
 (p,q) + x*(dp,dq) + y*(-dq,dp) = (i,j)

 which leads to:
 x = ((i-p)*dp + (j-q)*dq)/(dp^2 + dq^2)

 First the interceptor needs
 to be between (p,q) and (p0,q0) so x needs to be between 0 and 1.

 Now I intersect the last line with any corner of the square of (i,j)
 and I calculate the distance from that corner to the line through
 (p,q) and (p0,q0). This leads to:
 y = ((j%0.5-q)*dp - (i%0.5-p)*dq) / (dq^2 + dp^2)
 (with % being either + or -).

 The distance to the passing line is y / sqrt(dp^2+dq^2).
 The rangeruler is 5 cm wide so if y * 2.9 cm (width of a square)
 is less than 2.5 cm, the interceptor can indeed make an interception.
}
var  dist, dmod, d, dp2, dq2: real;
    dp, dq, bigd, littled: integer;
    b: boolean;
begin
  dp := abs(p0 - p);
  dq := abs(q0 - q);
  if dp >= dq then begin
    bigd := dp;
    littled := dq;
  end else begin
    bigd := dq;
    littled := dp;
  end;
  b := false;
  {x := ((i - p) * dp + (j - q) * dq) / (dp * dp + dq * dq);
  if (x <= 0) or (x >= 1) then CanIntercept := false else begin
    b := false;
    f := -0.5;
    while not(b) and (f < 1) do begin
      g := -0.5;
      while not(b) and (g < 1) do begin
        y := ( (j+f-q) * dp - (i+g-p) * dq) / (dq*dq + dp * dp);
        dist := y / sqrt (dp*dp + dq*dq);
        if dist < 2.5/2.9 then b := true;
        g := g + 1;
      end;
      f := f + 1;
    end;
    CanIntercept := b;
  end;   }
 {calculate closest point on pass-line to opponent}
  d := ((p - p0) * (p - i) + (q - q0) * (q - j)) /
    ((p - p0) * (p - p0) + (q - q0) * (q - q0));
  {if d<0 or d>1 then the opponent is not between passer and catcher}
  if (d > 0) and (d < 1) then begin
    {(dp,dq) is point on pass-line closest to opponent}
    dp2 := p + d * (p0 - p);
    dq2 := q + d * (q0 - q);
    {calculate distance from (dp,dq) to opponent}
    dist := Sqrt((i - dp2) * (i - dp2) + (j - dq2) * (j - dq2));
    {the range ruler is 5 cm wide, a player's square is 2.9 cm wide
    in ordinal directions and 4.1 cm wide at 45% angles;
    so if the distance is ordinal at most (5+2.9)/2 = 3.85 cm then the opponent
    can intercept... but on 45% angles its (5+4.1)/2 = 4.55 cm or smaller
    to intercept}
    if (littled = 0) or (bigd=0) then dmod := 3.85
      else if bigd=littled then dmod := 4.55
      else dmod := 3.85 + ((0.7/bigd)*littled);
    dist := dist * 2.9;
    if dist < dmod then b := true;
  end;
  CanIntercept := b;
end;

{Reset players}
procedure ResetPlayers;
var f, g: integer;
    s: string;
begin
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (allPlayers[g,f].status <> 11) then begin
        s := 'u' + Chr(g + 48) + Chr(f + 64) +
          Chr(allPlayers[g, f].ma + 48) +
          Chr(allPlayers[g, f].st + 48) +
          Chr(allPlayers[g, f].ag + 48) +
          Chr(allPlayers[g, f].av + 48) +
             Chr(allPlayers[g,f].cnumber + 64) +
             Chr(allPlayers[g,f].value div 5 + 48) +
             allPlayers[g,f].name + '$' +
             allPlayers[g,f].position + '$' +
             allPlayers[g,f].picture + '$' +
             allPlayers[g,f].icon + '$' +
          allPlayers[g, f].GetSkillString(1) + '|' +
          Chr(allPlayers[g, f].ma0 + 48) +
          Chr(allPlayers[g, f].st0 + 48) +
          Chr(allPlayers[g, f].ag0 + 48) +
          Chr(allPlayers[g, f].av0 + 48) +
             Chr(allPlayers[g,f].cnumber + 64) +
             Chr(allPlayers[g,f].value div 5 + 48) +
             allPlayers[g,f].name + '$' +
             allPlayers[g,f].position + '$' +
             allPlayers[g,f].picture + '$' +
             allPlayers[g,f].icon + '$' +
          allPlayers[g, f].GetSkillString(2);
        LogWrite(s);
        PlayActionPlayerStatChange(s, 1);
      end;
    end;
  end;
end;

end.
