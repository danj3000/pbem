unit unitCatchStuff;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmCatchStuff = class(TForm)
    lblCatcher: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    txtCatcherTZ: TEdit;
    txtCatcherAG: TEdit;
    gbPass: TGroupBox;
    cbExtraArms: TCheckBox;
    cbNervesOfSteel: TCheckBox;
    rgAccPassBB: TRadioGroup;
    lblPassFailed: TLabel;
    Label7: TLabel;
    butCatchRoll: TButton;
    butCatchSkill: TButton;
    butTeamReroll: TButton;
    butBounce: TButton;
    txtCatchRollNeeded: TEdit;
    cbPouringRain: TCheckBox;
    Label1: TLabel;
    txtCatcherFA: TEdit;
    cbBigGuyAlly: TCheckBox;
    cbNBH: TCheckBox;
    cbSafeThrow: TCheckBox;
    butPro: TButton;
    cbNoTZ: TCheckBox;
    procedure rgAccPassBBClick(Sender: TObject);
    procedure CatchSkillClick(Sender: TObject);
    procedure butCatchRollClick(Sender: TObject);
    procedure butCatchSkillClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butProClick(Sender: TObject);
    procedure butBounceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbPouringRainClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCatchStuff: TfrmCatchStuff;

procedure ShowCatchStuffWindow(g, f, acc, StuffType: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitTeam, unitMarker, unitBall, unitLog,
  unitSettings, unitThrowStuff;

{$R *.DFM}

var TeamCatcher, NumberCatcher, CatchRollNeeded, ThrowStuff: integer;
    CanHide: boolean;
    TheThing: string;

procedure CalculateCatchRollNeeded;
var r: integer;
begin
  r := 7 - player[TeamCatcher, NumberCatcher].ag;
  if frmCatchStuff.rgAccPassBB.ItemIndex = 0 then r := r - 1;
  if frmCatchStuff.cbExtraArms.checked then r := r - 1;

  if not(frmCatchStuff.cbNervesOfSteel.checked) then
    r := r + FVal(frmCatchStuff.txtCatcherTZ.text);
  r := r + FVal(frmCatchStuff.txtCatcherFA.text);
  if (frmCatchStuff.cbPouringRain.checked) then r := r + 1;
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  if (frmCatchStuff.cbNBH.checked) then r := 7;
  if (frmCatchStuff.cbNoTZ.checked) then r := 7;

  CatchRollNeeded := r;

  frmCatchStuff.txtCatchRollNeeded.text := IntToStr(r) + '+';
end;

procedure BlowUpBomb;
var BallScatter, Whiff: boolean;
    t, u, v, w, pplace, qplace, ploc, qloc, BombDist: integer;
begin
  pplace := StuffP;
  qplace := StuffQ;
  LogWrite('e' + Chr(47) + Chr(63) + Chr(BombTeam+48) + Chr(BombPlayer+64));
  BombTeam := -1;
  BombPlayer := -1;
  BallScatter := false;
  Whiff := true;
  if ThrowStuff = 1 then begin
    for t := 1 to 3 do begin
      for u := 1 to 3 do begin
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = pplace + (t-2)) and (player[v,w].q = qplace + (u-2))
              then begin
                Whiff := false;
                if (t=2) and (u=2) then begin
                  Bloodbowl.comment.Text := 'Bomb blast HITS #' +
                    player[v,w].GetPlayerName;
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                  ArmourSettings(v,w,v,w,0);
                  if player[v,w].status < InjuryStatus then begin
                    if player[v,w].status=2 then begin
                      ploc := player[v,w].p;
                      qloc := player[v,w].q;
                      player[v,w].SetStatus(InjuryStatus);
                      BallScatter := true;
                    end else player[v,w].SetStatus(InjuryStatus);
                  end;
                  InjuryStatus := 0;
                end else begin
                  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                  if lastroll > 3 then begin
                     Bloodbowl.comment.Text := 'Bomb blast HITS #' +
                       player[v,w].GetPlayerName;
                     Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                     ArmourSettings(v,w,v,w,0);
                     if player[v,w].status < InjuryStatus then begin
                       if player[v,w].status=2 then begin
                         ploc := player[v,w].p;
                         qloc := player[v,w].q;
                         player[v,w].SetStatus(InjuryStatus);
                         BallScatter := true;
                       end else player[v,w].SetStatus(InjuryStatus);
                     end;
                     InjuryStatus := 0;
                  end else begin
                    Bloodbowl.comment.Text := 'Bomb blast misses #' +
                      player[v,w].GetPlayerName;
                    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                  end;
                end;
            end;
          end;
        end;
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else if ThrowStuff=2 then begin
    for t := 1 to 3 do begin
      for u := 1 to 3 do begin
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = pplace + (t-2)) and (player[v,w].q = qplace + (u-2))
            then begin
              Whiff := false;
              Bloodbowl.comment.Text := 'Stink Bomb blast HITS #' +
                player[v,w].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              InjuryStatus := 3;
              if player[v,w].status < InjuryStatus then begin
                if player[v,w].status=2 then begin
                  ploc := player[v,w].p;
                  qloc := player[v,w].q;
                  player[v,w].SetStatus(InjuryStatus);
                  BallScatter := true;
                end else player[v,w].SetStatus(InjuryStatus);
              end;
              InjuryStatus := 0;
            end;
          end;
        end;
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else if ThrowStuff=3 then begin
    for v := 0 to 1 do begin
      for w := 1 to team[v].numplayers do begin
        Bombdist := RangeRulerRange(player[v,w].p, player[v,w].q,
          pplace,qplace);
        if Bombdist = 0 then begin
          Whiff := false;
          if (player[v,w].p = StuffP) and (player[v,w].q = StuffQ) then begin
            Bloodbowl.comment.Text := 'Big Bomb blast HITS #' +
              player[v,w].GetPlayerName;
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            ArmourSettings(v,w,v,w,0);
            if player[v,w].status < InjuryStatus then begin
              if player[v,w].status=2 then begin
                ploc := player[v,w].p;
                qloc := player[v,w].q;
                player[v,w].SetStatus(InjuryStatus);
                BallScatter := true;
              end else player[v,w].SetStatus(InjuryStatus);
            end;
            InjuryStatus := 0;
          end else begin
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll > 3 then begin
              Bloodbowl.comment.Text := 'Big Bomb blast HITS #' +
                player[v,w].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              ArmourSettings(v,w,v,w,0);
              if player[v,w].status < InjuryStatus then begin
                if player[v,w].status=2 then begin
                  ploc := player[v,w].p;
                  qloc := player[v,w].q;
                  player[v,w].SetStatus(InjuryStatus);
                  BallScatter := true;
                end else player[v,w].SetStatus(InjuryStatus);
              end;
              InjuryStatus := 0;
            end else begin
              Bloodbowl.comment.Text := 'Big Bomb blast misses #' +
                player[v,w].GetPlayerName;
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            end;
          end;
        end;
        if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
      end;
    end;
    Bloodbowl.comment.Text := 'Player originally throwing the Big Bomb is ' +
      'ejected and this call cannot be argued!  Please Send Off the player!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
  if Whiff then begin
    Bloodbowl.comment.Text := TheThing + ' misses everybody!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
end;

procedure ShowCatchStuffWindow(g, f, acc, stufftype: integer);
var tz: TackleZones;
begin
  ThrowStuff := StuffType;
  if StuffType = 1 then TheThing := 'Bomb' else
    if StuffType = 2 then TheThing := 'Stink Bomb' else
    if StuffType = 3 then TheThing := 'BIG Bomb' else TheThing := 'Net';
  TeamCatcher := g;
  NumberCatcher := f;
  frmCatchStuff.lblCatcher.caption := player[g,f].GetPlayerName;
  frmCatchStuff.lblCatcher.font.color := colorarray[g,0,0];
  if acc=1 then frmCatchStuff.rgAccPassBB.ItemIndex := 0
    else if acc=0 then frmCatchStuff.rgAccPassBB.ItemIndex := 1;
  frmCatchStuff.txtCatcherAG.text := IntToStr(player[g,f].ag);
  tz := CountTZ(g, f);
  frmCatchStuff.txtCatcherTZ.text := IntToStr(tz.num);
  frmCatchStuff.txtCatcherFA.text := IntToStr(CountFA(g, f));
  frmCatchStuff.cbExtraArms.checked := player[g,f].hasSkill('Extra Arms');
  frmCatchStuff.cbNBH.checked := player[g,f].hasSkill('Nonball Handler');
  frmCatchStuff.cbNoTZ.checked := (player[g,f].tz > 0) ;
  frmCatchStuff.cbNervesOfSteel.checked := player[g,f].hasSkill('Nerves of Steel');

  frmCatchStuff.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (true)); // big guy
  frmCatchStuff.cbPouringRain.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) = 'POURING RAIN')
     and not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) = 'EERIE MIST')
     and not (player[g,f].hasSkill('Weather Immunity'));

  CalculateCatchRollNeeded;

  frmCatchStuff.butCatchRoll.enabled := true;
  frmCatchStuff.height := 450;
  try
    frmCatchStuff.ShowModal;
  except
    on EInvalidOperation do CanHide := false;
  end;
end;

function WorkOutCatchResult(i: integer): boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll >= CatchRollNeeded then begin
    WorkOutCatchResult := true;
  end else begin
    WorkOutCatchResult := false;
    if (i = 0)  and (frmCatchStuff.rgAccPassBB.ItemIndex < 2)
        then Bloodbowl.comment.text := 'Catch roll failed!'
        else if (i <> 0) and (frmCatchStuff.rgAccPassBB.ItemIndex < 2) then
          Bloodbowl.comment.text := 'Catch RE-ROLL failed!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
end;

procedure TfrmCatchStuff.rgAccPassBBClick(Sender: TObject);
begin
  CalculateCatchRollNeeded;
end;

procedure TfrmCatchStuff.CatchSkillClick(Sender: TObject);
begin
  CalculateCatchRollNeeded;
end;

procedure TfrmCatchStuff.butCatchRollClick(Sender: TObject);
var s: string;
begin
  s := player[TeamCatcher, NumberCatcher].GetPlayerName +
       ' tries to catch the bomb (';
  if rgAccPassBB.ItemIndex = 0 then s := s + 'Accurate Pass, '
          else
          if rgAccPassBB.ItemIndex = 1 then s := s + 'Bouncing Bomb, ';
  if cbExtraArms.checked then s := s + 'Extra Arms, ';

  if cbNervesOfSteel.checked then s := s + 'Nerves of Steel, ';
  if txtCatcherTZ.Text <> '0' then s := s + txtCatcherTZ.text + ' TZ, ';
  if cbPouringRain.checked then s := s + 'Pouring Rain, ';
  s := s + txtCatchRollNeeded.text + ')';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);

  butCatchRoll.enabled := false;
  if WorkOutCatchResult(0) then begin
    ModalResult := 1;
    Hide;
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    if lastroll<=3 then begin
      Bloodbowl.comment.Text := player[TeamCatcher, NumberCatcher].GetPlayerName
        + ' catches the '+TheThing+' only to have it explode in their hands!!!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      StuffP := player[TeamCatcher,NumberCatcher].p;
      StuffQ := player[TeamCatcher,NumberCatcher].q;
      BlowUpBomb;
    end else begin
      Bloodbowl.comment.Text := player[TeamCatcher, NumberCatcher].GetPlayerName
        + ' has caught the '+TheThing+' and may throw it!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if curmove <> TeamCatcher then begin
        Bloodbowl.comment.Text := 'Send game to opponent to resolve Bomb toss';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      LogWrite('e' + Chr(TeamCatcher+48) + Chr(NumberCatcher+64) +
        Chr(BombTeam+48) + Chr(BombPlayer+64));
      PlayActionBombPlayer('e' + Chr(TeamCatcher+48) + Chr(NumberCatcher+64) +
        Chr(BombTeam+48) + Chr(BombPlayer+64), 1);
    end;
  end else begin
    butCatchSkill.enabled :=
       player[TeamCatcher, NumberCatcher].hasSkill('Catch') and
       not(player[TeamCatcher,NumberCatcher].usedSkill('Catch'));
    butPro.enabled :=
       player[TeamCatcher, NumberCatcher].hasSkill('Pro') and
       not(player[TeamCatcher,NumberCatcher].usedSkill('Pro'));
    butTeamReroll.enabled := false;
    if (TeamCatcher = curmove) and CanUseTeamReroll(cbBigGuyAlly.checked)
      then butTeamReroll.enabled := true;
    height := 570;
    frmCatchStuff.butBounce.enabled := true;
  end;
end;

procedure MakeCatchReroll;
begin
  if WorkOutCatchResult(1) then begin
    frmCatchStuff.ModalResult := 1;
    frmCatchStuff.Hide;
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    if lastroll<=3 then begin
      Bloodbowl.comment.Text := player[TeamCatcher, NumberCatcher].GetPlayerName
        + ' catches the bomb only to have it explode in their hands!!!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      StuffP := player[TeamCatcher,NumberCatcher].p;
      StuffQ := player[TeamCatcher,NumberCatcher].q;
      BlowUpBomb;
    end else begin
      Bloodbowl.comment.Text := player[TeamCatcher, NumberCatcher].GetPlayerName
        + ' has caught the bomb and may throw it!';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      if curmove <> TeamCatcher then begin
        Bloodbowl.comment.Text := 'Send game to opponent to resolve Bomb toss';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      LogWrite('e' + Chr(TeamCatcher+48) + Chr(NumberCatcher+64) +
        Chr(BombTeam+48) + Chr(BombPlayer+64));
      PlayActionBombPlayer('e' + Chr(TeamCatcher+48) + Chr(NumberCatcher+64) +
        Chr(BombTeam+48) + Chr(BombPlayer+64), 1);
    end;
  end else begin
    frmCatchStuff.butCatchSkill.enabled := false;
    frmCatchStuff.butTeamReroll.enabled := false;
    frmCatchStuff.butPro.enabled := false;
  end;
end;

procedure TfrmCatchStuff.butCatchSkillClick(Sender: TObject);
begin
  player[TeamCatcher,NumberCatcher].UseSkill('Catch');
  MakeCatchReroll;
end;

procedure TfrmCatchStuff.butProClick(Sender: TObject);
begin
  player[TeamCatcher,NumberCatcher].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamCatcher,NumberCatcher);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeCatchReroll;
  end else begin
    frmCatchStuff.butPro.enabled := false;
    frmCatchStuff.butCatchSkill.enabled := false;
    frmCatchStuff.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmCatchStuff.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakeCatchReroll else begin
    frmCatchStuff.butCatchSkill.enabled := false;
    frmCatchStuff.butTeamReroll.enabled := false;
    frmCatchStuff.butPro.enabled := false;
  end;
end;

procedure TfrmCatchStuff.butBounceClick(Sender: TObject);

begin
  CanHide := true;
  if CanHide then begin
    ModalResult := 1;
    Hide;
  end;
  StuffP := player[TeamCatcher, NumberCatcher].p;
  StuffQ := player[TeamCatcher, NumberCatcher].q;
  ScatterStuffFrom(Stuffp, Stuffq, 1, 0, TheThing);
  If StuffP = -1 then begin
    Bloodbowl.comment.text :=  TheThing +
      ' lands in the crowd.  No Effect!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end else begin
    BlowUpBomb;
  end;
end;

procedure TfrmCatchStuff.FormCreate(Sender: TObject);
begin
  CanHide := true;
end;

procedure TfrmCatchStuff.cbPouringRainClick(Sender: TObject);

begin
  CalculateCatchRollNeeded;
end;

end.
