unit gate;

interface

type
  TGate = class(TObject)
  private
   { private declarations }
   class procedure DoWorkOutGate(redRoll: Integer; blueRoll: Integer);
  protected
   { protected declarations }
  public
   { public declarations }
    class procedure WorkOutGate();
    class procedure PlayActionGate(s: string; dir: integer);
  published
   { published declarations }
  end;

implementation

uses bbalg, bbunit, unitPlayAction, unitLog, unitRandom;

class procedure TGate.WorkOutGate();
var redRoll, blueRoll: integer;
    r: array [0..1] of integer;
begin
  if CanWriteToLog then begin

    redRoll := Roll2D6().Total();
    blueRoll := Roll2D6().Total();

    DoWorkOutGate(redRoll, blueRoll);

    // [2] is G for gate
    LogWrite('D' + 'G' + Chr(redRoll + 48) + Chr(blueRoll + 48));
  end;
end;

class procedure TGate.PlayActionGate(s: string; dir: integer);
var redRoll, blueRoll, redFF, blueFF, redFans, blueFans: integer;
    s0, sr, sb: string;
begin
  if dir = DIR_FORWARD then
  begin

    redRoll := Ord(s[3]) - 48;
    blueRoll := Ord(s[4]) - 48;

    DoWorkOutGate(redRoll, blueRoll);

    Bloodbowl.ButGate.enabled := false;
    Bloodbowl.ButHandicap.enabled := true;
  end
  else
  begin
    BackLog;
    Bloodbowl.GateLabel.caption := '';
    Bloodbowl.LblGate.caption := '';

    Bloodbowl.ButGate.enabled := true;
    Bloodbowl.ButHandicap.enabled := false;
  end;
end;

class procedure TGate.DoWorkOutGate(redRoll: Integer; blueRoll: Integer);
var
  redFF: Integer;
  blueFF: Integer;
  redFans: Integer;
  blueFans: Integer;
  sr: string;
  sb: string;
  s1: string;
  gateLabelText: string;
begin
  redFF := team[0].ff;
  blueFF := team[1].ff;
  redFans := redRoll + redFF;
  blueFans := blueRoll + blueFF;
  bbalg.Gate := redFans + blueFans;

  // FAME
  bbalg.RedFame := 0;
  bbalg.BlueFame := 0;
  // more red fans
  if redFans > blueFans then
    if (redFans / 2) > blueFans then
      bbalg.redFame := 2
    else
      bbalg.redFame := 1;
  // more blue fans
  if blueFans > redFans then
    if (blueFans / 2) > redFans then
      bbalg.blueFame := 2
    else
      bbalg.blueFame := 1;

  sr := '(Red:' + IntToStr(redRoll) + ' + ' + IntToStr(redFF) + 'FF = ' + IntToStr(redFans) + ')';
  sb := '(Blue:' + IntToStr(blueRoll) + ' + ' + IntToStr(blueFF) + 'FF = ' + IntToStr(blueFans) + ')';
  s1 := IntToStr(bbalg.Gate) + ',000 cheering fans!';
  gateLabelText := 'Gate: ' + s1 + Chr(13) + sr + Chr(13) + sb + Chr(13);
  // display in main screen
  Bloodbowl.Gatelabel.caption := gateLabelText;
  // display on pregame
  Bloodbowl.LblGate.caption := IntToStr(RedFans) + 'k Red Fans - ' +
    IntToStr(BlueFans) + 'k Blue fans';
  // display in log
  AddLog('Gate: ' + sr + ' ' + sb + ' - ' + s1);
end;

end.
