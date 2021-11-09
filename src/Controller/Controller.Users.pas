unit Controller.Users;

interface

uses
  Horse, Model.Users, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt;

type

  TControllerUsers = class
    public
      class procedure Router;
    end;

implementation

{ TControllerUsers }

procedure getUsers(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelUsers;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelUsers.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getUsers('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getUsersID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelUsers;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelUsers.Create;
       modc.ID_USUARIO := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getUsers('', erro);

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

procedure addUsers(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelUsers;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelUsers.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.NOME := body.GetValue<string>('nome', '');
     modc.USUARIO := body.GetValue<string>('usuario', '');
     modc.SENHA := body.GetValue<string>('senha', '');
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
     modc.STATUS := body.GetValue<string>('status', '');
     modc.TIPO := body.GetValue<string>('tipo', '');
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
     objJson.AddPair('id', modc.ID_USUARIO.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteUsers(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelUsers;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelUsers.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_USUARIO := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_USUARIO.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateUsers(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelUsers;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelUsers.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            modc.ID_USUARIO := body.GetValue<integer>('id', 0);
            modc.NOME := body.GetValue<string>('nome', '');
            modc.USUARIO := body.GetValue<string>('usuario', '');
            modc.SENHA := body.GetValue<string>('senha', '');
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
            modc.STATUS := body.GetValue<string>('status', '');
            modc.TIPO := body.GetValue<string>('tipo', '');
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
        objJson.AddPair('id', modc.ID_USUARIO.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerUsers.Router;
begin
  THorse.Get('/users', getUsers);
  THorse.Get('/users/:id', getUsersID);
  THorse.Post('/users', addUsers);
  THorse.Put('/users', updateUsers);
  THorse.Delete('/users/:id', deleteUsers);
end;

end.
