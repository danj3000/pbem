{$A+,B-,C+,D+,E-,F-,G+,H+,I+,J-,K-,L+,M-,N+,O+,P+,Q-,R-,S-,T-,U-,V+,W-,X+,Y+,Z1}
{$MINSTACKSIZE $00004000}
{$MAXSTACKSIZE $00100000}
{$IMAGEBASE $00400000}
{$APPTYPE GUI}
unit bbunit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, Menus, ComCtrls, jpeg,
  bbalg, unitDodgeRoll, unitTeam, unitPlayer, unitMarker, unitCards;

type
  TBloodbowl = class(TForm)
    comment: TEdit;
    Movetofield1: TMenuItem;
    MovetoReserve1: TMenuItem;
    reservePopup: TPopupMenu;
    koPopup: TPopupMenu;
    fieldPopup: TPopupMenu;
    nullPopup: TPopupMenu;
    playerPopup: TPopupMenu;
    Placeball1: TMenuItem;
    Endofmove1: TMenuItem;
    Ballcarrier1: TMenuItem;
    N1: TMenuItem;
    Prone1: TMenuItem;
    Stunned1: TMenuItem;
    SeriouslyInjured1: TMenuItem;
    Reserve1: TMenuItem;
    Standing1: TMenuItem;
    OneD6Button: TButton;
    TwoD6Button: TButton;
    D8Button: TButton;
    OneDBButton: TButton;
    TwoDBButton: TButton;
    ThreeDBButton: TButton;
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    Exit1: TMenuItem;
    SaveGame1: TMenuItem;
    Exit2: TMenuItem;
    Playbooks1: TMenuItem;
    ViewRedPB1: TMenuItem;
    ViewBluePB1: TMenuItem;
    SpecialRolls1: TMenuItem;
    Kickofftable1: TMenuItem;
    Weathertable1: TMenuItem;
    StarPlayerPoints1: TMenuItem;
    Completion1: TMenuItem;
    Interception1: TMenuItem;
    Touchdown1: TMenuItem;
    Casualty1: TMenuItem;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    DiceRoll1: TImage;
    DiceRoll2: TImage;
    BlockRoll1: TImage;
    BlockRoll2: TImage;
    BlockRoll3: TImage;
    LoadTeamDialog: TOpenDialog;
    EnterButton: TBitBtn;
    WeatherLabel: TLabel;
    GateLabel: TLabel;
    LogLabel: TLabel;
    Help1: TMenuItem;
    About1: TMenuItem;
    toolbar: TPanel;
    savegameSB: TSpeedButton;
    viewredSB: TSpeedButton;
    viewblueSB: TSpeedButton;
    ArgueCallSB: TSpeedButton;
    Log1: TMenuItem;
    ViewLog1: TMenuItem;
    N3: TMenuItem;
    Gotostart1: TMenuItem;
    Gotostartofturn1: TMenuItem;
    Gotoendofturn1: TMenuItem;
    Gotoend1: TMenuItem;
    Playoneaction1: TMenuItem;
    Takebackoneaction1: TMenuItem;
    N5: TMenuItem;
    Goto1: TMenuItem;
    SpeakLabel: TLabel;
    N6: TMenuItem;
    PlayerShowPassingRanges1: TMenuItem;
    N7: TMenuItem;
    FieldShowPassingRanges1: TMenuItem;
    Cards1: TMenuItem;
    N8: TMenuItem;
    RandomRedplayer1: TMenuItem;
    RandomBlueplayer1: TMenuItem;
    N9: TMenuItem;
    ArmourRoll1: TMenuItem;
    InjuryRoll1: TMenuItem;
    FoulRoll1: TMenuItem;
    DecodecardsforRed1: TMenuItem;
    DecodecardsforBlue1: TMenuItem;
    SpecialActions1: TMenuItem;
    StartHalf1: TMenuItem;
    PrepareforKickoff1: TMenuItem;
    PostgameRolls1: TMenuItem;
    SIMNG1: TMenuItem;
    SINig1: TMenuItem;
    SIMA1: TMenuItem;
    SIST1: TMenuItem;
    SIAG1: TMenuItem;
    SIAV1: TMenuItem;
    N10: TMenuItem;
    MakeDodgeroll1: TMenuItem;
    N11: TMenuItem;
    LoseRegainTackleZone1: TMenuItem;
    StatsChange1: TMenuItem;
    N12: TMenuItem;
    IGotMyEyeOnRed1: TMenuItem;
    IGotMyEyeOnBlue1: TMenuItem;
    N13: TMenuItem;
    AddCards1: TMenuItem;
    N14: TMenuItem;
    MakeaThrowin1: TMenuItem;
    StartHalfSB: TSpeedButton;
    PrepareKickoffSB: TSpeedButton;
    kickoffSB: TSpeedButton;
    weatherSB: TSpeedButton;
    compSB: TSpeedButton;
    interceptionSB: TSpeedButton;
    touchdownSB: TSpeedButton;
    casualtySB: TSpeedButton;
    armourrollSB: TSpeedButton;
    injuryrollSB: TSpeedButton;
    foulrollSB: TSpeedButton;
    SBThrowIn: TSpeedButton;
    RandomRedSB: TSpeedButton;
    RandomBlueSB: TSpeedButton;
    SBIGMEOYRed: TSpeedButton;
    SBIGMEOYBlue: TSpeedButton;
    TurnLabel: TLabel;
    ScoreLabel: TLabel;
    RerollLabel: TLabel;
    ImIGMEOYL: TImage;
    ImIGMEOYR: TImage;
    BallImage: TImage;
    CurBox: TShape;
    FieldBorder: TShape;
    tdline1: TShape;
    tdline2: TShape;
    mline: TShape;
    widezoneline2: TShape;
    widezoneline1: TShape;
    FieldImage: TImage;
    PregamePanel: TPanel;
    Label1: TLabel;
    ButLoadRed: TBitBtn;
    ButLoadBlue: TBitBtn;
    ButWeather: TBitBtn;
    ButGate: TBitBtn;
    ButHandicap: TBitBtn;
    ButCardsRed: TBitBtn;
    ButCardsBlue: TBitBtn;
    ButNiggles: TBitBtn;
    ButSaveGame: TBitBtn;
    LblNiggles: TLabel;
    RGGate: TRadioGroup;
    ImRedDie: TImage;
    ImBlueDie: TImage;
    ButStart: TBitBtn;
    lblBlueTeam: TLabel;
    LblRedTeam: TLabel;
    LblWeather: TLabel;
    LblGate: TLabel;
    LblHandicap: TLabel;
    LblCardsBlue: TLabel;
    LblCardsRed: TLabel;
    PostgameSB: TSpeedButton;
    butToss: TBitBtn;
    lblToss: TLabel;
    MakePass1: TMenuItem;
    MakeCatchroll1: TMenuItem;
    MissesMatch1: TMenuItem;
    lbHalfID: TLabel;
    lbHalftext: TLabel;
    HandicapRolls1: TMenuItem;
    butMakeHandicapRolls: TBitBtn;
    sbOtherSPP: TSpeedButton;
    OtherSPP1: TMenuItem;
    MakePickuproll1: TMenuItem;
    MakeGFIroll1: TMenuItem;
    Settings1: TMenuItem;
    ScatterBall1: TMenuItem;
    ScatterBallfromplayer1: TMenuItem;
    SBResetIGMEOY: TSpeedButton;
    ResetIGotMyEyeOnYou1: TMenuItem;
    SBMVP: TSpeedButton;
    MVPAward1: TMenuItem;
    imPlayerImageRed: TImage;
    imPlayerImageBlue: TImage;
    lblDiceRoll: TLabel;
    lblBlockDiceRoll: TLabel;
    BadlyHurt2: TMenuItem;
    Dead2: TMenuItem;
    TargetedActions1: TMenuItem;
    HypnoticGaze1: TMenuItem;
    Leap1: TMenuItem;
    MultipleBlock1: TMenuItem;
    ThrowTeamMate1: TMenuItem;
    ThrowExplosiveBombs1: TMenuItem;
    ThrowinMovement1: TMenuItem;
    TargetActionsSpecial1: TMenuItem;
    BearHug1: TMenuItem;
    Chill1: TMenuItem;
    Ethereal1: TMenuItem;
    MaceTail1: TMenuItem;
    BulletThrow1: TMenuItem;
    PitchPlayer1: TMenuItem;
    ThrowStinkBomb1: TMenuItem;
    ThrowNet1: TMenuItem;
    ThrowBigBomb1: TMenuItem;
    Wings1: TMenuItem;
    WingsLeap1: TMenuItem;
    WarCry1: TMenuItem;
    Shadowing1: TMenuItem;
    MakeKickRoll1: TMenuItem;
    DirtyKick1: TMenuItem;
    Punt1: TMenuItem;
    AVInjRoll1: TMenuItem;
    lblPickWeather1: TMenuItem;
    PWeather1: TMenuItem;
    PWeather2: TMenuItem;
    PWeather3: TMenuItem;
    PWeather4: TMenuItem;
    PWeather5: TMenuItem;
    PWeather6: TMenuItem;
    PWeather7: TMenuItem;
    PWeather8: TMenuItem;
    PWeather9: TMenuItem;
    PWeather10: TMenuItem;
    PWeather11: TMenuItem;
    RemoveComp1: TMenuItem;
    RemoveInt1: TMenuItem;
    RemoveTD1: TMenuItem;
    RemoveCas1: TMenuItem;
    RemoveOther1: TMenuItem;
    RemoveMVP1: TMenuItem;
    Dig1: TMenuItem;
    RemoveCheerleaderAsstCoach1: TMenuItem;
    ChangeGate1: TMenuItem;
    CrowdRoll1: TMenuItem;
    HideBall1: TMenuItem;
    ShowHidePassBlockRanges1: TMenuItem;
    sbEXP: TSpeedButton;
    EXP1: TMenuItem;
    RemoveEXP1: TMenuItem;
    TempOut1: TMenuItem;
    MissDrive1: TMenuItem;
    ResetMove1: TMenuItem;
    W1: TMenuItem;
    Fireball1: TMenuItem;
    LightningBolt1: TMenuItem;
    Zap1: TMenuItem;
    LRBWizSpells: TMenuItem;
    CastFireball1: TMenuItem;
    CastLightningBolt1: TMenuItem;
    StatsChange2: TMenuItem;
    StatsChange3: TMenuItem;
    SideStep1: TMenuItem;
    ShowHideDivingTackle2: TMenuItem;
    SendOffTempOut1: TMenuItem;
    SendOff1: TMenuItem;
    TemporarilyOut1: TMenuItem;
    HeatOut1: TMenuItem;
    ShowHideSpecialRanges1: TMenuItem;
    ShowHidePassBlockRanges2: TMenuItem;
    ShowHideDivingTackle: TMenuItem;
    ShowHideTackle: TMenuItem;
    ShowHideTackle2: TMenuItem;
    KO1: TMenuItem;
    DeclareAction1: TMenuItem;
    Blitz1: TMenuItem;
    Cast1: TMenuItem;
    Foul1: TMenuItem;
    Pass1: TMenuItem;
    HandOff1: TMenuItem;
    DisableRedWizard1: TMenuItem;
    DisableBlueApothecary1: TMenuItem;
    DisableBlueWizard1: TMenuItem;
    DisableRedApothecary1: TMenuItem;
    RPB1: TMenuItem;
    Teams1: TMenuItem;
    ViewRedTeam1: TMenuItem;
    ViewBlueTeam1: TMenuItem;
    Firethrower1: TMenuItem;
    RPB2: TMenuItem;
    RPB3: TMenuItem;
    RPB4: TMenuItem;
    RPB5: TMenuItem;
    RPB6: TMenuItem;
    RPB7: TMenuItem;
    RPB8: TMenuItem;
    RPB9: TMenuItem;
    RPB10: TMenuItem;
    BPB1: TMenuItem;
    BPB2: TMenuItem;
    BPB3: TMenuItem;
    BPB4: TMenuItem;
    BPB5: TMenuItem;
    BPB6: TMenuItem;
    BPB7: TMenuItem;
    BPB8: TMenuItem;
    BPB9: TMenuItem;
    BPB10: TMenuItem;
    Stab1: TMenuItem;
    AVInjRoll2: TMenuItem;
    PickSideStep1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Movetofield1Click(Sender: TObject);
    procedure BallMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BallDragOver(Sender, Source: TObject; X,
                    Y: Integer; State: TDragState; var Accept: Boolean);
    procedure ApoWizClick(Sender: TObject);
    procedure MovetoReserve1Click(Sender: TObject);
    procedure Placeball1Click(Sender: TObject);
    procedure Endofmove1Click(Sender: TObject);
    procedure Resetmove1Click(Sender: TObject);
    procedure Move1Click(Sender: TObject);
    procedure Ballcarrier1Click(Sender: TObject);
    procedure Standing1Click(Sender: TObject);
    procedure Prone1Click(Sender: TObject);
    procedure Stunned1Click(Sender: TObject);
    procedure Reserve1Click(Sender: TObject);
    procedure KO1Click(Sender: TObject);
    procedure BadlyHurt1Click(Sender: TObject);
    procedure SeriouslyInjured1Click(Sender: TObject);
    procedure Dead1Click(Sender: TObject);
    procedure TemporaryOut1Click(Sender: TObject);
    procedure HeatOut1Click(Sender: TObject);
    procedure OneD6ButtonClick(Sender: TObject);
    procedure TwoD6ButtonClick(Sender: TObject);
    procedure D8ButtonClick(Sender: TObject);
    procedure OneDBButtonClick(Sender: TObject);
    procedure TwoDBButtonClick(Sender: TObject);
    procedure ThreeDBButtonClick(Sender: TObject);
    procedure Exit2Click(Sender: TObject);
    procedure SaveGame1Click(Sender: TObject);
    procedure LoadGame1Click(Sender: TObject);
    procedure Completion1Click(Sender: TObject);
    procedure Interception1Click(Sender: TObject);
    procedure Touchdown1Click(Sender: TObject);
    procedure Casualty1Click(Sender: TObject);
    procedure Kickofftable1Click(Sender: TObject);
    procedure Weathertable1Click(Sender: TObject);
    procedure EnterButtonClick(Sender: TObject);
    procedure SendOff1Click(Sender: TObject);
    procedure ViewRedPB1Click(Sender: TObject);
    procedure ViewBluePB1Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure ViewLog1Click(Sender: TObject);
    procedure NewGame1Click(Sender: TObject);
    procedure armourrollSBClick(Sender: TObject);
    procedure Goto1Click(Sender: TObject);
    procedure injuryrollSBClick(Sender: TObject);
    procedure foulrollSBClick(Sender: TObject);
    procedure cardsDecodeClick(Sender: TObject);
    procedure cardPlayClick(Sender: TObject);
    procedure RandomRedSBClick(Sender: TObject);
    procedure RandomBlueSBClick(Sender: TObject);
    procedure SpeakLabelClick(Sender: TObject);
    procedure StartHalfSBClick(Sender: TObject);
    procedure PlayerShowPassingRanges1Click(Sender: TObject);
    procedure PlayerShowPassBlockRanges1Click(Sender: TObject);
    procedure FieldShowPassingRanges1Click(Sender: TObject);
    procedure FieldShowPassBlockRanges1Click(Sender: TObject);
    procedure DecodecardsforRed1Click(Sender: TObject);
    procedure DecodecardsforBlue1Click(Sender: TObject);
    procedure PrepareforKickoff1Click(Sender: TObject);
    procedure StartButtonClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure PlayoneButtonClick(Sender: TObject);
    procedure PlaybackmoveButtonClick(Sender: TObject);
    procedure StartturnButtonClick(Sender: TObject);
    procedure EndturnButtonClick(Sender: TObject);
    procedure EndButtonClick(Sender: TObject);
    procedure MakeDodgeroll1Click(Sender: TObject);
    procedure LoseRegainTackleZone1Click(Sender: TObject);
    procedure StatsChange1Click(Sender: TObject);
    procedure SBIGMEOYRedClick(Sender: TObject);
    procedure SBResetIGMEOYClick(Sender: TObject);
    procedure SBIGMEOYBlueClick(Sender: TObject);
    procedure AddCards1Click(Sender: TObject);
    procedure SBThrowInClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ButLoadRedClick(Sender: TObject);
    procedure ButLoadBlueClick(Sender: TObject);
    procedure ButWeatherClick(Sender: TObject);
    procedure ButGateClick(Sender: TObject);
    procedure ButHandicapClick(Sender: TObject);
    procedure butMakeHandicapRollsClick(Sender: TObject);
    procedure ButCardsRedClick(Sender: TObject);
    procedure ButCardsBlueClick(Sender: TObject);
    procedure ButNigglesClick(Sender: TObject);
    procedure ButTossClick(Sender: TObject);
    procedure ButSaveGameClick(Sender: TObject);
    procedure ButStartClick(Sender: TObject);
    procedure PostgameSBClick(Sender: TObject);
    procedure MakePass1Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure MakeCatchroll1Click(Sender: TObject);
    procedure MakePickuproll1Click(Sender: TObject);
    procedure MakeGFIroll1Click(Sender: TObject);
    procedure MissesMatch1Click(Sender: TObject);
    procedure UpdateHalfID(HalfNo: integer);
    procedure PostgameRolls1Click(Sender: TObject);
    procedure HandicapRolls1Click(Sender: TObject);
    procedure OtherSPP1Click(Sender: TObject);
    procedure EXP1Click(Sender: TObject);
    procedure Settings1Click(Sender: TObject);
    procedure ScatterBall1Click(Sender: TObject);
    procedure ScatterPlayerBall1Click(Sender: TObject);
    procedure SBMVPClick(Sender: TObject);
    procedure HGaze1Click(Sender: TObject);
    procedure Leap1Click(Sender: TObject);
    procedure MultipleBlock1Click(Sender: TObject);
    procedure BearHug1Click(Sender: TObject);
    procedure Chill1Click(Sender: TObject);
    procedure Ethereal1Click(Sender: TObject);
    procedure ThrowTeamMate1Click(Sender: TObject);
    procedure ThrowBomb1Click(Sender: TObject);
    procedure ThrowStinkBomb1Click(Sender: TObject);
    procedure ThrowinMovement1Click(Sender: TObject);
    procedure MaceTail1Click(Sender: TObject);
    procedure BulletThrow1Click(Sender: TObject);
    procedure PitchPlayer1Click(Sender: TObject);
    procedure ThrowNet1Click(Sender: TObject);
    procedure ThrowBigBomb1Click(Sender: TObject);
    procedure ThrowFireball1Click(Sender: TObject);
    procedure Wings1Click(Sender: TObject);
    procedure WingsLeap1Click(Sender: TObject);
    procedure WarCry1Click(Sender: TObject);
    procedure Shadowing1Click(Sender: TObject);
    procedure CastFireball1Click(Sender: TObject);
    procedure CastFireballField1Click(Sender: TObject);
    procedure CastLightningBolt1Click(Sender: TObject);
    procedure CastLBoltField1Click(Sender: TObject);
    procedure CastZap1Click(Sender: TObject);
    procedure MakeKickRoll1Click(Sender: TObject);
    procedure Punt1Click(Sender: TObject);
    procedure HideBall1Click(Sender: TObject);
    procedure DirtyKick1Click(Sender: TObject);
    procedure AVInjRoll1Click(Sender: TObject);
    procedure CrowdRoll1Click(Sender: TObject);
    procedure PickWeather1Click(Sender: TObject);
    procedure PickWeather2Click(Sender: TObject);
    procedure PickWeather3Click(Sender: TObject);
    procedure PickWeather4Click(Sender: TObject);
    procedure PickWeather5Click(Sender: TObject);
    procedure PickWeather6Click(Sender: TObject);
    procedure PickWeather7Click(Sender: TObject);
    procedure PickWeather8Click(Sender: TObject);
    procedure PickWeather9Click(Sender: TObject);
    procedure PickWeather10Click(Sender: TObject);
    procedure PickWeather11Click(Sender: TObject);
    procedure RemoveComp1Click(Sender: TObject);
    procedure RemoveInt1Click(Sender: TObject);
    procedure RemoveTD1Click(Sender: TObject);
    procedure RemoveCas1Click(Sender: TObject);
    procedure RemoveOther1Click(Sender: TObject);
    procedure RemoveMVP1Click(Sender: TObject);
    procedure RemoveEXP1Click(Sender: TObject);
    procedure ArgueCallSBClick(Sender: TObject);
    procedure Dig1Click(Sender: TObject);
    procedure ChangeGate1Click(Sender: TObject);
    procedure RemoveCHACClick(Sender: TObject);
    procedure PlayerShowDivingTackle1Click(Sender: TObject);
    procedure SideStep1Click(Sender: TObject);
    procedure FieldShowDivingTackleRanges1Click(Sender: TObject);
    procedure PlayerShowTackle1Click(Sender: TObject);
    procedure FieldShowTackleRanges1Click(Sender: TObject);
    procedure DeclareBlitz1Click(Sender: TObject);
    procedure DeclareCast1Click(Sender: TObject);
    procedure DeclareFoul1Click(Sender: TObject);
    procedure DeclareHandOff1Click(Sender: TObject);
    procedure DeclarePass1Click(Sender: TObject);
    procedure DisableRedWizard1Click(Sender: TObject);
    procedure DisableRedApothecary1Click(Sender: TObject);
    procedure DisableBlueWizard1Click(Sender: TObject);
    procedure DisableBlueApothecary1Click(Sender: TObject);
    procedure RPB1Click(Sender: TObject);
    procedure RPB2Click(Sender: TObject);
    procedure RPB3Click(Sender: TObject);
    procedure RPB4Click(Sender: TObject);
    procedure RPB5Click(Sender: TObject);
    procedure RPB6Click(Sender: TObject);
    procedure RPB7Click(Sender: TObject);
    procedure RPB8Click(Sender: TObject);
    procedure RPB9Click(Sender: TObject);
    procedure RPB10Click(Sender: TObject);
    procedure BPB1Click(Sender: TObject);
    procedure BPB2Click(Sender: TObject);
    procedure BPB3Click(Sender: TObject);
    procedure BPB4Click(Sender: TObject);
    procedure BPB5Click(Sender: TObject);
    procedure BPB6Click(Sender: TObject);
    procedure BPB7Click(Sender: TObject);
    procedure BPB8Click(Sender: TObject);
    procedure BPB9Click(Sender: TObject);
    procedure BPB10Click(Sender: TObject);
    procedure UseFirethrower1Click(Sender: TObject);
    procedure Stab1Click(Sender: TObject);
    procedure PickSideStep1Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Bloodbowl: TBloodbowl;
  turn: array [0..1, 1..8] of TLabel;
  marker: array [0..1, 1..4] of TMarker;
  fn, GameStatus, FollowUp, LDFILEDT, BugString, HomePic,
    AwayPic, LustrianRoll, LustrianRoll2: string; {fn=filename, LDFILEDT=File Date/Time}
  ff: file of char;
  curteam, curplayer, curmove, IGMEOY, HalfNo, lastroll, lastroll2, lastroll3,
  NumHandicaps, ActionTeam, ActionPlayer, ArgueMod, RefMod,
  ThrownTeam, ThrownPlayer, LastFieldP, LastFieldQ, DigP, DigQ,
  DigStrength, RandCnt1, RandCnt2, RandCnt3, RandCnt4, RandCnt5,
  KickDist, KOCatcherTeam, KOCatcherPlayer, InjuryStatus, KickOffTeam,
  MachineID, GettheRef, SWSafeRef, HideBallp, HideBallq,
  AccurateTeam, AccuratePlayer, StuffP, StuffQ, BombTeam, BombPlayer,
  BlockTeam, BlockPlayer, HitTeam, HitPlayer, D3RollBlue, D3RollTOTBlue, KDownBlue,
  KDownTOTBlue, AVBreakBlue, AVBreakTOTBlue, KOInjBlue, KOInjTOTBlue, D3RollRed,
  D3RollTOTRed, KDownRed, KDownTOTRed, AVBreakRed, AVBreakTOTRed, KOInjRed,
  KOInjTOTRed, PilingOn, BashTeam, BashPlayer, DownTeam, DownPlayer:  integer;
  ffc: array [0..1] of string[1];
  KickField: array [0..14, 0..25] of integer;
  RandRoll1, RandRoll2, RandRoll3, RandRoll4, RandRoll5: array [0..100]
    of integer;
  ref, AutoSave, AskConfirmation, MBPO,
  ThickSkull, PoisonedDagger, CrystalSkin, Brittle,
  DirtyPlayer4th, DaemonicAura, LesserBanishment, bbfullscreen,
  LBanishment2, SmellingSalts, IronMan, Decay, PulledPunches,
  TIKSTPK, BribeTheAnnouncers, NoDeath, FixedRand, SaveGameAllowed,
  FirstLoad, Touchback, SettingsLoaded, AccuratePassPlay, PalmedCoin,
  SideStepStop, ProSkill, KickOffNow, DodgeNoStand, GetCAS, AVBreak,
  LoadedFileFirstBlood, LoadedFlag: boolean;
  PlayerData: array [0..1, 1..5] of TLabel;
  CardsData: array [0..1, 1..25] of TCardLabel;
  CardsBox: array [0..1] of TScrollBox;
  lblCardsBox: array [0..1] of TLabel;
  TeamTextColor, OrgTeamTextColor: array [0..1] of TColor;
  apo, wiz, apo1, apo2, apo3, apo4, apo5: array [0..1] of TLabel;
  team: array [0..1] of TTeam;
  player: array [0..1, 1..MaxNumPlayersInTeam] of TPlayer;
  pnlDugOut: array [0..1, 1..3] of TScrollBox;
  lblDugOut: array [0..1, 1..3] of TLabel;
  ComputerID: array [1..500] of string;
  CurrentComputer,LoadedFile: string;
  RedPlaybook, BluePlaybook: array [1..10] of string;

procedure RepaintColor(g: integer);
procedure SetSpeakLabel(g: integer);
procedure GotoEntry(e: integer);
procedure FormReset(startup, restarting: boolean);
procedure ShowFieldImage(PitchName: string);
procedure PlayOne(w: integer);
procedure PlayOneBack;
procedure ApoWizCreate(g: integer);

implementation

uses unitRoster, unitLog, unitAbout, unitArmourRoll, unitNotes,
  unitLogControl, unitPlayerStatsChange, unitThrowIn, unitWelcome,
  unitPlayAction, unitTurnChange, unitExtern, unitBall, unitGFI,
  unitPregame, unitPostgameSeq, unitFanFactor, unitField, unitRandom,
  unitCatch, unitPickUp, unitAddPlayer, unitHandicapTable, unitSkillRoll,
  unitSettings, unitMessage;

{$R *.DFM}

procedure SetSpeakLabel(g: integer);
begin
  if g = 1 then begin
    Bloodbowl.SpeakLabel.caption := 'Away says:';
    Bloodbowl.SpeakLabel.font.color := TeamTextColor[1];
  end else begin
    Bloodbowl.SpeakLabel.caption := 'Home says:';
    Bloodbowl.SpeakLabel.font.color := TeamTextColor[0];
  end;
end;

procedure FormReset(startup, restarting: boolean);
var f, g: integer;

begin
  UnCur;
  curmove := -1;
  ffcl[0] := 'Home';
  ffcl[1] := 'Away';
  for g := 0 to 1 do begin
   for f := 1 to 8 do begin
    turn[g,f].color := colorarray[g,0,0];
    if ref then turn[g,f].Refresh;
   end;
   for f := 1 to 4 do begin
     marker[g, f].SetValue(0);
     if ref then marker[g, f].Refresh;
   end;
  end;
  for g := 0 to 1 do begin
   pw[g] := '';
   plcards[g] := '00';
   for f := 1 to 25 do begin
    playedcardsset[g,f] := 0;
    CardsData[g,f].caption := '';
    if ref then CardsData[g,f].Refresh;
   end;
  end;
  for f := 0 to 14 do
   for g := 0 to 25 do begin
    field[f,g].caption := '';
    field[f,g].color := clGreen;
    field[f,g].font.size := 12;
    if ref then field[f,g].Refresh;
   end;
  GameStatus := '';
  for g := 0 to 1 do ResetTeam(g);
  ClearAllNumOnField;
  ball.p := -1;
  Bloodbowl.WeatherLabel.caption := '';
  Bloodbowl.GateLabel.caption := '';
  Bloodbowl.ballImage.visible := false;
  if ref then Bloodbowl.ballImage.Refresh;
{  if ref then RedrawDugOut;}
  if SettingsLoaded then begin
    for g := 0 to 1 do begin
      if frmSettings.cbUpApoth.checked then begin
        apo1[g].color := colorarray[g, 0, 0];
        apo1[g].font.color := colorarray[g, 0, 1];
        apo1[g].visible := true;
        apo2[g].color := colorarray[g, 0, 0];
        apo2[g].font.color := colorarray[g, 0, 1];
        apo2[g].visible := true;
        apo3[g].color := colorarray[g, 0, 0];
        apo3[g].font.color := colorarray[g, 0, 1];
        apo3[g].visible := true;
        apo4[g].color := colorarray[g, 0, 0];
        apo4[g].font.color := colorarray[g, 0, 1];
        apo4[g].visible := true;
        apo5[g].color := colorarray[g, 0, 0];
        apo5[g].font.color := colorarray[g, 0, 1];
        apo5[g].visible := true;
      end else begin
        apo[g].color := colorarray[g, 0, 0];
        apo[g].font.color := colorarray[g, 0, 1];
        apo[g].visible := true;
      end;
      wiz[g].color := colorarray[g, 0, 0];
      wiz[g].font.color := colorarray[g, 0, 1];
      wiz[g].visible := true;
    end;
  end;
  SetIGMEOY(-1);
  InEditMode := false;
  if not(startup) then begin
    frmNotes.NotesMemo.Clear;
    if restarting then ResetLog else begin
      frmLog.LogLB.ItemIndex := -1;
      frmLogControl.logcounter.text := IntToStr(0);
      frmLog.LogLB.TopIndex := 0;
      Bloodbowl.loglabel.caption := '';
    end;
    PregameEnableDisable;
  end;
  if PostgameActive then frmPostgame.Hide;
end;

procedure ShowFieldImage(PitchName: string);
var f, g : integer;
    b: boolean;
begin
  b := PitchName <> '';
  if b then
   b := FileExists(curdir + 'images/' + PitchName);
  Bloodbowl.fieldborder.visible := not(b);
  Bloodbowl.tdline1.visible := not(b);
  Bloodbowl.tdline2.visible := not(b);
  Bloodbowl.mline.visible := not(b);
  Bloodbowl.widezoneline1.visible := not(b);
  Bloodbowl.widezoneline2.visible := not(b);
  Bloodbowl.fieldImage.visible := b;
  if b then
    Bloodbowl.fieldImage.picture.LoadFromFile(
          curdir + 'images/' + PitchName);
  for f := 0 to 14 do
   for g := 0 to 25 do begin
     field[f,g].color := clGreen;
     field[f,g].transparent := b;
   end;
end;

procedure RepaintColor(g: integer);
var f: integer;
begin
  for f := 1 to 8 do begin
    turn[g,f].color := colorarray[g,0,0];
  end;
  if SettingsLoaded then begin
    if not(frmSettings.cbUpApoth.checked) then begin
      if (apo[g].color <> colorarray[g, 4, 0]) then begin
        apo[g].color := colorarray[g, 0, 0];
        apo[g].font.color := colorarray[g, 0, 1];
      end;
    end else begin
      if (team[g].apot >= 1) and (apo1[g].color <> colorarray[g, 4, 0])
        then begin
        apo1[g].color := colorarray[g, 0, 0];
        apo1[g].font.color := colorarray[g, 0, 1];
      end;
      if (team[g].apot >= 2) and (apo2[g].color <> colorarray[g, 4, 0])
        then begin
        apo2[g].color := colorarray[g, 0, 0];
        apo2[g].font.color := colorarray[g, 0, 1];
      end;
      if (team[g].apot >= 3) and (apo3[g].color <> colorarray[g, 4, 0])
        then begin
        apo3[g].color := colorarray[g, 0, 0];
        apo3[g].font.color := colorarray[g, 0, 1];
      end;
      if (team[g].apot >= 4) and (apo4[g].color <> colorarray[g, 4, 0])
        then begin
        apo4[g].color := colorarray[g, 0, 0];
        apo4[g].font.color := colorarray[g, 0, 1];
      end;
      if (team[g].apot >= 5) and (apo5[g].color <> colorarray[g, 4, 0])
        then begin
        apo5[g].color := colorarray[g, 0, 0];
        apo5[g].font.color := colorarray[g, 0, 1];
      end;
    end;
    if wiz[g].color <> colorarray[g, 4, 0] then begin
      wiz[g].color := colorarray[g, 0, 0];
      wiz[g].font.color := colorarray[g, 0, 1];
    end;
  end;
  team[g].font.color := TeamTextColor[g];
  if g = 0 then begin
    Bloodbowl.LblRedteam.Font.Color := TeamTextColor[g];
  end else begin
    Bloodbowl.LblBlueteam.Font.Color := TeamTextColor[g];
  end;
  lblCardsBox[g].font.color := TeamTextColor[g];
  for f := 1 to 5 do begin
    PlayerData[g,f].font.color := TeamTextColor[g];
  end;
  for f := 1 to 4 do begin
    marker[g,f].color := colorarray[g, 0, 0];
  end;
  for f := 1 to team[g].numplayers do begin
    Player[g,f].Redraw;
  end;
end;

procedure TBloodbowl.FormCreate(Sender: TObject);
var f, g, y, z: integer;
    gg: textfile;
    s: string;

begin
  curdir := GetCurrentDir + '\';
  LoadSaveDir := curdir;
  {Randomize;}
  ref := false;
  PassRangeShowing := false;
  PassBlockRangeShowing := false;
  DivingTackleRangeShowing := false;
  TackleRangeShowing := false;

  AutoSave := false;
  bbfullscreen := false;
  PlayButtonDelay := 0;
  CheckFileOpen := false;
  SettingsLoaded := false;
  SmellingSalts := false;
  BribeTheAnnouncers := false;
  PalmedCoin := false;
  IGMEOY := -1;
  ThickSkull := false;
  PoisonedDagger := false;
  CrystalSkin := false;
  DaemonicAura := false;
  Brittle := false;
  IronMan := false;
  Decay := false;
  PulledPunches := false;
  DirtyPlayer4th := false;
  TIKSTPK := false;
  LastFieldP := -1;
  LastFieldQ := -1;
  ActionTeam := 0;
  ActionPlayer := 0;
  ThrownTeam := 0;
  ThrownPlayer := 0;
  KOCatcherTeam := -1;
  KOCatcherPlayer := -1;
  InjuryStatus := 0;
  ArgueMod := 0;
  RefMod := 0;
  LDFILEDT := 'No Date';
  RandCnt1 := 0;
  RandCnt2 := 0;
  RandCnt3 := 0;
  RandCnt4 := 0;
  RandCnt5 := 0;
  FixedRand := false;
  TouchBack := false;
  KickOffNow := false;
  KickOffTeam := -1;
  AccuratePassPlay := false;
  AccurateTeam := -1;
  AccuratePlayer := -1;
  HomePic := '';
  AwayPic := '';
  KickDist := 0;
  GettheRef := 3;
  SWSafeRef := 3;
  HideBallp := -1;
  HideBallq := -1;
  BombTeam := -1;
  BombPlayer := -1;
  BlockTeam := -1;
  BlockPlayer := -1;
  HitTeam := -1;
  HitPlayer := -1;
  BashTeam := -1;
  BashPlayer := -1;
  DownTeam := -1;
  DownPlayer := -1;
  SideStepStop := true;
  D3RollBlue := 0;
  D3RollTOTBlue := 0;
  KDownBlue := 0;
  KDownTOTBlue := 0;
  AVBreakBlue := 0;
  AVBreakTOTBlue := 0;
  KOInjBlue := 0;
  KOInjTOTBlue := 0;
  D3RollRed := 0;
  D3RollTOTRed := 0;
  KDownRed := 0;
  KDownTOTRed := 0;
  AVBreakRed := 0;
  AVBreakTOTRed := 0;
  KOInjRed := 0;
  KOInjTOTRed := 0;
  PilingOn := -1;
  DodgeNoStand := false;
  GetCAS := false;
  AVBreak := false;
  LoadedFileFirstBlood := true;
  LoadedFlag := false;
  LoadedFile := '';

  AskConfirmation := true;
  WriteLogUncoded := false;
  MakeCheckFile := false;
  MakeExportLog := false;
  SaveGameAllowed := false;
  Bloodbowl.savegameSB.Visible := false;
  Bloodbowl.SaveGame1.Visible := false;
  FirstLoad := true;
  BugString := ' ';
  for f := 1 to 500 do begin
    ComputerID[f] := ' ';
  end;

  FollowUp := '';

  {read ini file}
  AssignFile(gg, curdir + 'ini/pbembb.ini');
  Reset(gg);
  while not(eof(gg)) do begin
    Readln(gg, s);
    if Copy(s, 1, 10) = 'ViewLogOn=' then begin
      ViewLog1.checked := (Copy(s, 11, 1) = 'Y');
    end;
    if Copy(s, 1, 20) = 'AutoSaveAtTurnClick=' then begin
      AutoSave := (Copy(s, 21, 1) = 'Y');
    end;
    if Copy(s, 1, 23) = 'ShowSPPatPlayerDetails=' then begin
      frmSettings.cbShowSPP.checked  := (Copy(s, 24, 1) = 'Y');
    end;
    if Copy(s, 1, 21) = 'PassingRangesColored=' then begin
      frmSettings.cbPassingRangesColored.checked := (Copy(s, 22, 1) = 'Y');
    end;
    if Copy(s, 1, 14) = 'MovementWhite=' then begin
      frmSettings.cbBlackIce.checked := (Copy(s, 15, 1) = 'N');
    end;
    if Copy(s, 1, 16) = 'BackGroundColor=' then begin
      Bloodbowl.color := StringToColor(copy(s, 17, 7));
    end;
    if Copy(s, 1, 17) = 'RedTeamTextColor=' then begin
      TeamTextColor[0] := StringToColor(copy(s, 18, 7));
      OrgTeamTextColor[0] := TeamTextColor[0];
    end;
    if Copy(s, 1, 18) = 'BlueTeamTextColor=' then begin
      TeamTextColor[1] := StringToColor(copy(s, 19, 7));
      OrgTeamTextColor[1] := TeamTextColor[1];
    end;
    if Copy(s, 1, 13) = 'BBFullScreen=' then begin
      bbfullscreen := (copy(s, 14, 1) = 'Y');
    end;
    if Copy(s, 1, 6) = 'BBTop=' then begin
      Bloodbowl.top := FVal(copy(s, 7, 4));
    end;
    if Copy(s, 1, 7) = 'BBLeft=' then begin
      Bloodbowl.left := FVal(copy(s, 8, 4));
    end;
    if Copy(s, 1, 8) = 'BBWidth=' then begin
      Bloodbowl.width := FVal(copy(s, 9, 4));
    end;
    if Copy(s, 1, 16) = 'PlayButtonDelay=' then begin
      PlayButtonDelay := FVal(copy(s, 17, 4));
    end;
    {if Copy(s, 1, 11) = 'FieldImage=' then begin
      frmSettings.txtFieldImageFile.text := Trim(Copy(s,12,80));
    end;   }
    if Copy(s, 1, 16) = 'RandomAlgorithm=' then begin
      frmSettings.rgRandomAlgorithm.ItemIndex := FVal(Copy(s,17,80));
    end;
    if Copy(s, 1, 24) = 'AskConfirmationOnChange=' then begin
      AskConfirmation := (Copy(s, 25, 1) <> 'N');
    end;
    if Copy(s, 1, 23) = 'LogWrittenNotEncrypted=' then begin
      WriteLogUncoded := (Copy(s, 24, 1) = 'Y');
    end;
    if Copy(s, 1, 14) = 'MakeCheckFile=' then begin
      MakeCheckFile := (Copy(s, 15, 1) = 'Y');
    end;
    if Copy(s, 1, 15) = 'MakeExportFile=' then begin
      MakeExportLog := (Copy(s, 16, 1) = 'Y');
    end;
  end;
  CloseFile(gg);

  InitTables;

  UserRandomize;

  if bbfullscreen then begin
    Bloodbowl.width := Screen.width;
    Bloodbowl.height := Screen.height;
    Bloodbowl.left := 0;
    Bloodbowl.top := 0;
  end;

  {set up field}
  ffc[0] := 'R';
  ffc[1] := 'B';
  toolbar.left := 0;
  toolbar.top := 0;
  toolbar.width := Bloodbowl.width - 8;
  TurnLabel.top := 8 + toolbar.height;
  TurnLabel.width := RerollLabel.width;
  TurnLabel.left := (Bloodbowl.width - TurnLabel.width - 8) div 2 + 1;
  ScoreLabel.top := TurnLabel.top + 20;
  ScoreLabel.left := TurnLabel.left;
  ScoreLabel.width := TurnLabel.width;
  RerollLabel.top := TurnLabel.top + 40;
  RerollLabel.left := TurnLabel.left;
  RerollLabel.width := TurnLabel.width;

  comment.top := 497;
  comment.left := (Bloodbowl.width - 8) div 2 - 210;
  comment.width := 470 - EnterButton.width;
  SpeakLabel.top := comment.top + 4;
  SpeakLabel.left := comment.left - 54;
  SpeakLabel.font.color := TeamTextColor[0];
  EnterButton.left := comment.left + comment.width;
  EnterButton.top := comment.top;
  {/// smaller buttons}
  D8Button.width := 48;
  OneD6Button.width := D8Button.width;
  TwoD6Button.width := D8Button.width;
  OneDBButton.width := D8Button.width;
  TwoDBButton.width := D8Button.width;
  ThreeDBButton.width := D8Button.width;
  D8Button.height := 30;
  OneD6Button.height := D8Button.height;
  TwoD6Button.height := D8Button.height;
  OneDBButton.height := D8Button.height;
  TwoDBButton.height := D8Button.height;
  ThreeDBButton.height := D8Button.height;
  {/// until here}
  D8Button.left := ((Bloodbowl.width - 8) div 2) - D8Button.width - 2;
  D8Button.top := comment.top + 40 {/// was: 30};
  TwoD6Button.left := D8Button.left - TwoD6Button.width - 4;
  TwoD6Button.top := D8Button.top;
  OneD6Button.left := TwoD6Button.left - OneD6Button.width;
  OneD6Button.top := D8Button.top;
  lblDiceRoll.Left := OneD6Button.left +
                        (2 * OneD6Button.width - lblDiceRoll.Width) div 2;
  lblDiceRoll.Top := OneD6Button.top - 15;
  DiceRoll1.top := OneD6Button.top - 8;
  DiceRoll1.left := OneD6Button.left - DiceRoll1.width - 4;
  DiceRoll2.top := OneD6Button.top - 8;
  DiceRoll2.left := DiceRoll1.left - DiceRoll2.width - 4;
  OneDBButton.left := D8Button.left + D8Button.width + 4;
  OneDBButton.top := D8Button.top;
  TwoDBButton.left := OneDBButton.left + OneDBButton.width;
  TwoDBButton.top := D8Button.top;
  ThreeDBButton.left := TwoDBButton.left + TwoDBButton.width;
  ThreeDBButton.top := D8Button.top;
  lblBlockDiceRoll.Left := OneDBButton.left +
                        (3 * OneDBButton.width - lblBlockDiceRoll.Width) div 2;
  lblBlockDiceRoll.Top := lblDiceRoll.top;
  BlockRoll1.top := ThreeDBButton.top - 8;
  BlockRoll1.left := ThreeDBButton.left + ThreeDBButton.width + 4;
  BlockRoll2.top := ThreeDBButton.top - 8;
  BlockRoll2.left := BlockRoll1.left + BlockRoll1.width + 4;
  BlockRoll3.top := ThreeDBButton.top - 8;
  BlockRoll3.left := BlockRoll2.left + BlockRoll2.width + 4;
  LogLabel.left := ((Bloodbowl.width - 8) div 2) - 260; {/// was: OneD6Button.left;}
  LogLabel.top := OneD6Button.top + OneD6Button.height + 6;
  LogLabel.height := 52;
  LogLabel.width := 520;
    {/// was: ThreeDBButton.left + ThreeDBButton.width - OneD6Button.left;}
  if not(bbfullscreen) then begin
    Bloodbowl.height := LogLabel.top + LogLabel.height + 50;
  end;
  curteam := -1;
  for g := 0 to 1 do begin
   for f := 1 to 8 do begin
    turn[g,f] := TTurn.New(Bloodbowl, g, f);
   end;
   marker[g, MT_score] := TMarker.New(Bloodbowl, g, MT_Score);
   marker[g, MT_CasScore] := TMarker.New(Bloodbowl, g, MT_CasScore);
   marker[g, MT_Reroll] := TMarker.New(Bloodbowl, g, MT_Reroll);
   marker[g, MT_Leader] := TMarker.New(Bloodbowl, g, MT_Leader);
  end;
  for f := 0 to 14 do
   for g := 0 to 25 do begin
    field[f,g] := TFieldLabel.Create(Bloodbowl, f, g);
   end;

  fieldborder.top := field[0,0].top - 1;
  fieldborder.left := field[0,0].left - 1;
  fieldborder.height := 301;
  fieldborder.width := 521;
  tdline1.top := field[0,0].top;
  tdline1.left := field[0,1].left - 1;
  tdline1.height := 299;
  tdline1.width := 1;
  tdline2.top := field[0,0].top;
  tdline2.left := field[0,25].left - 1;
  tdline2.height := 299;
  tdline2.width := 1;
  mline.top := field[0,0].top;
  mline.left := field[0,13].left - 1;
  mline.height := 299;
  mline.width := 1;
  widezoneline1.top := field[4,0].top - 1;
  widezoneline1.left := field[0,0].left;
  widezoneline1.height := 1;
  widezoneline1.width := 519;
  widezoneline2.top := field[11,0].top - 1;
  widezoneline2.left := field[0,0].left;
  widezoneline2.height := 1;
  widezoneline2.width := 519;
  fieldImage.top := field[0,0].top - 1;
  fieldImage.left := field[0,0].left - 1;
  fieldImage.height := 301;
  fieldImage.width := 521;
  ShowFieldImage(frmSettings.txtFieldImageFile.text);

  for g := 0 to 1 do begin
    for f := 1 to 3 do begin
      pnlDugOut[g,f] := TScrollBox.Create(Bloodbowl);
      if f = 1 then pnlDugOut[g,f].top := 405
        else pnlDugOut[g,f].Top := 401 + 24 * f;
      if g = 0 then
        pnlDugOut[g,f].left := Bloodbowl.width div 2 - 268
      else
        pnlDugOut[g,f].left := Bloodbowl.width div 2;
      pnlDugOut[g,f].Width := 262;
      if f = 1 then pnlDugOut[g,f].height := 44
        else pnlDugOut[g,f].height := 24;
      pnlDugOut[g,f].parent := Bloodbowl;
      pnlDugOut[g,f].color := $909090;
      pnlDugOut[g,f].HorzScrollBar.visible := false;
      lblDugOut[g,f] := TLabel.Create(Bloodbowl);
      lblDugOut[g,f].parent := pnlDugOut[g,f];
      lblDugOut[g,f].AutoSize := false;
      lblDugOut[g,f].Alignment := taCenter;
      lblDugOut[g,f].Left := 0;
      lblDugOut[g,f].width := pnlDugOut[g,f].ClientWidth;
      lblDugOut[g,f].height := 20;
      if f = 1 then lblDugOut[g,f].top := 9
       else lblDugOut[g,f].top := -1;
      lblDugOut[g,f].font.name := 'Copperplate Gothic Bold';
      lblDugOut[g,f].font.size := 12;
    end;
    lblDugOut[g,1].caption := 'Reserves';
    lblDugOut[g,1].font.color := clLime;
    lblDugOut[g,2].caption := 'Knocked Out';
    lblDugOut[g,2].font.color := clNavy;
    lblDugOut[g,3].caption := 'Dead and Injured';
    lblDugOut[g,3].font.color := clMaroon;
  end;
  for g := 0 to 1 do
   for f := 1 to MaxNumPlayersInTeam do begin
    player[g,f] := TPlayer.New(Bloodbowl, g, f);
   end;

  for g := 0 to 1 do begin
   lblCardsBox[g] := TLabel.Create(Bloodbowl);
   lblCardsBox[g].top := toolbar.height + 4;
   lblCardsBox[g].caption := 'Cards for ' + ffcl[g] + ' team';
   lblCardsBox[g].font.color := TeamTextColor[g];
   lblCardsBox[g].parent := Bloodbowl;
   if g = 0 then begin
     lblCardsBox[g].left := 4;
   end else begin
     lblCardsBox[g].left := Bloodbowl.width - field[0,0].left - 3;
   end;
   lblCardsBox[g].OnClick := CardsDecodeClick;
   CardsBox[g] := TScrollBox.Create(Bloodbowl);
   CardsBox[g].height := 90;
   CardsBox[g].width := field[0,0].left - 9;
   CardsBox[g].top := toolbar.height + 20;
   CardsBox[g].left := lblCardsBox[g].left;
   CardsBox[g].HorzScrollBar.visible := false;
   CardsBox[g].parent := Bloodbowl;
   for f := 1 to 25 do begin
    CardsData[g,f] := TCardLabel.Create(Bloodbowl);
    CardsData[g,f].autosize := false;
    CardsData[g,f].visible := false;
    CardsData[g,f].width := CardsBox[g].clientwidth;
    CardsData[g,f].caption := '';
    CardsData[g,f].alignment := taCenter;
    CardsData[g,f].color := Bloodbowl.color;
    CardsData[g,f].font.size := 8;
    CardsData[g,f].height := 14;
    CardsData[g,f].top := f * 14 - 14;
    CardsData[g,f].left := 0;
    CardsData[g,f].showhint := false;
    CardsData[g,f].parent := CardsBox[g];
   end;
  end;
  {/// added:}
  imPlayerImageRed.top := CardsBox[0].top + CardsBox[0].height + 4;
  imPlayerImageRed.left := CardsBox[0].left;
  imPlayerImageBlue.top := CardsBox[1].top + CardsBox[1].height + 4;
  imPlayerImageBlue.left := CardsBox[1].left;
  {/// until here}
  for g := 0 to 1 do
   for f := 1 to 5 do begin
    PlayerData[g,f] := TLabel.Create(Bloodbowl);
    PlayerData[g,f].autosize := false;
    PlayerData[g,f].visible := true;
    PlayerData[g,f].width := field[0,0].left - 9;
    PlayerData[g,f].caption := '';
    PlayerData[g,f].alignment := taCenter;
    PlayerData[g,f].color := Bloodbowl.color;
    PlayerData[g,f].font.color := TeamTextColor[g];
    PlayerData[g,f].left := CardsBox[g].left;
    if f = 1 then begin
      PlayerData[g,f].font.size := 14;
      PlayerData[g,f].height := 24;
      PlayerData[g,f].top := CardsBox[g].top + CardsBox[g].height + 154 {/// was: 4};
    end else if f < 5 then begin
      PlayerData[g,f].font.size := 12;
      PlayerData[g,f].height := 20;
      PlayerData[g,f].top := PlayerData[g,f-1].top + PlayerData[g,f-1].height;
   end else begin
      PlayerData[g,f].font.size := 11;
      PlayerData[g,f].height := 100 {/// was: 140};
      PlayerData[g,f].wordwrap := true;
      PlayerData[g,f].top := PlayerData[g,f-1].top + PlayerData[g,f-1].height;
    end;
    PlayerData[g,f].showhint := false;
    PlayerData[g,f].parent := Bloodbowl;
   end;
  for g := 0 to 1 do begin
    team[g] := TTeam.New(Bloodbowl, g);
  end;
  team[0].caption := 'Team Red';
  team[1].caption := 'Team Blue';
  lbHalfID.top := turn[0,1].top;
  lbHalfID.left := turn[0,1].left - 30;
  lbHalftext.top := lbHalfID.top + 8;
  lbHalftext.left := lbHalfID.left - 27;
  ImIGMEOYL.left := team[0].left;
  ImIGMEOYL.top := team[0].top;
  ImIGMEOYR.left := team[1].left + team[1].width - 32;
  ImIGMEOYR.top := team[1].top;
  WeatherLabel.left := PlayerData[0,1].left;
  WeatherLabel.top := DiceRoll1.top;
    {/// was: PlayerData[0,5].top + PlayerData[0,5].height + 20;}
  WeatherLabel.width := PlayerData[0,1].width - 3;
  WeatherLabel.height := 70;
  GateLabel.left := PlayerData[1,1].left + 4;
  GateLabel.top := WeatherLabel.top;
  GateLabel.width := PlayerData[0,1].width - 3;
  GateLabel.height := 70;
  RedrawDugOut;
  GameStatus := '';
  ClearAllNumOnField;
  ball.p := -1;
  ballImage.visible := false;
  if ref then ballImage.Refresh;
  curteam := -1;
  curmove := -1;

  PregamePanel.top := TurnLabel.top;
  PregamePanel.left := field[0,0].left;
  PregamePanel.height := comment.top - TurnLabel.top - 3;
  PregamePanel.width := 521;
  PregamePanel.visible := false;

  {create new logfile}
  fn := curdir + 'autosave.$bm';
  AssignFile(ff, fn);
  {$I-}
  Rewrite(ff);
  {$I+}
  if IOResult <> 0 then begin
    Application.MessageBox('You already have PBEMBB running....',
          'Bloodbowl Error', mb_OK);
    Halt;
  end;

  FormReset(true, false);

  for g := 0 to 1 do RepaintColor(g);
end;

procedure TBloodbowl.ApoWizClick(Sender: TObject);
var g: integer;
begin
  if (not(frmSettings.cbUpApoth.checked)) and
    ((((Sender as TLabel).top = apo[0].top) and
    ((Sender as TLabel).Left = apo[0].Left)) or
    (((Sender as TLabel).top = apo[1].top) and
    ((Sender as TLabel).Left = apo[1].Left))) then begin
      if (Sender as TLabel) = apo[0] then g := 0 else g := 1;
      if apo[g].color = colorarray[g, 0, 0] then begin
        GameStatus := 'Apoth1';
        Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO APOTHECARY';
        ActionTeam := g;
      end;

  end else
    if (frmSettings.cbUpApoth.checked) and
      ((((Sender as TLabel).top = apo1[0].top) and
      ((Sender as TLabel).Left = apo1[0].Left)) or
      (((Sender as TLabel).top = apo1[1].top) and
      ((Sender as TLabel).Left = apo1[1].Left))) then begin
      if (Sender as TLabel) = apo1[0] then g := 0 else g := 1;
      if apo1[g].color = colorarray[g, 0, 0] then begin
        GameStatus := 'Apoth1';
        Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO APOTHECARY';
        ActionTeam := g;
      end;

  end else
    if (frmSettings.cbUpApoth.checked) and
      ((((Sender as TLabel).top = apo2[0].top) and
      ((Sender as TLabel).Left = apo2[0].Left)) or
      (((Sender as TLabel).top = apo2[1].top) and
      ((Sender as TLabel).Left = apo2[1].Left))) then begin
      if (Sender as TLabel) = apo2[0] then g := 0 else g := 1;
      if apo2[g].color = colorarray[g, 0, 0] then begin
        GameStatus := 'Apoth2';
        Loglabel.caption := 'CLICK ON THE NIGGLED PLAYER YOU WISH TO APOTHECARY';
        ActionTeam := g;
      end;

  end else
    if (frmSettings.cbUpApoth.checked) and
      ((((Sender as TLabel).top = apo3[0].top) and
      ((Sender as TLabel).Left = apo3[0].Left)) or
      (((Sender as TLabel).top = apo3[1].top) and
      ((Sender as TLabel).Left = apo3[1].Left))) then begin
      if (Sender as TLabel) = apo3[0] then g := 0 else g := 1;
      if apo3[g].color = colorarray[g, 0, 0] then begin
        if CanWriteToLog then begin
          LogWrite('a' + Chr(g + 48) + '3');
          AddLog(ffcl[g] + ' disables the Level 3 Apothecary');
          apo3[g].color := colorarray[g, 4, 0];
          apo3[g].font.color := colorarray[g, 4, 1];
        end;
      end;

  end else
    if (frmSettings.cbUpApoth.checked) and
      ((((Sender as TLabel).top = apo4[0].top) and
      ((Sender as TLabel).Left = apo4[0].Left)) or
      (((Sender as TLabel).top = apo4[1].top) and
      ((Sender as TLabel).Left = apo4[1].Left))) then begin
      if (Sender as TLabel) = apo4[0] then g := 0 else g := 1;
      if apo4[g].color = colorarray[g, 0, 0] then begin
        GameStatus := 'Apoth4';
        Loglabel.caption := 'CLICK ON THE SERIOUSLY INJURED PLAYER YOU WISH TO APOTHECARY';
        ActionTeam := g;
      end;

  end else
    if (frmSettings.cbUpApoth.checked) and
      ((((Sender as TLabel).top = apo5[0].top) and
      ((Sender as TLabel).Left = apo5[0].Left)) or
      (((Sender as TLabel).top = apo5[1].top) and
      ((Sender as TLabel).Left = apo5[1].Left))) then begin
      if (Sender as TLabel) = apo5[0] then g := 0 else g := 1;
      if apo5[g].color = colorarray[g, 0, 0] then begin
        GameStatus := 'Apoth5';
        Loglabel.caption := 'CLICK ON THE DEAD PLAYER YOU WISH TO APOTHECARY';
        ActionTeam := g;
      end;

  end else
    {if (((Sender as TLabel).top = wiz[0].top) and
      ((Sender as TLabel).Left = wiz[0].Left)) or
      (((Sender as TLabel).top = wiz[1].top) and
      ((Sender as TLabel).Left = wiz[1].Left)) then begin
      if (Sender as TLabel) = wiz[0] then g := 0 else g := 1;
      if wiz[g].color = colorarray[g, 0, 0] then begin
        if CanWriteToLog then begin
          LogWrite('W' + Chr(g + 48));
          AddLog(ffcl[g] + '''s Wizard casts a spell');
          wiz[g].color := colorarray[g, 4, 0];
          wiz[g].font.color := colorarray[g, 4, 1];
        end;
      end;
    end;}
end;

procedure ApoWizCreate(g: integer);
begin
  if not(frmSettings.cbUpApoth.checked) then begin
    apo[g] := TLabel.Create(Bloodbowl);
    apo[g].autosize := false;
    apo[g].caption := 'APO';
    apo[g].height := 19;
    apo[g].width := 38;
    apo[g].top := pnlDugOut[0,3].top + 3;
    if g = 0 then begin
      apo[g].left := pnlDugOut[0,3].left - 40;
    end else begin
      apo[g].left := pnlDugOut[1,3].left + pnlDugOut[1,3].width + 2;
    end;
    apo[g].visible := true;
    apo[g].alignment := taCenter;
    apo[g].font.size := 12;
    apo[g].color := colorarray[g, 0, 0];
    apo[g].font.color := colorarray[g, 0, 1];
    apo[g].hint := 'Click to use Apothecary';
    apo[g].showhint := true;
    apo[g].OnClick := Bloodbowl.ApoWizClick;
    apo[g].parent := Bloodbowl;
  end else begin
    apo1[g] := TLabel.Create(Bloodbowl);
    apo1[g].autosize := false;
    apo1[g].caption := 'A';
    apo1[g].height := 19;
    apo1[g].width := 13;
    apo1[g].top := pnlDugOut[0,3].top + 3;
    if g = 0 then begin
      apo1[g].left := pnlDugOut[0,3].left - 66;
    end else begin
      apo1[g].left := pnlDugOut[1,3].left + pnlDugOut[1,3].width + 2;
    end;
    apo1[g].visible := true;
    apo1[g].alignment := taCenter;
    apo1[g].font.size := 12;
    apo1[g].color := colorarray[g, 0, 0];
    apo1[g].font.color := colorarray[g, 0, 1];
    apo1[g].hint := 'Click to use Level 1 Apothecary';
    apo1[g].showhint := true;
    apo1[g].OnClick := Bloodbowl.ApoWizClick;
    apo1[g].parent := Bloodbowl;
    apo2[g] := TLabel.Create(Bloodbowl);
    apo2[g].autosize := false;
    apo2[g].caption := 'P';
    apo2[g].height := 19;
    apo2[g].width := 13;
    apo2[g].top := pnlDugOut[0,3].top + 3;
    if g = 0 then begin
      apo2[g].left := pnlDugOut[0,3].left - 53;
    end else begin
      apo2[g].left := pnlDugOut[1,3].left + pnlDugOut[1,3].width + 15;
    end;
    apo2[g].visible := true;
    apo2[g].alignment := taCenter;
    apo2[g].font.size := 12;
    apo2[g].color := colorarray[g, 0, 0];
    apo2[g].font.color := colorarray[g, 0, 1];
    apo2[g].hint := 'Click to use Level 2 Apothecary';
    apo2[g].showhint := true;
    apo2[g].OnClick := Bloodbowl.ApoWizClick;
    apo2[g].parent := Bloodbowl;
    apo3[g] := TLabel.Create(Bloodbowl);
    apo3[g].autosize := false;
    apo3[g].caption := 'O';
    apo3[g].height := 19;
    apo3[g].width := 13;
    apo3[g].top := pnlDugOut[0,3].top + 3;
    if g = 0 then begin
      apo3[g].left := pnlDugOut[0,3].left - 40;
    end else begin
      apo3[g].left := pnlDugOut[1,3].left + pnlDugOut[1,3].width + 28;
    end;
    apo3[g].visible := true;
    apo3[g].alignment := taCenter;
    apo3[g].font.size := 12;
    apo3[g].color := colorarray[g, 0, 0];
    apo3[g].font.color := colorarray[g, 0, 1];
    apo3[g].hint := 'Click to use Level 3 Apothecary';
    apo3[g].showhint := true;
    apo3[g].OnClick := Bloodbowl.ApoWizClick;
    apo3[g].parent := Bloodbowl;
    apo4[g] := TLabel.Create(Bloodbowl);
    apo4[g].autosize := false;
    apo4[g].caption := 'T';
    apo4[g].height := 19;
    apo4[g].width := 13;
    apo4[g].top := pnlDugOut[0,3].top + 3;
    if g = 0 then begin
      apo4[g].left := pnlDugOut[0,3].left - 27;
    end else begin
      apo4[g].left := pnlDugOut[1,3].left + pnlDugOut[1,3].width + 41;
    end;
    apo4[g].visible := true;
    apo4[g].alignment := taCenter;
    apo4[g].font.size := 12;
    apo4[g].color := colorarray[g, 0, 0];
    apo4[g].font.color := colorarray[g, 0, 1];
    apo4[g].hint := 'Click to use Level 4 Apothecary';
    apo4[g].showhint := true;
    apo4[g].OnClick := Bloodbowl.ApoWizClick;
    apo4[g].parent := Bloodbowl;
    apo5[g] := TLabel.Create(Bloodbowl);
    apo5[g].autosize := false;
    apo5[g].caption := 'H';
    apo5[g].height := 19;
    apo5[g].width := 13;
    apo5[g].top := pnlDugOut[0,3].top + 3;
    if g = 0 then begin
      apo5[g].left := pnlDugOut[0,3].left - 14;
    end else begin
      apo5[g].left := pnlDugOut[1,3].left + pnlDugOut[1,3].width + 54;
    end;
    apo5[g].visible := true;
    apo5[g].alignment := taCenter;
    apo5[g].font.size := 12;
    apo5[g].color := colorarray[g, 0, 0];
    apo5[g].font.color := colorarray[g, 0, 1];
    apo5[g].hint := 'Click to use Level 5 Apothecary';
    apo5[g].showhint := true;
    apo5[g].OnClick := Bloodbowl.ApoWizClick;
    apo5[g].parent := Bloodbowl;
  end;
  wiz[g] := TLabel.Create(Bloodbowl);
  wiz[g].autosize := false;
  wiz[g].caption := 'WIZ';
  wiz[g].height := 19;
  wiz[g].width := 38;
  if frmSettings.cbUpApoth.checked then begin
    wiz[g].top := apo1[g].top {/// was: - 20};
    if g = 0 then
      wiz[g].left := apo3[g].left + (2 * g - 1) * ((apo5[g].width*5) + 2)
    else wiz[g].left := apo1[g].left + (2 * g - 1) * ((apo1[g].width*5) + 2);
  end else begin
    wiz[g].top := apo[g].top {/// was: - 20};
    wiz[g].left := apo[g].left
      {/// added:} + (2 * g - 1) * (apo[g].width + 2); {/// until here};
  end;
  wiz[g].visible := false;
  wiz[g].alignment := taCenter;
  wiz[g].font.size := 12;
  wiz[g].color := colorarray[g, 0, 0];
  wiz[g].font.color := colorarray[g, 0, 1];
  wiz[g].hint := 'Click to use Wizard';
  wiz[g].showhint := true;
  wiz[g].OnClick := Bloodbowl.ApoWizClick;
  wiz[g].parent := Bloodbowl;
  if not(frmSettings.cbUpApoth.checked) then begin
    if team[g].apot > 0 then begin
      apo[g].color := colorarray[g, 0, 0];
      apo[g].font.color := colorarray[g, 0, 1];
      apo[g].visible := true;
    end else apo[g].visible := false;
  end else begin
    if team[g].apot = 0 then begin
      apo1[g].visible := false;
      apo2[g].visible := false;
      apo3[g].visible := false;
      apo4[g].visible := false;
      apo5[g].Visible := false;
    end else begin
      apo1[g].visible := true;
      apo1[g].color := colorarray[g, 0, 0];
      apo1[g].font.color := colorarray[g, 0, 1];
      apo2[g].visible := true;
      apo2[g].color := colorarray[g, 4, 0];
      apo2[g].font.color := colorarray[g, 4, 1];
      apo3[g].visible := true;
      apo3[g].color := colorarray[g, 4, 0];
      apo3[g].font.color := colorarray[g, 4, 1];
      apo4[g].visible := true;
      apo4[g].color := colorarray[g, 4, 0];
      apo4[g].font.color := colorarray[g, 4, 1];
      apo5[g].visible := true;
      apo5[g].color := colorarray[g, 4, 0];
      apo5[g].font.color := colorarray[g, 4, 1];
      if team[g].apot >= 2 then begin
        apo2[g].color := colorarray[g, 0, 0];
        apo2[g].font.color := colorarray[g, 0, 1];
      end;
      if team[g].apot >= 3 then begin
        apo3[g].color := colorarray[g, 0, 0];
        apo3[g].font.color := colorarray[g, 0, 1];
      end;
      if team[g].apot >= 4 then begin
        apo4[g].color := colorarray[g, 0, 0];
        apo4[g].font.color := colorarray[g, 0, 1];
      end;
      if team[g].apot = 5 then begin
        apo5[g].color := colorarray[g, 0, 0];
        apo5[g].font.color := colorarray[g, 0, 1];
      end;
    end;
  end;
end;

procedure TBloodbowl.FormClose(Sender: TObject; var Action: TCloseAction);
var SaveAnswer: string;
begin
  if Bloodbowl.SaveGame1.Visible then begin
    SaveAnswer := ' ';
    SaveAnswer := FlexMessageBox('You have not saved.  Do you really wish to Quit?'
               , 'Quit without Saving Notice', 'No,Yes');
    if SaveAnswer<>'Yes' then Action := caNone;
    if SaveAnswer='Yes' then begin
      CloseFile(ff);
      if not(AutoSave) then begin
        DeleteFile(curdir + 'autosave.$bm');
      end;
      frmWelcome.Close;
    end;
  end else begin
    CloseFile(ff);
    if not(AutoSave) then begin
      DeleteFile(curdir + 'autosave.$bm');
    end;
    frmWelcome.Close;
  end;
end;

procedure TBloodbowl.EnterButtonClick(Sender: TObject);
var p, q, r, av, armod, injmod, refroll, refpos: integer;
    eye: boolean;
    s: string;
begin
  if comment.Text <> '' then begin
    if comment.Text[1] = '*' then begin
      p := Pos('arm', comment.Text);
      if p > 0 then begin
        if CanWriteToLog then begin
          armod := 0;
          injmod := 0;
          av := FVal(copy(comment.Text, p+3, 2));
          q := Pos('+', copy(comment.Text, p+4, length(comment.Text)));
          if q > 0 then begin
            armod := FVal(copy(comment.Text, p+q+4, 2));
            r := Pos('+', copy(comment.Text, p+q+5, length(comment.Text)));
            if r > 0 then begin
              injmod := FVal(copy(comment.Text, p+q+r+5, 2));
            end else begin
              r := Pos('&', copy(comment.Text, p+q+5, length(comment.Text)));
              if r > 0 then begin
                injmod := - FVal(copy(comment.Text, p+q+r+5, 2));
              end;
            end;
          end;
          s := Chr(av + 48) + ArmourRoll(av, armod, injmod);
          LogWrite('Z' + s);
          AddLog(ArmourRollToText(s));
        end;
      end;
      p := Pos('inj', comment.Text);
      if p > 0 then begin
        if CanWriteToLog then begin
          injmod := 0;
          r := Pos('+', copy(comment.Text, p+3, length(comment.Text)));
          if r > 0 then begin
            injmod := FVal(copy(comment.Text, p+r+3, 2));
          end else begin
            r := Pos('&', copy(comment.Text, p+3,length(comment.Text)));
            if r > 0 then begin
              injmod := - FVal(copy(comment.Text, p+r+3, 2));
            end;
            if injmod = -7 then injmod := -1;
            if injmod = -8 then injmod := 0;
            if injmod = -9 then injmod := 1;
          end;
          s := InjuryRoll(injmod);
          LogWrite('z' + s);
          AddLog(InjuryRollToText(s));
        end;
      end;
      p := Pos('foul', comment.Text);
      if p > 0 then begin
        if CanWriteToLog then begin
          armod := 0;
          injmod := 0;
          av := FVal(copy(comment.Text, p+4, 2));
          q := Pos('+', copy(comment.Text, p+5, length(comment.Text)));
          if q > 0 then begin
            armod := FVal(copy(comment.Text, p+q+5, 2));
            r := Pos('+', copy(comment.Text, p+q+6, length(comment.Text)));
            if r > 0 then begin
              injmod := FVal(copy(comment.Text, p+q+r+6, 2));
            end else begin
              r := Pos('&', copy(comment.Text, p+q+6, length(comment.Text)));
              if r > 0 then begin
                injmod := - FVal(copy(comment.Text, p+q+r+6, 2));
              end;
            end;
          end;
          eye := (Pos('IGMEOY', comment.text) > 0);
          s := Chr(av + 48) + FoulRoll(av, armod, injmod, eye);
          LogWrite('^' + s);
          {RONALD: CHANGE HERE: Use PlayAction instead of copying the code}
          PlayActionFoulRoll('^' + s, 1);
        end;
      end;
      p := Pos('c@rds', comment.Text);
      if p > 0 then begin
        ShowCards(2);
        p := FVal(Copy(comment.Text, p+5, 1));
        if DrawNewCards then begin
          s := 'Ç';
          if CanWriteToLog then begin
            LogWrite(s + Chr(p+48) + plcards[p]);
            q := 3;
            s := '';
            while q < length(plcards[p]) do begin
              for r := 1 to numset do
                if plcards[p][q] = setabbr[r][1] then s := s + setabbr[r] + ' ';
              q := q + 2;
            end;
            if p = 0 then
              Bloodbowl.LblCardsRed.caption := s
            else
              Bloodbowl.LblCardsBlue.caption := s;
            s := 'Cards for ' + ffcl[p] + ': ' + s;
            s := s + '(cards from ' + frmSettings.txtCardsIniFile.text + ')';
            AddLog(Trim(s));
          end;
        end else begin
          s := '>';
          if CanWriteToLog then begin
            LogWrite(s + Chr(p+48) + plcards[p]);
            q := length(plcards[p]) - 1;
            s := 'Extra Card for ' + ffcl[p] + ':';
            for r := 1 to numset do
              if plcards[p][q] = setabbr[r][1] then s := s + ' ' + setabbr[r];
            s := s + '(cards from ' + frmSettings.txtCardsIniFile.text + ')';
            AddLog(s);
          end;
        end;
      end;
      p := Pos('throwin', comment.Text);
      if p > 0 then begin
        s := 'i' + Copy(comment.Text, p + 8, 3);
        if CanWriteToLog then begin
          LogWrite(s);
          AddLog(TranslateThrowIn(s));
        end;
      end;
    end else if comment.Text[1] = '!' then begin
      s := Trim(Copy(comment.Text, 2, length(comment.text)));
      if CanWriteToLog then begin
        LogWrite(Chr(252) + s + Chr(255));
        AddNote(s);
        AddLog('Note: "' + s + '"');
      end;
    end else begin
      if SpeakLabel.caption[1] = 'H' then s := Chr(253) else s := Chr(254);
      if CanWriteToLog then begin
        LogWrite(s + comment.Text + Chr(255));
        if SpeakLabel.caption[1] = 'H' then s := ffcl[0] else s := ffcl[1];
        AddLog(s + ': "' + comment.text + '"');
      end;
    end;
    comment.Text := '';
  end else begin
    p := FVal(frmLogControl.logcounter.text);
    if p <> logcount then GotoEntry(p);
  end;
end;

function GetNextInLog: string;
var s: string;
begin
  s := LogRead;
  if s = '' then GetNextInLog := ' ' else GetNextInLog := s;
end;

procedure PlayOne(w: integer);
var s: string;
    t: char;
    lp: longint;
    done: boolean;
begin
  WaitLength := w;
  done := EOGameLog;
  if not(done) then s := GetNextInLog;
  while not(done) do begin
    done := true;
    if s[1] = ')' then begin
      done := false;
      s := Copy(s, 2, Length(s) - 1);
    end;
    t := s[1];
    case t of
      Chr(252): PlayActionNote(s, 1);
      Chr(253): PlayActionComment(s, 1, 0);
      Chr(254): PlayActionComment(s, 1, 1);
      Chr(255): PlayActionComment(s, 1, 2);
      '+', '/', '=': if CheckFileOpen then PlayActionCheat(s);
      '.': PlayActionNumOnField(s, 1);
      ';': PlayActionMakeCurrent(s, 1);
      ',': PlayActionUnCur(s, 1);
      '!': PlayActionRollBlockDice(s, 1, 1);
      '@': PlayActionRollBlockDice(s, 1, 2);
      '#': PlayActionRollBlockDice(s, 1, 3);
      '^': PlayActionFoulRoll(s, 1);
      ']': PlayActionAddCard(s, 1, false);
      '>': PlayActionAddCard(s, 1, true);
      '1': PlayActionRoll1Die(s, 1);
      '2': PlayActionRoll2Dice(s, 1);
      '8': PlayActionRollScatter(s, 1);
      'A': PlayActionMoveToReserve(s, 1);
      'a': PlayActionUseApo(s, 1);
      'B': PlayActionPlaceBall(s, 1);
      'b': PlayActionBlockMove(s, 1);
      'C': PlayActionDrawCards(s, 1, false);
      'c': PlayActionPlayCard(s, 1);
      'Ç': PlayActionDrawCards(s, 1, true);
      'D': begin
            case s[2] of
             'W': PlayActionWeatherRoll(s, 1);
             'K': PlayActionKickOff(s, 1);
             'G': PlayActionGate(s, 1, 0);
             'S': PlayActionGate(s, 1, 1);
             'F': PlayActionGate(s, 1, 2);
             '0': PlayActionMVP(s, 1);
             '1': PlayActionMVP(s, 1);
             'H': PlayActionHandicap(s, 1);
             'h': PlayActionHandicapTable(s, 1);
             'C': PlayActionCardsRoll(s, 1);
             'N': PlayActionNiggles(s, 1);
             'n': PlayActionNiggleResult(s, 1);
             'T': PlayActionToss(s, 1);
            end;
          end;
      'E': PlayActionSetIGMEOY(s, 1);
      'e': PlayActionBombPlayer(s, 1);
      'F': PlayActionFieldPlayer(s, 1);
      'f': PlayActionFanFactor(s, 1);
      'G': PlayActionStartPostGame(s, 1);
      'g': PlayActionColorChange(s, 1);
      'H': PlayActionHandicapRolls(s, 1);
      'h': PlayActionHideBall(s, 1);
      'I': PlayActionComputerID(s, 1);
      'i': PlayActionThrowIn(s, 1);
      'J': PlayActionCoachRef(s, 1);
      'j': PlayActionRemoveACCH(s, 1);
      'K': PlayActionPrepareForKickoff(s, 1);
      'k': PlayActionUseSkill(s, 1);
      'L': PlayActionLoadTeam(s, 1);
      'l': PlayActionLuck(s, 1);
      'M': PlayActionPlayerMove(s, 1);
      'm': PlayActionMarkerChange(s, 1);
      'N': begin
             case s[2] of
               'R', 'a', 'C', 'A', 'W', 'X', 'Z': PlayActionBuy(s, 1);
             else
               PlayActionAddPlayer(s, 1);
             end;
           end;
      'P': PlayActionSetStatus(s, 1);
      'p': PlayActionSPP(s, 1);
      'Q': begin
             case s[2] of
               'F': PlayActionSideStep(s, 1);
               'P': PlayActionPGFI(s, 1);
               'S': PlayActionDeStun(s, 1);
             end;
           end;
      'q': PlayActionReverseSPP(s, 1);
      'R': PlayActionRetire(s, 1);
      'r': PlayActionMoveToReserve(s, 1);
      '®': PlayActionRiot(s, 1);
      'S': PlayActionTeamStatChange(s, 1);
      's': PlayActionSkillRoll(s, 1);
      'T': PlayActionTurn(s, 1);
      't': PlayActionStartHalf(s, 1);
      'U': PlayActionToggleTackleZone(s, 1);
      'u': PlayActionPlayerStatChange(s, 1);
      'V': PlayActionPlaybook(s, 1);
      'W': PlayActionUseWiz(s, 1);
      'w': if s[2] = '0' then PlayActionMatchWinnings(s, 1)
                         else PlayActionMatchWinningsMod(s, 1);
      'X': PlayActionResetMove(s, 1);
      'x': PlayActionEndOfMove(s, 1);
      'Y': PlayActionRandomPlayer(s, 1);
      'Z': PlayActionArmourRoll(s, 1);
      'z': PlayActionInjuryRoll(s, 1);
    end;
    lp := GetCurrentLogPos;
    if not(EOGameLog) then begin
      s := GetNextInLog;
      if s[1] = '(' then begin
        s := Copy(s, 2, length(s) - 1);
        done := false;
      end else if done then GoToGameLog(lp);
    end else done := true;
  end;
end;

function GetPrevInLog: string;
var s: string;
begin
  s := '';
  while ((s = '') or (s = '+')) and not(BOGameLog) do s := LogReadBack;
  GetPrevInLog := s;
end;

procedure PlayOneBack;
var s: string;
    t: char;
    done: boolean;
begin
  s := GetPrevInLog;
  done := (s = '');
  while not(done) do begin
    if s[1] = ')' then s[1] := '(';
    if s[1] = '(' then s := Copy(s, 2, length(s) - 1) else done := true;
    t := s[1];
    case t of
      Chr(252): PlayActionNote(s, -1);
      Chr(253): PlayActionComment(s, -1, 0);
      Chr(254): PlayActionComment(s, -1, 1);
      Chr(255): PlayActionComment(s, -1, 2);
      '.': PlayActionNumOnField(s, -1);
      ';': PlayActionMakeCurrent(s, -1);
      ',': PlayActionUnCur(s, -1);
      '!': PlayActionRollBlockDice(s, -1, 1);
      '@': PlayActionRollBlockDice(s, -1, 2);
      '#': PlayActionRollBlockDice(s, -1, 3);
      '^': PlayActionFoulRoll(s, -1);
      ']': PlayActionAddCard(s, -1, false);
      '>': PlayActionAddCard(s, -1, true);
      '1': PlayActionRoll1Die(s, -1);
      '2': PlayActionRoll2Dice(s, -1);
      '8': PlayActionRollScatter(s, -1);
      'A': PlayActionMoveToReserve(s, -1);
      'a': PlayActionUseApo(s, -1);
      'B': PlayActionPlaceBall(s, -1);
      'b': PlayActionBlockMove(s, -1);
      'C': PlayActionDrawCards(s, -1, false);
      'c': PlayActionPlayCard(s, -1);
      'Ç': PlayActionDrawCards(s, -1, true);
      'D': begin
            case s[2] of
             'W': PlayActionWeatherRoll(s, -1);
             'K': PlayActionKickOff(s, -1);
             'G': PlayActionGate(s, -1, 0);
             'S': PlayActionGate(s, -1, 1);
             'F': PlayActionGate(s, -1, 2);
             '0': PlayActionMVP(s, -1);
             '1': PlayActionMVP(s, -1);
             'H': PlayActionHandicap(s, -1);
             'h': PlayActionHandicapTable(s, -1);
             'C': PlayActionCardsRoll(s, -1);
             'N': PlayActionNiggles(s, -1);
             'n': PlayActionNiggleResult(s, -1);
             'T': PlayActionToss(s, -1);
            end;
           end;
      'E': PlayActionSetIGMEOY(s, -1);
      'e': PlayActionBombPlayer(s, -1);
      'F': PlayActionFieldPlayer(s, -1);
      'f': PlayActionFanFactor(s, -1);
      'G': PlayActionStartPostGame(s, -1);
      'g': PlayActionColorChange(s, -1);
      'H': PlayActionHandicapRolls(s, -1);
      'h': PlayActionHideBall(s, -1);
      'I': PlayActionComputerID(s, -1);
      'i': PlayActionThrowIn(s, -1);
      'J': PlayActionCoachRef(s, -1);
      'j': PlayActionRemoveACCH(s, -1);
      'K': PlayActionPrepareForKickoff(s, -1);
      'k': PlayActionUseSkill(s, -1);
      'L': PlayActionLoadTeam(s, -1);
      'l': PlayActionLuck(s, -1);
      'M': PlayActionPlayerMove(s, -1);
      'm': PlayActionMarkerChange(s, -1);
      'N': begin
             case s[2] of
               'R', 'a', 'C', 'A', 'W', 'X', 'Z': PlayActionBuy(s, -1);
             else
               PlayActionAddPlayer(s, -1);
             end;
           end;
      'P': PlayActionSetStatus(s, -1);
      'p': PlayActionSPP(s, -1);
      'Q': begin
             case s[2] of
               'F': PlayActionSideStep(s, -1);
               'P': PlayActionPGFI(s, -1);
               'S': PlayActionDeStun(s, -1);
             end;
           end;
      'q': PlayActionReverseSPP(s, -1);
      'R': PlayActionRetire(s, -1);
      'r': PlayActionMoveToReserve(s, -1);
      '®': PlayActionRiot(s, -1);
      'S': PlayActionTeamStatChange(s, -1);
      's': PlayActionSkillRoll(s, -1);
      'T': PlayActionTurn(s, -1);
      't': PlayActionStartHalf(s, -1);
      'U': PlayActionToggleTackleZone(s, -1);
      'u': PlayActionPlayerStatChange(s, -1);
      'V': PlayActionPlaybook(s, -1);
      'W': PlayActionUseWiz(s, -1);
      'w': if s[2] = '0' then PlayActionMatchWinnings(s, -1)
                         else PlayActionMatchWinningsMod(s, -1);
      'X': PlayActionResetMove(s, -1);
      'x': PlayActionEndOfMove(s, -1);
      'Y': PlayActionRandomPlayer(s, -1);
      'Z': PlayActionArmourRoll(s, -1);
      'z': PlayActionInjuryRoll(s, -1);
    end;
    if not(done) then begin
      s := GetPrevInLog;
    end else begin
      s := GetPreviousGameLog;
      if s[1] = ')' then begin
        s := GetPrevInLog;
        done := false;
        s := Copy(s, 2, Length(s) - 1);
      end;
    end;
  end;
end;

procedure GotoEntry(e: integer);
begin
  SetItem := false;
  if e < logcount then begin
    while e < logcount do PlayOneBack;
  end else begin
    while (e > logcount) and not(EOGameLog) do PlayOne(0);
  end;
  SetCurrentLogItem;
end;

procedure TBloodbowl.Goto1Click(Sender: TObject);
begin
  frmLogControl.logcounter.SetFocus;
  frmLogControl.logcounter.SelectAll;
end;

procedure TBloodbowl.Movetofield1Click(Sender: TObject);
begin
  player[curteam, curplayer].StartMoveToField;
end;

procedure TBloodbowl.BallMouseDown(Sender: TObject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbLeft then begin
    (Sender as TImage).BeginDrag(false);
  end;
end;

procedure TBloodbowl.BallDragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
var i: TImage;
begin
  i := (Sender as TImage);
end;

procedure TBloodbowl.MovetoReserve1Click(Sender: TObject);
begin
  if player[curteam,curplayer].status = 12 then begin
    if player[curteam,curplayer].SOstatus <= 4 then
       player[curteam,curplayer].SetStatus(0) else
       player[curteam,curplayer].SetStatus(player[curteam,curplayer].SOstatus);
    if player[curteam,curplayer].SOstatus = 7 then
       player[curteam,curplayer].SIstatus :=
         player[curteam,curplayer].SOSIstatus;
  end else player[curteam,curplayer].SetStatus(0);
end;

procedure TBloodbowl.Placeball1Click(Sender: TObject);
var f, g: integer;
begin
  for f := 0 to 14 do
   for g := 0 to 25 do if fieldPopup.PopupComponent = field[f,g] then begin
     PlaceBall(f, g);
   end;
end;

procedure TBloodbowl.Endofmove1Click(Sender: TObject);
var f, g: integer;
    s: string;
begin
  g := curteam;
  f := curplayer;
  if CanWriteToLog then begin
    s := 'x' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
    LogWrite(s);
    PlayActionEndOfMove(s, 1);
  end;
end;

procedure TBloodbowl.Resetmove1Click(Sender: TObject);
var f, g: integer;
    s: string;
begin
  g := curteam;
  f := curplayer;
  if CanWriteToLog then begin
    s := 'X' + Chr(g + 48) + Chr(f + 65) + Chr(player[g,f].UsedMA + 64);
    LogWrite(s);
    PlayActionResetMove(s, 1);
  end;
end;

procedure TBloodbowl.Move1Click(Sender: TObject);
begin
  GameStatus := 'Move player';
end;

procedure TBloodbowl.Standing1Click(Sender: TObject);
var tz, tz0: TackleZones;
    p, StandUp, r2, targetaction, g, f, WATarget: integer;
    s, ReRollAnswer, WAAnswer: string;
    bga, reroll, proskill, WAPass, WACheck, UReroll: boolean;
begin
  g := curteam;
  f := curplayer;
  ActionTeam := curteam;
  ActionPlayer := curplayer;
  LeftClickPlayer(curteam,curplayer);
  if curteam = g then begin
    if ((not(player[g,f].hasSkill('SLOW'))) and
       (not((player[g,f].ma<=2)))) or
       (player[g,f].hasSkill('Jump Up'))
       then begin
       player[g,f].SetStatus(1);
    end else if (player[g,f].status) > 2 then begin
        tz := CountTZSlow(g, f);
        StandUp := 0;
        for p := 1 to tz.num do begin
          if tz.pl[p] <> f then begin
             tz0 := CountTZ(g, tz.pl[p]);
             if tz0.num=0 then StandUp := StandUp + 1;
          end;
        end;
        if (player[g,f].hasSkill('SLOW')) then
          Bloodbowl.comment.text := 'Stand Up roll with ' + IntToStr(StandUp) +
          ' assists';
        if (not (player[g,f].hasSkill('SLOW'))) and
         ((player[g,f].ma)<=2) then begin
            Bloodbowl.comment.text := 'Stand Up roll 4+ to succeed';
            StandUp := 0;
        end;
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        if lastroll<>1 then lastroll := lastroll + StandUp;
        r2 := lastroll;

        if lastroll < 4 then begin
          bga := (((player[ActionTeam,ActionPlayer].BigGuy) or
            (player[ActionTeam,ActionPlayer].Ally))
            and (frmSettings.rgBGA4th.ItemIndex >= 1));
          proskill := ((player[ActionTeam,ActionPlayer].HasSkill('Pro'))) and
            (not (player[ActionTeam,ActionPlayer].usedSkill('Pro')))
            and (ActionTeam = curmove);
          reroll := CanUseTeamReroll(bga);
          ReRollAnswer := 'Fail Roll';
          if reroll and proskill then begin
            ReRollAnswer := FlexMessageBox('Stand Up roll has failed!'
              , 'Stand Up Failure',
              'Use Pro,Team Reroll,Fail Roll');
          end else if proskill then begin
            ReRollAnswer := 'Use Pro';
          end else if reroll then begin
            ReRollAnswer := FlexMessageBox('Stand Up roll failed!'
              , 'Stand Up Failure', 'Fail Roll,Team Reroll');
          end;
          if ReRollAnswer='Team Reroll' then begin
            UReroll := UseTeamReroll;
            if UReroll then begin
              Bloodbowl.comment.text := 'Standup reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              if lastroll<>1 then lastroll := lastroll + StandUp;
            end;
          end;
          if ReRollAnswer='Use Pro' then begin
            player[ActionTeam,ActionPlayer].UseSkill('Pro');
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <= 3 then TeamRerollPro(ActionTeam,ActionPlayer);
            if (lastroll <= 3) then lastroll := r2;
            if (lastroll >= 4) then begin
              Bloodbowl.comment.text := 'Pro reroll';
              Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              if lastroll<>1 then lastroll := lastroll + StandUp;
            end;
          end;
        end;

        if lastroll>=4 then begin
          Bloodbowl.comment.text := 'Stand Up roll successful';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          player[g,f].SetStatus(1);
        end else begin
          Bloodbowl.comment.text := 'Stand Up roll failed!';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          s := 'x' + Chr(g + 48) + Chr(f + 65) +
             Chr(player[g,f].UsedMA + 64);
          LogWrite(s);
          PlayActionEndOfMove(s, 1);
        end;
    end;
  end;
end;

procedure TBloodbowl.Ballcarrier1Click(Sender: TObject);
begin
  player[curteam,curplayer].SetStatus(2);
end;

procedure TBloodbowl.Prone1Click(Sender: TObject);
var g, f: integer;
begin
  g := curteam;
  f := curplayer;
  if not(frmSettings.cbDeStun.Checked) then LeftClickPlayer(curteam,curplayer);
  if g = curteam then begin
    if player[g,f].status=2 then begin
      player[g,f].SetStatus(3);
      ScatterBallFrom((player[g,f].p), (player[g,f].q), 1, 0);
    end else player[g,f].SetStatus(3);
  end;
end;

procedure TBloodbowl.Stunned1Click(Sender: TObject);
begin
  if player[curteam,curplayer].status=2 then begin
    player[curteam,curplayer].SetStatus(4);
    ScatterBallFrom((player[curteam,curplayer].p), (player[curteam,curplayer].q), 1, 0);
  end else player[curteam,curplayer].SetStatus(4);
end;

procedure TBloodbowl.Reserve1Click(Sender: TObject);
begin
 if player[curteam,curplayer].status = 12 then begin
    player[curteam,curplayer].SetStatus(player[curteam,curplayer].SOstatus);
    if player[curteam,curplayer].SOstatus = 7 then
       player[curteam,curplayer].SIstatus :=
         player[curteam,curplayer].SOSIstatus;
  end else player[curteam,curplayer].SetStatus(0);
end;

procedure TBloodbowl.KO1Click(Sender: TObject);
var ploc, qloc: integer;
begin
  if player[curteam,curplayer].status=2 then begin
    ploc := player[curteam,curplayer].p;
    qloc := player[curteam,curplayer].q;
    player[curteam,curplayer].SetStatus(5);
    ScatterBallFrom(ploc, qloc, 1, 0);
  end else player[curteam,curplayer].SetStatus(5);
end;

procedure TBloodbowl.BadlyHurt1Click(Sender: TObject);
var ploc, qloc: integer;
begin
  if player[curteam,curplayer].status=2 then begin
    ploc := player[curteam,curplayer].p;
    qloc := player[curteam,curplayer].q;
    player[curteam,curplayer].SetStatus(6);
    ScatterBallFrom(ploc, qloc, 1, 0);
  end else player[curteam,curplayer].SetStatus(6);
end;

procedure TBloodbowl.SeriouslyInjured1Click(Sender: TObject);
var s: string;
    v, ploc, qloc: integer;
begin
  v := 7;
  s := (Sender as TMenuItem).name;
  if s[3] = 'M' then v := 70; {MNG}
  if s[3] = 'N' then v := 71; {Nigg}
  if s[4] = 'A' then v := 72; {-1 MA}
  if s[3] = 'S' then v := 73; {-1 ST}
  if s[4] = 'G' then v := 74; {-1 AG}
  if s[4] = 'V' then v := 75; {-1 AV}
  if player[curteam,curplayer].status=2 then begin
    ploc := player[curteam,curplayer].p;
    qloc := player[curteam,curplayer].q;
    player[curteam,curplayer].SetStatus(v);
    ScatterBallFrom(ploc, qloc, 1, 0);
  end else player[curteam,curplayer].SetStatus(v);
end;

procedure TBloodbowl.Dead1Click(Sender: TObject);
var ploc, qloc: integer;
begin
  if player[curteam,curplayer].status=2 then begin
    ploc := player[curteam,curplayer].p;
    qloc := player[curteam,curplayer].q;
    player[curteam,curplayer].SetStatus(8);
    ScatterBallFrom(ploc, qloc, 1, 0);
  end else player[curteam,curplayer].SetStatus(8);
end;

procedure TBloodbowl.SendOff1Click(Sender: TObject);
var ploc, qloc: integer;
begin
  if player[curteam,curplayer].status=2 then begin
    ploc := player[curteam,curplayer].p;
    qloc := player[curteam,curplayer].q;
    player[curteam,curplayer].SOstatus := player[curteam,curplayer].status;
    player[curteam,curplayer].SOSIstatus := player[curteam,curplayer].SIstatus;
    player[curteam,curplayer].SetStatus(12);
    ScatterBallFrom(ploc, qloc, 1, 0);
  end else begin
    player[curteam,curplayer].SOstatus := player[curteam,curplayer].status;
    player[curteam,curplayer].SOSIstatus := player[curteam,curplayer].SIstatus;
    player[curteam,curplayer].SetStatus(12);
  end;
  if Bloodbowl.ArgueCallSB.Visible then
    Bloodbowl.comment.Text := 'Remember you can Argue the Call!';
end;

procedure TBloodbowl.MissesMatch1Click(Sender: TObject);
begin
  player[curteam,curplayer].SetStatus(10);
end;

procedure TBloodbowl.TemporaryOut1Click(Sender: TObject);
begin
  player[curteam,curplayer].SetStatus(13);
end;

procedure TBloodbowl.HeatOut1Click(Sender: TObject);
begin
  player[curteam,curplayer].SetStatus(14);
end;

procedure TBloodbowl.HideBall1Click(Sender: TObject);
var f, g, i, LOS, WZone1, WZone2, TotalPlayers, TotalPlaying, TeamTest,
    extratitchy: integer;
    s: string;
    DefenseOK: boolean;
begin
  for f := 0 to 14 do
   for g := 0 to 25 do if fieldPopup.PopupComponent = field[f,g] then begin
     DefenseOK := True;
     {Begin Check for 3 on the Line of Scrimmage and no more than 2 in the
       wide zones}
     if g <= 12 then TeamTest := 1 else TeamTest := 0;
     LOS := 0;
     WZone1 := 0;
     WZone2 := 0;
     TotalPlayers := 0;
     TotalPlaying := 0;
     extratitchy := 0;
     for i := 1 to team[TeamTest].numplayers do begin
       if (frmSettings.rgTitchy.ItemIndex=1) and
         (player[TeamTest,i].HasSkill('Titchy')) then extratitchy := 1;
       if (player[TeamTest,i].q = 12) and (TeamTest = 0) and
         (player[TeamTest,i].p > 3) and (player[TeamTest,i].p < 11) then
         LOS := LOS + 1;
       if (player[TeamTest,i].q = 13) and (TeamTest = 1) and
         (player[TeamTest,i].p > 3) and (player[TeamTest,i].p < 11) then
         LOS := LOS + 1;
       if (player[TeamTest,i].p <= 3) and (Player[TeamTest,i].status >= 1) and
          (Player[TeamTest,i].status <= 2) then WZone1 := WZone1 + 1;
       if (player[TeamTest,i].p >= 11) then WZone2 := WZone2 + 1;
       if (Player[TeamTest,i].status <= 4) then TotalPlayers := TotalPlayers + 1;
       if (Player[TeamTest,i].status >= 1) and (Player[TeamTest,i].status <= 4)
         then TotalPlaying := TotalPlaying + 1;
     end;
     If (TotalPlayers >= 3) and (LOS < 3) and (frmSettings.cbLOS.checked)
       then DefenseOK := False;
     If (TotalPlayers < 3) and (LOS <> TotalPlayers) and (frmSettings.cbLOS.checked)
       then DefenseOK := False;
     if (TotalPlayers >= 11) and (TotalPlaying < 11)
       and (frmSettings.cbRuleof11.checked) then DefenseOK := False;
     if (TotalPlayers < 11) and (TotalPlaying <> TotalPlayers)
       and (frmSettings.cbRuleof11.checked) then DefenseOK := False;
     If (WZone1 > 2) and (frmSettings.cbWideZone.checked) then DefenseOK := False;
     If (WZone2 > 2) and (frmSettings.cbWideZone.checked) then DefenseOK := False;
     if (TotalPlaying>11) and (extratitchy=0) then begin
       Application.Messagebox('You have set up more than 12 players! '
        ,'Bloodbowl Possible Illegal Defense Warning', MB_OK);
     end;
     if DefenseOK then begin
       s := 'h' + Chr(f + 65) + Chr(g + 65) + ' ';
       LogWrite(s);
       Bloodbowl.comment.text := 'Ball hidden for kickoff';
       Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
       Bloodbowl.comment.Text := 'Ball hidden at ' + field[f,g].hint;
       HideBallP := f;
       HideBallQ := g;
     end else begin
       Application.Messagebox('Illegal Kicking Defensive formation.  Ball cannot ' +
        'be hidden!','Bloodbowl Illegal Defense Warning', MB_OK);
     end;
   end;
end;

procedure TBloodbowl.CrowdRoll1Click(Sender: TObject);
var ploc, qloc, arrow: integer;
begin
  HitTeam := -1;
  HitPlayer := -1;
  BlockTeam := -1;
  BlockPlayer := -1;
  BashTeam := -1;
  BashPlayer := -1;
  DownTeam := -1;
  DownPlayer := -1;
  GetCAS := false;
  AVBreak := false;
  InjurySettings(curteam, curplayer);
  if InjuryStatus = 4 then InjuryStatus := 0;
  if player[curteam,curplayer].status=2 then begin
    ploc := player[curteam,curplayer].p;
    qloc := player[curteam,curplayer].q;
    player[curteam,curplayer].SetStatus(InjuryStatus);
    if ploc = 0 then arrow := 2;
    if ploc = 14 then arrow := 7;
    if qloc = 0 then arrow := 4;
    if qloc = 25 then arrow := 5;
    ScatterBallFrom(ploc, qloc, 1, arrow);
  end else player[curteam,curplayer].SetStatus(InjuryStatus);
  InjuryStatus := 0;
end;

procedure TBloodbowl.OneD6ButtonClick(Sender: TObject);
var s: string;
    {i, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12: integer; }
begin
  if CanWriteToLog then begin
    {The commented out text is to allow testing of the different
       random number generating methods}
    {for i:= 1 to 100000 do begin}
      lastroll := Rnd(6,1) + 1;
      {if lastroll = 1 then r1 := r1 + 1;
      if lastroll = 2 then r2 := r2 + 1;
      if lastroll = 3 then r3 := r3 + 1;
      if lastroll = 4 then r4 := r4 + 1;
      if lastroll = 5 then r5 := r5 + 1;
      if lastroll = 6 then r6 := r6 + 1;
      if lastroll = 8 then r8 := r8 + 1;
      if lastroll = 9 then r9 := r9 + 1;
      if lastroll = 10 then r10 := r10 + 1;
      if lastroll = 11 then r11 := r11 + 1;
      if lastroll = 12 then r12 := r12 + 1;
      lastroll := 1;
    end;
    if Bloodbowl.SpeakLabel.caption[1] = 'H' then
      s := Chr(253) else s := Chr(254);
      if CanWriteToLog then begin
        LogWrite(s + ' ' + Chr(255));
        if Bloodbowl.SpeakLabel.caption[1] = 'H' then s := ffcl[0]
          else s := ffcl[1];
        AddLog(s + ': "' + InttoStr(r1) + ' ' + InttoStr(r2) + ' ' +
            InttoStr(r3) + ' ' + InttoStr(r4) + ' ' + InttoStr(r5) + ' ' +
            InttoStr(r6) + '"');
      end;    }
    s := '1' + Chr(lastroll + 48);
    LogWrite(s);
    PlayActionRoll1Die(s, 1);
  end;
  EnterButton.SetFocus;
  if curmove = 0 then begin
    if lastroll >= 3 then D3RollRed := D3RollRed + 1;
    D3RollTOTRed := D3RollTOTRed + 1;
  end else if curmove = 1 then begin
    if lastroll >= 3 then D3RollBlue := D3RollBlue + 1;
    D3RollTOTBlue := D3RollTOTBlue + 1;
  end;
end;

procedure TBloodbowl.TwoD6ButtonClick(Sender: TObject);
var r1, r2: integer;
    s: string;
begin
  if CanWriteToLog then begin
    r1 := Rnd(6,2) + 1;
    r2 := Rnd(6,1) + 1;
    lastroll := r1 + r2;
    s := '2' + Chr(r1 + 48) + Chr(r2 + 48);
    LogWrite(s);
    PlayActionRoll2Dice(s, 1);
  end;
  EnterButton.SetFocus;
end;

procedure TBloodbowl.D8ButtonClick(Sender: TObject);
begin
  if CanWriteToLog then begin
    lastroll := Rnd(8,6) + 1;
    AddLog('Scatter: ' + IntToStr(lastroll));
    LogWrite('8' + Chr(lastroll + 48));
    ScatterRollShow(lastroll);
  end;
  EnterButton.SetFocus;
end;

procedure TBloodbowl.OneDBButtonClick(Sender: TObject);
var r1: integer;
begin
  if CanWriteToLog then begin
    r1 := Rnd(6,3) + 1;
    lastroll := r1;
    AddLog('Block roll: ' + DBroll[r1]);
    BlockRollShow(r1, 0, 0);
    LogWrite('!' + Chr(r1 + 48));
  end;
  EnterButton.SetFocus;
end;

procedure TBloodbowl.TwoDBButtonClick(Sender: TObject);
var r1, r2: integer;
begin
  if CanWriteToLog then begin
    r1 := Rnd(6,4) + 1;
    r2 := Rnd(6,3) + 1;
    lastroll := r1;
    lastroll2 := r2;
    AddLog('Block roll: ' + DBroll[r1] + ' , ' + DBroll[r2]);
    BlockRollShow(r1, r2, 0);
    LogWrite('@' + Chr(r1 + 48) + Chr(r2 + 48));
  end;
  EnterButton.SetFocus;
end;

procedure TBloodbowl.ThreeDBButtonClick(Sender: TObject);
var r1, r2, r3: integer;
begin
  if CanWriteToLog then begin
    r1 := Rnd(6,5) + 1;
    r2 := Rnd(6,4) + 1;
    r3 := Rnd(6,3) + 1;
    lastroll := r1;
    lastroll2 := r2;
    lastroll3 := r3;
    AddLog('Block roll: ' + DBroll[r1] + ' , ' + DBroll[r2]
              + ' , ' + DBroll[r3]);
    BlockRollShow(r1, r2, r3);
    LogWrite('#' + Chr(r1 + 48) + Chr(r2 + 48) +  Chr(r3 + 48));
  end;
  EnterButton.SetFocus;
end;

procedure TBloodbowl.Exit2Click(Sender: TObject);
begin
  Bloodbowl.close;
  Exit;
end;

procedure TBloodbowl.SaveGame1Click(Sender: TObject);
var g, p, p2, p3: integer;
    notfound: boolean;
    s: string;
begin
  if SaveGameAllowed then begin
    notfound := true;
    for g := 1 to 500 do begin
      if (ComputerID[g]=CurrentComputer) or (CurrentComputer='') then begin
        notfound := false;
      end;
    end;
    if notfound then begin
      AddToGameLog(')=N0' + LoggedCoach + '@' + DateTimeToStr(Now) +
           '%' + LDFILEDT + '$' + PBeMVersion);
      s := '0' + LoggedCoach + '@' + DateTimeToStr(Now) +
           '%' + LDFILEDT + '$' + PBeMVersion;
      p := Pos('@', s);
      p2 := Pos('%', s);
      p3 := Pos('$', s);
      Bloodbowl.comment.text := '*** ALERT *** New Computer ID detected' + ' by ' +
        Copy(s, 2, p-2) + ' at ' + Copy(s, p+1, p2-p-1);
      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
    end;
    AddToGameLog('(I'+CurrentComputer);
    AddToGameLog('(lR|'+InttoStr(D3RollRed)+'~'+InttoStr(D3RollTOTRed)+'!'+
        InttoStr(KDownRed)+'='+InttoStr(KDownTOTRed)+'?'+InttoStr(AVBreakRed)+
        '<'+InttoStr(AVBreakTOTRed)+'>'+InttoStr(KOInjRed)+'*'+
        InttoStr(KOInjTOTRed)+'+');
    AddToGameLog('(lB|'+InttoStr(D3RollBlue)+'~'+InttoStr(D3RollTOTBlue)+'!'+
        InttoStr(KDownBlue)+'='+InttoStr(KDownTOTBlue)+'?'+InttoStr(AVBreakBlue)+
        '<'+InttoStr(AVBreakTOTBlue)+'>'+InttoStr(KOInjBlue)+'*'+
        InttoStr(KOInjTOTBlue)+'+');
    SaveDialog1.InitialDir := LoadSaveDir;
    SaveDialog1.Filename := '';
    SaveDialog1.Execute;
    if SaveDialog1.Filename <> '' then begin
      comment.text := 'S A V I N G . . .   One moment please...';
      comment.color := clYellow;
      comment.Refresh;
      SaveGame(SaveDialog1.Filename);
      comment.text := '';
      comment.color := clWhite;
    end;
    SaveGameAllowed := false;
    Bloodbowl.savegameSB.Visible := false;
    Bloodbowl.SaveGame1.Visible := false;
  end;
end;

procedure TBloodbowl.LoadGame1Click(Sender: TObject);
begin
  OpenDialog1.InitialDir := LoadSaveDir;
  OpenDialog1.Filename := '';
  OpenDialog1.Options := [ofFileMustExist];
  OpenDialog1.Execute;
  if OpenDialog1.Filename <> '' then begin
    comment.text := 'L O A D I N G . . .   One moment please...';
    comment.color := clYellow;
    comment.Refresh;
    FormReset(false, true);
    frmLog.FormCreate(Bloodbowl);
    LoadGame(OpenDialog1.FileName);
    comment.text := '';
    comment.color := clWhite;
    EndButtonClick(Sender);
    InEditMode := false;
    if RLCoach[0] = LoggedCoach then SetSpeakLabel(0) else
    if RLCoach[1] = LoggedCoach then SetSpeakLabel(1);
    SaveGameAllowed := false;
    Bloodbowl.savegameSB.Visible := false;
    Bloodbowl.SaveGame1.Visible := false;
  end;
end;

procedure TBloodbowl.Completion1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    player[curteam, curplayer].comp := player[curteam, curplayer].comp + 1;
    LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'c');
    AddLog('Completion for ' + player[curteam, curplayer].GetPlayerName);
  end;
end;

procedure TBloodbowl.Interception1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    player[curteam, curplayer].int := player[curteam, curplayer].int + 1;
    LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'I');
    AddLog('Interception for ' + player[curteam, curplayer].GetPlayerName);
  end;
end;

procedure TBloodbowl.Touchdown1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    player[curteam, curplayer].td := player[curteam, curplayer].td + 1;
    LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'T');
    AddLog('Touchdown for ' + player[curteam, curplayer].GetPlayerName);
    {Idleness}
    if (player[curteam,curplayer].HasSkill('Idleness')) then begin
      player[curteam,curplayer].UseSkill('Idleness');
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      if lastroll = 1 then begin
        AddLog('Idleness roll failure for ' +
          player[curteam, curplayer].GetPlayerName);
        player[curteam,curplayer].SetStatus(13);
      end else begin
        AddLog('Idleness roll success for ' +
          player[curteam, curplayer].GetPlayerName);
      end;
    end;
    {increase score marker}
    marker[curteam, MT_Score].MarkerMouseUp(
              marker[curteam, MT_Score], mbLeft, [], 0, 0);
    if (frmSettings.cbKicking.checked) and not(frmSettings.cbFG1PT.Checked)
      then begin
      marker[curteam, MT_Score].MarkerMouseUp(
          marker[curteam, MT_Score], mbLeft, [], 0, 0);
      marker[curteam, MT_Score].MarkerMouseUp(
          marker[curteam, MT_Score], mbLeft, [], 0, 0);
    end;
  end;
end;

procedure TBloodbowl.Casualty1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    player[curteam, curplayer].cas := player[curteam, curplayer].cas + 1;
    LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'C');
    AddLog('Casualty for ' + player[curteam, curplayer].GetPlayerName);
    {increase casscore marker}
    marker[curteam, MT_CasScore].MarkerMouseUp(
              marker[curteam, MT_CasScore], mbLeft, [], 0, 0);
  end;
end;

procedure TBloodbowl.OtherSPP1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    player[curteam, curplayer].otherSPP :=
                    player[curteam, curplayer].otherSPP + 1;
    LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'O');
    AddLog('1 other SPP for ' + player[curteam, curplayer].GetPlayerName);
  end;
end;

procedure TBloodbowl.EXP1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    player[curteam, curplayer].exp :=
                    player[curteam, curplayer].exp + 1;
    LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'E');
    AddLog('EXP point for ' + player[curteam, curplayer].GetPlayerName);
  end;
end;

procedure TBloodbowl.SBMVPClick(Sender: TObject);
var intAnswer: integer;
begin
  if CanWriteToLog then begin
    if (frmSettings.rgAging.ItemIndex <> 3) or (frmSettings.cbMVPEXP.checked)
      then begin
      intAnswer := Application.MessageBox(PChar('Are you sure you want to give ' +
            player[curteam, curplayer].GetPlayerName + ' a MVP Award?'),
            'Bloodbowl', mb_YesNo);
    end else begin
      intAnswer := Application.MessageBox(PChar('Are you sure you want to give ' +
            player[curteam, curplayer].GetPlayerName + ' an EXP Point?'),
            'Bloodbowl', mb_YesNo);
    end;
    if intAnswer = idYes then begin
      player[curteam, curplayer].mvp :=
                    player[curteam, curplayer].mvp + 1;
      LogWrite('p' + Chr(curteam + 48) + chr(curplayer + 65) + 'M');
      if (frmSettings.rgAging.ItemIndex <> 3) or (frmSettings.cbMVPEXP.checked)
        then
        AddLog('MVP Award for ' + player[curteam, curplayer].GetPlayerName) else
        AddLog('EXP Point for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure RandomPlayer(g: integer);
var r: integer;
    s: string;
begin
  r := Rnd(team[g].numplayers,6) + 1;
  while player[g,r].status = 11 do r := Rnd(team[g].numplayers,6) + 1;
  if CanWriteToLog then begin
    s := player[g,r].MakeCurrent;
    if s <> '' then LogWrite(s);
    s := 'Y' + Chr(g + 48) + Chr(r + 64);
    LogWrite(s);
    PlayActionRandomPlayer(s, 1);
  end;
end;

procedure TBloodbowl.Kickofftable1Click(Sender: TObject);
var r1, r2, r3, koteam0, koteam1, done, g, f, ballspotp, ballspotq,
    ploc, qloc, piplayers, pitchcount, TotalPlayers, TotalPlaying,
    WZone1, WZone2, LOS, TeamTest, i, u, v, t, turnno, extratitchy: integer;
    s, CurrentHalfNo: string;
    ballplaced, koreturn, DefenseOK, PlayerThere, ballhidden, Enddrive,
    ExtraPlayers: boolean;
begin
  Touchback := false;
  Enddrive := false;
  KickOffNow := true;
  KOCatcherPlayer := -1;
  KOCatcherTeam := -1;
  ExtraPlayers := false;
  if lbHalfID.caption = '1' then CurrentHalfNo := ' 1st half'
   else if lbHalfID.caption = '2' then CurrentHalfNo := ' 2nd half'
   else CurrentHalfNo := ' Overtime';
  if CanWriteToLog then begin
    ballplaced := false;
    ballhidden := true;
    koreturn := false;
    for g := 0 to 1 do begin
      for f := 1 to team[g].numplayers do begin
        if player[g,f].status = 2 then begin
          ballplaced := true;
          ballspotp := player[g,f].p;
          ballspotq := player[g,f].q;
          ballhidden := false;
        end;
      end;
    end;
    if (ball.p >= 0) then begin
      ballplaced := true;
      ballhidden := false;
      ballspotp := ball.p;
      ballspotq := ball.q;
    end;
    if (HideBallp <> -1) and (ballhidden) then begin
      PlayerThere := false;
      ballplaced := true;
      ballspotp := HideBallp;
      ballspotq := HideBallq;
    end;
    {begin test to see if there are 3 players on the LOS and no more than
      2 in a wide zone on both sides}
    DefenseOK := True;
    if ballplaced then begin
      if ballspotq <= 12 then TeamTest := 1 else TeamTest := 0;
      LOS := 0;
      WZone1 := 0;
      WZone2 := 0;
      TotalPlayers := 0;
      extratitchy := 0;
      for i := 1 to team[TeamTest].numplayers do begin
        if (frmSettings.rgTitchy.ItemIndex=1) and
          (player[TeamTest,i].HasSkill('Titchy')) then extratitchy := 1;
        if (player[TeamTest,i].q = 12) and (TeamTest = 0) and
          (player[TeamTest,i].p > 3) and (player[TeamTest,i].p < 11) then
          LOS := LOS + 1;
        if (player[TeamTest,i].q = 13) and (TeamTest = 1) and
          (player[TeamTest,i].p > 3) and (player[TeamTest,i].p < 11) then
          LOS := LOS + 1;
        if (player[TeamTest,i].p <= 3) and (Player[TeamTest,i].status >= 1) and
           (Player[TeamTest,i].status <= 2) then WZone1 := WZone1 + 1;
        if (player[TeamTest,i].p >= 11) then WZone2 := WZone2 + 1;
        if (Player[TeamTest,i].status <= 4) then TotalPlayers := TotalPlayers + 1;
        if (Player[TeamTest,i].status >= 1) and (Player[TeamTest,i].status <= 4)
          then TotalPlaying := TotalPlaying + 1;
      end;
      If (TotalPlayers >= 3) and (LOS < 3) and (frmSettings.cbLOS.checked)
        then DefenseOK := False;
      If (TotalPlayers < 3) and (LOS <> TotalPlayers) and (frmSettings.cbLOS.checked)
        then DefenseOK := False;
      if (TotalPlayers >= 11) and (TotalPlaying < 11)
        and (frmSettings.cbRuleof11.checked) then DefenseOK := False;
      if (TotalPlayers < 11) and (TotalPlaying <> TotalPlayers)
        and (frmSettings.cbRuleof11.checked) then DefenseOK := False;
      If (WZone1 > 2) and (frmSettings.cbWideZone.checked) then DefenseOK := False;
      If (WZone2 > 2) and (frmSettings.cbWideZone.checked) then DefenseOK := False;
      if (TotalPlaying>11) and (extratitchy=0) then ExtraPlayers := true;
      TeamTest := 1 - TeamTest;
      LOS := 0;
      WZone1 := 0;
      WZone2 := 0;
      TotalPlayers := 0;
      TotalPlaying := 0;
      extratitchy := 0;
      for i := 1 to team[TeamTest].numplayers do begin
        if (frmSettings.rgTitchy.ItemIndex=1) and
          (player[TeamTest,i].HasSkill('Titchy')) then extratitchy := 1;
        if (player[TeamTest,i].q = 12) and (TeamTest = 0) and
          (player[TeamTest,i].p > 3) and (player[TeamTest,i].p < 11) then
          LOS := LOS + 1;
        if (player[TeamTest,i].q = 13) and (TeamTest = 1) and
          (player[TeamTest,i].p > 3) and (player[TeamTest,i].p < 11) then
          LOS := LOS + 1;
        if (player[TeamTest,i].p <= 3) and (Player[TeamTest,i].status >= 1) and
           (Player[TeamTest,i].status <= 2) then WZone1 := WZone1 + 1;
        if (player[TeamTest,i].p >= 11) then WZone2 := WZone2 + 1;
        if (Player[TeamTest,i].status <= 4) then TotalPlayers := TotalPlayers + 1;
        if (Player[TeamTest,i].status >= 1) and (Player[TeamTest,i].status <= 4)
          then TotalPlaying := TotalPlaying + 1;
      end;
      If (TotalPlayers >= 3) and (LOS < 3) and (frmSettings.cbLOS.checked)
        then DefenseOK := False;
      If (TotalPlayers < 3) and (LOS <> TotalPlayers) and (frmSettings.cbLOS.checked)
        then DefenseOK := False;
      if (TotalPlayers >= 11) and (TotalPlaying < 11)
        and (frmSettings.cbRuleof11.checked) then DefenseOK := False;
      if (TotalPlayers < 11) and (TotalPlaying <> TotalPlayers)
        and (frmSettings.cbRuleof11.checked) then DefenseOK := False;
      If (WZone1 > 2) and (frmSettings.cbWideZone.checked) then DefenseOK := False;
      If (WZone2 > 2) and (frmSettings.cbWideZone.checked) then DefenseOK := False;
      if (TotalPlaying>11) and (extratitchy=0) then ExtraPlayers := true;
    end;
    if (ExtraPlayers) then begin
      Application.Messagebox('One team has set up more than 12 players! '
        ,'Bloodbowl Possible Illegal Formation Warning', MB_OK);
    end;
    if (ballplaced) and (DefenseOK) then begin
      if (HideBallp <> -1) and (Ballhidden) then begin
        PlayerThere := false;
        ballplaced := true;
        ballspotp := HideBallp;
        ballspotq := HideBallq;
        for u := 0 to 1 do begin
          for v := 1 to team[u].numplayers do begin
            if (player[u,v].p = HideBallp) and (player[u,v].q = HideBallq)
            then begin
              PlayerThere := true;
              {player[u,v].SetStatus(2);}
            end;
          end;
        end;
        if not(PlayerThere) then PlaceBall(HideBallp, HideBallq);
      end;
      r1 := Rnd(6,2) + 1;
      r2 := Rnd(6,1) + 1;
      r3 := (r1 * 10) + r2;
      if ballspotq >= 13 then g := 1 else g := 0;
      KickOffTeam := g;
      for f := 1 to team[g].numplayers do begin
        if (player[g,f].hasSkill('Kickoff Return')) and ((player[g,f].status = 1)
          or (player[g,f].status = 2)) and ((player[g,f].q > 13) or
          (player[g,f].q < 12)) then KOReturn := true;
        if (player[g,f].hasSkill('Kick-Off Return')) and ((player[g,f].status = 1)
          or (player[g,f].status = 2)) and ((player[g,f].q > 13) or
          (player[g,f].q < 12)) then KOReturn := true;
      end;
      AddLog('(' + IntToStr(r1) + ',' + IntToStr(r2) + ') : '
        + KickoffTable[r3]);
      LogWrite('DK' + Chr(r1 + 48) + Chr(r2 + 48));
      LogWrite('h' + Chr(HideBallp+65) + Chr(HideBallq+65) + 'E');
      if Copy((KickoffTable[r3]),1,4) = 'RIOT' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
          s := Chr(255) + 'Riot lasts '+InttoStr(lastroll) + ' turns! ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          if ExecuteRiot(lastroll) then begin
            s := Chr(255) + 'Riot ends the half!';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
          end else begin
            if KOCatcherPlayer <> -1 then begin
              ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
              KOCatcherTeam := -1;
              KOCatcherPlayer := -1;
            end else begin
              if KOReturn then begin
                s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                  'and then manually scatter the ball or catch it as applies ';
                PlayActionComment(s, 1, 2);
                LogWrite(s);
              end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
            end;
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,11) = 'INJURY TIME' then begin
        turnno := 0;
        for t := 1 to 8 do begin
          if turn[KickoffTeam,t].Font.Size = 8 then turnno := t;
        end;
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          if turnno <= 4 then lastroll := 1 else lastroll := -1;
          if lastroll=1 then
            s := Chr(255) + 'Injury Time moves the game one turn forward! ' else
            s := Chr(255) + 'Injury Time moves the game one turn back! ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          Enddrive := ExecuteRiot(lastroll);
          if KOCatcherPlayer <> -1 then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
            if KOReturn then begin
              s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                'and then manually scatter the ball or catch it as applies ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
            end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,11) = 'GET THE REF' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          s := Chr(255) + 'Get the Ref roll for '+ffcl[0]+' ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
          koteam0 := lastroll + team[0].ff;
          s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[0].ff) + ' Fan Factor = ' + InttoStr(koteam0)+ ' ';;
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          s := Chr(255) + 'Get the Ref roll for '+ffcl[1] + ' ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
          koteam1 := lastroll + team[1].ff;
          s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[1].ff) + ' Fan Factor = ' + InttoStr(koteam1)+ ' ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          if koteam0 > koteam1 then begin
            s := Chr(255) + ffcl[0] + ' win the roll! ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := Chr(252) + ffcl[0] + ' Gets the Ref for the' + CurrentHalfNo + '!';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            if (GettheRef=3) or (GettheRef=0) then
              s := 'JR' + Chr(0 + 48)
            else s := 'JR' + Chr(2 + 48);
            LogWrite(s);
            PlayActionCoachRef(s, 1);
          end else if koteam1 > koteam0 then begin
            s := Chr(255) + ffcl[1] + ' win the roll! ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := Chr(252) + ffcl[1] + ' Gets the Ref for the' + CurrentHalfNo + '!';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            if (GettheRef=3) or (GettheRef=1) then
              s := 'JR' + Chr(1 + 48)
            else s := 'JR' + Chr(2 + 48);
            LogWrite(s);
            PlayActionCoachRef(s, 1);
          end else begin
            s := Chr(255) + 'Tie roll, both teams effected! ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := Chr(252) + 'Both Teams Get the Ref for the' + CurrentHalfNo + '!';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := 'JR' + Chr(2 + 48);
            LogWrite(s);
            PlayActionCoachRef(s, 1);
          end;
          if (KOCatcherPlayer <> -1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status >= 1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status <= 2) then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,15) = 'PERFECT DEFENCE' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'before applying Perfect Defense and then manually scatter ' +
                 'the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,13) = 'CHEERING FANS' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          done := 0;
          while done = 0 do begin
            s := Chr(255) + 'Cheering Fans Roll for '+ffcl[0]+' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            koteam0 := lastroll + team[0].cheerleaders + team[0].ff;
            s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[0].cheerleaders) + ' cheerleaders + ' +
              InttoStr(team[0].ff) + ' Fan Factor = ' + InttoStr(koteam0)+ ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := Chr(255) + 'Cheering Fans Roll for '+ffcl[1] + ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            koteam1 := lastroll + team[1].cheerleaders + team[1].ff;
            s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[1].cheerleaders) + ' cheerleaders + ' +
              InttoStr(team[1].ff) + ' Fan Factor = ' + InttoStr(koteam1)+ ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            if koteam0 > koteam1 then begin
              s := Chr(255) + ffcl[0] + ' win the roll! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              marker[0, MT_Reroll].MarkerMouseUp(marker[0, MT_Reroll],
                                                  mbLeft, [], 0, 0);
              done := 1;
            end else if koteam1 > koteam0 then begin
              s := Chr(255) + ffcl[1] + ' win the roll! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              marker[1, MT_Reroll].MarkerMouseUp(marker[1, MT_Reroll],
                                                  mbLeft, [], 0, 0);
              done := 1;
            end else begin
              s := Chr(255) + 'Tie roll, rolling again! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
            end;
          end;
          if KOCatcherPlayer <> -1 then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,8) = 'BAD KICK' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, true);
          if KOCatcherPlayer <> -1 then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,14) = 'WEATHER CHANGE' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          WeatherTableClick;
          if KOCatcherPlayer <> -1 then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,10) = 'QUICK SNAP' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'before applying Quick Snap and then manually scatter ' +
                 'the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,18) = 'BRILLIANT COACHING' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          done := 0;
          while done = 0 do begin
            s := Chr(255) + 'Brilliant Coaching Roll for '+ffcl[0]+' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            koteam0 := lastroll + team[0].asstcoaches;
            s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[0].asstcoaches) + ' assistant coaches = ' +
              InttoStr(koteam0)+ ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := Chr(255) + 'Brilliant Coaching Roll for '+ffcl[1] + ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            koteam1 := lastroll + team[1].asstcoaches;
            s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[1].asstcoaches) + ' assistant coaches = ' +
              InttoStr(koteam1)+ ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            if koteam0 > koteam1 then begin
              s := Chr(255) + ffcl[0] + ' win the roll! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              marker[0, MT_Reroll].MarkerMouseUp(marker[0, MT_Reroll],
                                                  mbLeft, [], 0, 0);
              done := 1;
            end else if koteam1 > koteam0 then begin
              s := Chr(255) + ffcl[1] + ' win the roll! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              marker[1, MT_Reroll].MarkerMouseUp(marker[1, MT_Reroll],
                                                  mbLeft, [], 0, 0);
              done := 1;
            end else begin
              s := Chr(255) + 'Tie roll, rolling again! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
            end;
          end;
          if KOCatcherPlayer <> -1 then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1, 5) = 'BLITZ' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'before applying Blitz and then manually scatter ' +
                 'the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,12) = 'THROW A ROCK' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          s := Chr(255) + 'Throw a Rock Roll for '+ffcl[0]+' ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
          koteam0 := lastroll + team[0].ff;
          s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[0].ff) + ' Fan Factor = ' + InttoStr(koteam0)+ ' ';;
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          s := Chr(255) + 'Throw a Rock Roll for '+ffcl[1] + ' ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
          koteam1 := lastroll + team[1].ff;
          s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
              InttoStr(team[1].ff) + ' Fan Factor = ' + InttoStr(koteam1)+ ' ';
          PlayActionComment(s, 1, 2);
          LogWrite(s);
          if koteam0 > koteam1 then begin
            s := Chr(255) + ffcl[0] + ' win the roll! ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            done := 0;
            pitchcount := 0;
            for f := 1 to team[1].numplayers do begin
             if (player[1,f].status = 2) or (player[1,f].status =1) then begin
               pitchcount := pitchcount + 1;
             end;
            end;
            if pitchcount > 0 then begin
              while done = 0 do begin
                RandomPlayer(1);
                if (player[curteam,curplayer].status = 1) or
                   (player[curteam,curplayer].status = 2) then done := 1;
              end;
            end;
            InjurySettings(curteam, curplayer);
            if player[curteam,curplayer].status=2 then begin
              ploc := player[curteam,curplayer].p;
              qloc := player[curteam,curplayer].q;
              player[curteam,curplayer].SetStatus(InjuryStatus);
              ScatterBallFrom(ploc, qloc, 1, 0);
            end else player[curteam,curplayer].SetStatus(InjuryStatus);
            InjuryStatus := 0;
          end else if koteam1 > koteam0 then begin
            s := Chr(255) + ffcl[1] + ' win the roll! ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            done := 0;
            pitchcount := 0;
            for f := 1 to team[0].numplayers do begin
             if (player[0,f].status = 2) or (player[0,f].status =1) then begin
               pitchcount := pitchcount + 1;
             end;
            end;
            if pitchcount > 0 then begin
              while done = 0 do begin
                RandomPlayer(0);
                if (player[curteam,curplayer].status = 1) or
                   (player[curteam,curplayer].status = 2) then done := 1;
              end;
            end;
            InjurySettings(curteam, curplayer);
            if player[curteam,curplayer].status=2 then begin
              ploc := player[curteam,curplayer].p;
              qloc := player[curteam,curplayer].q;
              player[curteam,curplayer].SetStatus(InjuryStatus);
              ScatterBallFrom(ploc, qloc, 1, 0);
            end else player[curteam,curplayer].SetStatus(InjuryStatus);
            InjuryStatus := 0;
          end else begin
            s := Chr(255) + 'Tie roll, both teams effected! ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            done := 0;
            pitchcount := 0;
            for f := 1 to team[0].numplayers do begin
             if (player[0,f].status = 2) or (player[0,f].status =1) then begin
               pitchcount := pitchcount + 1;
             end;
            end;
            if pitchcount > 0 then begin
              while done = 0 do begin
                RandomPlayer(0);
                if (player[curteam,curplayer].status = 1) or
                   (player[curteam,curplayer].status = 2) then done := 1;
              end;
            end;
            InjurySettings(curteam, curplayer);
            if player[curteam,curplayer].status=2 then begin
              ploc := player[curteam,curplayer].p;
              qloc := player[curteam,curplayer].q;
              player[curteam,curplayer].SetStatus(InjuryStatus);
              ScatterBallFrom(ploc, qloc, 1, 0);
            end else player[curteam,curplayer].SetStatus(InjuryStatus);
            InjuryStatus := 0;
            done := 0;
            pitchcount := 0;
            for f := 1 to team[1].numplayers do begin
             if (player[1,f].status = 2) or (player[1,f].status =1) then begin
               pitchcount := pitchcount + 1;
             end;
            end;
            if pitchcount > 0 then begin
              while done = 0 do begin
                RandomPlayer(1);
                if (player[curteam,curplayer].status = 1) or
                   (player[curteam,curplayer].status = 2) then done := 1;
              end;
            end;
            InjurySettings(curteam, curplayer);
            if player[curteam,curplayer].status=2 then begin
              ploc := player[curteam,curplayer].p;
              qloc := player[curteam,curplayer].q;
              player[curteam,curplayer].SetStatus(InjuryStatus);
              ScatterBallFrom(ploc, qloc, 1, 0);
            end else player[curteam,curplayer].SetStatus(InjuryStatus);
            InjuryStatus := 0;
          end;
          if (KOCatcherPlayer <> -1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status >= 1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status <= 2) then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else if (KOCatcherPlayer <> -1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status > 2) then begin
            ScatterBallFrom(ball.p,ball.q,1,0);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else if Copy((KickoffTable[r3]),1,14) = 'PITCH INVASION' then begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          if not(frmSettings.cbLRB4KO.checked) then begin
            s := Chr(255) + 'Pitch Invasion Roll for '+ffcl[0]+' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
            koteam0 := lastroll + team[0].ff;
            s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
                InttoStr(team[0].ff) + ' Fan Factor = ' + InttoStr(koteam0)+ ' ';;
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            s := Chr(255) + 'Pitch Invasion Roll for '+ffcl[1] + ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
            koteam1 := lastroll + team[1].ff;
            s := Chr(255) + 'Roll: ' + InttoStr(lastroll) + ' + ' +
                InttoStr(team[1].ff) + ' Fan Factor = ' + InttoStr(koteam1)+ ' ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            if koteam0 > koteam1 then begin
              s := Chr(255) + ffcl[0] + ' win the roll! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              piplayers := lastroll;
              s := Chr(255) + InttoStr(piplayers) + ' affected by Pitch Invasion!';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              pitchcount := 0;
              for f := 1 to team[1].numplayers do begin
               if (player[1,f].status = 2) or (player[1,f].status =1) then begin
                 pitchcount := pitchcount + 1;
               end;
              end;
              if pitchcount < piplayers then piplayers := pitchcount;
              if piplayers > 0 then begin
                for f := 1 to piplayers do begin
                  done := 0;
                  while done = 0 do begin
                    RandomPlayer(1);
                    if (player[curteam,curplayer].status = 1) or
                       (player[curteam,curplayer].status = 2) then done := 1;
                  end;
                  InjurySettings(curteam, curplayer);
                  if player[curteam,curplayer].status=2 then begin
                    ploc := player[curteam,curplayer].p;
                    qloc := player[curteam,curplayer].q;
                    player[curteam,curplayer].SetStatus(InjuryStatus);
                    ScatterBallFrom(ploc, qloc, 1, 0);
                  end else player[curteam,curplayer].SetStatus(InjuryStatus);
                  InjuryStatus := 0;
                end;
              end;
            end else if koteam1 > koteam0 then begin
              s := Chr(255) + ffcl[1] + ' win the roll! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              piplayers := lastroll;
              s := Chr(255) + InttoStr(piplayers) + ' affected by Pitch Invasion!';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              pitchcount := 0;
              for f := 1 to team[0].numplayers do begin
               if (player[0,f].status = 2) or (player[0,f].status =1) then begin
                 pitchcount := pitchcount + 1;
               end;
              end;
              if pitchcount < piplayers then piplayers := pitchcount;
              if piplayers > 0 then begin
                for f := 1 to piplayers do begin
                  done := 0;
                  while done = 0 do begin
                    RandomPlayer(0);
                    if (player[curteam,curplayer].status = 1) or
                       (player[curteam,curplayer].status = 2) then done := 1;
                  end;
                  InjurySettings(curteam, curplayer);
                  if player[curteam,curplayer].status=2 then begin
                    ploc := player[curteam,curplayer].p;
                    qloc := player[curteam,curplayer].q;
                    player[curteam,curplayer].SetStatus(InjuryStatus);
                    ScatterBallFrom(ploc, qloc, 1, 0);
                  end else player[curteam,curplayer].SetStatus(InjuryStatus);
                  InjuryStatus := 0;
                end;
              end;
            end else begin
              s := Chr(255) + 'Tie roll, both teams effected! ';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              piplayers := lastroll;
              s := Chr(255) + InttoStr(piplayers) + ' affected by Pitch Invasion!';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              pitchcount := 0;
              for f := 1 to team[0].numplayers do begin
               if (player[0,f].status = 2) or (player[0,f].status =1) then begin
                 pitchcount := pitchcount + 1;
               end;
              end;
              if pitchcount < piplayers then piplayers := pitchcount;
              if piplayers > 0 then begin
                for f := 1 to piplayers do begin
                  done := 0;
                  while done = 0 do begin
                    RandomPlayer(0);
                    if (player[curteam,curplayer].status = 1) or
                       (player[curteam,curplayer].status = 2) then done := 1;
                  end;
                  InjurySettings(curteam, curplayer);
                  if player[curteam,curplayer].status=2 then begin
                    ploc := player[curteam,curplayer].p;
                    qloc := player[curteam,curplayer].q;
                    player[curteam,curplayer].SetStatus(InjuryStatus);
                    ScatterBallFrom(ploc, qloc, 1, 0);
                  end else player[curteam,curplayer].SetStatus(InjuryStatus);
                  InjuryStatus := 0;
                end;
              end;
              Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
              piplayers := lastroll;
              s := Chr(255) + InttoStr(piplayers) + ' affected by Pitch Invasion!';
              PlayActionComment(s, 1, 2);
              LogWrite(s);
              pitchcount := 0;
              for f := 1 to team[1].numplayers do begin
               if (player[1,f].status = 2) or (player[1,f].status =1) then begin
                 pitchcount := pitchcount + 1;
               end;
              end;
              if pitchcount < piplayers then piplayers := pitchcount;
              if piplayers > 0 then begin
                for f := 1 to piplayers do begin
                  done := 0;
                  while done = 0 do begin
                    RandomPlayer(1);
                    if (player[curteam,curplayer].status = 1) or
                       (player[curteam,curplayer].status = 2) then done := 1;
                  end;
                  InjurySettings(curteam, curplayer);
                  if player[curteam,curplayer].status=2 then begin
                    ploc := player[curteam,curplayer].p;
                    qloc := player[curteam,curplayer].q;
                    player[curteam,curplayer].SetStatus(InjuryStatus);
                    ScatterBallFrom(ploc, qloc, 1, 0);
                  end else player[curteam,curplayer].SetStatus(InjuryStatus);
                  InjuryStatus := 0;
                end;
              end;
            end;
          end else begin
            if team[0].ff < team[1].ff then
              s := Chr(255) + 'Pitch Invasion Rolls for '+ffcl[0]+' with +1 modifiers '
              else
                s := Chr(255) + 'Pitch Invasion Rolls for '+ffcl[0]+' with no modifiers ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            for f := 1 to team[0].numplayers do begin
              if (player[0,f].status >= 1) and (player[0,f].status <= 4) then begin
                Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                if team[0].ff < team[1].ff then lastroll := lastroll + 1;
                if lastroll >= 6 then begin
                  if player[0,f].status=2 then begin
                    ploc := player[0,f].p;
                    qloc := player[0,f].q;
                    player[0,f].SetStatus(4);
                    ScatterBallFrom(ploc, qloc, 1, 0);
                  end else player[0,f].SetStatus(4);
                  InjuryStatus := 0;
                end;
              end;
            end;
            if team[1].ff < team[0].ff then
              s := Chr(255) + 'Pitch Invasion Rolls for '+ffcl[1]+' with +1 modifiers '
              else
                s := Chr(255) + 'Pitch Invasion Rolls for '+ffcl[1]+' with no modifiers ';
            PlayActionComment(s, 1, 2);
            LogWrite(s);
            for f := 1 to team[1].numplayers do begin
              if (player[1,f].status >= 1) and (player[1,f].status <= 4) then begin
                Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                if team[1].ff < team[0].ff then lastroll := lastroll + 1;
                if lastroll >= 6 then begin
                  if player[1,f].status=2 then begin
                    ploc := player[1,f].p;
                    qloc := player[1,f].q;
                    player[1,f].SetStatus(4);
                    ScatterBallFrom(ploc, qloc, 1, 0);
                  end else player[1,f].SetStatus(4);
                  InjuryStatus := 0;
                end;
              end;
            end;
          end;
          if (KOCatcherPlayer <> -1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status >= 1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status <= 2) then begin
            ShowCatchWindow(KOCatcherTeam, KOCatcherPlayer, 0, false, false);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else if (KOCatcherPlayer <> -1) and
            (player[KOCatcherTeam, KOCatcherPlayer].status > 2) then begin
            ScatterBallFrom(ball.p,ball.q,1,0);
            KOCatcherTeam := -1;
            KOCatcherPlayer := -1;
          end else begin
             if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'and then manually scatter the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
             end else if not(Touchback) then ScatterBallFrom(ball.p, ball.q, 1, 0);
          end;
        end;
      end else begin
        if CanWriteToLog then begin
          ScatterD8D6(ballspotp, ballspotq, true, false);
          if KOReturn then begin
               s := Chr(255) + 'Player has Kick-Off Return.  Apply this skill ' +
                 'before applying Blitz and then manually scatter ' +
                 'the ball or catch it as applies ';
               PlayActionComment(s, 1, 2);
               LogWrite(s);
          end;
        end;
      end;
    end else if not(ballplaced) then begin
      Application.Messagebox('The ball must be placed before you can kickoff',
         'Bloodbowl Kickoff Error', MB_OK);
    end else begin
       Application.Messagebox('Illegal formation found!  Ball cannot ' +
       'be kicked off!','Bloodbowl Illegal Offense/Defense Warning', MB_OK)
    end;
  end;
  Touchback := false;
  KickoffTeam := -1;
  KickoffNow := false;
end;

procedure TBloodbowl.Weathertable1Click(Sender: TObject);
begin
  WeatherTableClick;
end;

procedure TBloodbowl.ViewRedPB1Click(Sender: TObject);
begin
  ShowTeam(0);
end;

procedure TBloodbowl.ViewBluePB1Click(Sender: TObject);
begin
  ShowTeam(1);
end;

procedure TBloodbowl.About1Click(Sender: TObject);
begin
  frmAbout.Show;
end;

procedure TBloodbowl.ViewLog1Click(Sender: TObject);
begin
  ViewLog1.Checked := not(ViewLog1.Checked);
  if ViewLog1.Checked then begin
    frmLog.Show;
    Bloodbowl.BringToFront;
  end else frmLog.Hide;
end;

procedure TBloodbowl.NewGame1Click(Sender: TObject);
begin
  FormReset(false, true);
  frmLog.FormCreate(Bloodbowl);
end;

procedure TBloodbowl.armourrollSBClick(Sender: TObject);
begin
  FollowUp := '';
  ShowHurtForm('A');
end;

procedure TBloodbowl.injuryrollSBClick(Sender: TObject);
begin
  ShowHurtForm('I');
end;

procedure TBloodbowl.foulrollSBClick(Sender: TObject);
begin
  ShowHurtForm('F');
end;

procedure TBloodbowl.AddCards1Click(Sender: TObject);
begin
  DrawNewCards := false;
  frmCards.Show;
end;

procedure TBloodbowl.cardsDecodeClick(Sender: TObject);
begin
  if (Sender as TLabel) = lblCardsBox[0] then ShowCards(0) else ShowCards(1);
end;

procedure TBloodbowl.cardPlayClick(Sender: TObject);
var l: TCardLabel;
    f, g: integer;
begin
  l := (Sender as TCardLabel);
  if (l.caption <> '') and (Pos('???', l.caption) = 0) then begin
    if (l.font.color <> clSilver) then begin
      l.color := clSilver;
      if MessageDlg(cardset[l.cset, l.cnum] + Chr(13) + Chr(13) +
            cardhint[l.cset, l.cnum] + Chr(13) + Chr(13) + Chr(13) +
            'Do you want to play this card ?',
            mtConfirmation, mbOkCancel, 0) = mrOk then begin
        if CanWriteToLog then begin
          for g := 0 to 1 do
           for f := 1 to 25 do begin
            if CardsData[g,f].color = clSilver then begin
              LogWrite('c' + Chr(g+48) + Chr(f+64) + Chr(CardsData[g,f].cset + 64)
                       + Chr(CardsData[g,f].cnum + 64));
              RemoveCard(g, f);
              ShowCards(2);
              AddLog(ffcl[g] + ' plays card "' + Trim(l.caption) + '"');
            end;
           end;
        end;
      end;
      l.color := clGray;
    end else begin
      ShowMessage(cardset[l.cset, l.cnum] + Chr(13) + Chr(13) +
                  cardhint[l.cset, l.cnum]);
    end;
  end;
end;

procedure TBloodbowl.RandomRedSBClick(Sender: TObject);
begin
  RandomPlayer(0);
end;

procedure TBloodbowl.RandomBlueSBClick(Sender: TObject);
begin
  RandomPlayer(1);
end;

procedure TBloodbowl.SpeakLabelClick(Sender: TObject);
begin
  if SpeakLabel.caption[1] = 'H' then SetSpeakLabel(1) else SetSpeakLabel(0);
end;

procedure TBloodbowl.StartHalfSBClick(Sender: TObject);
begin
  if CanWriteToLog then begin
    PrepareStartHalf;
  end;  
end;

procedure ShowPassBlockRanges(p, q: integer);
var f, g, r, t, m: integer;
begin
  if PassBlockRangeShowing then begin
    PassBlockRangeShowing := false;
    for f := 0 to 14 do
      for g := 0 to 25 do field[f,g].color := clGreen;
    if frmSettings.txtFieldImageFile.text <> '' then
      for f := 0 to 14 do
        for g := 0 to 25 do field[f,g].transparent := true;
  end else begin
    PassBlockRangeShowing := true;
    t := abs(1-curteam);
    if (t=1) or (t=0) then begin
      for m := 1 to team[t].numplayers do begin
        if player[t,m].hasSkill('Pass Block') then begin
          for f := 0 to 14 do
            for g := 0 to 25 do begin
              if (abs(f - (player[t,m].p)) <= 3) and
              (abs(g - (player[t,m].q)) <= 3) then begin
                field[f,g].color := clYellow;
                field[f,g].transparent := false;
              end;
            end;
        end;
      end;
    end;
  end;
end;

procedure ShowPassRanges(p, q: integer);
var f, g, r, squaredist: integer;
begin
  if PassRangeShowing then begin
    PassRangeShowing := false;
    for f := 0 to 14 do
      for g := 0 to 25 do field[f,g].color := clGreen;
    if frmSettings.txtFieldImageFile.text <> '' then
      for f := 0 to 14 do
        for g := 0 to 25 do field[f,g].transparent := true;
  end else begin
    PassRangeShowing := true;
    for f := 0 to 14 do
      for g := 0 to 25 do begin
        r := (p - f) * (p - f) + (q - g) * (q - g);
        if frmSettings.cbSquarePass.checked then begin
          if (p<>f) or (q<>g) then begin
            squaredist := RangeRulerRange(p,q,f,g);
            if frmSettings.cbPassingRangesColored.checked then begin
              field[f,g].color := clSilver;
              if squaredist = 1 then field[f,g].color := clPurple;
              if squaredist = 2 then field[f,g].color := clYellow;
              if squaredist = 3 then field[f,g].color := clBlack;
              if squaredist <= 3 then field[f,g].transparent := false;
            end else begin
              field[f,g].color := clGreen;
              if squaredist = 1 then field[f,g].color := $006800;
              if squaredist = 2 then field[f,g].color := $005000;
              if squaredist = 3 then field[f,g].color := $003800;
              if squaredist <= 3 then field[f,g].transparent := false;
            end;
          end;
        end else begin
          if frmSettings.cbPassingRangesColored.checked then begin
            field[f,g].color := clSilver;
            if (r >= 16) and (r <= 56) then field[f,g].color := clPurple;
            if (r > 56) and (r < 121) then field[f,g].color := clYellow;
            if (r >= 121) and (r <= 182) then field[f,g].color := clBlack;
            if r <= 182 then field[f,g].transparent := false;
          end else begin
            field[f,g].color := clGreen;
            if (r >= 16) and (r <= 56) then field[f,g].color := $006800;
            if (r > 56) and (r < 121) then field[f,g].color := $005000;
            if (r >= 121) and (r <= 182) then field[f,g].color := $003800;
            if r <= 182 then field[f,g].transparent := false;
          end;
        end;
      end;
  end;
end;

procedure TBloodbowl.PlayerShowPassingRanges1Click(Sender: TObject);
begin
  ShowPassRanges(player[curteam, curplayer].p, player[curteam, curplayer].q);
end;

procedure TBloodbowl.PlayerShowPassBlockRanges1Click(Sender: TObject);
begin
  ShowPassBlockRanges(player[curteam, curplayer].p, player[curteam, curplayer].q);
end;

procedure TBloodbowl.FieldShowPassingRanges1Click(Sender: TObject);
var p, q: integer;
begin
  for p := 0 to 14 do
   for q := 0 to 25 do if fieldPopup.PopupComponent = field[p,q] then begin
     ShowPassRanges(p, q);
   end;
end;

procedure TBloodbowl.FieldShowPassBlockRanges1Click(Sender: TObject);
var p, q: integer;
begin
  for p := 0 to 14 do
   for q := 0 to 25 do if fieldPopup.PopupComponent = field[p,q] then begin
     ShowPassBlockRanges(p, q);
   end;
end;

procedure TBloodbowl.DecodecardsforRed1Click(Sender: TObject);
begin
  ShowCards(0);
end;

procedure TBloodbowl.DecodecardsforBlue1Click(Sender: TObject);
begin
  ShowCards(1);
end;

procedure TBloodbowl.PrepareforKickoff1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    PrepareForKickoff;
  end;
end;

procedure TBloodbowl.StartButtonClick(Sender: TObject);
begin
  frmLogControl.StartButtonClick(frmLogControl.StartButton);
end;

procedure TBloodbowl.PlayButtonClick(Sender: TObject);
begin
  frmLogControl.PlayButtonClick(frmLogControl.PlayButton);
end;

procedure TBloodbowl.PlayoneButtonClick(Sender: TObject);
begin
  frmLogControl.PlayoneButtonClick(frmLogControl.PlayoneButton);
end;

procedure TBloodbowl.PlaybackmoveButtonClick(Sender: TObject);
begin
  frmLogControl.PlaybackmoveButtonClick(frmLogControl.PlaybackmoveButton);
end;

procedure TBloodbowl.StartturnButtonClick(Sender: TObject);
begin
  frmLogControl.StartturnButtonClick(frmLogControl.StartturnButton);
end;

procedure TBloodbowl.EndturnButtonClick(Sender: TObject);
begin
  frmLogControl.EndturnButtonClick(frmLogControl.EndturnButton);
end;

procedure TBloodbowl.EndButtonClick(Sender: TObject);
begin
  if MakeCheckFile then begin
    CheckFileOpen := true;
    AssignFile(CheckFile,LoadSaveDir + 'bblog.chk');
    Rewrite(CheckFile);
  end;
  if MakeExportLog then begin
    ExportFileOpen := true;
    AssignFile(ExportLog,LoadSaveDir + 'pbemstat.log');
    Rewrite(ExportLog);
  end;
  frmLogControl.EndButtonClick(frmLogControl.EndButton);
  if MakeCheckFile then begin
    CloseFile(CheckFile);
    CheckFileOpen := false;
    MakeCheckFile := false;
  end;
  if MakeExportLog then begin
    CloseFile(ExportLog);
    ExportFileOpen := false;
    MakeExportLog := false;
  end;
end;

procedure TBloodbowl.MakeDodgeroll1Click(Sender: TObject);
begin
  ShowDodgeRollWindow(curteam, curplayer);
end;

procedure TBloodbowl.LoseRegainTackleZone1Click(Sender: TObject);
var s: string;
begin
  if player[curteam, curplayer].tz > 0 then begin
    if CanWriteToLog then begin
      s := 'U+' + Chr(curteam + 48) + Chr(curplayer + 64);
      LogWrite(s);
      PlayActionToggleTackleZone(s, 1);
    end;
  end else begin
    if CanWriteToLog then begin
      s := 'U-' + Chr(curteam + 48) + Chr(curplayer + 64);
      LogWrite(s);
      PlayActionToggleTackleZone(s, 1);
    end;
  end;
end;

procedure TBloodbowl.StatsChange1Click(Sender: TObject);
begin
  TeamChanged := curteam;
  PlayerChanged := curplayer;
  frmPlayerStatsChange.Show;
end;

procedure TBloodbowl.SBIGMEOYRedClick(Sender: TObject);
begin
  if (IGMEOY <> 0) and (CanWriteToLog) then begin
    LogWrite('E' + Chr(IGMEOY + 66) + 'B');
    AddLog('I Got My Eye On You: ' + ffcl[0]);
    SetIGMEOY(0);
  end;
end;

procedure TBloodbowl.SBResetIGMEOYClick(Sender: TObject);
begin
  if (IGMEOY <> -1) and (CanWriteToLog) then begin
    LogWrite('E' + Chr(IGMEOY + 66) + 'A');
    AddLog('I Got My Eye On You: Reset');
    SetIGMEOY(-1);
  end;
end;

procedure TBloodbowl.SBIGMEOYBlueClick(Sender: TObject);
begin
  if (IGMEOY <> 1) and (CanWriteToLog) then begin
    LogWrite('E' + Chr(IGMEOY + 66) + 'C');
    AddLog('I Got My Eye On You: ' + ffcl[1]);
    SetIGMEOY(1);
  end;
end;

procedure TBloodbowl.SBThrowInClick(Sender: TObject);
begin
  frmThrowIn.Show
end;

procedure TBloodbowl.FormShow(Sender: TObject);
begin
  frmLogControl.Show;
end;

procedure LoadTeam(g: integer);
begin
  Bloodbowl.LoadTeamDialog.InitialDir := LoadSaveDir;
  Bloodbowl.LoadTeamDialog.Filename := '';
  Bloodbowl.LoadTeamDialog.Options := [ofFileMustExist];
  Bloodbowl.LoadTeamDialog.Execute;
  if Bloodbowl.LoadTeamDialog.Filename <> '' then begin
    if CanWriteToLog then
      LoadTeamFile(g, Bloodbowl.LoadTeamDialog.Filename);
  end;
end;

procedure TBloodbowl.ButLoadRedClick(Sender: TObject);
var intAnswer: integer;
begin
  LoadTeam(0);
  if team[0].name <> '' then begin
    LblRedteam.caption := team[0].name;
    ButLoadRed.enabled := false;
    LblRedteam.Font.Color := TeamTextColor[0];
    if not(ButLoadBlue.enabled) then ButWeather.Enabled := true;
    if RLCoach[0] = '' then begin
      intAnswer := Application.MessageBox('Are you playing this team?',
                           'Bloodbowl', mb_YesNo);
      if intAnswer = idYes then begin
        RLCoach[0] := LoggedCoach;
        UpdateLog(1, LoggedCoach);
        SetSpeakLabel(0);
        if (team[0].homefield <> '') and (RLCoach[0] = LoggedCoach) then begin
          if FileExists(curdir + 'roster/' + team[0].homefield) then begin
            frmSettings.txtFieldImageFile.text :=
              '../roster/' + team[0].homefield;
            ShowFieldImage(frmSettings.txtFieldImageFile.text);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBloodbowl.ButLoadBlueClick(Sender: TObject);
var intAnswer: integer;
begin
  LoadTeam(1);
  if team[1].name <> '' then begin
    LblBlueteam.caption := team[1].name;
    ButLoadBlue.enabled := false;
    LblBlueteam.Font.Color := TeamTextColor[1];
    if not(ButLoadRed.enabled) then ButWeather.Enabled := true;
    if RLCoach[1] = '' then begin
      intAnswer := Application.MessageBox('Are you playing this team?',
                           'Bloodbowl', mb_YesNo);
      if intAnswer = idYes then begin
        RLCoach[1] := LoggedCoach;
        UpdateLog(2, LoggedCoach);
        SetSpeakLabel(1);
        if (team[1].homefield <> '') and (RLCoach[1] = LoggedCoach) then begin
          if FileExists(curdir + 'roster/' + team[1].homefield) then begin
            frmSettings.txtFieldImageFile.text :=
              '../roster/' + team[1].homefield;
            ShowFieldImage(frmSettings.txtFieldImageFile.text);
          end;
        end;
      end;
    end;
  end;
end;

procedure TBloodbowl.ButWeatherClick(Sender: TObject);
begin
  Bloodbowl.Weathertable1Click(Bloodbowl);
  LblWeather.caption :=
    Copy(Bloodbowl.WeatherLabel.caption, 1,
          Pos('.', Bloodbowl.WeatherLabel.caption) - 1);
  ButWeather.enabled := false;
  ButGate.enabled := true;
  RGGate.visible := true;
end;

procedure TBloodbowl.ButGateClick(Sender: TObject);
begin
  case RGGate.Itemindex of
   0: WorkOutGate('G');
   1: WorkOutGate('S');
   2: WorkOutGate('F');
  end;
  LblGate.caption := IntToStr(Gate) + '.000 cheering fans!';
  RGGate.visible := false;
  ButGate.enabled := false;
  ButHandicap.enabled := true;
end;

procedure TBloodbowl.ButHandicapClick(Sender: TObject);
begin
  WorkOutHandicap;
end;

procedure TBloodbowl.butMakeHandicapRollsClick(Sender: TObject);
begin
  MakeHandicapRolls;
end;

procedure TBloodbowl.ButCardsRedClick(Sender: TObject);
begin
  RollForCards(0);
  DrawNewCards := true;
  frmCards.Show;
  frmCards.RedRB.checked := true;
  ButCardsRed.enabled := false;
end;

procedure TBloodbowl.ButCardsBlueClick(Sender: TObject);
begin
  RollForCards(1);
  DrawNewCards := true;
  frmCards.Show;
  frmCards.BlueRB.checked := true;
  ButCardsBlue.enabled := false;
end;

procedure TBloodbowl.ButNigglesClick(Sender: TObject);
begin
  WorkOutNiggles;
end;

procedure TBloodbowl.ButTossClick(Sender: TObject);
begin
  WorkOutToss;
end;

procedure TBloodbowl.ButSaveGameClick(Sender: TObject);
begin
  Bloodbowl.SaveGame1Click(Bloodbowl);
end;

procedure TBloodbowl.ButStartClick(Sender: TObject);
begin
  Bloodbowl.StartHalfSBClick(Bloodbowl);
  PregamePanel.visible := false;
end;

procedure TBloodbowl.PostgameSBClick(Sender: TObject);
var intAnswer, p, done, f, LossMod, r1, r2, r3, NoPlayers: integer;
    UsedPlayers: array [1..4] of integer;
begin
  if not(PostgameActive) then begin
    intAnswer := Application.MessageBox('Are you sure you want to start ' +
                  'the Postgame Sequence?', 'Bloodbowl', mb_YesNo);
    if intAnswer = idYes then begin
      if CanWriteToLog then begin
        LogWrite('G');
        PlayActionStartPostGame('G', 1);
        Continuing := true;
        MakeRegenerationRolls;
        ResetPlayers;

        Bloodbowl.comment.text := team[0].name + ' made ' + InttoStr(D3RollRed)+
          ' 3+ rolls out of '+ InttoStr(D3RollTOTRed)+' D6 rolls.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[0].name + ' made ' + InttoStr(KDownRed)+
          ' knockdowns out of '+ InttoStr(KDownTOTRed)+' blocks.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[0].name + ' beat AV ' + InttoStr(AVBreakRed)+
          ' out of '+ InttoStr(AVBreakTOTRed)+' AV rolls.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[0].name + ' rolled KO or worse ' + InttoStr(KOInjRed)+
          ' out of '+ InttoStr(KOInjTOTRed)+' injury rolls.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[1].name + ' made ' + InttoStr(D3RollBlue)+
          ' 3+ rolls out of '+ InttoStr(D3RollTOTBlue)+' D6 rolls.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[1].name + ' made ' + InttoStr(KDownBlue)+
          ' knockdowns out of '+ InttoStr(KDownTOTBlue)+' blocks.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[1].name + ' beat AV ' + InttoStr(AVBreakBlue)+
          ' out of '+ InttoStr(AVBreakTOTBlue)+' AV rolls.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        Bloodbowl.comment.text := team[1].name + ' rolled KO or worse ' + InttoStr(KOInjBlue)+
          ' out of '+ InttoStr(KOInjTOTBlue)+' injury rolls.';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);

        if (frmSettings.cbNurglesRotters.checked) then NurgleRotRolls;
        {Begin Evil Git Rolls}
        for p := 0 to 1 do begin
          if (Uppercase(team[p].race) = 'EVIL GITS') then begin
            UsedPlayers[1] := -1;
            UsedPlayers[2] := -1;
            UsedPlayers[3] := -1;
            UsedPlayers[4] := -1;
            LossMod := 0;
            if (marker[p, MT_Score].value <= marker[1-p, MT_Score].value) then
              LossMod := 1;
            Bloodbowl.comment.text := 'Post Game Injury rolls for Evil Gits!';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
            if lastroll <=2 then NoPlayers := 1 else
            if (lastroll>=3) and (lastroll<=4) then NoPlayers := 2 else
            NoPlayers := 3;
            for f := 1 to (NoPlayers + LossMod) do begin
              done := 0;
              while done = 0 do begin
                RandomPlayer(p);
                if (player[curteam,curplayer].status <> 8) and
                   (player[curteam,curplayer].status <> 10) and
                   (player[curteam,curplayer].status <> 11) then done := 1;
                if (curplayer=UsedPlayers[1]) or (curplayer=UsedPlayers[2]) or
                  (curplayer=UsedPlayers[3]) or (curplayer=UsedPlayers[4]) 
                  then done := 0;
              end;
              UsedPlayers[f] := curplayer;
              r3 := Rnd(6,3) + 1;
              r1 := Rnd(6,2) + 1;
              r2 := Rnd(6,1) + 1;
              if r3 <= 3 then begin
                InjuryStatus := 6;
                Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                  player[curteam, curplayer].name +
                  ' only Badly Hurt from the Post Game Fight! He will be fine!';
                Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              end;
              if (r3>=4) and (r3<=5) then begin
                if (r1>=1) and (r1<=3) then begin
                  InjuryStatus := 70;
                  Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                    player[curteam, curplayer].name +
                    ' will Miss Next Game from the Post Game Fight!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else
                if (r1>=4) and (r1<=5) then begin
                  InjuryStatus := 71;
                  Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                    player[curteam, curplayer].name +
                    ' will Miss Next Game and suffers a Niggling Injury from the Post Game Fight!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else
                if (r2=1) or (r2=2) then begin
                  InjuryStatus := 72;
                  Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                    player[curteam, curplayer].name +
                    ' will Miss Next Game and suffers -1 MA from the Post Game Fight!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else
                if (r2=3) then begin
                  InjuryStatus := 73;
                  Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                    player[curteam, curplayer].name +
                    ' will Miss Next Game and suffers -1 ST from the Post Game Fight!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else
                if (r2=4) then begin
                  InjuryStatus := 74;
                  Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                    player[curteam, curplayer].name +
                    ' will Miss Next Game and suffers -1 AG from the Post Game Fight!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end else
                if (r2=5) or (r2=6) then begin
                  InjuryStatus := 75;
                  Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                    player[curteam, curplayer].name +
                    ' will Miss Next Game and suffers -1 AV from the Post Game Fight!';
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end;
              end;
              if r3 = 6 then begin
                InjuryStatus := 8;
                Bloodbowl.comment.text := InttoStr(r1)+InttoStr(r2)+': '+
                  player[curteam, curplayer].name +
                  ' KILLED during the Post Game Fight!  What a fight!';
                Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
              end;
              player[curteam,curplayer].SetStatus(InjuryStatus);
              InjuryStatus := 0;
            end;
          end;
        end;
        {End Evil Gits rolls}
        if (frmSettings.cbWizards.checked) and (team[0].wiz=1) then begin
          curroster := 0;
          Buy('X');
        end;
        if (frmSettings.cbWizards.checked) and (team[1].wiz=1) then begin
          curroster := 1;
          Buy('X');
        end;
        if (frmSettings.cbApoths.checked) and (team[0].apot<>0) then begin
          curroster := 0;
          Buy('Z');
        end;
        if (frmSettings.cbApoths.checked) and (team[1].apot<>0) then begin
          curroster := 1;
          Buy('Z');
        end;
        if (frmSettings.rgAging.ItemIndex = 3) and (not(frmSettings.cbMVPEXP.checked))
          then begin
          frmPostgame.ButMVPRed.Caption := 'EXP';
          frmPostgame.ButMVPBlue.Caption := 'EXP';
          {Ronald EXP change:
          frmPostgame.ButMVPRed.enabled := false;
          frmPostgame.ButMVPBlue.enabled := false;
          MakeEXPRolls;
          }
        end;
        if (frmSettings.rgAging.ItemIndex = 3) and (frmSettings.cbMVPEXP.checked)
          then begin
          frmPostgame.ButMVPRed.Caption := 'MVP/EXP';
          frmPostgame.ButMVPBlue.Caption := 'MVP/EXP';
          {Ronald EXP change:
          frmPostgame.ButMVPRed.enabled := false;
          frmPostgame.ButMVPBlue.enabled := false;
          MakeEXPRolls;
          }
        end;

        Continuing := false;
        frmPostgame.BringToFront;
      end;
    end;
  end else frmPostgame.Show;
end;

procedure TBloodbowl.MakePass1Click(Sender: TObject);
var PassFine, TZone, bga, proskill, reroll, UReroll: Boolean;
    g, f: integer;
    ReRollAnswer: string;
begin
  if player[curteam, curplayer].status = 2 then begin
    PassFine := true;
    TZone := true;
    g := curteam;
    f := curplayer;
    if player[curteam, curplayer].hasSkill('Greater Glory') then begin
      player[g,f].UseSkill('Greater Glory');
      Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
      bga := (((player[g,f].BigGuy) or (player[g,f].Ally))
         and (frmSettings.rgBGA4th.ItemIndex >= 1));
      proskill := ((player[g,f].HasSkill('Pro'))) and (lastroll <= 3) and
         (not (player[g,f].usedSkill('Pro'))) and (g = curmove);
      reroll := CanUseTeamReroll(bga);
      if lastroll <= 3 then begin
        ReRollAnswer := 'Fail Roll';
        if reroll and proskill then begin
          ReRollAnswer := FlexMessageBox('Greater Glory roll failed!'
            , 'Greater Glory Pass Failure', 'Use Pro,Team Reroll,Fail Roll');
        end else if proskill then ReRollAnswer := 'Use Pro' else
        if reroll then begin
          ReRollAnswer := FlexMessageBox('Greater Glory roll failed!'
            , 'Greater Glory Pass Failure', 'Team Reroll,Fail Roll');
        end;
      end;
      if ReRollAnswer='Team Reroll' then begin
        UReroll := UseTeamReroll;
        if UReroll then begin
          Bloodbowl.comment.text := 'Greater Glory reroll';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
        end;
      end;
      if ReRollAnswer='Use Pro' then begin
         player[g,f].UseSkill('Pro');
         Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         if lastroll <= 3 then TeamRerollPro(g,f);
         if (lastroll <= 3) then lastroll := 1;
         if (lastroll >= 4) then begin
           Bloodbowl.comment.text := 'Pro reroll';
           Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
           Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
         end;
      end;
      if lastroll <= 3 then begin
         Bloodbowl.Endofmove1Click(Bloodbowl);
         Bloodbowl.comment.text := player[g,f].name + ' fails his Greater Glory' +
           ' roll and refuses to Pass the ball.   Pass action wasted!';
         Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
         PassFine := false;
      end;
    end;
    if (player[g,f].tz > 0) and (not(frmSettings.cbNoTZAssist.checked))
      then TZone := False;
    if TZone then begin
      if PassFine then begin
        GameStatus := 'Pass';
        Loglabel.caption := 'CLICK ON THE PLAYER OR THE SPOT ON THE FIELD ' +
           'WHERE THE BALL IS PASSED TO';
      end;
    end else begin
      Application.Messagebox('The player does not have a tackle zone so he cannot ' +
      'make a pass!', 'Bloodbowl Pass Error', MB_OK);
    end;
  end else begin
    Application.Messagebox('The player does not have the ball so he cannot ' +
    'make a pass!', 'Bloodbowl Pass Error', MB_OK);
  end;
end;

procedure TBloodbowl.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if not(comment.Focused) then begin
    comment.Text := comment.Text + Key;
    comment.Setfocus;
    comment.SelStart := Length(comment.Text);
  end;
end;

procedure TBloodbowl.MakeCatchroll1Click(Sender: TObject);
begin
  ShowCatchWindow(curteam, curplayer, 0, false, false);
end;

procedure TBloodbowl.MakeGFIroll1Click(Sender: TObject);
begin
  ShowGFIWindow(curteam, curplayer);
end;

procedure TBloodbowl.MakePickuproll1Click(Sender: TObject);
begin
  ShowPickUpWindow(curteam, curplayer);
end;

procedure TBloodbowl.UpdateHalfID(HalfNo: integer);
begin
  if HalfNo <= 1 then lbHalfID.caption := '1';
  if HalfNo = 2 then lbHalfID.caption := '2';
  if HalfNo > 2 then lbHalfID.caption := 'O';
end;

procedure TBloodbowl.PostgameRolls1Click(Sender: TObject);
begin
  PostgameSBClick(Sender);
end;

procedure TBloodbowl.HandicapRolls1Click(Sender: TObject);
begin
  ShowHandicapTablesForm;
end;

procedure TBloodbowl.Settings1Click(Sender: TObject);
begin
  frmSettings.Show;
end;

procedure TBloodbowl.ScatterBall1Click(Sender: TObject);
var f, g: integer;
begin
  for f := 0 to 14 do
   for g := 0 to 25 do if fieldPopup.PopupComponent = field[f,g] then begin
     ScatterBallFrom(f, g, 1, 0);
   end;
end;

procedure TBloodbowl.ScatterPlayerBall1Click(Sender: TObject);
begin
  ScatterBallFrom((player[curteam,curplayer].p), (player[curteam,curplayer].q), 1, 0);
end;

procedure TBloodbowl.HGaze1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Hypnotic Gaze'))
  then begin
    if not (player[curteam,curplayer].usedSkill('Hypnotic Gaze'))
    then begin
      GameStatus := 'HGaze';
      if (frmSettings.rgHGaze.ItemIndex=1) and (player[curteam,curplayer].font.size=12) then
        Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO GAZE ... REMEMBER'+
          ' YOU MUST USE A BLITZ ACTION TO GAZE AND MOVE AFTER GAZING'
      else if (frmSettings.rgHGaze.ItemIndex=1) and (player[curteam,curplayer].font.size<>12) then
        Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO GAZE ... REMEMBER'+
          ' YOU MUST USE A BLITZ ACTION TO DO THIS SINCE YOU HAVE MOVED ALREADY'
      else Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO GAZE';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
        Application.Messagebox('You can only use Hypnotic Gaze once per a turn!',
                 'Bloodbowl Hypnotic Gaze Warning', MB_OK);
    end;
  end else begin
        Application.Messagebox('You must have the Hypnotic Gaze skill!',
                 'Bloodbowl Hypnotic Gaze Warning', MB_OK);
  end;
end;

procedure TBloodbowl.Leap1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Pogo Stick')) or
    (player[curteam,curplayer].hasSkill('Leap'))
    then begin
    if not (player[curteam,curplayer].usedSkill('Leap'))
      and not(player[curteam,curplayer].hasSkill('Pogo Stick'))
      then begin
      GameStatus := 'Leap';
      Loglabel.caption := 'CLICK ON THE SPOT ON THE FIELD ' +
           'WHERE YOU WISH TO LEAP TO';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
      Application.Messagebox('You can only use Leap once per a turn!',
                 'Bloodbowl Leap Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Leap or Pogo Stick skill!',
                 'Bloodbowl Leap Warning', MB_OK);
  end;
end;

procedure TBloodbowl.MultipleBlock1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.BearHug1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Bear Hug')) and
   (player[curteam,curplayer].font.size = 12)
  then begin
    if not (player[curteam,curplayer].usedSkill('Bear Hug')) then begin
      GameStatus := 'Bear Hug';
      Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO BEAR HUG';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
        Application.Messagebox('You can only use Bear Hug once per a turn!',
                 'Bloodbowl Bear Hug Warning', MB_OK);
    end;
  end else begin
        Application.Messagebox('You must have the Bear Hug skill and not have moved!',
                 'Bloodbowl Bear Hug Warning', MB_OK);
  end;
end;

procedure TBloodbowl.Chill1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Chill'))
  then begin
    if not (player[curteam,curplayer].usedSkill('Chill')) then begin
      GameStatus := 'Chill';
      Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO CHILL';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
        Application.Messagebox('You can only use Chill once per a turn!',
                 'Bloodbowl Chill Warning', MB_OK);
    end;
  end else begin
        Application.Messagebox('You must have the Chill skill!',
                 'Bloodbowl Chill Warning', MB_OK);
  end;
end;

procedure TBloodbowl.Ethereal1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Ethereal'))
    then begin
    if not (player[curteam,curplayer].usedSkill('Ethereal'))
      then begin
      GameStatus := 'Ethereal';
      Loglabel.caption := 'CLICK ON THE OPPONENT THAT YOU WISH TO PASS THROUGH';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
      Application.Messagebox('You can only use Ethereal once per a turn!',
                 'Bloodbowl Ethereal Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Ethereal skill!',
                 'Bloodbowl Ethereal Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowTeamMate1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Throw TeamMate')) or
    (player[curteam,curplayer].hasSkill('Toss Team-Mate')) or
    (player[curteam,curplayer].hasSkill('Throw Team-Mate'))
    then begin
    if ((player[curteam,curplayer].hasSkill('Throw TeamMate')) and
      (not (player[curteam,curplayer].usedSkill('Throw TeamMate')))) or
      ((player[curteam,curplayer].hasSkill('Throw Team-Mate')) and
      (not (player[curteam,curplayer].usedSkill('Throw Team-Mate')))) or
      ((player[curteam,curplayer].hasSkill('Toss Team-Mate')) and
      (not (player[curteam,curplayer].usedSkill('Toss Team-Mate'))))
      then begin
      GameStatus := 'ThrowTeamMate1';
      Loglabel.caption := 'CLICK ON THE PLAYER THAT YOU WISH TO THROW';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
      Application.Messagebox('You can only use Throw Team-Mate once per a turn!',
                 'Bloodbowl Throw Team-Mate Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Throw Team-Mate skill!',
                 'Bloodbowl Throw Team-Mate Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowBomb1Click(Sender: TObject);
begin
  if ((player[curteam,curplayer].hasSkill('Bomb')) and
  (player[curteam,curplayer].font.size = 12)) or ((curteam=BombTeam) and
  (curplayer=BombPlayer))
  then begin
    GameStatus := 'Bomb';
    Loglabel.caption := 'CLICK ON THE PLAYER/SQUARE THAT YOU WISH TO THROW THE' +
      ' BOMB AT';
    ActionTeam := curteam;
    ActionPlayer := curplayer;
  end else begin
     Application.Messagebox('You must have the skill BOMB and not have moved ' +
       ' to throw a Bomb!','Bloodbowl Bomb Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowStinkBomb1Click(Sender: TObject);
begin
  if ((player[curteam,curplayer].hasSkill('Stink Bomb')) and
  (player[curteam,curplayer].font.size = 12)) or ((curteam=BombTeam) and
  (curplayer=BombPlayer))
  then begin
    GameStatus := 'StinkBomb';
    Loglabel.caption := 'CLICK ON THE PLAYER/SQUARE THAT YOU WISH TO THROW THE' +
      ' BOMB AT';
    ActionTeam := curteam;
    ActionPlayer := curplayer;
  end else begin
    Application.Messagebox('You must have the skill STINK BOMB and not ' +
      'have moved to throw one!','Bloodbowl Stink Bomb Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowinMovement1Click(Sender: TObject);
begin
  GameStatus := 'ThrowinMovement';
  Loglabel.caption := 'CLICK ON THE SQUARE THAT WOULD BE THE 3-4 DIRECTION';
  ActionTeam := curteam;
  ActionPlayer := curplayer;
end;

procedure TBloodbowl.MaceTail1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Mace Tail')) and
   (player[curteam,curplayer].font.size = 12)
  then begin
    if not (player[curteam,curplayer].usedSkill('Mace Tail')) then begin
      GameStatus := 'Mace Tail';
      Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO MACE TAIL';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin

        Application.Messagebox('You can only use Mace Tail once per a turn!',
                 'Bloodbowl Mace Tail Warning', MB_OK);
    end;
  end else begin
        Application.Messagebox('You must have the Mace Tail skill and not have moved!',
                 'Bloodbowl Mace Tail Warning', MB_OK);
  end;
end;

procedure TBloodbowl.BulletThrow1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Bullet Throw')) then begin
    if player[curteam, curplayer].status = 2 then begin
      GameStatus := 'BulletThrow';
      Loglabel.caption := 'CLICK ON THE PLAYER TO THROW THE BALL TO';
    end else begin
      Application.Messagebox('The player doesn''t have the ball so he can''t ' +
      'make a pass!', 'Bloodbowl Pass Error', MB_OK);
    end;
  end else begin
    Application.Messagebox('You must have the Bullet Throw skill!',
                 'Bloodbowl Bullet Throw Warning', MB_OK);
  end;
end;

procedure TBloodbowl.PitchPlayer1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Pitch Player'))
    then begin
    if not (player[curteam,curplayer].usedSkill('Pitch Player'))
      then begin
      GameStatus := 'PitchPlayer1';
      Loglabel.caption := 'CLICK ON THE PLAYER THAT YOU WISH TO THROW';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
      Application.Messagebox('You can only use Pitch Player once per a turn!',
                 'Bloodbowl Pitch Player Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Pitch Player skill!',
                 'Bloodbowl Pitch Player Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowNet1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Netter'))
  then begin
    GameStatus := 'Net';
    Loglabel.caption := 'CLICK ON THE PLAYER THAT YOU WISH TO THROW THE' +
      ' NET AT';
    ActionTeam := curteam;
    ActionPlayer := curplayer;
  end else begin
     Application.Messagebox('You must have the Skill NETTER to throw a Net!',
                 'Bloodbowl Netter Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowBigBomb1Click(Sender: TObject);
begin
  if ((player[curteam,curplayer].font.size = 12)) or ((curteam=BombTeam) and
  (curplayer=BombPlayer)) then begin
    GameStatus := 'BigBomb';
    Loglabel.caption := 'Click on the Player/Square that you wish to throw the' +
      ' BIG bomb at';
    ActionTeam := curteam;
    ActionPlayer := curplayer;
  end else begin
    Application.Messagebox('You must not have moved to throw the BIG BOMB!',
      'Bloodbowl BIG BOMB Warning', MB_OK);
  end;
end;

procedure TBloodbowl.ThrowFireball1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.CastFireball1Click(Sender: TObject);
var pplace, qplace, g, t, u, v, w, ploc, qloc: integer;
    Ballscatter: boolean;
begin
  if (wiz[curmove].color = colorarray[curmove, 0, 0]) and
  (team[curmove].wiz=1)
    then begin
    Ballscatter := false;
    g := curmove;
    ActionTeam := curteam;
    ActionPlayer := curplayer;
    pplace := player[ActionTeam,ActionPlayer].p;
    qplace := player[ActionTeam,ActionPlayer].q;
    LogWrite('W' + Chr(g + 48));
    AddLog(ffcl[g] + '''s Wizard casts a spell');
    wiz[g].color := colorarray[g, 4, 0];
    wiz[g].font.color := colorarray[g, 4, 1];
    for t := 1 to 3 do begin
      for u := 1 to 3 do begin
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = pplace + (t-2)) and (player[v,w].q = qplace + (u-2))
              then begin
                Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                if lastroll > player[v,w].ag then begin
                   Bloodbowl.comment.Text := 'Fireball HITS #' +
                     player[v,w].GetPlayerName + ' AG: ' +
                     InttoStr(player[v,w].ag);
                   Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                   ArmourSettings(v,w,v,w,1);
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
                  Bloodbowl.comment.Text := 'Fireball misses ' +
                    player[v,w].GetPlayerName + ' AG: ' +
                    InttoStr(player[v,w].ag);
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end;
            end;
          end;
        end;
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else begin
     Application.Messagebox('You must have an unused Wizard to do this!',
                 'No Wizard Warning', MB_OK);
  end;
end;

procedure TBloodbowl.CastFireballField1Click(Sender: TObject);
var pplace, qplace, f, g, t, u, v, w, z, ploc, qloc: integer;
    Ballscatter: boolean;
begin
  if (wiz[curmove].color = colorarray[curmove, 0, 0]) and
  (team[curmove].wiz=1)
    then begin
    Ballscatter := false;
    z := curmove;
    LogWrite('W' + Chr(z + 48));
    AddLog(ffcl[z] + '''s Wizard casts a spell');
    wiz[z].color := colorarray[z, 4, 0];
    wiz[z].font.color := colorarray[z, 4, 1];
    for f := 0 to 14 do
      for g := 0 to 25 do if fieldPopup.PopupComponent = field[f,g] then begin
        pplace := f;
        qplace := g;
    end;
    for t := 1 to 3 do begin
      for u := 1 to 3 do begin
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = pplace + (t-2)) and (player[v,w].q = qplace + (u-2))
              then begin
                Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
                if lastroll > player[v,w].ag then begin
                   Bloodbowl.comment.Text := 'Fireball HITS #' +
                     player[v,w].GetPlayerName + ' AG: ' +
                     InttoStr(player[v,w].ag);
                   Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                   ArmourSettings(v,w,v,w,1);
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
                  Bloodbowl.comment.Text := 'Fireball misses ' +
                    player[v,w].GetPlayerName + ' AG: ' +
                    InttoStr(player[v,w].ag);
                  Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                end;
            end;
          end;
        end;
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else begin
     Application.Messagebox('You must have an unused Wizard to do this!',
                 'No Wizard Warning', MB_OK);
  end;
end;

procedure TBloodbowl.CastLightningBolt1Click(Sender: TObject);
var pplace, qplace, g, t, v, w, ploc, qloc, testp1, testq1, testq2,
    Lboltcount, LBoltPlayer, LBoltCount2: integer;
    Ballscatter, Zapped: boolean;
    LeftRight: string;
begin
  if (wiz[curmove].color = colorarray[curmove, 0, 0]) and
  (team[curmove].wiz=1)
  then begin
    if (player[curteam,curplayer].p=0) or (player[curteam,curplayer].p=14)
    then begin
      if (player[curteam,curplayer].q=0) then LeftRight := 'Right'
      else if (player[curteam,curplayer].q=25) then LeftRight := 'Left'
      else begin
        LeftRight := 'Left';
        LeftRight := FlexMessageBox('Should the 2nd square of the Lightning Bolt'+
          ' width be to the Right or Left of this square?'
            , 'Lightning Bolt Question','Left,Right');
      end;
      Ballscatter := false;
      Zapped := false;
      g := curmove;
      ActionTeam := curteam;
      ActionPlayer := curplayer;
      pplace := player[ActionTeam,ActionPlayer].p;
      qplace := player[ActionTeam,ActionPlayer].q;
      LogWrite('W' + Chr(g + 48));
      AddLog(ffcl[g] + '''s Wizard casts a spell');
      wiz[g].color := colorarray[g, 4, 0];
      wiz[g].font.color := colorarray[g, 4, 1];
      for t := 0 to 4 do begin
        if pplace = 0 then begin
          testp1 := pplace + t;
          testq1 := qplace;
          if LeftRight = 'Left' then testq2 := qplace -1 else
            testq2 := qplace + 1;
        end else begin
          testp1 := pplace - t;
          testq1 := qplace;
          if LeftRight = 'Left' then testq2 := qplace -1 else
            testq2 := qplace + 1;
        end;
        LBoltCount := 0;
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = testp1) and ((player[v,w].q = testq1) or
              (player[v,w].q = testq2)) then LBoltCount := LBoltCount + 1;
          end;
        end;
        if LBoltCount = 2 then LBoltPlayer := Rnd(2,6) + 1;
        if LBoltCount = 1 then LBoltPlayer := 1;
        LBoltCount2 := 0;
        if (LBoltCount > 0) and (not(Zapped)) then begin
          for v := 0 to 1 do begin
            for w := 1 to team[v].numplayers do begin
              if (player[v,w].p = testp1) and ((player[v,w].q = testq1) or
              (player[v,w].q = testq2)) then begin
                  LBoltCount2 := LBoltCount2 + 1;
                  if LBoltPlayer = LBoltCount2 then begin
                    Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
                    if lastroll > player[v,w].ag then begin
                       Bloodbowl.comment.Text := 'Lightning Bolt HITS #' +
                         player[v,w].GetPlayerName + ' AG: ' +
                         InttoStr(player[v,w].ag);
                       Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                       ArmourSettings(v,w,v,w,1);
                       if player[v,w].status < InjuryStatus then begin
                         if player[v,w].status=2 then begin
                           ploc := player[v,w].p;
                           qloc := player[v,w].q;
                           player[v,w].SetStatus(InjuryStatus);
                           BallScatter := true;
                         end else player[v,w].SetStatus(InjuryStatus);
                       end;
                       InjuryStatus := 0;
                       Zapped := true;
                    end else begin
                      Bloodbowl.comment.Text := 'Lightning Bolt misses ' +
                        player[v,w].GetPlayerName + ' AG: ' +
                        InttoStr(player[v,w].ag);
                      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                    end;
                  end;
              end;
            end;
          end;
        end;
      end;
      if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
    end else begin
     Application.Messagebox('Lightning Bolt may only be cast from a sideline square!',
                 'Lightning Bolt Not from Sideline Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have an unused Wizard to do this!',
                 'No Wizard Warning', MB_OK);
  end;
end;

procedure TBloodbowl.CastLBoltField1Click(Sender: TObject);
var pplace, qplace, g, f, t, v, w, ploc, qloc, testp1, testq1, testq2,
    Lboltcount, LBoltPlayer, LBoltCount2: integer;
    Ballscatter, Zapped: boolean;
    LeftRight: string;
begin
  if (wiz[curmove].color = colorarray[curmove, 0, 0]) and
  (team[curmove].wiz=1)
  then begin
    for f := 0 to 14 do
      for g := 0 to 25 do if fieldPopup.PopupComponent = field[f,g] then begin
        pplace := f;
        qplace := g;
    end;
    if (pplace=0) or (pplace=14)
    then begin
      if (qplace=0) then LeftRight := 'Right'
      else if (qplace=25) then LeftRight := 'Left'
      else begin
        LeftRight := 'Left';
        LeftRight := FlexMessageBox('Should the 2nd square of the Lightning Bolt'+
          ' width be to the Right or Left of this square?'
            , 'Lightning Bolt Question','Left,Right');
      end;
      Ballscatter := false;
      Zapped := false;
      g := curmove;
      LogWrite('W' + Chr(g + 48));
      AddLog(ffcl[g] + '''s Wizard casts a spell');
      wiz[g].color := colorarray[g, 4, 0];
      wiz[g].font.color := colorarray[g, 4, 1];
      for t := 0 to 4 do begin
        if pplace = 0 then begin
          testp1 := pplace + t;
          testq1 := qplace;
          if LeftRight = 'Left' then testq2 := qplace -1 else
            testq2 := qplace + 1;
        end else begin
          testp1 := pplace - t;
          testq1 := qplace;
          if LeftRight = 'Left' then testq2 := qplace -1 else
            testq2 := qplace + 1;
        end;
        LBoltCount := 0;
        for v := 0 to 1 do begin
          for w := 1 to team[v].numplayers do begin
            if (player[v,w].p = testp1) and ((player[v,w].q = testq1) or
              (player[v,w].q = testq2)) then LBoltCount := LBoltCount + 1;
          end;
        end;
        if LBoltCount = 2 then LBoltPlayer := Rnd(2,6) + 1;
        if LBoltCount = 1 then LBoltPlayer := 1;
        LBoltCount2 := 0;
        if (LBoltCount > 0) and (not(Zapped)) then begin
          for v := 0 to 1 do begin
            for w := 1 to team[v].numplayers do begin
              if (player[v,w].p = testp1) and ((player[v,w].q = testq1) or
              (player[v,w].q = testq2)) then begin
                  LBoltCount2 := LBoltCount2 + 1;
                  if LBoltPlayer = LBoltCount2 then begin
                    Bloodbowl.TwoD6ButtonClick(Bloodbowl.TwoD6Button);
                    if lastroll > player[v,w].ag then begin
                       Bloodbowl.comment.Text := 'Lightning Bolt HITS #' +
                         player[v,w].GetPlayerName + ' AG: ' +
                         InttoStr(player[v,w].ag);
                       Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                       ArmourSettings(v,w,v,w,1);
                       if player[v,w].status < InjuryStatus then begin
                         if player[v,w].status=2 then begin
                           ploc := player[v,w].p;
                           qloc := player[v,w].q;
                           player[v,w].SetStatus(InjuryStatus);
                           BallScatter := true;
                         end else player[v,w].SetStatus(InjuryStatus);
                       end;
                       InjuryStatus := 0;
                       Zapped := true;
                    end else begin
                      Bloodbowl.comment.Text := 'Lightning Bolt misses ' +
                        player[v,w].GetPlayerName + ' AG: ' +
                        InttoStr(player[v,w].ag);
                      Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
                    end;
                  end;
              end;
            end;
          end;
        end;
      end;
      if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
    end else begin
     Application.Messagebox('Lightning Bolt may only be cast from a sideline square!',
                 'Lightning Bolt Not from Sideline Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have an unused Wizard to do this!',
                 'No Wizard Warning', MB_OK);
  end;
end;

procedure TBloodbowl.CastZap1Click(Sender: TObject);
var pplace, qplace, g, t, u, v, w, ploc, qloc, Zteam, Zplayer: integer;
    Ballscatter, Zapped: boolean;
    s, s2: string;
begin
  if (wiz[curmove].color = colorarray[curmove, 0, 0]) and
  (team[curmove].wiz=1) 
  then begin
    Ballscatter := false;
    Zapped := false;
    g := curmove;
    ActionTeam := curteam;
    ActionPlayer := curplayer;
    pplace := player[ActionTeam,ActionPlayer].p;
    qplace := player[ActionTeam,ActionPlayer].q;
    LogWrite('W' + Chr(g + 48));
    AddLog(ffcl[g] + '''s Wizard casts a spell');
    wiz[g].color := colorarray[g, 4, 0];
    wiz[g].font.color := colorarray[g, 4, 1];
    Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
    StuffP := pplace;
    StuffQ := qplace;
    if lastroll < 4 then begin
      ScatterStuffFrom(Stuffp, Stuffq, lastroll, 0, 'Zap');
    end;
    if StuffP <> -1 then begin
      for v := 0 to 1 do begin
        for w := 1 to team[v].numplayers do begin
          if (player[v,w].p = StuffP) and (player[v,w].q = StuffQ)
          then begin
            Zapped := true;
            Zteam := v;
            Zplayer := w;
          end;
        end;
      end;
      if Zapped then begin
        Bloodbowl.comment.Text := 'Zap Spell HITS #' +
          player[Zteam,Zplayer].GetPlayerName + '.  Players changed to a FROG!!!' +
          '  Use Stats Change, Reset to' +
          ' default change him/her back at the end of the drive!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        s2 := 'u' + Chr(Zteam + 48) + Chr(Zplayer + 64) +
               Chr(player[Zteam,Zplayer].ma + 48) +
               Chr(player[Zteam,Zplayer].st + 48) +
               Chr(player[Zteam,Zplayer].ag + 48) +
               Chr(player[Zteam,Zplayer].av + 48) +
               Chr(player[Zteam,Zplayer].cnumber + 64) +
               Chr(player[Zteam,Zplayer].value div 5 + 48) +
               player[Zteam,Zplayer].name + '$' +
               player[Zteam,Zplayer].position + '$' +
               player[Zteam,Zplayer].picture + '$' +
               player[Zteam,Zplayer].icon + '$' +
               player[Zteam,Zplayer].GetSkillString(1) + '|' +
               Chr(3 + 48) +
               Chr(1 + 48) +
               Chr(4 + 48) +
               Chr(4 + 48) +
               Chr(player[Zteam,Zplayer].cnumber + 64) +
               Chr(player[Zteam,Zplayer].value div 5 + 48) +
               player[Zteam,Zplayer].name + '$' +
               'Toad' + '$' +
               'Human\Toad.jpg' + '$' +
               player[Zteam,Zplayer].icon + '$';
        s := 'Dodge, Leap, Stunty';
        player[Zteam, Zplayer].SetSkill(s);
        s2 := s2 + player[Zteam, Zplayer].GetSkillString(1);
        LogWrite(s2);
        PlayActionPlayerStatChange(s2, 1);
        if player[Zteam,Zplayer].status=2 then begin
          ploc := player[Zteam,Zplayer].p;
          qloc := player[Zteam,Zplayer].q;
          BallScatter := true;
        end;
      end else begin
        Bloodbowl.comment.Text := 'Zap Spell misses everyone!';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
      end;
    end;
    if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
  end else begin
     Application.Messagebox('You must have an unused Wizard to do this!',
                 'No Wizard Warning', MB_OK);
  end;
end;

procedure TBloodbowl.Wings1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Wings'))
    then begin
    if ((player[curteam,curplayer].LastAction = 1) and
        (player[curteam,curplayer].UsedMA > 1)) then begin
      if not (player[curteam,curplayer].usedSkill('Wings'))
        then begin
        GameStatus := 'Wings';
        Loglabel.caption := 'CLICK ON THE SPOT ON THE FIELD ' +
             'WHERE YOU WISH TO WING TO';
      end else begin
        Application.Messagebox('You can only use Wings once per a turn!',
                   'Bloodbowl Wings Warning', MB_OK);
      end;
    end else begin
      Application.Messagebox('You must move 2 square before using the Wings skill!',
                 'Bloodbowl Wings Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Wings skill!',
                 'Bloodbowl Wings Warning', MB_OK);
  end;
end;

procedure TBloodbowl.WingsLeap1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Wings')) and
     (player[curteam,curplayer].hasSkill('Leap'))
    then begin
    if ((player[curteam,curplayer].LastAction = 1) and
        (player[curteam,curplayer].UsedMA > 1)) then begin
      if not (player[curteam,curplayer].usedSkill('Wings')) and
         not (player[curteam,curplayer].usedSkill('Leap'))
        then begin
        GameStatus := 'WingLeap';
        Loglabel.caption := 'CLICK ON THE SPOT ON THE FIELD ' +
             'WHERE YOU WISH TO WINGED LEAP TO';
      end else begin
        Application.Messagebox('You can only use Wings and Leap once per a turn!',
                   'Bloodbowl Winged Leap Warning', MB_OK);
      end;
    end else begin
      Application.Messagebox('You must move 2 squares before using the Wings skill!',
                 'Bloodbowl Winged Leap Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Wings and Leap skills!',
                 'Bloodbowl Winged Leap Warning', MB_OK);
  end;
end;

procedure TBloodbowl.WarCry1Click(Sender: TObject);
var i,j,k,l,ActionTeam,ActionPlayer: integer;
    s: string;
begin
  if (player[curteam,curplayer].hasSkill('War Cry')) and
   (player[curteam,curplayer].font.size = 12)
  then begin
    if not (player[curteam,curplayer].usedSkill('War Cry')) then begin
      ActionTeam := curteam;
      ActionPlayer := curplayer;
      for i := -1 to 1 do
        for j := -1 to 1 do
          for k := 0 to 1 do
            for l := 1 to team[1-k].numplayers do begin
              if (i<>0) or (j<>0) then begin
                if (((player[ActionTeam,ActionPlayer].p)+i)=(player[k,l].p)) and
                   (((player[ActionTeam,ActionPlayer].q)+j)=(player[k,l].q)) then begin
                     s := 'U-' + Chr(k + 48) +  Chr(l + 64);
                     LogWrite(s);
                     PlayActionToggleTackleZone(s, 1);
                     if (ActionTeam=k) and (player[k,l].font.size = 12) then begin
                       s := 'x' + Chr(k + 48) + Chr(l + 65) +
                         Chr(player[k,l].UsedMA + 64);
                       LogWrite(s);
                       PlayActionEndOfMove(s, 1);
                     end;
                end;
              end;
            end;
    end else begin
        Application.Messagebox('You can only use War Cry once per a turn!',
                 'Bloodbowl War Cry Warning', MB_OK);
    end;
  end else begin
        Application.Messagebox('You must have the War Cry skill and not have moved!',
                 'Bloodbowl War Cry Warning', MB_OK);
  end;
end;

procedure TBloodbowl.Shadowing1Click(Sender: TObject);
begin
  GameStatus := 'Shadow';
  Loglabel.caption := 'CLICK ON THE OPPONENT THAT IS TRYING TO SHADOW YOU';
  ActionTeam := curteam;
  ActionPlayer := curplayer;
end;

procedure TBloodbowl.MakeKickRoll1Click(Sender: TObject);
begin
  if player[curteam, curplayer].status = 2 then begin
    GameStatus := 'Kick';
    Loglabel.caption := 'CLICK ON THE ADJACENT SQUARE THAT IS THE STRAIGHT '+
       'LINE KICKING DIRECTION';
  end else begin
    Application.Messagebox('The player doesn''t have the ball so he can''t ' +
    'make a kick!', 'Bloodbowl Kick Error', MB_OK);
  end;
end;

procedure TBloodbowl.Punt1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Punt'))
    then begin
    if not (player[curteam,curplayer].usedSkill('Punt'))
      then begin
      GameStatus := 'Punt';
      Loglabel.caption := 'CLICK ON THE SQUARE THAT YOU WISH TO PUNT TO';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
      Application.Messagebox('You can only use Punt once per a turn!',
                 'Bloodbowl Punt Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Punt skill!',
                 'Bloodbowl Punt Warning', MB_OK);
  end;
end;

procedure TBloodbowl.DirtyKick1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Dirty Kick'))
    then begin
    if not (player[curteam,curplayer].usedSkill('Dirty Kick'))
      then begin
      GameStatus := 'Dirty Kick';
      Loglabel.caption := 'CLICK ON THE PLAYER THAT YOU WISH TO DIRTY KICK';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
    end else begin
      Application.Messagebox('You can only use Dirty Kick once per a turn!',
                 'Bloodbowl Dirty Kick Warning', MB_OK);
    end;
  end else begin
     Application.Messagebox('You must have the Dirty Kick skill!',
                 'Bloodbowl Dirty Kick Warning', MB_OK);
  end;
end;

procedure TBloodbowl.AVInjRoll1Click(Sender: TObject);
var p, NiggleCount, totspp, MVPValue, ploc, qloc, v, w: integer;
    s: string;
    SPP4th, BallScatter: boolean;
begin
  Ballscatter := false;
  v := curteam;
  w := curplayer;
  InjuryStatus := 0;
  HitTeam := -1;
  HitPlayer := -1;
  BlockTeam := -1;
  BlockPlayer := -1;
  BashTeam := -1;
  BashPlayer := -1;
  DownTeam := -1;
  DownPlayer := -1;
  GetCAS := false;
  ArmourSettings(curteam,curplayer,curteam,curplayer,0);
  if player[v,w].status < InjuryStatus then begin
    if player[v,w].status=2 then begin
      ploc := player[v,w].p;
      qloc := player[v,w].q;
      player[v,w].SetStatus(InjuryStatus);
      BallScatter := true;
    end else player[v,w].SetStatus(InjuryStatus);
  end;
  InjuryStatus := 0;
  if BallScatter then ScatterBallFrom(ploc, qloc, 1, 0);
end;

procedure TBloodbowl.PickWeather1Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather1.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather2Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather2.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather3Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather3.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather4Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather4.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather5Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather5.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather6Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather6.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather7Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather7.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather8Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather8.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather9Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather9.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather10Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather10.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.PickWeather11Click(Sender: TObject);
var s0: string;
    g, p: integer;
    foundit: boolean;
begin
  foundit := false;
  for g := 2 to 12 do begin
    s0 := WeatherTable[g];
    p := Pos('.', s0);
    if (Bloodbowl.PWeather11.Caption = '&' + Copy(s0,1,p-1)) and not(foundit) then begin
      WeatherPickClick(g);
      foundit := true;
    end;
  end;
end;

procedure TBloodbowl.RemoveComp1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].comp0)+(player[curteam, curplayer].comp) > 0
      then begin
      player[curteam, curplayer].comp := player[curteam, curplayer].comp - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'cR');
      AddLog('Remove Completion for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.RemoveInt1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].int)+(player[curteam, curplayer].int0) > 0
      then begin
      player[curteam, curplayer].int := player[curteam, curplayer].int - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'IA');
      AddLog('Remove Interception for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.RemoveTD1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].td)+(player[curteam, curplayer].td0) > 0
      then begin
      player[curteam, curplayer].td := player[curteam, curplayer].td - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'TA');
      AddLog('Remove Touchdown for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.RemoveCas1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].cas)+(player[curteam, curplayer].cas0) > 0
      then begin
      player[curteam, curplayer].cas := player[curteam, curplayer].cas - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'C');
      AddLog('Remove Casualty for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.RemoveOther1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].otherSPP)+(player[curteam, curplayer].otherSPP0) > 0
      then begin
      player[curteam, curplayer].otherSPP :=
                      player[curteam, curplayer].otherSPP - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'O');
      AddLog('Remove 1 other SPP for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.RemoveMVP1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].mvp)+(player[curteam, curplayer].mvp0) > 0
      then begin
      player[curteam, curplayer].mvp :=
                    player[curteam, curplayer].mvp - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'M');
      if (frmSettings.rgAging.ItemIndex <> 3) or (frmSettings.cbMVPEXP.checked) then
        AddLog('Remove MVP Award for ' + player[curteam, curplayer].GetPlayerName) else
        AddLog('Remove EXP Point for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.RemoveEXP1Click(Sender: TObject);
begin
  if CanWriteToLog then begin
    if (player[curteam, curplayer].EXP)+(player[curteam, curplayer].EXP0) > 0
      then begin
      player[curteam, curplayer].EXP :=
                      player[curteam, curplayer].EXP - 1;
      LogWrite('q' + Chr(curteam + 48) + chr(curplayer + 65) + 'E');
      AddLog('Remove EXP point for ' + player[curteam, curplayer].GetPlayerName);
    end;
  end;
end;

procedure TBloodbowl.ArgueCallSBClick(Sender: TObject);
var ArgueRoll, TotalMods: integer;
    s: string;
begin
  ArgueRoll := Rnd(6,1) + 1;
  TotalMods := 0;
  if (ArgueMod<>0) and ((team[curmove].tr) < (team[1-curmove].tr)) and
    (ArgueRoll<>1)
    then begin
      ArgueRoll := ArgueRoll + ArgueMod;
      TotalMods := ArgueMod;
    end;
  if (frmSettings.cbHobgoblin.checked) and
    (Uppercase(team[curmove].race) = 'HOBGOBLIN') and (ArgueRoll<>1) then begin
    ArgueRoll := ArgueRoll + 1;
    TotalMods := TotalMods + 1;
  end;
  if ArgueRoll>6 then ArgueRoll := 6;
  s := 'JC' + Chr(curmove + 48) + Chr(ArgueRoll + 48);
  LogWrite(s);
  PlayActionCoachRef(s, 1);
  s := Chr(255) + 'Hey REF! Argue the Call! ';
  s := s + 'Argue the Call roll: ' + InttoStr(ArgueRoll);
  if TotalMods<>0 then s := s + ' (Modified by ' + InttoStr(TotalMods);
  if ArgueRoll=1 then
    s := s + ' ... Argue the Call roll FAILED!!! Head Coach EJECTED!!!' else
    if ArgueRoll = 6 then
    s := s + ' ... Argue the Call roll succeeds!  Player NOT ejected!' else
    s := s + '... Argue the Call roll fails!';
  PlayActionComment(s, 1, 2);
  LogWrite(s);
end;

procedure TBloodbowl.Dig1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Dig')) and
    (player[curteam,curplayer].status <> 2)
    then begin
      GameStatus := 'Dig1';
      Loglabel.caption := 'CLICK ON THE SQUARE OR PLAYER THAT YOU WISH TO DIG UNDER';
      ActionTeam := curteam;
      ActionPlayer := curplayer;
      DigP := 0;
      DigQ := 0;
      DigStrength := 0;
  end else begin
     Application.Messagebox('You must have the Dig skill and'
      + ' cannot be holding the ball to use it!','Bloodbowl Dig Warning', MB_OK);
  end;
end;

procedure TBloodbowl.RemoveCHACClick(Sender: TObject);
var RemoveQues, s: string;
begin
  if (CanWriteToLog) and (curmove<>-1) then begin
    if (team[curmove].cheerleaders > 0) and (team[curmove].asstcoaches > 0)
    then begin
      RemoveQues := 'Cancel';
      RemoveQues := FlexMessageBox('Remove Assistant Coach or Cheerleader from '+
        'Team: '+ team[curmove].name + '?','Remove Support Staff',
        'Cancel,Assist. Coach,Cheerleader');
      if RemoveQues<>'Cancel' then begin
        if RemoveQues='Assist. Coach' then
          s := 'j' + Chr(curmove + 48) + 'A' else
          s := 'j' + Chr(curmove + 48) + 'C';
        Logwrite(s);
        PlayActionRemoveACCH(s,1);
      end;
    end else
    if (team[curmove].cheerleaders > 0)
    then begin
      RemoveQues := 'Cancel';
      RemoveQues := FlexMessageBox('Remove Cheerleader from '+
        'Team: '+ team[curmove].name + '?','Remove Cheerleader',
        'Cancel,Cheerleader');
      if RemoveQues<>'Cancel' then begin
        s := 'j' + Chr(curmove + 48) + 'C';
        Logwrite(s);
        PlayActionRemoveACCH(s,1);
      end;
    end else
    if (team[curmove].asstcoaches > 0)
    then begin
      RemoveQues := 'Cancel';
      RemoveQues := FlexMessageBox('Remove Assistant Coach from '+
        'Team: '+ team[curmove].name + '?','Remove Assistant Coach',
        'Cancel,Assist. Coach');
      if RemoveQues<>'Cancel' then begin
        s := 'j' + Chr(curmove + 48) + 'A';
        Logwrite(s);
        PlayActionRemoveACCH(s,1);
      end;
    end;
  end;
end;

procedure TBloodbowl.ChangeGate1Click(Sender: TObject);
var GateAnswer, s: string;
begin
  GateAnswer := ' ';
  GateAnswer := FlexMessageBox('How much should the gate change by: '
    ,'Change Gate Question','+1000,+5000,-1000,-5000,No Change');
  if (GateAnswer<>' ') and (GateAnswer<>'No Change') then begin
    s := 'SS';
    if GateAnswer='+1000' then S := S + '1';
    if GateAnswer='+5000' then S := S + '2';
    if GateAnswer='-1000' then S := S + '3';
    if GateAnswer='-5000' then S := S + '4';
    Logwrite(s);
    PlayActionTeamStatChange(s,1);
  end;
end;

procedure ShowDivingTackleRanges(p, q: integer);
var f, g, r, t, m: integer;
begin
  if DivingTackleRangeShowing then begin
    DivingTackleRangeShowing := false;
    for f := 0 to 14 do
      for g := 0 to 25 do field[f,g].color := clGreen;
    if frmSettings.txtFieldImageFile.text <> '' then
      for f := 0 to 14 do
        for g := 0 to 25 do field[f,g].transparent := true;
  end else begin
    DivingTackleRangeShowing := true;
    t := abs(1-curteam);
    if (t=1) or (t=0) then begin
      for m := 1 to team[t].numplayers do begin
        if player[t,m].hasSkill('Diving Tackle') then begin
          for f := 0 to 14 do
            for g := 0 to 25 do begin
              if (abs(f - (player[t,m].p)) <= 1) and
              (abs(g - (player[t,m].q)) <= 1) then begin
                field[f,g].color := clYellow;
                field[f,g].transparent := false;
              end;
            end;
        end;
      end;
    end;
  end;
end;

procedure TBloodbowl.PlayerShowDivingTackle1Click(Sender: TObject);
begin
  ShowDivingTackleRanges(player[curteam, curplayer].p, player[curteam, curplayer].q);
end;

procedure TBloodbowl.FieldShowDivingTackleRanges1Click(Sender: TObject);
var p, q: integer;
begin
  for p := 0 to 14 do
   for q := 0 to 25 do if fieldPopup.PopupComponent = field[p,q] then begin
     ShowDivingTackleRanges(p, q);
   end;
end;

procedure TBloodbowl.SideStep1Click(Sender: TObject);
var pplace, qplace, TestP, TestQ, NewP, NewQ, g, f, q, r, v, w, SStype,
    ballspotp, ballspotq, ploc, qloc, arrow, counter, NotMovedBadTZ,
    BadTZ, FriendTZ, DtoEndZone, DtoBall, NewP2, NewQ2, Winner,
    FinalP, FinalQ: integer;
    s: string;
    OOB, PlayerHere, Sideline, BallFlag, BallScat, PickedSquare: boolean;
    SquarePoints, PDir, QDir: array [0..7] of integer;
begin
  if (player[curteam,curplayer].hasSkill('Side Step'))
     then begin
      ActionTeam := curteam;
      ActionPlayer := curplayer;
      PickedSquare := false;
      if player[ActionTeam,ActionPlayer].SideStep[1] = 1 then begin
        PickedSquare := true;
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if (player[g,f].p = player[ActionTeam,ActionPlayer].SideStep[2]) and
              (player[g,f].q = player[ActionTeam,ActionPlayer].SideStep[3]) then
              PickedSquare := false;
          end;
        end;
      end;
      if PickedSquare then begin
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if player[g,f].status = 2 then begin
              SStype := 3;
              if (g=ActionTeam) and (f=ActionPlayer) then SStype := 1;
              ballspotp := player[g,f].p;
              ballspotq := player[g,f].q;
            end;
          end;
        end;
        if (ball.p >= 0) then begin
          SStype := 2;
          ballspotp := ball.p;
          ballspotq := ball.q;
        end;
        BallScat := false;
        FinalP := player[ActionTeam, ActionPlayer].SideStep[2];
        FinalQ := player[ActionTeam, ActionPlayer].SideStep[3];
        if (FinalP=ballspotp) and (FinalQ=ballspotq) then BallScat := true;
        SideStepStop := false;
        PlacePlayer(ActionPlayer, ActionTeam, FinalP, FinalQ);
        Bloodbowl.comment.text := 'Side Step skill used for pushback - ' +
          'coach picked square';
        Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
        if BallScat then ScatterBallFrom(FinalP, FinalQ, 1, 0);
        s := 'QF' + Chr(ActionTeam + 48) + Chr(ActionPlayer + 64) + Chr(0+48)
          + Chr(0+64) + Chr(0+64)
          + Chr(player[ActionTeam,ActionPlayer].SideStep[1]+48)
          + Chr(player[ActionTeam,ActionPlayer].SideStep[2]+64)
          + Chr(player[ActionTeam,ActionPlayer].SideStep[3]+64);
        LogWrite(s);
        PlayActionSideStep(s, 1);
      end else begin
        pplace := player[ActionTeam,ActionPlayer].p;
        qplace := player[ActionTeam,ActionPlayer].q;
        TestP := player[HitTeam,HitPlayer].p;
        TestQ := player[HitTeam,HitPlayer].q;
        for g := 0 to 1 do begin
          for f := 1 to team[g].numplayers do begin
            if player[g,f].status = 2 then begin
              SStype := 3;
              if (g=ActionTeam) and (f=ActionPlayer) then SStype := 1;
              ballspotp := player[g,f].p;
              ballspotq := player[g,f].q;
            end;
          end;
        end;
        if (ball.p >= 0) then begin
          SStype := 2;
          ballspotp := ball.p;
          ballspotq := ball.q;
        end;
        OOB := true;
        Sideline := false;
        for q := -1 to 1 do begin
          for r := -1 to 1 do begin
            NewP := pplace + q;
            NewQ := qplace + r;
            if (NewP<0) or (NewP>14) or (NewQ<0) or (NewQ>25) then begin
               Sideline := true
            end else begin
              PlayerHere := false;
              for g := 0 to 1 do begin
                for f := 1 to team[g].numplayers do begin
                  if (player[g,f].p = NewP) and (player[g,f].q = NewQ) then
                    PlayerHere := true;
                end;
              end;
              if not(PlayerHere) then OOB := false;
            end;
          end;
        end;
        if not(SideLine) then OOB := false;
        if OOB then begin
          Bloodbowl.comment.text := 'Side Step Player is pushed out of bounds';
          Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
          InjurySettings(curteam, curplayer);
          if InjuryStatus = 4 then InjuryStatus := 0;
          if player[curteam,curplayer].status=2 then begin
            ploc := player[curteam,curplayer].p;
            qloc := player[curteam,curplayer].q;
            player[curteam,curplayer].SetStatus(InjuryStatus);
            if ploc = 0 then arrow := 2;
            if ploc = 14 then arrow := 7;
            if qloc = 0 then arrow := 4;
            if qloc = 25 then arrow := 5;
            ScatterBallFrom(ploc, qloc, 1, arrow);
          end else player[curteam,curplayer].SetStatus(InjuryStatus);
          InjuryStatus := 0;
        end else begin
          for g := 0 to 7 do begin
            SquarePoints[g] := 0;
          end;
          counter := -1;
          for q := -1 to 1 do begin
            for r := -1 to 1 do begin
              NewP2 := pplace + q;
              NewQ2 := qplace + r;
              PlayerHere := false;
              for g := 0 to 1 do begin
                for f := 1 to team[g].numplayers do begin
                  if (player[g,f].p = NewP2) and (player[g,f].q = NewQ2) then
                    PlayerHere := true;
                end;
              end;
              if (NewP2<0) or (NewP2>14) or (NewQ2<0) or (NewQ2>25) then
                PlayerHere := true;
              if PlayerHere then begin
                {skip testing}
              end else begin
                counter := counter + 1;
                PDir[counter] := q;
                QDir[counter] := r;
                NotMovedBadTZ := 0;
                FriendTZ := 0;
                BadTZ := 0;
                BallFlag := false;
                SquarePoints[counter] := Rnd(99,6)+1;
                for v := -1 to 1 do begin
                  for w := -1 to 1 do begin
                    NewP := pplace + q + v;
                    NewQ := qplace + r + w;
                    if (NewP=pplace) and (NewQ=qplace) then begin
                      {skip testing}
                    end else begin
                      for g := 0 to 1 do begin
                        for f := 1 to team[g].numplayers do begin
                          if (player[g,f].p=NewP) and (player[g,f].q=NewQ) then begin
                            if (ActionTeam <> g) and not((g=HitTeam) and (f=HitPlayer))
                              then BadTZ := BadTZ + 1;
                            if (ActionTeam <> g) and (player[g,f].font.size = 12)
                              and not((g=HitTeam) and (f=HitPlayer))
                              then NotMovedBadTZ := NotMovedBadTZ + 1;
                            if ActionTeam = g then FriendTZ := FriendTZ + 1;
                          end;
                        end;
                      end;
                      if (ballspotp=NewP) and (ballspotq=NewQ) and not(BallFlag)
                        and not((ballspotp=NewP2) and (ballspotq=NewQ2))
                        then begin
                          SquarePoints[counter] := SquarePoints[counter]+30000;
                          BallFlag := true;
                        end;
                    end;
                  end;
                end;
                if (NewP2=ballspotp) and (NewQ2=ballspotq) then
                  SquarePoints[counter] := SquarePoints[counter]+20000;
                if ActionTeam=0 then DtoEndZone := 25-NewQ2 else DtoEndZone := NewQ2;
                if abs(NewP2-ballspotp) >= abs(NewQ2-ballspotq) then
                  DtoBall := abs(NewP2-ballspotp) else DtoBall := abs(NewQ2-ballspotq);
                DtoEndZone := 26 - DtoEndZone;
                DtoBall := 26 - DtoBall;
                if SStype = 1 then begin
                  SquarePoints[counter] := SquarePoints[counter] +
                    ((8-NotMovedBadTZ)*10000);
                  SquarePoints[counter] := SquarePoints[counter] +
                    ((DtoEndZone + FriendTZ + (8-BadTZ))*100);
                  if DtoEndZone = 26 then SquarePoints[counter] :=
                    SquarePoints[counter] + 80000;
                end else begin
                  SquarePoints[counter] := SquarePoints[counter] +
                    ((8-NotMovedBadTZ)*10000);
                  SquarePoints[counter] := SquarePoints[counter] +
                    ((DtoBall + FriendTZ + (8-BadTZ))*100);
                end;
              end;
            end;
          end;
          Winner := 0;
          for g := 0 to 7 do begin
            if SquarePoints[g] > SquarePoints[Winner] then Winner := g;
          end;
          if SquarePoints[Winner]=0 then begin
            Bloodbowl.comment.text := 'Side Step Player is not moved';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            Bloodbowl.Loglabel.caption :=
              'All squares blocked, Side Step Player is not moved!';
          end else begin
            BallScat := false;
            FinalP := pplace + PDir[Winner];
            FinalQ := qplace + QDir[Winner];
            if (FinalP=ballspotp) and (FinalQ=ballspotq) then BallScat := true;
            SideStepStop := false;
            PlacePlayer(ActionPlayer, ActionTeam, FinalP, FinalQ);
            Bloodbowl.comment.text := 'Side Step skill used for pushback - '
             + 'PBeM Tool picked square';
            Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
            if BallScat then ScatterBallFrom(FinalP, FinalQ, 1, 0);
          end;
        end;
        ActionTeam := -1;
        ActionPlayer := -1;
        HitTeam := -1;
        HitPlayer := -1;
      end;
  end else begin
    Application.Messagebox('Player must have the Side Step skill!',
      'Bloodbowl Side Step Warning', MB_OK);
  end;
end;

procedure ShowTackleRanges(p, q: integer);
var f, g, r, t, m: integer;
begin
  if TackleRangeShowing then begin
    TackleRangeShowing := false;
    for f := 0 to 14 do
      for g := 0 to 25 do field[f,g].color := clGreen;
    if frmSettings.txtFieldImageFile.text <> '' then
      for f := 0 to 14 do
        for g := 0 to 25 do field[f,g].transparent := true;
  end else begin
    TackleRangeShowing := true;
    t := abs(1-curteam);
    if (t=1) or (t=0) then begin
      for m := 1 to team[t].numplayers do begin
        if player[t,m].hasSkill('Tackle') then begin
          for f := 0 to 14 do
            for g := 0 to 25 do begin
              if (abs(f - (player[t,m].p)) <= 1) and
              (abs(g - (player[t,m].q)) <= 1) then begin
                field[f,g].color := clYellow;
                field[f,g].transparent := false;
              end;
            end;
        end;
      end;
    end;
  end;
end;
procedure TBloodbowl.PlayerShowTackle1Click(Sender: TObject);
begin
  ShowTackleRanges(player[curteam, curplayer].p, player[curteam, curplayer].q);
end;

procedure TBloodbowl.FieldShowTackleRanges1Click(Sender: TObject);
var p, q: integer;
begin
  for p := 0 to 14 do
   for q := 0 to 25 do if fieldPopup.PopupComponent = field[p,q] then begin
     ShowTackleRanges(p, q);
   end;
end;

procedure TBloodbowl.DeclareBlitz1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.DeclareCast1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.DeclareFoul1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.DeclareHandOff1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.DeclarePass1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.DisableRedWizard1Click(Sender: TObject);
begin
  LogWrite('W' + Chr(0 + 48));
  AddLog(ffcl[0] + '''s Wizard casts a spell');
  wiz[0].color := colorarray[0, 4, 0];
  wiz[0].font.color := colorarray[0, 4, 1];
end;

procedure TBloodbowl.DisableRedApothecary1Click(Sender: TObject);
begin
  if (not(frmSettings.cbUpApoth.checked)) then begin
    LogWrite('a' + Chr(0 + 48));
    AddLog(ffcl[0] + ' uses the Apothecary');
    apo[0].color := colorarray[0, 4, 0];
    apo[0].font.color := colorarray[0, 4, 1];
  end else begin
    LogWrite('a' + Chr(0 + 48) + '1');
    AddLog(ffcl[0] + ' uses the Level 1 Apothecary');
    apo1[0].color := colorarray[0, 4, 0];
    apo1[0].font.color := colorarray[0, 4, 1];
    LogWrite('a' + Chr(0 + 48) + '2');
    AddLog(ffcl[0] + ' uses the Level 2 Apothecary');
    apo2[0].color := colorarray[0, 4, 0];
    apo2[0].font.color := colorarray[0, 4, 1];
    LogWrite('a' + Chr(0 + 48) + '3');
    AddLog(ffcl[0] + ' disables the Level 3 Apothecary');
    apo3[0].color := colorarray[0, 4, 0];
    apo3[0].font.color := colorarray[0, 4, 1];
    LogWrite('a' + Chr(0 + 48) + '4');
    AddLog(ffcl[0] + ' uses the Level 4 Apothecary');
    apo4[0].color := colorarray[0, 4, 0];
    apo4[0].font.color := colorarray[0, 4, 1];
    LogWrite('a' + Chr(0 + 48) + '5');
    AddLog(ffcl[0] + ' uses the Level 5 Apothecary');
    apo5[0].color := colorarray[0, 4, 0];
    apo5[0].font.color := colorarray[0, 4, 1];
  end;
end;

procedure TBloodbowl.DisableBlueWizard1Click(Sender: TObject);
begin
  LogWrite('W' + Chr(1 + 48));
  AddLog(ffcl[1] + '''s Wizard casts a spell');
  wiz[1].color := colorarray[1, 4, 0];
  wiz[1].font.color := colorarray[1, 4, 1];
end;

procedure TBloodbowl.DisableBlueApothecary1Click(Sender: TObject);
begin
  if (not(frmSettings.cbUpApoth.checked)) then begin
    LogWrite('a' + Chr(1 + 48));
    AddLog(ffcl[1] + ' uses the Apothecary');
    apo[1].color := colorarray[1, 4, 0];
    apo[1].font.color := colorarray[1, 4, 1];
  end else begin
    LogWrite('a' + Chr(1 + 48) + '1');
    AddLog(ffcl[1] + ' uses the Level 1 Apothecary');
    apo1[1].color := colorarray[1, 4, 0];
    apo1[1].font.color := colorarray[1, 4, 1];
    LogWrite('a' + Chr(1 + 48) + '2');
    AddLog(ffcl[1] + ' uses the Level 2 Apothecary');
    apo2[1].color := colorarray[1, 4, 0];
    apo2[1].font.color := colorarray[1, 4, 1];
    LogWrite('a' + Chr(1 + 48) + '3');
    AddLog(ffcl[1] + ' disables the Level 3 Apothecary');
    apo3[1].color := colorarray[1, 4, 0];
    apo3[1].font.color := colorarray[1, 4, 1];
    LogWrite('a' + Chr(1 + 48) + '4');
    AddLog(ffcl[1] + ' uses the Level 4 Apothecary');
    apo4[1].color := colorarray[1, 4, 0];
    apo4[1].font.color := colorarray[1, 4, 1];
    LogWrite('a' + Chr(1 + 48) + '5');
    AddLog(ffcl[1] + ' uses the Level 5 Apothecary');
    apo5[1].color := colorarray[1, 4, 0];
    apo5[1].font.color := colorarray[1, 4, 1];
  end;
end;

procedure TBloodbowl.RPB1Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB1.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB2Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB2.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB3Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB3.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB4Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB4.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB5Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB5.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB6Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB6.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB7Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB7.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB8Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB8.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB9Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB9.hint;
  RPBCall(s);
end;

procedure TBloodbowl.RPB10Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.RPB10.hint;
  RPBCall(s);
end;

procedure TBloodbowl.BPB1Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB1.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB2Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB2.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB3Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB3.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB4Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB4.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB5Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB5.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB6Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB6.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB7Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB7.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB8Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB8.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB9Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB9.hint;
  BPBCall(s);
end;

procedure TBloodbowl.BPB10Click(Sender: TObject);
var s: string;
begin
  s := Bloodbowl.BPB10.hint;
  BPBCall(s);
end;

procedure TBloodbowl.UseFirethrower1Click(Sender: TObject);
begin
  Loglabel.caption := 'Feature not yet installed ... sorry!';
end;

procedure TBloodbowl.Stab1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Stab')) then begin
    GameStatus := 'Stab';
    Loglabel.caption := 'CLICK ON THE PLAYER YOU WISH TO STAB';
    ActionTeam := curteam;
    ActionPlayer := curplayer;
  end else begin
    Application.Messagebox('You must have the Stab skill!',
                 'Bloodbowl Stab Warning', MB_OK);
  end;
end;

procedure TBloodbowl.PickSideStep1Click(Sender: TObject);
begin
  if (player[curteam,curplayer].hasSkill('Side Step')) then begin
    GameStatus := 'Side Step';
    Loglabel.caption := 'CLICK ON THE SQUARE YOU WANT TO PICK TO SIDE ' +
      'STEP THIS PLAYER TO';
    ActionTeam := curteam;
    ActionPlayer := curplayer;
  end else begin
    Application.Messagebox('You must have the Side Step skill!',
                 'Bloodbowl Step Skill Warning', MB_OK);
  end;
end;

end.


