unit unitCheckFile;

interface

var CoachNames: array of string;

procedure ReadCoach;
procedure AddCoachName(strName: string);

implementation

uses SysUtils;

procedure ReadCoach;
var s: string;
    cf: Text;
begin
  Finalize(CoachNames);
  Assign(cf, GetCurrentDir + '\ini\bbcheck.ini');
  Reset(cf);
  ReadLn(cf, s);
  while s <> '[Coach]' do ReadLn(cf, s);
  ReadLn(cf, s);
  while not(EOF(cf)) and (s <> '') do begin
    SetLength(CoachNames, Length(CoachNames) + 1);
    CoachNames[High(CoachNames)] := s;
    ReadLn(cf, s);
  end;
  Close(cf);
end;

procedure AddCoachName(strName: string);
var co, cn: Text;
    s: string;
begin
  RenameFile(GetCurrentDir + '\ini\bbcheck.ini',
             GetCurrentDir + '\ini\bbchecko.ini');
  Assign(co, GetCurrentDir + '\ini\bbchecko.ini');
  Assign(cn, GetCurrentDir + '\ini\bbcheck.ini');
  Reset(co);
  Rewrite(cn);
  ReadLn(co, s);
  while s <> '[Coach]' do begin
    WriteLn(cn, s);
    ReadLn(co, s);
  end;
  Writeln(cn, s);
  WriteLn(cn, Trim(strName));
  while not(EOF(co)) do begin
    ReadLn(co, s);
    WriteLn(cn, s);
  end;
  Close(co);
  Close(cn);
  DeleteFile(GetCurrentDir + '\ini\bbchecko.ini');
end;

end.
