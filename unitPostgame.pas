unit unitPostgame;

interface

procedure PlayActionStartPostGame(s: string; dir: integer);
procedure PlayActionMatchWinnings(s: string; dir: integer);
procedure MatchWinnings(tm: integer);
procedure PlayActionMatchWinningsMod(s: string; dir: integer);
procedure MatchWinningsModifier(tm: integer);
procedure CreateMVPplayer(tm, pl: integer);
procedure PlayActionMVP(s: string; dir: integer);
procedure MVP(tm: integer);

implementation

uses Classes, Dialogs,
     unitPlayer, bbunit, unitLog, bbalg, unitPlayAction, unitFanFactor,
     unitMarker, unitRandom, unitTeam;

var MatchResult: array [0..2] of string;

procedure PlayActionStartPostGame(s: string; dir: integer);
begin
  if dir = 1 then begin
    SetFanFactorModifiers;
    Bloodbowl.GBPostgameRed.caption := team[0].name;
    Bloodbowl.GBPostgameBlue.caption := team[1].name;
    Bloodbowl.PostgamePanel.visible := true;
    Bloodbowl.PostgamePanel.BringToFront;
    DefaultAction('Start of Post-Game Sequence');
  end else begin
    Bloodbowl.PostgamePanel.visible := false;
    BackLog;
  end;
  MatchResult[0] := 'Lost Match';
  MatchResult[1] := 'Tied Match';
  MatchResult[2] := 'Won Match';
end;

procedure PlayActionMatchWinnings(s: string; dir: integer);
var tm, r, result, mw, w, t: integer;
    s0: string;
begin
  tm := Ord(s[3]) - 48;
  if dir = 1 then begin
    r := Ord(s[4]) - 64;
    mw := Ord(s[5]) - 64;
    result := Ord(s[6]) - 65;
    w := Ord(s[7]) - 64;
    t := Ord(s[8]) - 64;
    if tm = 0 then begin
      Bloodbowl.ImMWDieRed.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + '.bmp');
      Bloodbowl.ImMWDieRed.visible := true;
      Bloodbowl.LblMWWTLRed.hint := MatchResult[result];
      Bloodbowl.LblMWRollRed.caption := IntToStr(r);
      Bloodbowl.LblMWTableRed.caption := IntToStr(mw);
      Bloodbowl.LblMWWTLRed.caption := IntToStr(w + t);
      Bloodbowl.TxtMWModRed.enabled := true;
      Bloodbowl.LblMWTotRed.caption := IntToStr(team[tm].matchwinnings) + '0';
      Bloodbowl.ButMWRed.enabled := false;
      Bloodbowl.ButPurchaseRed.enabled := true;
    end else begin
      Bloodbowl.ImMWDieBlue.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + 'b.bmp');
      Bloodbowl.ImMWDieBlue.visible := true;
      Bloodbowl.LblMWWTLBlue.hint := MatchResult[result];
      Bloodbowl.LblMWRollBlue.caption := IntToStr(r);
      Bloodbowl.LblMWTableBlue.caption := IntToStr(mw);
      Bloodbowl.LblMWWTLBlue.caption := IntToStr(w + t);
      Bloodbowl.TxtMWModBlue.enabled := true;
      Bloodbowl.LblMWTotBlue.caption := IntToStr(r + mw + w + t) + '0';
      Bloodbowl.ButMWBlue.enabled := false;
      Bloodbowl.ButPurchaseBlue.enabled := true;
    end;
    s0 := 'Match winnings for ' + ffcl[tm] + ': ' + IntToStr(r);
    s0 := s0 + ' + ' + IntToStr(mw) + ' (Match Winnings Table)';
    if w > 0 then s0 := s0 + ' + ' + IntToStr(w) + ' (Won Match)';
    if t > 0 then s0 := s0 + ' + ' + IntToStr(t) + ' (Tied Match)';
    s0 := s0 + ' x10k = ' + IntToStr(r + mw + w + t) + '0k';
    DefaultAction(s0);
  end else begin
    if tm = 0 then begin
      Bloodbowl.ImMWDieRed.visible := false;
      Bloodbowl.LblMWWTLRed.hint := '';
      Bloodbowl.LblMWRollRed.caption := '';
      Bloodbowl.LblMWTableRed.caption := '';
      Bloodbowl.LblMWWTLRed.caption := '';
      Bloodbowl.TxtMWModRed.enabled := false;
      Bloodbowl.LblMWTotRed.caption := '';
      Bloodbowl.ButMWRed.enabled := true;
      Bloodbowl.ButPurchaseRed.enabled := false;
    end else begin
      Bloodbowl.ImMWDieBlue.visible := false;
      Bloodbowl.LblMWWTLBlue.hint := '';
      Bloodbowl.LblMWRollBlue.caption := '';
      Bloodbowl.LblMWTableBlue.caption := '';
      Bloodbowl.LblMWWTLBlue.caption := '';
      Bloodbowl.TxtMWModBlue.enabled := false;
      Bloodbowl.LblMWTotBlue.caption := '';
      Bloodbowl.ButMWBlue.enabled := true;
      Bloodbowl.ButPurchaseBlue.enabled := false;
    end;
    BackLog;
  end;
end;

procedure MatchWinnings(tm: integer);
var s: string;
    result, r, mw, k, w, t: integer;
    gg: TextFile;
begin
  {roll die}
  r := Rnd(6) + 1;
  {get modifier from Match Winnings Table}
  AssignFile(gg, curdir + 'ini\bbtables.ini');
  Reset(gg);
  ReadLn(gg, s);
  while Copy(s, 2, length(MWTable)) <> MWTable do ReadLn(gg, s);
  ReadLn(gg, s);
  k := 12;
  while (k < length(s)) and (FVal(copy(s, k ,3)) <> 0)
        and (FVal(copy(s, k, 3)) < team[tm].tr) do k := k + 8;
  ReadLn(gg, s);
  while (FVal(copy(s, 5, 3)) < Gate) and (FVal(copy(s, 5, 3)) <> 0)
        do ReadLn(gg, s);
  {TOM CHANGE: original code was:  mw := FVal(copy(s, k - 1, 1));}
  mw := FVal(copy(s, k - 1, 2));
  CloseFile(gg);

  {get Won Match/Tied Match modifier}
  w := 0;
  t := 0;
  if marker[tm, MT_Score].value > marker[1-tm, MT_Score].value then begin
    w := WonMatchMod;
    result := 2;
  end else begin
    if marker[tm, MT_Score].value = marker[1-tm, MT_Score].value then begin
      if TiedMatchMod > 0 then t := TiedMatchMod;
      result := 1;
    end else begin
      result := 0;
    end;
  end;

  mw := 8;

  s := 'w0' + Chr(tm + 48) + Chr(r + 64) + Chr(mw + 64) +
             Chr(result + 65) + Chr(w + 64) + Chr(t + 64);
  if CanWriteToLog then begin
    PlayActionMatchWinnings(s, 1);
    LogWrite(s);
  end;
end;

procedure PlayActionMatchWinningsMod(s: string; dir: integer);
var tm, m, p: integer;
begin
  tm := Ord(s[3]) - 64;
  p := Pos('~', s);
  if dir = 1 then begin
    m := FVal(Copy(s, p + 1, Length(s) - p));
    DefaultAction(ffcl[tm] + ': Match Winnings Modified by ' + IntToStr(m));
  end else begin
    m := FVal(Copy(s, 4, p - 4));
    if tm = 0 then Bloodbowl.TxtMwModRed.Text := ''
              else Bloodbowl.TxtMwModBlue.Text := '';
    BackLog;
  end;
  team[tm].matchwinningsmod := m;
  if tm = 0 then begin
    if m = 0 then Bloodbowl.TxtMwModRed.Text := ''
             else Bloodbowl.TxtMwModRed.Text := IntToStr(m);
    Bloodbowl.LblMWTotRed.caption :=
       IntToStr(10 * team[tm].matchwinnings + team[tm].matchwinningsmod);
  end else begin
    if m = 0 then Bloodbowl.TxtMwModBlue.Text := ''
             else Bloodbowl.TxtMwModBlue.Text := IntToStr(m);
    Bloodbowl.LblMWTotBlue.caption :=
       IntToStr(10 * team[tm].matchwinnings + team[tm].matchwinningsmod);
  end;
end;

procedure MatchWinningsModifier(tm: integer);
var m: integer;
    s: string;
begin
  if tm = 0 then
    m := FVal(Bloodbowl.TxtMwModRed.Text)
  else
    m := FVal(Bloodbowl.TxtMwModBlue.Text);
  if m <> team[tm].matchwinningsmod then begin
    if 10 * team[tm].matchwinnings + m < 0 then begin
      ShowMessage('You can''t lose money on Match Winnings!');
      if tm = 0 then Bloodbowl.TxtMwModRed.Text := ''
                else Bloodbowl.TxtMwModBlue.Text := '';
    end else begin
      s := 'w1' + Chr(tm + 64) + IntToStr(team[tm].matchwinningsmod) + '~' +
           IntToStr(m);
      if CanWriteToLog then begin
        PlayActionMatchWinningsMod(s, 1);
        LogWrite(s);
      end;
    end;
  end;
end;

procedure CreateMVPplayer(tm, pl: integer);
begin
  MVPplayer[tm,pl].autosize := false;
  MVPplayer[tm,pl].height := 19;
  MVPplayer[tm,pl].width := 19;
  MVPplayer[tm,pl].visible := false;
  MVPplayer[tm,pl].alignment := taCenter;
  MVPplayer[tm,pl].font.size := 12;
  MVPplayer[tm,pl].left := 20 * pl - 12;
  MVPplayer[tm,pl].top := 130;

  if tm = 0 then MVPplayer[tm,pl].parent := Bloodbowl.GBPostgameRed
            else MVPplayer[tm,pl].parent := Bloodbowl.GBPostgameBlue;
end;

procedure PlayActionMVP(s: string; dir: integer);
var c, f, tm: integer;
    s0: string;
begin
  tm := Ord(s[2]) - 48;
  if dir = 1 then begin
    s0 := 'Most Valuable Player for ' + ffcl[tm] + ': ';
    for c := 3 to Length(s) do begin
      f := Ord(s[c]) - 64;
      player[tm,f].mvp := 1;
      if c > 3 then s0 := s0 + ', ';
      s0 := s0 + IntToStr(player[tm,f].cnumber);
      MVPplayer[tm, c-2].Color := player[tm,f].color;
      MVPplayer[tm, c-2].font.Color := player[tm,f].font.color;
      MVPplayer[tm, c-2].caption := IntToStr(player[tm,f].cnumber);
      MVPplayer[tm, c-2].visible := true;
    end;
    DefaultAction(s0);
    if tm = 0 then Bloodbowl.ButMVPRed.enabled := false
              else Bloodbowl.ButMVPBlue.enabled := false;
    if tm = 0 then Bloodbowl.ButSkillrollRed.enabled := true
              else Bloodbowl.ButSkillrollBlue.enabled := true;
  end else begin
    if tm = 0 then Bloodbowl.ButMVPRed.enabled := true
              else Bloodbowl.ButMVPBlue.enabled := true;
    if tm = 0 then Bloodbowl.ButSkillrollRed.enabled := false
              else Bloodbowl.ButSkillrollBlue.enabled := false;
    for f := 1 to team[tm].numplayers do player[tm,f].mvp := 0;
    for f := 1 to 10 do MVPplayer[tm,f].visible := false;
    BackLog;
  end;
end;

procedure MVP(tm: integer);
var c, f, r, numEligible: integer;
    gotMVP: array [1..MaxNumPlayersInTeam] of boolean;
    s: string;
begin
  s := 'D' + Chr(tm + 48);
  c := 0;
  numEligible := 0;
  for f := 1 to team[tm].numplayers do
    OkayforMVP := false;
    if ((player[tm,f].PlayedThisMatch) and not (NoMVPs)) or
       ((frmSettings.MVPBench.checked) and (player[tm,f].status<>9) and
      (player[tm,f].status<>10) and not (NoMVPs)) or
       ((frmSettings.MVPBench.checked) and (player[tm,f].status<>9) and
      (player[tm,f].status<>10) and (NoMVPs) and
      not (player[tm,f].status = 8) and not (player[tm,f].HasSkill('No MVPs'))) or
      ((player[tm,f].PlayedThisMatch) and (NoMVPs) and
      not (player[tm,f].status = 8) and not (player[tm,f].HasSkill('No MVPs')))
      then numEligible := numEligible + 1;
  for f := 1 to team[tm].numplayers do gotMVP[f] := false;
  while (c <= team[tm].bonusMVP) and (c < numEligible) do begin
    r := Rnd(team[tm].numplayers) + 1;
    while ((not(player[tm,r].PlayedThisMatch) and not(frmSettings.MVPBench.checked))
         or (gotMVP[r])) and
        ((frmSettings.MVPBench.checked) and ((player[tm,r].status = 9) or
        (player[tm,r].status = 10))) and
        ((player[tm,r].HasSkill('No MVPs')) and (NoMVPs)) and
        ((player[tm,r].status = 8) and (NoMVPs))
      do r := Rnd(team[tm].numplayers) + 1;
    gotMVP[r] := true;
    s := s + Chr(r + 64);
    c := c + 1;
  end;
  if CanWriteToLog then begin
    PlayActionMVP(s, 1);
    LogWrite(s);
  end;
end;

end.
