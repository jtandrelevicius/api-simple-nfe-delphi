unit Model.Sales;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

  type
    TModelSales = class
      private
        FDESCONTO: Double;
        FTROCO: Double;
        FVALOR: Double;
        FID_VENDA: Integer;
        FUSUARIO_CADASTRO: String;
        FDATA_CADASTRO: TDate;
        FVALOR_RECEBIDO: Double;
        FID_CLIENTE: Integer;
        FSTATUS: String;
        FHORA_CADASTRO: TTime;
        FID_PAGAMENTO: Integer;
        FTERMINAL: String;
      public
        constructor Create;
        destructor Destroy; override;
        property ID_VENDA: Integer read FID_VENDA write FID_VENDA;
        property ID_CLIENTE: Integer read FID_CLIENTE write FID_CLIENTE;
        property ID_PAGAMENTO: Integer read FID_PAGAMENTO write FID_PAGAMENTO;
        property VALOR: Double read FVALOR write FVALOR;
        property DESCONTO: Double read FDESCONTO write FDESCONTO;
        property VALOR_RECEBIDO: Double read FVALOR_RECEBIDO write FVALOR_RECEBIDO;
        property TROCO: Double read FTROCO write FTROCO;
        property DATA_CADASTRO: TDate read FDATA_CADASTRO write FDATA_CADASTRO;
        property HORA_CADASTRO: TTime read FHORA_CADASTRO write FHORA_CADASTRO;
        property TERMINAL: String read FTERMINAL write FTERMINAL;
        property USUARIO_CADASTRO: String read FUSUARIO_CADASTRO;
        property STATUS: String read FSTATUS write FSTATUS;

        function getSales(order_by: String; out erro:String): TFDQuery;
        function insert(out erro: String): Boolean;
        function delete(out erro: String): Boolean;
        function update(out erro: String): Boolean;
    end;

implementation

{ TModelSales }

constructor TModelSales.Create;
begin
Model.Connection.Connect;
end;

function TModelSales.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM VENDAS WHERE ID=:ID');
            ParamByName('ID').Value := ID_VENDA;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir venda: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelSales.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelSales.getSales(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM VENDAS WHERE 1 = 1');

         if ID_VENDA > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_VENDA;
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
         erro := 'Erro ao consultar vendas' + ex.Message;
         Result := nil;
       end;
     end;

end;

function TModelSales.insert(out erro: String): Boolean;
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
            SQL.Add('INSERT INTO VENDAS(ID_CLIENTE, ID_PAGAMENTO, VALOR, DESCONTO, VALOR_RECEBIDO, TROCO, DATA_CADASTRO, HORA_CADASTRO, USUARIO_CADASTRO, STATUS)');
            SQL.Add('VALUES(:ID_CLIENTE, :ID_PAGAMENTO, :VALOR, :DESCONTO, :VALOR_RECEBIDO, :TROCO, :DATA_CADASTRO, :HORA_CADASTRO, :USUARIO_CADASTRO, :STATUS)');

            if ID_CLIENTE = 0 then
            begin
               ParamByName('ID_CLIENTE').Value := 0;
            end
            else
            begin
               ParamByName('ID_CLIENTE').Value := ID_CLIENTE;
            end;

            ParamByName('ID_PAGAMENTO').Value := ID_PAGAMENTO;
            ParamByName('VALOR').Value := VALOR;
            ParamByName('DESCONTO').Value := DESCONTO;
            ParamByName('VALOR_RECEBIDO').Value := VALOR_RECEBIDO;
            ParamByName('TROCO').Value := TROCO;
            ParamByName('DATA_CADASTRO').Value := Date;
            ParamByName('HORA_CADASTRO').Value := Time;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('STATUS').Value := 'FINALIZADO';

            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM VENDAS');
            active := true;

            ID_VENDA := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar venda: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelSales.update(out erro: String): Boolean;

begin



end;

end.
