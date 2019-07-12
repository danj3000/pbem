unit unitPregame;

interface

procedure PregameEnableDisable;
procedure NigglesOrStart;

function TranslateHandicapTable: string;
procedure PlayActionHandicapTable(s: string; dir: integer);
procedure PlayActionHandicap(s: string; dir: integer);
procedure WorkOutHandicap;
procedure PlayActionNiggles(s: string; dir: integer);
procedure PlayActionNiggleResult(s: string; dir: integer);
procedure WorkOutNiggles;
procedure PlayActionToss(s: string; dir: integer);
procedure WorkOutToss;

implementation

uses Dialogs, Graphics, SysUtils,
     bbunit, bbalg, unitLog, unitPlayAction, unitTurnChange, unitRandom,
     unitArmourRoll, unitHandicapTable, unitSettings;

procedure PregameEnableDisable;
begin
  Bloodbowl.ButLoadRed.enabled := true;
  Bloodbowl.ButLoadBlue.enabled := true;
  Bloodbowl.ButWeather.enabled := false;
  Bloodbowl.ButGate.enabled := false;
  Bloodbowl.ButHandicap.enabled := false;
  Bloodbowl.ButCardsRed.enabled := false;
  Bloodbowl.ButCardsBlue.enabled := false;
  Bloodbowl.butMakeHandicapRolls.enabled := false;
  Bloodbowl.ButNiggles.enabled := false;
  Bloodbowl.ButToss.enabled := false;
  Bloodbowl.ButStart.enabled := false;
  Bloodbowl.PregamePanel.visible := true;
  Bloodbowl.PregamePanel.BringToFront;

  Bloodbowl.LblRedTeam.caption := '';
  Bloodbowl.LblBlueTeam.caption := '';
  Bloodbowl.lblHomeTV.caption := '';
  Bloodbowl.lblAwayTV.caption := '';

  Bloodbowl.LblWeather.caption := '';
  Bloodbowl.LblGate.caption := '';
  Bloodbowl.LblHandicap.caption := '';
  Bloodbowl.LblCardsRed.caption := '';
  Bloodbowl.LblCardsBlue.caption := '';
  Bloodbowl.LblNiggles.caption := '';
  Bloodbowl.ImRedDie.visible := false;
  Bloodbowl.ImBlueDie.visible := false;
  Bloodbowl.lblToss.caption := '';
end;

procedure NigglesOrStart;
var f, g: integer;
    b: boolean;
begin
  if ((frmSettings.rgCardSystem.ItemIndex < 3)
      and (not(Bloodbowl.ButCardsRed.enabled)
           and not(Bloodbowl.ButCardsBlue.enabled)))
  or ((frmSettings.rgCardSystem.ItemIndex >= 3) and
           (not(Bloodbowl.butMakeHandicapRolls.enabled)))
  then begin
    b := false;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if (allPlayers[g,f].status = 9) then begin
          b := true;
        end;
      end;
    end;
    if b then begin
      Bloodbowl.ButNiggles.enabled := true;
    end else begin
      if PalmedCoin then begin
        Bloodbowl.butStart.enabled := true;
        Bloodbowl.butToss.Enabled := false;
      end else Bloodbowl.ButToss.enabled := true;
    end;
  end;
end;

procedure PlayActionHandicap(s: string; dir: integer);
begin
  if dir = 1 then begin
    team[0].bonusCards := Ord(s[3]) - 48;
    team[0].bonusMVP := Ord(s[4]) - 48;
    team[1].bonusCards := Ord(s[5]) - 48;
    team[1].bonusMVP := Ord(s[6]) - 48;
    DefaultAction(TranslateHandicap);
    Bloodbowl.ButHandicap.enabled := false;
    Bloodbowl.ButCardsRed.enabled := true;
    Bloodbowl.ButCardsBlue.enabled := true;
  end else begin
    BackLog;
    Bloodbowl.LblHandicap.caption := '';
    Bloodbowl.ButHandicap.enabled := true;
    Bloodbowl.ButCardsRed.enabled := false;
    Bloodbowl.ButCardsBlue.enabled := false;
  end;
end;

function TranslateHandicapTable: string;
begin
  if frmSettings.rgCardSystem.ItemIndex = 3 then begin
    TranslateHandicapTable := 'Number of rolls on Handicap Table: '
                 + IntToStr(NumHandicaps);
    frmHandicapTable.top := 107;
  end;
  if frmSettings.rgCardSystem.ItemIndex = 4 then begin
    TranslateHandicapTable := 'Points to spend on Handicap Table: '
                 + IntToStr(NumHandicaps);
  end;
end;

procedure PlayActionHandicapTable(s: string; dir: integer);
begin
  if dir = 1 then begin
    NumHandicaps := Ord(s[3]) - 48;
    DefaultAction(TranslateHandicapTable);
    if NumHandicaps = 0 then
      Bloodbowl.LblHandicap.font.color := clPurple
    else if (team[0].tr < team[1].tr) then
      Bloodbowl.LblHandicap.font.color := colorarray[0,0,0]
    else
      Bloodbowl.LblHandicap.font.color := colorarray[1,0,0];
    Bloodbowl.lblHandicap.caption := TranslateHandicapTable;
    Bloodbowl.ButHandicap.enabled := false;
    if NumHandicaps = 0 then begin
      NigglesOrStart;
    end else begin
      Bloodbowl.butMakeHandicapRolls.enabled := true;
    end;
  end else begin
    BackLog;
    Bloodbowl.lblHandicap.caption := '';
    Bloodbowl.ButHandicap.enabled := true;
    Bloodbowl.butMakeHandicapRolls.enabled := false;
    Bloodbowl.butNiggles.enabled := false;
    Bloodbowl.butToss.enabled := false;
  end;
end;

procedure WorkOutHandicap;
var s, HT: string;
    m, v, k, bc, bm: integer;
    gg: TextFile;
begin
  if team[0].tr < team[1].tr then m := 0 else m := 1;
  v := team[1-m].tr - team[m].tr;
  if frmSettings.rgCardSystem.ItemIndex = 3 then begin
    if v <= 10 then NumHandicaps := 0 else
    if v <= 25 then NumHandicaps := 1 else
    if v <= 50 then NumHandicaps := 2 else
    if v <= 75 then NumHandicaps := 3 else
    if v <= 100 then NumHandicaps := 4 else NumHandicaps := 5;
    s := 'Dh' + Chr(48 + NumHandicaps);
    if CanWriteToLog then begin
      LogWrite(s);
      PlayActionHandicapTable(s, 1);
    end;
  end;
  if frmSettings.rgCardSystem.ItemIndex = 4 then begin
    if v <= 10 then NumHandicaps := 0 else
     NumHandicaps := v;
    s := 'Dh' + Chr(48 + NumHandicaps);
    if CanWriteToLog then begin
      LogWrite(s);
      PlayActionHandicapTable(s, 1);
    end;
  end;
  if frmSettings.rgCardSystem.ItemIndex >= 3 then begin
    if (Trim(frmSettings.txtHandicapTable.text)='H5') then begin
      AssignFile(gg, curdir + 'ini/bbtables.ini');
      Reset(gg);
      ReadLn(gg, s);
      HT := Trim(frmSettings.txtHandicapTable.text);
      while Copy(s, 2, length(HT)) <> HT do ReadLn(gg, s);
      ReadLn(gg, s);
      k := 12;
      while (k < length(s)) and (FVal(copy(s, k ,3)) <> 0)
            and (FVal(copy(s, k, 3)) < team[m].tr) do k := k + 8;
      ReadLn(gg, s);
      while (FVal(copy(s, 5, 3)) < v) and (FVal(copy(s, 5, 3)) <> 0)
            do ReadLn(gg, s);
      bc := FVal(copy(s, k-2, 1));
      bm := FVal(copy(s, k, 1));
      CloseFile(gg);
      team[m].bonusCards := bc;
      team[m].bonusMVP := bm;
      team[1-m].bonusCards := 0;
      team[1-m].bonusMVP := 0;
      s := 'DH' + Chr(48 + team[0].bonusCards) + Chr(48 + team[0].bonusMVP) +
           Chr(48 + team[1].bonusCards) + Chr(48 + team[1].bonusMVP);
      if CanWriteToLog then begin
        AddLog(TranslateHandicap);
        LogWrite(s);
      end;
      if (team[0].bonusCards > 0) or (team[0].bonusMVP > 0) then
        Bloodbowl.LblHandicap.font.color := colorarray[0,0,0]
      else if (team[1].bonusCards > 0) or (team[1].bonusMVP > 0) then
        Bloodbowl.LblHandicap.font.color := colorarray[1,0,0]
      else
        Bloodbowl.LblHandicap.font.color := clPurple;
      Bloodbowl.ButCardsRed.enabled := true;
      Bloodbowl.ButCardsBlue.enabled := true;
    end;
  end;
  if frmSettings.rgCardSystem.ItemIndex < 3 then begin
    AssignFile(gg, curdir + 'ini/bbtables.ini');
    Reset(gg);
    ReadLn(gg, s);
    HT := Trim(frmSettings.txtHandicapTable.text);
    while Copy(s, 2, length(HT)) <> HT do ReadLn(gg, s);
    ReadLn(gg, s);
    k := 12;
    while (k < length(s)) and (FVal(copy(s, k ,3)) <> 0)
          and (FVal(copy(s, k, 3)) < team[m].tr) do k := k + 8;
    ReadLn(gg, s);
    while (FVal(copy(s, 5, 3)) < v) and (FVal(copy(s, 5, 3)) <> 0)
          do ReadLn(gg, s);
    bc := FVal(copy(s, k-2, 1));
    bm := FVal(copy(s, k, 1));
    CloseFile(gg);
    team[m].bonusCards := bc;
    team[m].bonusMVP := bm;
    team[1-m].bonusCards := 0;
    team[1-m].bonusMVP := 0;
    s := 'DH' + Chr(48 + team[0].bonusCards) + Chr(48 + team[0].bonusMVP) +
         Chr(48 + team[1].bonusCards) + Chr(48 + team[1].bonusMVP);
    if CanWriteToLog then begin
      AddLog(TranslateHandicap);
      LogWrite(s);
    end;
    if (team[0].bonusCards > 0) or (team[0].bonusMVP > 0) then
      Bloodbowl.LblHandicap.font.color := colorarray[0,0,0]
    else if (team[1].bonusCards > 0) or (team[1].bonusMVP > 0) then
      Bloodbowl.LblHandicap.font.color := colorarray[1,0,0]
    else
      Bloodbowl.LblHandicap.font.color := clPurple;
    Bloodbowl.ButCardsRed.enabled := true;
    Bloodbowl.ButCardsBlue.enabled := true;
  end;
  Bloodbowl.ButHandicap.enabled := false;
end;

procedure PlayActionNiggles(s: string; dir: integer);
begin
  if dir = 1 then begin
    Bloodbowl.LblNiggles.top := 334;
    Bloodbowl.LblNiggles.height := 15;
    DefaultAction(TranslateNiggle(s));
    Bloodbowl.ButNiggles.enabled := false;
    if PalmedCoin then Bloodbowl.butStart.enabled := true else
      Bloodbowl.ButToss.enabled := true;
  end else begin
    BackLog;
  end;
end;

procedure PlayActionNiggleResult(s: string; dir: integer);
var f, g: integer;
begin
  g := Ord(s[3]) - 48;
  f := Ord(s[4]) - 64;
  if dir = 1 then begin
    DefaultAction(TranslateNiggleResult(s));
    if s[5] = '0' then allPlayers[g,f].SetStatusDef(0);
  end else begin
    allPlayers[g,f].SetStatusDef(9);
    BackLog;
    Bloodbowl.LblNiggles.caption := '';
    Bloodbowl.ButNiggles.enabled := true;
    Bloodbowl.ButToss.enabled := false;
  end;
end;

procedure WorkOutNiggles;
var f, g, p, r, r2: integer;
    s, t: string;
begin
  NumNiggles := 0;
  Bloodbowl.LblNiggles.caption := '';
  Bloodbowl.LblNiggles.top := 334;
  Bloodbowl.LblNiggles.height := 15;
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      {look for niggled players}
      if (allPlayers[g,f].status = 9) then begin
        s := allPlayers[g,f].inj;
        p := Pos('N', Uppercase(s));
        {roll for each N until all done, or 1 rolled}
        repeat begin
          r := Rnd(6,6) + 1;
          r2 := Rnd(6,6) + 1;

          t := 'DN' + Chr(g + 48) + Chr(f + 64) + Chr(r + 48);
          if CanWriteToLog then begin
            AddLog(TranslateNiggle(t));
            LogWrite(t);
          end;
          s := Copy(s, p+1, Length(s) - p);
          p := Pos('N', Uppercase(s));
          Continuing := true;
        end until (r = 1) or (p = 0);
        t := 'Dn' + Chr(g + 48) + Chr(f + 64);
        if r <> 1 then begin
          t := t + '0';
          allPlayers[g,f].SetStatusDef(0);
        end else begin
          t := t + '1';
        end;
        if CanWriteToLog then begin
          AddLog(TranslateNiggleResult(t));
          LogWrite(t);
        end;
      end;
    end;
  end;
  Bloodbowl.ButNiggles.enabled := false;
  if PalmedCoin then Bloodbowl.butStart.enabled := true else
    Bloodbowl.ButToss.enabled := true;
  Continuing := false;
end;

function TranslateToss(s: string): string;
begin
  TranslateToss := team[Ord(s[3]) - 48].name + ' wins the toss';
end;

procedure PlayActionToss(s: string; dir: integer);
begin
  if dir = 1 then begin
    Bloodbowl.lblToss.caption := TranslateToss(s);
    Bloodbowl.lblToss.font.color := colorarray[FVal(s[3]),0,0];
    DefaultAction(TranslateToss(s));
    Bloodbowl.butToss.enabled := false;
    Bloodbowl.butStart.enabled := true;
  end else begin
    BackLog;
    Bloodbowl.lblToss.caption := '';
    if PalmedCoin then begin
      Bloodbowl.butToss.enabled := false;
      Bloodbowl.butStart.enabled := true;
    end else begin
      Bloodbowl.butToss.enabled := true;
      Bloodbowl.butStart.enabled := false;
    end;
  end;
end;

procedure WorkOutToss;
var s: string;
begin
  if CanWriteToLog then begin
    s := 'DT' + Chr(Rnd(2,6) + 48);
    LogWrite(s);
    PlayActionToss(s, 1);
  end;
end;

end.
