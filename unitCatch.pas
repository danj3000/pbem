unit unitCatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmCatch = class(TForm)
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
    cbETrunk: TCheckBox;
    cbHFHead: TCheckBox;
    cbPerfectSpiral: TCheckBox;
    cbVeryLongLegs: TCheckBox;
    cbNBH: TCheckBox;
    cbFragile: TCheckBox;
    cbSafeThrow: TCheckBox;
    butPro: TButton;
    cbButterfingers: TCheckBox;
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
  frmCatch: TfrmCatch;

procedure ShowCatchWindow(g, f, acc: integer; pspiral, sthrow: boolean);

implementation

uses bbunit, bbalg, unitPlayer, unitTeam, unitMarker, unitBall, unitLog, unitPass,
  unitSettings;

{$R *.DFM}

var TeamCatcher, NumberCatcher, CatchRollNeeded: integer;
    CanHide: boolean;

procedure CalculateCatchRollNeeded;
var r: integer;
begin
  if frmCatch.rgAccPassBB.ItemIndex = 2 then begin
     frmCatch.cbVeryLongLegs.visible := true;
     frmCatch.cbExtraArms.Visible := false;
  end else begin
     frmCatch.cbVeryLongLegs.visible := false;
     frmCatch.cbExtraArms.visible := true;
  end;
  r := 7 - player[TeamCatcher, NumberCatcher].ag;
  if frmCatch.rgAccPassBB.ItemIndex = 0 then r := r - 1;
  if frmCatch.rgAccPassBB.ItemIndex = 2 then r := r + 2;
  if frmCatch.cbPerfectSpiral.checked then r := r - 1;
  if (frmCatch.cbExtraArms.checked) and (not(frmCatch.rgAccPassBB.ItemIndex=2))
     then r := r - 1;
  if (frmCatch.cbVeryLongLegs.checked) and (frmCatch.rgAccPassBB.ItemIndex = 2)
     then r := r - 1;
  if frmCatch.cbETrunk.checked then r := r - 1;
  if frmCatch.cbHFHead.checked then r := r + 2;
  if frmCatch.cbButterfingers.checked then r := r + 1;
  if not(frmCatch.cbNervesOfSteel.checked) then
    r := r + FVal(frmCatch.txtCatcherTZ.text);
  r := r + FVal(frmCatch.txtCatcherFA.text);
  if (frmCatch.cbPouringRain.checked) then r := r + 1;
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  if (frmCatch.cbNBH.checked) then r := 7;
  if (frmCatch.cbNoTZ.checked) then r := 7;

  CatchRollNeeded := r;

  frmCatch.txtCatchRollNeeded.text := IntToStr(r) + '+';
end;

procedure ShowCatchWindow(g, f, acc: integer; pspiral, sthrow: boolean);
var tz: TackleZones;
begin
  TeamCatcher := g;
  NumberCatcher := f;
  frmCatch.lblCatcher.caption := player[g,f].GetPlayerName;
  frmCatch.lblCatcher.font.color := colorarray[g,0,0];
  if acc=1 then frmCatch.rgAccPassBB.ItemIndex := 0
    else if acc=0 then frmCatch.rgAccPassBB.ItemIndex := 1 else
    frmCatch.rgAccPassBB.ItemIndex := 2;
  frmCatch.txtCatcherAG.text := IntToStr(player[g,f].ag);
  tz := CountTZ(g, f);
  frmCatch.txtCatcherTZ.text := IntToStr(tz.num);
  frmCatch.txtCatcherFA.text := IntToStr(CountFA(g, f));
  frmCatch.cbExtraArms.checked := player[g,f].hasSkill('Extra Arms');
  frmCatch.cbNBH.checked := player[g,f].hasSkill('Nonball Handler');
  frmCatch.cbNoTZ.checked := (player[g,f].tz > 0) and
    (not(frmSettings.cbNoTZAssist.checked));
  frmCatch.cbNervesOfSteel.checked := player[g,f].hasSkill('Nerves of Steel');
  frmCatch.cbETrunk.visible := frmSettings.cbElephantTrunk.checked or
    frmSettings.cbBless.checked;
  frmCatch.cbETrunk.checked := ((player[g,f].hasSkill('Elephant Trunk')) and
     (frmSettings.cbElephantTrunk.checked)) or
     ((player[g,f].hasSkill('Bless')) and
     (frmSettings.cbBless.checked));
  frmCatch.cbHFHead.visible := frmSettings.cbHouseFlyHead.checked;
  frmCatch.cbHFHead.checked := (player[g,f].hasSkill('House Fly Head')) and
     (frmSettings.cbHouseFlyHead.checked);
  frmCatch.cbButterfingers.visible := frmSettings.cbButterfingers.checked;
  frmCatch.cbButterfingers.checked := (player[g,f].hasSkill('Butterfingers')) and
     (frmSettings.cbButterfingers.checked);
  frmCatch.cbPerfectSpiral.visible := frmSettings.cbPerfectSpiral.checked;
  frmCatch.cbPerfectSpiral.checked := (pspiral) and
     (frmSettings.cbPerfectSpiral.checked);
  frmCatch.cbSafeThrow.Checked := sthrow;
  frmCatch.cbFragile.visible := frmSettings.cbFragile.checked;
  frmCatch.cbFragile.checked := (player[g,f].hasSkill('Fragile')) and
     (frmSettings.cbFragile.checked);
  frmCatch.cbVeryLongLegs.visible := false;
  frmCatch.cbVeryLongLegs.checked := (player[g,f].hasSkill('Very Long Legs'));
  frmCatch.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (frmSettings.rgBGA4th.ItemIndex >= 1));
  frmCatch.cbPouringRain.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) = 'POURING RAIN')
     and not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) = 'EERIE MIST')
     and not (player[g,f].hasSkill('Weather Immunity'));

  CalculateCatchRollNeeded;

  frmCatch.butCatchRoll.enabled := true;
  frmCatch.height := 450;
  try
    frmCatch.ShowModal;
  except
    on EInvalidOperation do CanHide := false;
  end;
end;

function WorkOutCatchResult(i: integer): boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll >= CatchRollNeeded then begin
    if (frmCatch.rgAccPassBB.ItemIndex = 2) and (frmCatch.cbSafeThrow.checked)
    then begin
      player[ActionTeam,ActionPlayer].UseSkill('Safe Throw');
      Bloodbowl.comment.text := 'Safe Throw roll';
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if ((player[ActionTeam,ActionPlayer].HasSkill('Pro')) and (lastroll <= 1) and
        (not (player[ActionTeam,ActionPlayer].usedSkill('Pro'))) and
        (ActionTeam = curmove)) then begin
            player[ActionTeam,ActionPlayer].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
            if (lastroll <= 3) then lastroll := 1;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            end;
         end;
      if lastroll = 1 then begin
        Bloodbowl.comment.text := 'Safe Throw failed!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        if CanWriteToLog then begin
          player[TeamCatcher, NumberCatcher].int :=
            player[TeamCatcher, NumberCatcher].int + 1;
          LogWrite('p' + Chr(TeamCatcher + 48) + chr(NumberCatcher + 65) + 'I');
          AddLog('Interception for ' +
            player[TeamCatcher, NumberCatcher].GetPlayerName);
        end;
        player[TeamCatcher, NumberCatcher].SetStatus(2);
        if (AccurateTeam=TeamCatcher) and (AccuratePassPlay) and
          (AccuratePlayer<>NumberCatcher) then begin
          player[AccurateTeam, AccuratePlayer].comp :=
            player[AccurateTeam, AccuratePlayer].comp + 1;
          LogWrite('p' + Chr(AccurateTeam + 48) + chr(AccuratePlayer + 65) + 'c');
          AddLog('Completion for ' +
            player[AccurateTeam, AccuratePlayer].GetPlayerName);
          AccuratePassPlay := false;
        end;
        WorkOutCatchResult := true;
      end else begin
        Bloodbowl.comment.text := 'Safe Throw stops the interception!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
      WorkOutCatchResult := true;
    end else begin
      if frmCatch.cbNBH.checked then begin
          AddLog('Nonball Handler ' +
              (player[TeamCatcher, NumberCatcher].GetPlayerName) + ' bats it out'+
              ' of the air');
          ScatterBallFrom(player[TeamCatcher, NumberCatcher].p,
            player[TeamCatcher, NumberCatcher].q, 1, 0);
          WorkOutCatchResult := true;
      end else begin
        player[TeamCatcher, NumberCatcher].SetStatus(2);
        if (AccurateTeam=TeamCatcher) and (AccuratePassPlay) and
          (AccuratePlayer<>NumberCatcher) then begin
          player[AccurateTeam, AccuratePlayer].comp :=
            player[AccurateTeam, AccuratePlayer].comp + 1;
          LogWrite('p' + Chr(AccurateTeam + 48) + chr(AccuratePlayer + 65) + 'c');
          AddLog('Completion for ' +
            player[AccurateTeam, AccuratePlayer].GetPlayerName);
          AccuratePassPlay := False;
        end;
        WorkOutCatchResult := true;
        if frmCatch.rgAccPassBB.ItemIndex = 2 then begin
          if CanWriteToLog then begin
               player[TeamCatcher, NumberCatcher].int :=
                 player[TeamCatcher, NumberCatcher].int + 1;
               LogWrite('p' + Chr(TeamCatcher + 48) + chr(NumberCatcher + 65) + 'I');
               AddLog('Interception for ' +
                 player[TeamCatcher, NumberCatcher].GetPlayerName);
               WorkOutCatchResult := true;
          end;
        end;
      end;
    end;
  end else begin
    WorkOutCatchResult := false;
    if (i = 0)  and (frmCatch.rgAccPassBB.ItemIndex < 2)
        then Bloodbowl.comment.text := 'Catch roll failed!'
        else if (i <> 0) and (frmCatch.rgAccPassBB.ItemIndex < 2) then
          Bloodbowl.comment.text := 'Catch RE-ROLL failed!'
        else if (i = 0) and (frmCatch.rgAccPassBB.ItemIndex = 2) then begin
          Bloodbowl.comment.text := 'Interception roll failed!';
          if not (player[TeamCatcher, NumberCatcher].hasSkill('Catch'))
             then WorkOutCatchResult := true;
        end else begin
          Bloodbowl.comment.text := 'Interception RE-ROLL failed!';
          WorkOutCatchResult := true;
        end;
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;
end;

procedure TfrmCatch.rgAccPassBBClick(Sender: TObject);
begin
  CalculateCatchRollNeeded;
end;

procedure TfrmCatch.CatchSkillClick(Sender: TObject);
begin
  CalculateCatchRollNeeded;
end;

procedure TfrmCatch.butCatchRollClick(Sender: TObject);
var s: string;
begin
  s := player[TeamCatcher, NumberCatcher].GetPlayerName +
       ' tries to catch the ball (';
  if rgAccPassBB.ItemIndex = 0 then s := s + 'Accurate Pass, '
          else
          if rgAccPassBB.ItemIndex = 1 then s := s + 'Bouncing Ball, ' else
          s := s + 'Interception, ';
  if cbPerfectSpiral.checked then s := s + 'Perfect Spiral, ';
  if (cbVeryLongLegs.checked) and (frmCatch.rgAccPassBB.ItemIndex = 2)
       then s := s + 'Very Long Legs, ';
  if cbExtraArms.checked then s := s + 'Extra Arms, ';
  if cbETrunk.checked then s := s + 'Elephant Trunk, ';
  if cbHFHead.checked then s := s + 'House Fly Head, ';
  if cbButterfingers.checked then s := s + 'Butterfingers, ';
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
  end else begin
    butCatchSkill.enabled :=
       player[TeamCatcher, NumberCatcher].hasSkill('Catch') and
       not(player[TeamCatcher,NumberCatcher].usedSkill('Catch'));
    butPro.enabled :=
       player[TeamCatcher, NumberCatcher].hasSkill('Pro') and
       not(player[TeamCatcher,NumberCatcher].usedSkill('Pro'));
    butTeamReroll.enabled := false;
    if (TeamCatcher = curmove) and CanUseTeamReroll(cbBigGuyAlly.checked)
      and (not(KickOffNow)) then butTeamReroll.enabled := true;
    height := 570;
    frmCatch.butBounce.enabled := true;
    if rgAccPassBB.ItemIndex = 2 then frmCatch.butBounce.enabled := false;
  end;
end;

procedure MakeCatchReroll;
begin
  if WorkOutCatchResult(1) then begin
    frmCatch.ModalResult := 1;
    frmCatch.Hide;
  end else begin
    frmCatch.butCatchSkill.enabled := false;
    frmCatch.butTeamReroll.enabled := false;
    frmCatch.butPro.enabled := false;
  end;
end;

procedure TfrmCatch.butCatchSkillClick(Sender: TObject);
begin
  player[TeamCatcher,NumberCatcher].UseSkill('Catch');
  MakeCatchReroll;
end;

procedure TfrmCatch.butProClick(Sender: TObject);
begin
  player[TeamCatcher,NumberCatcher].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamCatcher,NumberCatcher);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakeCatchReroll;
  end else begin
    frmCatch.butPro.enabled := false;
    frmCatch.butCatchSkill.enabled := false;
    frmCatch.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmCatch.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakeCatchReroll else begin
    frmCatch.butCatchSkill.enabled := false;
    frmCatch.butTeamReroll.enabled := false;
    frmCatch.butPro.enabled := false;
  end;
end;

procedure TfrmCatch.butBounceClick(Sender: TObject);

begin
  CanHide := true;
  if frmCatch.cbFragile.checked then
     player[TeamCatcher,NumberCatcher].SetStatus(4);
  {Stop HEre}
  ScatterBallFrom(player[TeamCatcher, NumberCatcher].p,
                  player[TeamCatcher, NumberCatcher].q, 1, 0);
  if CanHide then begin
    ModalResult := 1;
    Hide;
  end;
end;

procedure TfrmCatch.FormCreate(Sender: TObject);
begin
  CanHide := true;
end;

procedure TfrmCatch.cbPouringRainClick(Sender: TObject);

begin
  CalculateCatchRollNeeded;
end;

end.