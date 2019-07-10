unit weather;

interface

type

TWeather = class(TObject)
private
  { private declarations }
protected
  { protected declarations }
public
  { public declarations }
  // todo: make these instance methods as needed
  class procedure DoWeatherRoll;
  class procedure DoWeather(r1, r2: integer);
  class procedure DoWeatherPick(r3: integer);

  class procedure PlayActionWeatherRoll(s: string; dir: integer);
published
  { published declarations }
end;

implementation

uses unitLog, unitRandom, bbunit, bbalg, unitPlayAction;

class procedure TWeather.DoWeatherRoll;
var r1, r2: integer;
begin
  if CanWriteToLog then
  begin
    r1 := Rnd(6,6) + 1;
    r2 := Rnd(6,6) + 1;
    DoWeather(r1, r2);
  end;
end;

class procedure TWeather.DoWeather(r1, r2: integer);
var weatherString: string;
begin
    weatherString := WeatherTable[r1 + r2];
    AddLog('(' + IntToStr(r1) + ',' + IntToStr(r2) + ') = ' + IntToStr(r1 + r2) + ' : ' + weatherString);
    LogWrite('DW' + Chr(r1 + 48) + Chr(r2 + 48));

    Bloodbowl.SetWeather(weatherString);
end;

class procedure TWeather.DoWeatherPick(r3: integer);
var r1, r2: integer;
begin
  if CanWriteToLog then begin
    // make up dice rolls
    if r3 >= 7 then
      r1 := 6
    else
      r1 := 1;
    r2 := r3 - r1;

    // do it
    DoWeather(r1, r2);
  end;
end;

class procedure TWeather.PlayActionWeatherRoll(s: string; dir: integer);
var
  newWeatherCaption, newWeatherCaption2: string;
  f, g, p: integer;
  fullWeatherString: string;
  weather: TWeatherState;
begin
  if dir = DIR_FORWARD then
  begin
    f := Ord(s[3]) - 48;
    g := Ord(s[4]) - 48;
    fullWeatherString := WeatherTable[f + g];
    DefaultAction('(' + IntToStr(f) + ',' + IntToStr(g) + ') = ' + IntToStr(f + g) + ' : ' + fullWeatherString);

    p := Pos('.', fullWeatherString);
    newWeatherCaption := Copy(fullWeatherString, 1, p) + Chr(13) + Copy(fullWeatherString, p + 1, 100);
    newWeatherCaption2 := Copy(fullWeatherString, 1, p - 1);

    Bloodbowl.WeatherLabel.caption := newWeatherCaption;
    Bloodbowl.LblWeather.caption := newWeatherCaption2;

    if Bloodbowl.PregamePanel.visible then
    begin
      Bloodbowl.ButWeather.enabled := false;
      Bloodbowl.ButGate.enabled := true;
      Bloodbowl.RGGate.visible := true;
    end;
  end
  else
  begin
    BackLog;
    if Bloodbowl.PregamePanel.visible then
    begin
      Bloodbowl.WeatherLabel.caption := '';
      Bloodbowl.LblWeather.caption := '';
      Bloodbowl.ButWeather.enabled := true;
      Bloodbowl.ButGate.enabled := false;
      Bloodbowl.RGGate.visible := false;
    end;
  end;
  Bloodbowl.SetWeather(fullWeatherString);
end;

end.
