unit unitPregame;

interface

procedure PregameEnableDisable;
procedure NigglesOrStart;

procedure WorkOutHandicap;

procedure PlayActionToss(s: string; dir: integer);
procedure WorkOutToss;

procedure PlayActionInducements(log: string; dir: integer);

implementation

uses Dialogs, Graphics, SysUtils,
     bbunit, bbalg, unitLog, unitPlayAction, unitTurnChange, unitRandom,
     unitArmourRoll, unitSettings;

procedure PregameEnableDisable;
begin
  Bloodbowl.ButLoadRed.enabled := true;
  Bloodbowl.ButLoadBlue.enabled := true;
  Bloodbowl.ButWeather.enabled := false;
  Bloodbowl.ButGate.enabled := false;
  Bloodbowl.ButHandicap.enabled := false;
  Bloodbowl.ButCardsRed.enabled := false;
  Bloodbowl.ButCardsBlue.enabled := false;
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
  Bloodbowl.ImRedDie.visible := false;
  Bloodbowl.ImBlueDie.visible := false;
  Bloodbowl.lblToss.caption := '';
end;

procedure NigglesOrStart;
var f, g: integer;
begin
  Bloodbowl.ButToss.enabled := true;
end;

procedure PlayActionInducements(log: string; dir: integer);
var
  text: string;
  diff, gold: integer;
begin
  if dir = 1 then
  begin
    diff := team[1].GetTeamValue() - team[0].GetTeamValue();
    gold := abs(diff);
    text := IntToStr(gold) + 'k to spend on inducements';
    DefaultAction(text);
    Bloodbowl.LblHandicap.caption := text;
    Bloodbowl.ButHandicap.enabled := false;
    Bloodbowl.ButToss.enabled := true;
  end
  else
  begin
    Bloodbowl.LblHandicap.caption := '';
    Bloodbowl.ButHandicap.enabled := true;
    Bloodbowl.ButToss.enabled := false;
  end;
end;

procedure WorkOutHandicap;
var s, log, HT: string;
    diff, gold, m, v, k, bc, bm: integer;
    gg: TextFile;
begin
    if CanWriteToLog then
    begin
      // blank log - no state data
      log := 'H';
      LogWrite(log);
      PlayActionInducements(log, 1);
    end;
//  if team[0].tr < team[1].tr then m := 0 else m := 1;
//  v := team[1-m].tr - team[m].tr;
//  if frmSettings.rgCardSystem.ItemIndex = 3 then begin
//    if v <= 10 then NumHandicaps := 0 else
//    if v <= 25 then NumHandicaps := 1 else
//    if v <= 50 then NumHandicaps := 2 else
//    if v <= 75 then NumHandicaps := 3 else
//    if v <= 100 then NumHandicaps := 4 else NumHandicaps := 5;
//    s := 'Dh' + Chr(48 + NumHandicaps);
//    if CanWriteToLog then begin
//      LogWrite(s);
//      PlayActionHandicapTable(s, 1);
//    end;
//  end;
//  if frmSettings.rgCardSystem.ItemIndex = 4 then begin
//    if v <= 10 then NumHandicaps := 0 else
//     NumHandicaps := v;
//    s := 'Dh' + Chr(48 + NumHandicaps);
//    if CanWriteToLog then begin
//      LogWrite(s);
//      PlayActionHandicapTable(s, 1);
//    end;
//  end;
//  if frmSettings.rgCardSystem.ItemIndex >= 3 then begin
//    if (Trim(frmSettings.txtHandicapTable.text)='H5') then begin
//      AssignFile(gg, curdir + 'ini/bbtables.ini');
//      Reset(gg);
//      ReadLn(gg, s);
//      HT := Trim(frmSettings.txtHandicapTable.text);
//      while Copy(s, 2, length(HT)) <> HT do ReadLn(gg, s);
//      ReadLn(gg, s);
//      k := 12;
//      while (k < length(s)) and (FVal(copy(s, k ,3)) <> 0)
//            and (FVal(copy(s, k, 3)) < team[m].tr) do k := k + 8;
//      ReadLn(gg, s);
//      while (FVal(copy(s, 5, 3)) < v) and (FVal(copy(s, 5, 3)) <> 0)
//            do ReadLn(gg, s);
//      bc := FVal(copy(s, k-2, 1));
//      bm := FVal(copy(s, k, 1));
//      CloseFile(gg);
//      team[m].bonusCards := bc;
//      team[m].bonusMVP := bm;
//      team[1-m].bonusCards := 0;
//      team[1-m].bonusMVP := 0;
//      s := 'DH' + Chr(48 + team[0].bonusCards) + Chr(48 + team[0].bonusMVP) +
//           Chr(48 + team[1].bonusCards) + Chr(48 + team[1].bonusMVP);
//      if CanWriteToLog then begin
//        AddLog(TranslateHandicap);
//        LogWrite(s);
//      end;
//      if (team[0].bonusCards > 0) or (team[0].bonusMVP > 0) then
//        Bloodbowl.LblHandicap.font.color := colorarray[0,0,0]
//      else if (team[1].bonusCards > 0) or (team[1].bonusMVP > 0) then
//        Bloodbowl.LblHandicap.font.color := colorarray[1,0,0]
//      else
//        Bloodbowl.LblHandicap.font.color := clPurple;
//      Bloodbowl.ButCardsRed.enabled := true;
//      Bloodbowl.ButCardsBlue.enabled := true;
//    end;
//  end;
//  if frmSettings.rgCardSystem.ItemIndex < 3 then begin
//    AssignFile(gg, curdir + 'ini/bbtables.ini');
//    Reset(gg);
//    ReadLn(gg, s);
//    HT := Trim(frmSettings.txtHandicapTable.text);
//    while Copy(s, 2, length(HT)) <> HT do ReadLn(gg, s);
//    ReadLn(gg, s);
//    k := 12;
//    while (k < length(s)) and (FVal(copy(s, k ,3)) <> 0)
//          and (FVal(copy(s, k, 3)) < team[m].tr) do k := k + 8;
//    ReadLn(gg, s);
//    while (FVal(copy(s, 5, 3)) < v) and (FVal(copy(s, 5, 3)) <> 0)
//          do ReadLn(gg, s);
//    bc := FVal(copy(s, k-2, 1));
//    bm := FVal(copy(s, k, 1));
//    CloseFile(gg);
//    team[m].bonusCards := bc;
//    team[m].bonusMVP := bm;
//    team[1-m].bonusCards := 0;
//    team[1-m].bonusMVP := 0;
//    s := 'DH' + Chr(48 + team[0].bonusCards) + Chr(48 + team[0].bonusMVP) +
//         Chr(48 + team[1].bonusCards) + Chr(48 + team[1].bonusMVP);
//    if CanWriteToLog then begin
//      AddLog(TranslateHandicap);
//      LogWrite(s);
//    end;
//    if (team[0].bonusCards > 0) or (team[0].bonusMVP > 0) then
//      Bloodbowl.LblHandicap.font.color := colorarray[0,0,0]
//    else if (team[1].bonusCards > 0) or (team[1].bonusMVP > 0) then
//      Bloodbowl.LblHandicap.font.color := colorarray[1,0,0]
//    else
//      Bloodbowl.LblHandicap.font.color := clPurple;
//    Bloodbowl.ButCardsRed.enabled := true;
//    Bloodbowl.ButCardsBlue.enabled := true;
//  end;
  Bloodbowl.ButHandicap.enabled := false;
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
