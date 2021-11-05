unit Controller.Provider;

interface

uses
  Horse, Model.Provider, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt;

type

  TControllerProvider = class
    public
      class procedure Router;
    end;

implementation

{ TControllerProvider }
procedure getProvider(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProvider;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelProvider.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getProvider('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getProviderID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProvider;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelProvider.Create;
       modc.ID_FORNECEDOR := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getProvider('', erro);

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

procedure addProvider(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProvider;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelProvider.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.NOME_FANTASIA := body.GetValue<string>('nome', '');
     modc.RAZAO_SOCIAL := body.GetValue<string>('razao', '');
     modc.IE := body.GetValue<string>('ie', '');
     modc.CNPJ := body.GetValue<string>('cnpj', '');
     modc.EMAIL := body.GetValue<string>('email', '');
     modc.CONTATO := body.GetValue<string>('contato', '');
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
     modc.STATUS := body.GetValue<string>('status', '');
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
     objJson.AddPair('id', modc.ID_FORNECEDOR.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteProvider(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelProvider;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelProvider.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_FORNECEDOR := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_FORNECEDOR.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateProvider(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProvider;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelProvider.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            modc.ID_FORNECEDOR := body.GetValue<integer>('id', 0);
            modc.NOME_FANTASIA := body.GetValue<string>('nome', '');
            modc.RAZAO_SOCIAL := body.GetValue<string>('razao', '');
            modc.IE := body.GetValue<string>('ie', '');
            modc.CNPJ := body.GetValue<string>('cnpj', '');
            modc.EMAIL := body.GetValue<string>('email', '');
            modc.CONTATO := body.GetValue<string>('contato', '');
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
            modc.STATUS := body.GetValue<string>('status', '');
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
        objJson.AddPair('id', modc.ID_FORNECEDOR.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerProvider.Router;
begin
  THorse.Get('/provider', getProvider);
  THorse.Get('/provider/:id', getProviderID);
  THorse.Post('/provider', addProvider);
  THorse.Put('/provider', updateProvider);
  THorse.Delete('/provider/:id', deleteProvider);
end;

end.
