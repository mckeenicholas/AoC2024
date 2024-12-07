program P2;

uses
  SysUtils, Math;

type
  IntArray = array[1..12] of Integer;

var
  inputFile: Text;
  line: string;
  target: Int64;
  values: string;
  equation: IntArray;
  nVals: Integer;
  total: Int64;

procedure SplitLine(const line: string; var target: Int64; var values: string);
var
  colonPos: Integer;
begin
  colonPos := Pos(':', line);
  if colonPos > 0 then
  begin
    target := StrToInt64(Trim(Copy(line, 1, colonPos - 1)));
    values := Trim(Copy(line, colonPos + 1, Length(line) - colonPos));
  end
  else
  begin
    target := 0;
    values := '';
  end;
end;

procedure ParseValues(const values: string; var equation: IntArray; var nVals: Integer);
var
  start, len, eqIdx: Integer;
  value: string;
begin
  start := 1;
  len := Length(values);
  eqIdx := 0;

  while start <= len do
  begin
    value := '';
    while (start <= len) and (values[start] <> ' ') do
    begin
      value := value + values[start];
      Inc(start);
    end;

    if value <> '' then
    begin
      Inc(eqIdx);
      equation[eqIdx] := StrToInt(value);
    end;

    Inc(start);
  end;

  nVals := eqIdx;
end;

function CalculateSequence(target: Int64; acc: Int64; const equation: IntArray; idx, len: Integer): Boolean;
var
  conc: Int64;
begin
  if idx > len then
    Exit(acc = target);

  if acc > target then
    Exit(False);

  conc := acc * Trunc(Power(10, Floor(Log10(equation[idx]) + 1))) + equation[idx];

  if CalculateSequence(target, acc + equation[idx], equation, idx + 1, len) or
     CalculateSequence(target, acc * equation[idx], equation, idx + 1, len) or 
     CalculateSequence(target, conc, equation, idx + 1, len) then
    Exit(True);

  Exit(False);
end;

begin
  Assign(inputFile, 'input.txt');
  Reset(inputFile);

  total := 0;

  while not EOF(inputFile) do
  begin
    ReadLn(inputFile, line);

    SplitLine(line, target, values);
    ParseValues(values, equation, nVals);

    if CalculateSequence(target, 0, equation, 1, nVals) then
    begin
      total := total + target;
    end;
  end;

  Close(inputFile);

  WriteLn(total);
end.
