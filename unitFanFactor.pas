unit unitFanFactor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls;

type
  TfrmFanFactor = class(TForm)
    GroupBox1: TGroupBox;
    cbTDMod: TCheckBox;
    cbEach2TD: TCheckBox;
    GroupBox2: TGroupBox;
    cbCasMod: TCheckBox;
    cbEach2Cas: TCheckBox;
    GroupBox3: TGroupBox;
    cbMinFFEach10: TCheckBox;
    GroupBox4: TGroupBox;
    rbWonMatch: TRadioButton;
    rbTiedMatch: TRadioButton;
    rbLostMatch: TRadioButton;
    GroupBox6: TGroupBox;
    cbFFPreMod: TCheckBox;
    Label1: TLabel;
    GroupBox7: TGroupBox;
    cbBigMatch: TCheckBox;
    butFFUse: TButton;
    butFFCancel: TButton;
    cbTeamFFMod: TCheckBox;
    procedure butFFCancelClick(Sender: TObject);
    procedure butFFUseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmFanFactor: TfrmFanFactor;

procedure SetFanFactorModifiers;
function FanfactorModifier(tm: integer): integer;
procedure FanFactorShow(tm: integer);
procedure PlayActionFanFactor(s: string; dir: integer);
procedure FanFactor(tm: integer);

implementation

{$R *.DFM}
uses bbunit, bbalg, unitLog, unitMarker, unitRandom, unitPlayAction,
  unitPostgameSeq, unitSettings;

var ffresult: array [0..1] of integer;
    tdmod, eachtd, casmod, eachcas, ffmod, bigmatch,
    premod, specteammod: array [0..1] of boolean;
    curFFteam: integer;

procedure SetFanFactorModifiers;
var f, g: integer;
begin
  if FVal(marker[0, MT_Score].caption) > FVal(marker[1, MT_Score].caption) then begin
    ffresult[0] := 1;
    ffresult[1] := -1;
  end else if FVal(marker[0, MT_Score].caption) = FVal(marker[1, MT_Score].caption) then begin
    ffresult[0] := 0;
    ffresult[1] := 0;
  end else begin
    ffresult[0] := -1;
    ffresult[1] := 1;
  end;
  for g := 0 to 1 do begin
    tdmod[g] := (FVal(marker[g, MT_Score].caption) >= 2);
    eachtd[g] := false;
    casmod[g] := (FVal(marker[g, MT_CasScore].caption) >= 2);
    eachcas[g] := false;
    ffmod[g] := false; // fan factor modifier if > 10
    bigmatch[g] := false;
    premod[g] := false;
    specteammod[g] := false;
  end;
  for g := 0 to 1 do
   for f := 1 to 9 do
    if (CardsData[g,f].caption = 'The Big Match')
    and (CardsData[g,f].font.color = clSilver) then begin
      bigmatch[0] := true;
      bigmatch[1] := true;
    end;
  for g := 0 to 1 do FanfactorModifier(g);
end;

function FanfactorModifier(tm: integer): integer;
var m: integer;
    s: string;
begin
  m := 0;
  m := m + ffresult[tm];
  if tdmod[tm] then begin
    if eachtd[tm] then begin
      m := m + FVal(marker[tm, MT_Score].caption) div 2;
    end else m := m + 1;
  end;
  if casmod[tm] then begin
    if eachcas[tm] then
      m := m + FVal(marker[tm, MT_CasScore].caption) div 2 else m := m + 1;
  end;

  if ffmod[tm] then m := m - (team[tm].ff) div 10;
  if bigmatch[tm] then m := m + 3;
  if specteammod[tm] then m := m + 1;
  s := IntToStr(m);
  if m >= 0 then s := '+' + s;
  if tm = 0 then
    frmPostgame.lblTotalFFModRed.caption := s
  else
    frmPostgame.lblTotalFFModBlue.caption := s;
  FanfactorModifier := m;
end;

procedure FanFactorShow(tm: integer);
begin
  frmFanFactor.rbWonMatch.checked := (ffresult[tm] = 1);
  frmFanFactor.rbTiedMatch.checked := (ffresult[tm] = 0);
  frmFanFactor.rbLostMatch.checked := (ffresult[tm] = -1);
  frmFanFactor.cbTDMod.checked := tdmod[tm];
  frmFanFactor.cbEach2TD.checked := eachtd[tm];
  frmFanFactor.cbCasMod.checked := casmod[tm];
  frmFanFactor.cbEach2Cas.checked := eachcas[tm];
  frmFanFactor.cbMinFFEach10.checked := ffmod[tm];
  frmFanFactor.cbBigMatch.checked := bigmatch[tm];
  frmFanFactor.cbFFPreMod.checked := premod[tm];
  frmFanFactor.cbTeamFFMod.checked := specteammod[tm];
  curFFteam := tm;
  frmFanFactor.ShowModal;
end;

procedure PlayActionFanFactor(s: string; dir: integer);
var s0: string;
    r, tm, h: integer;
begin
  tm := Ord(s[2]) - 48;
  if dir = 1 then begin
    r := Ord(s[3]) - 64;
    if tm = 0 then begin
      frmPostgame.ImFFDieRed.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + '.bmp');
      frmPostgame.ImFFDieRed.visible := true;
      frmPostgame.ButFFRed.enabled := false;
    end else begin
      frmPostgame.ImFFDieBlue.Picture.LoadFromFile(
                            curdir + 'images\die' + IntToStr(r) + 'b.bmp');
      frmPostgame.ImFFDieBlue.visible := true;
      frmPostgame.ButFFBlue.enabled := false;
    end;
    s0 := 'Fan factor roll for ' + ffcl[tm] + ': ' + IntToStr(r);
    if (s[12] = 'B') and ((r=1) or (r=6)) then begin
      if r = 1 then s0 := s0 + ' (always down)';
      if r = 6 then s0 := s0 + ' (always up)';
    end else begin
      if s[4] = 'B' then s0 := s0 + ' +1 (Won Match)';
      if s[4] = '@' then s0 := s0 + ' -1 (Lost Match)';
      if s[6] = 'B' then begin
        h := FVal(marker[tm, MT_Score].caption) div 2;
        if h > 0 then s0 := s0 + ' +' + IntToStr(h) + ' (' +
                   marker[tm, MT_CasScore].caption + ' touchdowns)';
      end else if s[5] = 'B' then s0 := s0 + ' +1 (2+ Touchdowns)';
      if s[8] = 'B' then begin
        h := FVal(marker[tm, MT_CasScore].caption) div 2;
        if h > 0 then s0 := s0 + ' +' + IntToStr(h) + ' (' +
                   marker[tm, MT_CasScore].caption + ' casualties)';
      end else if s[7] = 'B' then s0 := s0 + ' +1 (2+ casualties)';
      if s[9] = 'B' then s0 := s0 + ' +1 (Semi-final)';
      if s[9] = 'C' then s0 := s0 + ' +2 (Final)';
      if s[10] = 'B' then begin
        h := (team[tm].ff) div 10;
        if h > 0 then s0 := s0 + ' -' + IntToStr(h) + ' (FF ' +
             IntToStr(team[tm].ff) + ')';
      end;
      if s[11] = 'B' then s0 := s0 + ' +3 (The Big Match)';
      if s[13] = 'B' then s0 := s0 + ' +1 (Special Team)';
    end;
    if s[14] = 'U' then begin
      s0 := s0 + ' = UP!';
      if tm = 0 then frmPostgame.lblFFResultRed.caption := 'UP!'
                else frmPostgame.lblFFResultBlue.caption := 'UP!';
      team[tm].ff := team[tm].ff + 1;
    end;
    if s[14] = 'D' then begin
      s0 := s0 + ' = DOWN!';
      if tm = 0 then frmPostgame.lblFFResultRed.caption := 'DOWN!'
                else frmPostgame.lblFFResultBlue.caption := 'DOWN!';
      team[tm].ff := team[tm].ff - 1;
    end;
    if s[14] = 'N' then begin
      s0 := s0 + ' = No change';
      if tm = 0 then frmPostgame.lblFFResultRed.caption := 'No change'
                else frmPostgame.lblFFResultBlue.caption := 'No change';
    end;
    DefaultAction(s0);

  end else begin
    if tm = 0 then begin
      frmPostgame.ImFFDieRed.visible := false;
      frmPostgame.ButFFRed.enabled := true;
      frmPostgame.lblFFResultRed.caption := '';
    end else begin
      frmPostgame.ImFFDieBlue.visible := false;
      frmPostgame.ButFFBlue.enabled := true;
      frmPostgame.lblFFResultBlue.caption := '';
    end;
    BackLog;
    if s[14] = 'U' then begin
      team[tm].ff := team[tm].ff - 1;
    end else if s[14] = 'D' then begin
      team[tm].ff := team[tm].ff + 1;
    end;
  end;
end;

function BoolToInt(b: boolean): integer;
begin
  if b then BoolToInt := 1 else BoolToInt := 0;
end;

procedure FanFactor(tm: integer);
var s: string;
    r: integer;
begin
  r := Rnd(6,2) + 1;
  s := 'f' + Chr(tm + 48) + Chr(r + 64) +
       Chr(ffresult[tm] + 65) +
       Chr(BoolToInt(tdmod[tm]) + 65) +
       Chr(BoolToInt(eachtd[tm]) + 65) +
       Chr(BoolToInt(casmod[tm]) + 65) +
       Chr(BoolToInt(eachcas[tm]) + 65) +
       Chr(65) +
       Chr(BoolToInt(ffmod[tm]) + 65) +
       Chr(BoolToInt(bigmatch[tm]) + 65) +
       Chr(BoolToInt(premod[tm]) + 65) +
       Chr(BooltoInt(specteammod[tm]) + 65);

  if (premod[tm] and (r = 1)) or (r + FanFactorModifier(tm) <= 1) then begin
    if team[tm].ff <> 1 then s := s + 'D';
  end else
  if (premod[tm] and (r = 6)) or (r + FanFactorModifier(tm) >= 6) then begin
    s := s + 'U';
  end else begin
    s := s + 'N';
  end;
  if CanWriteToLog then begin
    PlayActionFanFactor(s, 1);
    LogWrite(s);
  end;
end;

procedure TfrmFanFactor.butFFCancelClick(Sender: TObject);
begin
  Hide;
  ModalResult := 1;
end;

procedure TfrmFanFactor.butFFUseClick(Sender: TObject);
begin
  if rbWonMatch.checked then ffresult[curFFteam] := 1;
  if rbTiedMatch.checked then ffresult[curFFteam] := 0;
  if rbLostMatch.checked then ffresult[curFFteam] := -1;
  tdmod[curFFteam] := cbTDMod.checked;
  eachtd[curFFteam] := cbEach2TD.checked;
  casmod[curFFteam] := cbCasMod.checked;
  eachcas[curFFteam] := cbEach2Cas.checked;
  ffmod[curFFteam] := cbMinFFEach10.checked;
  bigmatch[curFFteam] := cbBigMatch.checked;
  premod[curFFteam] := cbFFPreMod.checked;
  specteammod[curFFteam] := cbTeamFFMod.checked;
  FanFactorModifier(curFFteam);
  frmFanFactor.Hide;
  ModalResult := 1;
end;



end.
