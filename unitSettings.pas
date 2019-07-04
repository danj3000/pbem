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
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
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
    GroupBox2: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Button1: TButton;
    lblHomeColor: TLabel;
    lblAwayColor: TLabel;
    butHomeColorChange: TButton;
    butAwayColorChange: TButton;
    cdColorDialog: TColorDialog;
    TabSheet9: TTabSheet;
    Label17: TLabel;
    txtCardsIniFile: TEdit;
    Label24: TLabel;
    txtHandicapIniFile: TEdit;
    lblLustrian: TLabel;
    rgCardSystem: TRadioGroup;
    butSelectFile: TButton;
    dlgPic: TOpenDialog;
    cbPassingRangesColored: TCheckBox;
    cbBlackIce: TCheckBox;
    rbPO: TRadioGroup;
    cbWeatherPitch: TCheckBox;
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
var f: integer;
begin
  for f := 1 to frmSettings.pcSettings.PageCount - 1 do
                frmSettings.pcSettings.Pages[f].Enabled := false;
  frmSettings.cmbLeague.enabled := false;
  frmSettings.butAccept.visible := false;
  frmSettings.lblCantChange.visible := true;

  frmArmourRoll.txtDPArmMod.text := '+' + bbalg.DirtyPlayerArmourModifier.ToString;
  frmArmourRoll.txtDPInjMod.text := '+' + bbalg.DirtyPlayerInjuryModifier.ToString;

  FillKOTable;
  FillWTable;
  frmCards.InitForm;
  frmRoster.InitForm;

  begin
    Bloodbowl.sbOtherSPP.Visible := false;
    Bloodbowl.OtherSPP1.visible := false;
    Bloodbowl.RemoveOther1.Visible := false;
  end;


  Bloodbowl.sbEXP.Visible := false;
  Bloodbowl.EXP1.visible := false;
  Bloodbowl.RemoveEXP1.visible := false;


  if frmSettings.rgCardSystem.ItemIndex >= 3 then begin
    Bloodbowl.butCardsBlue.visible := false;
    Bloodbowl.butCardsRed.visible := false;
  end else begin
    Bloodbowl.butMakeHandicapRolls.visible := false;
  end;

  begin
    BloodBowl.MakeKickRoll1.Visible := false;
    BloodBowl.DirtyKick1.Visible := false;
    BloodBowl.Punt1.Visible := false;
  end;

  ShowFieldImage(frmSettings.txtFieldImageFile.text);

  if (frmSettings.txtHandicapIniFile.text <> 'bbhandicap.ini') and
   (frmSettings.txtHandicapIniFile.text <> '') then
     OtherHandicapSetup;

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
//  frmSettings.cbMB4th.checked := (s[1] = 'M');
//  frmSettings.cbSF4th.checked := (s[2] = 'S');
//  frmSettings.rbWA.ItemIndex := Ord(s[3]) - 48;
//  frmSettings.cbDT4th.checked := (s[4] = 'D');
//  frmSettings.cbTentacles4th.checked := (s[5] = 'T');
//  frmSettings.cbBT4th.checked := (s[6] = 'B');
  frmSettings.rbPO.ItemIndex := Ord(s[7]) - 48;
//  frmSettings.rgBGA4th.ItemIndex := Ord(s[8]) - 48;
//  frmSettings.cbDTAfter.checked := (s[9] = 'A');
  GetText;

  GetText;
//  frmSettings.rgSkillRollsAt.ItemIndex := Ord(s[1]) - 48;
//  frmSettings.cbNoForcedMAandAG.checked := (s[3] = 'F');
//  frmSettings.cbCheerAC.checked := (s[4] = 'S');
//  frmSettings.cbNoMVPs.checked := (s[5] = 'M');
//  frmSettings.cbNiggleUp.checked := (s[6] = 'N');
//  frmSettings.cbBanishment.checked := (s[7] = 'B');
//  frmSettings.cbBless.checked := (s[8] = 'L');
//  frmSettings.cbBrittle.checked := (s[9] = 'R');
//  frmSettings.cbCrystalSkin.checked := (s[10] = 'C');
//  frmSettings.cbDaemonicAura.checked := (s[11] = 'D');
//  frmSettings.cbElephantTrunk.checked := (s[12] = 'E');
//  frmSettings.cbFragile.checked := (s[13] = 'P');
//  frmSettings.cbGFIInjury.checked := (s[14] = 'G');
//  frmSettings.cbHouseFlyHead.checked := (s[15] = 'H');
//  frmSettings.cbPerfectSpiral.checked := (s[16] = 'I');
//  frmSettings.cbPulledPunches.checked := (s[17] = 'J');
//  frmSettings.cbSingleEye.checked := (s[18] = 'K');
//  frmSettings.cbNullField.checked := (s[19] = 'O');
//  frmSettings.cbThirdEye.checked := (s[20] = 'T');
  //frmSettings.rgTitchy.ItemIndex := Ord(s[21]) - 48;
//  frmSettings.cbWaaaghArmour.checked := (s[22] = 'W');
//  frmSettings.cbBrightCrusaders.checked := (s[23] = 'X');
//  frmSettings.cbEvilGits.checked := (s[24] = 'U');
//  frmSettings.cbVampireNecrarch.checked := (s[25] = 'V');
//  frmSettings.cbVampireLahmian.checked := (s[26] = 'Y');
//  frmSettings.cbNurglesRotters.checked := (s[27] = 'Z');
//  frmSettings.cbHobgoblin.checked := (s[28] = 'A');
//  frmSettings.cbBiasedReferee.checked := (s[29] = 'C');
//  frmSettings.cbBearHug.checked := (s[30] = 'D');
//  frmSettings.cbBulletThrow.checked := (s[31] = 'E');
//  frmSettings.cbChill.checked := (s[32] = 'F');
//  frmSettings.cbEthereal.checked := (s[33] = 'G');
//  frmSettings.cbMaceTail.checked := (s[34] = 'H');
//  frmSettings.cbPitchPlayer.checked := (s[35] = 'I');
//  frmSettings.cbThrowBigBomb.checked := (s[36] = 'J');
//  frmSettings.cbThrowFireball.checked := (s[37] = 'K');
//  frmSettings.cbThrowNet.checked := (s[38] = 'L');
//  frmSettings.cbThrowStinkBomb.checked := (s[39] = 'M');
//  frmSettings.cbWarCry.checked := (s[40] = 'N');
//  frmSettings.cbWings.checked := (s[41] = 'O');
//  frmSettings.cbThrowStunty.checked := (s[42] = 'P');
//  frmSettings.cbFlyer.checked := (s[43] = 'Q');
//  frmSettings.cbLanding.checked := (s[44] = 'R');
//  frmSettings.cbKicking.checked := (s[45] = 'S');
//  frmSettings.cbNiggleHalf.checked := (s[46] = 'T');
//  frmSettings.cbMVPBench.checked := (s[47] = 'U');
  //frmSettings.cbWizards.checked := (s[49] = 'W');
//  frmSettings.rgPassFumble.ItemIndex := Ord(s[50]) - 48;
//  frmSettings.cbPGFI.checked := (s[51] = 'X');
//  frmSettings.cbLateInt.checked := (s[52] = 'Y');
//  frmSettings.cbDig.checked := (s[53] = 'Z');
//  frmSettings.cbButterfingers.checked := (s[54] = 'A');
//  frmSettings.cbFoulApp.checked := (s[55] = 'B');
//  frmSettings.cbFG1PT.checked := (s[56] = 'C');
//  frmSettings.cbOPTakeRoot.checked := (s[61] = 'F');
  frmSettings.cbBlackIce.Checked := (s[62] = 'G');
//  frmSettings.cbSquarePass.checked := (s[63] = 'H');
//  frmSettings.cbBHAssist.checked := (s[64] = 'I');
//  frmSettings.cbHChefNew.checked := (s[65] = 'J');
//  frmSettings.cbDiagMove.checked := (s[66] = 'K');
//  frmSettings.cbSWRef.checked := (s[67] = 'L');
//  frmSettings.cbGoblinWeapons.checked := (s[68] = 'M');
//  frmSettings.cbNoFieldGoals.checked := (s[69] = 'N');
//  frmSettings.cbOnPitchSpellcasters.checked := (s[70] = 'O');
//  frmSettings.cbNegativeWinnings.checked := (s[71] = 'P');
//  frmSettings.cbNoInjMods.checked := (s[73] = 'R');
//  frmSettings.cbFirethrower.checked := (s[74] = 'S');
  GetText;
//  frmSettings.rgWonMatchMod.ItemIndex := Ord(s[1]) - 48;
//  frmSettings.rgTiedMatchMod.ItemIndex := Ord(s[2]) - 48;
//  frmSettings.cbFFMinus1Per10.checked := (s[3] = 'M');
//  frmSettings.cbFFTrueDice.checked := (s[4] = 'T');
//  frmSettings.rgHGaze.ItemIndex := Ord(s[5]) - 48;
//  frmSettings.cbLOS.checked := (s[6] = 'L');
  frmSettings.cbWeatherPitch.checked := (s[7] = 'W');
//  frmSettings.cbWideZone.checked := (s[8] = 'Z');
//  frmSettings.cbRuleof11.checked := (s[9] = 'R');
  frmSettings.cbLRB4KO.Checked := (s[10] = 'K');
  frmSettings.cbDeStun.checked := (s[11] = 'S');
  frmSettings.cbDC.Checked := (s[12] = 'D');
  GetText;
//  frmSettings.txtRegenRollNeeded.text := s[1];
//  frmSettings.cbPBJumpUp.checked := (s[2] = 'J');
//  frmSettings.cbWeakStunty.checked := (s[3] = 'W');
//  frmSettings.cbNiggleOnFour.checked := (s[4] = 'N');
//  frmSettings.cbNoTZAssist.checked := (s[5] = 'A');
//  frmSettings.cbUpApoth.checked := (s[6] = 'U');
  frmSettings.rgCardSystem.ItemIndex := Ord(s[7]) - 48;
  GetText;
  frmSettings.txtCardsIniFile.text := GetText;
  frmSettings.txtHandicapIniFile.text := GetText;
  frmSettings.txtFieldImageFile.text := GetText;
//  frmSettings.cbUseOtherSPP.checked := (s[1] = 'O');
//  frmSettings.cbSeparateARIR.checked := (s[2] = 'S');
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
  st := st + 'M';
  st := st + 'S';
  st := st + Chr(48 + 2);    // Wild animal
  st := st + 'D';
  st := st + 'T';
  st := st + 'B';
  st := st + Chr(48 + rbPO.ItemIndex);
  st := st + Chr(48 + 3);
  st := st + 'A';
  st := st + '*';
  st := st + '2';

  st := st + '5';   // foul rule 5 (always)
  st := st + ' ';
  st := st + '*';
  st := st + Chr(48 + 2);
  st := st + Chr(48);
  st := st + 'F';
  st := st + '.';
  st := st + '.';  // noMVPs
  st := st + 'N'; // niggle up
  st := st + '.';
   st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';


  st := st + '.';
  st := st + '.';

  st := st + Chr(48 + 2);
  st := st + '.';

  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
    st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
    st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';    // niggles at half time
  st := st + 'U';    // unused can get mvp
  st := st + 'V';    // horns 2nd block
   st := st + '.';   // wizard freebooters
  st := st + Chr(48 + 0);  // fumbles
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';

  st := st + 'B';       // foul prone
  st := st + '.';
  st := st + '.';     // was mvpexp
  st := st + MVPValue.ToString;
  st := st + '9';
  st := st + '.';
  st := st + 'F'; // take root on pitch
  if cbBlackIce.checked then st := st + 'G' else st := st + '.';
  st := st + 'H' ;  // squares for passing range
  st := st + 'I'; // boneheads help really stupid
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';
  st := st + '.';   // negative winnings
  st := st + '.';   // apoth
  st := st + '.';
  st := st + '.';

  st := st + '*';
  st := st + Chr(48 + 0);
  st := st + Chr(48 + 1);
  st := st + '.';        // fan factor modifier > 10
  st := st + '.';        // 'true dice?'
  st := st + Chr(48 + 2);    // hypnogaze
  st := st + 'L' ; // LOS 3
  if cbWeatherPitch.checked then st := st + 'W' else st := st + '.';
  st := st + 'Z'; // widezone limit
  st := st + 'R'; // 11 men
  if cbLRB4KO.Checked then st := st + 'K' else st := st + '.';
  if cbDeStun.Checked then st := st + 'S' else st := st + '.';
  if cbDC.Checked then st := st + 'D' else st := st + '.';
  st := st + '*';
  st := st + bbalg.RegenRollNeeded.ToString();
  st := st + '.';
  st := st + 'W'; // stunty penalties
  st := st + '.';   // 41-6 niggling injury
  st := st + '.';
  st := st + '.';
  st := st + Chr(48 + rgCardSystem.ItemIndex);
  st := st + '*' + Trim(txtCardsIniFile.text);
  st := st + '*' + Trim(txtHandicapIniFile.text);
  st := st + '*' + Trim(txtFieldImageFile.text) + '*';
  st := st + '.';
  st := st + 'S'; // separate inj/arm rolls
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
        if Copy(s, 1, 11) = 'CardSystem=' then begin
          rgCardSystem.ItemIndex := FVal(copy(s, 12, 1)) - 1;
        end;
//        if Copy(s, 1, 16) = 'RegenRollNeeded=' then begin
//          txtRegenRollNeeded.text := copy(s, 17, 1);
//        end;
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
//        if Copy(s, 1, 17) = 'WonMatchModifier=' then begin
//          rgWonMatchMod.ItemIndex := FVal(copy(s, 18, 1)) - 1;
//        end;
//        if Copy(s, 1, 18) = 'TiedMatchModifier=' then begin
//          rgTiedMatchMod.ItemIndex := FVal(copy(s, 19, 1));
//        end;
//        if Copy(s, 1, 21) = '4thEditionMightyBlow=' then begin
//          cbMB4th.checked := (Copy(s, 22, 1) = 'Y');
//        end;
//        if Copy(s, 1, 20) = '4thEditionStandFirm=' then begin
//          cbSF4th.checked := (Copy(s, 21, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'WildAnimal=' then begin
//          rbWA.ItemIndex := FVal(copy(s, 12, 1));
//        end;
//        if Copy(s, 1, 10) = 'NoInjMods=' then begin
//          cbNoInjMods.checked := (Copy(s, 11, 1) = 'Y');
//        end;
        if Copy(s, 1, 15) = 'NewDivingCatch=' then begin
          cbDC.checked := (Copy(s, 16, 1) = 'Y');
        end;
//        if Copy(s, 1, 23) = '4thEditionDivingTackle=' then begin
//          cbDT4th.checked := (Copy(s, 24, 1) = 'Y');
//        end;
//        if Copy(s, 1, 18) = 'DivingTackleAfter=' then begin
//          cbDTAfter.checked := (Copy(s, 19, 1) = 'Y');
//        end;
        if Copy(s, 1, 9) = 'PilingOn=' then begin
          rbPO.ItemIndex := FVal(copy(s, 10, 1));
        end;
//        if Copy(s, 1, 27) = '4thEditionStarPlayerPoints=' then begin
//          if Copy(s, 28, 1) = 'Y' then rgSkillRollsAt.ItemIndex := 1
//                                  else rgSkillRollsAt.ItemIndex := 0;
//        end;
//        if Copy(s, 1, 9) = 'PBJumpUp=' then begin
//          cbPBJumpUp.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'NoTZAssist=' then begin
//          cbNoTZAssist.checked := (Copy(s, 12, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'NiggleUp=' then begin
//          cbNiggleUp.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'NiggleHalf=' then begin
//          cbNiggleHalf.checked := (Copy(s, 12, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'MVPBench=' then begin
//          cbMVPBench.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'LRBHorns=' then begin
          // cbLRBHorns.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'SquarePassing=' then begin
//          cbSquarePass.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'BHAssist=' then begin
//          cbBHAssist.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 16) = 'HalflingChefNew=' then begin
//          cbHChefNew.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 13) = 'DiagonalMove=' then begin
//          cbDiagMove.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 6) = 'SWRef=' then begin
//          cbSWRef.checked := (Copy(s, 7, 1) = 'Y');
//        end;
//        if Copy(s, 1, 5) = 'LOS3=' then begin
//          cbLOS.checked := (Copy(s, 6, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'WideZone=' then begin
//          cbWideZone.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'Ruleof11=' then begin
//          cbRuleof11.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 6) = 'HGaze=' then begin
//          rgHGaze.ItemIndex := FVal(copy(s, 7, 1));
//        end;
//        if Copy(s, 1, 14) = 'GoblinWeapons=' then begin
//          cbGoblinWeapons.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 16) = 'NoForcedMAandAG=' then begin
//          cbNoForcedMAandAG.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 21) = '4thEditionBigGuyAlly=' then begin
//          rgBGA4th.ItemIndex := FVal(copy(s, 22, 1));
//        end;
//        if Copy(s, 1, 20) = '4thEditionTentacles=' then begin
//          cbTentacles4th.checked := (Copy(s, 21, 1) = 'Y');
//        end;
//        if Copy(s, 1, 22) = '4thEditionBreakTackle=' then begin
//          cbBT4th.checked := (Copy(s, 23, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'WeakStunty=' then begin
//          cbWeakStunty.checked := (Copy(s, 12, 1) = 'Y');
//        end;
//        if Copy(s, 1, 13) = 'NiggleOnFour=' then begin
//          cbNiggleOnFour.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 12) = 'ThrowStunty=' then begin
//          cbThrowStunty.checked := (Copy(s, 13, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'CheerAC=' then begin
//          cbCheerAC.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'UpApoth=' then begin
//          cbUpApoth.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'Kicking=' then begin
//          cbKicking.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 13) = 'NoFieldGoals=' then begin
//          cbNoFieldGoals.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'FFMinus1Per10=' then begin
//          cbFFMinus1Per10.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'FFTrueDice=' then begin
//          cbFFTrueDice.checked := (Copy(s, 12, 1) = 'Y');
//        end;
//        if Copy(s, 1, 12) = 'UseOtherSPP=' then begin
//          cbUseOtherSPP.checked := (Copy(s, 13, 1) = 'Y');
//        end;
//        if Copy(s, 1, 7) = 'NoMVPs=' then begin
//          cbNoMVPs.checked := (Copy(s, 8, 1) = 'Y');
//        end;

//        if Copy(s, 1, 16) = 'OnPitchTakeRoot=' then begin
//          cbOPTakeRoot.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 28) = 'SeparateArmourAndInjuryRoll=' then begin
//          cbSeparateARIR.checked := (Copy(s, 29, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'Banishment=' then begin
//          cbBanishment.checked := (Copy(s, 12, 1) = 'Y');
//        end;
//        if Copy(s, 1, 6) = 'Bless=' then begin
//          cbBless.checked := (Copy(s, 7, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'Brittle=' then begin
//          cbBrittle.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 12) = 'CrystalSkin=' then begin
//          cbCrystalSkin.checked := (Copy(s, 13, 1) = 'Y');
//        end;
//        if Copy(s, 1, 13) = 'DaemonicAura=' then begin
//          cbDaemonicAura.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 4) = 'Dig=' then begin
//          cbDig.checked := (Copy(s, 5, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'ElephantTrunk=' then begin
//          cbElephantTrunk.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 12) = 'Firethrower=' then begin
//          cbFirethrower.checked := (Copy(s, 13, 1) = 'Y');
//        end;
//        if Copy(s, 1, 6) = 'Flyer=' then begin
//          cbFlyer.checked := (Copy(s, 7, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'Fragile=' then begin
//          cbFragile.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 10) = 'GFIInjury=' then begin
//          cbGFIInjury.checked := (Copy(s, 11, 1) = 'Y');
//        end;
//        if Copy(s, 1, 13) = 'HouseFlyHead=' then begin
//          cbHouseFlyHead.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'Landing=' then begin
//          cbLanding.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'PerfectSpiral=' then begin
//          cbPerfectSpiral.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'PulledPunches=' then begin
//          cbPulledPunches.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 10) = 'SingleEye=' then begin
//          cbSingleEye.checked := (Copy(s, 11, 1) = 'Y');
//        end;
//        if Copy(s, 1, 10) = 'NullField=' then begin
//          cbNullField.checked := (Copy(s, 11, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'ThirdEye=' then begin
//          cbThirdEye.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 7) = 'Titchy=' then begin
//          rgTitchy.ItemIndex := FVal(copy(s, 8, 1));
//        end;
//        if Copy(s, 1, 13) = 'WaaaghArmour=' then begin
//          cbWaaaghArmour.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 16) = 'BrightCrusaders=' then begin
//          cbBrightCrusaders.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'EvilGits=' then begin
//          cbEvilGits.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 16) = 'VampireNecrarch=' then begin
//          cbVampireNecrarch.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 15) = 'VampireLahmian=' then begin
//          cbVampireLahmian.checked := (Copy(s, 16, 1) = 'Y');
//        end;
//        if Copy(s, 1, 15) = 'NurglesRotters=' then begin
//          cbNurglesRotters.checked := (Copy(s, 16, 1) = 'Y');
//        end;
//        if Copy(s, 1, 10) = 'Hobgoblin=' then begin
//          cbHobgoblin.checked := (Copy(s, 11, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'BiasedReferee=' then begin
//          cbBiasedReferee.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'BearHug=' then begin
//          cbBearHug.checked := (Copy(s, 9, 1) = 'Y');
//        end;
//        if Copy(s, 1, 12) = 'BulletThrow=' then begin
//          cbBulletThrow.checked := (Copy(s, 13, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'Butterfingers=' then begin
//          cbButterfingers.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 6) = 'Chill=' then begin
//          cbChill.checked := (Copy(s, 7, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'Ethereal=' then begin
//          cbEthereal.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'MaceTail=' then begin
//          cbMaceTail.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 12) = 'PitchPlayer=' then begin
//          cbPitchPlayer.checked := (Copy(s, 13, 1) = 'Y');
//        end;
//        if Copy(s, 1, 13) = 'ThrowBigBomb=' then begin
//          cbThrowBigBomb.checked := (Copy(s, 14, 1) = 'Y');
//        end;
//        if Copy(s, 1, 14) = 'ThrowFireball=' then begin
//          cbThrowFireball.checked := (Copy(s, 15, 1) = 'Y');
//        end;
//        if Copy(s, 1, 9) = 'ThrowNet=' then begin
//          cbThrowNet.checked := (Copy(s, 10, 1) = 'Y');
//        end;
//        if Copy(s, 1, 15) = 'ThrowStinkBomb=' then begin
//          cbThrowStinkBomb.checked := (Copy(s, 16, 1) = 'Y');
//        end;
//        if Copy(s, 1, 7) = 'WarCry=' then begin
//          cbWarCry.checked := (Copy(s, 8, 1) = 'Y');
//        end;
//        if Copy(s, 1, 6) = 'Wings=' then begin
//          cbWings.checked := (Copy(s, 7, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'FAProne=' then begin
//          cbFoulApp.checked := (Copy(s, 9, 1) = 'Y');
//        end;
        if Copy(s, 1, 7) = 'DeStun=' then begin
          cbDeStun.checked := (Copy(s, 8, 1) = 'Y');
        end;
//        if Copy(s, 1, 16) = 'FieldGoal1Point=' then begin
//          cbFG1PT.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 17) = 'Freeboot Wizards=' then begin
//          cbWizards.checked := (Copy(s, 18, 1) = 'Y');
//        end;
//        if Copy(s, 1, 16) = 'OnPitch Wizards=' then begin
//          cbOnPitchSpellcasters.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 18) = 'Negative Winnings=' then begin
//          cbNegativeWinnings.checked := (Copy(s, 19, 1) = 'Y');
//        end;
//        if Copy(s, 1, 16) = 'Freeboot Apoths=' then begin
//          cbApoths.checked := (Copy(s, 17, 1) = 'Y');
//        end;
//        if Copy(s, 1, 11) = 'PassFumble=' then begin
//          rgPassFumble.ItemIndex := FVal(copy(s, 12, 1));
//        end;
//        if Copy(s, 1, 5) = 'PGFI=' then begin
//          cbPGFI.checked := (Copy(s, 6, 1) = 'Y');
//        end;
//        if Copy(s, 1, 8) = 'LateInt=' then begin
//          cbLateInt.checked := (Copy(s, 9, 1) = 'Y');
//        end;
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
