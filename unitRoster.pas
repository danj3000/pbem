unit unitRoster;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls,
  bbalg, bbunit, unitTeam;

type
  TfrmRoster = class(TForm)
    GroupBox1: TGroupBox;
    BeforeRB: TRadioButton;
    GameRB: TRadioButton;
    TotalRB: TRadioButton;
    teamnameLabel: TLabel;
    pnlTeam: TPanel;
    coachLabel: TLabel;
    raceLabel: TLabel;
    trLabel: TLabel;
    treasuryLabel: TLabel;
    race: TLabel;
    coach: TLabel;
    tr: TLabel;
    treasury: TLabel;
    rerollsLabel: TLabel;
    fanfactorLabel: TLabel;
    asstcoachesLabel: TLabel;
    cheerleadersLabel: TLabel;
    apotLabel: TLabel;
    wizLabel: TLabel;
    rerolls: TLabel;
    fanfactor: TLabel;
    asstcoaches: TLabel;
    cheerleaders: TLabel;
    apot: TLabel;
    wiz: TLabel;
    sbPlayers: TScrollBox;
    txtRerollNew: TEdit;
    txtFanFactorNew: TEdit;
    txtTreasuryNew: TEdit;
    cmdChangeStats: TButton;
    cmdUseNew: TButton;
    cmdAddPlayer: TButton;
    butBuyReroll: TButton;
    butBuyAsstCoach: TButton;
    butBuyCheerleader: TButton;
    butBuyApo: TButton;
    butBuyWizard: TButton;
    butUpdateTeamRoster: TButton;
    OpenDialog1: TOpenDialog;
    email: TLabel;
    lblemail: TLabel;
    procedure InitForm;
    procedure BeforeRBClick(Sender: TObject);
    procedure GameRBClick(Sender: TObject);
    procedure TotalRBClick(Sender: TObject);
    procedure cmdChangeStatsClick(Sender: TObject);
    procedure cmdUseNewClick(Sender: TObject);
    procedure cmdAddPlayerClick(Sender: TObject);
    procedure butBuyRerollClick(Sender: TObject);
    procedure butBuyAsstCoachClick(Sender: TObject);
    procedure butBuyCheerleaderClick(Sender: TObject);
    procedure butBuyApoClick(Sender: TObject);
    procedure butBuyWizardClick(Sender: TObject);
    procedure butUpdateTeamRosterClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TRetireButton = class(TButton)
  public
    nr: integer;
    constructor Create(Sender: TForm; f: integer);
    procedure RetireButtonClick(Sender: TObject);
  end;

var
  frmRoster: TfrmRoster;
  curroster: integer;
  lb: array [0..MaxNumPlayersInTeam, 0..17] of TLabel;
  butRetire: array [0..MaxNumPlayersInTeam] of TRetireButton;
  status: array [0..14] of string;

function TranslateRetire(s: string): string;
procedure PlayActionRetire(s: string; dir: integer);
procedure ShowTeam(g: integer);
procedure PlayActionBuy(s: string; dir: integer);
procedure MakePurchases(g: integer);
procedure Buy(t: string);

implementation

uses unitLog, unitAddPlayer, unitSkillRoll, unitPlayAction, unitMarker,
     unitPostgameSeq, unitExtern, unitPlayer, unitTurnChange, unitSettings;
{$R *.DFM}

constructor TRetireButton.Create(Sender: TForm; f: integer);
begin
  inherited Create(Sender);
  top := lb[f,0].Top;
  left := lb[f,17].left + lb[f,17].width + 4;
  height := 16;
  Width := 34;
  caption := 'Retire';
  Parent := frmRoster.sbPlayers;
  visible := false;
  nr := f;
  OnClick := RetireButtonClick;
end;

function TranslateRetire(s: string): string;
var f, g, st: integer;
    t: string;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  st := Ord(s[Length(s)]) - 64;
  t := player[g,f].GetPlayerName;
  if st = 8 then t := t + ' is removed from the team roster'
            else t := t + ' retires and becomes assistant coach';
  TranslateRetire := t;
end;

procedure PlayActionRetire(s: string; dir: integer);
var f, g, st: integer;
begin
  g := Ord(s[2]) - 48;
  f := Ord(s[3]) - 64;
  st := Ord(s[Length(s)]) - 64;
  if dir = DIR_FORWARD then begin
    if (st <> 8) and (Uppercase(team[g].race) <> 'NURGLES ROTTERS') then begin
      team[g].asstcoaches := team[g].asstcoaches + 1;
    end;
    player[g,f].status := 11;
    DefaultAction(TranslateRetire(s));
    player[g,f].visible := false;
  end else begin
    {restoring all settings for the player is the same as loading him}
    if (st <> 8) and (Uppercase(team[g].race) <> 'NURGLES ROTTERS') then begin
      team[g].asstcoaches := team[g].asstcoaches - 1;
    end;
    PlayActionLoadTeam(Copy(s, 1, length(s)-1), 1);
    BackLog;
    player[g,f].status := st;
    player[g,f].visible := true;
    player[g,f].Redraw;
  end;
  RedrawDugOut;

end;

procedure TRetireButton.RetireButtonClick(Sender: TObject);
var s: string;
begin
  s := 'Are you sure you want to ';
  if player[curroster,nr].status = 8
       then s := s + 'clear '
       else s := s + 'retire ';
  s := s + player[curroster,nr].GetPlayername + '?';
  if Application.MessageBox(PChar(s),
                  'Confirmation', MB_OKCANCEL) = IDOK then begin
    s := 'R' + player[curroster,nr].GetSaveString +
                      Chr(player[curroster,nr].status + 64);
    LogWrite(s);
    PlayActionRetire(s, 1);
    ShowTeam(curroster);
  end;
end;

procedure TfrmRoster.InitForm;
var f, h: integer;
    w: array[0..17] of integer;
begin
  w[0] := 14;
  w[1] := 100;
  w[2] := 100;
  w[3] := 21;
  w[4] := 21;
  w[5] := 21;
  w[6] := 21;
  w[7] := 250;
  w[8] := 28;
  w[9] := 0;
  w[10] := 28;
  w[11] := 28;
  w[12] := 28;
  w[13] := 28;
  w[14] := 28;
  w[15] := 0;
  w[16] := 28;
  w[17] := 28;
  frmRoster.height := 525;
  for f := 0 to MaxNumPlayersInTeam do begin
    for h := 0 to 17 do begin
      lb[f,h] := TLabel.Create(frmRoster);
      if f = 0 then lb[f,h].top := 32 else lb[f,h].top := f * 16 - 14;
      if h = 0 then lb[f,h].left := 2 else begin
        if lb[f,h-1].width = 0
           then lb[f,h].left := lb[f,h-1].left + lb[f,h-1].width
           else lb[f,h].left := lb[f,h-1].left + lb[f,h-1].width + 2;
      end;
      lb[f,h].autosize := false;
      lb[f,h].width := w[h];
      lb[f,h].height := 14;
      if (h = 1) or (h = 2) or (h = 7)
               then lb[f,h].alignment := taLeftJustify
               else lb[f,h].alignment := taCenter;
      if (f > 0) and (h > 0) and (h <> 16) then lb[f,h].color := clWhite;
      if f = 0 then lb[f,h].parent := frmRoster
               else lb[f,h].parent := sbPlayers;
    end;
    if f > 0 then begin
      lb[f,0].caption := '';
      lb[f,16].color := clYellow;
     end;
    lb[f,0].font.color := clRed;
    butRetire[f] := TRetireButton.Create(frmRoster, f);
  end;
  frmRoster.width := lb[0,17].left + w[17] + 16;
  sbPlayers.top := 48;
  sbPlayers.left := 0;
  sbPlayers.width := frmRoster.ClientWidth;
  sbPlayers.height := 262;
  Groupbox1.left := lb[0,9].left +
          (lb[0,14].left + w[16] - lb[0,9].left - Groupbox1.width) div 2;
  Groupbox1.top := 0;
  lb[0,1].caption := 'Name';
  lb[0,2].caption := 'Position';
  lb[0,3].caption := 'MA';
  lb[0,4].caption := 'ST';
  lb[0,5].caption := 'AG';
  lb[0,6].caption := 'AV';
  lb[0,7].caption := 'Skills';
  lb[0,8].caption := 'Inj';
  lb[0,9].caption := 'Other';
  lb[0,10].caption := 'Comp';
  lb[0,11].caption := 'TD';
  lb[0,12].caption := 'Cas';
  lb[0,13].caption := 'Int';
  lb[0,14].Caption := 'MVP';
  lb[0,15].caption := 'EXP';
  lb[0,16].caption := 'Tot';
  lb[0,17].caption := 'Status';
  teamnameLabel.left := lb[0,1].left;
  teamnameLabel.top := 4;
  teamnameLabel.width := lb[0,9].left - lb[0,1].left;
  pnlTeam.left := 10;
  pnlTeam.Top := sbPlayers.Top + sbPlayers.height + 4;
  pnlTeam.width := frmRoster.ClientWidth - 15;
  pnlTeam.height := 90;
  frmRoster.height := pnlTeam.top + pnlTeam.height + 28;
  raceLabel.left := lb[0,1].left - 10;
  raceLabel.top := 4;
  race.left := lb[0,2].left - 10;
  race.top := raceLabel.top;
  race.height := 14;
  coachLabel.left := raceLabel.left;
  coachLabel.top := raceLabel.top + 16;
  coach.left := race.left;
  coach.top := coachLabel.top;
  coach.height := 14;
  email.Left := coach.Left;
  email.Top := coach.top + 48;
  lblemail.Left := coachLabel.Left;
  lblemail.top := coachLabel.Top + 48;
  email.Height := 14;
  trLabel.left := raceLabel.left;
  trLabel.top := coachLabel.top + 16;
  tr.left := race.left;
  tr.top := trLabel.top;
  tr.height := 14;
  treasuryLabel.left := raceLabel.left;
  treasuryLabel.top := trLabel.top + 16;
  treasury.left := race.left;
  treasury.top := treasuryLabel.top;
  treasury.height := 14;
  rerollsLabel.left := lb[0,7].left + 90;
  rerollsLabel.top := raceLabel.top;
  rerolls.left := lb[0,8].left - rerolls.width - 12;
  rerolls.top := rerollsLabel.top;
  rerolls.height := 14;
  butBuyReroll.top := rerolls.top - 2;
  butBuyReroll.left := rerolls.left + rerolls.width + 32;
  fanfactorLabel.left := rerollsLabel.left;
  fanfactorLabel.top := rerollsLabel.top + 16;
  fanfactor.left := rerolls.left;
  fanfactor.top := fanfactorLabel.top;
  fanfactor.height := 14;
  asstcoachesLabel.left := lb[0,11].left - 10;
  asstcoachesLabel.top := raceLabel.top;
  asstcoaches.left := lb[0,16].left - 10;
  asstcoaches.top := asstcoachesLabel.top;
  asstcoaches.height := 14;
  butBuyAsstCoach.top := asstcoaches.top;
  butBuyAsstCoach.left := asstcoaches.left + asstcoaches.width + 4;
  cheerleadersLabel.left := asstcoachesLabel.left;
  cheerleadersLabel.top := asstcoachesLabel.top + 16;
  cheerleaders.left := asstcoaches.left;
  cheerleaders.top := cheerleadersLabel.top;
  cheerleaders.height := 14;
  butBuyCheerleader.top := cheerleaders.top;
  butBuyCheerleader.left := cheerleaders.left + cheerleaders.width + 4;
  apotLabel.left := asstcoachesLabel.left;
  apotLabel.top := cheerleadersLabel.top + 16;
  apot.left := asstcoaches.left;
  apot.top := apotLabel.top;
  apot.height := 14;
  butBuyApo.top := apot.top;
  butBuyApo.left := apot.left + apot.width + 4;
  wizLabel.left := asstcoachesLabel.left;
  wizLabel.top := apotLabel.top + 16;
  wiz.left := asstcoaches.left;
  wiz.top := wizLabel.top;
  wiz.height := 14;
  butBuyWizard.top := wiz.top;
  butBuyWizard.left := wiz.left + wiz.width + 4;
  status[0] := 'Res';
  status[1] := 'Ok';
  status[2] := 'Ball';
  status[3] := 'Prone';
  status[4] := 'Stun';
  status[5] := 'KO';
  status[6] := 'BH';
  status[7] := 'SI';
  status[8] := 'DEAD';
  status[9] := 'Nigg';
  status[10] := 'Miss';
  status[11] := '';
  status[12] := 'SO';
  status[13] := 'T Out';
  status[14] := 'Heat';
  txtRerollNew.top := rerolls.top - 2;
  txtRerollNew.left := rerolls.left + rerolls.width + 3;
  txtRerollNew.visible := false;
  txtFanFactorNew.top := fanfactor.top - 2;
  txtFanFactorNew.left := fanfactor.left + fanfactor.width + 3;
  txtFanFactorNew.visible := false;
  txtTreasuryNew.top := treasury.top - 2;
  txtTreasuryNew.left := treasury.left + treasury.width + 3;
  txtTreasuryNew.visible := false;
  cmdChangeStats.top := fanfactorLabel.top + fanfactorLabel.height + 4;
  cmdChangeStats.left := fanfactorLabel.left;
  cmdChangeStats.caption := 'Change Stats';
  cmdUseNew.top := cmdChangeStats.top;
  cmdUseNew.left := cmdChangeStats.left + cmdChangeStats.Width;
  cmdUseNew.visible := false;
  butUpdateTeamRoster.top := cmdChangeStats.top;
  butUpdateTeamRoster.left := cmdChangeStats.left -
                              butUpdateTeamRoster.Width - 6;
  cmdAddPlayer.top := cmdChangeStats.top - 30;
  cmdAddPlayer.left := butUpdateTeamRoster.left;
end;

procedure ClearRoster;
var f, h: integer;
begin
  for f := 1 to MaxNumPlayersInTeam do begin
    for h := 0 to 17 do begin
      lb[f,h].caption := '';
      if (h > 0) and (h <> 16) then lb[f,h].color := clWhite;
    end;
    lb[f,7].ShowHint := false;
  end;
  frmRoster.teamnameLabel.caption := '';
  frmRoster.race.caption := '';
  frmRoster.coach.caption := '';
  frmRoster.tr.caption := '';
  frmRoster.treasury.caption := '';
  frmRoster.rerolls.caption := '';
  frmRoster.fanfactor.caption := '';
  frmRoster.asstcoaches.caption := '';
  frmRoster.cheerleaders.caption := '';
  frmRoster.apot.caption := '';
  frmRoster.wiz.caption := '';
end;

procedure ShowSPP(g: integer);
var f, h, hb, hg, ha: integer;
begin
  for f := 1 to team[g].numplayers do begin
    for h := 9 to 16 do begin
      lb[f,h].caption := '';
    end;
  end;
  for f := 1 to team[g].numplayers do
   if player[g,f].status <> 11 then begin
    hb := player[g,f].GetStartingSPP();
    hg := player[g,f].GetMatchSPP();
    ha := hb + hg;
    if frmRoster.GameRB.checked then begin
      if (player[g,f].otherSPP > 0)
         then lb[f,9].caption := IntToStr(player[g,f].otherSPP);
      if player[g,f].comp > 0
         then lb[f,10].caption := IntToStr(player[g,f].comp);
      if player[g,f].td > 0
         then lb[f,11].caption := IntToStr(player[g,f].td);
      if player[g,f].cas > 0
         then lb[f,12].caption := IntToStr(player[g,f].cas);
      if player[g,f].int > 0
         then lb[f,13].caption := IntToStr(player[g,f].int);
      if player[g,f].mvp > 0
         then lb[f,14].caption := IntToStr(player[g,f].mvp);
      if player[g,f].exp > 0
         then lb[f,15].caption := IntToStr(player[g,f].exp);
      if player[g,f].peaked then
        lb[f,16].caption := 'P'
      else
       if hg > 0 then lb[f,16].caption := IntToStr(hg);
    end;
    if frmRoster.BeforeRB.checked then begin
      if (player[g,f].otherSPP0 > 0)
         then lb[f,9].caption := IntToStr(player[g,f].otherSPP0);
      if player[g,f].comp0 > 0
         then lb[f,10].caption := IntToStr(player[g,f].comp0);
      if player[g,f].td0 > 0
         then lb[f,11].caption := IntToStr(player[g,f].td0);
      if player[g,f].cas0 > 0
         then lb[f,12].caption := IntToStr(player[g,f].cas0);
      if player[g,f].int0 > 0
         then lb[f,13].caption := IntToStr(player[g,f].int0);
      if player[g,f].mvp0 > 0
         then lb[f,14].caption := IntToStr(player[g,f].mvp0);
      if player[g,f].exp0 > 0
         then lb[f,15].caption := IntToStr(player[g,f].exp0);
      if player[g,f].peaked then
        lb[f,16].caption := 'P'
      else
       if hb > 0 then lb[f,16].caption := IntToStr(hb);
    end;
    if frmRoster.TotalRB.checked then begin
      if player[g,f].otherSPP + player[g,f].otherSPP0 > 0 then
             lb[f,9].caption := IntToStr(player[g,f].otherSPP +
                                                 player[g,f].otherSPP0);
      if player[g,f].comp + player[g,f].comp0 > 0 then lb[f,10].caption :=
                              IntToStr(player[g,f].comp + player[g,f].comp0);
      if player[g,f].td + player[g,f].td0 > 0
         then lb[f,11].caption := IntToStr(player[g,f].td + player[g,f].td0);
      if player[g,f].cas + player[g,f].cas0 > 0
         then lb[f,12].caption := IntToStr(player[g,f].cas + player[g,f].cas0);
      if player[g,f].int + player[g,f].int0 > 0
         then lb[f,13].caption := IntToStr(player[g,f].int + player[g,f].int0);
      if player[g,f].mvp + player[g,f].mvp0 > 0
         then lb[f,14].caption := IntToStr(player[g,f].mvp + player[g,f].mvp0);
      if player[g,f].exp + player[g,f].exp0 > 0
         then lb[f,15].caption := IntToStr(player[g,f].exp + player[g,f].exp0);
      if player[g,f].peaked then
        lb[f,16].caption := 'P'
      else
       if ha > 0 then lb[f,16].caption := IntToStr(ha);
    end;
    if not(player[g,f].peaked) then begin
      CountSkillRolls(g, f);
      if player[g,f].skillrolls > 0
         then lb[f,16].color := clAqua else lb[f,16].color := clYellow;
    end;
  end;
end;

procedure ShowCurrentTeamStats(g: integer);
begin
  //frmRoster.tr.caption := IntToStr(CalculateTeamRating(g));
  frmRoster.treasury.caption := team[g].treasury;
  if team[g].treasury <> team[g].treasury0 then
    frmRoster.treasury.font.color := clRed
  else
    frmRoster.treasury.font.color := clBlack;
  frmRoster.rerolls.caption := IntToStr(team[g].reroll);
  if team[g].reroll <> team[g].reroll0 then
    frmRoster.rerolls.font.color := clRed
  else
    frmRoster.rerolls.font.color := clBlack;
  frmRoster.fanfactor.caption := IntToStr(team[g].ff);
  if (team[g].ff <> team[g].ff0) then
    frmRoster.fanfactor.font.color := clRed
  else
    frmRoster.fanfactor.font.color := clBlack;
  if team[g].asstcoaches > 0
     then frmRoster.asstcoaches.caption := IntToStr(team[g].asstcoaches)
     else frmRoster.asstcoaches.caption := '';
  if team[g].cheerleaders > 0
     then frmRoster.cheerleaders.caption := IntToStr(team[g].cheerleaders)
     else frmRoster.cheerleaders.caption := '';
  if team[g].apot > 0
     then frmRoster.apot.caption := IntToStr(team[g].apot)
     else frmRoster.apot.caption := '';
  if team[g].wiz > 0
     then frmRoster.wiz.caption := IntToStr(team[g].wiz)
     else frmRoster.wiz.caption := '';
end;

procedure EnableDisableBuyButtons;
var tr: integer;
begin
  tr := MoneyVal(team[curroster].treasury);
  frmRoster.butBuyReroll.enabled := (tr >= 2 * team[curroster].rerollcost);
  frmRoster.butBuyAsstCoach.enabled := (tr > 0);
  frmRoster.butBuyCheerleader.enabled := (tr > 0);
  frmRoster.butBuyApo.enabled := ((tr >= 50) and (team[curroster].apot = 0));
  frmRoster.butBuyWizard.enabled := ((tr >= 150) and (team[curroster].wiz = 0));
end;

procedure ShowTeam(g: integer);
var f, h: integer;
    s: string;
begin
  curroster := g;
  frmRoster.Show;
  ClearRoster;
  for f := 1 to team[g].numplayers do begin
    lb[f,0].font.color := colorarray[g,0,0];
    if player[g,f].status <> 11 then begin
      lb[f,0].caption := IntToStr(player[g,f].cnumber);
      if player[g,f].cnumber <> player[g,f].cnumber0 then lb[f,0].font.color := clRed
         else lb[f,0].font.color := clBlack;
      lb[f,1].caption := player[g,f].name;
      if player[g,f].name <> player[g,f].name0 then lb[f,1].font.color := clRed
         else lb[f,1].font.color := clBlack;
      lb[f,2].caption := player[g,f].position;
      if player[g,f].position <> player[g,f].position0 then lb[f,2].font.color := clRed
         else lb[f,2].font.color := clBlack;
      lb[f,3].caption := IntToStr(player[g,f].ma);
      if player[g,f].ma <> player[g,f].ma0 then lb[f,3].font.color := clRed
         else lb[f,3].font.color := clBlack;
      lb[f,4].caption := IntToStr(player[g,f].st);
      if player[g,f].st <> player[g,f].st0 then lb[f,4].font.color := clRed
         else lb[f,4].font.color := clBlack;
      lb[f,5].caption := IntToStr(player[g,f].ag);
      if player[g,f].ag <> player[g,f].ag0 then lb[f,5].font.color := clRed
         else lb[f,5].font.color := clBlack;
      lb[f,6].caption := IntToStr(player[g,f].av);
      if player[g,f].av <> player[g,f].av0 then lb[f,6].font.color := clRed
         else lb[f,6].font.color := clBlack;
      s := player[g,f].GetSkillString(1);
      if s <> '' then begin
        lb[f,7].caption := s;
        lb[f,7].hint := s;
        lb[f,7].ShowHint := true;
      end;
      if player[g,f].hasNewSkills
           then lb[f,7].font.color := clRed
           else lb[f,7].font.color := clBlack;
      lb[f,8].caption := player[g,f].inj;
      lb[f,17].caption := status[player[g,f].status];
      if (player[g,f].status > 5) and (player[g,f].status <> 11) then
        for h := 1 to 17 do if h <> 16 then lb[f,h].color := $DDDDDD;
      if PostgameActive then begin
        butRetire[f].visible := true;
        if player[g,f].status = 8 then butRetire[f].caption := 'Clear'
                                  else butRetire[f].caption := 'Retire';
      end else butRetire[f].visible := false;
    end else begin
      butRetire[f].visible := false;
    end;
    for h := 0 to 17 do lb[f,h].visible := true;
  end;
  for f := team[g].numplayers + 1 to MaxNumPlayersInTeam do begin
    for h := 0 to 17 do lb[f,h].visible := false;
  end;
  ShowSPP(g);
  frmRoster.sbplayers.VertScrollBar.visible := (team[g].numplayers > 16);
  if team[g].numplayers > 16 then begin
    frmRoster.width := lb[0,17].left + lb[0,17].width + 32;
  end else begin
    frmRoster.width := lb[0,17].left + lb[0,17].width + 16;
  end;
  if PostgameActive then frmRoster.width := frmRoster.width + 38;
  frmRoster.sbplayers.Width := frmRoster.width - 10;
  frmRoster.teamnameLabel.font.color := colorarray[g,0,0];
  frmRoster.teamnameLabel.caption := team[g].name;
  frmRoster.race.caption := team[g].race;
  frmRoster.coach.caption := team[g].coach;
  frmRoster.email.caption := team[g].email;
  ShowCurrentTeamStats(g);
{  frmRoster.butBuyReroll.visible := (PostgameActive) or
    (frmSettings.txtHandicapIniFile.text = 'bbhandicap_MBBL2.ini');
  frmRoster.butBuyAsstCoach.visible := (PostGameActive) or
    (frmSettings.txtHandicapIniFile.text = 'bbhandicap_MBBL2.ini');
  frmRoster.butBuyCheerleader.visible := (PostGameActive) or
    (frmSettings.txtHandicapIniFile.text = 'bbhandicap_MBBL2.ini');
  frmRoster.butBuyApo.visible := (PostgameActive) or
    (frmSettings.txtHandicapIniFile.text = 'bbhandicap_MBBL2.ini');}
  frmRoster.butBuyReroll.visible := true;
  frmRoster.butBuyAsstCoach.visible := true;
  frmRoster.butBuyCheerleader.visible := true;
  frmRoster.butBuyApo.visible := true;
  frmRoster.butBuyWizard.visible := (PostGameActive) or
    ((Uppercase(team[g].race) = 'HALFLING') and (frmSettings.cbHChefNew.checked));
  EnableDisableBuyButtons;
  {frmRoster.cmdChangeStats.visible := not(PostgameActive);}
end;

procedure TfrmRoster.BeforeRBClick(Sender: TObject);
begin
  ShowSPP(curroster);
end;

procedure TfrmRoster.GameRBClick(Sender: TObject);
begin
  ShowSPP(curroster);
end;

procedure TfrmRoster.TotalRBClick(Sender: TObject);
begin
  ShowSPP(curroster);
end;

procedure TfrmRoster.cmdChangeStatsClick(Sender: TObject);
var s: string;
begin
  if txtRerollNew.visible then begin
    s := 'S' + Chr(curroster + 48) + Chr(team[curroster].reroll + 48) +
         Chr(team[curroster].ff + 48) + team[curroster].treasury + '|';
    s := s + Chr(team[curroster].reroll0 + 48) +
         Chr(team[curroster].ff0 + 48) + team[curroster].treasury0;
    if CanWriteToLog then begin
      LogWrite(s);
      PlayActionTeamStatChange(s, 1);
      ShowCurrentTeamStats(curroster);
      txtRerollNew.visible := false;
      txtFanFactorNew.visible := false;
      txtTreasuryNew.visible := false;
      cmdUseNew.visible := false;
      cmdChangeStats.caption := 'Change Stats';
    end;
  end else begin
    rerolls.Caption := '(' + IntToStr(team[curroster].reroll0) + ')';
    txtRerollNew.text := IntToStr(team[curroster].reroll);
    fanfactor.caption := '(' + IntToStr(team[curroster].ff0) + ')';
    txtFanFactorNew.text := IntToStr(team[curroster].ff);
    treasury.caption := '(' + team[curroster].treasury0 + ')';
    txtTreasuryNew.text := team[curroster].treasury;
    txtRerollNew.visible := true;
    txtFanFactorNew.visible := true;
    txtTreasuryNew.visible := true;
    cmdUseNew.visible := true;
    cmdChangeStats.Caption := 'Use Default';
  end;
end;

procedure TfrmRoster.cmdUseNewClick(Sender: TObject);
var s: string;
begin
  s := 'S' + Chr(curroster + 48) + Chr(team[curroster].reroll + 48) +
         Chr(team[curroster].ff + 48) + team[curroster].treasury + '|';
  s := s + Chr(FVal(txtRerollNew.text) + 48) +
         Chr(FVal(txtFanFactorNew.text) + 48) + txtTreasuryNew.text;
  if CanWriteToLog then begin
    LogWrite(s);
    PlayActionTeamStatChange(s, 1);
    ShowCurrentTeamStats(curroster);
    txtRerollNew.visible := false;
    txtFanFactorNew.visible := false;
    txtTreasuryNew.visible := false;
    cmdUseNew.visible := false;
    cmdChangeStats.caption := 'Change Stats';
  end;
end;

procedure TfrmRoster.cmdAddPlayerClick(Sender: TObject);
begin
  ShowAddPlayerWindow(curroster);
end;

function TranslateBuy(s: string): string;
var t: string;
begin
  if s[2] = 'X' then begin
    t := team[Ord(s[3])- 48].name + ' loses their freeboot wizard'
  end else if s[2] = 'Z' then  begin
    t := team[Ord(s[3])- 48].name + ' loses their freeboot apothecary'
  end else begin
    t := team[Ord(s[3])- 48].name + ' buys ';
    case s[2] of
      'R': t := t + 'a Reroll';
      'a': t := t + 'an Assistant Coach';
      'C': t := t + 'a Cheerleader';
      'A': t := t + 'an Apothecary';
      'W': t := t + 'a Wizard';
    end;
  end;
  TranslateBuy := t;
end;

procedure PlayActionBuy(s: string; dir: integer);
var g: integer;
begin
  g := Ord(s[3]) - 48;
  curmove := g;
  if dir = DIR_FORWARD then begin
    case s[2] of
      'R': begin
             team[g].reroll := team[g].reroll + 1;
             team[g].treasury := IntToStr(MoneyVal(team[g].treasury) -
                            2 * team[g].rerollcost) + 'k';
           end;
      'a': begin
             team[g].asstcoaches := team[g].asstcoaches + 1;
             team[g].treasury := IntToStr(MoneyVal(team[g].treasury) - 10) + 'k';
           end;
      'C': begin
             team[g].cheerleaders := team[g].cheerleaders + 1;
             team[g].treasury := IntToStr(MoneyVal(team[g].treasury) - 10) + 'k';
           end;
      'A': begin
begin
               if team[g].apot = 0 then begin
                 apo[g].color := colorarray[g, 0, 0];
                 apo[g].font.color := colorarray[g, 0, 1];
                 apo[g].visible := true;
               end;
               team[g].apot := team[g].apot + 1;
               begin
                 team[g].treasury := IntToStr(MoneyVal(team[g].treasury) - 50) + 'k';
               end;;
             end;
           end;
      'W': begin
             if team[g].wiz = 0 then begin
               wiz[g].color := colorarray[g, 0, 0];
               wiz[g].font.color := colorarray[g, 0, 1];
               wiz[g].visible := true;
               if Pos('HALFLING', Uppercase(team[g].race)) > 0 then begin
                 wiz[g].color := colorarray[g, 4, 0];
                 wiz[g].font.color := colorarray[g, 4, 1];
                 wiz[g].caption := 'Chef';
               end;
             end;
             team[g].wiz := team[g].wiz + 1;
             if (frmSettings.cbHChefNew.checked) and
               (Uppercase(team[g].race) = 'HALFLING') then
                team[g].treasury := IntToStr(MoneyVal(team[g].treasury) -
                            20) + 'k'
             else
               team[g].treasury := IntToStr(MoneyVal(team[g].treasury) -
                            150) + 'k';
           end;
        'X': begin
             if team[g].wiz >= 1 then wiz[g].visible := false;
             team[g].wiz := 0;
           end;
        'Z': begin

               apo[g].visible := false;
               team[g].apot := 0;

           end;
    end;
    DefaultAction(TranslateBuy(s));
    ShowCurrentTeamStats(g);
    EnableDisableBuyButtons;
  end else begin
    case s[2] of
      'R': begin
             team[g].reroll := team[g].reroll - 1;
             team[g].treasury := IntToStr(MoneyVal(team[g].treasury) +
                            2 * team[g].rerollcost) + 'k';
           end;
      'a': begin
             team[g].asstcoaches := team[g].asstcoaches - 1;
             team[g].treasury := IntToStr(MoneyVal(team[g].treasury) + 10) + 'k';
           end;
      'C': begin
             team[g].cheerleaders := team[g].cheerleaders - 1;
             team[g].treasury := IntToStr(MoneyVal(team[g].treasury) + 10) + 'k';
           end;
      'A': begin

           end;
      'W': begin
             if team[g].wiz = 1 then wiz[g].visible := false;
             team[g].wiz := team[g].wiz - 1;
             if (not(Uppercase(team[g].race) = 'HALFLING')) then
               team[g].treasury := IntToStr(MoneyVal(team[g].treasury) +
                            50) + 'k' else
             if (frmSettings.cbHChefNew.checked) and
               (Uppercase(team[g].race) = 'HALFLING') then
                team[g].treasury := IntToStr(MoneyVal(team[g].treasury) +
                            20) + 'k'
             else
               team[g].treasury := IntToStr(MoneyVal(team[g].treasury) +
                            150) + 'k';
           end;
      'X': begin
             if team[g].wiz = 0 then begin
               wiz[g].color := colorarray[g, 0, 0];
               wiz[g].font.color := colorarray[g, 0, 1];
               wiz[g].visible := true;
               if Pos('HALFLING', Uppercase(team[g].race)) > 0 then begin
                 wiz[g].color := colorarray[g, 4, 0];
                 wiz[g].font.color := colorarray[g, 4, 1];
                 wiz[g].caption := 'Chef';
               end;
             end;
             team[g].wiz := team[g].wiz + 1;
           end;
      'Z': begin

             begin
               apo[g].color := colorarray[g, 0, 0];
               apo[g].font.color := colorarray[g, 0, 1];
               apo[g].visible := true;
               team[g].apot := team[g].apot + 1;
             end;
           end;
    end;
    BackLog;
    ShowCurrentTeamStats(g);
    EnableDisableBuyButtons;
  end;
end;

procedure Buy(t: string);
var s: string;
begin
  if CanWriteToLog then begin
    s := 'N' + t + IntToStr(curroster);
    LogWrite(s);
    PlayActionBuy(s, 1);
  end;
end;

procedure MakePurchases(g: integer);
begin
  ShowTeam(g);
  EnableDisableBuyButtons;
end;

procedure TfrmRoster.butBuyRerollClick(Sender: TObject);
begin
  Buy('R');
end;

procedure TfrmRoster.butBuyAsstCoachClick(Sender: TObject);
begin
  Buy('a');
end;

procedure TfrmRoster.butBuyCheerleaderClick(Sender: TObject);
begin
  Buy('C');
end;

procedure TfrmRoster.butBuyApoClick(Sender: TObject);
begin
  Buy('A');
end;

procedure TfrmRoster.butBuyWizardClick(Sender: TObject);
var p: integer;
    s: string;
begin
  Buy('W');
  if (Uppercase(team[curroster].race) = 'HALFLING') and (not(frmSettings.cbHChefNew.checked))
    then begin
      LogWrite('tC' + Chr(curroster + 48));
      PlayActionStartHalf('tC' + Chr(curroster + 48), 1);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      p := lastroll div 2;
      {if p > marker[1-curroster, MT_Reroll].value then
        p := marker[1-curroster, MT_Reroll].value; }
      s := 'tR' + Chr(curroster + 48) + Chr(p + 48);
      LogWrite(s);
      PlayActionStartHalf(s, 1);
  end;
  if (Uppercase(team[curroster].race) = 'HALFLING') and (frmSettings.cbHChefNew.checked)
    then begin
      LogWrite('tC' + Chr(curroster + 48));
      PlayActionStartHalf('tC' + Chr(curroster + 48), 1);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      {if (lastroll > 1) and (marker[1-curroster, MT_Reroll].value>0) then begin}
      if (lastroll > 1) then begin
        s := 'tR' + Chr(curroster + 48) + Chr(1 + 48);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
      end else begin
        Bloodbowl.comment.Text := 'Halfling Chef roll fails';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
  end;
  if (Uppercase(team[curroster].race) = 'DWARF') and (frmSettings.cbHChefNew.checked)
    then begin
      Bloodbowl.comment.Text := 'Roll for Dwarven Runesmith';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if lastroll = 1 then begin
        Bloodbowl.comment.Text := 'Runesmith Spell Fizzles!  No effect!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 2 then begin
        Bloodbowl.comment.Text := 'Runesmith casts Rune of Speed.  Player of '+
          'choice gains Sprint and +1 MA for this game!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 3 then begin
        Bloodbowl.comment.Text := 'Runesmith casts Rune of Might.  Player of '+
          'choice gains +1 ST for this game!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 4 then begin
        Bloodbowl.comment.Text := 'Runesmith casts Rune of Dexerity.  Player of '+
          'choice gains +1 AG for this game!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 5 then begin
        Bloodbowl.comment.Text := 'Runesmith casts Rune of Stone.  Player of '+
          'choice gains +1 AV and Stand Firm for this game!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 6 then begin
        Bloodbowl.comment.Text := 'Runesmith casts Rune of Courage.  Player of '+
          'choice gains Dauntless and Frenzy for this game!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      s := 'W' + Chr(curroster + 48);
      LogWrite(s);
      PlayActionUseWiz(s, 1);
  end;
end;

procedure TfrmRoster.butUpdateTeamRosterClick(Sender: TObject);
begin
  OpenDialog1.InitialDir := LoadSaveDir;
  OpenDialog1.Filename := '';
  OpenDialog1.Options := [ofFileMustExist];
  OpenDialog1.Execute;
  if OpenDialog1.Filename <> '' then begin
    SaveTeamFile(curroster, OpenDialog1.FileName);
  end;
end;

end.
