unit unitLog;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls;

type
  TfrmLog = class(TForm)
    LogLB: TListBox;
    procedure FormCreate(Sender: TObject);
    procedure LogLBDblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const StartOfLog = 10;

var
  frmLog: TfrmLog;
  logcount: integer;
  SetItem, Continuing: boolean;

procedure AddToGameLog(s: string);
procedure UpdateLog(i: integer; s: string);
procedure GoToGameLog(i: integer);
function EOGameLog: boolean;
function BOGameLog: boolean;
function GameLogLength: integer;
function GetGameLog(i: integer): string;
function GetCurrentGameLog: string;
function GetPreviousGameLog: string;
function GetCurrentLogPos: integer;
function CanWriteToLog: boolean;
{procedure ForcedWriteToLog;}
procedure LogWrite(s: string);
function LogRead: string;
function LogReadBack: string;
function LogSubtractLast: string;
procedure AddLog(s: string);
procedure ResetLog;
procedure BackLog;
procedure SetCurrentLogItem;

implementation

uses bbunit, unitLogControl, bbalg, unitExtern, unitSettings;

var logpos: integer;
    gamelog: array of string;

{$R *.DFM}

procedure ClearLogAfterCurrent;
var q: integer;
begin
  q := frmLog.LogLB.Items.Count - 1;
  while q > frmLog.LogLB.ItemIndex do begin
    frmLog.LogLB.items.delete(q);
    q := q - 1;
  end;
end;

procedure AddToGameLog(s: string);
begin
  SetLength(gamelog, Length(gamelog) + 1);
  gamelog[High(gamelog)] := s;
  logpos := Length(gamelog);
  SaveGameAllowed := true;
  Bloodbowl.savegameSB.Visible := true;
  Bloodbowl.SaveGame1.Visible := true;
end;

procedure UpdateLog(i: integer; s: string);
begin
  gamelog[i] := s;
end;

procedure GoToGameLog(i: integer);
begin
  logpos := i;
end;

function EOGameLog: boolean;
begin
  EOGameLog := (logpos >= Length(gamelog));
end;

function BOGameLog: boolean;
begin
  BOGameLog := (logpos <= StartOfLog);
end;

function GameLogLength: integer;
begin
  GameLogLength := Length(gamelog);
end;

function GetGameLog(i: integer): string;
begin
  GetGameLog := gamelog[i];
end;

function GetCurrentGameLog: string;
var i: integer;
begin
  i := logpos;
  while (i > 0) and (Copy(gamelog[i], 1, 1) = '(') do i := i - 1;
  while (i < Length(gamelog)) and (Copy(gamelog[i], 1, 1) = ')') do i := i + 1;
  if (i < Length(gamelog)) and (i >=0) then GetCurrentGameLog := gamelog[i]
  {at end of file, simulate a turn change marker}
                                else GetCurrentGameLog := 'T';
end;

function GetPreviousGameLog: string;
begin
  if logpos > StartOfLog then GetPreviousGameLog := gamelog[logpos - 1]
                else GetPreviousGameLog := '~';
end;

function GetCurrentLogPos: integer;
begin
  GetCurrentLogPos := logpos;
end;

function CanWriteToLog: boolean;
var f, p, p2, p3: integer;
    b, be, br: boolean;
    s, t, t2: string;
begin
  b := false;
  br := false;
  {check for coach}
  if not(InEditMode) then begin
    be := ((RLCoach[0] = LoggedCoach) or (RLCoach[1] = LoggedCoach)) or
      (LoggedCoach = 'Teakoak Ironwood');
    if not(be) then begin
      for f := 0 to 1 do begin
        if RLCoach[f] = '' then begin
          if Application.MessageBox(PChar('Are you playing this team: ' +
             ffcl[f] + '?'),
             'Bloodbowl Coach', MB_YESNO) = IDYES then begin
            be := true;
            RLCoach[f] := LoggedCoach;
            gamelog[f + 1] := LoggedCoach;
            SetSpeakLabel(f);
            if (team[f].homefield <> '') and (RLCoach[f] = LoggedCoach) then begin
              if FileExists(curdir + 'roster/' + team[f].homefield) then begin
                frmSettings.txtFieldImageFile.text :=
                  '../roster/' + team[f].homefield;
                ShowFieldImage(frmSettings.txtFieldImageFile.text);
              end;
            end;
          end;
        end;
      end;
      if not(be) then
         Application.MessageBox (
                'You are not playing this game! Log on as another coach!',
                'Bloodbowl Error', MB_OK);
    end;

  end else be := true;

  {check for deletion of part log}
  if (be) and (logpos <= High(gamelog)) and (TIKSTPK) then b := false else
    if be and (logpos <= High(gamelog)) then begin
      if AskConfirmation then begin
        if Application.MessageBox(
           'Are you sure you want to delete the log after this point ' +
           'and play from here on?', 'Bloodbowl Log Warning', MB_OKCANCEL) = 1
          then b := true;
      end else b := true;
      if b then begin
        for f := logpos to High(gamelog) do begin
          gamelog[f] := '( ' + gamelog[f];
        end;
        {gamelog := Copy(gamelog, 0, logpos);}
        ClearLogAfterCurrent;
        if not(InEditMode) then RecordInRegistry(GetGameLog(0), GameLogLength);
        AddToGameLog('(/' + LoggedCoach + '@' + DateTimeToStr(Now) + '%');
        br := true;
        s := '/' + LoggedCoach + '@' + DateTimeToStr(Now) + '%';
        p := Pos('@', s);
        p2 := Pos('%', s);
        p3 := Pos('$', s);
        InEditMode := true;
      end;
    end else b := true;
  CanWriteToLog := (b and be);
  if br then begin
    t2 := '***ALERT*** LOG RE-WIND by ' +
      Copy(s, 2, p-2) + ' at ' + Copy(s, p+1, p2-p-1);
    if Bloodbowl.SpeakLabel.caption[1] = 'H' then t := Chr(253)
      else t := Chr(254);
    LogWrite(t + t2 + Chr(255));
    if Bloodbowl.SpeakLabel.caption[1] = 'H' then t := ffcl[0] else t := ffcl[1];
    AddLog(t + ': "' + t2 + '"');
  end;
end;

{procedure ForcedWriteToLog;
var f: integer;
    b: boolean;
begin
  b := false;
  if logpos <= High(gamelog) then begin
    for f := logpos to High(gamelog) do begin
      gamelog[f] := '( ' + gamelog[f];
    end;
    ClearLogAfterCurrent;
  end;
end;
}
procedure LogWrite(s: string);
var p: integer;
    s2, t, t2: string;
begin
  if logpos >= Length(gamelog) then begin
    if not(InEditMode) then begin
      RecordInRegistry(GetGameLog(0), GameLogLength);
      InEditMode := true;
    end;
    if Continuing then s := '(' + s;
    AddToGameLog(s);
    if (s = '') and (Length(gamelog) > StartOfLog) then begin
      ShowMessage('ERROR! Empty string added to log');
    end;
  end else ShowMessage('ERROR! in LogWrite procedure');
end;

function LogRead: string;
begin
  if logpos < Length(gamelog) then begin
    LogRead := gamelog[logpos];
    logpos := logpos + 1;
  end else LogRead := '~';
end;

function LogReadBack: string;
begin
  if logpos > StartOfLog then logpos := logpos - 1;
  if logpos >= StartOfLog then begin
    LogReadBack := gamelog[logpos];
{    logpos := logpos - 1;}
  end else LogReadBack := '~';
end;

function LogSubtractLast: string;
begin
  if logpos = Length(gamelog) then begin
    LogSubtractLast := gamelog[Length(gamelog) - 1];
    SetLength(gamelog, Length(gamelog) - 1);
    logpos := Length(gamelog);
  end else begin
    ShowMessage('Error! Log subtract!');
    LogSubtractLast := 'xxxxxxxx';
  end;
end;

procedure AddLog(s: string);
var p, q: integer;
    s0: string;
begin
  p := frmLog.LogLB.items.count;
  q := logcount;
  s0 := IntToStr(q + 1) + ': ' + s;
  if CheckFileOpen then begin
    writeln(CheckFile, s0);
  end;
  if ExportFileOpen then begin
    writeln(ExportLog, s0);
  end;
  if not(frmLog.Showing) and (Bloodbowl.Viewlog1.Checked) then begin
    frmLog.Show;
    Bloodbowl.BringToFront;
    frmLogControl.BringToFront;
  end;

  Bloodbowl.Loglabel.caption := s;
  if ref then Bloodbowl.Loglabel.Refresh;

  if q = p then begin
    {add to gamelog}
    q := frmLog.LogLB.items.add(s0);
    if frmLog.LogLB.items[q] = '' then begin
      Application.Messagebox('Error LOG1! Please send your bbm file to ' +
          EMailAddress, 'Error!', mb_OK);
    end;
  end else begin
    {move through gamelog}
    if s0 <> frmLog.LogLB.Items[q] then begin
      Application.Messagebox('Error LOG2! Please send your bbm file to ' +
          EMailAddress, 'Error!', mb_OK);
    end;
  end;

  if SetItem then frmLog.LogLB.ItemIndex := q;
  if ref then frmLog.LogLB.Refresh;

  logcount := q + 1;
  frmLogControl.logcounter.text := IntToStr(q + 1);
  if ref then frmLogControl.logcounter.Refresh;
end;

procedure ResetLog;
begin
  frmLog.LogLB.Clear;
  if ref then frmLog.LogLB.Refresh;
  Bloodbowl.Loglabel.caption := '';
  if ref then Bloodbowl.Loglabel.Refresh;
  logcount := 0;
  HalfNo := 0;
  Bloodbowl.UpdateHalfID(HalfNo);
  frmLogControl.logcounter.text := IntToStr(0);
  if ref then frmLogControl.logcounter.Refresh;
end;

procedure BackLog;
var p, q: integer;
begin
  q := logcount - 1;
  p := Pos(':', frmLog.LogLB.items[q]);
  Bloodbowl.Loglabel.caption :=
      Copy(frmLog.LogLB.items[q], p+2, length(frmLog.LogLB.items[q]));
  if ref then Bloodbowl.Loglabel.Refresh;
  logcount := q;
  frmLogControl.logcounter.text := IntToStr(q);
  if SetItem then frmLog.LogLB.ItemIndex := q - 1;
  if ref then frmLog.LogLB.Refresh;
end;

procedure SetCurrentLogItem;
var p: integer;
begin
  p := logcount - 1;
  frmLog.LogLB.ItemIndex := p;
  SetItem := true;
end;

procedure TfrmLog.FormCreate(Sender: TObject);
begin
{  ResetLog;}
  logcount := 0;
  logpos := 0;
  Finalize(gamelog);
{  LogButtonsForm.logcounter.text := '0';}
  SetItem := true;
  Continuing := false;
end;

procedure TfrmLog.LogLBDblClick(Sender: TObject);
begin
  Bloodbowl.BringToFront;
  frmLogControl.BringToFront;
  GotoEntry(LogLB.ItemIndex + 1);
end;

end.
