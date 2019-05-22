unit unitSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, ExtCtrls, StdCtrls;

type
  TfrmSettings = class(TForm)
    pcSettings: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    cbShowSPP: TCheckBox;
    Label1: TLabel;
    txtDPArmMod: TEdit;
    txtDPInjMod: TEdit;
    Label2: TLabel;
    Label3: TLabel;
    GroupBox1: TGroupBox;
    rbFoulRule1: TRadioButton;
    rbFoulRule2: TRadioButton;
    rbFoulRule3: TRadioButton;
    rbFoulRule4: TRadioButton;
    rbFoulRule5: TRadioButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    rgFoulReferee: TRadioGroup;
    Label11: TLabel;
    cbMB4th: TCheckBox;
    cbSF4th: TCheckBox;
    cbDT4th: TCheckBox;
    TabSheet4: TTabSheet;
    rgSkillRollsAt: TRadioGroup;
    cbNoForcedMAandAG: TCheckBox;
    rgBGA4th: TRadioGroup;
    cbTentacles4th: TCheckBox;
    cbBT4th: TCheckBox;
    TabSheet5: TTabSheet;
    Label4: TLabel;
    txtRegenRollNeeded: TEdit;
    Label5: TLabel;
    cbPBJumpUp: TCheckBox;
    cbNoTZAssist: TCheckBox;
    cbUpApoth: TCheckBox;
    cbUseOtherSPP: TCheckBox;
    cbNoMVPs: TCheckBox;
    TabSheet6: TTabSheet;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    TabSheet7: TTabSheet;
    cbFFMinus1Per10: TCheckBox;
    cbFFTrueDice: TCheckBox;
    rgWonMatchMod: TRadioGroup;
    rgTiedMatchMod: TRadioGroup;
    Label18: TLabel;
    butAccept: TButton;
    lblCantChange: TLabel;
    txtHandicapTable: TEdit;
    txtMWTable: TEdit;
    txtKOTable: TEdit;
    txtWeatherTable: TEdit;
    txtFieldImageFile: TEdit;
    rgRandomAlgorithm: TRadioGroup;
    cmbLeague: TComboBox;
    Label20: TLabel;
    cbDTAfter: TCheckBox;
    TabSheet8: TTabSheet;
    Label19: TLabel;
    cbFragile: TCheckBox;
    cbElephantTrunk: TCheckBox;
    cbNullField: TCheckBox;
    cbGFIInjury: TCheckBox;
    cbPerfectSpiral: TCheckBox;
    cbHouseFlyHead: TCheckBox;
    cbCrystalSkin: TCheckBox;
    cbWaaaghArmour: TCheckBox;
    cbBanishment: TCheckBox;
    cbBrittle: TCheckBox;
    cbDaemonicAura: TCheckBox;
    cbPulledPunches: TCheckBox;
    cbBless: TCheckBox;
    cbSingleEye: TCheckBox;
    cbThirdEye: TCheckBox;
    Label21: TLabel;
    cbBrightCrusaders: TCheckBox;
    cbEvilGits: TCheckBox;
    cbVampireNecrarch: TCheckBox;
    cbCheerAC: TCheckBox;
    cbVampireLahmian: TCheckBox;
    cbNurglesRotters: TCheckBox;
    cbBiasedReferee: TCheckBox;
    cbHobgoblin: TCheckBox;
    cbWings: TCheckBox;
    cbWarCry: TCheckBox;
    cbThrowStinkBomb: TCheckBox;
    cbThrowNet: TCheckBox;
    cbThrowFireball: TCheckBox;
    cbThrowBigBomb: TCheckBox;
    cbPitchPlayer: TCheckBox;
    cbMaceTail: TCheckBox;
    cbEthereal: TCheckBox;
    cbChill: TCheckBox;
    cbBulletThrow: TCheckBox;
    cbBearHug: TCheckBox;
    cbFlyer: TCheckBox;
    cbLanding: TCheckBox;
    cbThrowStunty: TCheckBox;
    GroupBox2: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Button1: TButton;
    lblHomeColor: TLabel;
    lblAwayColor: TLabel;
    butHomeColorChange: TButton;
    butAwayColorChange: TButton;
    cdColorDialog: TColorDialog;
    cbKicking: TCheckBox;
    cbLRBHorns: TCheckBox;
    cbMVPBench: TCheckBox;
    TabSheet9: TTabSheet;
    cbWeakStunty: TCheckBox;
    cbNiggleOnFour: TCheckBox;
    cbNiggleUp: TCheckBox;
    cbNiggleHalf: TCheckBox;
    cbSeparateARIR: TCheckBox;
    Label17: TLabel;
    txtCardsIniFile: TEdit;
    Label24: TLabel;
    txtHandicapIniFile: TEdit;
    cbWizards: TCheckBox;
    rgAging: TRadioGroup;
    lblLustrian: TLabel;
    cbPGFI: TCheckBox;
    rgCardSystem: TRadioGroup;
    rgPassFumble: TRadioGroup;
    cbLateInt: TCheckBox;
    cbDig: TCheckBox;
    cbButterfingers: TCheckBox;
    butSelectFile: TButton;
    dlgPic: TOpenDialog;
    cbFoulApp: TCheckBox;
    cbPassingRangesColored: TCheckBox;
    cbBlackIce: TCheckBox;
    cbFG1PT: TCheckBox;
    cbMVPEXP: TCheckBox;
    lbEXPAgingPoint: TLabel;
    txtEXPAgingPoint: TEdit;
    cbEXPSI: TCheckBox;
    lblMVPValue: TLabel;
    txtMVPValue: TEdit;
    cbOPTakeRoot: TCheckBox;
    cbSquarePass: TCheckBox;
    cbBHAssist: TCheckBox;
    cbDiagMove: TCheckBox;
    cbSWRef: TCheckBox;
    cbHChefNew: TCheckBox;
    cbGoblinWeapons: TCheckBox;
    cbNoFieldGoals: TCheckBox;
    cbOnPitchSpellcasters: TCheckBox;
    cbNegativeWinnings: TCheckBox;
    cbApoths: TCheckBox;
    rbWA: TRadioGroup;
    rbPO: TRadioGroup;
    cbLOS: TCheckBox;
    cbNoInjMods: TCheckBox;
    cbFirethrower: TCheckBox;
    cbWeatherPitch: TCheckBox;
    rgTitchy: TRadioGroup;
    rgHGaze: TRadioGroup;
    cbWideZone: TCheckBox;
    cbRuleof11: TCheckBox;
    cbLRB4KO: TCheckBox;
    cbDeStun: TCheckBox;
    cbDC: TCheckBox;
    procedure butAcceptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure cmbLeagueChange(Sender: TObject);
    procedure butHomeColorChangeClick(Sender: TObject);
    procedure butAwayColorChangeClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure butSelectFileClick(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSettings: TfrmSettings;

procedure RestoreSettings(st: string);

implementation

uses bbunit, bbalg, unitArmourRoll, unitLog, unitCards, unitRoster,
     unitRandom, unitHandicapTable;

{$R *.DFM}

procedure FixSettings;
var f, g: integer;
begin
  for f := 1 to frmSettings.pcSettings.PageCount - 1 do
                frmSettings.pcSettings.Pages[f].Enabled := false;
  frmSettings.cmbLeague.enabled := false;
  frmSettings.butAccept.visible := false;
  frmSettings.lblCantChange.visible := true;

  frmArmourRoll.txtDPArmMod.text := '+' + Trim(frmSettings.txtDPArmMod.text);
  frmArmourRoll.txtDPInjMod.text := '+' + Trim(frmSettings.txtDPInjMod.text);

  FillKOTable;
  FillWTable;
  frmCards.InitForm;
  frmRoster.InitForm;

  if frmSettings.cbUseOtherSPP.checked then begin
    g := Bloodbowl.compSB.left;
    for f := 0 to Bloodbowl.toolbar.ControlCount - 1 do begin
      if Bloodbowl.toolbar.Controls[f].left >= g then
         Bloodbowl.toolbar.Controls[f].left :=
              Bloodbowl.toolbar.Controls[f].left + Bloodbowl.sbOtherSPP.width;
    end;
    Bloodbowl.sbOtherSPP.Left := g;
  end else begin
    Bloodbowl.sbOtherSPP.Visible := false;
    Bloodbowl.OtherSPP1.visible := false;
    Bloodbowl.RemoveOther1.Visible := false;
  end;

  if frmSettings.cbMVPEXP.checked then begin
    g := Bloodbowl.SBMVP.left;
    for f := 0 to Bloodbowl.toolbar.ControlCount - 1 do begin
      if Bloodbowl.toolbar.Controls[f].left >= g then
         Bloodbowl.toolbar.Controls[f].left :=
              Bloodbowl.toolbar.Controls[f].left + Bloodbowl.sbEXP.width;
    end;
    Bloodbowl.sbEXP.Left := g;
  end else begin
    Bloodbowl.sbEXP.Visible := false;
    Bloodbowl.EXP1.visible := false;
    Bloodbowl.RemoveEXP1.visible := false;
  end;

  if frmSettings.rgCardSystem.ItemIndex >= 3 then begin
    Bloodbowl.butCardsBlue.visible := false;
    Bloodbowl.butCardsRed.visible := false;
  end else begin
    Bloodbowl.butMakeHandicapRolls.visible := false;
  end;

  if frmSettings.cbOnPitchSpellcasters.Checked then begin
    Bloodbowl.W1.visible := false;
    Bloodbowl.LRBWizSpells.visible := false;
  end;

  if not (frmSettings.cbBearHug.checked) then
    BloodBowl.BearHug1.visible := false;
  if not (frmSettings.cbBulletThrow.checked) then
    BloodBowl.BulletThrow1.visible := false;
  if not (frmSettings.cbChill.checked) then
    BloodBowl.Chill1.visible := false;
  if not (frmSettings.cbEthereal.checked) then
    BloodBowl.Ethereal1.visible := false;
  if not (frmSettings.cbMaceTail.checked) then
    BloodBowl.MaceTail1.visible := false;
  if not (frmSettings.cbPitchPlayer.checked) then
    BloodBowl.PitchPlayer1.visible := false;
  if not (frmSettings.cbThrowBigBomb.checked) then
    BloodBowl.ThrowBigBomb1.visible := false;
  {if not (frmSettings.cbThrowFireball.checked) then
    BloodBowl.ThrowFireball1.visible := false; }
  if not (frmSettings.cbFirethrower.checked) then
    BloodBowl.Firethrower1.visible := false;
  if not (frmSettings.cbThrowNet.checked) then
    BloodBowl.ThrowNet1.visible := false;
  if not (frmSettings.cbThrowStinkBomb.checked) then
    BloodBowl.ThrowStinkBomb1.visible := false;
  if not (frmSettings.cbWarCry.checked) then
    BloodBowl.WarCry1.visible := false;
  if not (frmSettings.cbDig.checked) then
    BloodBowl.Dig1.visible := false;
  if not (frmSettings.cbWings.checked) then begin
    BloodBowl.Wings1.visible := false;
    BloodBowl.WingsLeap1.visible := false;
  end;
  if not (frmSettings.cbKicking.checked) then begin
    BloodBowl.MakeKickRoll1.Visible := false;
    BloodBowl.DirtyKick1.Visible := false;
    BloodBowl.Punt1.Visible := false;
  end;
  if not (frmSettings.cbBearHug.checked) and
     not (frmSettings.cbBulletThrow.checked) and
     not (frmSettings.cbChill.checked) and
     not (frmSettings.cbEthereal.checked) and
     not (frmSettings.cbMaceTail.checked) and
     not (frmSettings.cbPitchPlayer.checked) and
     not (frmSettings.cbThrowBigBomb.checked) and
     {not (frmSettings.cbThrowFireball.checked) and}
     not (frmSettings.cbThrowNet.checked) and
     not (frmSettings.cbThrowStinkBomb.checked) and
     not (frmSettings.cbFirethrower.checked) and
     not (frmSettings.cbWarCry.checked) and
     not (frmSettings.cbDig.checked) and
     not (frmSettings.cbWings.checked) then
     BloodBowl.TargetActionsSpecial1.visible := false;

  ShowFieldImage(frmSettings.txtFieldImageFile.text);

  if (frmSettings.txtHandicapIniFile.text <> 'bbhandicap.ini') and
   (frmSettings.txtHandicapIniFile.text <> '') then
     OtherHandicapSetup;

  if (frmSettings.rgAging.ItemIndex = 3) and (not(frmSettings.cbMVPEXP.checked))
    then begin
    BloodBowl.SBMVP.Hint := 'EXP Point';
    BloodBowl.MVPAward1.Caption := 'EXP Point';
    BloodBowl.RemoveMVP1.Caption := 'Remove EXP';
  end;

  SettingsLoaded := True;
  ApoWizCreate(0);
  ApoWizCreate(1);

end;

procedure RestoreSettings(st: string);
var s: string;

    function GetText: string;
    var p: integer;
    begin
      p := Pos('*', s);
      GetText := Copy(s, 1, p-1);
      s := Copy(s, p+1, Length(s) - p);
    end;
begin
  s := st;
  frmSettings.cmbLeague.text := GetText;
  frmSettings.txtHandicapTable.text := GetText;
  frmSettings.txtMWTable.text := GetText;
  frmSettings.txtKOTable.text := GetText;
  frmSettings.txtWeatherTable.text := GetText;
  frmSettings.cbMB4th.checked := (s[1] = 'M');
  frmSettings.cbSF4th.checked := (s[2] = 'S');
  frmSettings.rbWA.ItemIndex := Ord(s[3]) - 48;
  frmSettings.cbDT4th.checked := (s[4] = 'D');
  frmSettings.cbTentacles4th.checked := (s[5] = 'T');
  frmSettings.cbBT4th.checked := (s[6] = 'B');
  frmSettings.rbPO.ItemIndex := Ord(s[7]) - 48;
  frmSettings.rgBGA4th.ItemIndex := Ord(s[8]) - 48;
  frmSettings.cbDTAfter.checked := (s[9] = 'A');
  GetText;
  frmSettings.txtDPArmMod.text := s[1];
  frmSettings.txtDPInjMod.text := s[2];
  case s[3] of
    '1': frmSettings.rbFoulRule1.checked := true;
    '2': frmSettings.rbFoulRule2.checked := true;
    '3': frmSettings.rbFoulRule3.checked := true;
    '4': frmSettings.rbFoulRule4.checked := true;
    '5': frmSettings.rbFoulRule5.checked := true;
  end;
  frmSettings.rgFoulReferee.ItemIndex := Ord(s[4]) - 48;
  GetText;
  frmSettings.rgSkillRollsAt.ItemIndex := Ord(s[1]) - 48;
  frmSettings.rgAging.ItemIndex := Ord(s[2]) - 48;
  frmSettings.cbNoForcedMAandAG.checked := (s[3] = 'F');
  frmSettings.cbCheerAC.checked := (s[4] = 'S');
  frmSettings.cbNoMVPs.checked := (s[5] = 'M');
  frmSettings.cbNiggleUp.checked := (s[6] = 'N');
  frmSettings.cbBanishment.checked := (s[7] = 'B');
  frmSettings.cbBless.checked := (s[8] = 'L');
  frmSettings.cbBrittle.checked := (s[9] = 'R');
  frmSettings.cbCrystalSkin.checked := (s[10] = 'C');
  frmSettings.cbDaemonicAura.checked := (s[11] = 'D');
  frmSettings.cbElephantTrunk.checked := (s[12] = 'E');
  frmSettings.cbFragile.checked := (s[13] = 'P');
  frmSettings.cbGFIInjury.checked := (s[14] = 'G');
  frmSettings.cbHouseFlyHead.checked := (s[15] = 'H');
  frmSettings.cbPerfectSpiral.checked := (s[16] = 'I');
  frmSettings.cbPulledPunches.checked := (s[17] = 'J');
  frmSettings.cbSingleEye.checked := (s[18] = 'K');
  frmSettings.cbNullField.checked := (s[19] = 'O');
  frmSettings.cbThirdEye.checked := (s[20] = 'T');
  frmSettings.rgTitchy.ItemIndex := Ord(s[21]) - 48;
  frmSettings.cbWaaaghArmour.checked := (s[22] = 'W');
  frmSettings.cbBrightCrusaders.checked := (s[23] = 'X');
  frmSettings.cbEvilGits.checked := (s[24] = 'U');
  frmSettings.cbVampireNecrarch.checked := (s[25] = 'V');
  frmSettings.cbVampireLahmian.checked := (s[26] = 'Y');
  frmSettings.cbNurglesRotters.checked := (s[27] = 'Z');
  frmSettings.cbHobgoblin.checked := (s[28] = 'A');
  frmSettings.cbBiasedReferee.checked := (s[29] = 'C');
  frmSettings.cbBearHug.checked := (s[30] = 'D');
  frmSettings.cbBulletThrow.checked := (s[31] = 'E');
  frmSettings.cbChill.checked := (s[32] = 'F');
  frmSettings.cbEthereal.checked := (s[33] = 'G');
  frmSettings.cbMaceTail.checked := (s[34] = 'H');
  frmSettings.cbPitchPlayer.checked := (s[35] = 'I');
  frmSettings.cbThrowBigBomb.checked := (s[36] = 'J');
  frmSettings.cbThrowFireball.checked := (s[37] = 'K');
  frmSettings.cbThrowNet.checked := (s[38] = 'L');
  frmSettings.cbThrowStinkBomb.checked := (s[39] = 'M');
  frmSettings.cbWarCry.checked := (s[40] = 'N');
  frmSettings.cbWings.checked := (s[41] = 'O');
  frmSettings.cbThrowStunty.checked := (s[42] = 'P');
  frmSettings.cbFlyer.checked := (s[43] = 'Q');
  frmSettings.cbLanding.checked := (s[44] = 'R');
  frmSettings.cbKicking.checked := (s[45] = 'S');
  frmSettings.cbNiggleHalf.checked := (s[46] = 'T');
  frmSettings.cbMVPBench.checked := (s[47] = 'U');
  frmSettings.cbLRBHorns.checked := (s[48] = 'V');
  frmSettings.cbWizards.checked := (s[49] = 'W');
  frmSettings.rgPassFumble.ItemIndex := Ord(s[50]) - 48;
  frmSettings.cbPGFI.checked := (s[51] = 'X');
  frmSettings.cbLateInt.checked := (s[52] = 'Y');
  frmSettings.cbDig.checked := (s[53] = 'Z');
  frmSettings.cbButterfingers.checked := (s[54] = 'A');
  frmSettings.cbFoulApp.checked := (s[55] = 'B');
  frmSettings.cbFG1PT.checked := (s[56] = 'C');
  frmSettings.cbMVPEXP.checked := (s[57] = 'D');
  frmSettings.txtMVPValue.text := s[58];
  frmSettings.txtEXPAgingPoint.Text := s[59];
  frmSettings.cbEXPSI.checked := (s[60] = 'E');
  frmSettings.cbOPTakeRoot.checked := (s[61] = 'F');
  frmSettings.cbBlackIce.Checked := (s[62] = 'G');
  frmSettings.cbSquarePass.checked := (s[63] = 'H');
  frmSettings.cbBHAssist.checked := (s[64] = 'I');
  frmSettings.cbHChefNew.checked := (s[65] = 'J');
  frmSettings.cbDiagMove.checked := (s[66] = 'K');
  frmSettings.cbSWRef.checked := (s[67] = 'L');
  frmSettings.cbGoblinWeapons.checked := (s[68] = 'M');
  frmSettings.cbNoFieldGoals.checked := (s[69] = 'N');
  frmSettings.cbOnPitchSpellcasters.checked := (s[70] = 'O');
  frmSettings.cbNegativeWinnings.checked := (s[71] = 'P');
  frmSettings.cbApoths.checked := (s[72] = 'Q');
  frmSettings.cbNoInjMods.checked := (s[73] = 'R');
  frmSettings.cbFirethrower.checked := (s[74] = 'S');
  GetText;
  frmSettings.rgWonMatchMod.ItemIndex := Ord(s[1]) - 48;
  frmSettings.rgTiedMatchMod.ItemIndex := Ord(s[2]) - 48;
  frmSettings.cbFFMinus1Per10.checked := (s[3] = 'M');
  frmSettings.cbFFTrueDice.checked := (s[4] = 'T');
  frmSettings.rgHGaze.ItemIndex := Ord(s[5]) - 48;
  frmSettings.cbLOS.checked := (s[6] = 'L');
  frmSettings.cbWeatherPitch.checked := (s[7] = 'W');
  frmSettings.cbWideZone.checked := (s[8] = 'Z');
  frmSettings.cbRuleof11.checked := (s[9] = 'R');
  frmSettings.cbLRB4KO.Checked := (s[10] = 'K');
  frmSettings.cbDeStun.checked := (s[11] = 'S');
  frmSettings.cbDC.Checked := (s[12] = 'D');
  GetText;
  frmSettings.txtRegenRollNeeded.text := s[1];
  frmSettings.cbPBJumpUp.checked := (s[2] = 'J');
  frmSettings.cbWeakStunty.checked := (s[3] = 'W');
  frmSettings.cbNiggleOnFour.checked := (s[4] = 'N');
  frmSettings.cbNoTZAssist.checked := (s[5] = 'A');
  frmSettings.cbUpApoth.checked := (s[6] = 'U');
  frmSettings.rgCardSystem.ItemIndex := Ord(s[7]) - 48;
  GetText;
  frmSettings.txtCardsIniFile.text := GetText;
  frmSettings.txtHandicapIniFile.text := GetText;
  frmSettings.txtFieldImageFile.text := GetText;
  frmSettings.cbUseOtherSPP.checked := (s[1] = 'O');
  frmSettings.cbSeparateARIR.checked := (s[2] = 'S');
  frmSettings.lblLustrian.Caption := s[3];

  FixSettings;
end;

procedure TfrmSettings.butAcceptClick(Sender: TObject);
var st: string;
    i: integer;
begin
  for i := 1 to pcSettings.PageCount - 1 do
      pcSettings.Pages[i].Enabled := false;
  st := cmbLeague.Items[cmbLeague.ItemIndex] + '*';
  st := st + txtHandicapTable.text + '*' + txtMWTable.text + '*' +
        txtKOTable.text + '*' + txtWeatherTable.text + '*';
  if cbMB4th.checked then st := st + 'M' else st := st + '.';
  if cbSF4th.checked then st := st + 'S' else st := st + '.';
  st := st + Chr(48 + rbWA.ItemIndex);
  if cbDT4th.checked then st := st + 'D' else st := st + '.';
  if cbTentacles4th.checked then st := st + 'T' else st := st + '.';
  if cbBT4th.checked then st := st + 'B' else st := st + '.';
  st := st + Chr(48 + rbPO.ItemIndex);
  st := st + Chr(48 + rgBGA4th.ItemIndex);
  if cbDTAfter.checked then st := st + 'A' else st := st + '.';
  st := st + '*';
  st := st + Trim(txtDPArmMod.text) + Trim(txtDPInjMod.text);
  if rbFoulRule1.checked then st := st + '1' else
  if rbFoulRule2.checked then st := st + '2' else
  if rbFoulRule3.checked then st := st + '3' else
  if rbFoulRule4.checked then st := st + '4' else
  if rbFoulRule5.checked then st := st + '5' else st := st + '.';
  st := st + Chr(48 + rgFoulReferee.ItemIndex);
  st := st + '*';
  st := st + Chr(48 + rgSkillRollsAt.ItemIndex);
  st := st + Chr(48 + rgAging.ItemIndex);
  if cbNoForcedMAandAG.checked then st := st + 'F' else st := st + '.';
  if cbCheerAC.checked then st := st + 'S' else st := st + '.';
  if cbNoMVPs.checked then st := st + 'M' else st := st + '.';
  if cbNiggleUp.checked then st := st + 'N' else st := st + '.';
  if cbBanishment.checked then st := st + 'B' else st := st + '.';
  if cbBless.checked then st := st + 'L' else st := st + '.';
  if cbBrittle.checked then st := st + 'R' else st := st + '.';
  if cbCrystalSkin.checked then st := st + 'C' else st := st + '.';
  if cbDaemonicAura.checked then st := st + 'D' else st := st + '.';
  if cbElephantTrunk.checked then st := st + 'E' else st := st + '.';
  if cbFragile.checked then st := st + 'P' else st := st + '.';
  if cbGFIInjury.checked then st := st + 'G' else st := st + '.';
  if cbHouseFlyHead.checked then st := st + 'H' else st := st + '.';
  if cbPerfectSpiral.checked then st := st + 'I' else st := st + '.';
  if cbPulledPunches.checked then st := st + 'J' else st := st + '.';
  if cbSingleEye.checked then st := st + 'K' else st := st + '.';
  if cbNullField.checked then st := st + 'O' else st := st + '.';
  if cbThirdEye.checked then st := st + 'T' else st := st + '.';
  st := st + Chr(48 + rgTitchy.ItemIndex);
  if cbWaaaghArmour.checked then st := st + 'W' else st := st + '.';
  if cbBrightCrusaders.checked then st := st + 'X' else st := st + '.';
  if cbEvilGits.checked then st := st + 'U' else st := st + '.';
  if cbVampireNecrarch.checked then st := st + 'V' else st := st + '.';
  if cbVampireLahmian.checked then st := st + 'Y' else st := st + '.';
  if cbNurglesRotters.checked then st := st + 'Z' else st := st + '.';
  if cbHobgoblin.checked then st := st + 'A' else st := st + '.';
  if cbBiasedReferee.checked then st := st + 'C' else st := st + '.';
  if cbBearHug.checked then st := st + 'D' else st := st + '.';
  if cbBulletThrow.checked then st := st + 'E' else st := st + '.';
  if cbChill.checked then st := st + 'F' else st := st + '.';
  if cbEthereal.checked then st := st + 'G' else st := st + '.';
  if cbMaceTail.checked then st := st + 'H' else st := st + '.';
  if cbPitchPlayer.checked then st := st + 'I' else st := st + '.';
  if cbThrowBigBomb.checked then st := st + 'J' else st := st + '.';
  if cbThrowFireball.checked then st := st + 'K' else st := st + '.';
  if cbThrowNet.checked then st := st + 'L' else st := st + '.';
  if cbThrowStinkBomb.checked then st := st + 'M' else st := st + '.';
  if cbWarCry.checked then st := st + 'N' else st := st + '.';
  if cbWings.checked then st := st + 'O' else st := st + '.';
  if cbThrowStunty.checked then st := st + 'P' else st := st + '.';
  if cbFlyer.checked then st := st + 'Q' else st := st + '.';
  if cbLanding.checked then st := st + 'R' else st := st + '.';
  if cbKicking.checked then st := st + 'S' else st := st + '.';
  if cbNiggleHalf.checked then st := st + 'T' else st := st + '.';
  if cbMVPBench.checked then st := st + 'U' else st := st + '.';
  if cbLRBHorns.checked then st := st + 'V' else st := st + '.';
  if cbWizards.checked then st := st + 'W' else st := st + '.';
  st := st + Chr(48 + rgPassFumble.ItemIndex);
  if cbPGFI.checked then st := st + 'X' else st := st + '.';
  if cbLateInt.checked then st := st + 'Y' else st := st + '.';
  if cbDig.checked then st := st + 'Z' else st := st + '.';
  if cbButterfingers.checked then st := st + 'A' else st := st + '.';
  if cbFoulApp.checked then st := st + 'B' else st := st + '.';
  if cbFG1PT.checked then st := st + 'C' else st := st + '.';
  if cbMVPEXP.Checked then st := st + 'D' else st := st + '.';
  if FVal(txtMVPValue.text)>9 then
    st := st + '9' else
    st := st + Trim(txtMVPValue.text);
  if FVal(txtEXPAgingPoint.text)>9 then
    st := st + '9' else
    st := st + Trim(txtEXPAgingPoint.text);
  if cbEXPSI.checked then st := st + 'E' else st := st + '.';
  if cbOPTakeRoot.checked then st := st + 'F' else st := st + '.';
  if cbBlackIce.checked then st := st + 'G' else st := st + '.';
  if cbSquarePass.checked then st := st + 'H' else st := st + '.';
  if cbBHAssist.checked then st := st + 'I' else st := st + '.';
  if cbHChefNew.checked then st := st + 'J' else st := st + '.';
  if cbDiagMove.checked then st := st + 'K' else st := st + '.';
  if cbSWRef.checked then st := st + 'L' else st := st + '.';
  if cbGoblinWeapons.checked then st := st + 'M' else st := st + '.';
  if cbNoFieldGoals.checked then st := st + 'N' else st := st + '.';
  if cbOnPitchSpellcasters.checked then st := st + 'O' else st := st + '.';
  if cbNegativeWinnings.checked then st := st + 'P' else st := st + '.';
  if cbApoths.checked then st := st + 'Q' else st := st + '.';
  if cbNoInjMods.checked then st := st + 'R' else st := st + '.';
  if cbFirethrower.checked then st := st + 'S' else st := st + '.';
  st := st + '*';
  st := st + Chr(48 + rgWonMatchMod.ItemIndex);
  st := st + Chr(48 + rgTiedMatchMod.ItemIndex);
  if cbFFMinus1Per10.checked then st := st + 'M' else st := st + '.';
  if cbFFTrueDice.checked then st := st + 'T' else st := st + '.';
  st := st + Chr(48 + rgHGaze.ItemIndex);
  if cbLOS.checked then st := st + 'L' else st := st + '.';
  if cbWeatherPitch.checked then st := st + 'W' else st := st + '.';
  if cbWideZone.checked then st := st + 'Z' else st := st + '.';
  if cbRuleof11.checked then st := st + 'R' else st := st + '.';
  if cbLRB4KO.Checked then st := st + 'K' else st := st + '.';
  if cbDeStun.Checked then st := st + 'S' else st := st + '.';
  if cbDC.Checked then st := st + 'D' else st := st + '.';
  st := st + '*';
  st := st + Trim(txtRegenRollNeeded.text);
  if cbPBJumpUp.checked then st := st + 'J' else st := st + '.';
  if cbWeakStunty.checked then st := st + 'W' else st := st + '.';
  if cbNiggleOnFour.checked then st := st + 'N' else st := st + '.';
  if cbNoTZAssist.checked then st := st + 'A' else st := st + '.';
  if cbUpApoth.checked then st := st + 'U' else st := st + '.';
  st := st + Chr(48 + rgCardSystem.ItemIndex);
  st := st + '*' + Trim(txtCardsIniFile.text);
  st := st + '*' + Trim(txtHandicapIniFile.text);
  st := st + '*' + Trim(txtFieldImageFile.text) + '*';
  if cbUseOtherSPP.checked then st := st + 'O' else st := st + '.';
  if cbSeparateARIR.checked then st := st + 'S' else st := st + '.';
  st := st + frmSettings.lblLustrian.Caption;
  UpdateLog(3, st);

  ModalResult := 1;
  FixSettings;
  Bloodbowl.Show;
  Bloodbowl.BringToFront;
  Bloodbowl.PregamePanel.visible := true;
  Bloodbowl.PregamePanel.BringToFront;

end;

procedure TfrmSettings.FormCreate(Sender: TObject);
var ff: TextFile;
    s: string;
    leaguesfound: boolean;
begin
  leaguesfound := false;
  AssignFile(ff, curdir + 'ini/pbleague.ini');
  Reset(ff);
  cmbLeague.Clear;
  while not(eof(ff)) do begin
    ReadLn(ff, s);
    if (s <> '') and (s[1] = '[') then begin
      cmbLeague.Items.Add(Copy(s, 2, Pos(']', s) - 2));
      leaguesfound := true;
    end;
  end;
  if not(leaguesfound) then cmbLeague.Items.Add('<none>');
  cmbLeague.ItemIndex := 0;
  cmbLeagueChange(Sender);
  CloseFile(ff);
end;

procedure TfrmSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if butAccept.visible then Bloodbowl.Close else begin
    ShowFieldImage(txtFieldImageFile.text);
  end;
end;

procedure TfrmSettings.cmbLeagueChange(Sender: TObject);
var ff: TextFile;
    s: string;
    b: boolean;
    i: integer;
begin
  {if cmbLeague.ItemIndex = 0 then begin}
    for i := 1 to pcSettings.PageCount - 1 do
      pcSettings.Pages[i].Enabled := true;
  {end else begin}
    AssignFile(ff, curdir + 'ini/pbleague.ini');
    Reset(ff);
    b := false;
    while not(eof(ff)) do begin
      ReadLn(ff, s);
      if (s <> '') and (s[1] = '[') then begin
        b := (s = '[' + cmbLeague.Items[cmbLeague.ItemIndex] + ']');
      end;
      if b then begin
        if Copy(s, 1, 12) = 'DirtyPlayer=' then begin
          txtDPArmMod.text := Copy(s, 14, 1);
          txtDPInjMod.text := Copy(s, 17, 1);
        end;
        if Copy(s, 1, 12) = 'FoulAssists=' then begin
          case FVal(copy(s, 13, 1)) of
            0: rbFoulRule1.Checked := true;
            1: rbFoulRule2.Checked := true;
            2: rbFoulRule3.Checked := true;
            3: rbFoulRule4.Checked := true;
            4: rbFoulRule5.Checked := true;
          end;
        end;
        if Copy(s, 1, 12) = 'FoulReferee=' then begin
          rgFoulReferee.ItemIndex := FVal(copy(s, 13, 1));
        end;
        if Copy(s, 1, 11) = 'CardSystem=' then begin
          rgCardSystem.ItemIndex := FVal(copy(s, 12, 1)) - 1;
        end;
        if Copy(s, 1, 16) = 'RegenRollNeeded=' then begin
          txtRegenRollNeeded.text := copy(s, 17, 1);
        end;
        if Copy(s, 1, 14) = 'HandicapTable=' then begin
          txtHandicapTable.text := Trim((copy(s, 15, length(s))));
        end;
        if Copy(s, 1, 19) = 'MatchWinningsTable=' then begin
          txtMWTable.text := Trim((copy(s, 20, length(s))));
        end;
        if Copy(s, 1, 13) = 'KickOffTable=' then begin
          txtKOTable.text := Trim((copy(s, 14, length(s))));
        end;
        if Copy(s, 1, 13) = 'WeatherTable=' then begin
          txtWeatherTable.text := Trim((copy(s, 14, length(s))));
        end;
        if Copy(s, 1, 17) = 'WonMatchModifier=' then begin
          rgWonMatchMod.ItemIndex := FVal(copy(s, 18, 1)) - 1;
        end;
        if Copy(s, 1, 18) = 'TiedMatchModifier=' then begin
          rgTiedMatchMod.ItemIndex := FVal(copy(s, 19, 1));
        end;
        if Copy(s, 1, 21) = '4thEditionMightyBlow=' then begin
          cbMB4th.checked := (Copy(s, 22, 1) = 'Y');
        end;
        if Copy(s, 1, 20) = '4thEditionStandFirm=' then begin
          cbSF4th.checked := (Copy(s, 21, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'WildAnimal=' then begin
          rbWA.ItemIndex := FVal(copy(s, 12, 1));
        end;
        if Copy(s, 1, 10) = 'NoInjMods=' then begin
          cbNoInjMods.checked := (Copy(s, 11, 1) = 'Y');
        end;
        if Copy(s, 1, 15) = 'NewDivingCatch=' then begin
          cbDC.checked := (Copy(s, 16, 1) = 'Y');
        end;
        if Copy(s, 1, 23) = '4thEditionDivingTackle=' then begin
          cbDT4th.checked := (Copy(s, 24, 1) = 'Y');
        end;
        if Copy(s, 1, 18) = 'DivingTackleAfter=' then begin
          cbDTAfter.checked := (Copy(s, 19, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'PilingOn=' then begin
          rbPO.ItemIndex := FVal(copy(s, 10, 1));
        end;
        if Copy(s, 1, 27) = '4thEditionStarPlayerPoints=' then begin
          if Copy(s, 28, 1) = 'Y' then rgSkillRollsAt.ItemIndex := 1
                                  else rgSkillRollsAt.ItemIndex := 0;
        end;
        if Copy(s, 1, 9) = 'PBJumpUp=' then begin
          cbPBJumpUp.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'NoTZAssist=' then begin
          cbNoTZAssist.checked := (Copy(s, 12, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'Aging=' then begin
          rgAging.ItemIndex := FVal(copy(s, 7, 1));
        end;
        if Copy(s, 1, 9) = 'NiggleUp=' then begin
          cbNiggleUp.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'NiggleHalf=' then begin
          cbNiggleHalf.checked := (Copy(s, 12, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'MVPBench=' then begin
          cbMVPBench.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'LRBHorns=' then begin
          cbLRBHorns.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'SquarePassing=' then begin
          cbSquarePass.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'BHAssist=' then begin
          cbBHAssist.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'HalflingChefNew=' then begin
          cbHChefNew.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'DiagonalMove=' then begin
          cbDiagMove.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'SWRef=' then begin
          cbSWRef.checked := (Copy(s, 7, 1) = 'Y');
        end;
        if Copy(s, 1, 5) = 'LOS3=' then begin
          cbLOS.checked := (Copy(s, 6, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'WideZone=' then begin
          cbWideZone.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'Ruleof11=' then begin
          cbRuleof11.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'HGaze=' then begin
          rgHGaze.ItemIndex := FVal(copy(s, 7, 1));
        end;
        if Copy(s, 1, 14) = 'GoblinWeapons=' then begin
          cbGoblinWeapons.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'NoForcedMAandAG=' then begin
          cbNoForcedMAandAG.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 21) = '4thEditionBigGuyAlly=' then begin
          rgBGA4th.ItemIndex := FVal(copy(s, 22, 1));
        end;
        if Copy(s, 1, 20) = '4thEditionTentacles=' then begin
          cbTentacles4th.checked := (Copy(s, 21, 1) = 'Y');
        end;
        if Copy(s, 1, 22) = '4thEditionBreakTackle=' then begin
          cbBT4th.checked := (Copy(s, 23, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'WeakStunty=' then begin
          cbWeakStunty.checked := (Copy(s, 12, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'NiggleOnFour=' then begin
          cbNiggleOnFour.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 12) = 'ThrowStunty=' then begin
          cbThrowStunty.checked := (Copy(s, 13, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'CheerAC=' then begin
          cbCheerAC.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'UpApoth=' then begin
          cbUpApoth.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'Kicking=' then begin
          cbKicking.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'NoFieldGoals=' then begin
          cbNoFieldGoals.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'FFMinus1Per10=' then begin
          cbFFMinus1Per10.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'FFTrueDice=' then begin
          cbFFTrueDice.checked := (Copy(s, 12, 1) = 'Y');
        end;
        if Copy(s, 1, 12) = 'UseOtherSPP=' then begin
          cbUseOtherSPP.checked := (Copy(s, 13, 1) = 'Y');
        end;
        if Copy(s, 1, 7) = 'NoMVPs=' then begin
          cbNoMVPs.checked := (Copy(s, 8, 1) = 'Y');
        end;
        if Copy(s, 1, 7) = 'MVPEXP=' then begin
          cbMVPEXP.checked := (Copy(s, 8, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'EXPAgingPoint=' then begin
          txtEXPAgingPoint.text := (Copy(s, 15, 1));
        end;
        if Copy(s, 1, 9) = 'MVPValue=' then begin
          txtMVPValue.text := (Copy(s, 10, 1));
        end;
        if Copy(s, 1, 6) = 'EXPSI=' then begin
          cbEXPSI.checked := (Copy(s, 7, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'OnPitchTakeRoot=' then begin
          cbOPTakeRoot.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 28) = 'SeparateArmourAndInjuryRoll=' then begin
          cbSeparateARIR.checked := (Copy(s, 29, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'Banishment=' then begin
          cbBanishment.checked := (Copy(s, 12, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'Bless=' then begin
          cbBless.checked := (Copy(s, 7, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'Brittle=' then begin
          cbBrittle.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 12) = 'CrystalSkin=' then begin
          cbCrystalSkin.checked := (Copy(s, 13, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'DaemonicAura=' then begin
          cbDaemonicAura.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 4) = 'Dig=' then begin
          cbDig.checked := (Copy(s, 5, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'ElephantTrunk=' then begin
          cbElephantTrunk.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 12) = 'Firethrower=' then begin
          cbFirethrower.checked := (Copy(s, 13, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'Flyer=' then begin
          cbFlyer.checked := (Copy(s, 7, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'Fragile=' then begin
          cbFragile.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 10) = 'GFIInjury=' then begin
          cbGFIInjury.checked := (Copy(s, 11, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'HouseFlyHead=' then begin
          cbHouseFlyHead.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'Landing=' then begin
          cbLanding.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'PerfectSpiral=' then begin
          cbPerfectSpiral.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'PulledPunches=' then begin
          cbPulledPunches.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 10) = 'SingleEye=' then begin
          cbSingleEye.checked := (Copy(s, 11, 1) = 'Y');
        end;
        if Copy(s, 1, 10) = 'NullField=' then begin
          cbNullField.checked := (Copy(s, 11, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'ThirdEye=' then begin
          cbThirdEye.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 7) = 'Titchy=' then begin
          rgTitchy.ItemIndex := FVal(copy(s, 8, 1));
        end;
        if Copy(s, 1, 13) = 'WaaaghArmour=' then begin
          cbWaaaghArmour.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'BrightCrusaders=' then begin
          cbBrightCrusaders.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'EvilGits=' then begin
          cbEvilGits.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'VampireNecrarch=' then begin
          cbVampireNecrarch.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 15) = 'VampireLahmian=' then begin
          cbVampireLahmian.checked := (Copy(s, 16, 1) = 'Y');
        end;
        if Copy(s, 1, 15) = 'NurglesRotters=' then begin
          cbNurglesRotters.checked := (Copy(s, 16, 1) = 'Y');
        end;
        if Copy(s, 1, 10) = 'Hobgoblin=' then begin
          cbHobgoblin.checked := (Copy(s, 11, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'BiasedReferee=' then begin
          cbBiasedReferee.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'BearHug=' then begin
          cbBearHug.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 12) = 'BulletThrow=' then begin
          cbBulletThrow.checked := (Copy(s, 13, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'Butterfingers=' then begin
          cbButterfingers.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'Chill=' then begin
          cbChill.checked := (Copy(s, 7, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'Ethereal=' then begin
          cbEthereal.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'MaceTail=' then begin
          cbMaceTail.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 12) = 'PitchPlayer=' then begin
          cbPitchPlayer.checked := (Copy(s, 13, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'ThrowBigBomb=' then begin
          cbThrowBigBomb.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 14) = 'ThrowFireball=' then begin
          cbThrowFireball.checked := (Copy(s, 15, 1) = 'Y');
        end;
        if Copy(s, 1, 9) = 'ThrowNet=' then begin
          cbThrowNet.checked := (Copy(s, 10, 1) = 'Y');
        end;
        if Copy(s, 1, 15) = 'ThrowStinkBomb=' then begin
          cbThrowStinkBomb.checked := (Copy(s, 16, 1) = 'Y');
        end;
        if Copy(s, 1, 7) = 'WarCry=' then begin
          cbWarCry.checked := (Copy(s, 8, 1) = 'Y');
        end;
        if Copy(s, 1, 6) = 'Wings=' then begin
          cbWings.checked := (Copy(s, 7, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'FAProne=' then begin
          cbFoulApp.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 7) = 'DeStun=' then begin
          cbDeStun.checked := (Copy(s, 8, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'FieldGoal1Point=' then begin
          cbFG1PT.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 17) = 'Freeboot Wizards=' then begin
          cbWizards.checked := (Copy(s, 18, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'OnPitch Wizards=' then begin
          cbOnPitchSpellcasters.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 18) = 'Negative Winnings=' then begin
          cbNegativeWinnings.checked := (Copy(s, 19, 1) = 'Y');
        end;
        if Copy(s, 1, 16) = 'Freeboot Apoths=' then begin
          cbApoths.checked := (Copy(s, 17, 1) = 'Y');
        end;
        if Copy(s, 1, 11) = 'PassFumble=' then begin
          rgPassFumble.ItemIndex := FVal(copy(s, 12, 1));
        end;
        if Copy(s, 1, 5) = 'PGFI=' then begin
          cbPGFI.checked := (Copy(s, 6, 1) = 'Y');
        end;
        if Copy(s, 1, 8) = 'LateInt=' then begin
          cbLateInt.checked := (Copy(s, 9, 1) = 'Y');
        end;
        if Copy(s, 1, 13) = 'CardsIniFile=' then begin
          txtCardsIniFile.text := Copy(s, 14, Length(s) - 13);
        end;
        if Copy(s, 1, 16) = 'HandicapIniFile=' then begin
          txtHandicapIniFile.text := Copy(s, 17, Length(s) - 16);
        end;
        if Copy(s, 1, 15) = 'FieldImageFile=' then begin
          txtFieldImageFile.text := Copy(s, 16, Length(s) - 15);
        end;
        if Copy(s, 1, 13) = 'WeatherPitch=' then begin
          cbWeatherPitch.checked := (Copy(s, 14, 1) = 'Y');
        end;
        if Copy(s, 1, 7) = 'LRB4KO=' then begin
          cbLRB4KO.checked := (Copy(s, 8, 1) = 'Y');
        end;
      end;
    end;
    CloseFile(ff);
    if cmbLeague.Items[cmbLeague.ItemIndex] = 'LUSTRIAN' then begin
      txtWeatherTable.text := LustrianRoll;
      txtKOTable.text := LustrianRoll2;
      if txtWeatherTable.text = 'W3' then txtFieldImageFile.text := 'sdField.jpg' else
      if txtWeatherTable.text = 'W4' then txtFieldImageFile.text := 'jrsField.jpg' else
      if txtWeatherTable.text = 'W5' then txtFieldImageFile.text := 'ssField.jpg' else
      if txtWeatherTable.text = 'W6' then txtFieldImageFile.text := 'acField.jpg' else
      if txtWeatherTable.text = 'W7' then txtFieldImageFile.text := 'mpField.jpg' else
      if txtWeatherTable.text = 'W8' then txtFieldImageFile.text := 'uspField.jpg' else
      if txtWeatherTable.text = 'W9' then txtFieldImageFile.text := 'naField.jpg' else
      if txtWeatherTable.text = 'W10' then txtFieldImageFile.text := 'tbField.jpg';
      if txtWeatherTable.Text = 'W7' then cbBlackIce.Checked := True;
      if txtWeatherTable.Text = 'W9' then cbBlackIce.Checked := True;
      if txtWeatherTable.Text = 'W5' then cbBlackIce.Checked := True;
      if txtWeatherTable.Text = 'W10' then cbBlackIce.checked := True;
    end;
  {end;}
end;

procedure TfrmSettings.butHomeColorChangeClick(Sender: TObject);
var t: string;
begin
  cdColorDialog.Color := TeamTextColor[0];
  cdColorDialog.Execute;
  FillColorArray(0, cdColorDialog.Color);
  lblHomeColor.Color := TeamTextColor[0];
  RepaintColor(0);
  t := 'g0' + ColorToString(TeamTextColor[0]);
  LogWrite(t);
end;

procedure TfrmSettings.butAwayColorChangeClick(Sender: TObject);
var t: string;
begin
  cdColorDialog.Color := TeamTextColor[1];
  cdColorDialog.Execute;
  FillColorArray(1, cdColorDialog.Color);
  lblAwayColor.Color := TeamTextColor[1];
  RepaintColor(1);
  t := 'g1' + ColorToString(TeamTextColor[1]);
  LogWrite(t);
end;

procedure TfrmSettings.Button1Click(Sender: TObject);
var g: integer;
    t: string;
begin
  for g := 0 to 1 do begin
    FillColorArray(g, OrgTeamTextColor[g]);
    RepaintColor(g);
  end;
  lblHomeColor.Color := TeamTextColor[0];
  lblAwayColor.Color := TeamTextColor[1];
  t := 'g0' + ColorToString(TeamTextColor[0]);
  LogWrite(t);
  t := 'g1' + ColorToString(TeamTextColor[1]);
  LogWrite(t);
end;

procedure TfrmSettings.butSelectFileClick(Sender: TObject);
var s: string;
    LRoll: integer;
begin
  dlgPic.InitialDir := curdir + 'images\';
  dlgPic.Filename := '';
  dlgPic.Options := [ofFileMustExist];
  dlgPic.Execute;
  if dlgPic.Filename <> '' then begin
    s := dlgPic.Filename;
    while Pos('images\', s) > 0 do s := Copy(s, Pos('images\', s) + 7, Length(s));
    if FileExists(curdir + 'images\' + s) then begin
      txtFieldImageFile.text := s;
    end else begin
      ShowMessage('Field image must be put in directory ' + curdir + 'images');
    end;
  end;
  if cmbLeague.Items[cmbLeague.ItemIndex] = 'LUSTRIAN' then begin
    cbBlackIce.Checked := False;
    if txtFieldImageFile.text = 'sdField.jpg' then LRoll := 3 else
    if txtFieldImageFile.text = 'jrsField.jpg' then LRoll := 4 else
    if txtFieldImageFile.text = 'ssField.jpg' then LRoll := 5 else
    if txtFieldImageFile.text = 'acField.jpg' then LRoll := 6 else
    if txtFieldImageFile.text = 'mpField.jpg' then LRoll := 7 else
    if txtFieldImageFile.text = 'uspField.jpg' then LRoll := 8 else
    if txtFieldImageFile.text = 'naField.jpg' then LRoll := 9 else
    if txtFieldImageFile.text = 'tbField.jpg' then LRoll := 10 else
    if txtFieldImageFile.text = 'lcField.jpg' then LRoll := 11 else
    if txtFieldImageFile.text = 'rcpField.jpg' then LRoll := 12 else
    if txtFieldImageFile.text = 'saField.jpg' then LRoll := 13 else
    if txtFieldImageFile.text = 'ppField.jpg' then LRoll := 14;

    LustrianRoll := 'W'+ InttoStr(LRoll);
    LustrianRoll2 := 'KO' + InttoStr(LRoll);
    txtWeatherTable.text := LustrianRoll;
    txtKOTable.text := LustrianRoll2;
    if txtWeatherTable.Text = 'W7' then cbBlackIce.Checked := True;
    if txtWeatherTable.Text = 'W9' then cbBlackIce.Checked := True;
    if txtWeatherTable.Text = 'W5' then cbBlackIce.Checked := True;
    if txtWeatherTable.Text = 'W10' then cbBlackIce.checked := True;
  end;
end;

end.