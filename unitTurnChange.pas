unit unitTurnChange;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TmodTurnChange = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TTurn = class(TLabel)
public
  team, turnnumber: integer;
  constructor New(form: TForm; tm, nr: integer);
  procedure TurnClick(Sender: TObject);
end;

var
  modTurnChange: TmodTurnChange;
  SWSafeRef: integer;

function TurnChange: string;
function StartTurnNegativeSkills: string;
procedure PrepareStartHalf;
procedure PlayActionTurn(s: string; dir: integer);
procedure PlayActionStartHalf(s: string; dir: integer);
procedure MakeRegenerationRolls;
procedure ResetWerePlayers;
procedure NurgleRotRolls;
procedure PrepareForKickoff;
procedure PlayActionPrepareForKickoff(s: string; dir: integer);
procedure PlayActionRiot(s: string; dir: integer);
function ExecuteRiot(turns: integer): boolean;

implementation

uses bbunit, bbalg, unitLog, unitPlayAction, unitExtern, unitPlayer,
     unitField, unitMarker, unitBall, unitPostGameSeq, unitSettings,
     unitRandom, unitPregame, unitRoster;

{$R *.DFM}

constructor TTurn.New(form: TForm; tm, nr: integer);
begin
  inherited Create(form);

  {set label properties}
  autosize := false;
  if tm = 0 then left := Bloodbowl.TurnLabel.left - (9 - nr) * 20 - 2
            else left := Bloodbowl.TurnLabel.left + (nr - 1) * 20 +
                                 Bloodbowl.TurnLabel.width + 2;
  top := Bloodbowl.TurnLabel.top;
  height := 19;
  width := 19;
  caption := IntToStr(nr);
  alignment := taCenter;
  color := colorarray[tm, 0, 0];
  font.color := clWhite;
  font.size := 12;
  hint := 'Click to start new turn';
  ShowHint := true;
  parent := Bloodbowl;
  OnClick := TurnClick;

  {other properties}
  team := tm;
  turnnumber := nr;
end;

function TurnChange: string;
var f, g, h: integer;
    s: string;
begin
  s := '--';
  {look for current active Turn marker and make it small}
  for g := 0 to 1 do
   for f := 1 to 8 do begin
    if turn[g,f].color = clYellow then begin
      s := Chr(48 + g) + IntToStr(f);
      turn[g,f].font.size := 8;
    end;
    turn[g,f].color := colorarray[g,0,0];
    if ref then turn[g,f].Refresh;
  end;
  {remove numbers}
  s := s + ClearAllNumOnField + '^';
  {reset players}
  for g := 0 to 1 do
   for f := 1 to team[g].numplayers do
    if player[g,f].font.size = 8 then begin
     player[g,f].font.size := 12;
     if ref then player[g,f].Refresh;
     s := s + Chr(g + 48) + Chr(f + 65);
   end;
  s := s + '^';
  {reset used skills}
  for g := 0 to 1 do
   for f := 1 to team[g].numplayers do begin
      player[g,f].UsedMA := 0;
      player[g,f].FirstBlock := 0;
      player[g,f].SecondBlock := 0;
      player[g,f].LastAction := 0;
      player[g,f].GFI := 0;
      for h := 1 to 15 do begin
        if player[g,f].uskill[h]
        then s := s + Chr(g + 48) + Chr(f + 65) + Chr(h + 65);
        player[g,f].uskill[h] := false;
      end;
    end;
  s := s + '^';
  {reset reroll markers}
  for g := 0 to 1 do
    if marker[g, MT_Reroll].font.size = 10 then begin
      marker[g, MT_Reroll].font.size := 12;
      marker[g, MT_Leader].font.size := 10;
      s := s + Chr(48+g);
    end;
  TurnChange := s;
  {reset FollowUp indicator}
  FollowUp := '';
  if not(team[curmove].HeadCoach) then Bloodbowl.ArgueCallSB.Visible := false
    else Bloodbowl.ArgueCallSB.Visible := true;
end;

function StartTurnNegativeSkills: string;
var f, g, f2, g2: integer;
    s, s3: string;
    CTest: boolean;
begin
  {reset TIKSTPK tackle zones and roll for beginning of turn negative skills}
  for g := 0 to 1 do
  for f := 1 to team[g].numplayers do begin
    if (g = curmove) and (InEditMode) then begin
      if (player[g,f].HasSkill('TIKSTPK')) and (player[g, f].tz > 0) then begin
        TIKSTPK := true;
        if CanWriteToLog then begin
          s3 := 'U+' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s3);
          PlayActionToggleTackleZone(s3, 1);
        end;
        TIKSTPK := false;
      end;
      if (player[g,f].hasSkill('Side Step')) and
        (player[g,f].SideStep[1] = 1) then begin
        s3 := 'QF' + Chr(g + 48) + Chr(f + 64) + Chr(48) + Chr(64) + Chr(64)
          + Chr(player[g,f].SideStep[1]+48) + Chr(player[g,f].SideStep[2]+64)
          + Chr(player[g,f].SideStep[3]+64);
        LogWrite(s3);
        PlayActionSideStep(s3, 1);
      end;
      if (player[g,f].HasSkill('Spontaneous Combustion')) and
        (player[g,f].status >= 0) and (player[g,f].status <= 4) then begin
        if CanWriteToLog then begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll > 1 then begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
             ' Spontaneous Combustion roll successful';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' Spontaneous Combustion roll FAILED!   BA-BOOM!!!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
        end;
      end;
      if (player[g,f].HasSkill('Temporal Instability')) and
        (player[g,f].status >= 1) and (player[g,f].status <= 4) then begin
        if CanWriteToLog then begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll > 1 then begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' Temporal Instability roll successful';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' Temporal Instability roll failed!  Randomly scatter player one '+
              'square!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
        end;
      end;
      CTest := false;
      if (player[g,f].HasSkill('Cruelty')) and
        (player[g,f].status >= 1) and (player[g,f].status <= 2) then begin
          for g2 := 0 to 1 do
          for f2 := 1 to team[g2].numplayers do begin
            if (abs((player[g,f].p)-(player[g2,f2].p))<=1) and
               (abs((player[g,f].q)-(player[g2,f2].q))<=1) and
               ((player[g2,f2].status = 3) or (player[g2,f2].status = 4)) then begin
               if (CanWriteToLog) and (not(CTest)) then begin
                 CTest := true;
                 Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                 if lastroll > 1 then begin
                   Bloodbowl.comment.Text := player[g,f].GetPlayerName +
                     ' Cruelty roll successful';
                   Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                 end else begin
                   Bloodbowl.comment.Text := player[g,f].GetPlayerName +
                     ' Cruelty roll failed! You must foul an adjacent prone/stunned '+
                     'player! If you currently have the IGMEOY marker return it to ' +
                     'Neutral before making the foul.';
                   Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                 end;
               end;
            end;
          end;
      end;
      if (player[g,f].HasSkill('Not Worthy')) and
        (player[g,f].status = 2) then begin
        if CanWriteToLog then begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll > 1 then begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' We Are Not Worthy roll successful';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' We Are Not Worthy roll failed!  Player MUST move first and '+
              'get rid of the ball without scoring!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end;
        end;
      end;
      if (player[g,f].status = 4) and (frmSettings.cbDeStun.checked) and
        (CanWriteToLog) then begin
        s3 := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
        LogWrite(s3);
        PlayActionEndOfMove(s3, 1);
      end;
    end;
    if (g <> curmove) and (InEditMode) then begin
      if (player[g,f].StunStatus > 0) and (frmSettings.cbDeStun.Checked)
        then begin
        if CanWriteToLog then begin
          s3 := 'QS' + Chr(g + 48) + Chr(f + 64) + Chr(47);
          LogWrite(s3);
          PlayActionDeStun(s3, 1);
          if player[g,f].StunStatus = 0 then player[g,f].SetStatus(3);
        end;
      end;
      if (player[g,f].HasSkill('Ball and Chain')) and
        (player[g,f].status = 1) and (turn[g,1].font.size = 8) then begin
        if CanWriteToLog then begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll > 1 then begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' Ball and Chain Exhaustion roll successful';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          end else begin
            Bloodbowl.comment.Text := player[g,f].GetPlayerName +
              ' Ball and Chain Exhaustion roll fails!  Rolling for result ...';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then begin
              Bloodbowl.comment.Text := player[g,f].GetPlayerName +
                ' suffers Cardiac Arrest!!! ... Ball and Chain player dies!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              player[g,f].SetStatus(8);
            end else begin
              Bloodbowl.comment.Text := player[g,f].GetPlayerName +
                ' is just knackered ... he will be back for the next game!';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              player[g,f].SetStatus(6);
            end;
          end;
        end;
      end;
    end;
  end;
  s :='';
  StartTurnNegativeSkills := s;
end;

procedure TTurn.TurnClick(Sender: TObject);
type rij = array [0..3] of byte;
var s: string;
    p: ^rij;
begin
  if CanWriteToLog then begin
    curmove := team;
    s := TurnChange;
    color := clYellow;
    {add Randseed to Turn-log; not used anymore
    Randomize; }
    p := Addr(RandSeed);
    LogWrite('T' + Copy(s,1,2) + Chr(team + 48) + IntToStr(turnnumber) +
             Copy(s, 3, length(s)-2) +
             '~' +
             Chr(65 + p^[0] mod 16) + Chr(65 + p^[0] div 16) +
             Chr(65 + p^[1] mod 16) + Chr(65 + p^[1] div 16) +
             Chr(65 + p^[2] mod 16) + Chr(65 + p^[2] div 16) +
             Chr(65 + p^[3] mod 16) + Chr(65 + p^[3] div 16));
    AddLog(UPPERCASE('Turn: ' + ffcl[team] + ' ' + IntToStr(turnnumber)));
    s := StartTurnNegativeSkills;
    if RLCoach[0] = RLCoach[1] then SetSpeakLabel(team);
    if AutoSave then begin
      Bloodbowl.comment.text := 'A U T O S A V E . . .   One moment please...';
      Bloodbowl.comment.color := clYellow;
      Bloodbowl.comment.Refresh;
      SaveGame(curdir + 'autosave.bbm');
      Bloodbowl.comment.text := '';
      Bloodbowl.comment.color := clWhite;
    end;
  end;
end;

procedure PlayActionTurn(s: string; dir: integer);
{PlayActionTurn executes a Turnmarker click}
var f, g, h, v: integer;
    s0: string;
begin
  g := Ord(s[4]) - 48;
  f := FVal(s[5]);
  if dir = 1 then begin
    curmove := g;
    s0 := TurnChange;
    AddLog(UPPERCASE('Turn: ' + ffcl[g] + ' ' + turn[g,f].caption));
    if WaitLength > 0 then begin
      turn[g,f].color := clPurple;
      turn[g,f].Refresh;
      Wait;
    end;
    turn[g,f].color := clYellow;
    if WaitLength > 0 then turn[g,f].Refresh;
    SWSafeRef := 3;
    if not(team[curmove].HeadCoach) then Bloodbowl.ArgueCallSB.Visible := false
      else Bloodbowl.ArgueCallSB.Visible := true;
    {to restore the RandSeed at a turnclick:}
{            p := Pos('~', s);
            if p > 0 then begin
              for q := 0 to 3 do begin
                q0 := Ord(s[p+q*2+1]) - 65 + 16 * (Ord(s[p+q*2+2]) - 65);
                lr[q] := q0;
              end;
              l := Addr(lr);
              RandSeed := l^;
            end;}
  end else begin
    BackLog;
    {restore turn marker}
    turn[g,f].color := colorarray[g, 0, 0];
    turn[g,f].font.size := 12;
    {restore numbers on the field}
    h := Pos('^', s);
    PutMultipleNumOnField(Copy(s, 6, h - 6));
    {restore players to small font if they moved previous turn}
    h := h + 1;
    while (h < length(s)) and (s[h] <> '~') and (s[h] <> '^') do begin
      g := Ord(s[h]) - 48;
      f := Ord(s[h+1]) - 65;
      player[g,f].font.size := 8;
      h := h + 2;
    end;
    {restore players using skills}
    h := h + 1;
    while (h < length(s)) and (s[h] <> '~') and (s[h] <> '^') do begin
      g := Ord(s[h]) - 48;
      f := Ord(s[h+1]) - 65;
      v := Ord(s[h+2]) - 65;
      player[g,f].uskill[v] := true;
      h := h + 3;
    end;
    if s[h] = '^' then begin
      h := h + 1;
      {restore reroll- and leadercounter to small if they were used}
      while s[h] <> '~' do begin
        g := Ord(s[h]) - 48;
        marker[g, MT_Reroll].font.size := 10;
        marker[g, MT_Leader].font.size := 8;
        h := h + 1;
      end;
    end;
    {restore previous active turn marker}
    if s[2] <> '-' then begin
      g := Ord(s[2]) - 48;
      f := FVal(s[3]);
      turn[g,f].color := clYellow;
      curmove := g;
    end;
    if not(team[curmove].HeadCoach) then Bloodbowl.ArgueCallSB.Visible := false
      else Bloodbowl.ArgueCallSB.Visible := true;
  end;
end;

procedure PrepareStartHalf;
var s, t: string;
    f, g, p, i, j, r, r2, acroll, chroll, r1, done: integer;
    HadNiggle: boolean;
begin
  if Bloodbowl.PregamePanel.visible then s := 'tP' else s := 't ';
  LogWrite(s);
  PlayActionStartHalf(s, 1);

  Continuing := true;

  s := '';
  for g := 0 to 1 do
   for f := 1 to 8 do begin
    if turn[g,f].font.size = 8 then s := s + Chr(64 + g * 8 + f);
    if turn[g,f].color = clYellow then s := s + Chr(48 + g * 8 + f);
   end;
  LogWrite('tT' + s);
  PlayActionStartHalf('tT' + s, 1);

  for g := 0 to 1 do begin
    if HalfNo <= 2 then begin
      s := 'm' + Chr(MT_Reroll + 48) + Chr(g + 48) +
         Chr(marker[g, MT_Reroll].value + 48) +
         Chr(team[g].reroll + 48) + '--';
      LogWrite(s);
      PlayActionMarkerChange(s, 1);
    end;
  end;

  if (frmSettings.cbNiggleHalf.checked) and (HalfNo <> 1) then begin
    for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      {look for niggled players}
      if (player[g,f].status <= 5) then begin
        HadNiggle := false;
        s := player[g,f].inj;
        p := Pos('N', Uppercase(s));
        if p<>0 then HadNiggle := true;
        {roll for each N until all done, or 1 rolled}
        repeat begin
          r := Rnd(6,1) + 1;
          r2 := Rnd(6,1) + 1;
          if ((Uppercase(team[g].race) = 'BRIGHT CRUSADERS')) and (r = 1) and
            (r2 = 6) and (frmSettings.cbBrightCrusaders.checked) then r := r2;
          t := 'DN' + Chr(g + 48) + Chr(f + 64) + Chr(r + 48);
          if (CanWriteToLog) and (p<>0) then begin
            AddLog(TranslateNiggle(t));
            LogWrite(t);
          end;
          s := Copy(s, p+1, Length(s) - p);
          p := Pos('N', Uppercase(s));
          Continuing := true;
        end until (r = 1) or (p = 0);
        t := 'Dn' + Chr(g + 48) + Chr(f + 64);
        if (HadNiggle) then begin
          if r <> 1 then begin
            t := t + '9';
          end else begin
            t := t + '1';
          end;
          if CanWriteToLog then begin
            AddLog(TranslateNiggleResult(t));
            LogWrite(t);
          end;
          if r = 1 then player[g,f].SetStatus(9);
        end;
      end;
    end;
    end;
  end;

  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g,f].Ally) and (player[g,f].status < 6)
          and not (frmSettings.rgBGA4th.ItemIndex >= 1) then begin
        s := 'tA' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll = 1 then begin
          if marker[g, MT_Reroll].value > 0 then
           marker[g, MT_Reroll].MarkerMouseUp(marker[g, MT_Reroll],
                                              mbRight, [], 0, 0)
          else
           marker[1-g, MT_Reroll].MarkerMouseUp(marker[g, MT_Reroll],
                                                mbLeft, [], 0, 0);
        end;
      end;
    end;
  end;

  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      {A status 13 failed Take Root player returns to the
        game automatically}
      if (player[g,f].status = 13)
           and (player[g,f].HasSkill('Take Root')) and
           (not(frmSettings.cbOPTakeRoot.checked)) then begin
        s := 'tO' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
        curteam := g;
        curplayer := f;
        Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
      end;
      {Roll for Take Root if this the beginning of the 1st half}
      if (player[g,f].HasSkill('Take Root')) and (HalfNo = 1)
        and (not(frmSettings.cbOPTakeRoot.checked))
        then begin
        s := 'tK' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 3 then begin
           player[g,f].SetStatus(13);
        end;
      end;
      {Clear Out Side Step future programmed squares}
      if (player[g,f].hasSkill('Side Step')) and (HalfNo = 1) then begin
        s := 'QF' + Chr(g + 48) + Chr(f + 64) + Chr(48) + Chr(64) + Chr(64)
          + Chr(48) + Chr(64) + Chr(64);
        LogWrite(s);
        PlayActionSideStep(s, 1);
      end;
      if (player[g,f].hasSkill('Side Step')) and (HalfNo <> 1) and
        (player[g,f].SideStep[1] = 1) then begin
        s := 'QF' + Chr(g + 48) + Chr(f + 64) + Chr(48) + Chr(64) + Chr(64)
          + Chr(player[g,f].SideStep[1]+48) + Chr(player[g,f].SideStep[2]+64)
          + Chr(player[g,f].SideStep[3]+64);
        LogWrite(s);
        PlayActionSideStep(s, 1);
      end;

      if (player[g,f].HasSkill('Amateur')) and (HalfNo = 1) then begin
        s := 'ta' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 1 then begin
           player[g,f].SetStatus(10);
        end;
      end;
    end;
  end;

  for g := 0 to 1 do begin
    if (Uppercase(team[g].race) = 'GOBLIN') and (HalfNo = 1) and
      (frmSettings.cbGoblinWeapons.checked) then begin
      s := 'tW' + Chr(g + 48);
      LogWrite(s);
      PlayActionStartHalf(s, 1);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if lastroll = 1 then begin
        Bloodbowl.comment.text := team[g].name + ' gains no free secret weapons ' +
          'freebooters this game!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 2 then begin
        Bloodbowl.comment.text := team[g].name + ' gains a free Ball and Chain ' +
          'freebooter! (may take roster to 17 players)';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 3 then begin
        Bloodbowl.comment.text := team[g].name + ' gains a free Pogo Stick ' +
          'freebooter! (may take roster to 17 players)';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 4 then begin
        Bloodbowl.comment.text := team[g].name + ' gains a free Bomb ' +
          'freebooter! (may take roster to 17 players)';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else if lastroll = 5 then begin
        Bloodbowl.comment.text := team[g].name + ' gains a free Chainsaw ' +
          'freebooter! (may take roster to 17 players)';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else begin
        Bloodbowl.comment.text := team[g].name + ' gains a free ' +
          'secret weapon freebooter of coachs choice! (may take to roster to 17 players)';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
    end;
    if frmSettings.cbCheerAC.checked and (HalfNo = 1) then begin
      acroll := 0;
      chroll := 0;
      i := team[g].cheerleaders div 2;
      if i<>0 then begin
        for j := 1 to i do begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if (lastroll = 6) and (acroll=1) then acroll := 2;
          if (lastroll = 6) and (acroll=0) then acroll := 1;
        end;
        if acroll = 2 then s := 'tE' + Chr(g + 48) else
          if acroll = 1 then s := 'tG' + Chr(g + 48) else
          s := 'tg' + Chr(g + 48);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
      end;
      i := team[g].asstcoaches div 2;
      if i<>0 then begin
        for j := 1 to i do begin
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if (lastroll = 6) and (chroll=1) then chroll := 2;
          if (lastroll = 6) and (chroll=0) then chroll := 1;
        end;
        if chroll = 2 then s := 'tD' + Chr(g + 48) else
          if chroll = 1 then s := 'tM' + Chr(g + 48) else
          s := 'tm' + Chr(g + 48);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
      end;
    end;
  end;

  if IGMEOY <> -1 then begin
    s := 'E' + Chr(IGMEOY + 66) + 'A';
    LogWrite(s);
    PlayActionSetIGMEOY(s, 1);
  end;

  for g := 0 to 1 do begin
   if (wiz[g].visible) and (wiz[g].caption = 'Chef') and
     (not(frmSettings.cbHChefNew.checked)) then begin
     LogWrite('tC' + Chr(g + 48));
     PlayActionStartHalf('tC' + Chr(g + 48), 1);
     Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
     p := lastroll div 2;
     {if p > marker[1-g, MT_Reroll].value then p := marker[1-g, MT_Reroll].value;}
     s := 'tR' + Chr(g + 48) + Chr(p + 48);
     LogWrite(s);
     PlayActionStartHalf(s, 1);
   end;
   if (Uppercase(team[g].race) = 'HALFLING') and (frmSettings.cbHChefNew.checked)
     and (HalfNo = 1) then begin
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      {if (lastroll > 1) and (marker[1-g, MT_Reroll].value>0) then begin}
      if (lastroll > 1) then begin
        s := 'tR' + Chr(g + 48) + Chr(1 + 48);
        LogWrite(s);
        PlayActionStartHalf(s, 1);
      end else begin
        Bloodbowl.comment.Text := 'Halfling Chef roll fails';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
   end;
   if (Uppercase(team[g].race) = 'HALFLING') and (frmSettings.cbHChefNew.checked)
     and (HalfNo <> 1) then begin
       j := 1 + FVal(frmRoster.wiz.Caption);
       for i := 1 to j do begin
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         {if (lastroll > 1) and (marker[1-g, MT_Reroll].value>0) then begin}
         if (lastroll > 1) then begin
           s := 'tR' + Chr(g + 48) + Chr(1 + 48);
           LogWrite(s);
           PlayActionStartHalf(s, 1);
         end else begin
           Bloodbowl.comment.Text := 'Halfling Chef roll fails';
           Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         end;
       end;
   end;
   if (Uppercase(team[g].race) = 'DWARF') and (frmSettings.cbHChefNew.checked)
    and (HalfNo=1) and (wiz[g].visible)
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
    end;
  end;

  for g := 0 to 1 do
   if marker[g, MT_Reroll].value < 0 then begin
     s := 'tr' + Chr(g + 48) + Chr(marker[g, MT_Reroll].value + 48);
     LogWrite(s);
     PlayActionStartHalf(s, 1);
   end;

   if Bloodbowl.lbHalfID.caption = 'O' then begin
    done := 0;
    while done = 0 do begin
      r := Rnd(6,5)+1;
      r2 := Rnd(6,5)+1;
      if r<>r2 then done := 1;
    end;
    if r>r2 then s := Chr(255) + ffcl[0]+' win the OVERTIME coin toss and receive! '
      else s := Chr(255) + ffcl[1]+' win the OVERTIME coin toss and receive! ';
    PlayActionComment(s, 1, 2);
    LogWrite(s);
  end;

  PrepareForKickoff;
  Continuing := false;
end;

function TranslateStartHalf(s: string): string;
var f, g: integer;
    t, hn: string;
begin
  case s[2] of
    ' ', 'P': begin
           if HalfNo <= 2 then begin
             hn := 'half ' + InttoStr(HalfNo);
           end else begin
             hn := 'Overtime';
           end;
           TranslateStartHalf := 'Start of ' + hn;
         end;
    'T': TranslateStartHalf := '- resetting Turn markers';
    'K': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslateStartHalf :=
               'Take Root roll for ' + player[g,f].GetPlayerName;
         end;
    'a': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslateStartHalf :=
               'Amateur roll for ' + player[g,f].GetPlayerName;
         end;
    'A': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslateStartHalf := 'Ally roll for ' + player[g,f].GetPlayerName;
         end;
    'O': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslateStartHalf := player[g,f].GetPlayerName +
                     ' returns from Take Root';
         end;
    'C': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := 'Master Chef roll for ' + team[g].name;
         end;
    'R': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 48;
           t := 'The cooking of the Master Chef gains ';
           case f of
             0: t := t + 'no extra rerolls';
             1: t := t + '1 extra reroll';
           else t := t + s[4] + ' extra rerolls';
           end;
           TranslateStartHalf := t + ' for ' + ffcl[g];
         end;
    'r': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := '- rerolls reset to 0 for ' + team[g].name;
         end;
    'D': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' gets a Dirty Trick card ' +
             'from the Assistant Coach roll';
         end;
    'M': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' gets a Pre-Match Prep card ' +
             'from the Assistant Coach roll';
         end;
    'm': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' FAILS the Assistant Coach roll';
         end;
    'G': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' gets a Grab Bag card ' +
             'from the Cheerleader roll';
         end;
    'E': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' gets a Random Event card ' +
             'from the Cheerleader roll';
         end;
    'g': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' FAILS the Cheerleader roll';
         end;
    'W': begin
           g := Ord(s[3]) - 48;
           TranslateStartHalf := team[g].name + ' rolls for its free Weapon';
         end;
  end;
end;

procedure PlayActionStartHalf(s: string; dir: integer);
{PlayActionStartHalf indicates the start of a half}
var f, g, h: integer;
begin
  if dir = 1 then begin
    case s[2] of
      ' ', 'P':
           begin
             HalfNo := HalfNo + 1;
             Bloodbowl.UpdateHalfID(HalfNo);
             SWSafeRef := GettheRef;
             GettheRef := 3;
             DefaultAction(TranslateStartHalf(s));
             for g := 0 to 1 do begin
               team[g].UsedLeaderReroll := false;
               marker[g, MT_Leader].SetValue(0);
             end;
             if s[2] = 'P' then Bloodbowl.PregamePanel.Hide;
           end;
      'A', 'C', 'O', 'K', 'M', 'm', 'G', 'g', 'a', 'D', 'E', 'W':
           DefaultAction(TranslateStartHalf(s));
      'T': begin
             for g := 0 to 1 do
              for f := 1 to 8 do begin
                turn[g,f].font.size := 12;
                turn[g,f].color := colorarray[g, 0, 0];
                if WaitLength > 0 then turn[g,f].Refresh;
              end;
           end;
      'R': begin
             g := Ord(s[3]) - 48;
             f := Ord(s[4]) - 48;
             marker[g, MT_Reroll].SetValue(marker[g, MT_Reroll].value + f);
             if f > marker[1-g, MT_Reroll].value then
               f := marker[1-curroster, MT_Reroll].value;
             marker[1-g, MT_Reroll].SetValue(marker[1-g, MT_Reroll].value - f);
             DefaultAction(TranslateStartHalf(s));
           end;
      'r': begin
             g := Ord(s[3]) - 48;
             marker[g, MT_Reroll].SetValue(0);
           end;
    end;
  end else begin
    case s[2] of
      ' ': begin
             HalfNo := HalfNo - 1;
             Bloodbowl.UpdateHalfID(HalfNo);
             BackLog;
           end;
      'A', 'C', 'O', 'K', 'M', 'm', 'G', 'g', 'W':
           BackLog;
      'P': begin
             Bloodbowl.PregamePanel.Show;
             HalfNo := 0;
             BackLog;
           end;
      'T': begin
         {restore used Turn markers to small; set active Turn marker to yellow}
             h := 3;
             while (h <= length(s)) do begin
               if s[h] > Chr(64) then begin
                 f := (Ord(s[h]) - 65) mod 8 + 1;
                 g := (Ord(s[h]) - 65) div 8;
                 turn[g,f].font.size := 8;
               end else begin
                 f := (Ord(s[h]) - 49) mod 8 + 1;
                 g := (Ord(s[h]) - 49) div 8;
                 turn[g,f].color := clYellow;
               end;
               h := h + 1;
             end;
           end;
      'R': begin
             g := Ord(s[3]) - 48;
             f := Ord(s[4]) - 48;
             marker[g, MT_Reroll].SetValue(marker[g, MT_Reroll].value - f);
             marker[1-g, MT_Reroll].SetValue(marker[1-g, MT_Reroll].value + f);
             BackLog;
           end;
      'r': begin
             g := Ord(s[3]) - 48;
             f := Ord(s[4]) - 48;
             marker[g, MT_Reroll].SetValue(f);
           end;
    end;
  end;
end;

procedure MakeRegenerationRolls;
var f, g, Regen2: integer;
    s: string;
begin
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g,f].status >= 6) and (player[g,f].status <= 8)
      and ((player[g,f].HasSkill('Regen*')) or (player[g,f].HasSkill('Restoration')))
      and not(player[g,f].UsedRegeneration) then begin
        if player[g,f].HasSkill('Regen') then
            player[g,f].UseSkill('Regen');
        if player[g,f].HasSkill('Regenerate') then
            player[g,f].UseSkill('Regenerate');
        if player[g,f].HasSkill('Regeneration') then
            player[g,f].UseSkill('Regeneration');
        if player[g,f].hasSkill('RegenKO') then
            player[g,f].UseSkill('RegenKO');
        if player[g,f].hasSkill('Restoration') then
            player[g,f].UseSkill('Restoration');
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        Regen2 := FVal(frmSettings.txtRegenRollNeeded.text);
        if player[g,f].hasSkill('Restoration') then Regen2 := 2;
        if ((Uppercase(team[g].race) = 'VAMPIRE - NECRARCH') or
           (Uppercase(team[g].race) = 'VAMPIRE-NECRARCH')) and
           (frmSettings.cbVampireNecrarch.checked) then
           if (lastroll<>1) and (lastroll<>6) then begin
              lastroll := lastroll + 1;
              Bloodbowl.comment.Text :=
                '+1 bonus to dice roll for Necrarch Vampire team';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
           end;
        if lastroll >= Regen2 then begin
          curteam := g;
          curplayer := f;
          if (player[g,f].hasSkill('RegenKO')) or
            (player[g,f].hasSkill('Restoration')) then
            Bloodbowl.KO1Click(Bloodbowl.KO1) else
            Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
        end else begin
          s := 'KG' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s);
          PlayActionPrepareForKickOff(s, 1);
        end;
      end;
    end;
  end;
end;

{Reset Were player}
procedure ResetWerePlayers;
var f, g: integer;
    s: string;
begin
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if ((player[g,f].status <= 5) or (player[g,f].status = 13))
        and (player[g,f].HasSkill('Were*')) then begin
        s := 'u' + Chr(g + 48) + Chr(f + 64) +
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
          Chr(player[g, f].ma0 + 48) +
          Chr(player[g, f].st0 + 48) +
          Chr(player[g, f].ag0 + 48) +
          Chr(player[g, f].av0 + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
          player[g, f].GetSkillString(2);
        LogWrite(s);
        PlayActionPlayerStatChange(s, 1);
      end;
    end;
  end;
end;

{Nurgle Rotter's Rolls}
procedure NurgleRotRolls;
var f, g, p, s1spot, FALevel: integer;
    s, s2, s3: string;
begin
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (Uppercase(team[g].race) = 'NURGLES ROTTERS') and
        ((player[g,f].status<8) or (player[g,f].status>11)) and
        not (player[g,f].hasSkill('NoRot')) then begin
        if player[g,f].hasSkill('Foul Appearance L*') then begin
          s := player[g,f].Get1Skill('Foul Appearance L*');
          p := FVal(Copy(s, 18, Length(s) - 17));
        end else p := 1;
        if player[g,f].hasSkill('Foul Appearance L*') then begin
          s := player[g,f].Get1Skill('Foul Appearance L*');
          FALevel := FVal(Copy(s, 18, Length(s) - 17));
        end else FALevel := 0;
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= p then begin
          Bloodbowl.comment.text := '#' + InttoStr(f) + ' ' + player[g,f].name +
           ' FAILS his Nurgle Rot ' + InttoStr(p+1) + '+ roll.  Foul Appearance' +
           ' advances one level!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          s2 := '';
          if FALevel=0 then begin
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
              Chr(player[g, f].av - 1 + 48) +
              Chr(player[g,f].cnumber + 64) +
              Chr(player[g,f].value div 5 + 48) +
              player[g,f].name + '$' +
              player[g,f].position + '$' +
              player[g,f].picture + '$' +
              player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1);
            s1spot := Pos('Foul Appearance L',s);
            if s1spot = 0 then begin
              s3 := s + ', Foul Appearance L1, AV -1';
            end else if (s1spot = 1) and ((length(s))>20) then begin
              s3 := 'Foul Appearance L1, '+Copy(s, 21, length(s)-20)+', AV -1';
            end else if (s1spot = 1) and ((length(s))<=18) then begin
              s3 := 'Foul Appearance L1, AV -1';
            end else begin
              s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L1, ' +
                Copy(s, s1spot + 21, length(s)-(20+s1spot)) + ', AV -1';
            end;
            player[g, f].SetSkill(s3);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end else if FALevel = 1 then begin
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
              Chr(player[g, f].av - 1 + 48) +
              Chr(player[g,f].cnumber + 64) +
              Chr(player[g,f].value div 5 + 48) +
              player[g,f].name + '$' +
              player[g,f].position + '$' +
              player[g,f].picture + '$' +
              player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1);
            s1spot := Pos('Foul Appearance L',s);
            if (s1spot = 1) and ((length(s))>20) then begin
              s3 := 'Foul Appearance L2, '+Copy(s, 21, length(s)-20)+', AV -1';
            end else if (s1spot = 1) and ((length(s))<=18) then begin
              s3 := 'Foul Appearance L2, AV -1';
            end else begin
              s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L2, ' +
                Copy(s, s1spot + 21, length(s)-(20+s1spot)) + ', AV -1';
            end;
            player[g, f].SetSkill(s3);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end else if FALevel = 2 then begin
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
              player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1);
            s1spot := Pos('Foul Appearance L',s);
            if (player[g,f].hasSkill('Horns')) or (player[g,f].hasSkill('Horn'))
            then begin
              if (s1spot = 1) and ((length(s))>20) then begin
                s3 := 'Foul Appearance L3, '+Copy(s, 21, length(s)-20);
              end else begin
                s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L3, ' +
                  Copy(s, s1spot + 21, length(s)-(20+s1spot));
              end;
            end else begin
              if (s1spot = 1) and ((length(s))>20) then begin
                s3 := 'Foul Appearance L3, '+Copy(s, 21, length(s)-20)+', Horn';
              end else if (s1spot = 1) and ((length(s))<=18) then begin
                s3 := 'Foul Appearance L3, Horn';
              end else begin
                s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L3, ' +
                  Copy(s, s1spot + 21, length(s)-(20+s1spot)) + ', Horn';
              end;
            end;
            player[g, f].SetSkill(s3);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end else if FALevel = 3 then begin
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
              Chr(player[g, f].ag - 2 + 48) +
              Chr(player[g, f].av + 48) +
              Chr(player[g,f].cnumber + 64) +
              Chr(player[g,f].value div 5 + 48) +
              player[g,f].name + '$' +
              player[g,f].position + '$' +
              player[g,f].picture + '$' +
              player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1);
            s1spot := Pos('Foul Appearance L',s);
            if (s1spot = 1) and ((length(s))>20) then begin
              s3 := 'Foul Appearance L4, '+Copy(s, 21, length(s)-20)+', AG -2';
            end else if (s1spot = 1) and ((length(s))<=18) then begin
              s3 := 'Foul Appearance L4, AG -2';
            end else begin
              s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L4, ' +
                Copy(s, s1spot + 21, length(s)-(20+s1spot)) + ', AG -2';
            end;
            player[g, f].SetSkill(s3);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end else if FALevel = 4 then begin
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
              Chr(player[g, f].ma - 2 + 48) +
              Chr(player[g, f].st + 48) +
              Chr(player[g, f].ag + 48) +
              Chr(player[g, f].av + 48) +
              Chr(player[g,f].cnumber + 64) +
              Chr(player[g,f].value div 5 + 48) +
              player[g,f].name + '$' +
              player[g,f].position + '$' +
              player[g,f].picture + '$' +
              player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1);
            s1spot := Pos('Foul Appearance L',s);
            if (s1spot = 1) and ((length(s))>20) then begin
              s3 := 'Foul Appearance L5, '+Copy(s, 21, length(s)-20)+', MA -2, Claw';
            end else if (s1spot = 1) and ((length(s))<=18) then begin
              s3 := 'Foul Appearance L5, MA -2, Claw';
            end else begin
              s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L5, ' +
                Copy(s, s1spot + 21, length(s)-(20+s1spot)) + ', MA -2, Claw';
            end;
            player[g, f].SetSkill(s3);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end else if FALevel = 5 then begin
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
              Chr(player[g, f].st - 2 + 48) +
              Chr(player[g, f].ag + 48) +
              Chr(player[g, f].av + 48) +
              Chr(player[g,f].cnumber + 64) +
              Chr(player[g,f].value div 5 + 48) +
              player[g,f].name + '$' +
              player[g,f].position + '$' +
              player[g,f].picture + '$' +
              player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1);
            s1spot := Pos('Foul Appearance L',s);
            if (s1spot = 1) and ((length(s))>20) then begin
              s3 := 'Foul Appearance L6, '+Copy(s, 21, length(s)-20)+', ST -2';
            end else if (s1spot = 1) and ((length(s))<=18) then begin
              s3 := 'Foul Appearance L6, ST -2';
            end else begin
              s3 := Copy(s,1,s1spot-1) + 'Foul Appearance L6, ' +
                Copy(s, s1spot + 21, length(s)-(20+s1spot)) + ', ST -2';
            end;
            player[g, f].SetSkill(s3);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end else if FALevel = 6 then begin
            InjuryStatus := 8;
            Bloodbowl.comment.text := player[g,f].name + ' dies from the Rot!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            player[g, f].SetStatus(InjuryStatus);
            InjuryStatus := 0;
          end;
        end else begin
          Bloodbowl.comment.text := '#' + InttoStr(f) + ' ' + player[g,f].name +
          ' passes his Nurgle Rot ' + InttoStr(p+1) + '+ roll.';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end;
      end;
    end;
  end;
end;

procedure PrepareForKickoff;
var s, s0, s2, s3, jtest: string;
    f, g, sw, turnone, extratitchy, heatroll, koroll, jwtest, h, stest: integer;
begin
  s := ClearBall + UnCurSub;
  LogWrite('KB' + s);
  PlayActionPrepareForKickOff('KB' + s, 1);

  Continuing := true;

  turnone := 1;

  for g := 0 to 1 do
   for f := 1 to 8 do begin
    if turn[g,f].color = clYellow then begin
      turnone := 0;
    end;
  end;

  if HalfNo > 1 then begin
    turnone := 0;
  end;

  Bloodbowl.ViewRedPB1.Visible := true;
  Bloodbowl.ViewBluePB1.Visible := true;

  {The following rolls for Sweltering Heat rolls, or Torpor
  rolls during a Blizzard ... in addition Players are returned
  to reserves if they failed their Heat Exhaustion rolls before
  and resets Stunned flags}
  heatroll := 0;
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g,f].StunStatus > 0) and (frmSettings.cbDeStun.Checked)
        then begin
          s3 := 'QS' + Chr(g + 48) + Chr(f + 64) +
            Chr(48-player[g,f].StunStatus);
          LogWrite(s3);
          PlayActionDeStun(s3, 1);
      end;
      if (player[g,f].status > 0) and (player[g,f].status < 5) then begin
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
             'SWELTERING HEAT') OR
             (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 13)) =
             'TROPICAL HEAT')) and (player[g,f].status <= 4)
             and not ((player[g,f].HasSkill('Heat Resistant')) or
             (player[g,f].HasSkill('Cold Natured')) or
             (player[g,f].HasSkill('Stone Cold Stupid')) or
             (player[g,f].hasSkill('Weather Immunity')))
             then begin
          s0 := 'KW' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s0);
          PlayActionPrepareForKickOff(s0, 1);
          heatroll := 1;
          if player[g,f].HasSkill('Cold Resistant') then heatroll := 2;
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= heatroll then begin
            player[g,f].SetStatus(14);
          end;
        end;
        if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
             'BLIZZARD')) and (player[g,f].status <= 4)
             and (player[g,f].HasSkill('Heat Resistant'))
             and not (player[g,f].HasSkill('Cold Blooded'))
             then begin
          s0 := 'Kw' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s0);
          PlayActionPrepareForKickOff(s0, 1);
          heatroll := 1;
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll <= heatroll then begin
            player[g,f].SetStatus(14);
          end;
        end;
      end else begin
        if player[g,f].status = 14 then begin
             curteam := g;
             curplayer := f;
             Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
        end;
      end;
    end;
  end;

  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g,f].status > 0) and (player[g,f].status < 5) then begin
        s := 'KP' + Chr(g + 48) + Chr(f + 64) + Chr(player[g,f].status + 65) +
             Chr(player[g,f].p + 65) + Chr(player[g,f].q + 65) +
             Chr(player[g,f].font.size + 65);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
      end;
    end;
  end;

  s := 'KN' + ClearAllNumOnField;
  LogWrite(s);
  PlayActionPrepareForKickOff(s, 1);

  {The following makes Regeneration rolls}
  MakeRegenerationRolls;

  {The following makes Knocked Out rolls}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if player[g,f].status = 5 then begin
        s := 'KKO' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        koroll := 3;
        for h := 1 to 9 do begin
          jtest := CardsData[g,h].caption;
          jwtest := Pos('JOHNNY WATERBOY',UPPERCASE(jtest));
          stest := CardsData[g,h].font.color;
          if (jwtest <> 0) and (stest = 12632256) then  koroll := 1;
          if (team[g].tr < team[1-g].tr)
            and (SmellingSalts) then koroll := 1;
        end;
        if lastroll > koroll then begin
          curteam := g;
          curplayer := f;
          Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
        end else if (team[g].apot >= 3) and (frmSettings.cbUpApoth.checked)
          and (apo3[g].font.color = colorarray[g, 0, 1]) then begin
          s := 'Kk' + Chr(g + 48) + Chr(f + 64);
          Logwrite(s);
          PlayActionPrepareForKickOff(s, 1);
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll = 6 then begin
            curteam := g;
            curplayer := f;
            Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
          end;
        end;
      end;
    end;
  end;

  {The following for do loop handles the Unstable traits}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if ((player[g,f].status <= 7) or (player[g,f].status = 13))
          and (player[g,f].HasSkill('Unstable')) and (turnone = 0) then begin
        s := 'KU' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 2 then begin
           player[g,f].SetStatus(12);
        end;
      end;
    end;
  end;

  {The following for do loop handles the Easily Confused traits}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if ((player[g,f].status <= 7) or (player[g,f].status = 13))
          and (player[g,f].HasSkill('Easily Confused')) and (turnone = 0) then begin
        s := 'KE' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 3 then begin
           player[g,f].SetStatus(10);
           Bloodbowl.comment.text := 'Easily Confused switches and plays for your' +
             ' opponent!';
           Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        end;
      end;
    end;
  end;

  {The following for do loop handles the On Pitch Take Root trait}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g,f].HasSkill('Take Root')) and
        (frmSettings.cbOPTakeRoot.checked) and (player[g,f].ma = 0) then begin
        s := 'u' + Chr(g + 48) + Chr(f + 64) +
               Chr(0 + 48) +
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
               Chr(player[g, f].ma0 + 48) +
               Chr(player[g, f].st + 48) +
               Chr(player[g, f].ag + 48) +
               Chr(player[g, f].av + 48) +
             Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$' +
               player[g, f].GetSkillString(1);
          LogWrite(s);
          PlayActionPlayerStatChange(s, 1);
      end;
    end;
  end;

  {The following for do loop handles restoring Lost Tackle Zones}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g, f].tz > 0) and (not(player[g,f].HasSkill('Ball and Chain')))
        then begin
        if CanWriteToLog then begin
          s := 'U+' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s);
          PlayActionToggleTackleZone(s, 1);
        end;
      end;
    end;
  end;

  {The following for do loop handles the Will He Show? traits}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if (player[g,f].status = 0) and (player[g,f].HasSkill('Will He Sho*'))
          and (turnone = 1) and (HalfNo = 1) then begin
        s := 'Kh' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 1 then begin
           player[g,f].SetStatus(13);
        end;
      end;
    end;
  end;

  {The following rolls for Off for a Bite and Gluttony}
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if ((player[g,f].status <= 4) or (player[g,f].status = 13))
          and (((player[g,f].HasSkill('Off for a Bite'))) or
               ((player[g,f].HasSkill('OFAB')))) then begin
        s := 'KF' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll <= 3 then begin
           player[g,f].SetStatus(13);
        end else begin
           if player[g,f].status = 13 then begin
             curteam := g;
             curplayer := f;
             Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
           end;
        end;
      end;
      if ((player[g,f].status <= 4) or (player[g,f].status = 13))
          and (player[g,f].HasSkill('Gluttony')) then begin
        s := 'Kg' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if (lastroll <= 1) or ((lastroll <= 3) and
           (player[g,f].HasSkill('Always Hungry'))) then begin
           player[g,f].SetStatus(13);
        end else begin
           if player[g,f].status = 13 then begin
             curteam := g;
             curplayer := f;
             Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
           end;
        end;
      end;
    end;
  end;

  {Were transformation rolls player}
  ResetWerePlayers;
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if ((player[g,f].status <= 4) or (player[g,f].status = 13))
        and (player[g,f].HasSkill('Were*')) then begin
        s := 'KC' + Chr(g + 48) + Chr(f + 64);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll >= 5 then begin
          if (Pos('WEREWOLF', Uppercase(player[g,f].position)) > 0) then begin
            s2 := '';
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
              Chr(player[g, f].ma + 1 + 48) +
              Chr(player[g, f].st + 1 + 48) +
              Chr(player[g, f].ag - 1 + 48) +
              Chr(player[g, f].av + 1 + 48) +
              Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1) + ', Outrage';
            if player[g, f].HasSkill('Break Tackle') then s := s + ', Dodge'
               else s := s + ', Break Tackle';
            player[g, f].SetSkill(s);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end;
          if (Pos('WERECAT', Uppercase(player[g,f].position)) > 0) then begin
            s2 := '';
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
              Chr(player[g, f].ma + 2 + 48) +
              Chr(player[g, f].st + 48) +
              Chr(player[g, f].ag - 1 + 48) +
              Chr(player[g, f].av + 1 + 48) +
              Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1) + ', Sure Feet, Sprint, Outrage';
            if player[g, f].HasSkill('Dodge') then s := s + ', Break Tackle'
               else s := s + ', Dodge';
            player[g, f].SetSkill(s);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end;
          if (Pos('WEREBEAR', Uppercase(player[g,f].position)) > 0) then begin
            s2 := '';
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
              Chr(player[g, f].ma - 2 + 48) +
              Chr(player[g, f].st + 2 + 48) +
              Chr(player[g, f].ag - 1 + 48) +
              Chr(player[g, f].av + 1 + 48) +
                           Chr(player[g,f].cnumber + 64) +
             Chr(player[g,f].value div 5 + 48) +
             player[g,f].name + '$' +
             player[g,f].position + '$' +
             player[g,f].picture + '$' +
             player[g,f].icon + '$';
            s := '';
            s := player[g, f].GetSkillString(1) + ', Bear Hug, Outrage';
            player[g, f].SetSkill(s);
            s2 := s2 + player[g, f].GetSkillString(1);
            LogWrite(s2);
            PlayActionPlayerStatChange(s2, 1);
          end;
        end;
      end;
    end;
  end;

  {The following resets the Used this drive flag and rolls for
  Secret Weapon penalties, and special Weather results}
  s := 'KD';
  for g := 0 to 1 do begin
    for f := 1 to team[g].numplayers do begin
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) <>
             'POURING RAIN')) and (player[g,f].HasSkill('Rusting'))
             and (player[g,f].status = 14)
             then begin
             curteam := g;
             curplayer := f;
             Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
      end;
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) <>
             'VERY SUNNY')) and (player[g,f].HasSkill('Vampiric Change'))
             and (player[g,f].status = 14)
             then begin
             curteam := g;
             curplayer := f;
             Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
      end;
      if (not player[g,f].PlayedThisDrive) and
         ((player[g,f].status <= 4) or (player[g,f].status = 13)) and
         (turnone = 0) then begin
        s := s + Chr(g + 48) + Chr(f + 64);
        if player[g,f].HasSkill('DSW*') and (GettheRef<>2) and (GettheRef<>g)
          and (SWSafeRef<>2) and (SWSafeRef<>g) then begin
          s0 := 'KS' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s0);
          PlayActionPrepareForKickOff(s0, 1);
          s0 := player[g,f].Get1Skill('DSW*');
          sw := FVal(Trim(Copy(s0, 4, Length(s0) - 2)));
          Bloodbowl.TwoD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll >= sw then begin
            player[g,f].SOstatus := player[g,f].status;
            player[g,f].SOSIstatus := player[g,f].SIstatus;
            player[g,f].SetStatus(12);
          end;
        end;
      end;
      if player[g,f].PlayedThisDrive then begin
        s := s + Chr(g + 48) + Chr(f + 64);
        if ((player[g,f].HasSkill('SW*')) or (player[g,f].HasSkill('SSW*')))
          and (GettheRef<>2) and (GettheRef<>g) and (SWSafeRef<>2)
          and (SWSafeRef<>g)
          then begin
          s0 := 'KS' + Chr(g + 48) + Chr(f + 64);
          LogWrite(s0);
          PlayActionPrepareForKickOff(s0, 1);
          if player[g,f].HasSkill('SW*') then begin
            s0 := player[g,f].Get1Skill('SW*');
            sw := FVal(Trim(Copy(s0, 3, Length(s0) - 2)));
          end;
          if player[g,f].HasSkill('SSW*') then begin
            s0 := player[g,f].Get1Skill('SSW*');
            sw := FVal(Trim(Copy(s0, 4, Length(s0) - 3)));
          end;
          Bloodbowl.TwoD6ButtonClick(Bloodbowl.OneD6Button);
          if lastroll >= sw then begin
            player[g,f].SOstatus := player[g,f].status;
            player[g,f].SOSIstatus := player[g,f].SIstatus;
            player[g,f].SetStatus(12);
            if (frmSettings.cbSWRef.checked) then begin
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              if lastroll >= 4 then begin
                Bloodbowl.comment.text := UPPERCASE(player[g,f].GetPlayerName +
                  ' catches the Referee eye too much and the Referee confiscates'
                  + ' his secret weapon!');
                Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                s3 := Chr(252) + player[g,f].GetPlayerName + ' loses his weapon!';
                PlayActionComment(s3, 1, 2);
                LogWrite(s3);
              end else begin
                Bloodbowl.comment.text := player[g,f].GetPlayerName +
                  ' passes the referee roll and keeps his weapon!';
                Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              end;
            end;
          end;
        end;
      end;
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) =
             'SWELTERING HEAT')) and ((player[g,f].HasSkill('Cold Natured')) or
                (player[g,f].HasSkill('Stone Cold Stupid')))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) =
             'BLIZZARD')) and (player[g,f].HasSkill('Cold Blooded'))
             and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 15)) <>
             'SWELTERING HEAT')) and ((player[g,f].HasSkill('Cold Natured')) or
                (player[g,f].HasSkill('Stone Cold Stupid')))
                and (player[g,f].status = 14)
             then begin
               curteam := g;
               curplayer := f;
               Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
      end;
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 8)) <>
             'BLIZZARD')) and (player[g,f].HasSkill('Cold Blooded'))
             and (player[g,f].status = 14)
             then begin
             curteam := g;
             curplayer := f;
             Bloodbowl.MoveToReserve1Click(Bloodbowl.MoveToReserve1);
      end;
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) =
             'POURING RAIN')) and (player[g,f].HasSkill('Rusting'))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
      if ((UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) =
             'VERY SUNNY')) and (player[g,f].HasSkill('Vampiric Change'))
                and (player[g,f].status <= 4)
             then player[g,f].SetStatus(14);
    end;
  end;
  LogWrite(s);
  PlayActionPrepareForKickOff(s, 1);
  SWSafeRef := 3;

  {Titchy handling: see if extra players can be fielded}
  if frmSettings.rgTitchy.ItemIndex=1 then begin
    for g := 0 to 1 do begin
      extratitchy := 0;
      for f := 1 to team[g].numplayers do begin
        if (player[g,f].status <= 7)
        and (player[g,f].HasSkill('Titchy')) then extratitchy := 9;
      end;
      if extratitchy = 9 then begin
        s := 'KT' + Chr(g + 48);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll = 1 then extratitchy := 0 else
        if lastroll < 6 then extratitchy := 1 else extratitchy := 2;
        {extratitchy := lastroll div 2;  1->0, 2->1, 3->1, etc.}
        s := s + InttoStr(extratitchy);
        LogWrite(s);
        PlayActionPrepareForKickOff(s, 1);
      end;
    end;
  end;

  LogWrite('KR');
  PlayActionPrepareForKickOff('KR', 1);

  Continuing := false;
end;

function TranslatePrepareForKickOff(s: string): string;
var f, g: integer;
begin
  case s[2] of
    'B': TranslatePrepareForKickOff := 'Preparing for Kickoff';
    'P': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff := '- move ' +
                               player[g,f].GetPlayerName + ' to dugout';
         end;
    'N': TranslatePrepareForKickOff := '- clear num on field';
    'R': TranslatePrepareForKickOff := '- redraw dugout';
    'T': begin
           g := Ord(s[3]) - 48;
           TranslatePrepareForKickOff :=
               team[g].name + ' Titchy team roll: ' + s[4] +
                 ' extra Titchy players may be fielded';
         end;
    'K': begin
           g := Ord(s[4]) - 48;
           f := Ord(s[5]) - 64;
           TranslatePrepareForKickOff :=
               'KO roll for ' + player[g,f].GetPlayerName;
         end;
    'k': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Level 3+ Apothecary KO roll for ' + player[g,f].GetPlayerName;
         end;
    'G': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Regeneration failed for ' + player[g,f].GetPlayerName;
        end;
    'S': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Penalty roll for ' + player[g,f].GetPlayerName;
         end;
    'E': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Easily Confused roll for ' + player[g,f].GetPlayerName;
         end;
    'W': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Sweltering Heat roll for ' + player[g,f].GetPlayerName;
         end;
    'w': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Torpor roll for ' + player[g,f].GetPlayerName;
         end;
    'U': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Unstable roll for ' + player[g,f].GetPlayerName;
         end;
    'F': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Off for a Bite roll for ' + player[g,f].GetPlayerName;
         end;
    'C': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Were Transformation roll for ' + player[g,f].GetPlayerName;
         end;
    'g': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Gluttony roll for ' + player[g,f].GetPlayerName;
         end;
    'h': begin
           g := Ord(s[3]) - 48;
           f := Ord(s[4]) - 64;
           TranslatePrepareForKickOff :=
               'Will He Show? roll for ' + player[g,f].GetPlayerName;
         end;
    'D': TranslatePrepareForKickOff := '- reset PlayedThisDrive';
  end;
end;

procedure PlayActionPrepareForKickoff(s: string; dir: integer);
var f, g, h: integer;
begin
  if dir = 1 then begin
    case s[2] of
      'B': begin
             ClearBall;
             Uncur;
             DefaultAction(TranslatePrepareForKickOff(s));
           end;
      'P': begin
             g := Ord(s[3]) - 48;
             f := Ord(s[4]) - 64;
             player[g,f].status := 0;
             player[g,f].p := -1;
             player[g,f].q := -1;
             player[g,f].font.size := 12;
           end;
      'N': ClearAllNumOnField;
      'R': RedrawDugout;
      'K', 'S', 'U', 'F', 'T', 'W', 'w', 'g', 'h', 'k', 'C', 'E': begin
             DefaultAction(TranslatePrepareForKickOff(s));
           end;
      'G': begin
             DefaultAction(TranslatePrepareForKickOff(s));
           end;
      'D': begin
             h := 3;
             while h < Length(s) do begin
               g := Ord(s[h]) - 48;
               f := Ord(s[h+1]) - 64;
               player[g,f].PlayedThisDrive := false;
               h := h + 2;
             end;
           end;
     end;
  end else begin
    case s[2] of
      'B': begin
             GiveBall(Copy(s, 3, 3));
             if Length(s) > 5 then
                   PlayActionUncur(Copy(s, 6, Length(s) - 5), -1);
             RedrawDugOut;
             BackLog;
           end;
      'P': begin
             g := Ord(s[3]) - 48;
             f := Ord(s[4]) - 64;
             player[g,f].status := Ord(s[5]) - 65;
             player[g,f].p := Ord(s[6]) - 65;
             player[g,f].q := Ord(s[7]) - 65;
             player[g,f].parent := Bloodbowl;
             player[g,f].top := field[player[g,f].p,player[g,f].q].top;
             player[g,f].left := field[player[g,f].p,player[g,f].q].left;
             player[g,f].font.size := Ord(s[8]) - 65;
           end;
      'N': begin
             PutMultipleNumOnField(Copy(s, 3, Length(s) - 2));
           end;
      'R': ;
      'K', 'S', 'U', 'F', 'T', 'W', 'w', 'g', 'h', 'k', 'C', 'E': BackLog;
      'G': begin
             BackLog;
           end;
      'D': begin
             h := 3;
             while h < Length(s) do begin
               g := Ord(s[h]) - 48;
               f := Ord(s[h+1]) - 64;
               player[g,f].PlayedThisDrive := true;
               h := h + 2;
             end;
           end;
    end;
  end;
end;

procedure PlayActionRiot(s: string; dir: integer);
var f, g, h, t: integer;
begin
  h := 6;
  t := Length(s);
  if (s[t] = 'B') and (dir=1) then dir := -1 else
    if (s[t] = 'B') and (dir= -1) then dir := 1;
  while h < ((Length(s)) - 1) do begin
    g := Ord(s[h]) - 48;
    f := Ord(s[h+1]) - 48;
    h := h + 2;
    if dir = 1 then turn[g,f].font.size := 8
               else turn[g,f].font.size := 12;
  end;
  if dir = 1 then begin
    if ((Ord(s[5])-48)<>0) and ((Ord(s[5])-48)<9) then begin
      turn[(Ord(s[4])-48),(Ord(s[5])-48)].Color := clYellow;
      curmove := Ord(s[4])-48;
    end;
    g := Ord(s[4]) - 48;
    f := Ord(s[5]) - 48;
    if ((Ord(s[3])-48)<>0) and ((Ord(s[3])-48)<9) then begin
      turn[(Ord(s[2])-48),(Ord(s[3])-48)].color := colorarray[(Ord(s[2])-48),0,0];
      turn[(Ord(s[2])-48),(Ord(s[3])-48)].Font.Size := 8;
    end;
    if s[t] = 'B' then begin
      turn[g,(f-1)].color := colorarray[g,0,0];
      turn[g,f].Color := clYellow;
      curmove := g;
    end;
  end else begin
    if ((Ord(s[5])-48)<>0) and ((Ord(s[5])-48)<9) then begin
      turn[(Ord(s[4])-48),(Ord(s[5])-48)].Color := colorarray[(Ord(s[4])-48),0,0];
    end;
    if ((Ord(s[3])-48)<>0) and ((Ord(s[3])-48)<9) then begin
      turn[(Ord(s[2])-48),(Ord(s[3])-48)].color := clYellow;
      turn[(Ord(s[2])-48),(Ord(s[3])-48)].Font.Size := 12;
      curmove := Ord(s[2])-48;
    end;
    g := Ord(s[2]) - 48;
    f := Ord(s[3]) - 48;
    if s[t] = 'B' then begin
      turn[g,f].color := colorarray[g,0,0];
      turn[g,(f-1)].Color := clYellow;
      curmove := g;
    end;
  end;
end;

function ExecuteRiot(turns: integer): boolean;
{ExecuteRiot returns true if the riot ends the half}
var f, g, h, y, z: integer;
    s, s2, s3: string;
begin
  s := '';
  y := -1;
  z := 0;
  if turns = -1 then s3 := 'B' else s3 := '.';
  for g := 0 to 1 do begin
    f := 1;
    while (f <= 8) do begin
      if turn[g,f].color = clYellow then begin
        y := g;
        z := f;
      end;
      f := f +1;
    end;
  end;
  if y = -1 then y := (1-KickOffTeam);
  for g := 0 to 1 do begin
    f := 1;
    while (f <= 8) and ((turn[g,f].Font.Size = 8) or (turn[g,f].color=clYellow))
       do f := f + 1;
    h := f;
    while (h <= 8) and (h < f + turns) do begin
      s := s + Chr(48 + g) + IntToStr(h);
      h := h + 1;
    end;
    if turns = -1 then begin
      s := s + Char(48 + g) + InttoStr(h-1);
    end;
    if g=y then begin
      s2 := InttoStr(y)+InttoStr(z)+InttoStr(y)+InttoStr(h-1);
    end;
  end;
  s := '�' + s2 + s + s3;
  PlayActionRiot(s, 1);
  LogWrite('(' + s);
  ExecuteRiot := ((turn[0,8].font.size = 8) and (turn[1,8].Font.size = 8));
end;

end.