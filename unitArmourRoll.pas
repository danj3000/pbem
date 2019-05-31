unit unitArmourRoll;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TfrmArmourRoll = class(TForm)
    pnlAR: TPanel;
    Label1: TLabel;
    GroupBox1: TGroupBox;
    lblPilingOnST: TLabel;
    rbClaw: TRadioButton;
    rbARMightyBlow: TRadioButton;
    txtPilingOnST: TEdit;
    rbARNoSkill: TRadioButton;
    txtArmourValue: TEdit;
    butMakeRoll: TButton;
    pnlIR: TPanel;
    GroupBox2: TGroupBox;
    rbFangs: TRadioButton;
    rbIRNoSkill: TRadioButton;
    lblAssists: TLabel;
    txtAssists: TEdit;
    rbDirtyPlayer: TRadioButton;
    txtDPArmMod: TEdit;
    rbIRDirtyPlayer: TRadioButton;
    txtDPInjMod: TEdit;
    rbIRMightyBlow: TRadioButton;
    cbIGMEOY: TCheckBox;
    rbAVNegOne: TRadioButton;
    rbINJNegOne: TRadioButton;
    pnlPlayerSize: TPanel;
    GroupBox4: TGroupBox;
    rbWeakPlayer: TRadioButton;
    rbTitchyPlayer: TRadioButton;
    cbCrystalSkin: TCheckBox;
    cbThickSkull: TCheckBox;
    rbChainsaw: TRadioButton;
    rbPDagger: TRadioButton;
    cbARDaura: TCheckBox;
    cbIRDaura: TCheckBox;
    cbNullField: TCheckBox;
    cbWaaaghArmour: TCheckBox;
    cbLBanish: TCheckBox;
    cbLBanish2: TCheckBox;
    rbDeathRoller: TRadioButton;
    cbBrittle: TCheckBox;
    cbChainsawKD: TCheckBox;
    rbNoStunty: TRadioButton;
    cbIronMan: TCheckBox;
    cbPulledPunches: TCheckBox;
    lblNiggles: TLabel;
    txtNiggles: TEdit;
    cbNoDeath: TCheckBox;
    cbProSkill: TCheckBox;
    rbPilingOn: TCheckBox;
    cbDecay: TCheckBox;
    procedure rbPilingOnClick(Sender: TObject);
    procedure txtArmourValueChange(Sender: TObject);
    procedure butMakeRollClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure rbClawClick(Sender: TObject);
    procedure rbChainsawClick(Sender: TObject);
    procedure rbPDaggerClick(Sender: TObject);
    procedure rbARMightyBlowClick(Sender: TObject);
    procedure rbDirtyPlayerClick(Sender: TObject);
    procedure rbFangsClick(Sender: TObject);
    procedure rbIRMightyBlowClick(Sender: TObject);
    procedure rbIRDirtyPlayerClick(Sender: TObject);
    procedure cbARDauraClick(Sender: TObject);
    procedure cbIRDauraClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmArmourRoll: TfrmArmourRoll;

procedure ShowHurtForm(st: char);

implementation

uses bbunit, unitSettings, unitPass;

{$R *.DFM}

var RollSt: char;

procedure TfrmArmourRoll.txtArmourValueChange(Sender: TObject);
var v, c: integer;
begin
  Val(txtArmourValue.text, v, c);
  butMakeRoll.enabled := (v > 0);
end;

procedure TfrmArmourRoll.butMakeRollClick(Sender: TObject);
var s, ix: string;
    v, c, am, im: integer;
begin
  case RollSt of
    'A': begin
           Val(Trim(txtArmourValue.text), v, c);
           s := '* arm' + IntToStr(v);
         end;
    'I': begin
           s := '* inj';
         end;
    'F': begin
           Val(Trim(txtArmourValue.text), v, c);
           s := '* foul' + IntToStr(v);
         end;
  end;

  InjuryStatus := 3;
  PilingOn := -1;
  if RollST <> 'I' then begin
    am := 0;
    if rbChainsaw.checked then begin
      if RollST = 'F' then am := 2 else am := 3;
    end;
    if rbARMightyBlow.checked then am := 1;
    if rbClaw.checked then am := 2;
    if rbAVNegOne.checked then am := -1;
    if rbDirtyPlayer.checked then begin
      Val(Trim(txtDPArmMod.text), v, c);
      am := v;
    end;
    if rbDeathRoller.checked then am := am + 5;
    if cbChainsawKD.checked then am := am + 3;
    if rbPilingOn.checked then begin
      if frmSettings.rbPO.ItemIndex <= 1 then begin
        Val(Trim(txtPilingOnST.text), v, c);
        am := v;
      end;
      PilingOn := frmSettings.rbPO.ItemIndex;
    end;
    if RollST = 'F' then begin
      Val(Trim(txtAssists.text), v, c);
      am := am + v + 1;
    end;
    if cbARDaura.checked or cbNullField.checked then am := 0;

    s := s + ' +' + IntToStr(am);
  end;

  {Set Global Variables for armour and injury specials based on options}
  ProSkill := cbProSkill.checked;
  ThickSkull := cbThickSkull.checked;
  PulledPunches := cbPulledPunches.checked and frmSettings.cbPulledPunches.checked;
  IronMan := cbIronMan.checked;
  Decay := cbDecay.Checked;
  PoisonedDagger := rbPDagger.checked;
  CrystalSkin := cbCrystalSkin.checked and frmSettings.cbCrystalSkin.checked;
  DaemonicAura := cbIRDaura.checked and frmSettings.cbDaemonicAura.checked;
  LesserBanishment := cbLBanish.checked and frmSettings.cbBanishment.checked;
  LBanishment2 := cbLBanish2.checked and frmSettings.cbBanishment.checked;
  Brittle := cbBrittle.checked and frmSettings.cbBrittle.checked;
  NoDeath := cbNoDeath.checked;
  DirtyPlayer4th := false;

  im := 0;
  ix := ' +';
  if rbFangs.checked then im := 2;
  {Tom Change: Allow for Negative one injury modifier needs set
  at &7 to &9 so that it can be seperated from the mighty blow
  range of &1 to &3}
  if rbINJNegOne.checked then begin
    im := 7;
    ix := ' &';
  end;
  MBPO := false;
  if rbIRMightyBlow.checked then begin
    im := 1;
    MBPO := true;
    if frmSettings.cbMB4th.checked and (RollST <> 'I')
      and rbARMightyBlow.checked
      and not (cbARDaura.checked or cbNullField.checked) then ix := ' &';
  end;
  if rbIRDirtyPlayer.checked then begin
    Val(Trim(txtDPInjMod.text), v, c);
    im := v;
    if frmSettings.cbMB4th.checked
     and not (cbARDaura.checked or cbNullField.checked) then begin
      ix := ' &';
      DirtyPlayer4th := true;
    end;
  end;
  if (frmPass.txtBulletThrow.Visible) and (im>=0) then ix := ' +';
  if (frmPass.txtBulletThrow.Visible) and (im=(-1)) then begin
    im := 7;
    ix := ' &';
  end;
  if (im <> 7) and (cbWaaaghArmour.checked) then im := 0;
  if rbWeakPlayer.checked then im := im + 1;
  if rbTitchyPlayer.checked then im := im + 2;

  if frmSettings.cbNiggleUp.checked then begin
    Val(Trim(txtNiggles.text), v, c);
    im := im + v;
  end;

  if im > 0 then s := s + ix + IntToStr(im);

  if cbIGMEOY.checked then s := s + ' IGMEOY';

  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Sender);
  rbARNoSkill.Checked := true;
  rbIRNoSkill.Checked := true;
  rbPilingOn.Checked := false;
  rbDeathRoller.checked := false;
  txtArmourValue.text := '';
  rbWeakPlayer.checked := false;
  rbTitchyPlayer.checked := false;
  cbIGMEOY.checked := false;
  cbThickSkull.checked := false;
  cbProSkill.Checked := false;
  rbPDagger.checked := false;
  cbCrystalSkin.checked := false;
  cbIronMan.checked := false;
  cbDecay.checked := false;
  cbPulledPunches.checked := false;
  cbARDaura.checked := false;
  cbIRDaura.checked := false;
  cbNullField.checked := false;
  cbWaaaghArmour.checked := false;
  rbChainsaw.checked := false;
  cbChainsawKD.checked := false;
  cbLBanish.checked := false;
  cbLBanish2.checked := false;
  cbBrittle.checked := false;
  cbNoDeath.checked := false;
  txtAssists.text := '';
  txtPilingOnST.text := '';
  txtNiggles.text := '';
  ModalResult := 1;

  frmArmourRoll.rbClaw.visible := true;
  frmArmourRoll.rbFangs.visible := true;
  frmArmourRoll.rbARMightyBlow.visible := true;
  frmArmourRoll.rbIRMightyBlow.visible := true;

end;

procedure TfrmArmourRoll.FormActivate(Sender: TObject);
begin
  txtArmourValue.SetFocus;
end;

procedure ShowHurtForm(st: char);
begin
  {st = A: Armour Roll, = I: Injury Roll, = F: Foul Roll}
  RollSt := st;
  if not (frmSettings.cbCrystalSkin.checked) then begin
     frmArmourRoll.cbCrystalSkin.visible := false;
     frmArmourRoll.cbCrystalSkin.checked := false;
  end;
  if not (frmSettings.cbNullField.checked) then begin
     frmArmourRoll.cbNullField.visible := false;
     frmArmourRoll.cbNullField.checked := false;
  end;
  if not (frmSettings.cbWaaaghArmour.checked) then begin
     frmArmourRoll.cbWaaaghArmour.visible := false;
     frmArmourRoll.cbWaaaghArmour.checked := false;
  end;
  if not (frmSettings.cbBanishment.checked) then begin
     frmArmourRoll.cbLBanish.visible := false;
     frmArmourRoll.cbLBanish.checked := false;
     frmArmourRoll.cbLBanish2.checked := false;
  end;
  if not (frmSettings.cbBrittle.checked) then begin
     frmArmourRoll.cbBrittle.visible := false;
     frmArmourRoll.cbBrittle.checked := false;
  end;
  if frmSettings.rgTitchy.ItemIndex=0 then begin
     frmArmourRoll.rbTitchyPlayer.checked := false;
     frmArmourRoll.rbTitchyPlayer.visible := false;
  end;
  if not (frmSettings.cbDaemonicAura.checked) then begin
     frmArmourRoll.cbARDaura.checked := false;
     frmArmourRoll.cbARDaura.visible := false;
     frmArmourRoll.cbIRDaura.checked := false;
     frmArmourRoll.cbIRDaura.Visible := false;
  end;
  if not (frmSettings.cbPulledPunches.checked) then begin
     frmArmourRoll.cbPulledPunches.checked := false;
     frmArmourRoll.cbPulledPunches.visible := false;
  end;
  if not (frmSettings.cbNiggleUp.checked) then begin
     frmArmourRoll.lblNiggles.visible := false;
     frmArmourRoll.txtNiggles.visible := false;
  end;
  case st of
   'A': begin
          frmArmourRoll.caption := 'Armour Roll';
          frmArmourRoll.lblAssists.visible := false;
          frmArmourRoll.txtAssists.visible := false;
          frmArmourRoll.rbDirtyPlayer.visible := false;
          frmArmourRoll.txtDPArmMod.visible := false;
          frmArmourRoll.rbPilingOn.visible := true;
          frmArmourRoll.lblPilingOnST.visible := true;
          frmArmourRoll.txtPilingOnST.visible := true;
          frmArmourRoll.rbPDagger.visible := true;
          frmArmourRoll.rbDeathRoller.visible := false;
          frmArmourRoll.cbIGMEOY.visible := false;
          frmArmourRoll.rbIRDirtyPlayer.visible := false;
          frmArmourRoll.txtDPInjMod.visible := false;
          frmArmourRoll.cbChainsawKD.Visible := true;
          frmArmourRoll.pnlIR.left := frmArmourRoll.pnlAR.width;
          frmArmourRoll.pnlPlayerSize.left := frmArmourRoll.pnlAR.width;
          frmArmourRoll.width :=
               frmArmourRoll.pnlAR.width + frmArmourRoll.pnlIR.width;
          if frmSettings.rbPO.ItemIndex=2 then begin
            frmArmourRoll.lblPilingOnST.visible := false;
            frmArmourRoll.txtPilingOnST.visible := false;
          end;
          if frmSettings.cbNoInjMods.Checked then begin
              frmArmourRoll.rbIRNoSkill.checked := true;
              frmArmourRoll.rbNoStunty.checked := true;
          end;
        end;
   'I': begin
          frmArmourRoll.caption := 'Injury Roll';
          frmArmourRoll.cbIGMEOY.visible := false;
          frmArmourRoll.rbIRDirtyPlayer.visible := true;
          frmArmourRoll.txtDPInjMod.visible := true;
          frmArmourRoll.rbPDagger.visible := true;
          frmArmourRoll.pnlIR.left := frmArmourRoll.pnlAR.left;
          frmArmourRoll.pnlPlayerSize.left := frmArmourRoll.pnlAR.left;
          frmArmourRoll.width := frmArmourRoll.pnlIR.width;
          frmArmourRoll.butMakeRoll.enabled := true;
          if frmSettings.cbNoInjMods.Checked then begin
              frmArmourRoll.rbIRNoSkill.checked := true;
              frmArmourRoll.rbNoStunty.checked := true;
          end;
        end;
   'F': begin
          frmArmourRoll.caption := 'Foul Roll';
          frmArmourRoll.lblAssists.visible := true;
          frmArmourRoll.txtAssists.visible := true;
          frmArmourRoll.rbDirtyPlayer.visible := true;
          frmArmourRoll.txtDPArmMod.visible := true;
          frmArmourRoll.rbPilingOn.visible := false;
          frmArmourRoll.lblPilingOnST.visible := false;
          frmArmourRoll.txtPilingOnST.visible := false;
          frmArmourRoll.rbPDagger.visible := false;
          frmArmourRoll.cbIGMEOY.visible := true;
          frmArmourRoll.rbDeathRoller.visible := true;
          frmArmourRoll.rbIRDirtyPlayer.visible := true;
          frmArmourRoll.txtDPInjMod.visible := true;
          frmArmourRoll.cbChainsawKD.Visible := false;
          frmArmourRoll.cbChainsawKD.checked := false;
          frmArmourRoll.pnlIR.left := frmArmourRoll.pnlAR.width;
          frmArmourRoll.pnlPlayerSize.left := frmArmourRoll.pnlAR.width;
          frmArmourRoll.width :=
          frmArmourRoll.pnlAR.width + frmArmourRoll.pnlIR.width;

          frmArmourRoll.rbClaw.checked := false;
          frmArmourRoll.rbFangs.checked := false;
          frmArmourRoll.rbARMightyBlow.checked := false;
          frmArmourRoll.rbIRMightyBlow.checked := false;
          frmArmourRoll.rbClaw.visible := false;
          frmArmourRoll.rbFangs.visible := false;
          frmArmourRoll.rbARMightyBlow.visible := false;
          frmArmourRoll.rbIRMightyBlow.visible := false;

          if frmSettings.cbNoInjMods.Checked then begin
              frmArmourRoll.rbIRNoSkill.checked := true;
              frmArmourRoll.rbNoStunty.checked := true;
          end;
        end;
  end;
  frmArmourRoll.ShowModal;
end;

procedure TfrmArmourRoll.rbClawClick(Sender: TObject);
begin
  if not(frmSettings.cbSeparateARIR.checked) then
    rbIRNoSkill.checked := true;
end;

procedure TfrmArmourRoll.rbARMightyBlowClick(Sender: TObject);
begin
  {if not(frmSettings.cbSeparateARIR.checked) then}
   rbIRMightyBlow.checked := true;
   if frmSettings.cbNoInjMods.Checked then begin
     frmArmourRoll.rbIRNoSkill.checked := true;
   end;
end;

procedure TfrmArmourRoll.rbDirtyPlayerClick(Sender: TObject);
begin
{  txtDPArmMod.enabled := rbDirtyPlayer.checked;}
  {if not(frmSettings.cbSeparateARIR.checked) then}
    rbIRDirtyPlayer.checked := true;
end;

procedure TfrmArmourRoll.rbPilingOnClick(Sender: TObject);
begin
  txtPilingOnST.Enabled := rbPilingOn.Checked;
  if frmSettings.rbPO.ItemIndex <> 2 then rbARNoSkill.Checked := true;
  {if not(frmSettings.cbSeparateARIR.checked) then
    rbIRNoSkill.checked := true;   }
end;

procedure TfrmArmourRoll.rbChainsawClick(Sender: TObject);
begin
  {rbIRNoSkill.checked := true;}
end;

procedure TfrmArmourRoll.rbPDaggerClick(Sender: TObject);
begin
  rbIRNoSkill.checked := true;
end;

procedure TfrmArmourRoll.rbFangsClick(Sender: TObject);
begin
  if not(frmSettings.cbSeparateARIR.checked) then
    rbARNoSkill.checked := true;
  if rbChainsaw.checked then begin
    rbChainsaw.checked := false;
    rbARNoSkill.checked := true;
  end;
end;

procedure TfrmArmourRoll.rbIRMightyBlowClick(Sender: TObject);
begin
{  txtDPInjMod.enabled := rbIRDirtyPlayer.checked;}
  if not(frmSettings.cbSeparateARIR.checked) then
    rbARMightyBlow.checked := true;
  if rbChainsaw.checked then begin
    rbChainsaw.checked := false;
    rbARNoSkill.checked := true;
  end;
end;

procedure TfrmArmourRoll.rbIRDirtyPlayerClick(Sender: TObject);
begin
  if not(frmSettings.cbSeparateARIR.checked) then
    rbDirtyPlayer.checked := true;
  {if rbChainsaw.checked then begin
    rbChainsaw.checked := false;
    rbARNoSkill.checked := true;
  end;}
end;

procedure TfrmArmourRoll.cbARDauraClick(Sender: TObject);
begin
  if cbARDaura.checked = true then
      cbIRDaura.checked := true;
end;

procedure TfrmArmourRoll.cbIRDauraClick(Sender: TObject);
begin
  if cbIRDaura.checked = true then
      cbARDaura.checked := true;
end;

end.
