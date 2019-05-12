unit unitFoulRoll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmFoulRoll = class(TForm)
    Label1: TLabel;
    GroupBox1: TGroupBox;
    rbClaw: TRadioButton;
    rbMightyBlow: TRadioButton;
    rbFangs: TRadioButton;
    rbDirtyPlayer: TRadioButton;
    DParmmod: TEdit;
    rbNoSkill: TRadioButton;
    txtArmourValue: TEdit;
    butMakeRoll: TButton;
    DPinjmod: TEdit;
    Label2: TLabel;
    txtAssists: TEdit;
    cbWeakPlayer: TCheckBox;
    cbIGMEOY: TCheckBox;
    procedure txtArmourValueChange(Sender: TObject);
    procedure RBClick(Sender: TObject);
    procedure butMakeRollClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFoulRoll: TfrmFoulRoll;

implementation

uses bbunit;

{$R *.DFM}

procedure TfrmFoulRoll.RBClick(Sender: TObject);
begin
  DParmmod.Enabled := rbDirtyPlayer.Checked;
  DPinjmod.Enabled := rbDirtyPlayer.Checked;
end;

procedure TfrmFoulRoll.txtArmourValueChange(Sender: TObject);
var v, c: integer;
begin
  Val(txtArmourValue.text, v, c);
  butMakeRoll.enabled := (v > 0);
end;

procedure TfrmFoulRoll.butMakeRollClick(Sender: TObject);
var s, ix: string;
    a, i, v, c: integer;
begin
  Val(Trim(txtArmourValue.text), v, c);
  Val(Trim(txtAssists.text), a, c);
  a := a + 1;
  i := 0;
  ix := ' +';
  s := '* foul' + IntToStr(v);
  if rbClaw.checked then a := a + 2;
  if rbMightyBlow.checked then begin
    a := a + 1;
    i := 1;
    if MB4th then ix := ' &';
  end;
  if rbFangs.checked then i := 2;
  if rbDirtyPlayer.checked then begin
    Val(Trim(DParmmod.text), v, c);
    a := a + v;
    Val(Trim(DPinjmod.text), v, c);
    i := v;
  end;
  if cbWeakPlayer.checked then i := i + 1;
  s := s + ' +' + IntToStr(a);
  if i > 0 then s := s + ix + IntToStr(i);
  if cbIGMEOY.checked then s := s + ' IGMEOY';
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Sender);
  frmFoulRoll.Hide;
  rbNoSkill.Checked := true;
  cbWeakPlayer.checked := false;
  cbIGMEOY.checked := false;
  txtArmourValue.text := '';
  txtAssists.text := '';
end;

procedure TfrmFoulRoll.FormActivate(Sender: TObject);
begin
  txtArmourValue.SetFocus;
end;

procedure TfrmFoulRoll.FormCreate(Sender: TObject);
begin
  DPinjmod.text := DPIinjmod;
  DParmmod.text := DPIarmmod;
end;

end.
