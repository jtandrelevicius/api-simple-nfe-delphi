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
  modc : TModelClient;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelClient.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getClient('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getClientID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelClient;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelClient.Create;
       modc.ID_CLIENTE := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getClient('', erro);

       if qry.RecordCount > 0 then
       begin
         objJson := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objJson);
       end
       else
         aRes.Send('Cliente nao encontrado').Status(400);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure addClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelClient;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelClient.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.NOME := body.GetValue<string>('nome', '');
     modc.EMAIL := body.GetValue<string>('email', '');
     modc.TELEFONE := body.GetValue<string>('telefone', '');
     modc.CELULAR := body.GetValue<string>('celular', '');
     modc.CEP := body.GetValue<string>('cep', '');
     modc.TIPO_LOGRADOURO := body.GetValue<string>('tipo_logradouro', '');
     modc.LOGRADOURO := body.GetValue<string>('logradouro', '');
     modc.NUMERO := body.GetValue<string>('numero', '');
     modc.COMPLEMENTO := body.GetValue<string>('complemento', '');
     modc.BAIRRO := body.GetValue<string>('bairro', '');
     modc.UF := body.GetValue<string>('uf', '');
     modc.CIDADE := body.GetValue<string>('cidade', '');
     //cli.DATA_CADASTRO := strToDate(body.GetValue<string>('data_cadastro', ''));
     modc.STATUS := body.GetValue<string>('status', '');
     modc.CPF_CNPJ := body.GetValue<string>('cpf_cnpj', '');
     modc.insert(erro);

     body.Free;

     if erro <> '' then
        raise Exception.Create(erro);

   except on ex:exception do
   begin
       aRes.Send(ex.Message).status(400);
       exit;
   end;
   end;

     objJson := TJSONObject.Create;
     objJson.AddPair('id', modc.ID_CLIENTE.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelClient;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelClient.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_CLIENTE := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_CLIENTE.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateClient(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelClient;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelClient.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            modc.ID_CLIENTE := body.GetValue<integer>('id', 0);
            modc.NOME := body.GetValue<string>('nome', '');
            modc.EMAIL := body.GetValue<string>('email', '');
            modc.TELEFONE := body.GetValue<string>('telefone', '');
            modc.CELULAR := body.GetValue<string>('celular', '');
            modc.CEP := body.GetValue<string>('cep', '');
            modc.TIPO_LOGRADOURO := body.GetValue<string>('tipo_logradouro', '');
            modc.LOGRADOURO := body.GetValue<string>('logradouro', '');
            modc.NUMERO := body.GetValue<string>('numero', '');
            modc.COMPLEMENTO := body.GetValue<string>('complemento', '');
            modc.BAIRRO := body.GetValue<string>('bairro', '');
            modc.UF := body.GetValue<string>('uf', '');
            modc.CIDADE := body.GetValue<string>('cidade', '');
            //cli.DATA_CADASTRO := strToDate(body.GetValue<string>('data_cadastro', ''));
            modc.STATUS := body.GetValue<string>('status', '');
            modc.CPF_CNPJ := body.GetValue<string>('cpf_cnpj', '');
            modc.update(erro);

            body.Free;

            if erro <> '' then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_CLIENTE.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
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
