unit unitSkillRoll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmSkillRolls = class(TForm)
    lbPlayers: TListBox;
    Label1: TLabel;
    lblPlayerName: TLabel;
    imDie1: TImage;
    imDie2: TImage;
    rbSkill: TRadioButton;
    rbMA: TRadioButton;
    rbAG: TRadioButton;
    rbST: TRadioButton;
    txtSkill: TEdit;
    butAccept: TButton;
    imDieA1: TImage;
    imDieA2: TImage;
    imDieA3: TImage;
    imDieA4: TImage;
    lblNoAgingEffect: TLabel;
    lblAgingEffect: TLabel;
    procedure lbPlayersClick(Sender: TObject);
    procedure butAcceptClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSkillRolls: TfrmSkillRolls;

function TranslateActionSkillRoll(s: string): string;
procedure PlayActionSkillRoll(s: string; dir: integer);
procedure CountSkillRolls(g, f: integer);
procedure MakeSkillRolls(g: integer);

implementation

{$R *.DFM}

uses bbunit, bbalg, unitRoster, unitTeam, unitRandom, unitLog,
     unitPlayAction, unitPlayer, unitSettings, unitPostgameSeq, unitLanguage;

var Players: array [0..MaxNumPlayersInTeam] of integer;
    teamSK, playerSK, numSK: integer;

function TranslateActionSkillRoll(s: string): string;
var f, g, CurExp, EXPRoll, AgeRoll, Ageroll1, AgeRoll2: integer;
    sk, t: string;
begin
  case s[2] of
    'r': TranslateActionSkillRoll := '- skill roll -';
    'A': begin
            g := Ord(s[3]) - 48;
            f := Ord(s[4]) - 64;
            if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2)
              then begin
              sk := Copy(s, 6, Length(s) - 6);
              case s[Length(s)] of
                '-': t := ', Aging has no effect';
                'N': t := ', Aging gives him a Niggling injury';
                'V': t := ', Aging gives -1 AV';
                'M': t := ', Aging gives -1 MA';
                'G': t := ', Aging gives -1 AG';
                'S': t := ', Aging gives -1 ST';
              end;
            end else begin
              sk := Copy(s, 6, Length(s) - 5);
              t := '';
            end;
            TranslateActionSkillRoll :=
                player[g,f].GetPlayerName + ' gains ' + sk + t;
         end;
    'E': begin
            g := Ord(s[3]) - 48;
            f := Ord(s[4]) - 64;
            if (frmSettings.rgAging.ItemIndex=3) then begin
              CurExp := Ord(s[5]) - 64;
              EXPRoll := Ord(s[6]) - 64;
              if Length(s)= 9 then begin
                AgeRoll1 := Ord(s[7]) - 64;
                AgeRoll2 := Ord(s[8]) - 64;
                if not(frmSettings.cbEXPSI.checked) then
                  AgeRoll := Ageroll1 + Ageroll2 else
                  AgeRoll := (Ageroll1 * 10) + Ageroll2;
              end;
              t := 'Current EXP:' + InttoStr(CurExp) + ', EXP Roll: '
                          + InttoStr(EXPRoll) + ' #' + InttoStr(f) + ' ' +
                          player[g,f].name;
              case s[Length(s)] of
                'U': t := t + ' GAINS an EXP Point';
                '-': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: No Effect';
                'T': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: Miss Next Game';
                'N': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: Niggling Injury and Miss Next Game';
                'V': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: -1 AV and Miss Next Game';
                'M': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: -1 MA and Miss Next Game';
                'G': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: -1 AG and Miss Next Game';
                'S': t := t + ' fails EXP roll, Aging Roll: ' + InttoStr(AgeRoll) +
                          ' - Aging: -1 ST and Miss Next Game';
                'F': t := t + ' fails EXP roll';
              end;
            end;
            TranslateActionSkillRoll := t;
         end;
  end;
end;

procedure PlayActionSkillRoll(s: string; dir: integer);
var f, g, num, CurExp, EXPRoll: integer;
begin
  g := Ord(s[3]) - 48;
  f := Ord(s[4]) - 64;
  if dir = 1 then begin
    num := Ord(s[5]) - 48;
    if s[2] = 'r' then begin
      player[g,f].SkillRollsMade[num,0] := Ord(s[6]) - 48;
      player[g,f].SkillRollsMade[num,1] := Ord(s[7]) - 48;
      if Length(s) > 7 then begin
        player[g,f].SkillAgingRollsMade[num, 0] := Ord(s[8]) - 48;
        player[g,f].SkillAgingRollsMade[num, 1] := Ord(s[9]) - 48;
        if Length(s) > 9 then begin
          player[g,f].SkillAgingEffectRollsMade[num, 0] := Ord(s[10]) - 48;
          player[g,f].SkillAgingEffectRollsMade[num, 1] := Ord(s[11]) - 48;
        end;
      end;
    end;
    if s[2] = 'A' then begin
      if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2)
        then begin
        player[g,f].SkillsGained[num] := Copy(s, 6, Length(s) - 6);
        if s[Length(s)] = 'N' then begin
          player[g,f].inj := player[g,f].inj + 'N';
        end;
      end else begin
        player[g,f].SkillsGained[num] := Copy(s, 6, Length(s) - 5);
      end;
      DefaultAction(TranslateActionSkillRoll(s));
    end;
    if s[2] = 'E' then begin
      if (frmSettings.rgAging.ItemIndex=3) then begin
        CurExp := Ord(s[5]) - 64;
        EXPRoll := Ord(s[6]) - 64;
        if s[Length(s)] = 'U' then begin
          if frmSettings.cbMVPEXP.checked then
             player[g, f].exp := player[g, f].exp + 1 else
             player[g, f].mvp := player[g, f].mvp + 1;
        end else if s[Length(s)] = 'V' then begin
          player[g, f].av := player[g, f].av - 1;
          player[g,f].inj := player[g,f].inj + 'M';
          player[g,f].SIAgestatus := 1;
        end else if s[Length(s)] = 'M' then begin
          player[g, f].ma := player[g, f].ma - 1;
          player[g,f].inj := player[g,f].inj + 'M';
          player[g,f].SIAgestatus := 1;
        end else if s[Length(s)] = 'G' then begin
          player[g, f].ag := player[g, f].ag - 1;
          player[g,f].inj := player[g,f].inj + 'M';
          player[g,f].SIAgestatus := 1;
        end else if s[Length(s)] = 'S' then begin
          player[g, f].st := player[g, f].st - 1;
          player[g,f].inj := player[g,f].inj + 'M';
          player[g,f].SIAgestatus := 1;
        end else if s[Length(s)] = 'N' then begin
          player[g,f].inj := player[g,f].inj + 'MN';
          player[g,f].SIAgestatus := 1;
        end else if s[Length(s)] = 'T' then begin
          player[g,f].inj := player[g,f].inj + 'M';
          player[g,f].SIAgestatus := 1;
        end;
        DefaultAction(TranslateActionSkillRoll(s));
        if g = 0 then begin
          frmPostgame.ButMVPRed.enabled := false;
          frmPostgame.ButSkillrollRed.enabled := true;
          frmPostgame.lblNewTRRed.caption := IntToStr(CalculateTeamRating(0));
        end else begin
          frmPostgame.ButMVPBlue.enabled := false;
          frmPostgame.ButSkillrollBlue.enabled := true;
          frmPostgame.lblNewTRBlue.caption := IntToStr(CalculateTeamRating(1));
        end;
      end;
    end;
  end else begin
    if s[2] = 'A' then begin
      BackLog;
      if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2)
        then begin
        if s[Length(s)] = 'N' then begin
          player[g,f].inj :=
                Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 1);
        end;
      end;
    end;
    if s[2] = 'E' then begin
      BackLog;
      if (frmSettings.rgAging.ItemIndex=3) then begin
        CurExp := Ord(s[5]) - 64;
        EXPRoll := Ord(s[6]) - 64;
        if s[Length(s)] = 'U' then begin
          if frmSettings.cbMVPEXP.checked then
             player[g, f].exp := player[g, f].exp - 1 else
             player[g, f].mvp := player[g, f].mvp - 1;
        end else if s[Length(s)] = 'V' then begin
          player[g, f].av := player[g, f].av + 1;
          player[g,f].inj :=
            Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 1);
          player[g,f].SIAgestatus := 0;
        end else if s[Length(s)] = 'M' then begin
          player[g, f].ma := player[g, f].ma + 1;
          player[g,f].inj :=
            Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 1);
          player[g,f].SIAgestatus := 0;
        end else if s[Length(s)] = 'G' then begin
          player[g, f].ag := player[g, f].ag + 1;
          player[g,f].inj :=
            Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 1);
          player[g,f].SIAgestatus := 0;
        end else if s[Length(s)] = 'S' then begin
          player[g, f].st := player[g, f].st + 1;
          player[g,f].inj :=
            Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 1);
          player[g,f].SIAgestatus := 0;
        end else if s[Length(s)] = 'N' then begin
          player[g,f].inj :=
            Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 2);
          player[g,f].SIAgestatus := 0;
        end else if s[Length(s)] = 'T' then begin
          player[g,f].inj :=
            Copy(player[g,f].inj, 1, Length(player[g,f].inj) - 1);
          player[g,f].SIAgestatus := 0;
        end;
        if g = 0 then frmPostgame.ButMVPRed.enabled := true
           else frmPostgame.ButMVPBlue.enabled := true;
        if g = 0 then frmPostgame.ButSkillrollRed.enabled := false
           else frmPostgame.ButSkillrollBlue.enabled := false;
      end;
    end;
  end;
end;

procedure CountSkillRolls(g, f: integer);
var h, ha, hb, hg, i, MVPValue: integer;
    SPPNeeded: array [1..7] of integer;
begin
  if not (frmSettings.rgSkillRollsAt.ItemIndex = 1) then begin
    SPPNeeded[1] := 5;
    SPPNeeded[2] := 10;
    SPPNeeded[3] := 25;
    SPPNeeded[4] := 50;
    SPPNeeded[5] := 100;
    SPPNeeded[6] := 150;
    SPPNeeded[7] := 250;
  end else begin
    SPPNeeded[1] := 5;
    SPPNeeded[2] := 15;
    SPPNeeded[3] := 30;
    SPPNeeded[4] := 50;
    SPPNeeded[5] := 75;
    SPPNeeded[6] := 125;
    SPPNeeded[7] := 175;
  end;
  teamSK := g;
  h := 1;
  if (((player[g,f].BigGuy) and not (frmSettings.rgBGA4th.ItemIndex >= 1)) or
      (player[g,f].hasSkill('DProg'))) then h := 2;
  if (frmSettings.rgAging.ItemIndex = 3) and (not(frmSettings.cbMVPEXP.checked))
    then MVPValue := 1 else MVPValue := FVal(frmSettings.txtMVPValue.text);
  hb := player[g,f].comp0 + 3 * player[g,f].td0 +
          2 * player[g,f].cas0 + 2 * player[g,f].int0 +
          MVPValue * player[g,f].mvp0 + player[g,f].otherSPP0 +
          player[g,f].exp0;
  hg := player[g,f].comp + 3 * player[g,f].td +
          2 * player[g,f].cas + 2 * player[g,f].int +
          MVPValue * player[g,f].mvp + player[g,f].otherSPP +
          player[g,f].exp;
  ha := hb + hg;
  player[g,f].skillrolls := 0;
  for i := 1 to 7 do begin
    if (hb <= SPPNeeded[i] * h) and (ha > SPPNeeded[i] * h) then begin
      player[g,f].skillrolls := player[g,f].skillrolls + 1;
      player[g,f].SkillLevel[player[g,f].skillrolls] := i;
    end;
  end;
end;

procedure MakeSkillRolls(g: integer);
var f, n: integer;
begin
  frmSkillRolls.lbPlayers.Clear;
  for f := 1 to team[g].numplayers do begin
    CountSkillRolls(g, f);
    n := 0;
    while player[g,f].skillrolls > n do begin
      frmSkillRolls.lbPlayers.Enabled := true;
      frmSkillRolls.lbPlayers.Items.Add(player[g,f].GetPlayerName);
      Players[frmSkillRolls.lbPlayers.Items.count - 1] := f;
      n := n + 1;
    end;
  end;
  if frmSkillRolls.lbPlayers.Items.Count = 0 then begin
    frmSkillRolls.lbPlayers.Items.Add('<no players eligible>');
    frmSkillRolls.lbPlayers.Enabled := false;
  end;
  frmSkillRolls.height := 148;
  frmSkillRolls.show;
end;

procedure TfrmSkillRolls.lbPlayersClick(Sender: TObject);
var i, r1, r2, a1, a2, ae1, ae2: integer;
    AgingRoll: array [1..7] of integer;
    s: string;
begin
  playerSK := Players[lbPlayers.ItemIndex];
  numSK := 0;
  a1 := 0;
  a2 := 0;
  ae1 := 0;
  ae2 := 0;
  {check to see which skill roll this is (in case a player has more than 1)}
  for i := 0 to lbPlayers.ItemIndex do begin
    if Players[i] = playerSK then numSK := numSK + 1;
  end;
  lblPlayerName.caption := player[teamSK, playerSK].GetPlayerName;
  txtSkill.text := '';
  lblPlayerName.font.color := colorarray[teamSK,0,0];
  if player[teamSK, playerSK].SkillRollsMade[numSK,0] > 0 then begin
    r1 := player[teamSK, playerSK].SkillRollsMade[numSK,0];
    r2 := player[teamSK, playerSK].SkillRollsMade[numSK,1];
    if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2)
      then begin
      a1 := player[teamSK, playerSK].SkillAgingRollsMade[numSK,0];
      a2 := player[teamSK, playerSK].SkillAgingRollsMade[numSK,1];
      if player[teamSK, playerSK].SkillAgingEffectRollsMade[numSK,0] > 0
       then begin
        ae1 := player[teamSK, playerSK].SkillAgingEffectRollsMade[numSK,0];
        ae2 := player[teamSK, playerSK].SkillAgingEffectRollsMade[numSK,1];
      end;
    end;
    if player[teamSK, playerSK].SkillsGained[numSK] = '+1 MA' then begin
      rbMA.Checked := true;
    end else if player[teamSK, playerSK].SkillsGained[numSK] = '+1 AG' then begin
      rbAG.checked := true;
    end else if player[teamSK, playerSK].SkillsGained[numSK] = '+1 ST' then begin
      rbST.checked := true;
    end else begin
      rbSkill.checked := true;
      txtSkill.text := player[teamSK, playerSK].SkillsGained[numSK];
    end;
  end else begin
    r1 := Rnd(6,2) + 1;
    r2 := Rnd(6,2) + 1;
    player[teamSK, playerSK].SkillRollsMade[numSK, 0] := r1;
    player[teamSK, playerSK].SkillRollsMade[numSK, 1] := r2;
    s := '(sr' + Chr(teamSK + 48) + Chr(playerSK + 64) +
             Chr(numSK + 48) + Chr(r1 + 48) + Chr(r2 + 48);
    if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2)
      then begin
      if frmSettings.rgAging.ItemIndex = 1 then begin
        AgingRoll[1] := 3;
        AgingRoll[2] := 4;
        AgingRoll[3] := 5;
        AgingRoll[4] := 6;
        AgingRoll[5] := 7;
        AgingRoll[6] := 8;
        AgingRoll[7] := 9;
      end else if frmSettings.rgAging.ItemIndex = 2 then begin
        AgingRoll[1] := 4;
        AgingRoll[2] := 5;
        AgingRoll[3] := 6;
        AgingRoll[4] := 7;
        AgingRoll[5] := 8;
        AgingRoll[6] := 9;
        AgingRoll[7] := 10;
      end;
      a1 := Rnd(6,2) + 1;
      a2 := Rnd(6,2) + 1;
      player[teamSK, playerSK].SkillAgingRollsMade[numSK, 0] := a1;
      player[teamSK, playerSK].SkillAgingRollsMade[numSK, 1] := a2;
      s := s + Chr(a1 + 48) + Chr(a2 + 48);
      if a1 + a2 < AgingRoll[player[teamSK, playerSK].SkillLevel[numSK]]
       then begin
        ae1 := Rnd(6,2) + 1;
        ae2 := Rnd(6,2) + 1;
        player[teamSK, playerSK].SkillAgingEffectRollsMade[numSK, 0] := ae1;
        player[teamSK, playerSK].SkillAgingEffectRollsMade[numSK, 1] := ae2;
        s := s + Chr(ae1 + 48) + Chr(ae2 + 48);
      end;
    end;
    LogWrite(s);
  end;
  imDie1.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r1) + '.bmp');
  imDie2.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r2) + 'b.bmp');
  if frmSettings.cbNoForcedMAandAG.checked then rbSkill.enabled := true else
    rbSkill.enabled := (r1 = r2) or ((r1 + r2) <= 9);
  txtSkill.enabled := rbSkill.enabled;
  rbMA.enabled := (r1 + r2 = 10);
  rbAG.enabled := (r1 + r2 = 11);
  rbST.enabled := (r1 + r2 = 12);
  if txtSkill.text = '' then begin
    rbSkill.checked := rbSkill.enabled;
    rbMA.checked := rbMA.enabled;
    rbAG.checked := rbAG.enabled;
    rbST.checked := rbST.enabled;
  end;
  butAccept.enabled := (player[teamSK, playerSK].SkillsGained[numSK] = '');
  if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2) then begin
    imDieA1.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(a1) + '.bmp');
    imDieA2.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(a2) + 'b.bmp');
    if ae1 > 0 then begin
      imDieA3.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(ae1) + '.bmp');
      imDieA4.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(ae2) + 'b.bmp');
      lblNoAgingEffect.visible := false;
      case (ae1 + ae2) of
        9  : lblAgingEffect.caption := '-1 AV';
        10 : lblAgingEffect.caption := '-1 MA';
        11 : lblAgingEffect.caption := '-1 AG';
        12 : lblAgingEffect.caption := '-1 ST';
      else
        lblAgingEffect.caption := 'Niggling injury';
      end;
      frmSkillRolls.Height := 430;
    end else begin
      lblNoAgingEffect.visible := true;
      frmSkillRolls.Height := 370;
    end;
  end else begin
    frmSkillRolls.Height := 320;
  end;
end;

procedure TfrmSkillRolls.butAcceptClick(Sender: TObject);
var s, t, sk: string;
    r: integer;
begin
  sk := player[teamSK, playerSK].GetSkillString(1);
  s := '(u' + Chr(teamSK + 48) + Chr(playerSK + 64) +
        Chr(player[teamSK, playerSK].ma + 48) +
        Chr(player[teamSK, playerSK].st + 48) +
        Chr(player[teamSK, playerSK].ag + 48) +
        Chr(player[teamSK, playerSK].av + 48) +
        Chr(player[teamSK, playerSK].cnumber + 64) +
        Chr(player[teamSK, playerSK].value div 5 + 48) +
        player[teamSK, playerSK].name + '$' +
        player[teamSK, playerSK].position + '$' +
        player[teamSK, playerSK].picture + '$' +
        player[teamSK, playerSK].icon + '$' +
        sk + '|';
  if rbSkill.checked then begin
    player[teamSK, playerSK].SkillsGained[numSK] := Trim(txtSkill.text);
    sk := sk + ', ' + TranslateSkillToEnglish(Trim(txtSkill.text));
  end;
  if rbMA.checked then begin
    player[teamSK, playerSK].SkillsGained[numSK] := '+1 MA';
    player[teamSK, playerSK].ma := player[teamSK, playerSK].ma + 1;
    sk := sk + ', +1 MA';
  end;
  if rbAG.checked then begin
    player[teamSK, playerSK].SkillsGained[numSK] := '+1 AG';
    player[teamSK, playerSK].ag := player[teamSK, playerSK].ag + 1;
    sk := sk + ', +1 AG';
  end;
  if rbST.checked then begin
    player[teamSK, playerSK].SkillsGained[numSK] := '+1 ST';
    player[teamSK, playerSK].st := player[teamSK, playerSK].st + 1;
    sk := sk + ', +1 ST';
  end;
  if (sk <> '') and (sk[1] = ',') then sk := Copy(sk, 3, Length(sk));
  height := 148;
  t := 'sA' + Chr(teamSK + 48) + Chr(playerSK + 64) +
             Chr(numSK + 48) + player[teamSK, playerSK].SkillsGained[numSK];
  frmSkillRolls.lbPlayers.Items[lbPlayers.ItemIndex] :=
      player[teamSK, playerSK].GetPlayerName + ' gains ' +
      player[teamSK, playerSK].SkillsGained[numSK];
  if (frmSettings.rgAging.ItemIndex=1) or (frmSettings.rgAging.ItemIndex=2) then begin
    if player[teamSK, playerSK].SkillAgingEffectRollsMade[numsk,0] = 0
     then begin
      t := t + '-';
    end else begin
      r := player[teamSK, playerSK].SkillAgingEffectRollsMade[numsk,0] +
           player[teamSK, playerSK].SkillAgingEffectRollsMade[numsk,1];
      case r of
        9 : begin
              t := t + 'V';
              player[teamSK, playerSK].av := player[teamSK, playerSK].av - 1;
            end;
        10: begin
              t := t + 'M';
              player[teamSK, playerSK].ma := player[teamSK, playerSK].ma - 1;
            end;
        11: begin
              t := t + 'G';
              player[teamSK, playerSK].ag := player[teamSK, playerSK].ag - 1;
            end;
        12: begin
              t := t + 'S';
              player[teamSK, playerSK].st := player[teamSK, playerSK].st - 1;
            end;
      else  begin
              t := t + 'N';
            end;
      end;
    end;
  end;
  if CanWriteToLog then begin
    LogWrite(t);
    PlayActionSkillRoll(t, 1);
    s := s +
        Chr(player[teamSK, playerSK].ma + 48) +
        Chr(player[teamSK, playerSK].st + 48) +
        Chr(player[teamSK, playerSK].ag + 48) +
        Chr(player[teamSK, playerSK].av + 48) +
        Chr(player[teamSK, playerSK].cnumber + 64) +
        Chr(player[teamSK, playerSK].value div 5 + 48) +
        player[teamSK, playerSK].name + '$' +
        player[teamSK, playerSK].position + '$' +
        player[teamSK, playerSK].picture + '$' +
        player[teamSK, playerSK].icon + '$' +
        sk;
    LogWrite(s);
    PlayActionPlayerStatChange(Copy(s, 2, Length(s) - 1), 1);
  end;
end;

end.
