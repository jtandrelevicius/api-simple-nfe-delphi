unit Controller.NFE;

interface

uses
  Horse, Model.Client, Model.Certified, Model.NFE, Model.Company, Model.Sales, Model.Sales.Items, FireDAC.Comp.Client,
  System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt;


type

  TControllerNFE = class
    public
      class procedure Router;
    end;

implementation

{ TControllerNFE }

procedure getNFE(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelNFE;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try
       modc := TModelNFE.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getNFE('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getNFEID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelNFE;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelNFE.Create;
       modc.ID_NFE := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getNFE('', erro);

       if qry.RecordCount > 0 then
       begin
         objJson := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objJson);
       end
       else
         aRes.Send('NF-e nao encontrada').Status(400);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure addNFE(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelNFE;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelNFE.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.ID_VENDA := body.GetValue<integer>('id_venda', 0);
     modc.ID_CLIENTE := body.GetValue<integer>('id_cliente', 0);
     modc.ID_EMPRESA := body.GetValue<integer>('id_empresa', 0);
     modc.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
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
     objJson.AddPair('id', modc.ID_NFE.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure changelNFE(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
begin

end;

procedure cancelNFE(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelNFE;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelNFE.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            modc.ID_NFE := body.GetValue<integer>('id', 0);
            modc.cancel(erro);

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
        objJson.AddPair('id', modc.ID_NFE.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerNFE.Router;
begin
  THorse.Get('/nfe', getNFE);
  THorse.Get('/nfe/:id', getNFEID);
  THorse.Post('/nfe', addNFE);
  THorse.Put('/nfe', cancelNFe);
end;

end.
