unit apothecary;

interface

uses unitPlayer;

type
TApothecary = class(TObject)
private
  { private declarations }
protected
  { protected declarations }
public
  { public declarations }
  class procedure DoUseApo(thePlayer: TPlayer);
  class procedure PlayActionUseApo(s: string; dir: integer);

published
  { published declarations }
end;

implementation

uses unitPlayAction, bbunit, bbalg, unitLog;

class procedure TApothecary.DoUseApo(thePlayer: TPlayer);
begin
  // check here for race limitations (not undead)

  LogWrite('a' + Chr(ActionTeam + 48));
  AddLog(ffcl[ActionTeam] + ' uses the Apothecary');

  // update display of the apo button
  apo[ActionTeam].color := colorarray[ActionTeam, 4, 0];
  apo[ActionTeam].font.color := colorarray[ActionTeam, 4, 1];

  //todo: fix this - don't use screen controls - do it in code then update the screen
  Bloodbowl.OneD6ButtonClick(Bloodbowl.OneD6Button);
  if lastroll < 4 then
  begin
    Bloodbowl.comment.Text := 'Apothecary FAILS!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end
  else
  begin
    thePlayer.SetStatus(TPlayerStatus.Reserve);
    Bloodbowl.comment.Text := 'Apothecary heals the player!';
    Bloodbowl.EnterButtonClick(Bloodbowl.EnterButton);
  end;

end;

class procedure TApothecary.PlayActionUseApo(s: string; dir: integer);
var g: integer;
begin
  g := Ord(s[2]) - 48;
  if dir = DIR_FORWARD then begin
    begin
      apo[g].color := colorarray[g, 4, 0];
      apo[g].font.color := colorarray[g, 4, 1];
      DefaultAction(ffcl[g] + ' uses the Apothecary');
      // further changes handled in other actions?
    end ;
  end else begin
    BackLog;
    begin
      apo[g].color := colorarray[g, 0, 0];
      apo[g].font.color := colorarray[g, 0, 1];
    end
  end;
end;

end.
