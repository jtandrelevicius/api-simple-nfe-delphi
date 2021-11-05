unit Controller.Product;

interface

uses
  Horse, Model.Product, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt;

type

  TControllerProduct = class
    public
      class procedure Router;
    end;

implementation

{ TControllerProduct }


procedure getProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  pro : TModelProduct;
  qry : TFDQuery;
  erro : String;
  arrayProduct : TJSONArray;
begin
     try

       pro := TModelProduct.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := pro.getProduct('', erro);
       arrayProduct := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayProduct);

     finally
       qry.Free;
       pro.Free;
     end;

end;

procedure getProductID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  pro : TModelProduct;
  qry : TFDQuery;
  erro : String;
  objProduct : TJSONObject;
begin
     try
       pro := TModelProduct.Create;
       pro.ID_PRODUTO := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := pro.getProduct('', erro);

       if qry.RecordCount > 0 then
       begin
         objProduct := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objProduct);
       end
       else
         aRes.Send('Produto nao encontrado').Status(400);

     finally
       qry.Free;
       pro.Free;
     end;

end;

procedure addProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  pro : TModelProduct;
  objProduct : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    pro := TModelProduct.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

      pro.COD_PRODUTO_FORNECEDOR := body.GetValue<string>('cod_produto_for', '');
      pro.DESCRICAO := body.GetValue<string>('descricao', '');
      pro.VALOR_UNITARIO := body.GetValue<string>('valor_unitario', '').ToDouble;
      pro.FORNECEDOR := body.GetValue<string>('fornecedor', '');
      pro.EAN := body.GetValue<string>('ean', '');
      pro.COD_BARRAS := body.GetValue<string>('cod_barras', '');
      pro.UNIDADE := body.GetValue<string>('unidade', '');
      pro.NCM := body.GetValue<string>('ncm', '');
      pro.CFOP := body.GetValue<string>('cfop', '');
      pro.QUANTIDADE := body.GetValue<string>('quantidade', '').ToDouble;
      pro.ICMS_CST := body.GetValue<string>('icms_cst', '');
      pro.ICMS_CSON := body.GetValue<string>('icms_cson', '');
      pro.ICMS_PERCENTUAL := body.GetValue<string>('icms_percentual', '').ToDouble;
      pro.ICMS_VALOR := body.GetValue<string>('icms_valor', '').ToDouble;
      pro.PIS_CST := body.GetValue<string>('pis_cst', '');
      pro.PIS_PERCENTUAL := body.GetValue<string>('pis_percentual', '').ToDouble;
      pro.PIS_VALOR := body.GetValue<string>('pis_valor', '').ToDouble;
      pro.COFINS_CST := body.GetValue<string>('cofins_cst', '');
      pro.COFINS_PERCENTUAL := body.GetValue<string>('cofins_percentual', '').ToDouble;
      pro.COFINS_VALOR := body.GetValue<string>('cofins_valor', '').ToDouble;
      pro.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
      pro.STATUS := body.GetValue<string>('status', '');
      pro.CEST := body.GetValue<string>('cest', '');
      pro.ORIGEM := body.GetValue<string>('origem', '').ToDouble;
      pro.insert(erro);

     body.Free;

     if erro <> '' then
        raise Exception.Create(erro);

   except on ex:exception do
   begin
       aRes.Send(ex.Message).status(400);
       exit;
   end;
   end;

     objProduct := TJSONObject.Create;
     objProduct.AddPair('id', pro.ID_PRODUTO.ToString);

     aRes.Send<TJSONObject>(objProduct).Status(201);
 finally
  pro.Free;
 end;

end;

procedure deleteProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    pro : TModelProduct;
    objProduct : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       pro := TModelProduct.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            pro.ID_PRODUTO := aReq.Params['id'].ToInteger;

            if NOT pro.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objProduct := TJSONObject.Create;
        objProduct.AddPair('id', pro.ID_PRODUTO.ToString);

        aRes.Send<TJSONObject>(objProduct);
    finally
        pro.Free;
    end;

end;

procedure updateProduct(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  pro : TModelProduct;
  objProduct : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
    // Conexao com o banco...
    try
        pro := TModelProduct.Create;
    except
        aRes.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;
            pro.ID_PRODUTO := body.GetValue<integer>('id', 0);
            pro.COD_PRODUTO_FORNECEDOR := body.GetValue<string>('cod_produto_for', '');
            pro.DESCRICAO := body.GetValue<string>('descricao', '');
            pro.VALOR_UNITARIO := body.GetValue<string>('valor_unitario', '').ToDouble;
            pro.FORNECEDOR := body.GetValue<string>('fornecedor', '');
            pro.EAN := body.GetValue<string>('ean', '');
            pro.COD_BARRAS := body.GetValue<string>('cod_barras', '');
            pro.UNIDADE := body.GetValue<string>('unidade', '');
            pro.NCM := body.GetValue<string>('ncm', '');
            pro.CFOP := body.GetValue<string>('cfop', '');
            pro.QUANTIDADE := body.GetValue<string>('quantidade', '').ToDouble;
            pro.ICMS_CST := body.GetValue<string>('icms_cst', '');
            pro.ICMS_CSON := body.GetValue<string>('icms_cson', '');
            pro.ICMS_PERCENTUAL := body.GetValue<string>('icms_percentual', '').ToDouble;
            pro.ICMS_VALOR := body.GetValue<string>('icms_valor', '').ToDouble;
            pro.PIS_CST := body.GetValue<string>('pis_cst', '');
            pro.PIS_PERCENTUAL := body.GetValue<string>('pis_percentual', '').ToDouble;
            pro.PIS_VALOR := body.GetValue<string>('pis_valor', '').ToDouble;
            pro.COFINS_CST := body.GetValue<string>('cofins_cst', '');
            pro.COFINS_PERCENTUAL := body.GetValue<string>('cofins_percentual', '').ToDouble;
            pro.USUARIO_CADASTRO := body.GetValue<string>('usuario_cadastro', '');
            pro.STATUS := body.GetValue<string>('status', '');
            pro.CEST := body.GetValue<string>('cest', '');
            pro.ORIGEM := body.GetValue<string>('origem', '').ToDouble;
            pro.update(erro);

            body.Free;

            if erro <> '' then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objProduct := TJSONObject.Create;
        objProduct.AddPair('id', pro.ID_PRODUTO.ToString);

        aRes.Send<TJSONObject>(objProduct).Status(200);
    finally
        pro.Free;
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
