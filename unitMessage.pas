unit unitMessage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmMessage = class(TForm)
    lblMessage: TLabel;
    procedure ButtonClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmMessage: TfrmMessage;

function FlexMessageBox(txt, capt, buttons: string): string;

implementation

{$R *.dfm}

var butButton: array [1..5] of TButton;
var strClicked: string;

function FlexMessageBox(txt, capt, buttons: string): string;
{FlexMessageBox shows a Dialog box in the center of the screen
 with 'txt' as text, 'capt' as caption,
 and a number of buttons, depending on the string 'buttons'.
 Example: buttons='No,Yes,Cancel' then 3 buttons will be shown, reading
 'No', 'Yes' and 'Cancel'. The first button is the default one, so here
  that would be 'No'. It returns the text of the button being pressed,
  so suppose the user clicks the 2nd button in the example the function
  will return 'Yes'.
  The messagebox can show a maximum of 5 buttons.}
var f, p, w: integer;
    s: string;
begin
  frmMessage.Width := Screen.Width div 2;
  frmMessage.lblMessage.Left := 8;
  frmMessage.lblMessage.Width := frmMessage.ClientWidth - 16;
  frmMessage.lblMessage.caption := txt;
  frmMessage.Caption := capt;
  s := buttons + ',';
  f := 0;
  while s <> '' do begin
    p := Pos(',', s);
    f := f + 1;
    if f > 5 then begin
      ShowMessage('ERROR!!! FlexMessageBox can show at most 5 buttons!');
    end else begin
      butButton[f] := TButton.Create(frmMessage);
      butButton[f].Top := frmMessage.lblMessage.Top +
                        frmMessage.lblMessage.Height + 8;
      butButton[f].left := 8 + (f-1) * (butButton[f].Width + 4);
      butButton[f].visible := true;
      butButton[f].parent := frmMessage;
      butButton[f].OnClick := frmMessage.ButtonClick;
      butButton[f].Caption := Copy(s, 1, p-1);
      s := Copy(s, p+1, Length(s) - p);
    end;
  end;
  butButton[1].Default := true;
  strClicked := '';
  if (f * (butButton[1].Width + 4) > frmMessage.lblMessage.Width) then begin
    w := f * (butButton[1].Width + 4) - frmMessage.lblMessage.Width;
    frmMessage.lblMessage.Left := frmMessage.lblMessage.Left + w div 2;
    frmMessage.ClientWidth := f * (butButton[1].Width + 4) + 12;
  end else begin
    w := frmMessage.lblMessage.Width - f * (butButton[1].Width + 4);
    for p := 1 to f do butButton[p].Left := butButton[p].left + w div 2;
    frmMessage.ClientWidth := frmMessage.lblMessage.Width + 16;
  end;
  frmMessage.ClientHeight := butButton[1].Top + butButton[1].Height + 8;
  frmMessage.Top := (Screen.Height - frmMessage.Height) div 2;
  frmMessage.Left := (Screen.Width - frmMessage.Width) div 2;
  if f <= 5 then frmMessage.ShowModal;
  FlexMessageBox := strClicked;
  for p := 1 to f do butButton[p].Destroy;
end;

procedure TfrmMessage.ButtonClick(Sender: TObject);
begin
  strClicked := (Sender as TButton).Caption;
  frmMessage.ModalResult := 1;
end;

end.
