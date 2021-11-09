unit Model.Sales.Items;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelSalesItems = class
    private
    FPRODUTO: String;
    FID_PRODUTO: Integer;
    FVALOR: Double;
    FID_VENDA: Integer;
    FUSUARIO_CADASTRO: String;
    FTOTAL: Double;
    FQUANTIDADE: Double;
    FID_VENDAS_ITENS: Integer;
    public
      constructor Create;
      destructor Destroy;override;
      property ID_VENDAS_ITENS: Integer read FID_VENDAS_ITENS write FID_VENDAS_ITENS;
      property ID_VENDA: Integer read FID_VENDA write FID_VENDA;
      property ID_PRODUTO: Integer read FID_PRODUTO write FID_PRODUTO;
      property PRODUTO: String read FPRODUTO write FPRODUTO;
      property VALOR: Double read FVALOR write FVALOR;
      property TOTAL: Double read FTOTAL write FTOTAL;
      property QUANTIDADE: Double read FQUANTIDADE write FQUANTIDADE;
      property USUARIO_CADASTRO: String read FUSUARIO_CADASTRO write FUSUARIO_CADASTRO;

      function getSalesItems(order_by: String; out erro:String): TFDQuery;
      function insert(out erro: String): Boolean;
      function delete(out erro: String): Boolean;
      function update(out erro: String): Boolean;
  end;

implementation

{ TModelSalesItems }

constructor TModelSalesItems.Create;
begin
Model.Connection.Connect;
end;

function TModelSalesItems.delete(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM VENDAS_ITENS WHERE ID=:ID');
            ParamByName('ID').Value := ID_VENDAS_ITENS;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir item da venda: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelSalesItems.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelSalesItems.getSalesItems(order_by: String;
  out erro: String): TFDQuery;
var
  qry : TFDQuery;
begin
     try
       qry := TFDQuery.Create(nil);
       qry.Connection := Model.Connection.FConnection;

       with qry do
       begin
         Active := False;
         SQL.Clear;
         SQL.Add('SELECT * FROM VENDAS_ITENS WHERE 1 = 1');

         if ID_VENDAS_ITENS > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_VENDAS_ITENS;
         end;

         if order_by = '' then
            SQL.Add('ORDER BY ID')
         else
            SQL.Add('ORDER BY' + order_by);

         Active := True;
       end;

       erro := '';
       Result := qry;

     except on ex:exception do
       begin
         erro := 'Erro ao consultar itens' + ex.Message;
         Result := nil;
       end;
     end;

end;

function TModelSalesItems.insert(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO VENDAS_ITENS(ID_VENDA, ID_PRODUTO, PRODUTO, VALOR, TOTAL, QUANTIDADE, USUARIO_CADASTRO)');
            SQL.Add('VALUES(:ID_VENDA, :ID_PRODUTO, :PRODUTO, :VALOR, :TOTAL, :QUANTIDADE, :USUARIO_CADASTRO)');

            ParamByName('ID_VENDA').Value := ID_VENDA;
            ParamByName('ID_PRODUTO').Value := ID_PRODUTO;
            ParamByName('PRODUTO').Value := PRODUTO;
            ParamByName('VALOR').Value := VALOR;
            ParamByName('TOTAL').Value := TOTAL;
            ParamByName('QUANTIDADE').Value := QUANTIDADE;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM VENDAS_ITENS');
            active := true;

            ID_VENDAS_ITENS := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar item: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelSalesItems.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_VENDAS_ITENS <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. da venda';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE VENDAS_ITENS SET VALOR=:VALOR, TOTAL=:TOTAL, QUANTIDADE=:QUANTIDADE, USUARIO_CADASTRO=:USUARIO_CADASTRO');
            SQL.Add('WHERE ID=:ID');
            ParamByName('VALOR').Value := VALOR;
            ParamByName('TOTAL').Value := TOTAL;
            ParamByName('QUANTIDADE').Value := QUANTIDADE;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('ID').Value := ID_VENDAS_ITENS;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar item: ' + ex.Message;
            Result := false;
        end;
    end;

end;

end.
