unit Controller.Sales.Items;

interface

uses
  Horse, Model.Sales.Items, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt, uFunctions;

type

  TControllerSalesItems = class
    public
      class procedure Router;
    end;

implementation

{ TControllerSalesItems }

procedure getSalesItems(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSalesItems;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelSalesItems.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getSalesItems('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getSalesItemsID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSalesItems;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelSalesItems.Create;
       modc.ID_VENDAS_ITENS := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getSalesItems('', erro);

       if qry.RecordCount > 0 then
       begin
         objJson := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objJson);
       end
       else
         aRes.Send('Item  nao encontrado').Status(400);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure addSalesItems(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSalesItems;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelSalesItems.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.ID_VENDA := body.GetValue<integer>('id_venda', 0);
     modc.ID_PRODUTO := body.GetValue<integer>('id_produto', 0);
     modc.PRODUTO := body.GetValue<string>('produto', '');
     modc.VALOR := TrataValor(body.GetValue<string>('valor', ''));
     modc.TOTAL := TrataValor(body.GetValue<string>('total', ''));
     modc.QUANTIDADE := TrataValor(body.GetValue<string>('quantidade', ''));
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
     objJson.AddPair('id', modc.ID_VENDAS_ITENS.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteSalesItems(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelSalesItems;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelSalesItems.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_VENDAS_ITENS := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_VENDAS_ITENS.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateSalesItems(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSalesItems;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelSalesItems.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

            modc.ID_VENDAS_ITENS := body.GetValue<integer>('id', 0);
            modc.ID_VENDA := body.GetValue<integer>('id_venda', 0);
            modc.ID_PRODUTO := body.GetValue<integer>('id_produto', 0);
            modc.PRODUTO := body.GetValue<string>('produto', '');
            modc.VALOR := TrataValor(body.GetValue<string>('valor', ''));
            modc.TOTAL := TrataValor(body.GetValue<string>('total', ''));
            modc.QUANTIDADE := TrataValor(body.GetValue<string>('quantidade', ''));
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
        objJson.AddPair('id', modc.ID_VENDAS_ITENS.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerSalesItems.Router;
begin
  THorse.Get('/salesitems', getSalesItems);
  THorse.Get('/salesitems/:id', getSalesItemsID);
  THorse.Post('/salesitems', addSalesItems);
  THorse.Put('/salesitems', updateSalesItems);
  THorse.Delete('/salesitems/:id', deleteSalesItems);
end;

end.
