unit logPlayback;

interface
procedure PlayOne(w: integer);
procedure PlayOneBack;

implementation
uses unitLog, unitPlayAction, bbalg, unitField, unitCards, unitPlayer, unitBall, unitPreGame, weather,
 unitFanFactor, gate, unitPostGameSeq, unitTeam, unitMarker, unitTurnChange, unitExtern, unitAddPlayer,
 unitRoster, unitSkillRoll, apothecary;

function GetNextInLog: string;
var s: string;
begin
  s := LogRead;
  if s = '' then
    Result := ' '
  else
    GetNextInLog := s;
end;

function GetPrevInLog: string;
var s: string;
begin
  s := '';
  while ((s = '') or (s = '+')) and not(BOGameLog) do s := LogReadBack;
  GetPrevInLog := s;
end;

procedure PlayOne(w: integer);
var s: string;
    t: char;
    lp: longint;
    done: boolean;
begin
  WaitLength := w;
  done := EOGameLog;
  if not(done) then
    s := GetNextInLog;
  while not(done) do begin
    done := true;
    if s[1] = ')' then begin
      done := false;
      s := Copy(s, 2, Length(s) - 1);
    end;
    t := s[1];
    case t of
      Chr(252): PlayActionNote(s, 1);
      Chr(253): PlayActionComment(s, 1, 0);
      Chr(254): PlayActionComment(s, 1, 1);
      Chr(255): PlayActionComment(s, 1, 2);
      '+', '/', '=': if CheckFileOpen then PlayActionCheat(s);
      '.': PlayActionNumOnField(s, 1);
      ';': PlayActionMakeCurrent(s, 1);
      ',': PlayActionUnCur(s, 1);
      '!': PlayActionRollBlockDice(s, 1, 1);
      '@': PlayActionRollBlockDice(s, 1, 2);
      '#': PlayActionRollBlockDice(s, 1, 3);
      '^': PlayActionFoulRoll(s, DIR_FORWARD);
      ']': PlayActionAddCard(s, 1, false);
      '>': PlayActionAddCard(s, 1, true);
      '1': PlayActionRoll1Die(s, 1);
      '2': PlayActionRoll2Dice(s, 1);
      '8': PlayActionRollScatter(s, 1);
      'A': PlayActionMoveToReserve(s, 1);
      'a': TApothecary.PlayActionUseApo(s, 1);
      'B': PlayActionPlaceBall(s, 1);
      'b': PlayActionBlockMove(s, 1);
      'C': PlayActionDrawCards(s, 1, false);
      'c': PlayActionPlayCard(s, 1);
      'Ç': PlayActionDrawCards(s, 1, true);
      'D': begin
            case s[2] of
             'W': TWeather.PlayActionWeatherRoll(s, 1);
             'K': PlayActionKickOff(s, 1);
             'G': TGate.PlayActionGate(s, 1);
             '0': PlayActionMVP(s, 1);
             '1': PlayActionMVP(s, 1);
             'C': PlayActionCardsRoll(s, 1);
             'T': PlayActionToss(s, 1);
            end;
          end;
      'E': PlayActionSetIGMEOY(s, 1);
      'e': PlayActionBombPlayer(s, 1);
      'F': PlayActionFieldPlayer(s, 1);
      'f': PlayActionFanFactor(s, 1);
      'G': PlayActionStartPostGame(s, 1);
      'g': PlayActionColorChange(s, 1);
      'H': PlayActionInducements(s, 1);
      'h': PlayActionHideBall(s, 1);
      'I': PlayActionComputerID(s, 1);
      'i': PlayActionThrowIn(s, 1);
      'J': PlayActionCoachRef(s, 1);
      'j': PlayActionRemoveACCH(s, 1);
      'K': PlayActionPrepareForKickoff(s, 1);
      'k': PlayActionUseSkill(s, 1);
      'L': PlayActionLoadTeam(s, 1);
      'l': PlayActionLuck(s, 1);
      'M': PlayActionPlayerMove(s, 1);
      'm': PlayActionMarkerChange(s, 1);
      'N': begin
             case s[2] of
               'R', 'a', 'C', 'A', 'W', 'X', 'Z': PlayActionBuy(s, 1);
             else
               PlayActionAddPlayer(s, 1);
             end;
           end;
      'P': PlayActionSetStatus(s, 1);
      'p': PlayActionSPP(s, 1);
      'Q': begin
             case s[2] of
               'F': PlayActionSideStep(s, 1);
               'P': PlayActionPGFI(s, 1);
               'S': PlayActionDeStun(s, 1);
             end;
           end;
      'q': PlayActionReverseSPP(s, 1);
      'R': PlayActionRetire(s, 1);
      'r': PlayActionMoveToReserve(s, 1);
      '®': PlayActionRiot(s, 1);
      'S': PlayActionTeamStatChange(s, 1);
      's': PlayActionSkillRoll(s, 1);
      'T': PlayActionTurn(s, 1);
      't': PlayActionStartHalf(s, 1);
      'U': PlayActionToggleTackleZone(s, 1);
      'u': PlayActionPlayerStatChange(s, 1);
      'V': PlayActionPlaybook(s, 1);
      'W': PlayActionUseWiz(s, 1);
      'w': if s[2] = '0' then PlayActionMatchWinnings(s, 1)
                         else PlayActionMatchWinningsMod(s, 1);
      'X': PlayActionResetMove(s, 1);
      'x': PlayActionEndOfMove(s, 1);
      'Y': PlayActionRandomPlayer(s, 1);
      'Z': PlayActionArmourRoll(s, 1);
      'z': PlayActionInjuryRoll(s, 1);
    end;
    lp := GetCurrentLogPos;
    if not(EOGameLog) then begin
      s := GetNextInLog;
      if s[1] = '(' then begin
        s := Copy(s, 2, length(s) - 1);
        done := false;
      end else if done then GoToGameLog(lp);
    end else done := true;
  end;
end;

procedure PlayOneBack;
var s: string;
    t: char;
    done: boolean;
begin
  s := GetPrevInLog;
  done := (s = '');
  while not(done) do begin
    if s[1] = ')' then s[1] := '(';
    if s[1] = '(' then s := Copy(s, 2, length(s) - 1) else done := true;
    t := s[1];
    case t of
      Chr(252): PlayActionNote(s, -1);
      Chr(253): PlayActionComment(s, -1, 0);
      Chr(254): PlayActionComment(s, -1, 1);
      Chr(255): PlayActionComment(s, -1, 2);
      '.': PlayActionNumOnField(s, -1);
      ';': PlayActionMakeCurrent(s, -1);
      ',': PlayActionUnCur(s, -1);
      '!': PlayActionRollBlockDice(s, -1, 1);
      '@': PlayActionRollBlockDice(s, -1, 2);
      '#': PlayActionRollBlockDice(s, -1, 3);
      '^': PlayActionFoulRoll(s, -1);
      ']': PlayActionAddCard(s, -1, false);
      '>': PlayActionAddCard(s, -1, true);
      '1': PlayActionRoll1Die(s, -1);
      '2': PlayActionRoll2Dice(s, -1);
      '8': PlayActionRollScatter(s, -1);
      'A': PlayActionMoveToReserve(s, -1);
      'a': TApothecary.PlayActionUseApo(s, -1);
      'B': PlayActionPlaceBall(s, -1);
      'b': PlayActionBlockMove(s, -1);
      'C': PlayActionDrawCards(s, -1, false);
      'c': PlayActionPlayCard(s, -1);
      'Ç': PlayActionDrawCards(s, -1, true);
      'D': begin
            case s[2] of
             'W': TWeather.PlayActionWeatherRoll(s, -1);
             'K': PlayActionKickOff(s, -1);
             'G': TGate.PlayActionGate(s, -1);
             '0': PlayActionMVP(s, -1);
             '1': PlayActionMVP(s, -1);
             'C': PlayActionCardsRoll(s, -1);
             'T': PlayActionToss(s, -1);
            end;
           end;
      'E': PlayActionSetIGMEOY(s, -1);
      'e': PlayActionBombPlayer(s, -1);
      'F': PlayActionFieldPlayer(s, -1);
      'f': PlayActionFanFactor(s, -1);
      'G': PlayActionStartPostGame(s, -1);
      'g': PlayActionColorChange(s, -1);
      'H': PlayActionInducements(s, -1);
      'h': PlayActionHideBall(s, -1);
      'I': PlayActionComputerID(s, -1);
      'i': PlayActionThrowIn(s, -1);
      'J': PlayActionCoachRef(s, -1);
      'j': PlayActionRemoveACCH(s, -1);
      'K': PlayActionPrepareForKickoff(s, -1);
      'k': PlayActionUseSkill(s, -1);
      'L': PlayActionLoadTeam(s, -1);
      'l': PlayActionLuck(s, -1);
      'M': PlayActionPlayerMove(s, -1);
      'm': PlayActionMarkerChange(s, -1);
      'N': begin
             case s[2] of
               'R', 'a', 'C', 'A', 'W', 'X', 'Z': PlayActionBuy(s, -1);
             else
               PlayActionAddPlayer(s, -1);
             end;
           end;
      'P': PlayActionSetStatus(s, -1);
      'p': PlayActionSPP(s, -1);
      'Q': begin
             case s[2] of
               'F': PlayActionSideStep(s, -1);
               'P': PlayActionPGFI(s, -1);
               'S': PlayActionDeStun(s, -1);
             end;
           end;
      'q': PlayActionReverseSPP(s, -1);
      'R': PlayActionRetire(s, -1);
      'r': PlayActionMoveToReserve(s, -1);
      '®': PlayActionRiot(s, -1);
      'S': PlayActionTeamStatChange(s, -1);
      's': PlayActionSkillRoll(s, -1);
      'T': PlayActionTurn(s, -1);
      't': PlayActionStartHalf(s, -1);
      'U': PlayActionToggleTackleZone(s, -1);
      'u': PlayActionPlayerStatChange(s, -1);
      'V': PlayActionPlaybook(s, -1);
      'W': PlayActionUseWiz(s, -1);
      'w': if s[2] = '0' then PlayActionMatchWinnings(s, -1)
                         else PlayActionMatchWinningsMod(s, -1);
      'X': PlayActionResetMove(s, -1);
      'x': PlayActionEndOfMove(s, -1);
      'Y': PlayActionRandomPlayer(s, -1);
      'Z': PlayActionArmourRoll(s, -1);
      'z': PlayActionInjuryRoll(s, -1);
    end;
    if not(done) then begin
      s := GetPrevInLog;
    end else begin
      s := GetPreviousGameLog;
      if s[1] = ')' then begin
        s := GetPrevInLog;
        done := false;
        s := Copy(s, 2, Length(s) - 1);
      end;
    end;
  end;
end;

end.
