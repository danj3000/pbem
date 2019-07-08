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

var aPlayers: array [0..MaxNumPlayersInTeam] of integer;
    teamSK, playerSK, numSK: integer;

function TranslateActionSkillRoll(s: string): string;
var f, g: integer;
    sk, t: string;
begin
  case s[2] of
    'r': TranslateActionSkillRoll := '- skill roll -';
    'A': begin
            g := Ord(s[3]) - 48;
            f := Ord(s[4]) - 64;
            sk := Copy(s, 6, Length(s) - 5);
            t := '';
            TranslateActionSkillRoll := allPlayers[g,f].GetPlayerName + ' gains ' + sk + t;
         end;
    'E': begin
            TranslateActionSkillRoll := t;
         end;
  end;
end;

procedure PlayActionSkillRoll(s: string; dir: integer);
var f, g, num: integer;
begin
  g := Ord(s[3]) - 48;
  f := Ord(s[4]) - 64;
  if dir = 1 then begin
    num := Ord(s[5]) - 48;
    if s[2] = 'r' then begin
      allPlayers[g,f].SkillRollsMade[num,0] := Ord(s[6]) - 48;
      allPlayers[g,f].SkillRollsMade[num,1] := Ord(s[7]) - 48;
      if Length(s) > 7 then begin
        allPlayers[g,f].SkillAgingRollsMade[num, 0] := Ord(s[8]) - 48;
        allPlayers[g,f].SkillAgingRollsMade[num, 1] := Ord(s[9]) - 48;
        if Length(s) > 9 then begin
          allPlayers[g,f].SkillAgingEffectRollsMade[num, 0] := Ord(s[10]) - 48;
          allPlayers[g,f].SkillAgingEffectRollsMade[num, 1] := Ord(s[11]) - 48;
        end;
      end;
    end;
    if s[2] = 'A' then begin
      allPlayers[g,f].SkillsGained[num] := Copy(s, 6, Length(s) - 5);
      DefaultAction(TranslateActionSkillRoll(s));
    end;
    if s[2] = 'E' then begin
    end;
  end
  else
  begin
    if s[2] = 'A' then begin
      BackLog;
    end;
    if s[2] = 'E' then begin
      BackLog;
    end;
  end;
end;

procedure CountSkillRolls(g, f: integer);
var h, ha, hb, hg, i: integer;
    SPPNeeded: array [1..6] of integer;
begin
    SPPNeeded[1] := 5;
    SPPNeeded[2] := 15;
    SPPNeeded[3] := 30;
    SPPNeeded[4] := 50;
    SPPNeeded[5] := 75;
    SPPNeeded[6] := 175;

  teamSK := g;
  h := 1;
  if (allPlayers[g,f].hasSkill('DProg')) then
    h := 2;

  hb := allPlayers[g,f].GetStartingSPP();
  hg := allPlayers[g,f].GetMatchSPP();
  ha := hb + hg;
  allPlayers[g,f].skillrolls := 0;
  for i := 1 to 6 do begin
    if (hb <= SPPNeeded[i] * h) and (ha > SPPNeeded[i] * h) then begin
      allPlayers[g,f].skillrolls := allPlayers[g,f].skillrolls + 1;
      allPlayers[g,f].SkillLevel[allPlayers[g,f].skillrolls] := i;
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
    while allPlayers[g,f].skillrolls > n do begin
      frmSkillRolls.lbPlayers.Enabled := true;
      frmSkillRolls.lbPlayers.Items.Add(allPlayers[g,f].GetPlayerName);
      aPlayers[frmSkillRolls.lbPlayers.Items.count - 1] := f;
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
    s: string;
begin
  playerSK := aPlayers[lbPlayers.ItemIndex];
  numSK := 0;
  a1 := 0;
  a2 := 0;
  ae1 := 0;
  ae2 := 0;
  {check to see which skill roll this is (in case a player has more than 1)}
  for i := 0 to lbPlayers.ItemIndex do begin
    if aPlayers[i] = playerSK then numSK := numSK + 1;
  end;
  lblPlayerName.caption := allPlayers[teamSK, playerSK].GetPlayerName;
  txtSkill.text := '';
  lblPlayerName.font.color := colorarray[teamSK,0,0];
  if allPlayers[teamSK, playerSK].SkillRollsMade[numSK,0] > 0 then begin
    r1 := allPlayers[teamSK, playerSK].SkillRollsMade[numSK,0];
    r2 := allPlayers[teamSK, playerSK].SkillRollsMade[numSK,1];
    if allPlayers[teamSK, playerSK].SkillsGained[numSK] = '+1 MA' then begin
      rbMA.Checked := true;
    end else if allPlayers[teamSK, playerSK].SkillsGained[numSK] = '+1 AG' then begin
      rbAG.checked := true;
    end else if allPlayers[teamSK, playerSK].SkillsGained[numSK] = '+1 ST' then begin
      rbST.checked := true;
    end else begin
      rbSkill.checked := true;
      txtSkill.text := allPlayers[teamSK, playerSK].SkillsGained[numSK];
    end;
  end else begin
    r1 := Rnd(6,2) + 1;
    r2 := Rnd(6,2) + 1;
    allPlayers[teamSK, playerSK].SkillRollsMade[numSK, 0] := r1;
    allPlayers[teamSK, playerSK].SkillRollsMade[numSK, 1] := r2;
    s := '(sr' + Chr(teamSK + 48) + Chr(playerSK + 64) +
             Chr(numSK + 48) + Chr(r1 + 48) + Chr(r2 + 48);
    LogWrite(s);
  end;
  imDie1.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r1) + '.bmp');
  imDie2.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r2) + 'b.bmp');
  rbSkill.enabled := true;
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
  butAccept.enabled := (allPlayers[teamSK, playerSK].SkillsGained[numSK] = '');
  begin
    frmSkillRolls.Height := 320;
  end;
end;

procedure TfrmSkillRolls.butAcceptClick(Sender: TObject);
var s, t, sk: string;
begin
  sk := allPlayers[teamSK, playerSK].GetSkillString(1);
  s := '(u' + Chr(teamSK + 48) + Chr(playerSK + 64) +
        Chr(allPlayers[teamSK, playerSK].ma + 48) +
        Chr(allPlayers[teamSK, playerSK].st + 48) +
        Chr(allPlayers[teamSK, playerSK].ag + 48) +
        Chr(allPlayers[teamSK, playerSK].av + 48) +
        Chr(allPlayers[teamSK, playerSK].cnumber + 64) +
        Chr(allPlayers[teamSK, playerSK].value div 5 + 48) +
        allPlayers[teamSK, playerSK].name + '$' +
        allPlayers[teamSK, playerSK].position + '$' +
        allPlayers[teamSK, playerSK].picture + '$' +
        allPlayers[teamSK, playerSK].icon + '$' +
        sk + '|';
  if rbSkill.checked then begin
    allPlayers[teamSK, playerSK].SkillsGained[numSK] := Trim(txtSkill.text);
    sk := sk + ', ' + TranslateSkillToEnglish(Trim(txtSkill.text));
  end;
  if rbMA.checked then begin
    allPlayers[teamSK, playerSK].SkillsGained[numSK] := '+1 MA';
    allPlayers[teamSK, playerSK].ma := allPlayers[teamSK, playerSK].ma + 1;
    sk := sk + ', +1 MA';
  end;
  if rbAG.checked then begin
    allPlayers[teamSK, playerSK].SkillsGained[numSK] := '+1 AG';
    allPlayers[teamSK, playerSK].ag := allPlayers[teamSK, playerSK].ag + 1;
    sk := sk + ', +1 AG';
  end;
  if rbST.checked then begin
    allPlayers[teamSK, playerSK].SkillsGained[numSK] := '+1 ST';
    allPlayers[teamSK, playerSK].st := allPlayers[teamSK, playerSK].st + 1;
    sk := sk + ', +1 ST';
  end;
  if (sk <> '') and (sk[1] = ',') then sk := Copy(sk, 3, Length(sk));
  height := 148;
  t := 'sA' + Chr(teamSK + 48) + Chr(playerSK + 64) +
             Chr(numSK + 48) + allPlayers[teamSK, playerSK].SkillsGained[numSK];
  frmSkillRolls.lbPlayers.Items[lbPlayers.ItemIndex] :=
      allPlayers[teamSK, playerSK].GetPlayerName + ' gains ' +
      allPlayers[teamSK, playerSK].SkillsGained[numSK];
  if CanWriteToLog then begin
    LogWrite(t);
    PlayActionSkillRoll(t, 1);
    s := s +
        Chr(allPlayers[teamSK, playerSK].ma + 48) +
        Chr(allPlayers[teamSK, playerSK].st + 48) +
        Chr(allPlayers[teamSK, playerSK].ag + 48) +
        Chr(allPlayers[teamSK, playerSK].av + 48) +
        Chr(allPlayers[teamSK, playerSK].cnumber + 64) +
        Chr(allPlayers[teamSK, playerSK].value div 5 + 48) +
        allPlayers[teamSK, playerSK].name + '$' +
        allPlayers[teamSK, playerSK].position + '$' +
        allPlayers[teamSK, playerSK].picture + '$' +
        allPlayers[teamSK, playerSK].icon + '$' +
        sk;
    LogWrite(s);
    PlayActionPlayerStatChange(Copy(s, 2, Length(s) - 1), 1);
  end;
end;

end.
