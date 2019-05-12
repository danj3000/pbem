program pbembb25;

uses
  Forms,
  unitSettings in 'unitSettings.pas' {frmSettings},
  bbunit in 'bbunit.pas' {Bloodbowl},
  bbalg in 'bbalg.pas' {modAlg: TDataModule},
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
  unitPlayer in 'unitPlayer.pas' {modPlayer: TDataModule},
  unitPlayAction in 'unitPlayAction.pas' {modPlayAction: TDataModule},
  unitTurnChange in 'unitTurnChange.pas' {modTurnChange: TDataModule},
  unitExtern in 'unitExtern.pas' {modExtern: TDataModule},
  unitMarker in 'unitMarker.pas' {modMarker: TDataModule},
  unitBall in 'unitBall.pas' {modBall: TDataModule},
  unitTeam in 'unitTeam.pas' {modTeam: TDataModule},
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
  unitHandicapTable in 'unitHandicapTable.pas' {frmHandicapTable},
  unitSkillRoll in 'unitSkillRoll.pas' {frmSkillRolls},
  unitGFI in 'unitGFI.pas' {frmGFI},
  unitThrowTeamMate in 'unitThrowTeamMate.pas' {frmTTM},
  unitCatch in 'unitCatch.pas' {frmCatch},
  unitKick in 'unitKick.pas' {frmKick},
  unitMessage in 'unitMessage.pas' {frmMessage},
  unitMachineID in 'unitMachineID.pas' {MachID},
  unitLanguage in 'unitLanguage.pas',
  unitThrowStuff in 'unitThrowStuff.pas' {frmThrowStuff},
  unitCatchStuff in 'unitCatchStuff.pas' {frmCatchStuff};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Bloodbowl PBEM Tool';
  Application.CreateForm(TfrmWelcome, frmWelcome);
  Application.CreateForm(TfrmSettings, frmSettings);
  Application.CreateForm(TBloodbowl, Bloodbowl);
  Application.CreateForm(TfrmLog, frmLog);
  Application.CreateForm(TmodAlg, modAlg);
  Application.CreateForm(TfrmRoster, frmRoster);
  Application.CreateForm(TfrmAbout, frmAbout);
  Application.CreateForm(TfrmArmourRoll, frmArmourRoll);
  Application.CreateForm(TfrmCards, frmCards);
  Application.CreateForm(TfrmNotes, frmNotes);
  Application.CreateForm(TfrmLogControl, frmLogControl);
  Application.CreateForm(TfrmDodgeRoll, frmDodgeRoll);
  Application.CreateForm(TfrmPlayerStatsChange, frmPlayerStatsChange);
  Application.CreateForm(TfrmThrowIn, frmThrowIn);
  Application.CreateForm(TmodPlayer, modPlayer);
  Application.CreateForm(TmodPlayAction, modPlayAction);
  Application.CreateForm(TmodTurnChange, modTurnChange);
  Application.CreateForm(TmodExtern, modExtern);
  Application.CreateForm(TmodMarker, modMarker);
  Application.CreateForm(TmodBall, modBall);
  Application.CreateForm(TmodTeam, modTeam);
  Application.CreateForm(TfrmFanFactor, frmFanFactor);
  Application.CreateForm(TfrmPass, frmPass);
  Application.CreateForm(TfrmLanding, frmLanding);
  Application.CreateForm(TfrmPickUp, frmPickUp);
  Application.CreateForm(TfrmAddPlayer, frmAddPlayer);
  Application.CreateForm(TfrmPostgame, frmPostgame);
  Application.CreateForm(TfrmHandicapTable, frmHandicapTable);
  Application.CreateForm(TfrmSkillRolls, frmSkillRolls);
  Application.CreateForm(TfrmGFI, frmGFI);
  Application.CreateForm(TfrmTTM, frmTTM);
  Application.CreateForm(TfrmCatch, frmCatch);
  Application.CreateForm(TfrmKick, frmKick);
  Application.CreateForm(TfrmMessage, frmMessage);
  Application.CreateForm(TMachID, MachID);
  Application.CreateForm(TfrmThrowStuff, frmThrowStuff);
  Application.CreateForm(TfrmCatchStuff, frmCatchStuff);
  LanguageInit;
  
  Application.Run;
end.
