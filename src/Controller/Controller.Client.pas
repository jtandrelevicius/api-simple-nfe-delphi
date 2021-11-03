unit Controller.Client;

interface

uses
  Horse, Model.Client, FireDAC.Comp.Client, System.SysUtils;

type

  TControllerClient = class
    public
      class procedure Router;
    end;

implementation


{ TControllerClient }

procedure getClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  cli : ModelClient;
  qry : TFDQuery;
  erro : String;
  arrayClient : TJSONArray;
begin
     try
       cli := ModelClient.Create;
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
  cli : ModelClient;
  qry : TFDQuery;
  erro : String;
  objClient : TJSONObject;
begin
     try
       cli := ModelClient.Create;
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
  cli : ModelClient;
  objClient : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    cli := ModelClient.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

 try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     cli.NOME := body.GetValue<string>('nome', '');
     cli.EMAIL := body.GetValue<string>('email', '');
     cli.TELEFONE := body.GetValue<string>('telefone', '');
     cli.CELULAR := body.GetValue<string>('celular', '');
     cli.CEP := body.GetValue<string>('cep', '');
     cli.TIPO_LOGRADOURO := body.GetValue<string>('tipo_logradouro', '');
     cli.LOGRADOURO := body.GetValue<string>('logradouro', '');
     cli.NUMERO := body.GetValue<string>('numero', '');
     cli.COMPLEMENTO := body.GetValue<string>('complemento', '');
     cli.BAIRRO := body.GetValue<string>('bairro', '');
     cli.UF := body.GetValue<string>('uf', '');
     cli.CIDADE := body.GetValue<string>('cidade', '');
     cli.DATA_CADASTRO := body.GetValue<TDateTime>('data_cadastro', '');
     cli.STATUS := body.GetValue<string>('status', '');
     cli.CPF_CNPJ := body.GetValue<string>('cpf_cnpj', '');
     cli.insert(erro);

     body.Free;

     if erro <> '' then
        raise Exception.Create(erro);

   except on ex:exception do
   begin
       aRes.Send(ex.Message).status(400);
       exit;
   end;
 finally
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
