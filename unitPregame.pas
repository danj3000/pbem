unit unitPregame;

interface

procedure PregameEnableDisable;
procedure NigglesOrStart;
procedure WeatherTableClick;
procedure WeatherPickClick(r3: integer);
procedure PlayActionGate(s: string; dir, ff: integer);
function TranslateHandicapTable: string;
procedure PlayActionHandicapTable(s: string; dir: integer);
procedure WorkOutGate(game: char);
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
  Bloodbowl.RGGate.visible := false;
  Bloodbowl.PregamePanel.visible := true;
  Bloodbowl.PregamePanel.BringToFront;

  Bloodbowl.LblRedTeam.caption := '';
  Bloodbowl.LblBlueTeam.caption := '';
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
        if (player[g,f].status = 9) then begin
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

procedure PlayActionGate(s: string; dir, ff: integer);
var p, q, p0, q0: integer;
    s0, sr, sb: string;
begin
  if dir = 1 then begin
    p := Ord(s[3]) - 48;
    p0 := Ord(s[4]) - 48;
    q := Ord(s[5]) - 48;
    q0 := Ord(s[6]) - 48;
    Gate := p0 + q0 + ff * (team[0].ff + team[1].ff);
    case ff of
      0: begin
           s0 := '';
           sr := '';
           sb := '';
         end;
      1: begin
           s0 := ' (semi-final)';
           sr := ' + ' + IntToStr(team[0].ff);
           sb := ' + ' + IntToStr(team[1].ff);
         end;
      2: begin
           s0 := ' (final)';
           sr := ' + ' + IntToStr(2 * team[0].ff);
           sb := ' + ' + IntToStr(2 * team[1].ff);
         end;
    end;
    Bloodbowl.GateLabel.caption := 'Gate' + s0 + ':' + Chr(13) +
                       '(Red FF ' + IntToStr(p) + ': ' +
                       IntToStr(p0) + sr + ')' + Chr(13) + '(Blue FF ' +
                       IntToStr(q) + ': ' + IntToStr(q0) + sb + ')' + Chr(13) +
                       IntToStr(Gate) + '.000 cheering fans!';
    Bloodbowl.LblGate.caption := IntToStr(Gate) + '.000 cheering fans!';
    DefaultAction('Gate' + s0 + ': (Red FF ' + IntToStr(p) + ': ' +
                       IntToStr(p0) + sr + ') (Blue FF ' +
                       IntToStr(q) + ': ' + IntToStr(q0) + sb + ') ' +
                       IntToStr(Gate) + '.000 cheering fans!');
    Bloodbowl.RGGate.visible := false;
    Bloodbowl.ButGate.enabled := false;
    Bloodbowl.ButHandicap.enabled := true;
  end else begin
    BackLog;
    Bloodbowl.GateLabel.caption := '';
    Bloodbowl.LblGate.caption := '';
    Bloodbowl.RGGate.visible := true;
    Bloodbowl.ButGate.enabled := true;
    Bloodbowl.ButHandicap.enabled := false;
  end;
end;

procedure WorkOutGate(game: char);
var f, g: integer;
    ff, r: array [0..1] of integer;
    var s0, sr, sb, s1: string;
begin
  if CanWriteToLog then begin
    for g := 0 to 1 do
     if team[g].ff > 0 then ff[g] := team[g].ff else begin
       ff[g] := FVal(Inputbox('Unknown Fan Factor', 'Enter the Fan Factor ' +
         'for the ' + ffcl[g] + ' team.', '1'));
     end;
    r[0] := 0;
    r[1] := 0;
    for g := 0 to 1 do
     for f := 1 to ff[g] do r[g] := r[g] + Rnd(6,6) + 1;
    sr := '(Red FF ' + IntToStr(ff[0]) + ': ' +  IntToStr(r[0]);
    sb := '(Blue FF ' + IntToStr(ff[1]) + ': ' +  IntToStr(r[1]);
    case game of
      'G': begin
             s0 := 'Gate:';
             Gate := r[0] + r[1];
           end;
      'S': begin
             s0 := 'Gate (semi-final):';
             sr := sr + ' + ' + IntToStr(ff[0]);
             sb := sb + ' + ' + IntToStr(ff[1]);
             Gate := r[0] + r[1] + ff[0] + ff[1];
           end;
      'F': begin
             s0 := 'Gate (final):';
             sr := sr + ' + ' + IntToStr(2 * ff[0]);
             sb := sb + ' + ' + IntToStr(2 * ff[1]);
             Gate := r[0] + r[1] + 2 * (ff[0] + ff[1]);
           end;
    end;
    sr := sr + ')';
    sb := sb + ')';
    s1 := IntToStr(Gate) + '.000 cheering fans!';
    Bloodbowl.Gatelabel.caption := s0 + Chr(13) + sr + Chr(13) + sb +
           Chr(13) + s1;
    AddLog(s0 + ' ' + sr + ' ' + sb + ' ' + s1);
    LogWrite('D' + game + Chr(ff[0] + 48) + Chr(r[0] + 48) +
                    Chr(ff[1] + 48) + Chr(r[1] + 48));
  end;
end;

procedure WeatherTableClick;
var r1, r2, p, g, f: integer;
    s0: string;
begin
  if CanWriteToLog then begin
    r1 := Rnd(6,6) + 1;
    r2 := Rnd(6,6) + 1;
    AddLog('(' + IntToStr(r1) + ',' + IntToStr(r2) + ') = ' +
       IntToStr(r1 + r2) + ' : ' + WeatherTable[r1 + r2]);
    s0 := WeatherTable[r1 + r2];
    p := Pos('.', s0);
    Bloodbowl.WeatherLabel.caption :=
          Copy(s0, 1, p) + Chr(13) + Copy(s0, p+1, 100);
    LogWrite('DW' + Chr(r1 + 48) + Chr(r2 + 48));
    if frmSettings.cbWeatherPitch.checked then begin
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
        'SWELTERING HEAT')) then
        ShowFieldImage('field_heat.jpg') else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
        'BLIZZARD')) then
        ShowFieldImage('field_blizzard.jpg') else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
        'POURING RAIN')) then
        ShowFieldImage('field_rain.jpg') else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
        'VERY SUNNY')) then
        ShowFieldImage('field_sunny.jpg') else
        ShowFieldImage(frmSettings.txtFieldImageFile.text);
    end;
    if frmSettings.cbWeatherPitch.checked then begin
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
        'SWELTERING HEAT')) then
        frmSettings.cbBlackIce.Checked := False else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
        'BLIZZARD')) then
        frmSettings.cbBlackIce.Checked := True else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
        'POURING RAIN')) then
        frmSettings.cbBlackIce.Checked := False else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
        'VERY SUNNY')) then
        frmSettings.cbBlackIce.Checked := False else
      if frmSettings.txtWeatherTable.Text = 'W7' then
        frmSettings.cbBlackIce.Checked := True else
      if frmSettings.txtWeatherTable.Text = 'W9' then
        frmSettings.cbBlackIce.Checked := True else
      if frmSettings.txtWeatherTable.Text = 'W5' then
        frmSettings.cbBlackIce.Checked := True else
      if frmSettings.txtWeatherTable.Text = 'W10' then
        frmSettings.cbBlackIce.checked := True else
      frmSettings.cbBlackIce.Checked := False;
    end;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
             'SWELTERING HEAT')) and ((player[g,f].HasSkill('Cold Natured')) or
                (player[g,f].HasSkill('Stone Cold Stupid')))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
             'BLIZZARD')) and (player[g,f].HasSkill('Cold Blooded'))
             and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
             'POURING RAIN')) and (player[g,f].HasSkill('Rusting'))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
             'VERY SUNNY')) and (player[g,f].HasSkill('Vampiric Change'))
                and (player[g,f].status <= 4)
             then begin
               if player[g,f].status >= 1 then ShowHurtForm('I');
               player[g,f].SetStatus(14);
        end;
      end;
    end;
  end;
end;

procedure WeatherPickClick(r3: integer);
var r1, r2, p, g, f: integer;
    s0: string;
begin
  if CanWriteToLog then begin
    if r3 >= 7 then r1 := 6 else r1 := 1;
    r2 := r3 - r1;
    AddLog('(' + IntToStr(r1) + ',' + IntToStr(r2) + ') = ' +
       IntToStr(r1 + r2) + ' : ' + WeatherTable[r1 + r2]);
    s0 := WeatherTable[r1 + r2];
    p := Pos('.', s0);
    Bloodbowl.WeatherLabel.caption :=
          Copy(s0, 1, p) + Chr(13) + Copy(s0, p+1, 100);
    LogWrite('DW' + Chr(r1 + 48) + Chr(r2 + 48));
    if frmSettings.cbWeatherPitch.checked then begin
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
        'SWELTERING HEAT')) then
        ShowFieldImage('field_heat.jpg') else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
        'BLIZZARD')) then
        ShowFieldImage('field_blizzard.jpg') else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
        'POURING RAIN')) then
        ShowFieldImage('field_rain.jpg') else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
        'VERY SUNNY')) then
        ShowFieldImage('field_sunny.jpg') else
        ShowFieldImage(frmSettings.txtFieldImageFile.text);
    end;
    if frmSettings.cbWeatherPitch.checked then begin
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
        'SWELTERING HEAT')) then
        frmSettings.cbBlackIce.Checked := False else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
        'BLIZZARD')) then
        frmSettings.cbBlackIce.Checked := True else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
        'POURING RAIN')) then
        frmSettings.cbBlackIce.Checked := False else
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
        'VERY SUNNY')) then
        frmSettings.cbBlackIce.Checked := False else
      if frmSettings.txtWeatherTable.Text = 'W7' then
        frmSettings.cbBlackIce.Checked := True else
      if frmSettings.txtWeatherTable.Text = 'W9' then
        frmSettings.cbBlackIce.Checked := True else
      if frmSettings.txtWeatherTable.Text = 'W5' then
        frmSettings.cbBlackIce.Checked := True else
      if frmSettings.txtWeatherTable.Text = 'W10' then
        frmSettings.cbBlackIce.checked := True else
      frmSettings.cbBlackIce.Checked := False;
    end;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
             'SWELTERING HEAT')) and ((player[g,f].HasSkill('Cold Natured')) or
                (player[g,f].HasSkill('Stone Cold Stupid')))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
             'BLIZZARD')) and (player[g,f].HasSkill('Cold Blooded'))
             and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
             'POURING RAIN')) and (player[g,f].HasSkill('Rusting'))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
             'VERY SUNNY')) and (player[g,f].HasSkill('Vampiric Change'))
                and (player[g,f].status <= 4)
             then begin
               if player[g,f].status >= 1 then ShowHurtForm('I');
               player[g,f].SetStatus(14);
        end;
      end;
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
    if s[5] = '0' then player[g,f].SetStatusDef(0);
  end else begin
    player[g,f].SetStatusDef(9);
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
      if (player[g,f].status = 9) then begin
        s := player[g,f].inj;
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
          player[g,f].SetStatusDef(0);
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
