program pbembb25;

uses
  Forms,
  unitSettings in 'unitSettings.pas' {frmSettings},
  bbunit in 'bbunit.pas' {Bloodbowl},
  unitLog in 'unitLog.pas' {frmLog},
  unitRoster in 'unitRoster.pas' {frmRoster},
  unitAbout in 'unitAbout.pas' {frmAbout},
  unitArmourRoll in 'unitArmourRoll.pas' {frmArmourRoll},
  unitCards in 'unitCards.pas' {frmCards},
  unitNotes in 'unitNotes.pas' {frmNotes},
  unitLogControl in 'unitLogControl.pas' {frmLogControl},
  unitDodgeRoll in 'unitDodgeRoll.pas' {frmDodgeRoll},
  unitPlayerStatsChange in 'unitPlayerStatsChange.pas' {frmPlayerStatsChange},
  unitThrowIn in 'unitThrowIn.pas' {frmThrowIn},
  unitWelcome in 'unitWelcome.pas' {frmWelcome},
  unitPregame in 'unitPregame.pas',
  unitFanFactor in 'unitFanFactor.pas' {frmFanFactor},
  unitCheckFile in 'unitCheckFile.pas',
  unitField in 'unitField.pas',
  unitRandom in 'unitRandom.pas',
  unitPass in 'unitPass.pas' {frmPass},
  unitLanding in 'unitLanding.pas' {frmLanding},
  unitPickUp in 'unitPickUp.pas' {frmPickUp},
  unitAddPlayer in 'unitAddPlayer.pas' {frmAddPlayer},
  unitPostgameSeq in 'unitPostgameSeq.pas' {frmPostgame},
  unitSkillRoll in 'unitSkillRoll.pas' {frmSkillRolls},
  unitGFI in 'unitGFI.pas' {frmGFI},
  unitThrowTeamMate in 'unitThrowTeamMate.pas' {frmTTM},
  unitCatch in 'unitCatch.pas' {frmCatch},
  unitMessage in 'unitMessage.pas' {frmMessage},
  unitMachineID in 'unitMachineID.pas' {MachID},
  unitLanguage in 'unitLanguage.pas',
  unitThrowStuff in 'unitThrowStuff.pas' {frmThrowStuff},
  unitCatchStuff in 'unitCatchStuff.pas' {frmCatchStuff},
  weather in 'weather.pas',
  gate in 'gate.pas',
  logPlayback in 'logPlayback.pas',
  unitTurnChange in 'unitTurnChange.pas',
  bbalg in 'bbalg.pas',
  unitBall in 'unitBall.pas',
  unitMarker in 'unitMarker.pas',
  unitPlayAction in 'unitPlayAction.pas',
  unitPlayer in 'unitPlayer.pas',
  unitTeam in 'unitTeam.pas',
  unitExtern in 'unitExtern.pas',
  apothecary in 'apothecary.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Bloodbowl PBEM Tool';
  Application.CreateForm(TfrmWelcome, frmWelcome);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TBloodbowl, Bloodbowl);
  Application.CreateForm(TfrmLog, frmLog);
  Application.CreateForm(TfrmRoster, frmRoster);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmArmourRoll, frmArmourRoll);
  Application.CreateForm(TfrmCards, frmCards);
  Application.CreateForm(TfrmNotes, frmNotes);
  Application.CreateForm(TfrmLogControl, frmLogControl);
  Application.CreateForm(TfrmDodgeRoll, frmDodgeRoll);
  Application.CreateForm(TfrmPlayerStatsChange, frmPlayerStatsChange);
  Application.CreateForm(TfrmThrowIn, frmThrowIn);
  Application.CreateForm(TfrmFanFactor, frmFanFactor);
  Application.CreateForm(TfrmPass, frmPass);
  Application.CreateForm(TfrmLanding, frmLanding);
  Application.CreateForm(TfrmPickUp, frmPickUp);
  Application.CreateForm(TfrmAddPlayer, frmAddPlayer);
  Application.CreateForm(TfrmPostgame, frmPostgame);
  Application.CreateForm(TfrmSkillRolls, frmSkillRolls);
  Application.CreateForm(TfrmGFI, frmGFI);
  Application.CreateForm(TfrmTTM, frmTTM);
  Application.CreateForm(TfrmCatch, frmCatch);
  Application.CreateForm(TfrmMessage, frmMessage);
  Application.CreateForm(TMachID, MachID);
  Application.CreateForm(TfrmThrowStuff, frmThrowStuff);
  Application.CreateForm(TfrmCatchStuff, frmCatchStuff);
  LanguageInit;

  Application.Run;
end.
