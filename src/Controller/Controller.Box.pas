unit Controller.Box;

interface

uses
  Horse, Model.Box, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt, uFunctions;

type
  TControllerBox = class
    public
      class procedure Router;
  end;

implementation

{ TControllerBox }

procedure getBox(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelBox;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelBox.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getBox('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getBoxID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelBox;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelBox.Create;
       modc.ID_CAIXA := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getBox('', erro);

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

procedure addBox(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelBox;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelBox.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.VALOR_ABERTURA := TrataValor(body.GetValue<string>('valor_abertura', ''));
     modc.USUARIO_ABERTURA := body.GetValue<string>('usuario_abertura', '');
     modc.OPERADOR := body.GetValue<string>('operador', '');
     modc.TERMINAL := body.GetValue<string>('terminal', '');
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
     objJson .AddPair('id', modc.ID_CAIXA.ToString);

     aRes.Send<TJSONObject>(objJson ).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteBox(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelBox;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelBox.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_CAIXA := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_CAIXA.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateBox(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelBox;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelBox.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

             modc.VALOR_FECHAMENTO := TrataValor(body.GetValue<string>('valor_fechamento', ''));
             modc.USUARIO_FECHAMENTO := body.GetValue<string>('usuario_fechamento', '');
             modc.OPERADOR := body.GetValue<string>('operador', '');
             modc.TERMINAL := body.GetValue<string>('terminal', '');
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
        objJson.AddPair('id', modc.ID_CAIXA.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerBox.Router;
begin
  THorse.Get('/box', getBox);
  THorse.Get('/box/:id', getBoxID);
  THorse.Post('/box', addBox);
  THorse.Put('/box', updateBox);
  THorse.Delete('/box/:id', deleteBox);
end;

end.
