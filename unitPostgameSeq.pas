unit unitPostgameSeq;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls;

type
  TfrmPostgame = class(TForm)
    GBPostgameRed: TGroupBox;
    Label3: TLabel;
    LblNewTRRed: TLabel;
    ImMWDieRed: TImage;
    LblMWRollRed: TLabel;
    Label5: TLabel;
    LblMWTableRed: TLabel;
    Label6: TLabel;
    LblMWWTLRed: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    LblMWTotRed: TLabel;
    Label10: TLabel;
    Label9: TLabel;
    ImFFDieRed: TImage;
    lblTotalFFModRed: TLabel;
    lblFFResultRed: TLabel;
    ButMWRed: TBitBtn;
    ButMVPRed: TBitBtn;
    ButSkillRollRed: TBitBtn;
    ButFFRed: TBitBtn;
    ButPurchaseRed: TBitBtn;
    TxtMWModRed: TEdit;
    butFFTotModRed: TButton;
    GBPostgameBlue: TGroupBox;
    Label4: TLabel;
    LblNewTRBlue: TLabel;
    ImMWDieBlue: TImage;
    LblMWRollBlue: TLabel;
    Label11: TLabel;
    LblMWTableBlue: TLabel;
    Label13: TLabel;
    LblMWWTLBlue: TLabel;
    Label16: TLabel;
    LblMWTotBlue: TLabel;
    Label18: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    ImFFDieBlue: TImage;
    lblTotalFFModBlue: TLabel;
    lblFFResultBlue: TLabel;
    ButMWBlue: TBitBtn;
    ButMVPBlue: TBitBtn;
    ButSkillRollBlue: TBitBtn;
    ButFFBlue: TBitBtn;
    ButPurchaseBlue: TBitBtn;
    TxtMWModBlue: TEdit;
    butFFTotModBlue: TButton;
    procedure ButMWRedClick(Sender: TObject);
    procedure ButMWBlueClick(Sender: TObject);
    procedure ButMVPRedClick(Sender: TObject);
    procedure ButMVPBlueClick(Sender: TObject);
    procedure ButSkillRollRedClick(Sender: TObject);
    procedure ButSkillRollBlueClick(Sender: TObject);
    procedure ButFFRedClick(Sender: TObject);
    procedure ButFFBlueClick(Sender: TObject);
    procedure butFFTotModRedClick(Sender: TObject);
    procedure butFFTotModBlueClick(Sender: TObject);
    procedure ButPurchaseRedClick(Sender: TObject);
    procedure ButPurchaseBlueClick(Sender: TObject);
    procedure MVPplayerMouseMove(
          Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure TxtMWModRedExit(Sender: TObject);
    procedure TxtMWModBlueExit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPostgame: TfrmPostgame;
  MVPplayer: array [0..1, 1..10] of TLabel;
  PostgameActive: boolean;

procedure PlayActionStartPostGame(s: string; dir: integer);
procedure PlayActionMatchWinnings(s: string; dir: integer);
procedure MatchWinnings(tm: integer);
procedure PlayActionMatchWinningsMod(s: string; dir: integer);
procedure MatchWinningsModifier(tm: integer);
procedure CreateMVPplayer(tm, pl: integer);
procedure PlayActionMVP(s: string; dir: integer);
procedure MVP(tm: integer);
{Ronald EXP change:
procedure MakeEXPRolls;}
procedure MakeEXPRolls(g: integer);
function CalculateTeamRating(g: integer): integer;

implementation

{$R *.DFM}
uses unitPlayer, bbunit, unitLog, bbalg, unitPlayAction, unitFanFactor,
     unitMarker, unitRandom, unitTeam, unitSkillRoll, unitRoster,
  unitSettings;

var MatchResult: array [0..2] of string;

procedure PlayActionStartPostGame(s: string; dir: integer);
begin
  if dir = 1 then begin
    SetFanFactorModifiers;
    frmPostgame.GBPostgameRed.caption := team[0].name;
    frmPostgame.GBPostgameBlue.caption := team[1].name;
    frmPostgame.Show;
    frmPostgame.BringToFront;
    DefaultAction('Start of Post-Game Sequence');
    PostgameActive := true;
    frmPostgame.lblNewTRRed.caption := IntToStr(CalculateTeamRating(0));
    frmPostgame.lblNewTRBlue.caption := IntToStr(CalculateTeamRating(1));
    {Disable the MVP button for BribeTheAnnouncers}
    if BribeTheAnnouncers then begin
      if team[0].tr < team[1].tr then begin
        frmPostgame.ButMVPRed.enabled := false;
        frmPostgame.ButSkillrollRed.enabled := true;
      end else begin
        frmPostgame.ButMVPBlue.enabled := false;
        frmPostgame.ButSkillrollBlue.enabled := true;
      end;
    end;
  end else begin
    frmPostgame.Hide;
    BackLog;
    PostgameActive := false;
  end;
end;

procedure PlayActionMatchWinnings(s: string; dir: integer);
var tm, r, result, mw, w, t: integer;
    s0: string;
begin
  tm := Ord(s[3]) - 48;
  r := Ord(s[4]) - 64;
  mw := Ord(s[5]) - 64;
  result := Ord(s[6]) - 65;
  w := Ord(s[7]) - 64;
  t := Ord(s[8]) - 64;
  if length(s) < 9 then s := s + '@';
  if dir = 1 then begin
    {update treasury with matchwinnings... Ord(s[9]) has the old
     value of matchwinnings just in case...}
    team[tm].treasury := IntToStr(MoneyVal(team[tm].treasury) +
        (r + mw + w + t - Ord(s[9]) + 64) * 10) + 'k';
    team[tm].matchwinnings := r + mw + w + t;
    if tm = 0 then begin
      frmPostgame.ImMWDieRed.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + '.bmp');
      frmPostgame.ImMWDieRed.visible := true;
      frmPostgame.LblMWWTLRed.hint := MatchResult[result];
      frmPostgame.LblMWRollRed.caption := IntToStr(r);
      frmPostgame.LblMWTableRed.caption := IntToStr(mw);
      frmPostgame.LblMWWTLRed.caption := IntToStr(w + t);
      frmPostgame.TxtMWModRed.enabled := true;
      frmPostgame.LblMWTotRed.caption := IntToStr(team[tm].matchwinnings) + '0';
      frmPostgame.ButMWRed.enabled := false;
      frmPostgame.ButPurchaseRed.enabled := true;
      frmPostgame.lblNewTRRed.caption := IntToStr(CalculateTeamRating(0));
    end else begin
      frmPostgame.ImMWDieBlue.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + 'b.bmp');
      frmPostgame.ImMWDieBlue.visible := true;
      frmPostgame.LblMWWTLBlue.hint := MatchResult[result];
      frmPostgame.LblMWRollBlue.caption := IntToStr(r);
      frmPostgame.LblMWTableBlue.caption := IntToStr(mw);
      frmPostgame.LblMWWTLBlue.caption := IntToStr(w + t);
      frmPostgame.TxtMWModBlue.enabled := true;
      frmPostgame.LblMWTotBlue.caption := IntToStr(r + mw + w + t) + '0';
      frmPostgame.ButMWBlue.enabled := false;
      frmPostgame.ButPurchaseBlue.enabled := true;
      frmPostgame.lblNewTRBlue.caption := IntToStr(CalculateTeamRating(1));
    end;
    s0 := 'Match winnings for ' + ffcl[tm] + ': ' + IntToStr(r);
    s0 := s0 + ' + ' + IntToStr(mw) + ' (Match Winnings Table)';
    if w > 0 then s0 := s0 + ' + ' + IntToStr(w) + ' (Won Match)';
    if t > 0 then s0 := s0 + ' + ' + IntToStr(t) + ' (Tied Match)';
    s0 := s0 + ' x10k = ' + IntToStr(r + mw + w + t) + '0k';
    DefaultAction(s0);
  end else begin
    if tm = 0 then begin
      frmPostgame.ImMWDieRed.visible := false;
      frmPostgame.LblMWWTLRed.hint := '';
      frmPostgame.LblMWRollRed.caption := '';
      frmPostgame.LblMWTableRed.caption := '';
      frmPostgame.LblMWWTLRed.caption := '';
      frmPostgame.TxtMWModRed.enabled := false;
      frmPostgame.LblMWTotRed.caption := '';
      frmPostgame.ButMWRed.enabled := true;
      frmPostgame.ButPurchaseRed.enabled := false;
    end else begin
      frmPostgame.ImMWDieBlue.visible := false;
      frmPostgame.LblMWWTLBlue.hint := '';
      frmPostgame.LblMWRollBlue.caption := '';
      frmPostgame.LblMWTableBlue.caption := '';
      frmPostgame.LblMWWTLBlue.caption := '';
      frmPostgame.TxtMWModBlue.enabled := false;
      frmPostgame.LblMWTotBlue.caption := '';
      frmPostgame.ButMWBlue.enabled := true;
      frmPostgame.ButPurchaseBlue.enabled := false;
    end;
    team[tm].treasury := IntToStr(MoneyVal(team[tm].treasury) -
        (r + mw + w + t - Ord(s[9]) + 64) * 10) + 'k';
    team[tm].matchwinnings := Ord(s[9]) - 64;
    BackLog;
  end;
end;

procedure MatchWinnings(tm: integer);
var s, MWT: string;
    result, r, mw, k, w, t, trgroup, LustrianMod: integer;
    gg: TextFile;
begin
  {roll die}
  r := Rnd(6,2) + 1;
  {get modifier from Match Winnings Table}
  AssignFile(gg, curdir + 'ini\bbtables.ini');
  Reset(gg);
  ReadLn(gg, s);
  MWT := Trim(frmSettings.txtMWTable.text);
  while Copy(s, 2, length(MWT)) <> MWT do ReadLn(gg, s);
  ReadLn(gg, s);
  k := 12;
  while (k < length(s)) and (FVal(copy(s, k ,3)) <> 0)
        and (FVal(copy(s, k, 3)) < team[tm].tr) do k := k + 8;
  ReadLn(gg, s);
  while (FVal(copy(s, 5, 3)) < Gate) and (FVal(copy(s, 5, 3)) <> 0)
        do ReadLn(gg, s);
  mw := FVal(copy(s, k - 1, 2));
  CloseFile(gg);

  {Lustrian Win Modifier}
  if (Trim(frmSettings.txtHandicapTable.text)='H5') then begin
    if team[tm].tr < 100 then trgroup := 0 else
    if (team[tm].tr >= 100) and (team[tm].tr <= 150) then trgroup := 2 else
    if (team[tm].tr >= 151) and (team[tm].tr <= 200) then trgroup := 4 else
    trgroup := 6;
    LustrianMod := team[tm].bonusMVP - trgroup;
    if LustrianMod < 0 then LustrianMod := 0;
    mw := mw + LustrianMod;
  end;

  if team[tm].winmod <> 0 then mw := mw + team[tm].winmod;

  {get Won Match/Tied Match modifier}
  w := 0;
  t := 0;
  if marker[tm, MT_Score].value > marker[1-tm, MT_Score].value then begin
    w := frmSettings.rgWonMatchMod.ItemIndex + 1;
    result := 2;
  end else begin
    if marker[tm, MT_Score].value > marker[1-tm, MT_Score].value then begin
      if frmSettings.rgTiedMatchMod.ItemIndex > 0 then
                           t := frmSettings.rgTiedMatchMod.ItemIndex;
      result := 1;
    end else begin
      result := 0;
    end;
  end;

  {Change Match Win Modifier if total gold would be less than zero}
  if ((r + mw + w + t) < 0) and (not(frmSettings.cbNegativeWinnings.checked))
    then mw := mw + ((r + mw + w + t) * (-1));

  s := 'w0' + Chr(tm + 48) + Chr(r + 64) + Chr(mw + 64) +
             Chr(result + 65) + Chr(w + 64) + Chr(t + 64) +
             Chr(team[tm].matchwinnings + 64);
  if CanWriteToLog then begin
    PlayActionMatchWinnings(s, 1);
    LogWrite(s);
  end;
end;

procedure PlayActionMatchWinningsMod(s: string; dir: integer);
var tm, m, mn, mo, p: integer;
begin
  tm := Ord(s[3]) - 64;
  p := Pos('~', s);
  mo := FVal(Copy(s, 4, p-1));
  mn := FVal(Copy(s, p+1, Length(s) - p));
  if dir = 1 then begin
    DefaultAction(ffcl[tm] + ': Match Winnings Modified by ' + IntToStr(mn));
    team[tm].treasury := IntToStr(MoneyVal(team[tm].treasury) + mn - mo) + 'k';
    m := mn;
  end else begin
    if tm = 0 then frmPostgame.TxtMwModRed.Text := ''
              else frmPostgame.TxtMwModBlue.Text := '';
    team[tm].treasury := IntToStr(MoneyVal(team[tm].treasury) - mn + mo) + 'k';
    m := mo;
    BackLog;
  end;
  team[tm].matchwinningsmod := m;
  if tm = 0 then begin
    if m = 0 then frmPostgame.TxtMwModRed.Text := ''
             else frmPostgame.TxtMwModRed.Text := IntToStr(m);
    frmPostgame.LblMWTotRed.caption :=
       IntToStr(10 * team[tm].matchwinnings + team[tm].matchwinningsmod);
    frmPostgame.lblNewTRRed.caption := IntToStr(CalculateTeamRating(0));
  end else begin
    if m = 0 then frmPostgame.TxtMwModBlue.Text := ''
             else frmPostgame.TxtMwModBlue.Text := IntToStr(m);
    frmPostgame.LblMWTotBlue.caption :=
       IntToStr(10 * team[tm].matchwinnings + team[tm].matchwinningsmod);
    frmPostgame.lblNewTRBlue.caption := IntToStr(CalculateTeamRating(1));
  end;
end;

procedure MatchWinningsModifier(tm: integer);
var m: integer;
    s: string;
begin
  if tm = 0 then
    m := FVal(frmPostgame.TxtMwModRed.Text)
  else
    m := FVal(frmPostgame.TxtMwModBlue.Text);
  if m <> team[tm].matchwinningsmod then begin
    if 10 * team[tm].matchwinnings + m < 0 then begin
      ShowMessage('You can''t lose money on Match Winnings!');
      if tm = 0 then frmPostgame.TxtMwModRed.Text := ''
                else frmPostgame.TxtMwModBlue.Text := '';
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

  if tm = 0 then MVPplayer[tm,pl].parent := frmPostgame.GBPostgameRed
            else MVPplayer[tm,pl].parent := frmPostgame.GBPostgameBlue;
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
    if tm = 0 then begin
      frmPostgame.ButMVPRed.enabled := false;
      frmPostgame.ButSkillrollRed.enabled := true;
      frmPostgame.lblNewTRRed.caption := IntToStr(CalculateTeamRating(0));
    end else begin
      frmPostgame.ButMVPBlue.enabled := false;
      frmPostgame.ButSkillrollBlue.enabled := true;
      frmPostgame.lblNewTRBlue.caption := IntToStr(CalculateTeamRating(1));
    end;
  end else begin
    if tm = 0 then frmPostgame.ButMVPRed.enabled := true
              else frmPostgame.ButMVPBlue.enabled := true;
    if tm = 0 then frmPostgame.ButSkillrollRed.enabled := false
              else frmPostgame.ButSkillrollBlue.enabled := false;
    for f := 1 to team[tm].numplayers do player[tm,f].mvp := 0;
    for f := 1 to 10 do MVPplayer[tm,f].visible := false;
    BackLog;
  end;
end;

procedure MVP(tm: integer);
var c, f, r, numEligible, GoodPlayer, ExtraMVPs: integer;
    gotMVP: array [1..MaxNumPlayersInTeam] of boolean;
    s: string;
    NoMVPs, MVPBench: boolean;
begin
  s := 'D' + Chr(tm + 48);
  c := 0;
  numEligible := 0;
  noMVPs := frmSettings.cbNoMVPs.checked;
  MVPBench := frmSettings.cbMVPBench.Checked;
  for f := 1 to team[tm].numplayers do
    if ((player[tm,f].PlayedThisMatch) and not (NoMVPs)) or
     ((player[tm,f].PlayedThisMatch) and (NoMVPs) and
      not (player[tm,f].status = 8) and not (player[tm,f].HasSkill('No MVPs')))
      or ((MVPBench) and (((player[tm,f].status <> 9) and (player[tm,f].status<>10)
      and (player[tm,f].status<>11)) or (player[tm,f].PlayedThisMatch)))
      then numEligible := numEligible + 1;
  for f := 1 to team[tm].numplayers do gotMVP[f] := false;
  if (Trim(frmSettings.txtHandicapTable.text)<>'H5') then
    ExtraMVPs := 0 else ExtraMVPs := team[tm].bonusMVP;
  while (c <= ExtraMVPs) and (c < numEligible)
    do begin
    r := Rnd(team[tm].numplayers, 6) + 1;
    if (not MVPBench) and (not player[tm,r].PlayedThisMatch) then GoodPlayer := 0 else
       if (MVPBench) and (player[tm,r].status >= 9) and (player[tm,r].status <= 10)
         and not (player[tm,r].PlayedThisMatch) then GoodPlayer := 0 else
       if (gotMVP[r]) then GoodPlayer := 0 else
       if (player[tm,r].status = 8) and (NoMVPs) then GoodPlayer := 0 else
       if (player[tm,r].status = 11) then GoodPlayer := 0 else
       if (player[tm,r].HasSkill('No MVPs')) and (NoMVPs)
       then GoodPlayer := 0 else GoodPlayer := 1;
   while GoodPlayer = 0
      do begin
        r := Rnd(team[tm].numplayers, 6) + 1;
        if (not MVPBench) and (not player[tm,r].PlayedThisMatch) then GoodPlayer := 0 else
          if (MVPBench) and (player[tm,r].status >= 9) and (player[tm,r].status <= 10)
            and not (player[tm,r].PlayedThisMatch) then GoodPlayer := 0 else
          if (gotMVP[r]) then GoodPlayer := 0 else
          if (player[tm,r].status = 8) and (NoMVPs) then GoodPlayer := 0 else
          if (player[tm,r].status = 11) then GoodPlayer := 0 else
          if (player[tm,r].HasSkill('No MVPs')) and (NoMVPs)
          then GoodPlayer := 0 else GoodPlayer := 1;
      end;
    gotMVP[r] := true;
    s := s + Chr(r + 64);
    c := c + 1;
  end;
  if CanWriteToLog then begin
    PlayActionMVP(s, 1);
    LogWrite(s);
  end;
end;

{Ronald EXP change:
procedure MakeEXPRolls;
var f, g, CurExp, GoodPlayer, r, Ageroll: integer;}
procedure MakeEXPRolls(g: integer);
var f, CurExp, GoodPlayer, r, Ageroll, Ageroll1, AgeRoll2: integer;
    noMVPs, MVPBench, EXPSuccess: boolean;
    t, s, sk, s2: string;
begin
  noMVPs := frmSettings.cbNoMVPs.checked;
  MVPBench := frmSettings.cbMVPBench.Checked;
  {Ronald EXP change:
  for g := 0 to 1 do begin}
    t := Chr(255) + 'EXP Rolls for '+ffcl[g] + ' ';
    if CanWriteToLog then begin
      PlayActionComment(t, 1, 2);
      LogWrite(t);
    end;
    {Ronald EXP change:}
    Continuing := true;
    {to make sure the whole EXP rolls event will be rolled back as 1 action,
    all that follows is a 'continuing' of the message above}
    for f := 1 to team[g].numplayers do begin
      Ageroll := 0;
      if (not MVPBench) and (not player[g,f].PlayedThisMatch) then GoodPlayer := 0 else
        if (MVPBench) and (player[g,f].status >= 9) and (player[g,f].status <= 10)
          and not (player[g,f].PlayedThisMatch) then GoodPlayer := 0 else
        if (player[g,f].status = 8) or (player[g,f].status = 11)
           then GoodPlayer := 0 else
        if (player[g,f].HasSkill('No MVPs')) and (NoMVPs)
        then GoodPlayer := 0 else GoodPlayer := 1;
      if GoodPlayer = 1 then begin
        EXPSuccess := false;
        r := Rnd(6, 5) + 1;
        {REMOVED CODE: FOR CHANGE TO EXP HANDICAPS
        if BribeTheAnnouncers then begin
          if (r > 1) or (r < 6) then r := r + 1;
        end;}
        CurExp := player[g,f].mvp + player[g,f].mvp0;
        if r>CurExp then EXPSuccess := true else if r=6 then EXPSuccess := true;
        if r=1 then EXPSuccess := false;
        t := 'sE' + Chr(g + 48) + Chr(f + 64) + Chr(CurExp + 64) + Chr(r + 64);
        if EXPSuccess then begin
          t := t + 'U';
        end else if (r=1) and (CurEXP>=(FVal(frmSettings.txtEXPAgingPoint.text)))
          and (not(player[g,f].hasSkill('Ageless')))
          then begin
          Ageroll1 := (Rnd(6, 4) + 1);
          Ageroll2 := (Rnd(6, 4) + 1);
          Ageroll := Ageroll1 + Ageroll2;
          if not(frmSettings.cbEXPSI.checked) then begin
            case Ageroll of
            7 : begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'T';
                end;
            6 : begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'N';
                end;
            5 : begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'V';
                end;
            4: begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'M';
                end;
            3: begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'G';
                end;
            2: begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'S';
                end;
            else begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + '-';
                end;
            end;
          end else begin
            case Ageroll1 of
            4 : begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'N';
                end;
            5 : begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'N';
                end;
            6 : begin
                  if Ageroll2 <= 2 then
                    t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'M';
                  if Ageroll2 = 3 then
                    t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'S';
                  if Ageroll2 = 4 then
                    t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'G';
                  if Ageroll2 >= 5 then
                    t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'V';
                end;
            else begin
                  t := t + Chr(Ageroll1 + 64) + Chr(Ageroll2 + 64) + 'T';
                end;
            end;
          end;
        end else begin
          t := t + 'F';
        end;
        if CanWriteToLog then begin
          PlayActionSkillRoll(t, 1);
          LogWrite(t);
        end;
        if not(frmSettings.cbEXPSI.checked) then begin
          case Ageroll of
            5: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 AV';
                 s := player[g, f].GetSkillString(1) + ', -1 AV';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
            4: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 MA';
                 s := player[g, f].GetSkillString(1) + ', -1 MA';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
            3: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 AG';
                 s := player[g, f].GetSkillString(1) + ', -1 AG';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
                end;
            2: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 ST';
                 s := player[g, f].GetSkillString(1) + ', -1 ST';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
          end;
        end else begin
          case Ageroll2 of
            6: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 AV';
                 s := player[g, f].GetSkillString(1) + ', -1 AV';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
            5: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 AV';
                 s := player[g, f].GetSkillString(1) + ', -1 AV';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
            4: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 AG';
                 s := player[g, f].GetSkillString(1) + ', -1 AG';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
                end;
            3: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 ST';
                 s := player[g, f].GetSkillString(1) + ', -1 ST';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
            2: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 MA';
                 s := player[g, f].GetSkillString(1) + ', -1 MA';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
            1: begin
                 s2 := 'u' + Chr(g + 48) + Chr(f + 64) +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1) + '|' +
                   Chr(player[g, f].ma + 48) +
                   Chr(player[g, f].st + 48) +
                   Chr(player[g, f].ag + 48) +
                   Chr(player[g, f].av + 48) +
                   Chr(player[g,f].cnumber + 64) +
                   Chr(player[g,f].value div 5 + 48) +
                   player[g,f].name + '$' +
                   player[g,f].position + '$' +
                   player[g,f].picture + '$' +
                   player[g,f].icon + '$' +
                   player[g, f].GetSkillString(1)
                   + ', -1 MA';
                 s := player[g, f].GetSkillString(1) + ', -1 MA';
                 player[g, f].SetSkill(s);
                 LogWrite(s2);
                 PlayActionPlayerStatChange(s2, 1);
               end;
          end;
        end;
      end;
    end;
  {Ronald EXP change:
  end;}
  Continuing := false;
  {end change}
end;

procedure TfrmPostgame.ButMWRedClick(Sender: TObject);
begin
  MatchWinnings(0);
end;

procedure TfrmPostgame.ButMWBlueClick(Sender: TObject);
begin
  MatchWinnings(1);
end;

procedure TfrmPostgame.ButMVPRedClick(Sender: TObject);
begin
{Ronald EXP change:}
  if (frmSettings.rgAging.ItemIndex = 3) and (frmSettings.cbMVPEXP.checked)
    then begin
    MakeEXPRolls(0);
    MVP(0);
  end else if (frmSettings.rgAging.ItemIndex = 3) and (not(frmSettings.cbMVPEXP.checked))
    then
    MakeEXPRolls(0)
  else
  {change end}
  MVP(0);
end;

procedure TfrmPostgame.ButMVPBlueClick(Sender: TObject);
begin
{Ronald EXP change:}
  if (frmSettings.rgAging.ItemIndex = 3) and (frmSettings.cbMVPEXP.checked)
    then begin
    MakeEXPRolls(1);
    MVP(1);
  end else if (frmSettings.rgAging.ItemIndex = 3) and (not(frmSettings.cbMVPEXP.checked))
    then
    MakeEXPRolls(1)
  else
  {change end}
  MVP(1);
end;

procedure TfrmPostgame.ButSkillRollRedClick(Sender: TObject);
begin
  MakeSkillRolls(0);
end;

procedure TfrmPostgame.ButSkillRollBlueClick(Sender: TObject);
begin
  MakeSkillRolls(1);
end;

procedure TfrmPostgame.ButFFRedClick(Sender: TObject);
begin
  FanFactor(0);
end;

procedure TfrmPostgame.ButFFBlueClick(Sender: TObject);
begin
  FanFactor(1);
end;

procedure TfrmPostgame.butFFTotModRedClick(Sender: TObject);
begin
  FanFactorShow(0);
end;

procedure TfrmPostgame.butFFTotModBlueClick(Sender: TObject);
begin
  FanFactorShow(1);
end;

procedure TfrmPostgame.ButPurchaseRedClick(Sender: TObject);
begin
  MakePurchases(0);
end;

procedure TfrmPostgame.ButPurchaseBlueClick(Sender: TObject);
begin
  MakePurchases(1);
end;

procedure TfrmPostgame.FormCreate(Sender: TObject);
var f, g: integer;
begin
  MatchResult[0] := 'Lost Match';
  MatchResult[1] := 'Tied Match';
  MatchResult[2] := 'Won Match';
  for g := 0 to 1 do
   for f := 1 to 10 do begin
    MVPplayer[g,f] := TLabel.Create(Bloodbowl);
    CreateMVPplayer(g, f);
    MVPplayer[g,f].OnMouseMove := MVPplayerMouseMove;
   end;
  PostgameActive := false;
end;

procedure TfrmPostgame.MVPplayerMouseMove(
          Sender: TObject; Shift: TShiftState; X, Y: Integer);
var tm, pl: integer;
begin
  if (Sender as TLabel).parent = GBPostgameRed then tm := 0 else tm := 1;
  pl := FVal((Sender as TLabel).caption);
  player[tm,pl].ShowPlayerDetails;
end;

function CalculateTeamRating(g: integer): integer;
var f, tr, valtot, spp, MVPValue: integer;
begin
  spp := 0;
  valtot := 0;
  for f := 1 to team[g].numplayers do begin
    if not((player[g,f].status = 8) or (player[g,f].status = 11)) then begin
      valtot := valtot + player[g,f].value;
      if (frmSettings.rgAging.ItemIndex = 3) and (not(frmSettings.cbMVPEXP.checked))
        then MVPValue := 1 else MVPValue := FVal(frmSettings.txtMVPValue.text);
      spp := spp + MVPValue * (player[g,f].mvp + player[g,f].mvp0)
                 + 2 * (player[g,f].int + player[g,f].int0)
                 + 3 * (player[g,f].td + player[g,f].td0)
                 + 2 * (player[g,f].cas + player[g,f].cas0)
                 + player[g,f].comp + player[g,f].comp0
                 + player[g,f].OtherSPP + player[g,f].OtherSPP0
                 + player[g,f].exp + player[g,f].exp0;
    end;
  end;
  tr := valtot div 10 + spp div 5;
  tr := tr + team[g].reroll * team[g].rerollcost div 10;
  tr := tr + team[g].ff;
  tr := tr + team[g].cheerleaders;
  tr := tr + team[g].asstcoaches;
  if frmSettings.cbApoths.checked then tr := tr + team[g].apot else
    tr := tr + team[g].apot * 5;
  if frmSettings.cbWizards.checked then tr := tr + team[g].wiz * 5 else
    tr := tr + team[g].wiz * 15;
  if frmSettings.cbNegativeWinnings.Checked then
    tr := tr + Abs(MoneyVal(team[g].treasury)) div 10 
    else tr := tr + MoneyVal(team[g].treasury) div 10;
  CalculateTeamRating := tr;
end;

procedure TfrmPostgame.TxtMWModRedExit(Sender: TObject);
begin
  MatchWinningsModifier(0);
end;

procedure TfrmPostgame.TxtMWModBlueExit(Sender: TObject);
begin
  MatchWinningsModifier(1);
end;

end.


