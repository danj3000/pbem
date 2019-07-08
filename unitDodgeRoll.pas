unit unitDodgeRoll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, bbalg, unitLog;

type
  TfrmDodgeRoll = class(TForm)
    lblDirectionTxt: TLabel;
    MakeDodgeRollButton: TButton;
    lblPlayerUses: TLabel;
    lblOpponentsUse: TLabel;
    StuntyCB: TCheckBox;
    TwoHeadsCB: TCheckBox;
    BreakTackleCB: TCheckBox;
    lblPrehTailTxt: TLabel;
    lblTentaclesTxt: TLabel;
    PrehTail: TEdit;
    Tentacles: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    lblRollNeeded: TLabel;
    playerag: TEdit;
    playerst: TEdit;
    Roll: TEdit;
    lblNumberReprTxt: TLabel;
    butUseTeamReroll: TButton;
    lblDodgeFailed: TLabel;
    butUseDodgeSkill: TButton;
    butUseStandFirmSkill: TButton;
    butKnockOver: TButton;
    lblDodgeRerollFailed: TLabel;
    TitchyCB: TCheckBox;
    cbBigGuyAlly: TCheckBox;
    cbDivingTackle: TCheckBox;
    butPro: TButton;
    MakeGFIRoll: TButton;
    procedure Recalc(Sender: TObject);
    procedure MakeDodgeRollButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure butUseTeamRerollClick(Sender: TObject);
    procedure butUseDodgeSkillClick(Sender: TObject);
    procedure butMakeGFIRollClick(Sender: TObject);
    procedure butUseStandFirmSkillClick(Sender: TObject);
    procedure butProClick(Sender: TObject);
    procedure butKnockOverClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TDirBut = class(TButton)
    procedure DirButClick(Sender: TObject);
  private
    n, dx, dy: integer;
  end;

var
  frmDodgeRoll: TfrmDodgeRoll;
  DirBut: array [0..8] of TDirBut;
  f0, g0, r, r2, db, DTf: integer;

procedure ShowDodgeRollWindow(gg, ff: integer);

implementation

uses bbunit, unitField, unitPlayer, unitMarker, unitTeam, unitArmourRoll,
     unitBall, unitPickUp, unitGFI, unitSettings;

var OppHasTackle: boolean;
    TeamPlayer, NumberPlayer: integer;
    OppWithTentacles: array [1..8] of integer;

{$R *.DFM}

procedure ShowDodgeRollWindow(gg, ff: integer);
var f, i, j, b, tz, pt, ten: integer;
begin
  g0 := gg;
  f0 := ff;
  TeamPlayer := g0;
  NumberPlayer := f0;
  frmDodgeRoll.MakeDodgeRollButton.enabled := false;
  frmDodgeRoll.MakeGFIRoll.Enabled := false;
  frmDodgeRoll.playerag.text := IntToStr(allPlayers[g0,f0].ag);
  frmDodgeRoll.playerst.text := IntToStr(allPlayers[g0,f0].st);
  frmDodgeRoll.StuntyCB.checked := (allPlayers[g0,f0].hasSkill('Stunty')) and
    (not(allPlayers[g0,f0].HasSkill('SW*')));
  frmDodgeRoll.TwoHeadsCB.checked := allPlayers[g0,f0].hasSkill('Two Heads');
  if true then
       frmDodgeRoll.BreakTackleCB.checked :=
                        (allPlayers[g0,f0].hasSkill('Break Tackle')
                         and not(allPlayers[g0,f0].usedSkill('Break Tackle')))
  else frmDodgeRoll.BreakTackleCB.checked :=
                        allPlayers[g0,f0].hasSkill('Break Tackle');
  frmDodgeRoll.TitchyCB.Visible := true;
  frmDodgeRoll.TitchyCB.checked := (allPlayers[g0,f0].hasSkill('Titchy')) and
    (not(allPlayers[g0,f0].HasSkill('SW*'))) and (true);

  frmDodgeRoll.cbBigGuyAlly.checked := (((allPlayers[g0,f0].BigGuy) or
    (allPlayers[g0,f0].Ally)) and ( true));   // bigguy
  b := 0;
  pt := 0;
  ten := 0;
  DTf := 1;
  OppHasTackle := false;
  frmDodgeRoll.cbDivingTackle.checked := false;
  frmDodgeRoll.cbDivingTackle.visible := true;
  for i := -1 to 1 do
   for j := -1 to 1 do if (i<>0) or (j<>0) then begin
    tz := 0;
    if allPlayers[g0,f0].p + i < 0 then tz := 10;
    if allPlayers[g0,f0].p + i > 14 then tz := 10;
    if allPlayers[g0,f0].q + j < 0 then tz := 10;
    if allPlayers[g0,f0].q + j > 25 then tz := 10;
    if tz = 0 then begin
      for f := 1 to team[1-g0].numplayers do begin
        if (allPlayers[1-g0,f].status = 1)
        or (allPlayers[1-g0,f].status = 2)
        then begin
          if (abs(allPlayers[1-g0,f].p - allPlayers[g0,f0].p - i) <= 1)
          and (abs(allPlayers[1-g0,f].q - allPlayers[g0,f0].q - j) <= 1) then begin
            if (allPlayers[1-g0,f].tz = 0) and
               not ((allPlayers[1-g0,f].hasSkill('Titchy')) and
                 (true)) then tz := tz + 1;
          end;
          if (allPlayers[1-g0,f].p = allPlayers[g0,f0].p + i)
          and (allPlayers[1-g0,f].q = allPlayers[g0,f0].q + j) then begin
            tz := 10;
            if allPlayers[1-g0,f].tz = 0 then begin
              if allPlayers[1-g0,f].hasSkill('Prehensile Tail') then pt := pt + 1;
              if allPlayers[1-g0,f].hasSkill('Tentacles') then begin
                ten := ten + 1;
                OppWithTentacles[ten] := f;
              end;
              if allPlayers[1-g0,f].hasSkill('Tackle') then OppHasTackle := true;
              if (allPlayers[1-g0,f].hasSkill('Diving Tackle')) and
                 (allPlayers[1-g0,f].status = 1) and (true)
                 then begin
                   frmDodgeRoll.cbDivingTackle.checked := true;
                   DTf := f;
                 end;
            end;
          end;
        end;
        if ((allPlayers[1-g0,f].status >= 1) and (allPlayers[1-g0,f].status <= 4))
          then begin
            if (allPlayers[1-g0,f].p = allPlayers[g0,f0].p + i)
              and (allPlayers[1-g0,f].q = allPlayers[g0,f0].q + j) then tz := 10;
          end;
      end;
      for f := 1 to team[g0].numplayers do begin
        if (f <> f0) and ((allPlayers[g0,f].status >= 1)
          and (allPlayers[g0,f].status <= 4)) then begin
            if (allPlayers[g0,f].p = allPlayers[g0,f0].p + i)
            and (allPlayers[g0,f].q = allPlayers[g0,f0].q + j) then tz := 10;
        end;
      end;
    end;
    if tz < 10 then begin
      DirBut[b].caption := IntToStr(tz);
      DirBut[b].enabled := true;
    end else begin
      DirBut[b].caption := '';
      DirBut[b].enabled := false;
    end;
    b := b + 1;
  end;
  frmDodgeRoll.PrehTail.text := IntToStr(pt);
  frmDodgeRoll.Tentacles.text := IntToStr(ten);
  frmDodgeRoll.Height := 345;
  frmDodgeRoll.Show;
end;

procedure TDirBut.DirButClick(Sender: TObject);
var b: integer;
begin
  for b := 0 to 7 do begin
    if b = n then begin
      font.color := clRed;
      Refresh;
      db := n;
    end else DirBut[b].font.color := clBlack;
  end;
  frmDodgeRoll.Recalc(Sender);
  frmDodgeRoll.MakeDodgeRollButton.enabled := true;
  frmDodgeRoll.MakeGFIRoll.Enabled := true;
end;

procedure TfrmDodgeRoll.Recalc(Sender: TObject);
begin
  if frmDodgeRoll.BreakTackleCB.checked
   and true then
      frmDodgeRoll.BreakTackleCB.checked :=
        allPlayers[g0,f0].hasSkill('Break Tackle')
        and not(allPlayers[g0,f0].usedSkill('Break Tackle'));
  if BreakTackleCB.checked
        then begin
          r := 6 - FVal(playerst.text);
          r2 := 6 - FVal(playerag.text);
        end else begin
          r := 6 - FVal(playerag.text);
          r2 := 6 - FVal(playerag.text);
        end;
  if not(StuntyCB.checked or TitchyCB.checked)
        then begin
          r := r + FVal(DirBut[db].caption);
          r2 := r2 + FVal(DirBut[db].caption);
        end;
  if TwoHeadsCB.checked then begin
    r := r - 1;
    r2 := r2 - 1;
  end;

  if cbDivingTackle.checked then begin
    r := r + 2;
    r2 := r2 + 2;
  end;
  if TitchyCB.checked then begin
    r := r - 1;
    r2 := r2 -1 ;
  end;
  r := r + FVal(PrehTail.text);
  r2 := r2 + FVal(PrehTail.text);
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  if r2 < 2 then r2 := 2;
  if r2 > 6 then r2 := 6;
  Roll.text := IntToStr(r) + '+';
end;

function WorkOutDodgeResult(t: integer): boolean;
var r3: integer;
begin
  r3 := 0;
  if true
    and frmDodgeRoll.cbDivingTackle.checked then begin
     if r = 2 then r3 := 7 else
     if r = 3 then r3 := 2 else r3 := r - 2;
  end;
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if frmDodgeRoll.cbDivingTackle.checked then begin
    if (lastroll >= r) then begin
      if (frmDodgeRoll.BreakTackleCB.checked) and (lastroll < r2) and
         (true) then
          allPlayers[g0,f0].UseSkill('Break Tackle');
      if (not(allPlayers[1-g0,DTf].usedSkill('Diving Tackle'))) and
        (not(true)) then
          allPlayers[1-g0,DTf].UseSkill('Diving Tackle');
      if allPlayers[1-g0,DTf].usedSkill('Diving Tackle') then
       Bloodbowl.comment.text := 'Dodge successful - Diving Tackle used - Place' +
           'DT player prone in square you LEFT!' else
       Bloodbowl.comment.text := 'Dodge successful - Diving Tackle not used';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      WorkOutDodgeResult := true;
    end else begin
      if (not(allPlayers[1-g0,DTf].usedSkill('Diving Tackle')) and
        (not (true))) or
        ((true) and (lastroll >= r3) and
         not(allPlayers[1-g0,DTf].usedSkill('Diving Tackle'))) then
        allPlayers[1-g0,DTf].UseSkill('Diving Tackle');
      if (t = 0) and (allPlayers[1-g0,DTf].usedSkill('Diving Tackle')) then
         Bloodbowl.comment.text := 'Dodge failed! - Diving Tackle used - Place' +
           'DT player prone in square you LEFT!' else
      if (t = 0) and (not(allPlayers[1-g0,DTf].usedSkill('Diving Tackle'))) then
         Bloodbowl.comment.text := 'Dodge failed! - Diving Tackle not used' else
      if (t <> 0) and (not(allPlayers[1-g0,DTf].usedSkill('Diving Tackle'))) then
         Bloodbowl.comment.text := 'Dodge REROLL failed! - Diving Tackle not used'
      else Bloodbowl.comment.text := 'Dodge REROLL failed! - Diving Tackle used - Place' +
           'DT player prone in square you LEFT!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      WorkOutDodgeResult := false;
      frmDodgeRoll.BringToFront;
    end;
  end else begin
    if (lastroll >= r) then begin
      if (frmDodgeRoll.BreakTackleCB.checked) and (lastroll < r2) and
         (true) then
          allPlayers[g0,f0].UseSkill('Break Tackle');
      Bloodbowl.comment.text := 'Dodge successful';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      WorkOutDodgeResult := true;
    end else begin
      if t = 0 then Bloodbowl.comment.text := 'Dodge failed!'
               else Bloodbowl.comment.text := 'Dodge REROLL failed!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      WorkOutDodgeResult := false;
      frmDodgeRoll.BringToFront;
    end;
  end;
end;

procedure TfrmDodgeRoll.MakeDodgeRollButtonClick(Sender: TObject);
var succes, Tentacles4th, UReroll: boolean;
    r1, r2, f: integer;
    s: string;
begin
  succes := true;
  UReroll := true;
  f := 1;
  Tentacles4th := true;
  while succes and (f <= FVal(Tentacles.text)) do begin
    s := allPlayers[g0,f0].GetPlayerName + ' tries to get away from Tentacles';
    if Tentacles4th then
          s := s + ' of ' + allPlayers[1-g0,OppWithTentacles[f]].GetPlayerName;
    Bloodbowl.comment.text := s;
    Bloodbowl.EnterButtonClick(Bloodbowl);
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    r1 := lastroll;
    if Tentacles4th then Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    r2 := lastroll;
    if Tentacles4th then begin
      with allPlayers[g0,f0] do begin
        s := GetPlayerName + ': ST' + IntToStr(st) + ' + ' +
             IntToStr(r1) + ' = ' + IntToStr(st + r1);
      end;
      with allPlayers[1-g0,OppWithTentacles[f]] do begin
        s := s + ', ' + GetPlayerName + ': ST' + IntToStr(st) + ' + ' +
             IntToStr(r2) + ' = ' + IntToStr(st + r2);
      end;
      Bloodbowl.comment.text := s;
      Bloodbowl.EnterButtonClick(Bloodbowl);
    end;
    if (Tentacles4th and
            (r1 + allPlayers[g0,f0].st < r2 + allPlayers[1-g0,OppWithTentacles[f]].st))
    or (not(Tentacles4th) and (lastroll >= allPlayers[g0,f0].st)) then begin
      succes := false;
      if CanUseTeamReroll(cbBigGuyAlly.checked) then begin
        if Application.MessageBox('Tentacles roll failed! Use Team Reroll?',
         'Tentacles Failure', mb_OKCancel) = 1 then begin
          succes := true;
          UReroll := UseTeamReroll;
          if not(UReroll) then succes := false;
        end;
      end;
    end else f := f + 1;
  end;
  if not(succes) then begin
    {didn't escape Tentacles}
    Bloodbowl.comment.text := allPlayers[g0,f0].GetPlayerName +
       ' was grabbed by Tentacles';
    Bloodbowl.EnterButtonClick(Bloodbowl);
    frmDodgeRoll.Hide;
  end else begin
    Bloodbowl.comment.text := allPlayers[g0,f0].GetPlayerName + ' dodges to ' +
       field[allPlayers[g0,f0].p + DirBut[db].dx,
          allPlayers[g0,f0].q + DirBut[db].dy].hint + ' (';
    if TwoHeadsCB.checked then
      Bloodbowl.comment.text := Bloodbowl.comment.text + 'Two Heads, ';

    if BreakTackleCB.checked and true then
       Bloodbowl.comment.text := Bloodbowl.comment.text +
       'Break Tackle (optional), ';
    if BreakTackleCB.checked and not(true) then
      Bloodbowl.comment.text := Bloodbowl.comment.text + 'Break Tackle, ';
    if (cbDivingTackle.checked) and not (true) then
      Bloodbowl.comment.text := Bloodbowl.comment.text + 'Diving Tackle, ';
    if PrehTail.text <> '0' then Bloodbowl.comment.text :=
         Bloodbowl.comment.text + PrehTail.text +' Prehensile Tail, ';
    if StuntyCB.checked then
      Bloodbowl.comment.text := Bloodbowl.comment.text + 'Stunty, '
    else if DirBut[db].caption <> '0' then Bloodbowl.comment.text :=
         Bloodbowl.comment.text + DirBut[db].caption +' TZ, ';
    Bloodbowl.comment.text := Bloodbowl.comment.text + IntToStr(r) + '+)';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    succes := WorkOutDodgeResult(0);
    if not(succes) then begin
      butUseDodgeSkill.enabled := false;
      butUseTeamReroll.enabled := false;
      butUseStandFirmSkill.enabled := false;
      lblDodgeRerollFailed.Visible := false;
      if allPlayers[g0,f0].hasSkill('Dodge') and not(OppHasTackle)
      and not(allPlayers[g0,f0].usedSkill('Dodge')) then
        butUseDodgeSkill.enabled := true;
      if allPlayers[g0,f0].hasSkill('Pro')and
        not(allPlayers[g0,f0].usedSkill('Pro')) then
        butPro.enabled := true;
      butUseTeamReroll.enabled := CanUseTeamReroll(cbBigGuyAlly.checked);
      if allPlayers[g0,f0].hasSkill('Stand Firm') then
        butUseStandFirmSkill.enabled := true;
    end;
    if succes then begin
      PlacePlayer(f0, g0,
         allPlayers[g0,f0].p + DirBut[db].dx, allPlayers[g0,f0].q + DirBut[db].dy);
      frmDodgeRoll.Hide;
      if (allPlayers[g0,f0].p = ball.p) and (allPlayers[g0,f0].q = ball.q) then begin
        Continuing := true;
        allPlayers[g0,f0].SetStatus(2);
        Continuing := false;
        ShowPickUpWindow(g0, f0);
      end;
    end else begin
      frmDodgeRoll.Height := 508;
    end;
    frmDodgeRoll.MakeDodgeRollButton.enabled := false;
    frmDodgeRoll.MakeGFIRoll.enabled := false;
    for f := 0 to 7 do DirBut[f].enabled := false;
  end;
end;

procedure TfrmDodgeRoll.FormCreate(Sender: TObject);
var i, j, b: integer;
begin
  b := 0;
  for i := -1 to 1 do
   for j := -1 to 1 do if (i<>0) or (j<>0) then begin
    DirBut[b] := TDirBut.Create(frmDodgeRoll);
    DirBut[b].dx := i;
    DirBut[b].dy := j;
    DirBut[b].n := b;
    DirBut[b].top := 33 + 25 * i;
    DirBut[b].left := 33 + 25 * j;
    DirBut[b].height := 25;
    DirBut[b].width := 25;
    DirBut[b].OnClick := DirBut[b].DirButClick;
    DirBut[b].parent := frmDodgeRoll;
    b := b + 1;
  end;
end;

procedure MakeDodgeReroll;
begin
  if WorkOutDodgeResult(1) then begin
    PlacePlayer(f0, g0,
       allPlayers[g0,f0].p + DirBut[db].dx, allPlayers[g0,f0].q + DirBut[db].dy);
    frmDodgeRoll.Hide;
    if (allPlayers[g0,f0].p = ball.p) and (allPlayers[g0,f0].q = ball.q) then begin
      Continuing := true;
      allPlayers[g0,f0].SetStatus(2);
      Continuing := false;
      ShowPickUpWindow(g0, f0);
    end;
  end else begin
    frmDodgeRoll.butUseDodgeSkill.enabled := false;
    frmDodgeRoll.butPro.enabled := false;
    frmDodgeRoll.butUseTeamReroll.enabled := false;
    frmDodgeRoll.lblDodgeRerollFailed.visible := true;
  end;
end;

procedure TfrmDodgeRoll.butUseTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  {right-click on reroll marker}
  UReroll := UseTeamReroll;
  if UReroll then MakeDodgeReroll else begin
    frmDodgeRoll.butUseDodgeSkill.enabled := false;
    frmDodgeRoll.butPro.enabled := false;
    frmDodgeRoll.butUseTeamReroll.enabled := false;
    frmDodgeRoll.lblDodgeRerollFailed.visible := true;
  end;
end;

procedure TfrmDodgeRoll.butMakeGFIRollClick(Sender: TObject);
begin
  ShowGFIWindow(TeamPlayer, NumberPlayer);
  MakeGFIRoll.Enabled := False;
  if (allPlayers[teamplayer, numberplayer].status < 1) or
    (allPlayers[teamplayer, numberplayer].status > 2) then begin
    DodgeNoStand := true;
    PlacePlayer(NumberPlayer, TeamPlayer,
      allPlayers[TeamPlayer,NumberPlayer].p + DirBut[db].dx,
      allPlayers[TeamPlayer,NumberPlayer].q + DirBut[db].dy);
    DodgeNoStand := false;
    frmDodgeRoll.Hide;
    if (allPlayers[TeamPlayer,NumberPlayer].p = ball.p) and
      (allPlayers[TeamPlayer,NumberPlayer].q = ball.q) then begin
      ScatterBallFrom(allPlayers[TeamPlayer, NumberPlayer].p,
                   allPlayers[TeamPlayer, NumberPlayer].q, 1, 0);
    end;
  end;
end;

procedure TfrmDodgeRoll.butProClick(Sender: TObject);
begin
  allPlayers[g0,f0].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(g0,f0);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeDodgeReroll;
  end else begin
    frmDodgeRoll.butPro.enabled := false;
    frmDodgeRoll.butUseDodgeSkill.enabled := false;
    frmDodgeRoll.butUseTeamReroll.enabled := false;
    Show;
  end;
end;

procedure TfrmDodgeRoll.butUseDodgeSkillClick(Sender: TObject);
begin
  allPlayers[g0,f0].UseSkill('Dodge');
  MakeDodgeReroll;
end;

procedure TfrmDodgeRoll.butUseStandFirmSkillClick(Sender: TObject);
var s: string;
begin
  allPlayers[g0,f0].UseSkill('Stand Firm');
{  player[g0,f0].MakeCurrent;}
  if allPlayers[g0,f0].UsedMA = 0 then begin
    s := 'x' + Chr(g0 + 48) + Chr(f0 + 65) + Chr(allPlayers[g0,f0].UsedMA + 64);
    LogWrite(s);
    PlayActionEndOfMove(s, 1);
  end;
{  player[g0,f0].MakeCurrent;}
  frmDodgeRoll.Hide;
end;

procedure TfrmDodgeRoll.butKnockOverClick(Sender: TObject);
var v, w, ploc, qloc: integer;
    ballscatter: boolean;
begin
  frmDodgeRoll.Hide;
  PlacePlayer(f0, g0,
     allPlayers[g0,f0].p + DirBut[db].dx, allPlayers[g0,f0].q + DirBut[db].dy);
  Ballscatter := false;
  v := g0;
  w := f0;
  if (ball.p = allPlayers[g0,f0].p) and
    (ball.q = allPlayers[g0,f0].q) then begin
    BallScatter := true;
    ploc := ball.p;
    qloc := ball.q;
  end;
  ArmourSettings(v,w,v,w,0);
  if allPlayers[v,w].status < InjuryStatus then begin
    if allPlayers[v,w].status=2 then begin
      ploc := allPlayers[v,w].p;
      qloc := allPlayers[v,w].q;
      allPlayers[v,w].SetStatus(InjuryStatus);
      BallScatter := true;
    end else allPlayers[v,w].SetStatus(InjuryStatus);
  end;
  InjuryStatus := 0;
  if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
end;

end.
