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
            sk := Copy(s, 6, Length(s) - 5);
            t := '';
            TranslateActionSkillRoll := player[g,f].GetPlayerName + ' gains ' + sk + t;
         end;
    'E': begin
            g := Ord(s[3]) - 48;
            f := Ord(s[4]) - 64;
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
      player[g,f].SkillsGained[num] := Copy(s, 6, Length(s) - 5);
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
    SPPNeeded: array [1..7] of integer;
begin
    SPPNeeded[1] := 5;
    SPPNeeded[2] := 15;
    SPPNeeded[3] := 30;
    SPPNeeded[4] := 50;
    SPPNeeded[5] := 75;
    SPPNeeded[6] := 175;

  teamSK := g;
  h := 1;
  if (((player[g,f].BigGuy) and not (true)) or  // big guy
      (player[g,f].hasSkill('DProg'))) then h := 2;

  hb := player[g,f].GetStartingSPP();
  hg := player[g,f].GetMatchSPP();
  ha := hb + hg;
  player[g,f].skillrolls := 0;
  for i := 1 to 6 do begin
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
  butAccept.enabled := (player[teamSK, playerSK].SkillsGained[numSK] = '');
  begin
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
