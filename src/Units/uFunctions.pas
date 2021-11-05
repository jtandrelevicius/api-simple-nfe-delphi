unit uFunctions;

interface
uses
  System.Classes, Soap.EncdDecd, System.SysUtils, FMX.Graphics, System.NetEncoding,DateUtils;

function Base64FromBitmap(Bitmap: TBitmap): String;
function ValidarEmail(email: string): Boolean;
function TrataValor(str: string):double;
function NomeMes() : String;
function TrataPorcentagem(str: string):double;
function TrataNegativo(str: string):double;

implementation

//TRATAMENTO BASE64 PARA IMAGEM
function Base64FromBitmap(Bitmap: TBitmap): String;
var
  Input : TBytesStream;
  Output : TStringStream;
  Encoding : TBase64Encoding;
begin
   Input := TBytesStream.Create;
   try
     Bitmap.SaveToStream(Input);
     Input.Position := 0;
     Output := TStringStream.Create('', TEncoding.ASCII);

     try
       Encoding := TBase64Encoding.Create(0);
       Encoding.Encode(Input, Output);
       Result := Output.DataString;
     finally
       Encoding.Free;
       Output.Free;
     end;
   finally
       Input.Free;
   end;
end;

//VALIDACAO DO CAMPO EMAIL
function ValidarEmail(email: string): Boolean;
begin
  email := Trim(UpperCase(email));
  if Pos('@', email) > 1 then begin
    Delete(email, 1, pos('@', email));
    Result := (Length(email) > 0) and (Pos('.', email) > 2) and (Pos(' ', email) = 0);
  end else begin
    Result := False;
  end;
end;

//TRATAMENTO DE CAMPOS COM VALORES
function TrataValor(str: string):double;
begin
  str := StringReplace(str, '.', '', [rfReplaceAll]);
  str := StringReplace(str, ',', '', [rfReplaceAll]);

  try
    Result := StrToFloat(str) / 100;
  except
    Result := 0;
  end;
end;

//TRATAMENTO MES PELA NOMENCLATURA
function NomeMes() : String;
var
vData_Filtro : TDate;
begin
     case MonthOf(vData_Filtro) of
        1 : Result := 'Janeiro';
        2 : Result := 'Fevereiro';
        3 : Result := 'Março';
        4 : Result := 'Abril';
        5 : Result := 'Maio';
        6 : Result := 'Junho';
        7 : Result := 'Julho';
        8 : Result := 'Agosto';
        9 : Result := 'Setembro';
       10 : Result := 'Outubro';
       11 : Result := 'Novembro';
       12 : Result := 'Dezembro';

     end;
    Result := Result + ' / ' + YearOf(vData_filtro).ToString;
end;

function TrataPorcentagem(str: string):double;
begin
  str := StringReplace(str, '%', '', [rfReplaceAll]);

  try
    Result := StrToFloat(str);
  except
    Result := 0;
  end;
end;

function TrataNegativo(str: string):double;
begin
  str := StringReplace(str, '-', '', [rfReplaceAll]);

  try
    Result := StrToFloat(str);
  except
    Result := 0;
  end;
end;

end.
