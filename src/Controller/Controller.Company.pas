unit Controller.Company;

interface

uses
  Horse, Model.Company, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt;

type
  TControllerCompany = class
    public
      class procedure Router;
  end;

implementation

{ TControllerCompany }

procedure getCompany(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelCompany;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelCompany.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getCompany('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getCompanyID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelCompany;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelCompany.Create;
       modc.ID_EMPRESA := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getCompany('', erro);

       if qry.RecordCount > 0 then
       begin
         objJson := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objJson);
       end
       else
         aRes.Send('Empresa nao encontrado').Status(400);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure addCompany(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelCompany;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelCompany.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.CNPJ := body.GetValue<string>('cnpj', '');
     modc.IE := body.GetValue<string>('ie', '');
     modc.NOME := body.GetValue<string>('nome', '');
     modc.FANTASIA := body.GetValue<string>('fantasia', '');
     modc.FONE := body.GetValue<string>('fone', '');
     modc.CEP := body.GetValue<string>('cep', '');
     modc.LOGRADOURO := body.GetValue<string>('logradouro', '');
     modc.NUMERO := body.GetValue<string>('numero', '');
     modc.COMPLEMENTO := body.GetValue<string>('complemento', '');
     modc.BAIRRO := body.GetValue<string>('bairro', '');
     modc.COD_MUNICIPIO := body.GetValue<string>('cod_municipio', '');
     modc.MUNICIPIO := body.GetValue<string>('municipio', '');
     modc.UF := body.GetValue<string>('uf', '');
     modc.IE_ESTADUAL := body.GetValue<string>('ie_estadual', '');
     modc.CRT := body.GetValue<string>('crt', '');
     modc.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
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
     objJson.AddPair('id', modc.ID_EMPRESA.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteCompany(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelCompany;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelCompany.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_EMPRESA := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_EMPRESA.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateCompany(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelCompany;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelCompany.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            modc.ID_EMPRESA := body.GetValue<integer>('id', 0);
            modc.CNPJ := body.GetValue<string>('cnpj', '');
            modc.IE := body.GetValue<string>('ie', '');
            modc.NOME := body.GetValue<string>('nome', '');
            modc.FANTASIA := body.GetValue<string>('fantasia', '');
            modc.FONE := body.GetValue<string>('fone', '');
            modc.CEP := body.GetValue<string>('cep', '');
            modc.LOGRADOURO := body.GetValue<string>('logradouro', '');
            modc.NUMERO := body.GetValue<string>('numero', '');
            modc.COMPLEMENTO := body.GetValue<string>('complemento', '');
            modc.BAIRRO := body.GetValue<string>('bairro', '');
            modc.COD_MUNICIPIO := body.GetValue<string>('cod_municipio', '');
            modc.MUNICIPIO := body.GetValue<string>('municipio', '');
            modc.UF := body.GetValue<string>('uf', '');
            modc.IE_ESTADUAL := body.GetValue<string>('ie_estadual', '');
            modc.CRT := body.GetValue<string>('crt', '');
            modc.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
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
        objJson.AddPair('id', modc.ID_EMPRESA.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerCompany.Router;
begin
  THorse.Get('/company', getCompany);
  THorse.Get('/company/:id', getCompanyID);
  THorse.Post('/company', addCompany);
  THorse.Put('/company', updateCompany);
  THorse.Delete('/company/:id', deleteCompany);
end;

end.
