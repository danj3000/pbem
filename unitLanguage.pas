unit unitLanguage;

interface

function TranslateSkillToLanguage(skill: string): string;
function TranslateSkillToEnglish(skill: string): string;
procedure LanguageInit;

implementation

uses SysUtils, Windows, unitWelcome, unitDodgeRoll, unitGFI;

const MAXNUMSKILLS=500;
      MAXARRAYNUM=50;

var ff: TextFile;
    s, LanguageUsed: string;
    skilllist: array [1..MAXNUMSKILLS, 1..2] of string;
    teamlist,playerlist: array [1..MAXARRAYNUM, 1..2] of string;
    numskills, numteams, numplayers: integer;

function TranslateSkillToLanguage(skill: string): string;
var f: integer;
begin
  f := 1;
  while (f <= numskills)
          and (Uppercase(skilllist[f,1]) <> Uppercase(skill)) do f := f + 1;
  if f <= numskills then TranslateSkillToLanguage := skilllist[f,2]
                    else TranslateSkillToLanguage := '?' + skill + '?';
end;

function TranslateSkillToEnglish(skill: string): string;
var f: integer;
begin
  f := 1;
  while (f <= numskills)
          and (Uppercase(skilllist[f,2]) <> Uppercase(skill)) do f := f + 1;
  if f <= numskills then TranslateSkillToEnglish := skilllist[f,1]
                    else TranslateSkillToEnglish := '?' + skill + '?';
end;

procedure GetNextLine;
begin
  ReadLn(ff, s);
  while not(eof(ff)) and (s = '') do ReadLn(ff, s);
end;

function CompareNode(t: string): boolean;
{This function compares the beginning of s to t and if so,
 it strips s of t so only the relevant text is left}
var l: integer;
begin
  l := Length(t) + 1;
  if Copy(s, 1, l) = t + '=' then begin
    CompareNode := true;
    s := Trim(Copy(s, l + 1, Length(s) - l));
  end else CompareNode := false;
end;

procedure ReadSkillList;
var p: integer;
begin
  numskills := 0;
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    p := Pos('=', s);
    if p > 0 then begin
      numskills := numskills + 1;
      skilllist[numskills, 1] := Copy(s, 1, p-1);
      skilllist[numskills, 2] := Trim(Copy(s, p+1, Length(s) - p));
    end;
    GetNextLine;
  end;
end;

procedure ReadTeamList;
var p: integer;
begin
  numteams := 0;
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    p := Pos('=', s);
    if p > 0 then begin
      numteams := numteams + 1;
      teamlist[numteams, 1] := Copy(s, 1, p-1);
      teamlist[numteams, 2] := Trim(Copy(s, p+1, Length(s) - p));
    end;
    GetNextLine;
  end;
end;

procedure ReadPlayerList;
var p: integer;
begin
  numplayers := 0;
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    p := Pos('=', s);
    if p > 0 then begin
      numplayers := numplayers + 1;
      playerlist[numplayers, 1] := Copy(s, 1, p-1);
      playerlist[numplayers, 2] := Trim(Copy(s, p+1, Length(s) - p));
    end;
    GetNextLine;
  end;
end;

function InsertSkill(skill, txt: string): string;
var p: integer;
begin
  p := Pos('???', s);
  InsertSkill := Copy(txt, 1, p-1) + TranslateSkillToLanguage(skill) +
                 Copy(txt, p+3, Length(txt))
end;

procedure StandardTexts;
begin
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    if CompareNode('RollNeeded') then begin
       frmDodgeRoll.lblRollNeeded.caption := s;
       frmGFI.lblRollNeeded.caption := s;
    end;
    if CompareNode('RerollFailed') then begin
       frmDodgeRoll.lblDodgeRerollFailed.caption := s;
    end;
    if CompareNode('MakeRoll') then begin
       frmDodgeRoll.MakeDodgeRollButton.caption := InsertSkill('Dodge', s);
       frmGFI.butGFIRoll.caption := InsertSkill('Go For It', s);
    end;
    if CompareNode('UseSkill') then begin
       frmDodgeRoll.butUseDodgeSkill.caption := InsertSkill('Dodge', s);
       frmDodgeRoll.butPro.caption := InsertSkill('Pro', s);
       frmDodgeRoll.butUseStandFirmSkill.caption := InsertSkill('Stand Firm', s);
       frmGFI.butsurefeetSkill.Caption := InsertSkill('Sure Feet', s);
       frmGFI.butPro.caption := InsertSkill('Pro', s);
    end;
    if CompareNode('UseTeamReroll') then begin
       frmDodgeRoll.butUseTeamReroll.caption := s;
       frmGFI.butTeamReroll.caption := s;
    end;
    if CompareNode('KnockOverPlayer') then begin
       frmDodgeRoll.butKnockOver.caption := s;
       frmGFI.butKnockDown.caption := s;
    end;
    GetNextLine;
  end;
end;

procedure WelcomeWindow;
begin
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    if CompareNode('WelcomeTo') then
       frmWelcome.Label1.caption := s + ' Ronald''s';
    if CompareNode('ToolName') then
       frmWelcome.Label2.Caption := s;
    if CompareNode('WhoAreYou') then
       frmWelcome.Label4.caption := s;
    if CompareNode('WhereDoYou') then
       frmWelcome.Label3.caption := s;
    if CompareNode('StartButton') then
       frmWelcome.ButStartNew.caption := s;
    if CompareNode('LoadButton') then
       frmWelcome.ButLoad.caption := s;
    GetNextLine;
  end;
end;

procedure DodgeWindow;
begin
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    if CompareNode('DodgeRoll') then
       frmDodgeRoll.caption := s;
    if CompareNode('NumberRepresents') then
       frmDodgeRoll.lblNumberReprTxt.caption := s;
    if CompareNode('ClickOnDirection') then
       frmDodgeRoll.lblDirectionTxt.Caption := s;
    if CompareNode('PlayerUses') then
       frmDodgeRoll.lblPlayerUses.caption := s;
    if CompareNode('OpponentsUse') then
       frmDodgeRoll.lblOpponentsUse.caption := s;
    if CompareNode('DodgeFailed') then
       frmDodgeRoll.lblDodgeFailed.caption := s;
    GetNextLine;
  end;
  frmDodgeRoll.StuntyCB.Caption := TranslateSkillToLanguage('Stunty');
  frmDodgeRoll.TwoHeadsCB.Caption := TranslateSkillToLanguage('Two Heads');
  frmDodgeRoll.BreakTackleCB.Caption := TranslateSkillToLanguage('Break Tackle');
  frmDodgeRoll.TitchyCB.Caption := TranslateSkillToLanguage('Titchy');
  frmDodgeRoll.lblPrehTailTxt.Caption := TranslateSkillToLanguage('Prehensile Tail');
  frmDodgeRoll.lblTentaclesTxt.Caption := TranslateSkillToLanguage('Tentacles');
  frmDodgeRoll.cbDivingTackle.Caption := TranslateSkillToLanguage('Diving Tackle');
  frmDodgeRoll.cbBigGuyAlly.Caption := TranslateSkillToLanguage('Big Guy') +
        '/' + TranslateSkillToLanguage('Ally');
end;

procedure GFIWindow;
begin
  GetNextLine;
  while not(eof(ff)) and (s[1] <> '[') do begin
    if CompareNode('BloodbowlGFI') then
       frmGFI.caption := s;
    if CompareNode('TriesToGFI') then
       frmGFI.lblTriesToTxt.caption := s;
    if CompareNode('Blizzard') then
       frmGFI.cbBlizzard.Caption := s;
    if CompareNode('SprintForPGFI') then
       frmGFI.cbSprint.caption := s;
    if CompareNode('GoForItFailed') then
       frmGFI.lblGFIFailed.caption := s;
    GetNextLine;
  end;
end;

procedure LanguageInit;
var filename2, filename: string;
begin
  filename2 := 'ini\pbembb.ini';
  filename := 'ini\bblanguage_English.ini';
  LanguageUsed := 'English';
  if FileExists(filename2) then begin
    Assign(ff, filename2);
    Reset(ff);
    while not(eof(ff)) do begin
      Readln(ff, s);
      if Copy(s, 1, 9) = 'Language=' then begin
        filename := 'ini\bblanguage_'+Copy(s, 10, Length(s)-9)+'.ini';
        LanguageUsed := Copy(s, 10, Length(s)-9);
      end;
    end;
    CloseFile(ff);
  end;
{  if FileExists(filename) and (LanguageUsed<>'English') then begin}
  if FileExists(filename) then begin
    Assign(ff, filename);
    Reset(ff);
    while not(eof(ff)) do begin
      GetNextLine;
      if s = '[Skills]' then ReadSkillList;
      if s = '[Teams]' then ReadTeamList;
      if s = '[Players]' then ReadPlayerList;
      if s = '[Standard]' then StandardTexts;
      if s = '[Welcome]' then WelcomeWindow;
      if s = '[Dodge]' then DodgeWindow;
      if s = '[GoForIt]' then GFIWindow;
    end;
    CloseFile(ff);
  end;
end;

end.
