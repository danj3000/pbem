unit unitMarker;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

const MT_Score = 1;
const MT_CasScore = 2;
const MT_Reroll = 3;
const MT_Leader = 4;

type
  TmodMarker = class(TDataModule)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

type TMarker = class(TLabel)
public
  team0, value, MarkerType: integer;
  used: boolean;

  constructor New(owner: TWinControl; tm, mt: integer);
  procedure MarkerMouseUp(Sender: TObject;
                    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  procedure SetValue(newvalue: integer);
end;

var
  modMarker: TmodMarker;

function TranslateActionMarkerChange(s: string): string;
procedure PlayActionMarkerChange(s: string; dir: integer);

implementation

uses bbunit, bbalg, unitLog, unitPlayAction;

{$R *.DFM}

constructor TMarker.New(owner: TWinControl; tm, mt: integer);
begin
  inherited Create(owner);

  {set label properties}
  autosize := false;
  case mt of
    MT_Score: begin
                if tm = 0 then left := Bloodbowl.ScoreLabel.left - 22
                          else left := Bloodbowl.ScoreLabel.left +
                                       Bloodbowl.ScoreLabel.width + 2;
                top := Bloodbowl.ScoreLabel.top;
                height := 19;
                width := 19;
                font.size := 12;
                hint := 'Click or right-click to modify score';
              end;
    MT_CasScore: begin
                if tm = 0 then left := Bloodbowl.ScoreLabel.left - 39
                          else left := Bloodbowl.ScoreLabel.left +
                                       Bloodbowl.ScoreLabel.width + 22;
                top := Bloodbowl.ScoreLabel.top;
                height := 16;
                width := 16;
                font.size := 10;
                hint := 'Click or right-click to modify Casualties scored';
              end;
    MT_Reroll: begin
                if tm = 0 then left := Bloodbowl.RerollLabel.left - 22
                          else left := Bloodbowl.RerollLabel.left +
                                       Bloodbowl.RerollLabel.width + 2;
                top := Bloodbowl.RerollLabel.top;
                height := 19;
                width := 19;
                font.size := 12;
                hint := 'Click or right-click to modify rerolls';
              end;
    MT_Leader: begin
                if tm = 0 then left := Bloodbowl.RerollLabel.left - 39
                          else left := Bloodbowl.RerollLabel.left +
                                       Bloodbowl.RerollLabel.width + 22;
                top := Bloodbowl.RerollLabel.top;
                height := 16;
                width := 16;
                font.size := 10;
                hint := 'Click or right-click to modify Leader reroll';
              end;
  end;
  caption := IntToStr(0);
  alignment := taCenter;
  color := colorarray[tm, 0, 0];
  font.color := clWhite;
  showhint := true;
  parent := owner;
  OnMouseUp := MarkerMouseUp;

  {other properties}
  team0 := tm;
  value := 0;
  MarkerType := mt;
  used := false;
end;

procedure TMarker.MarkerMouseUp(Sender: TObject;
                    Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var f, m: integer;
    s: string;
    b: boolean;
begin
  if Button = mbLeft then m := 1 else m := -1;
  if value + m >= 0 then begin
    b := true;
    if (MarkerType = MT_Leader) and (m = -1) then begin
      b := false;
      for f := 1 to team[team0].numplayers do begin
        if (allPlayers[team0, f].status >= 1) and (allPlayers[team0, f].status <= 4)
        and (allPlayers[team0, f].HasSkill('Leader')) then b := true;
      end;
      if not(b) then
        ShowMessage('You can''t use the Leader reroll at this moment, ' +
                    'because no player with this skill is standing or ' +
                    'prone/stunned on the field!');
    end;
    if b and CanWriteToLog then begin
      s := '-';
      if m = -1 then begin
        if MarkerType = MT_Reroll then
         if font.size = 12 then s := 's';
        if MarkerType = MT_Leader then
         if font.size = 10 then s := 's';
      end;
      if used then s := s + '-' else s := s + 'u';
      s := 'm' + Chr(MarkerType + 48) + Chr(team0 + 48) +
           Chr(value + 48) + Chr(value + m + 48) + s;
      LogWrite(s);
      PlayActionMarkerChange(s, 1);
    end;
  end;
end;

procedure TMarker.SetValue(newvalue: integer);
begin
  value := newvalue;
  caption := IntToStr(value);
end;

function TranslateActionMarkerChange(s: string): string;
var team, v, mt: integer;
    s0: string;
begin
  mt := Ord(s[2]) - 48;
  team := Ord(s[3]) - 48;
  v := Ord(s[5]) - 48;
  case mt of
    MT_Score:    s0 := 'Score';
    MT_CasScore: s0 := 'Casualties scored';
    MT_Reroll:   s0 := 'Rerolls';
    MT_Leader:   s0 := 'Leader reroll';
  end;
  TranslateActionMarkerChange :=
        s0 + ' change for ' + ffcl[team] + ': ' + IntToStr(v);
end;

procedure PlayActionMarkerChange(s: string; dir: integer);
var mt, tm, v: integer;
    c: TColor;
begin
  mt := Ord(s[2]) - 48;
  tm := Ord(s[3]) - 48;
  if dir = 1 then begin
    v := Ord(s[5]) - 48;
    AddLog(TranslateActionMarkerChange(s));
    marker[tm, mt].SetValue(v);
    marker[tm, mt].used := true;
    if WaitLength > 0 then begin
      c := marker[tm, mt].color;
      marker[tm, mt].color := clPurple;
      marker[tm, mt].Refresh;
      Wait;
      marker[tm, mt].color := c;
      marker[tm, mt].Refresh;
    end;
    if s[6] = 's' then begin
      marker[tm, MT_Reroll].font.size := 10;
      marker[tm, MT_Leader].font.size := 8;
    end;
    if (mt = MT_Leader) and (s[5] < s[4])
     then team[tm].UsedLeaderReroll := true;
  end else begin
    v := Ord(s[4]) - 48;
    marker[tm, mt].SetValue(v);
    if s[6] = 's' then begin
      marker[tm, MT_Reroll].font.size := 12;
      marker[tm, MT_Leader].font.size := 10;
    end;
    if s[7] = 'u' then marker[tm, mt].used := false;
    if (mt = MT_Leader) and (s[5] < s[4])
     then team[tm].UsedLeaderReroll := false;
    BackLog;
  end;
end;

end.
