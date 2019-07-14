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
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label18: TLabel;
    butAccept: TButton;
    lblCantChange: TLabel;
    txtMWTable: TEdit;
    txtKOTable: TEdit;
    txtWeatherTable: TEdit;
    txtFieldImageFile: TEdit;
    rgRandomAlgorithm: TRadioGroup;
    GroupBox2: TGroupBox;
    Label22: TLabel;
    Label23: TLabel;
    Button1: TButton;
    lblHomeColor: TLabel;
    lblAwayColor: TLabel;
    butHomeColorChange: TButton;
    butAwayColorChange: TButton;
    cdColorDialog: TColorDialog;
    Label17: TLabel;
    txtCardsIniFile: TEdit;
    butSelectFile: TButton;
    dlgPic: TOpenDialog;
    cbPassingRangesColored: TCheckBox;
    cbBlackIce: TCheckBox;
    cbWeatherPitch: TCheckBox;
    cbLRB4KO: TCheckBox;
    Label11: TLabel;
    cbDC: TCheckBox;
    cbDeStun: TCheckBox;
    procedure butAcceptClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LoadLeagueSettings();
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
     unitRandom;

{$R *.DFM}

const
  SETTINGS_INDEX  = 3;

procedure FixSettings;
var f: integer;
begin
  for f := 1 to frmSettings.pcSettings.PageCount - 1 do
                frmSettings.pcSettings.Pages[f].Enabled := false;
  frmSettings.butAccept.visible := false;
  frmSettings.lblCantChange.visible := true;

  frmArmourRoll.txtDPArmMod.text := '+' + bbalg.DirtyPlayerArmourModifier.ToString;
  frmArmourRoll.txtDPInjMod.text := '+' + bbalg.DirtyPlayerInjuryModifier.ToString;

  FillKOTable;
  FillWTable;
  frmCards.InitForm;
  frmRoster.InitForm;

  Bloodbowl.sbOtherSPP.Visible := false;
  Bloodbowl.OtherSPP1.visible := false;
  Bloodbowl.RemoveOther1.Visible := false;

  Bloodbowl.butCardsBlue.visible := false;
  Bloodbowl.butCardsRed.visible := false;

  ShowFieldImage(frmSettings.txtFieldImageFile.text);

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
  GetText;
  GetText;
  frmSettings.txtMWTable.text := GetText;
  frmSettings.txtKOTable.text := GetText;
  frmSettings.txtWeatherTable.text := GetText;

  GetText;

  frmSettings.cbBlackIce.Checked := (s[62] = 'G');

  GetText;

  frmSettings.cbWeatherPitch.checked := (s[7] = 'W');

  frmSettings.cbLRB4KO.Checked := (s[10] = 'K');
  frmSettings.cbDeStun.checked := (s[11] = 'S');
  frmSettings.cbDC.Checked := (s[12] = 'D');

  GetText;

  GetText;
  frmSettings.txtCardsIniFile.text := GetText;
  GetText;
  frmSettings.txtFieldImageFile.text := GetText;

  FixSettings;
end;

procedure TfrmSettings.butAcceptClick(Sender: TObject);
var st: string;
    i: integer;
begin
  for i := 1 to pcSettings.PageCount - 1 do
      pcSettings.Pages[i].Enabled := false;
  st := '*';
  st := st + '*' + txtMWTable.text + '*' +
        txtKOTable.text + '*' + txtWeatherTable.text + '*';
  st := st + 'M';
  st := st + 'S';
  st := st + Chr(48 + 2);    // Wild animal
  st := st + 'D';
  st := st + 'T';
  st := st + 'B';
  st := st + '2';
  st := st + Chr(48 + 3);
  st := st + 'A';
  // section
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

  // section
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
  // section
  st := st + '*';
  st := st + bbalg.RegenRollNeeded.ToString();
  st := st + '.';
  st := st + 'W'; // stunty penalties
  st := st + '.';   // 41-6 niggling injury
  st := st + '.';
  st := st + '.';
  st := st + '.';
  // section
  st := st + '*' + Trim(txtCardsIniFile.text);
  st := st + '*';
  st := st + '*' + Trim(txtFieldImageFile.text);
  // section
  st := st + '*';
  st := st + '.';
  st := st + 'S'; // separate inj/arm rolls
  st := st + '';
  UpdateLog(SETTINGS_INDEX, st);

  ModalResult := 1;
  FixSettings;
  Bloodbowl.Show;
  Bloodbowl.BringToFront;
  Bloodbowl.PregamePanel.visible := true;
  Bloodbowl.PregamePanel.BringToFront;

end;

procedure TfrmSettings.FormCreate(Sender: TObject);
begin
  LoadLeagueSettings();
end;

procedure TfrmSettings.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if butAccept.visible then Bloodbowl.Close else begin
    ShowFieldImage(txtFieldImageFile.text);
  end;
end;

procedure TfrmSettings.LoadLeagueSettings();
var ff: TextFile;
    s: string;
    i: integer;
begin
    for i := 1 to pcSettings.PageCount - 1 do
      pcSettings.Pages[i].Enabled := true;

    AssignFile(ff, curdir + 'ini/pbleague.ini');
    Reset(ff);
    while not(eof(ff)) do begin
      ReadLn(ff, s);
      begin
        if Copy(s, 1, 19) = 'MatchWinningsTable=' then begin
          txtMWTable.text := Trim((copy(s, 20, length(s))));
        end;
        if Copy(s, 1, 13) = 'KickOffTable=' then begin
          txtKOTable.text := Trim((copy(s, 14, length(s))));
        end;
        if Copy(s, 1, 13) = 'WeatherTable=' then begin
          txtWeatherTable.text := Trim((copy(s, 14, length(s))));
        end;

        if Copy(s, 1, 15) = 'NewDivingCatch=' then begin
          cbDC.checked := (Copy(s, 16, 1) = 'Y');
        end;

        if Copy(s, 1, 7) = 'DeStun=' then begin
          cbDeStun.checked := (Copy(s, 8, 1) = 'Y');
        end;

        if Copy(s, 1, 13) = 'CardsIniFile=' then begin
          txtCardsIniFile.text := Copy(s, 14, Length(s) - 13);
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
end;

end.
