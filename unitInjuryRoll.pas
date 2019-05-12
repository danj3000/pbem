unit unitInjuryRoll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmInjuryRoll = class(TForm)
    GroupBox1: TGroupBox;
    MightyBlowRB: TRadioButton;
    FangsRB: TRadioButton;
    DirtyPlayerRB: TRadioButton;
    rbNoSkill: TRadioButton;
    DPinjmod: TEdit;
    MakeRollBut: TButton;
    CBWeakPlayer: TCheckBox;
    procedure RBClick(Sender: TObject);
    procedure MakeRollButClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmInjuryRoll: TfrmInjuryRoll;

implementation

uses bbunit;

{$R *.DFM}

procedure TfrmInjuryRoll.RBClick(Sender: TObject);
begin
  DPinjmod.Enabled := DirtyPlayerRB.Checked;
end;

procedure TfrmInjuryRoll.MakeRollButClick(Sender: TObject);
var s: string;
    i, v, c: integer;
begin
  i := 0;
  s := '* inj';
  if MightyBlowRB.checked then i := 1;
  if FangsRB.checked then i := 2;
  if DirtyPlayerRB.checked then begin
    Val(Trim(DPinjmod.text), v, c);
    i := v;
  end;
  if CBWeakPlayer.checked then i := i + 1;
  if i > 0 then s := s + ' +' + IntToStr(i);
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Sender);
  frmInjuryRoll.Hide;
  rbNoSkill.checked := true;
  cbWeakPlayer.checked := false;
end;

procedure TfrmInjuryRoll.FormCreate(Sender: TObject);
begin
  DPinjmod.text := DPIinjmod;
end;

end.
