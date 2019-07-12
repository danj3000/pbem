unit unitExtern;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TmodExtern = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  modExtern: TmodExtern;

  WriteLogUncoded: boolean;
  LoadSaveDir: string;

procedure SaveGame(fn: string);
procedure LoadGame(fn: string);
procedure LoadTeamFile(g: integer; fn: string);
procedure PlayActionLoadTeam(s: string; dir: integer);
procedure SaveTeamFile(g: integer; fn: string);
procedure RecordInRegistry(gameid: string; len: integer);

implementation

uses registry,
     unitLog, bbalg, bbunit, unitTeam, unitMarker, unitPostgameSeq,
  unitSettings, unitPlayAction, unitRandom;

{$R *.DFM}

type CodeTable = array [32..255] of integer;

function FillCodeTable(start, step: integer): CodeTable;
var f, cur: integer;
    cd: CodeTable;
begin
  cur := start;
  for f := 32 to 255 do cd[f] := 0;
  for f := 32 to 255 do begin
    cur := (cur + step - 32) mod 224 + 32;
    while cd[cur] <> 0 do cur := (cur - 31) mod 224 + 32;
    cd[cur] := f;
  end;
  FillCodeTable := cd;
end;

function GetDirOfFileName(s: string): string;
var p: integer;
begin
  p := length(s);
  while (p > 0) and (s[p] <> '\') do p := p - 1;
  GetDirOfFileName := Copy(s, 1, p);
end;

procedure SaveGame(fn: string);
var gg: textfile;
    c: char;
    cd: CodeTable;
    i, j, p, p2, p3, start, step: integer;
    s: string;
begin
  if fn<>(curdir + 'autosave.bbm') then begin
    AddToGameLog('(=S0' + LoggedCoach + '@' + DateTimeToStr(Now) +
      '%' + LDFILEDT + '$' + PBeMVersion);
    s := '=S0' + LoggedCoach + '@' + DateTimeToStr(Now) +
      '%' + LDFILEDT + '$' + PBeMVersion;
    s := Copy(s, 3, length(s) - 2);
    p := Pos('@', s);
    p2 := Pos('%', s);
    p3 := Pos('$', s);
    Bloodbowl.comment.text := 'Save Game by ' +
      Copy(s, 2, p-2) + ' at ' + Copy(s, p+1, p2-p-1);
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
  start := Random(224) + 32;
  step := Random(192) + 32;
  cd := FillCodeTable(start, step);
  AssignFile(gg, fn);
  Rewrite(gg);
  WriteLn(gg, PBeMVerText);
  if WriteLogUncoded then
  begin
    i := 0;
    while i < GameLogLength do
    begin
      s := GetGameLog(i);
      WriteLn(gg, s);
      i := i + 1;
    end;
  end else
  begin
    Write(gg, '&' + Chr(start) + Chr(step));
    j := 0;
    while j < GameLogLength do
    begin
      s := GetGameLog(j) + Chr(248);
      for p := 1 to Length(s) do begin
        c := Chr(cd[(Ord(s[p]) + p + j - 33) mod 224 + 32]);
        Write(gg, c);
      end;
      j := j + 1;
    end;
  end;
  CloseFile(gg);
  LoadSaveDir := GetDirOfFileName(fn);
end;

procedure LoadGame(fn: string);
var s, s0: string;
    cd, dc: CodeTable;
    start, step, f: integer;
    l, lc, lp: longint;
    gg: Textfile;

    function DecodeNextChar: longint;
    var li: longint;
    begin
      li := dc[Ord(s0[lp])] - l - Length(s);
      lp := lp + 1;
      while li < 32 do li := li + 224;
      DecodeNextChar := li;
    end;

begin
  AssignFile(gg, fn);
  Reset(gg);
  LDFILEDT := DateTimeToStr(FileDateToDateTime(FileAge(fn)));
  UserRandomize;
  ReadLn(gg, s);
  ReadLn(gg, s);
  if s[1] = '&' then begin
    s0 := s;
    while not(eof(gg)) do begin
      ReadLn(gg, s);
      s0 := s0 + s;
    end;
    start := Ord(s0[2]);
    step := Ord(s0[3]);
    cd := FillCodeTable(start, step);
    for f := 32 to 255 do dc[cd[f]] := f;
    l := 0;
    lp := 4;
    while lp <= Length(s0) do begin
      s := '';
      lc := DecodeNextChar;
      while (lc <> 248) and (lp <= Length(s0)) do begin
        s := s + Chr(lc);
        lc := DecodeNextChar;
      end;
      AddToGameLog(s);
      l := l + 1;
    end;
  end else begin
    AddToGameLog(s);
    while not(eof(gg)) do begin
      ReadLn(gg, s);
      AddToGameLog(s);
    end;
  end;
  
  CloseFile(gg);
  GoToGameLog(StartOfLog);
  RLCoach[0] := GetGameLog(1);
  RLCoach[1] := GetGameLog(2);
  RestoreSettings(GetGameLog(3));
  LoadSaveDir := GetDirOfFileName(fn);
end;

function StripAllTags(s: string): string;
var s0: string;
    p: integer;
begin
  s0 := trim(s);
  p := Pos('<', s0);
  while p = 1 do begin
    p := Pos('>', s0);
    s0 := Trim(Copy(s0, p+1, length(s0)));
    p := Pos('<', s0);
  end;
  if p > 0 then StripAllTags := Trim(Copy(s0, 1, p-1))
           else StripAllTags := s0;
end;

function GetNextCell(s: string): string;
var s0, t: string;
    p: integer;
begin
  p := Pos('</TD>', s);
  if p = 1 then begin
    s := copy(s, 6, length(s));
    p := Pos('</TD>', s);
  end;
  if p = 0 then s0 := StripAllTags(s) else begin
    t := StripAlltags(copy(s, 1, p-1));
    s0 := t;
  end;
  p := Pos('&NBSP;', Uppercase(s0));
  while p > 0 do begin
    s0 := Trim(Copy(s0, 1, p-1) + ' ' + Copy(s0, p+6, length(s0)));
    p := Pos('&NBSP;', Uppercase(s0));
  end;
  p := Pos('&NBSP', Uppercase(s0));
  while p > 0 do begin
    s0 := Trim(Copy(s0, 1, p-1) + ' ' + Copy(s0, p+5, length(s0)));
    p := Pos('&NBSP', Uppercase(s0));
  end;
  GetNextCell := s0;
end;

procedure LoadTeamFile(g: integer; fn: string);
var gg: TextFile;
    r, s, s0, t, s2: string;
    f, p, q, piccount, p2, p3, holdq: integer;
    pl, pics, blnLogo, blnField: boolean;

   function GetLine: string;
   var t, tag: string;
       i, j: integer;
   begin
     t := '';
     tag := '';
     while (tag <> '<P>') and (tag <> '</P>') and (tag <> '<BR>')
       and (tag <> '</TR>') and (r <> '') do begin
       i := Pos('<', r);
       if i = 0 then i := length(r) + 1;
       t := t + Trim(Copy(r, 1, i-1));
       r := Copy(r, i, length(r) - i + 1);
       j := Pos('>', r);
       tag := Uppercase(Copy(r, 1, j));
       r := Copy(r, j+1, length(r) - j);
       if copy(tag, 1, 3) = '<TR' then t := t + '<TR>';
       if copy(tag, 1, 3) = '<TH' then t := t + '<TH>';
       if copy(tag, 1, 3) = '<TD' then t := t + '<TD>';
       if (tag = '</TR>') or (tag = '<TITLE>') or (tag = '</TITLE>')
        or (tag = '</TD>') or (tag = '</TH>') or (Copy(tag, 1, 4) = '<IMG')
        or (Copy(tag,1, 8) = '<A HREF=') or (tag = '</A>')
         then t := t + tag;
     end;
     GetLine := t;
   end;

begin
  pl := true;
  pics := false;
  blnLogo := false;
  piccount := 0;
  ResetTeam(g);
  AssignFile(gg, fn);
  Reset(gg);
  r := '';
  while not(eof(gg)) do begin
    ReadLn(gg, s);
    r := r + ' ' + Trim(s);
  end;
  CloseFile(gg);
  if r <> '' then s := Trim(GetLine);
  while (s <> '') or (r<> '') do begin
    if (Pos('<TR', UpperCase(s)) > 0)
    and (Pos('</TR>', Uppercase(s)) = 0) then begin
      s0 := GetLine;
      while (Pos('</TR>', UpperCase(s0)) = 0) and (r <> '') do begin
        s := s + ' ' + Trim(s0);
        s0 := GetLine;
      end;
      s := s + ' ' + s0;
    end;
    p := Pos('<TITLE>', s);
    if p > 0 then team[g].name := GetNextCell(copy(s, p+7, length(s)));
    p := Pos('RACE:', UpperCase(s));
    if p > 0 then team[g].race := GetNextCell(copy(s, p+5, length(s)));
    p := Pos('COACHED BY:', UpperCase(s));
    if p > 0 then begin
     p2 := Pos('<',s);
     if p2 = 0 then p2 := length(s) + 1;
     team[g].coach := Copy(s, p+11, p2-(p+11));
     team[g].email := GetNextCell(copy(s, p+11, length(s)));
    end;
    p := Pos('MAILTO:',s);
    if p > 0 then begin
      team[g].email := GetNextCell(copy(s, p+7, length(s)));
      p2 := Pos('>',team[g].email);
      team[g].email := Copy(team[g].email, 1, p2-2);
    end;
    p := Pos('COACH:', UpperCase(s));
    if p > 0 then team[g].coach := GetNextCell(copy(s, p+11, length(s)));
    p := Pos('RE-ROLLS:', UpperCase(s));
    if p > 0 then begin
      s0 := Copy(s, p+14, Length(s));
      team[g].reroll := FVal(GetNextCell(s0));
      team[g].reroll0 := team[g].reroll;
      s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
      team[g].rerollcost := MoneyVal(GetNextCell(s0));
    end;
    p := Pos('FAN FACTOR:', UpperCase(s));
    if p > 0 then begin
      team[g].ff := FVal(GetNextCell(copy(s, p+11, length(s))));
      team[g].ff0 := team[g].ff;
    end;
    p := Pos('ASSISTANT COACHES:', UpperCase(s));
    if p > 0 then
      team[g].asstcoaches := FVal(GetNextCell(copy(s, p+18, length(s))));
    p := Pos('CHEERLEADERS:', UpperCase(s));
    if p > 0 then
      team[g].cheerleaders := FVal(GetNextCell(copy(s, p+13, length(s))));
    p := Pos('APOTHECARY:', UpperCase(s));
    if p > 0 then
      team[g].apot := FVal(GetNextCell(copy(s, p+11, length(s))));
    if Pos('HALFLING', Uppercase(team[g].race)) > 0 then
      p := Pos('MASTER CHEF:', UpperCase(s))
    else
      p := Pos('TEAM WIZARD:', UpperCase(s));
    if p > 0 then
      team[g].wiz := FVal(GetNextCell(copy(s, p+12, length(s))));
    p := Pos('TREASURY:', UpperCase(s));
    if p > 0 then begin
      team[g].treasury := GetNextCell(copy(s, p+9, length(s)));
      team[g].treasury0 := team[g].treasury;
    end;
    p := Pos('WIN MODIFIER=', UpperCase(s));
    if p > 0 then begin
      q := Pos('K',Copy(UPPERCASE(s), p+13, length(s)-p-12));
      team[g].winmod := (FVal(Copy(s, p+13, q-p))) div 10;
    end;
    s0 := '';
    p := Pos('PLAYBOOK', UpperCase(s));
    if p > 0 then begin
      q := Pos('PLAYBOOK END', Copy(UPPERCASE(s), p+8, length(s)-p-7));
      s0 := Copy(UpperCase(s), p+8, (q-p)+1);
      p := Pos('~', s0);
      while p > 0 do begin
        q := Pos('~', Copy(s0, p+1, length(s0)));
        holdq := q;
        if q<>0 then begin
          if g = 0 then begin
            s2 := 'VR' + Copy(s0, p+1, (q-p)+1);
          end else begin
            s2 := 'VB' + Copy(s0, p+1, (q-p)+1);
          end;
          Logwrite(s2);
          PlayActionPlayBook(s2,1);
          s0 := Copy(s0, holdq+1, length(s0));
          p := Pos('~', s0);
        end else p:=0;
      end;
    end;
    s0 := '';
    p := Pos('TEAM LOGO', UpperCase(s));
    if p > 0 then begin
      blnLogo := true;
      s0 := UpperCase(copy(s, p+9, Length(s)-p-8));
    end else if blnLogo then begin
      s0 := UpperCase(s);
    end;
    if blnLogo then begin
      p := Pos('SRC="', s0);
      if p > 0 then begin
        q := Pos('"', Copy(s0, p+5, length(s0)));
        team[g].logo := Copy(s0, p+5, q-1);
        blnLogo := false;
      end;
    end;
    p := Pos('TEAM FIELD', UpperCase(s));
    if p > 0 then begin
      blnField := true;
      s0 := UpperCase(copy(s, p+9, Length(s)-p-8));
    end else if blnField then begin
      s0 := UpperCase(s);
    end;
    if blnField then begin
      p := Pos('SRC="', s0);
      if p > 0 then begin
        q := Pos('"', Copy(s0, p+5, length(s0)));
        team[g].homefield := Copy(s0, p+5, q-1);
        blnField := false;
      end;
    end;
    s0 := '';
    p := Pos('TEAM PICTURES', UpperCase(s));
    if p > 0 then begin
      q := Pos('TEAM PICTURES END', UpperCase(s));
      if (p=q) and pics then p := 1;
      if q = 0 then q := Length(s) else pics := false;
      s0 := UpperCase(Copy(s, p, q-p+1));
      pics := true;
    end else if pics then begin
      s0 := UpperCase(s);
    end;
    if s0 <> '' then begin
      p := Pos('SRC="', s0);
      while p > 0 do begin
        q := Pos('"', Copy(s0, p+5, length(s0)));
        piccount := piccount + 1;
        allPlayers[g,piccount].picture := Copy(s0, p+5, q-1);
        allPlayers[g,piccount].picture0 := allPlayers[g,piccount].picture;
        s0 := Copy(s0, p+5+q, length(s0));
        p := Pos('SRC="', s0);
      end;
    end;
    p := Pos('TEAM COLOR=', UpperCase(s));
    if p > 0 then begin
      FillColorArray(g, StringToColor('$00' + Copy(s,p+11, 6)));
      RepaintColor(g);
      t := 'g' + InttoStr(g) + ('$00' + Copy(s,p+11,6));
      LogWrite(t);
    end;
    p := Pos('>#<', s);
    if (p > 0) and pl then begin
      pl := false;
      s := GetLine;
      f := 1;
      while f <= MaxNumPlayersInTeam do begin
        s := Trim(s);
        s0 := s;
        while Pos('<TR', Uppercase(s0)) = 0 do s0 := GetLine;
        while Pos('</TR>', Uppercase(s0)) = 0 do begin
          t := GetLine;
          s0 := s0 + ' ' + Trim(t);
        end;
        q := FVal(GetNextcell(s0));
        if (q > 0) and (q < 100) then begin
          allPlayers[g,f].cnumber := q;
          allPlayers[g,f].cnumber0 := q;
          allPlayers[g,f].caption := IntToStr(q);
          allPlayers[g,f].status := 0;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].name := GetNextCell(s0);
          allPlayers[g,f].name0 := allPlayers[g,f].name;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].position := GetNextCell(s0);
          allPlayers[g,f].position0 := allPlayers[g,f].position;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].ma := FVal(GetNextCell(s0));
          allPlayers[g,f].ma0 := allPlayers[g,f].ma;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].st := FVal(GetNextCell(s0));
          allPlayers[g,f].st0 := allPlayers[g,f].st;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].ag := FVal(GetNextCell(s0));
          allPlayers[g,f].ag0 := allPlayers[g,f].ag;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].av := FVal(GetNextCell(s0));
          allPlayers[g,f].av0 := allPlayers[g,f].av;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].SetSkill(GetNextCell(s0));
          allPlayers[g,f].SetSkillsToDefault;
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].inj := GetNextCell(s0);
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].comp0 := FVal(GetNextCell(s0));
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].td0 := FVal(GetNextCell(s0));
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].int0 := FVal(GetNextCell(s0));
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].cas0 := FVal(GetNextCell(s0));
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].mvp0 := FVal(GetNextCell(s0));
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));

          allPlayers[g,f].peaked := (Uppercase(Trim(GetNextCell(s0))) = 'P');
          s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
          allPlayers[g,f].value := MoneyVal(GetNextCell(s0));
          allPlayers[g,f].value0 := allPlayers[g,f].value;
          s := GetLine;
          f := f + 1;
        end else begin
          t := UpperCase(GetNextCell(s0));
          if not((t = 'TEAM:') or (t = 'TEAM NAME:')) then begin
            s0 := Copy(s0, Pos('</TD>', s0) + 5, length(s0));
            t := UpperCase(GetNextCell(s0));
          end;
          if (t = 'TEAM:') or (t = 'TEAM NAME:') then begin
            team[g].numplayers := f - 1;
            f := MaxNumPlayersInTeam + 1;
          end else s := GetLine;
        end;
      end;
    end else s := GetLine;
  end;
  LogWrite('L' + Chr(g + 48) + '!' + trim(team[g].name) + Chr(255) +
           trim(team[g].race) + Chr(255) +
           trim(team[g].email) + Chr(255) +
           trim(team[g].coach) + Chr(255) +
           trim(team[g].treasury) + Chr(255) + Chr(team[g].ff + 48) +
           Chr(team[g].reroll + 48) + Chr(team[g].asstcoaches + 48) +
           Chr(team[g].winmod + 48) +
           Chr(team[g].cheerleaders + 48) + Chr(team[g].apot + 48) +
           Chr(team[g].wiz + 48) + Chr(48) +
           Chr(48) + Chr(team[g].rerollcost + 48) +
           team[g].logo + Chr(255) + team[g].homefield);
  for f := 1 to team[g].numplayers do begin
    s0 := '(L' + allPlayers[g,f].GetSaveString;
    LogWrite(s0);
  end;
  AddLog('Team ' + ffcl[g] + ' loaded: ' + team[g].name);
  ffcl[g] := team[g].name;
  team[g].caption := team[g].name;
  for f := 1 to team[g].numplayers do begin
    if allPlayers[g,f].ma = 0
    then allPlayers[g,f].SetStatusDef(11)
    else
     if Pos('M', allPlayers[g,f].inj) > 0
     then allPlayers[g,f].SetStatusDef(10)
     else
      if Pos('N', allPlayers[g,f].inj) > 0
      then allPlayers[g,f].SetStatusDef(9);
  end;
  for f := team[g].numplayers + 1 to MaxNumPlayersInTeam
   do allPlayers[g,f].SetStatusDef(11);

  apo[g].Enabled := (team[g].apot > 0 );

  if team[g].wiz > 0 then
  begin
    wiz[g].color := colorarray[g, 0, 0];
    wiz[g].font.color := colorarray[g, 0, 1];
    wiz[g].visible := true;
    if Pos('HALFLING', Uppercase(team[g].race)) > 0 then begin
      wiz[g].color := colorarray[g, 4, 0];
      wiz[g].font.color := colorarray[g, 4, 1];
      wiz[g].caption := 'Chef';
    end;
  end
  else
    wiz[g].visible := false;

  marker[g, MT_Reroll].SetValue(team[g].reroll);
  LoadSaveDir := GetDirOfFileName(fn);
end;

procedure PlayActionLoadTeam(s: string; dir: integer);
var f, g: integer;
    s0, t: string;
begin
  if dir = 1 then begin
    g := Ord(s[2]) - 48;
    if s[3] = '!' then begin
      ResetTeam(g);
      s0 := Copy(s, 4, length(s));
      SplitTextAtChr255(s0, team[g].name);
      SplitTextAtChr255(s0, team[g].race);
      SplitTextAtChr255(s0, team[g].email);
      SplitTextAtChr255(s0, team[g].coach);
      SplitTextAtChr255(s0, team[g].treasury);
      team[g].treasury0 := team[g].treasury;
      team[g].ff := Ord(s0[1]) - 48;
      team[g].ff0 := team[g].ff;
      team[g].reroll := Ord(s0[2]) - 48;
      team[g].reroll0 := team[g].reroll;
      team[g].asstcoaches := Ord(s0[3]) - 48;
      team[g].winmod := Ord(s0[4]) - 48;
      team[g].cheerleaders := Ord(s0[5]) - 48;
      team[g].apot := Ord(s0[6]) - 48;
      team[g].wiz := Ord(s0[7]) - 48;
      team[g].rerollcost := Ord(s0[10]) - 48;
      s0 := Copy(s0, 11, length(s0));
      SplitTextAtChr255(s0, team[g].logo);
      SplitTextAtChr255(s0, team[g].homefield);
      if (team[g].homefield <> '') and (RLCoach[g] = LoggedCoach) then begin
        if FileExists(curdir + 'roster/' + team[g].homefield) then begin
          frmSettings.txtFieldImageFile.text :=
            '../roster/' + team[g].homefield;
          ShowFieldImage(frmSettings.txtFieldImageFile.text);
        end;
      end;
      AddLog('Team ' + ffcl[g] + ' loaded: ' + team[g].name);
      ffcl[g] := team[g].name;
      team[g].caption := team[g].name;
      ApoWizCreate(g);
      if team[g].wiz > 0 then begin
        wiz[g].caption := 'WIZ';
        wiz[g].color := colorarray[g, 0, 0];
        wiz[g].font.color := colorarray[g, 0, 1];
        wiz[g].visible := true;
        if Pos('HALFLING', Uppercase(team[g].race)) > 0 then begin
          wiz[g].color := colorarray[g, 4, 0];
          wiz[g].font.color := colorarray[g, 4, 1];
          wiz[g].caption := 'Chef';
        end;
      end
      else
        wiz[g].visible := false;

      if g = 0 then
      begin
        Bloodbowl.LblRedTeam.caption := ffcl[g];
        Bloodbowl.lblHomeTV.caption := 'TV: ' + team[g].GetTeamValue().ToString();
      end
      else
      begin
        Bloodbowl.LblBlueTeam.caption := ffcl[g];
        Bloodbowl.lblAwayTV.caption := 'TV: ' + team[g].GetTeamValue().ToString();
      end;

      if g = 0 then Bloodbowl.ButLoadRed.enabled := false
               else Bloodbowl.ButLoadBlue.enabled := false;
      if not(Bloodbowl.ButLoadRed.enabled)
      and not(Bloodbowl.ButLoadBlue.enabled) then
        Bloodbowl.ButWeather.enabled := true;
    end else begin
      team[g].numplayers := team[g].numplayers + 1;
      f := Ord(s[3]) - 64;
      allPlayers[g,f].number := f;
      allPlayers[g,f].teamnr := g;
      s0 := Copy(s, 4, Length(s) - 3);
      SplitTextAtChr255(s0, allPlayers[g,f].name);
      allPlayers[g,f].name0 := allPlayers[g,f].name;
      SplitTextAtChr255(s0, allPlayers[g,f].position);
      allPlayers[g,f].position0 := allPlayers[g,f].position;
      SplitTextAtChr255(s0, t);
      allPlayers[g,f].SetSkill(t);
      SplitTextAtChr255(s0, allPlayers[g,f].inj);
      SplitTextAtChr255(s0, t);
      allPlayers[g,f].icon := 'Yet to be Enabled';
      allPlayers[g,f].icon0 := 'Yet to be Enabled';
      allPlayers[g,f].ma := Ord(t[1]) - 48;
      allPlayers[g,f].st := Ord(t[2]) - 48;
      allPlayers[g,f].ag := Ord(t[3]) - 48;
      allPlayers[g,f].av := Ord(t[4]) - 48;
      allPlayers[g,f].ma0 := allPlayers[g,f].ma;
      allPlayers[g,f].st0 := allPlayers[g,f].st;
      allPlayers[g,f].ag0 := allPlayers[g,f].ag;
      allPlayers[g,f].av0 := allPlayers[g,f].av;
      allPlayers[g,f].SetSkillsToDefault;
      allPlayers[g,f].int0 := Ord(t[5]) - 48;
      allPlayers[g,f].td0 := Ord(t[6]) - 48;
      allPlayers[g,f].cas0 := Ord(t[7]) - 48;
      allPlayers[g,f].comp0 := Ord(t[8]) - 48;
      allPlayers[g,f].mvp0 := Ord(t[9]) - 48;
      allPlayers[g,f].peaked := (t[10] = 'P');
      allPlayers[g,f].value := 10 * (Ord(t[11]) - 48);
      allPlayers[g,f].value0 := allPlayers[g,f].value;
      if length(t) > 11 then allPlayers[g,f].cnumber := Ord(t[12]) - 48
                         else allPlayers[g,f].cnumber := f;
      allPlayers[g,f].cnumber0 := allPlayers[g,f].cnumber;
      if length(t) > 12 then begin
        allPlayers[g,f].otherSPP0 := Ord(t[13]) - 48;
      end;
      if s0 <> '' then allPlayers[g,f].picture := s0;
      allPlayers[g,f].picture0 := allPlayers[g,f].picture;
      allPlayers[g,f].caption := IntToStr(allPlayers[g,f].cnumber);
      if allPlayers[g,f].ma <> 0 then begin
        if Pos('M', allPlayers[g,f].inj) > 0 then
          allPlayers[g,f].SetStatusDef(10)
        else
          if Pos('N', allPlayers[g,f].inj) > 0 then
            allPlayers[g,f].SetStatusDef(9)
         else
           allPlayers[g,f].SetStatusDef(0);
      end else begin
        allPlayers[g,f].SetStatusDef(11);
      end;
    end;
  end
  else
  begin
    // Dir is back
    if s[3] = '!' then begin
      g := Ord(s[2]) - 48;
      ResetTeam(g);
      if g = 0 then ffcl[0] := 'Home' else ffcl[1] := 'Away';
      if g = 0 then Bloodbowl.lblRedTeam.caption := ''
               else Bloodbowl.lblBlueTeam.caption := '';
      if g = 0 then Bloodbowl.ButLoadRed.enabled := true
               else Bloodbowl.ButLoadBlue.enabled := true;
      Bloodbowl.ButWeather.enabled := false;
      BackLog;
    end;
  end;
end;

function Money(i: integer): string;
var t: integer;
    s: string;
begin
  if i <> 0 then begin
    if i >= 1000 then begin
      t := i div 1000;
      s := IntToStr(i - 1000 * t);
      while length(s) < 3 do s := '0' + s;
      Money := '$' + IntToStr(t) + ',' + s + ',000';
    end else begin
      Money := '$' + IntToStr(i) + ',000';
    end;
  end else begin
    Money := '';
  end;
end;

function GotoNextCell(s: string; startpos: integer): integer;
var done: boolean;
begin
  done := false;
  {continue until <TD -tag found}
  while (startpos <= length(s)) and not(done) do begin
    if s[startpos] = '<' then begin
      done := (Copy(s, startpos, 3) = '<TD');
      while s[startpos] <> '>' do startpos := startpos + 1;
    end;
    startpos := startpos + 1;
  end;
  GotoNextCell := startpos;
end;

function ReplaceNextText(s, nw: string; startpos: integer): string;
var s0: string;
    p, endpos: integer;
    done: boolean;
begin
  endpos := length(s);
  p := startpos;
  done := false;
  {skip all spaces and htm-tags until </...>}
  while (p <= endpos) and ((s[p] = ' ') or (s[p] = '<')) and not(done) do begin
    if s[p] = '<' then begin
      done := (Copy(s, p, 2) = '</');
      if not(done) then begin
        while s[p] <> '>' do p := p + 1;
        p := p + 1;
      end;
    end else begin
      p := p + 1;
    end;
  end;
  startpos := p;
  {look for next </TD>}
  p := Pos('</TD>', Copy(s, startpos, endpos - startpos + 1));
  if p > 0 then endpos := startpos + p - 2;
  {skip all spaces and html-tags from the end}
  p := endpos;
  while (p >= startpos) and ((s[p] = ' ') or (s[p] = '>')) do begin
    if s[p] = '>' then begin
      while s[p] <> '<' do p := p - 1;
    end;
    p := p - 1;
  end;
  endpos := p;

  if (nw = '0') or (nw = '') then nw := '&nbsp';

  s0 := Copy(s, 1, startpos - 1) + nw;
  if endpos < length(s) - 1 then
        s0 := s0 + Copy(s, endpos + 1, Length(s) - endpos);
  ReplaceNextText := s0;
end;

procedure SaveTeamFile(g: integer; fn: string);
var gg: TextFile;
    r, s, s0, t, Tom1, Tom2, Tom3, Tom4, Tom5: string;
    f, i, p, q, p0, q0, totval, piccount,  pickuplength, pickup2,
      p2: integer;
    pl, pics: boolean;

   function GetLine: string;
   var t, tag: string;
       i, j: integer;
   begin
     t := '';
     tag := '';
     while (tag <> '<P>') and (tag <> '</P>') and (tag <> '<BR>')
       and (tag <> '</TR>') and (r <> '') do begin
       i := Pos('<', r);
       if i = 0 then i := length(r) + 1;
       t := t + Copy(r, 1, i-1);
       r := Copy(r, i, length(r) - i + 1);
       j := Pos('>', r);
       tag := Uppercase(Copy(r, 1, j));
       r := Copy(r, j+1, length(r) - j);
       t := t + tag;
     end;
     GetLine := t;
   end;

begin
  pl := true;
  totval := 0;
  piccount := 0;
  AssignFile(gg, fn);
  Reset(gg);
  r := '';
  while not(eof(gg)) do begin
    ReadLn(gg, s);
    r := r + ' ' + Trim(s);
  end;
  CloseFile(gg);

  f := Pos('.', fn);
  AssignFile(gg, Copy(fn, 1, f-1) + '_new.htm');
  Rewrite(gg);

  if r <> '' then s := Trim(GetLine);
  while (s <> '') or (r <> '') do begin
    if (Pos('<TR', UpperCase(s)) > 0)
    and (Pos('</TR>', Uppercase(s)) = 0) then begin
      s0 := GetLine;
      while (Pos('</TR>', UpperCase(s0)) = 0) and (r <> '') do begin
        s := s + ' ' + Trim(s0);
        s0 := GetLine;
      end;
      s := s + ' ' + s0;
    end;
    p := Pos('RE-ROLLS:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, IntToStr(team[g].reroll), p);
      p := GotoNextCell(s, p);
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(team[g].reroll * team[g].rerollcost), p);
      totval := totval + team[g].reroll * team[g].rerollcost;
    end;
    p := Pos('FAN FACTOR:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, IntToStr(team[g].ff), p);
      p := GotoNextCell(s, p);
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(team[g].ff * 10), p);
      totval := totval + team[g].ff * 10;
    end;
    p := Pos('ASSISTANT COACHES:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, IntToStr(team[g].asstcoaches), p);
      p := GotoNextCell(s, p);
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(team[g].asstcoaches * 10), p);
      totval := totval + team[g].asstcoaches * 10;
    end;
    p := Pos('CHEERLEADERS:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, IntToStr(team[g].cheerleaders), p);
      p := GotoNextCell(s, p);
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(team[g].cheerleaders * 10), p);
      totval := totval + team[g].cheerleaders * 10;
    end;
    p := Pos('APOTHECARY:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, IntToStr(team[g].apot), p);
      p := GotoNextCell(s, p);
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(team[g].apot * 50), p);
      totval := totval + team[g].apot * 50;
    end;
    if Pos('HALFLING', Uppercase(team[g].race)) > 0 then
      p := Pos('MASTER CHEF:', UpperCase(s))
    else
      p := Pos('TEAM WIZARD:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, IntToStr(team[g].wiz), p);
      p := GotoNextCell(s, p);
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(team[g].wiz * 150), p);
      totval := totval + team[g].wiz * 150;
    end;
    p := Pos('TREASURY:', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(MoneyVal(team[g].treasury)), p);
    end;
    p := Pos('COST OF TEAM', UpperCase(s));
    if p > 0 then begin
      p := GotoNextCell(s, p);
      s := ReplaceNextText(s, Money(totval), p);
    end;
    s0 := '';
    p := Pos('TEAM PICTURES', UpperCase(s));
    if p > 0 then begin
      q := Pos('TEAM PICTURES END', UpperCase(s));
      if (p=q) and pics then p := 1;
      if q = 0 then q := Length(s);
      pics := true;
    end else if pics then begin
      p := 1;
      q := Length(s);
    end;
    if pics then begin
      p0 := p-1 + Pos('SRC="', Copy(s, p, Length(s)));
      pickuplength := 4;
      pickup2 := 0;
      while (p0 > p) and (p0 < q) and (piccount < team[g].numplayers) do begin
        q0 := p0+pickuplength+ Pos('"', Copy(s, p0+5, length(s)))+2;
        piccount := piccount + 1;
        q := q + p0 + 5 - q0 + length(allPlayers[g,piccount].picture) +
          (pickuplength-2);
        if p2 = 1 then pickuplength := 4;
        s := Copy(s, 1, p0+pickuplength) + allPlayers[g,piccount].picture + '">' +
               CHR(13) + CHR(10) + Copy(s, q0+pickup2, Length(s));
        Tom1 := Copy(s, 1, p0+pickuplength);
        Tom2 := Copy(s, q0+pickup2, Length(s));
        Tom3 := Copy(s, 1, q);
        Tom4 := Copy(s, q+1, length(s));
        p0 := Pos('SRC="', Copy(s, (q0-2), Length(s)));
        p2 := Pos('SRC=""', Copy(s, (q0-2)+p0-1, Length(s)));
        if p0 > 0 then p0 := q0 - 1 + p0;
        if p2 = 1 then p0 := p0 - 2;
        Tom5 := Copy(s, p0+5, length(s));
        pickuplength := 2;
        pickup2 := 2;
      end;
    end;
    p := Pos('>#<', s);
    if (p > 0) and pl then begin
      pl := false;
      Writeln(gg, s);
      s := Trim(GetLine);
      while Pos('<TR', Uppercase(s)) = 0 do begin
        Writeln(gg, s);
        s := GetLine;
      end;
      while Pos('</TR>', Uppercase(s)) = 0 do begin
        t := GetLine;
        s := s + ' ' + Trim(t);
      end;
      for f := 1 to team[g].numplayers do begin
        p := Pos('<TR', s);
        p := GotoNextCell(s, p);
        {Tom Change:  Added code to remove sent off Dead players}
        if (allPlayers[g,f].status = 8) or (allPlayers[g,f].status = 11) or
           (allPlayers[g,f].SOstatus = 8) then begin
          {remove DEAD and retired players}
          s := ReplaceNextText(s, IntToStr(allPlayers[g,f].cnumber), p);
          for i := 1 to 15 do begin
            p := GotoNextCell(s, p);
            s := ReplaceNextText(s, '', p);
          end;

        end else begin
          s := ReplaceNextText(s, IntToStr(allPlayers[g,f].cnumber), p);
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s, allPlayers[g,f].name, p);
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s, allPlayers[g,f].position, p);
          p := GotoNextCell(s, p);
          q := allPlayers[g,f].ma;
          t := '';
          {Added code for Seriously Injured Sent Off players}
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 2)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 2)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 11)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 11)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 15)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 15)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 16)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 16)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 18)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 18))
             then begin
            q := q - 1;
            t := t + '-1 MA';
          end;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 17)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 17))
             then begin
            q := q - 2;
            t := t + '-1 MA, -1 MA';
          end;
          if (Uppercase(team[g].race) <> 'NURGLES ROTTERS') and (q<1) then q := 1;
          s := ReplaceNextText(s, IntToStr(q), p);
          p := GotoNextCell(s, p);
          q := allPlayers[g,f].st;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 3)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 3)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 12)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 12)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 15)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 15)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 20)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 20)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 21)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 21))
            then begin
            q := q - 1;
            t := t + '-1 ST';
          end;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 19)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 19))
            then begin
            q := q - 2;
            t := t + '-1 ST, -1 ST';
          end;
          if (Uppercase(team[g].race) <> 'NURGLES ROTTERS') and (q<1) then q := 1;
          s := ReplaceNextText(s, IntToStr(q), p);
          p := GotoNextCell(s, p);
          q := allPlayers[g,f].ag;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 4)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 4)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 13)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 13)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 16)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 16)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 20)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 20)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 23)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 23))
            then begin
            q := q - 1;
            t := t + '-1 AG';
          end;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 22)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 22))
            then begin
            q := q - 2;
            t := t + '-1 AG, -1 AG';
          end;
          if (Uppercase(team[g].race) <> 'NURGLES ROTTERS') and (q<1) then q := 1;
          s := ReplaceNextText(s, IntToStr(q), p);
          p := GotoNextCell(s, p);
          q := allPlayers[g,f].av;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 5)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 5)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 14)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 14)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 18)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 18)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 21)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 21)) or
             ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 23)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 23))
            then begin
            q := q - 1;
            t := t + '-1 AV';
          end;
          if ((allPlayers[g,f].status = 7) and (allPlayers[g,f].SIstatus = 24)) or
             ((allPlayers[g,f].SOstatus = 7) and (allPlayers[g,f].SOSIstatus = 24))
            then begin
            q := q - 2;
            t := t + '-1 AV, -1 AV';
          end;
          if (Uppercase(team[g].race) <> 'NURGLES ROTTERS') and (q<1) then q := 1;
          s := ReplaceNextText(s, IntToStr(q), p);
          p := GotoNextCell(s, p);
          s0 := allPlayers[g,f].GetSkillString(1);
          if t <> '' then begin
            if s0 = '' then s0 := t else s0 := s0 + ', ' + t;
          end;
          s := ReplaceNextText(s, s0, p);
          p := GotoNextCell(s, p);
          t := allPlayers[g,f].inj;
          if (t <> '') and (t[1] = 'M') then t := Copy(t, 2, Length(t) - 1);
          if (allPlayers[g,f].status = 7) or (allPlayers[g,f].SOstatus = 7) or
            (allPlayers[g,f].SIAgestatus > 0) then begin
            t := 'M' + t;
            if (allPlayers[g,f].SIstatus = 1) or (allPlayers[g,f].SOSIstatus = 1) or
               (allPlayers[g,f].SIstatus = 10) or (allPlayers[g,f].SOSIstatus = 10) or
               (allPlayers[g,f].SIstatus = 11) or (allPlayers[g,f].SOSIstatus = 11) or
               (allPlayers[g,f].SIstatus = 12) or (allPlayers[g,f].SOSIstatus = 12) or
               (allPlayers[g,f].SIstatus = 13) or (allPlayers[g,f].SOSIstatus = 13) or
               (allPlayers[g,f].SIstatus = 14) or (allPlayers[g,f].SOSIstatus = 14)
               then t := t + 'N';
            if (allPlayers[g,f].SIstatus = 10) or (allPlayers[g,f].SOSIstatus = 10)
               then t := t + 'N';
          end;
          s := ReplaceNextText(s, t, p);

          p := GotoNextCell(s, p);
          s := ReplaceNextText(s,
                IntToStr(allPlayers[g,f].comp + allPlayers[g,f].comp0), p);
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s,
                IntToStr(allPlayers[g,f].td + allPlayers[g,f].td0), p);
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s,
                IntToStr(allPlayers[g,f].int + allPlayers[g,f].int0), p);
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s,
                IntToStr(allPlayers[g,f].cas + allPlayers[g,f].cas0), p);
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s,
                IntToStr(allPlayers[g,f].mvp + allPlayers[g,f].mvp0), p);

          p := GotoNextCell(s, p);
          if allPlayers[g,f].peaked then begin
            s := ReplaceNextText(s, 'P', p);
          end
          else
          begin
            s := ReplaceNextText(s, IntToStr(allPlayers[g,f].GetStartingSPP() + allPlayers[g,f].GetMatchSPP()), p);
          end;                                                                      
          p := GotoNextCell(s, p);
          s := ReplaceNextText(s, Money(allPlayers[g,f].value), p);
          totval := totval + allPlayers[g,f].value;
        end;
        Writeln(gg, s);
      end;
      while (Pos('TEAM:', Uppercase(s)) = 0)
        and (Pos('TEAM NAME:', Uppercase(s)) = 0) do s := GetLine;
    end else begin
      Writeln(gg, s);
      s := GetLine;
    end;
  end;
  CloseFile(gg);
  ShowMessage(Copy(fn, 1, Pos('.', fn) - 1) + '_new.htm created');
end;

procedure RecordInRegistry(gameid: string; len: integer);
var Reg: TRegistry;
    KeyInfo: TRegKeyInfo;
    curval, s, t: string;
    f, p, p2, p3, q, r, prevlen, curnr, freenr, cnt: integer;
    found: boolean;
    checkdate: TDateTime;
    DateSeparator: AnsiChar;
    fmt: TFormatSettings;
begin
  DateSeparator := '-';
  p := 0;
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_CURRENT_USER;
    s := '\Software\RLTool';
    Reg.Access := KEY_ALL_ACCESS;
    if Reg.OpenKey(s, true) then begin
      Reg.GetKeyInfo(KeyInfo);
      found := false;
      curnr := 1;
      cnt := 0;
      freenr := 0;
      if KeyInfo.NumValues > 0 then begin
        while (cnt < KeyInfo.NumValues) and not(found) do begin
          curval := 'game' + IntToStr(curnr);
          if Reg.ValueExists(curval) then begin
            cnt := cnt + 1;
            t := Reg.ReadString(curval);
            p := Pos('|', t);
            if Copy(t, 1, p - 1) = gameid then begin
              found := true;
            end else begin
              {check for cleanup}
              q := Pos('\', t);
              try
                GetLocaleFormatSettings(0, fmt);

                fmt.DateSeparator := '-';

                checkdate := StrToDate(Copy(t, q+1, Length(t) - q), fmt);
              except
                on EConvertError do begin
                  s := Copy(t, q+1, Length(t) - q);
                  while Pos(' ', s) > 0 do begin
                    p := Pos(' ', s);
                    s := Copy(s, 1, p-1) + DateSeparator +
                                        Copy(s, p+1, length(s) - p);
                  end;
                  for f := 1 to 12 do begin
                    p := Pos(UpperCase(FormatSettings.LongMonthNames[f]), UpperCase(s));
                    if p > 0 then begin
                      s := Copy(s, 1, p-1) + IntToStr(f) +
                         Copy(s, p + Length(FormatSettings.LongMonthNames[f]), length(s));
                    end;
                  end;
                  for f := 1 to 12 do begin
                    p := Pos(UpperCase(FormatSettings.ShortMonthNames[f]), UpperCase(s));
                    if p > 0 then begin
                      s := Copy(s, 1, p-1) + IntToStr(f) +
                         Copy(s, p + Length(FormatSettings.ShortMonthNames[f]), length(s));
                    end;
                  end;
                  try
                    checkdate := StrToDate(s);
                  except
                    on EConvertError do begin
                      AddToGameLog(') ALERT UNKNOWN DATE: ' + s);
                      checkdate := Date - 61;
                    end;
                  end;
                end;
              end;
              {if 60 days nothing happened then it is removed}
              if checkdate + 60 < Date then begin
                Reg.DeleteValue(curval);
                if freenr = 0 then freenr := curnr;
              end;
              curnr := curnr + 1;
            end;
          end else begin
            if freenr = 0 then freenr := curnr;
            curnr := curnr + 1;
          end;
        end;
      end;
      r := 0;
      if freenr = 0 then freenr := curnr;
      if not(found) then begin
        {AddToGameLog(')=N0' + LoggedCoach + '@' + DateTimeToStr(Now) +
           '%' + LDFILEDT + '$' + PBeMVersion);
        curnr := freenr;}
      end else begin
        q := Pos('\', t);
        prevlen := FVal(Copy(t, p+2, q-p-2));
        if prevlen >= len then r := Ord(t[p+1]) - 47;  {= - 48 + 1}
        AddToGameLog(')=R' + Chr(r + 48) +
                            LoggedCoach + '@' + DateTimeToStr(Now) +
                            '%' + LDFILEDT + '$' + PBeMVersion);
        LoadedFile := 'TT'+Chr(r + 48) + LoggedCoach + '@'
          + DateTimeToStr(Now) +
          '%' + LDFILEDT + '$' + PBeMVersion;
        LoadedFlag := true;
      end;
      Reg.WriteString('game' + IntToStr(curnr),
             gameid + '|' + Chr(r + 48) + IntToStr(len) + '\' +
             DateToStr(Date));
    end;
  finally
    Reg.CloseKey;
    Reg.Free;
  end;
end;

end.
