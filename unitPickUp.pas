unit unitPickUp;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmPickUp = class(TForm)
    lblPlayer: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    cbBigHand: TCheckBox;
    butPickUpRoll: TButton;
    butsureHandsSkill: TButton;
    butTeamReroll: TButton;
    butBounce: TButton;
    cbPouringRain: TCheckBox;
    txtPlayerAG: TEdit;
    txtPlayerTZ: TEdit;
    txtPickUpRollNeeded: TEdit;
    gbPickUp: TGroupBox;
    cbBigGuyAlly: TCheckBox;
    cbNBH: TCheckBox;
    cbAutoScatter: TCheckBox;
    butPro: TButton;
    butGFI: TButton;
    procedure BigHandClick(Sender: TObject);
    procedure NewSkillClick(Sender: TObject);
    procedure butPickUpRollClick(Sender: TObject);
    procedure butGFIRollClick(Sender: TObject);
    procedure butSureHandsSkillClick(Sender: TObject);
    procedure butProClick(Sender: TObject);
    procedure butTeamRerollClick(Sender: TObject);
    procedure butBounceClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbPouringRainClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPickUp: TfrmPickUp;

procedure ShowPickUpWindow(g, f: integer);

implementation

uses bbunit, bbalg, unitPlayer, unitMarker, unitBall, unitLog, unitPass,
     unitTeam, unitGFI, unitSettings;

{$R *.DFM}

var TeamPlayer, NumberPlayer, PickUpRollNeeded: integer;
    CanHide: boolean;

procedure CalculatePickUpRollNeeded;
var r: integer;
begin
  r := 6 - player[TeamPlayer, NumberPlayer].ag;
  if frmPickUp.cbPouringRain.checked then r := r + 1;

  r := r + FVal(frmPickUp.txtPlayerTZ.text);
  if frmPickUp.cbBigHand.checked then r := 2;
  if r < 2 then r := 2;
  if r > 6 then r := 6;
  if frmPickUp.cbNBH.checked then r := 7;
  if frmPickUp.cbAutoScatter.checked then r := 7;
  PickUpRollNeeded := r;

  frmPickUp.txtPickUpRollNeeded.text := IntToStr(r) + '+';
end;

procedure ShowPickUpWindow(g, f: integer);
var tz: TackleZones;
begin
  TeamPlayer := g;
  NumberPlayer := f;
  frmPickUp.lblPlayer.caption := player[g,f].GetPlayerName;
  frmPickUp.lblPlayer.font.color := colorarray[g,0,0];
  frmPickUp.txtPlayerAG.text := IntToStr(player[g,f].ag);
  tz := CountTZ(g, f);
  frmPickUp.txtPlayerTZ.text := IntToStr(tz.num);
  frmPickUp.cbBigHand.checked := player[g,f].hasSkill('Big Hand');

  frmPickUp.cbPouringRain.checked :=
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 12)) = 'POURING RAIN')
     and not (player[g,f].hasSkill('Weather Immunity')) OR
    (UpperCase(Copy(Bloodbowl.WeatherLabel.caption, 1, 10)) = 'EERIE MIST')
     and not (player[g,f].hasSkill('Weather Immunity'));

  frmPickUp.cbNBH.checked := player[g,f].hasSkill('Nonball Handler');
  frmPickUp.cbBigGuyAlly.checked := (((player[g,f].BigGuy) or
      (player[g,f].Ally)) and (true));   // big guy

  CalculatePickUpRollNeeded;

  frmPickUp.butGFI.Enabled := true;
  frmPickUp.butPickUpRoll.enabled := true;
  frmPickUp.height := 338;
  try
    frmPickUp.ShowModal;
  except
    on EInvalidOperation do CanHide := false;
  end;
end;

function WorkOutPickUpResult(i: integer): boolean;
begin
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll >= PickUpRollNeeded then begin
    player[TeamPlayer, NumberPlayer].SetStatus(2);
    WorkOutPickUpResult := true;
  end else begin
    if i = 0 then Bloodbowl.comment.text := 'PickUp roll failed!'
             else Bloodbowl.comment.text := 'PickUp RE-ROLL failed!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    WorkOutPickUpResult := false;
  end;
end;

procedure TfrmPickUp.BigHandClick(Sender: TObject);
begin
  CalculatePickUpRollNeeded;
end;

procedure TfrmPickUp.NewSkillClick(Sender: TObject);
begin
  CalculatePickUpRollNeeded;
end;

procedure TfrmPickUp.butPickUpRollClick(Sender: TObject);
var s: string;
begin
  butGFI.Enabled := False;
  if cbAutoScatter.checked then begin
     s := 'Ball scatters off of ' +
        player[TeamPlayer, NumberPlayer].GetPlayerName;
  end else begin
    s := player[TeamPlayer, NumberPlayer].GetPlayerName +
         ' tries to pick up the ball (';
    if cbBigHand.checked then s := s + 'Big Hand, ' else begin
      if txtPlayerTZ.Text <> '0' then s := s + txtPlayerTZ.text + ' TZ, ';
      if cbPouringRain.checked then s := s + 'Pouring Rain, ';

    end;
    s := s + txtPickUpRollNeeded.text + ')';
  end;
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);

  butPickUpRoll.enabled := false;
  if cbAutoScatter.checked then begin
    cbAutoScatter.checked := false;
    CanHide := true;
    ScatterBallFrom(player[TeamPlayer, NumberPlayer].p,
                  player[TeamPlayer, NumberPlayer].q, 1, 0);
    if CanHide then begin
      ModalResult := 1;
      Hide;
    end;
  end else if WorkOutPickUpResult(0) then begin
    ModalResult := 1;
    Hide;
  end else begin
    butSureHandsSkill.enabled :=
       player[TeamPlayer, NumberPlayer].hasSkill('Sure Hands');
    butPro.enabled :=
       player[TeamPlayer, NumberPlayer].hasSkill('Pro') and
       not(player[TeamPlayer,NumberPlayer].usedSkill('Pro'));
    butTeamReroll.enabled := false;
    if (TeamPlayer = curmove) and CanUseTeamReroll(cbBigGuyAlly.checked)
      then butTeamReroll.enabled := true;
    height := 463;
  end;
end;

procedure MakePickUpReroll;
begin
  if WorkOutPickUpResult(1) then begin
    frmPickUp.ModalResult := 1;
    frmPickUp.Hide;
  end else begin
    frmPickUp.butSureHandsSkill.enabled := false;
    frmPickUp.butTeamReroll.enabled := false;
    frmPickUp.butPro.enabled := false;
  end;
end;

procedure TfrmPickUp.butSureHandsSkillClick(Sender: TObject);
begin
  player[TeamPlayer,NumberPlayer].UseSkill('Sure Hands');
  MakePickUpReroll;
end;

procedure TfrmPickUp.butProClick(Sender: TObject);
begin
  player[TeamPlayer,NumberPlayer].UseSkill('Pro');
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll <= 3 then TeamRerollPro(TeamPlayer,NumberPlayer);
  if (lastroll >= 4) then begin
    Bloodbowl.comment.text := 'Pro reroll';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    MakePickUpReroll;
  end else begin
    frmPickUp.butPro.enabled := false;
    frmPickUp.butSureHandsSkill.enabled := false;
    frmPickUp.butTeamReroll.enabled := false;
  end;
end;

procedure TfrmPickUp.butTeamRerollClick(Sender: TObject);
var UReroll: boolean;
begin
  UReroll := UseTeamReroll;
  if UReroll then MakePickUpReroll else begin
    frmPickUp.butSureHandsSkill.enabled := false;
    frmPickUp.butTeamReroll.enabled := false;
    frmPickUp.butPro.enabled := false;
  end;
end;

procedure TfrmPickUp.butGFIRollClick(Sender: TObject);
begin
  ShowGFIWindow(TeamPlayer, NumberPlayer);
  butGFI.Enabled := False;
  if (player[teamplayer, numberplayer].status < 1) or
     (player[teamplayer, numberplayer].status > 2) then begin
    CanHide := true;
    if CanHide then begin
      ModalResult := 1;
      Hide;
    end;
  end;
end;

procedure TfrmPickUp.butBounceClick(Sender: TObject);
begin
  CanHide := true;
  ScatterBallFrom(player[TeamPlayer, NumberPlayer].p,
                  player[TeamPlayer, NumberPlayer].q, 1, 0);
  if CanHide then begin
    ModalResult := 1;
    Hide;
  end;
end;

procedure TfrmPickUp.FormCreate(Sender: TObject);
begin
  CanHide := true;
end;

procedure TfrmPickUp.cbPouringRainClick(Sender: TObject);
begin
  CalculatePickUpRollNeeded;
end;

end.
