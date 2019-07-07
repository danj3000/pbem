unit Weather;

interface

type

TWeather = class
private
  textWeather: string;
public
  constructor Create(TextWeather: string);
  function IsVerySunny(): boolean;
end;

implementation

uses bbunit;

constructor TWeather.Create(TextWeather: string);
begin
  textWeather := TextWeather;
end;

function TWeather.IsVerySunny;
begin
  Result := textWeather = 'VERY SUNNY';
end;

end.
