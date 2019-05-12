unit unitThrowIn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmThrowIn = class(TForm)
    GroupBox1: TGroupBox;
    RBTop: TRadioButton;
    RBBottom: TRadioButton;
    RBLeft: TRadioButton;
    RBRight: TRadioButton;
    ThrowInBut: TButton;
    procedure SelectionClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ThrowInButClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmThrowIn: TfrmThrowIn;

function TranslateThrowIn(tis: string): string;

implementation

uses bbunit, unitRandom;

{$R *.DFM}

procedure TfrmThrowIn.SelectionClick(Sender: TObject);
begin
  ThrowInBut.enabled := true;
end;

procedure TfrmThrowIn.FormActivate(Sender: TObject);
begin
  RBTop.checked := false;
  RBLeft.checked := false;
  RBRight.checked := false;
  RBBottom.checked := false;
  ThrowInBut.enabled := false;
end;

procedure TfrmThrowIn.ThrowInButClick(Sender: TObject);
var s: string;
begin
  s := '*throwin ';
  if RBTop.checked then s := s + 'T';
  if RBLeft.checked then s := s + 'L';
  if RBRight.checked then s := s + 'R';
  if RBBottom.checked then s := s + 'B';
  s := s + Chr(49 + Rnd(6,6)) + Chr(66 + Rnd(6,6) + Rnd(6,6));
  Bloodbowl.comment.text := s;
  Bloodbowl.EnterButtonClick(Sender);
  frmThrowIn.Hide;
end;

function TranslateThrowIn(tis: string): string;
var s: string;
begin
  s := 'Throw In from ';
  case tis[2] of
   'T': begin
          s := s + 'top sideline: dir ' + tis[3] + ' ';
          case tis[3] of
            '1', '2': s := s + '(down right)';
            '3', '4': s := s + '(down)';
            '5', '6': s := s + '(down left)';
          end;
        end;
   'L': begin
          s := s + 'left sideline: dir ' + tis[3] + ' ';
          case tis[3] of
            '1', '2': s := s + '(up right)';
            '3', '4': s := s + '(right)';
            '5', '6': s := s + '(down right)';
          end;
        end;
   'R': begin
          s := s + 'right sideline: dir ' + tis[3] + ' ';
          case tis[3] of
            '1', '2': s := s + '(down left)';
            '3', '4': s := s + '(left)';
            '5', '6': s := s + '(up left)';
          end;
        end;
   'B': begin
          s := s + 'bottom sideline: dir ' + tis[3] + ' ';
          case tis[3] of
            '1', '2': s := s + '(up left)';
            '3', '4': s := s + '(up)';
            '5', '6': s := s + '(up right)';
          end;
        end;
  end;
  s := s + ' distance: ' + IntToStr(Ord(tis[4]) - 64);
  TranslateThrowIn := s;
end;

end.
