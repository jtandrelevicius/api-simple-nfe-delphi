unit Controller.Client;

interface

uses
  Horse, Model.Client, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON;

type

  TControllerClient = class
    public
      class procedure Router;
    end;

implementation


{ TControllerClient }

procedure getClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  cli : TModelClient;
  qry : TFDQuery;
  erro : String;
  arrayClient : TJSONArray;
begin
     try

       cli := TModelClient.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := cli.getClient('', erro);
       arrayClient := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayClient);

     finally
       qry.Free;
       cli.Free;
     end;

end;

procedure getClientID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  cli : TModelClient;
  qry : TFDQuery;
  erro : String;
  objClient : TJSONObject;
begin
     try
       cli := TModelClient.Create;
       cli.ID_CLIENTE := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := cli.getClient('', erro);

       if qry.RecordCount > 0 then
       begin
         objClient := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objClient);
       end
       else
         aRes.Send('Cliente nao encontrado').Status(400);

     finally
       qry.Free;
       cli.Free;
     end;

end;

procedure insertClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  cli : TModelClient;
  objClient : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    cli := TModelClient.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;


end;

procedure deleteClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
begin

end;

procedure updateClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
begin

end;

class procedure TControllerClient.Router;
begin
  THorse.Get('/client', getClient);
  THorse.Get('/client/:id', getClientID);
  THorse.Post('/client', insertClient);
  THorse.Delete('/client', deleteClient);
 // THorse.Get('/client', getClient);
end;

end.
