unit unitLogControl;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, bbalg;

type
  TfrmLogControl = class(TForm)
    StartButton: TSpeedButton;
    StartturnButton: TBitBtn;
    logcounter: TEdit;
    PlayoneButton: TBitBtn;
    EndturnButton: TBitBtn;
    EndButton: TBitBtn;
    PlaybackmoveButton: TBitBtn;
    PlayButton: TBitBtn;
    procedure StartButtonClick(Sender: TObject);
    procedure StartturnButtonClick(Sender: TObject);
    procedure PlayButtonClick(Sender: TObject);
    procedure PlayoneButtonClick(Sender: TObject);
    procedure PlaybackmoveButtonClick(Sender: TObject);
    procedure EndturnButtonClick(Sender: TObject);
    procedure EndButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure logcounterKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmLogControl: TfrmLogControl;

implementation

uses unitLog, bbunit, unitPostgameSeq, logPlayback;

{$R *.DFM}

procedure TfrmLogControl.StartButtonClick(Sender: TObject);
begin
  FormReset(false, false);
  GoToGameLog(StartOfLog);
  logcount := 0;
  HalfNo := 0;
end;

procedure TfrmLogControl.StartturnButtonClick(Sender: TObject);
begin
  Bloodbowl.comment.text :=
            'P L A Y I N G   T O   S T A R T   O F   T U R N . . .';
  Bloodbowl.comment.color := clYellow;
  Bloodbowl.comment.Refresh;
  SetItem := false;
  if not(BOGameLog) then PlayOneBack;
  {$B-}
  while not(BOGameLog) and (Copy(GetCurrentGameLog,1,1) <> 'T')
    and (Copy(GetCurrentGameLog,1,2) <> 'KB') do begin
    PlayOneBack;
  end;
  SetCurrentLogItem;
  Bloodbowl.comment.text := '';
  Bloodbowl.comment.color := clWhite;
end;

procedure TfrmLogControl.PlayButtonClick(Sender: TObject);
begin
  ref := true;
  while not(EOGameLog) do begin
    PlayOne(PlayButtonDelay);
    SetCurrentLogItem;
  end;
  ref := false;
end;

procedure TfrmLogControl.PlayoneButtonClick(Sender: TObject);
begin
  ref := true;
  if not(EOGameLog) then PlayOne(0);
  ref := false;
end;

procedure TfrmLogControl.PlaybackmoveButtonClick(Sender: TObject);
begin
  ref := true;
  if not(BOGameLog) then PlayOneBack;
  ref := false;
end;

procedure TfrmLogControl.EndturnButtonClick(Sender: TObject);
begin
  Bloodbowl.comment.text :=
          'P L A Y I N G   T O   E N D   O F   T U R N . . .';
  Bloodbowl.comment.color := clYellow;
  Bloodbowl.comment.Refresh;
  SetItem := false;
  if not(EOGameLog) then PlayOne(0);
  {$B-}
  while not(EOGameLog) and (Copy(GetCurrentGameLog,1,1) <> 'T')
  and (Copy(GetCurrentGameLog,1,2) <> 'KB') do begin
    PlayOne(0);
  end;
  SetCurrentLogItem;
  Bloodbowl.comment.text := '';
  Bloodbowl.comment.color := clWhite;
end;

procedure TfrmLogControl.EndButtonClick(Sender: TObject);
begin
  Bloodbowl.comment.text :=
         'P L A Y I N G   T O   E N D . . .  One moment please...';
  Bloodbowl.comment.color := clYellow;
  Bloodbowl.comment.Refresh;
  SetItem := false;
  while not(EOGameLog) do PlayOne(0);
  SetCurrentLogItem;
  Bloodbowl.comment.text := '';
  Bloodbowl.comment.color := clWhite;
  frmLog.BringToFront;
  frmLogControl.BringToFront;
  bloodbowl.BringToFront;
  if PostgameActive then frmPostgame.BringToFront;
end;

procedure TfrmLogControl.FormCreate(Sender: TObject);
begin
  if PlayButtonDelay > 0 then begin
    frmLogControl.width := frmLogControl.width + PlayButton.width;
    PlayButton.left := EndTurnButton.left;
    EndTurnButton.left := EndTurnButton.left + PlayButton.width;
    EndButton.left := EndButton.left + PlayButton.width;
  end;
  frmLogControl.left :=
      Bloodbowl.left + Bloodbowl.width - frmLogControl.width;
  {frmLogControl.top := Bloodbowl.top + Bloodbowl.height + 4;}
  frmLogControl.top := Bloodbowl.top + Bloodbowl.height - 5;
{  LogButtonsForm.Show;}
end;

procedure TfrmLogControl.logcounterKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then begin
    Bloodbowl.Enterbuttonclick(Bloodbowl);
  end;
end;

end.
