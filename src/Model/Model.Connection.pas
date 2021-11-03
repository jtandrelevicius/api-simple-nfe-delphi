unit Model.Connection;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client,IniFiles, System.SysUtils;

var
   FConnection : TFDConnection;

function SetupConnection(FConn: TFDConnection):String;
function Connect: TFDConnection;
procedure Disconnect;

implementation

function SetupConnection(FConn: TFDConnection): String;
var
   arq_ini:String;
   ini:TIniFile;
begin
  try
    try
      arq_ini := GetCurrentDir + '\HorseSimple.ini';
      if NOT FileExists(arq_ini) then
      begin
        Result := 'Arquivo INI não encontrado:' + arq_ini;
        exit;
      end;

      //INICIA o ARQUIVO INI
      ini := TIniFile.Create(arq_ini);

      //BUSCA OS DADOS CONTIDOS NO ARQUIVO


      Result := 'OK';
    except on ex:exception do
      Result := 'Erro ao configurar database'+ ex.Message;
    end;
  finally
    if Assigned(ini)then
       ini.Free;
  end;

end;

function Connect: TFDConnection;
begin
   FConnection := TFDConnection.Create(nil);
   SetupConnection(FConnection);
   FConnection.Connected:= True;

   Result := FConnection;
end;

procedure Disconnect;
begin
   if Assigned(FConnection)then
   begin
     if FConnection.Connected then
        FConnection.Connected := False;

     FConnection.Free;
   end;
end;

end.
