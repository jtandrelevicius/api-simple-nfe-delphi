unit Controller.Product;

interface

uses
  Horse, Model.Product, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt, uFunctions;

type

  TControllerProduct = class
    public
      class procedure Router;
    end;

implementation

{ TControllerProduct }


procedure getProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProduct;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelProduct.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getProduct('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getProductID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProduct;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelProduct.Create;
       modc.ID_PRODUTO := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getProduct('', erro);

       if qry.RecordCount > 0 then
       begin
         objJson := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objJson);
       end
       else
         aRes.Send('Produto nao encontrado').Status(400);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure addProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProduct;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelProduct.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

      modc.COD_PRODUTO_FORNECEDOR := body.GetValue<string>('cod_produto_for', '');
      modc.DESCRICAO := body.GetValue<string>('descricao', '');
      modc.VALOR_UNITARIO := TrataValor(body.GetValue<string>('valor_unitario', ''));
      modc.FORNECEDOR := body.GetValue<string>('fornecedor', '');
      modc.EAN := body.GetValue<string>('ean', '');
      modc.COD_BARRAS := body.GetValue<string>('cod_barras', '');
      modc.UNIDADE := body.GetValue<string>('unidade', '');
      modc.NCM := body.GetValue<string>('ncm', '');
      modc.CFOP := body.GetValue<string>('cfop', '');
      modc.QUANTIDADE := TrataValor(body.GetValue<string>('quantidade', ''));
      modc.ICMS_CST := body.GetValue<string>('icms_cst', '');
      modc.ICMS_CSON := body.GetValue<string>('icms_cson', '');
      modc.ICMS_PERCENTUAL := TrataValor(body.GetValue<string>('icms_percentual', ''));
      modc.ICMS_VALOR := TrataValor(body.GetValue<string>('icms_valor', ''));
      modc.PIS_CST := body.GetValue<string>('pis_cst', '');
      modc.PIS_PERCENTUAL := TrataValor(body.GetValue<string>('pis_percentual', ''));
      modc.PIS_VALOR := TrataValor(body.GetValue<string>('pis_valor', ''));
      modc.COFINS_CST := body.GetValue<string>('cofins_cst', '');
      modc.COFINS_PERCENTUAL := TrataValor(body.GetValue<string>('cofins_percentual', ''));
      modc.COFINS_VALOR := TrataValor(body.GetValue<string>('cofins_valor', ''));
      modc.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
      modc.STATUS := body.GetValue<string>('status', '');
      modc.CEST := body.GetValue<string>('cest', '');
      modc.ORIGEM := TrataValor(body.GetValue<string>('origem', ''));
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
     objJson.AddPair('id', modc.ID_PRODUTO.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelProduct;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelProduct.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_PRODUTO := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_PRODUTO.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelProduct;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        modc := TModelProduct.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;
            modc.ID_PRODUTO := body.GetValue<integer>('id', 0);
            modc.COD_PRODUTO_FORNECEDOR := body.GetValue<string>('cod_produto_for', '');
            modc.DESCRICAO := body.GetValue<string>('descricao', '');
            modc.VALOR_UNITARIO := TrataValor(body.GetValue<string>('valor_unitario', ''));
            modc.FORNECEDOR := body.GetValue<string>('fornecedor', '');
            modc.EAN := body.GetValue<string>('ean', '');
            modc.COD_BARRAS := body.GetValue<string>('cod_barras', '');
            modc.UNIDADE := body.GetValue<string>('unidade', '');
            modc.NCM := body.GetValue<string>('ncm', '');
            modc.CFOP := body.GetValue<string>('cfop', '');
            modc.QUANTIDADE := TrataValor(body.GetValue<string>('quantidade', ''));
            modc.ICMS_CST := body.GetValue<string>('icms_cst', '');
            modc.ICMS_CSON := body.GetValue<string>('icms_cson', '');
            modc.ICMS_PERCENTUAL := TrataValor(body.GetValue<string>('icms_percentual', ''));
            modc.ICMS_VALOR := TrataValor(body.GetValue<string>('icms_valor', ''));
            modc.PIS_CST := body.GetValue<string>('pis_cst', '');
            modc.PIS_PERCENTUAL := TrataValor(body.GetValue<string>('pis_percentual', ''));
            modc.PIS_VALOR := TrataValor(body.GetValue<string>('pis_valor', ''));
            modc.COFINS_CST := body.GetValue<string>('cofins_cst', '');
            modc.COFINS_PERCENTUAL := TrataValor(body.GetValue<string>('cofins_percentual', ''));
            modc.COFINS_VALOR := TrataValor(body.GetValue<string>('cofins_valor', ''));
            modc.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
            modc.STATUS := body.GetValue<string>('status', '');
            modc.CEST := body.GetValue<string>('cest', '');
            modc.ORIGEM := TrataValor(body.GetValue<string>('origem', ''));
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
        objJson.AddPair('id', modc.ID_PRODUTO.ToString);

        aRes.Send<TJSONObject>(objJson).Status(200);
    finally
        modc.Free;
    end;

end;

class procedure TControllerProduct.Router;
begin
  THorse.Get('/product', getProduct);
  THorse.Get('/product/:id', getProductID);
  THorse.Post('/product', addProduct);
  THorse.Put('/product', updateProduct);
  THorse.Delete('/product/:id', deleteProduct);
end;

end.
