unit _SeriaisDB;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, ZDataset;

function MyNextSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string): integer;
function MyGetSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string): integer;
function MySetSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string;
  new: integer): integer;
function MyCreateSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string;
  nProximo, nBase, nOffSet: integer): integer;

implementation

function MyBase10(cNum: string): string;
var
  nI, nSoma: integer;
  cPart1, cPart2: string;
begin
  nSoma := 0;
  cPart1 := '';
  cPart2 := '';
  if Length(cNum) mod 2 = 1 then
    cNum := '0' + cNum;

  for nI := 1 to Length(cNum) do
  begin
    if nI mod 2 = 1 then
      cPart1 := cPart1 + cNum[nI]
    else
      cPart2 := cPart2 + cNum[nI];

  end;
  cPart2 := IntToStr(StrToInt64(cPart2) * 2);
  cPart1 := cPart1 + cPart2;

  for nI := 1 to Length(cPart1) do
  begin
    nSoma := nSoma + (Ord(cPart1[nI]) - 48);
  end;
  nSoma := 10 - (nSoma mod 10);
  if nSoma = 10 then
    nSoma := 0;
  Result := IntToStr(nSoma);
end;

function MyBase11(cNum: string): string;
  // se o resultado for < 10 > então retorna < 0 >
var
  nI, nSoma, nFator: integer;
begin
  nSoma := 0;
  nFator := 2;
  for nI := Length(cNum) downto 1 do
  begin
    nSoma := nSoma + (Ord(cNum[nI]) - 48) * nFator;
    Inc(nFator);
    if nFator = 10 then
      nFator := 2;
  end;
  Result := IntToStr(nSoma * 10 mod 11);
  if Result = '10' then
    Result := '0';
end;

function MySqlSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string;
  nNewVal: integer): integer;
  // retorna o serial de <cID> ou 0 (zero) se não encontrar

  // if <nNewVal> = 0 somente retorna o serial
  // if <nNewVal> = -1 retorna o serial e incrementa
  // if <nNewVal> > 0 set o novo valor
var
  dv: integer;
  proximo: integer;
  base: integer;
  offserial: integer;
begin
  Result := 0;
  ZQ.Close;
  ZQ.SQL.Text := 'SELECT * FROM ' + fNomeTabelaSerial + ' WHERE NomeSerial = ''' +
    UpperCase(sNomeSerial) + '''';
  ZQ.Open;
  if ZQ.RecordCount = 0 then
    exit;

  proximo := ZQ.FieldByName('proximoserial').AsInteger;
  base := ZQ.FieldByName('baseserial').AsInteger;
  offserial := ZQ.FieldByName('offsetserial').AsInteger;

  Result := proximo;

  if nNewVal = -1 then
  begin
    Inc(proximo);
    ZQ.Close;
    ZQ.SQL.Text := 'UPDATE ' + fNomeTabelaSerial + ' SET proximoserial = ' +
      IntToStr(proximo) + ' WHERE NomeSerial = ''' + UpperCase(sNomeSerial) + '''';
    ZQ.ExecSQL;
  end

  else if nNewVal > 0 then
  begin
    ZQ.Close;
    ZQ.SQL.Text := 'UPDATE ' + fNomeTabelaSerial + ' SET proximoserial = ' +
      IntToStr(nNewVal) + ' WHERE NomeSerial = ''' + UpperCase(sNomeSerial) + '''';
    ZQ.ExecSQL;
  end;

  ZQ.Connection.Commit;

  dv := -1;

  if base = 10 then
    dv := StrToInt(MyBase10(IntToStr(Result)))
  else if base = 11 then
    dv := StrToInt(MyBase11(IntToStr(Result)));

  if dv > -1 then
  begin
    dv := (dv + offserial) mod 10;
    Result := (Result * 10) + dv;
  end;

end;

function MyNextSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string): integer;
begin
  Result := MySqlSerial(ZQ, fNomeTabelaSerial, sNomeSerial, -1);
end;

function MyGetSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string): integer;
begin
  Result := MySqlSerial(ZQ, fNomeTabelaSerial, sNomeSerial, 0);
end;

function MySetSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string;
  new: integer): integer;
begin
  Result := MySqlSerial(ZQ, fNomeTabelaSerial, sNomeSerial, new);
end;

function MyCreateSerial(ZQ: TZQuery; fNomeTabelaSerial, sNomeSerial: string;
  nProximo, nBase, nOffSet: integer): integer;
begin
  ZQ.Close;
  ZQ.SQL.Text := 'insert into ' + fNomeTabelaSerial +
    '(NomeSerial, ProximoSerial, BaseSerial, OffSetSerial) ' +
    ' values(''' + sNomeSerial + ''', ' + IntToStr(nProximo) + ', ' +
    IntToStr(nBase) + ', ' + IntToStr(nOffSet) + ')';
  ZQ.ExecSQL;
  ZQ.Connection.Commit;

  Result := 0;

end;

end.
