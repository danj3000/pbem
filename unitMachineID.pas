unit unitMachineID;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, winsock,
  StdCtrls;

function GetMachineID: integer;

type
  TMachID = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  MachID: TMachID;
  IPAddress, SerialNumber: String;

implementation

uses bbunit;

procedure GetIPList(const List: TStrings);
var
  WSAData: TWSAData;
  HostName: PAnsiChar;
  HostInfo: PHostEnt;
  InAddr: ^PInAddr;
begin
  List.Clear;
  if WSAStartup($0101, WSAData) = 0 then
  try
    if gethostname(HostName, SizeOf(HostName)) = 0 then
    begin
      HostInfo := gethostbyname(HostName);
      if HostInfo <> nil then
      begin
        InAddr := Pointer(HostInfo^.h_addr_list);
        if (InAddr <> nil) then
          while InAddr^ <> nil do
          begin
            List.Add(inet_ntoa(InAddr^^));
            Inc(InAddr);
          end;
      end;
    end;
  finally
    WSACleanup;
  end;
end;

{$R *.DFM}

procedure SerialID;
var
 VolumeSerialNumber: DWORD;
 MaximumComponentLength: DWORD;
 FileSystemFlags: DWORD;
begin
  GetVolumeInformation('C:\',
                      nil,
                      0,
                      @VolumeSerialNumber,
                      MaximumComponentLength,
                      FileSystemFlags,
                      nil,
                      0);
  SerialNumber := IntToHex(HiWord(VolumeSerialNumber), 4) +
                 '-' +
                 IntToHex(LoWord(VolumeSerialNumber), 4);
end;


function GetMachineID: integer;
var
  StringLoop, TestValue, MachineID: integer;
  TestString, TestItem: string;
begin
{  GetIpList (MachID.Memo1.Lines);
  IPAddress := MachID.Memo1.Lines[0];
  TestString := IPAddress;}
  MachineID := 1000;
  SerialNumber := '';
  SerialID;
  CurrentComputer := SerialNumber;
{  if Length(IPAddress) > 6 then begin
    for StringLoop := 1 to 4 do begin
      DecPos := Pos('.',TestString);
      if DecPos=0 then DecPos := (Length(TestString))+1;
      TestItem := Copy(TestString,1,(DecPos-1));
      Val(TestItem, TestValue, Code);
      MachineID := MachineID + (TestValue * StringLoop);
      TestString := Copy(TestString,(DecPos+1),(Length(TestString)-DecPos));
    end;
  end;}
  TestString := SerialNumber;
  if Length(TestString) > 1 then begin
    for StringLoop := 1 to Length(TestString) do begin
      TestItem := Copy(TestString,StringLoop,1);
      TestValue := Ord(TestItem[1]);
      MachineID := MachineID + (TestValue * StringLoop);
    end;
  end;
  GetMachineID := MachineID;
end;



end.
