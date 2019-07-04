unit unitBall;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TmodBall = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TBall = record
    p, q: integer;
  end;

var
  modBall: TmodBall;
  ball: TBall;

function ClearBall: string;
procedure GiveBall(s:string);
procedure PlayActionPlaceBall(s: string; dir: integer);
procedure PlaceBall(p, q: integer);
procedure ScatterBallFrom(p, q, sctimes, arrow: integer);
procedure ScatterD8D6(p, q: integer; kickoff, BadKick: boolean);
procedure ScatterStuffFrom(p, q, sctimes, arrow: integer; thething: string);

implementation

uses bbunit, bbalg, unitLog, unitPlayAction, unitField, unitCatch, unitRandom,
  unitPass, unitSettings;

{$R *.DFM}

function ClearBall: string;
var s: string;
    f, g, st: integer;
begin
  if ball.p = -1 then begin
    s := '---';
  end else if ball.p >= 0 then begin
    s := 'F' + Chr(ball.p + 65) + Chr(ball.q + 65);
    Bloodbowl.ballImage.visible := false;
    if ref then Bloodbowl.ballImage.Refresh;
  end else begin
    g := ball.p + 3;
    f := ball.q;
    if player[g,f].status = 2 then st := 1 else st := player[g,f].status;
    player[g,f].status := st;
    player[g,f].Redraw;
    s := 'P' + Chr(g + 48) + Chr(f + 65);
  end;
  ball.p := -1;
  ball.q := -1;
  ClearBall := s;
end;

procedure GiveBall(s:string);
var f, g: integer;
begin
{  ClearBall;}
  if s[1] = '-' then begin
    ball.p := -1;
  end else if s[1] = 'F' then begin
    ball.p := Ord(s[2]) - 65;
    ball.q := Ord(s[3]) - 65;
    Bloodbowl.ballImage.left := field[ball.p,ball.q].left;
    Bloodbowl.ballImage.top := field[ball.p,ball.q].top;
    Bloodbowl.ballImage.visible := true;
    Bloodbowl.ballImage.BringToFront;
    if ref then Bloodbowl.ballImage.Refresh;
 end else if s[1] = 'P' then begin
    g := Ord(s[2]) - 48;
    f := Ord(s[3]) - 65;
    ball.p := g - 3;
    ball.q := f;
    player[g,f].status := 2;
    player[g,f].Redraw;
  end;
end;

procedure PlayActionPlaceBall(s: string; dir: integer);
var f, g, v: integer;
begin
  f := Ord(s[5]) - 65;
  g := Ord(s[6]) - 65;
  if dir = 1 then begin
    ClearBall;
    ball.p := f;
    ball.q := g;
    AddLog('Ball at ' + field[f,g].hint);
    AccuratePassPlay := False;
    if WaitLength > 0 then begin
      field[f,g].color := clPurple;
      field[f,g].Refresh;
      Wait;
      field[f,g].color := clGreen;
      field[f,g].Refresh;
    end;
    Bloodbowl.ballImage.left := field[f,g].left;
    Bloodbowl.ballImage.top := field[f,g].top;
    Bloodbowl.ballImage.visible := true;
    Bloodbowl.ballImage.BringToFront;
    if WaitLength > 0 then Bloodbowl.ballImage.Refresh;
    if s[7] <> '@' then begin
      v := Ord(s[7]) - 65;
      RemoveNumOnField(v);
    end;
    field[f,g].BringToFront;
  end else begin
    BackLog;
    if s[7] <> '@' then begin
      PutNumOnField(f, g, Ord(s[7]) - 65,  Ord(s[8]) - 65);
    end else field[f,g].caption := '';
    Bloodbowl.ballImage.visible := false;
    GiveBall(Copy(s,2,3));
  end;
end;

procedure PlaceBall(p, q: integer);
var s, t: string;
    v, c: integer;
begin
  if CanWriteToLog then begin
    AccuratePassPlay := False;
    AccurateTeam := -1;
    AccuratePlayer := -1;
    s := ClearBall;
    if field[p,q].caption = 'X' then v := 15
         else v := FVal(field[p,q].caption) - 1;
    if v >= 0 then c := NumOnFieldColor(v) else c := 0;
    t := 'B' + s + Chr(p + 65) + Chr(q + 65) + Chr(v + 65) + Chr(c + 65);
    LogWrite(t);
    PlayActionPlaceBall(t, 1);
  end;
end;

procedure ScatterBallFrom(p, q, sctimes, arrow: integer);
{ScatterBallFrom scatters the ball from (p,q) sctimes times,
 so a single bounce will be ScatterBallFrom(p,q,1), an incomplete pass
 will be ScatterBallFrom(p,q,3)  }
 {if arrow has a value then the scatter direction is predetermined}
var f, g, x, done, p0, q0, ndir, throwin, throwdis, dp, dq: integer;
    s: string;
    DCcheck: boolean;
begin
  done := 0;
  dp := 0;
  dq := 0;
  ndir := 0;
  throwin := 0;
  DCcheck := false;
  while done = 0 do begin
    {first let the ball scatter sctimes}
    while done < sctimes do begin
      throwin := 0;
      if arrow = 0 then Bloodbowl.D8ButtonClick(Bloodbowl.D8Button) else
         lastroll := arrow;
      {store old position of the ball}
      p0 := p;
      q0 := q;
      NewPosInDir(p, q, lastroll);
      {check to see if the ball goes out of bounds}
      if (KickoffTeam<>-1) and ((p < 0) or (p > 14) or (q < 0) or (q > 25) or
        ((q<13) and (KickoffTeam=1)) or ((q>12) and (KickoffTeam=0))) then begin
        TouchBack := true;
        s := 'Kickoff lands out out of receiving team pitch half ... touchback!';
        Bloodbowl.comment.text := s;
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end else begin
        while (p < 0) or (p > 14) or (q < 0) or (q > 25) do begin
          Bloodbowl.comment.text := 'Ball goes out of bounds!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          {process throwin from out of bounds}
          s := '*throwin ';
          if p<0 then s := s + 'T';
          if q<0 then s := s + 'L';
          if q>25 then s := s + 'R';
          if p>14 then s := s + 'B';
          if p<0 then ndir := 100;
          if q<0 then ndir := 200;
          if q>25 then ndir := 300;
          if p>14 then ndir := 400;
          throwin := Rnd(6,6) + 1;
          throwdis := Rnd(6,6) + Rnd(6,6) + 2;
          s := s + Chr(throwin + 48) + Chr(throwdis + 64);
          ndir := ndir + throwin;
          Bloodbowl.comment.text := s;
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          {determine direction of the throwin}
          case ndir of
            305, 306, 401, 402: begin dp := -1; dq := -1; end;
            403, 404:           begin dp := -1; dq :=  0; end;
            201, 202, 405, 406: begin dp := -1; dq :=  1; end;
            303, 304:           begin dp :=  0; dq := -1; end;
            203, 204:           begin dp :=  0; dq :=  1; end;
            105, 106, 301, 302: begin dp :=  1; dq := -1; end;
            103, 104:           begin dp :=  1; dq :=  0; end;
            101, 102, 205, 206: begin dp :=  1; dq :=  1; end;
          end;
          {set starting ball square = to last square on pitch}
          p := p0;
          q := q0;
          {determine if throwin lands in crowd again or}
          {on square on the pitch}
          x := 1;
          while (x <= throwdis - 1)
          and (p >= 0) and (p <= 14) and (q >= 0) and (q <= 25) do begin
            p0 := p;
            q0 := q;
            p := p + dp;
            q := q + dq;
            x := x + 1;
          end;
          {make sure no more scatters after throw-in}
          done := sctimes;
        end;
      end;
      done := done + 1;
    end;
    {after inaccurate pass or throw-in, one more bounce}
    if (sctimes > 1) or (throwin > 0) then begin
      sctimes := 1;
      done := 0;
      arrow := 0;
      DCcheck := true;
    end;
    {but first see if a player can catch the ball}
    if (not(Touchback)) then begin
      for g := 0 to 1 do begin
        for f := 1 to team[g].numplayers do begin
          if (player[g,f].p = p) and (player[g,f].q = q) then begin
            if player[g,f].status < 3 then begin
              done := 99;
              Bloodbowl.comment.text := player[g,f].GetPlayerName +
                  ' can catch the ball';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              ShowCatchWindow(g, f, 0, false, false);
              DCCheck := false;
            end else begin
              Bloodbowl.comment.text := 'Ball bounces on ' +
                  player[g,f].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              sctimes := 1;
              done := 0;
              DCCheck := false;
            end;
          end;
        end;
      end;
      if (DCCheck) and (frmSettings.cbDC.checked) then begin
        DCCheck := DetermineDivingCatch(p,q,1,0);
        if DCCheck then begin
          done := 99;
          DCCheck := false;
        end;
      end;
    end;
  end;
  if (done < 99) and (not(Touchback)) then PlaceBall(p, q);
end;

procedure ScatterStuffFrom(p, q, sctimes, arrow: integer; thething: string);
{ScatterStuffFrom scatters something from (p,q) sctimes times,
 so a single bounce will be ScatterStuffFrom(p,q,1), an incomplete pass
 will be ScatterStuffFrom(p,q,3)  }
 {if arrow has a value then the scatter direction is predetermined}
var done, p0, q0, throwin: integer;
begin
  done := 0;
  while done = 0 do begin
    {let the thing scatter sctimes}
    while done < sctimes do begin
      throwin := 0;
      if arrow = 0 then Bloodbowl.D8ButtonClick(Bloodbowl.D8Button) else
         lastroll := arrow;
      {store old position of the thing}
      p0 := p;
      q0 := q;
      NewPosInDir(p, q, lastroll);
      {check to see if the things goes out of bounds}
      while (p < 0) or (p > 14) or (q < 0) or (q > 25) do begin
        Bloodbowl.comment.text := thething + ' goes into the crowd.  No Effect!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
       {make sure no more scatters after out of bounds}
        done := sctimes;
        StuffP := -1;
        StuffQ := -1;
        p := 0;
        q := 0;
      end;
      done := done + 1;
    end;
  end;
  if StuffP <> -1 then begin
    StuffP := p;
    StuffQ := q;
  end;
end;

procedure ScatterD8D6(p, q: integer; kickoff, BadKick: boolean);
var arrow, arrowp, arrowq, lastp, lastq, scat, g, f, f2, firstQ, QTeam: integer;
    oob, catchit, KickSkill, KickerPlayer: boolean;
    s: string;
begin
  KickSkill := false;

    KickerPlayer := true;
  FirstQ := Q;
  if FirstQ <= 12 then QTeam := 1 else QTeam := 0;
  Bloodbowl.D8ButtonClick(Bloodbowl.D8Button);
  arrow := lastroll;
  if not(BadKick) then Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button)
    else Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
  for f2 := 1 to team[QTeam].numplayers do begin
    if (player[QTeam,f2].HasSkill('Kick')) and (player[QTeam,f2].status = 1)
      and (kickoff) and (player[QTeam,f2].q > 13) and (player[QTeam,f2].p > 3)
      and (player[QTeam,f2].p < 11) and (QTeam = 1) then KickSkill := true;
    if (player[QTeam,f2].HasSkill('Kick')) and (player[QTeam,f2].status = 1)
      and (kickoff) and (player[QTeam,f2].q < 12) and (player[QTeam,f2].p > 3)
      and (player[QTeam,f2].p < 11) and (QTeam = 0) then KickSkill := true;
    if (player[QTeam,f2].status = 1) and (kickoff) and (player[QTeam,f2].q > 13)
      and (player[QTeam,f2].p > 3) and (player[QTeam,f2].p < 11) and (QTeam = 1)
      then KickerPlayer := true;
    if (player[QTeam,f2].status = 1) and (kickoff) and (player[QTeam,f2].q < 12)
      and (player[QTeam,f2].p > 3) and (player[QTeam,f2].p < 11) and (QTeam = 0)
      then KickerPlayer := true;
  end;
  if KickSkill then lastroll := lastroll div 2;
  if arrow=1 then begin
       arrowp := -1;
       arrowq := -1;
  end else
    if arrow=2 then begin
         arrowp := -1;
         arrowq := 0;
    end else
    if arrow=3 then begin
         arrowp := -1;
         arrowq := 1;
    end else
    if arrow=5 then begin
         arrowp := 0;
         arrowq := 1;
    end else
    if arrow=8 then begin
         arrowp := 1;
         arrowq := 1;
    end else
    if arrow=7 then begin
         arrowp := 1;
         arrowq := 0;
    end else
    if arrow=6 then begin
         arrowp := 1;
         arrowq := -1;
    end else
    if arrow=4 then begin
         arrowp := 0;
         arrowq := -1;
    end;
  scat := 0;
  while (scat < lastroll) and not (oob) do begin
    LastP := P;
    LastQ := Q;
    P := P + arrowp;
    Q := Q + arrowq;
    if (P < 0) or (P > 14) or (Q < 0) or (Q > 25) then oob := true;
    scat := scat + 1;
  end;
  if kickoff then begin
    if (FirstQ >= 13) and (Q <= 12) then oob := true;
    if (FirstQ <= 12) and (Q >= 13) then oob := true;
  end;
  CatchIt := false;
  if not (oob) and not(kickoff) then begin
    s := 'Punt lands in ' + Chr(Q+65) + InttoStr(P+1);
    Bloodbowl.comment.text := s;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if (player[g,f].p = P) and (player[g,f].q = Q) then begin
          if player[g,f].status < 3 then begin
            Bloodbowl.comment.text := player[g,f].GetPlayerName +
                ' can catch the ball';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            ShowCatchWindow(g, f, 0, false, false);
            Catchit := true;
          end;
        end;
      end;
    end;
    if not(CatchIt) and (frmSettings.cbDC.Checked) then begin
      CatchIt := DetermineDivingCatch(P,Q,1,0);
    end;
    if not (CatchIt) then ScatterBallFrom(P, Q, 1, 0)
  end else if not(oob) and (kickoff) and (KickerPlayer) then begin
    CatchIt := false;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if (player[g,f].p = P) and (player[g,f].q = Q) then begin
          if player[g,f].status < 3 then begin
            Bloodbowl.comment.text := player[g,f].GetPlayerName +
                ' can catch the ball after the kickoff result has been resolved';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Catchit := true;
            KoCatcherTeam := g;
            KoCatcherPlayer := f;
            ball.p := player[g,f].p;
            ball.q := player[g,f].q;
          end;
        end;
      end;
    end;
    if not(CatchIt) and (frmSettings.cbDC.Checked) then begin
      CatchIt := DetermineDivingCatch(P,Q,0,0);
    end;
    if not (Catchit) then begin
      s := 'Kickoff WILL land in ' + Chr(Q+65) + InttoStr(P+1) ;
      Bloodbowl.comment.text := s;
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      PlaceBall(p, q)
    end;
  end else if (oob) and (kickoff) and (KickerPlayer) then begin
    TouchBack := true;
    s := 'Kickoff lands out of bounds ... touchback!';
    Bloodbowl.comment.text := s;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end else if (kickoff) and not(KickerPlayer) then begin
    Touchback := True;
    Bloodbowl.comment.text := 'No player set up to kick the ball!  TOUCHBACK!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end else begin
      if (P < 0) and (Q < 0) then
        ScatterBallFrom(LastP, LastQ, 1, 1) else
      if (P < 0) and (Q > 25) then
         ScatterBallFrom(LastP, LastQ, 1, 3) else
      if (P > 14) and (Q < 0) then
         ScatterBallFrom(LastP, LastQ, 1, 6) else
      if (P > 14) and (Q > 25) then
         ScatterBallFrom(LastP, LastQ, 1, 8) else
      if (P < 0) then
         ScatterBallFrom(LastP, LastQ, 1, 2) else
      if (P > 14) then
         ScatterBallFrom(LastP, LastQ, 1, 7) else
      if (Q < 0) then
         ScatterBallFrom(LastP, LastQ, 1, 4) else
      if (Q > 25) then
         ScatterBallFrom(LastP, LastQ, 1, 5);
  end;
end;

end.
