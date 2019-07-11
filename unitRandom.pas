unit unitRandom;
interface


type
  TDiceResult = record
    Dice : array of integer;
    function Total(): integer;
    constructor Create(count: integer);
  end;

procedure UserRandomize;
function Rnd(r: word; rtype: integer): word;
function RollD6(): integer;
function Roll2D6(): TDiceResult;

implementation

uses Windows, bbalg, bbunit, unitSettings, unitMachineID;

constructor TDiceResult.Create(count: integer);
begin
  SetLength(Dice, count);
end;

function TDiceResult.Total(): integer;
var
  i, total: Integer;
begin
  total := 0;
  for i in Dice do
    total := total + i;

  Result := total;
end;

const R1m = 2147483647;
const R1q = 127773;
const R1a = 16807;
const R1r = 2836;

var seed: longword;
    RSeed: integer;

procedure UserRandomize;
var ColLoc, SpcLoc, PMLoc, DTSepLoc, DTSepLoc2, PMmod, k: integer;
    FDT1, FDT2, FDTmo, FDTdy, FDThr, FDTmn, FDTse: string;
begin
  {8/7/2002 8:59:34 AM
   07-30-2002 9:20:20 PM
   8-20-02 10:19:59 AM
   31-07-2002 20:30:26
   14.08.2002 16:41:50
   31/07/02 18:40:05   }
  RSeed := 0;
  PMmod := 1;
  if LDFILEDT<>'No Date' then begin
    SpcLoc := Pos(' ',LDFILEDT);
    PMLoc := Pos('PM', LDFILEDT);
    if PMLoc<>0 then PMLoc := 13;
    ColLoc := Pos(':',LDFILEDT);
    if Pos('/',LDFILEDT)<>0 then begin
      DTSepLoc := Pos('/',LDFILEDT);
      FDT1 := Copy(LDFILEDT,(DTSepLoc+1),(SpcLoc-(DTSepLoc+1)));
      DTSepLoc2 := Pos('/',FDT1);
      FDTmo := Copy(LDFILEDT, 1, (DTSepLoc-1));
      FDTdy := Copy(FDT1, 1, (DTSepLoc2-1));
    end else if Pos('-',LDFILEDT)<>0 then begin
      DTSepLoc := Pos('-',LDFILEDT);
      FDT1 := Copy(LDFILEDT,(DTSepLoc+1),(SpcLoc-(DTSepLoc+1)));
      DTSepLoc2 := Pos('-',FDT1);
      FDTmo := Copy(LDFILEDT, 1, (DTSepLoc-1));
      FDTdy := Copy(FDT1, 1, (DTSepLoc2-1));
    end else if Pos('.',LDFILEDT)<>0 then begin
      DTSepLoc := Pos('.',LDFILEDT);
      FDT1 := Copy(LDFILEDT,(DTSepLoc+1),(SpcLoc-(DTSepLoc+1)));
      DTSepLoc2 := Pos('.',FDT1);
      FDTmo := Copy(LDFILEDT, 1, (DTSepLoc-1));
      FDTdy := Copy(FDT1, 1, (DTSepLoc2-1));
    end;
    FDThr := Copy(LDFILEDT, (SpcLoc+1), (ColLoc-(SpcLoc+1)));
    FDT2 := Copy(LDFILEDT,(ColLoc+1),((Length(LDFILEDT))-ColLoc));
    DTSepLoc := Pos(':',FDT2);
    FDTmn := Copy(FDT2, 1, (DTSepLoc-1));
    FDTse := Copy(FDT2, (DTSepLoc+1), 2);
    RSeed := (FVal(FDTmo)+1) * (FVal(FDTmn)+1) * (FVal(FDTse)+1) *
       (FVal(FDTdy)+1) * (FVal(FDThr)+PMmod);
  end;
  if RSeed<>0 then RandSeed := RSeed + GetMachineID
              else Randomize;
  seed := Abs(RandSeed);
  if RSeed<>0 then begin
    for k := 0 to 100 do begin
      RandRoll5[k] := Rnd(6,6);
      RandRoll4[k] := Rnd(6,6);
      RandRoll3[k] := Rnd(6,6);
      RandRoll2[k] := Rnd(6,6);
      RandRoll1[k] := Rnd(6,6);
    end;
    FixedRand := true;
  end;
end;

function Rnd(r: word; rtype:integer): word;
var hi, lo, test, l, m: longword;
    i, j, k: word;
begin
  if (rtype = 1) and (RandCnt1>100) then rtype := 6;
  if (rtype = 2) and (RandCnt2>100) then rtype := 6;
  if (rtype = 3) and (RandCnt3>100) then rtype := 6;
  if (rtype = 4) and (RandCnt4>100) then rtype := 6;
  if (rtype = 5) and (RandCnt5>100) then rtype := 6;
  if not(FixedRand) then rtype := 6;
  if r<>6 then rtype := 6;
  case rtype of
    1: begin
         i := RandRoll1[RandCnt1];
         if FixedRand then RandCnt1 := RandCnt1 + 1;
       end;
    2: begin
         i := RandRoll2[RandCnt2];
         if FixedRand then RandCnt2 := RandCnt2 + 1;
       end;
    3: begin
         i := RandRoll3[RandCnt3];
         if FixedRand then RandCnt3 := RandCnt3 + 1;
       end;
    4: begin
         i := RandRoll4[RandCnt4];
         if FixedRand then RandCnt4 := RandCnt4 + 1;
       end;
    5: begin
         i := RandRoll5[RandCnt5];
         if FixedRand then RandCnt5 := RandCnt5 + 1;
       end;
    6: begin
         case frmSettings.rgRandomAlgorithm.ItemIndex of
           1: begin
                hi := seed div R1q;
                lo := seed mod R1q;
                test := R1a * lo + R1r * hi;
                if test > 0 then seed := test else seed := test + R1m;
                i := seed mod r;
              end;
           2: begin
                m := 0;
                j := Random(100) + 10;
                for k := 1 to j do begin
                  l := Random(R1q);
                  m := m + Random(l);
                end;
                i := m mod r;
              end;
           else begin
                i := Random(r);
              end;
           end;
       end;
  end;
  Rnd := i;
end;

function RollD6(): integer;
begin
  Result := Rnd(6,6);
end;

function Roll2D6(): TDiceResult;
var output: TDiceResult;
begin
  output := TDiceResult.Create(2);
  output.Dice[0] := Rnd(6,6) + 1;
  output.Dice[1] := Rnd(6,6) + 1;

  Result := output;
end;

end.
