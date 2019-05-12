unit unitNotes;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmNotes = class(TForm)
    NotesMemo: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNotes: TfrmNotes;

procedure AddNote(s: string);
procedure RemoveNote;

implementation

uses bbunit, unitLog;

{$R *.DFM}

procedure AddNote(s: string);
begin
  if not(frmNotes.Showing) then begin
    frmNotes.Show;
    if frmLog.Showing then frmLog.BringToFront;
    Bloodbowl.BringToFront;
  end;
  frmNotes.NotesMemo.lines.add(s);
  if ref then frmNotes.NotesMemo.Refresh;
end;

procedure RemoveNote;
begin
  frmNotes.NotesMemo.lines.delete(frmNotes.NotesMemo.lines.count - 1);
  if frmNotes.NotesMemo.lines.count = 0 then frmNotes.Hide;
  if ref then frmNotes.NotesMemo.Refresh;
end;

end.
