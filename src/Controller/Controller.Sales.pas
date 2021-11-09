unit Controller.Sales;

interface

uses
  Horse, Model.Sales, FireDAC.Comp.Client, System.SysUtils, Data.DB, DataSet.Serialize, System.JSON, FireDAC.DApt, uFunctions;

type

  TControllerSales = class
    public
      class procedure Router;
    end;

implementation

{ TControllerSales }

procedure getSales(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSales;
  qry : TFDQuery;
  erro : String;
  arrayList : TJSONArray;
begin
     try

       modc := TModelSales.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getSales('', erro);
       arrayList := qry.ToJSONArray();
       aRes.Send<TJSONArray>(arrayList);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure getSalesID(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSales;
  qry : TFDQuery;
  erro : String;
  objJson : TJSONObject;
begin
     try
       modc := TModelSales.Create;
       modc.ID_VENDA := StrToInt(aReq.Params['id']);
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;

     try
       qry := modc.getSales('', erro);

       if qry.RecordCount > 0 then
       begin
         objJson := qry.ToJSONObject;
         aRes.Send<TJSONObject>(objJson);
       end
       else
         aRes.Send('Venda nao encontrado').Status(400);

     finally
       qry.Free;
       modc.Free;
     end;

end;

procedure addSales(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
  modc : TModelSales;
  objJson : TJSONObject;
  erro : String;
  body : TJSONValue;
begin
  try
    modc := TModelSales.Create;
 except
   aRes.Send('Erro ao conectar com o banco de dados').Status(500);
  end;

  try
   try
     body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(aReq.Body), 0) as TJsonValue;

     modc.ID_CLIENTE := body.GetValue<integer>('id_cliente', 0);
     modc.ID_PAGAMENTO := body.GetValue<integer>('id_pagamento', 0);
     modc.VALOR := TrataValor(body.GetValue<string>('valor', ''));
     modc.DESCONTO := TrataValor(body.GetValue<string>('desconto', ''));
     modc.VALOR_RECEBIDO := TrataValor(body.GetValue<string>('valor_recebido', ''));
     modc.TROCO := TrataValor(body.GetValue<string>('troco', ''));
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
     objJson.AddPair('id', modc.ID_VENDA.ToString);

     aRes.Send<TJSONObject>(objJson).Status(201);
 finally
  modc.Free;
 end;

end;

procedure deleteSales(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
var
    modc : TModelSales;
    objJson : TJSONObject;
    erro : String;

begin
    // Conexao com o banco...
     try
       modc := TModelSales.Create;
     except
       aRes.Send('Erro ao conectar com o banco de dados').Status(500);
       exit;
     end;


    try
        try
            modc.ID_VENDA := aReq.Params['id'].ToInteger;

            if NOT modc.delete(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                aRes.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objJson := TJSONObject.Create;
        objJson.AddPair('id', modc.ID_VENDA.ToString);

        aRes.Send<TJSONObject>(objJson);
    finally
        modc.Free;
    end;

end;

procedure updateSales(aReq:THorseRequest; aRes:THorseResponse; aNext:TNextProc);
begin


end;

class procedure TControllerSales.Router;
begin
  THorse.Get('/sales', getSales);
  THorse.Get('/sales/:id', getSalesID);
  THorse.Post('/sales', addSales);
  THorse.Put('/sales', updateSales);
  THorse.Delete('/sales/:id', deleteSales);
end;

end.
