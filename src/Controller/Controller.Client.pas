unit Controller.Client;

interface

uses
  Horse, Model.Client, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt;

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

procedure addClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
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
     //cli.DATA_CADASTRO := strToDate(body.GetValue<string>('data_cadastro', ''));
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
   end;

     objClient := TJSONObject.Create;
     objClient.AddPair('id', cli.ID_CLIENTE.ToString);

     aRes.Send<TJSONObject>(objClient).Status(201);
 finally
  cli.Free;
 end;

end;

procedure deleteClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    cli : TModelClient;
    objClient : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       cli := TModelClient.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            cli.ID_CLIENTE := aReq.Params['id'].ToInteger;

            if NOT cli.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objClient := TJSONObject.Create;
        objClient.AddPair('id', cli.ID_CLIENTE.ToString);

        aRes.Send<TJSONObject>(objClient);
    finally
        cli.Free;
    end;

end;

procedure updateClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  cli : TModelClient;
  objClient : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        cli := TModelClient.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            cli.ID_CLIENTE := body.GetValue<integer>('id', 0);
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
            //cli.DATA_CADASTRO := strToDate(body.GetValue<string>('data_cadastro', ''));
            cli.STATUS := body.GetValue<string>('status', '');
            cli.CPF_CNPJ := body.GetValue<string>('cpf_cnpj', '');
            cli.update(erro);

            body.Free;

            if erro <> '' then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objClient := TJSONObject.Create;
        objClient.AddPair('id_cliente', cli.ID_CLIENTE.ToString);

        aRes.Send<TJSONObject>(objClient).Status(200);
    finally
        cli.Free;
    end;

end;

class procedure TControllerClient.Router;
begin
  THorse.Get('/client', getClient);
  THorse.Get('/client/:id', getClientID);
  THorse.Post('/client', addClient);
  THorse.Put('/client', updateClient);
  THorse.Delete('/client/:id', deleteClient);
end;

end.
