unit Model.Payment;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelPayment = class
    private
      FDESCRICAO: String;
      FID_PAGAMENTO: Integer;
    public
      constructor Create;
      destructor Destroy;override;
      property ID_PAGAMENTO: Integer read FID_PAGAMENTO write FID_PAGAMENTO;
      property DESCRICAO: String read FDESCRICAO write FDESCRICAO;

      function getPayment(order_by: String; out erro:String): TFDQuery;
      function insert(out erro: String): Boolean;
      function delete(out erro: String): Boolean;
      function update(out erro: String): Boolean;
  end;

implementation

{ TModelPayment }

constructor TModelPayment.Create;
begin
Model.Connection.Connect;
end;

function TModelPayment.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM TIPO_PAGAMENTO WHERE ID=:ID');
            ParamByName('ID').Value := ID_PAGAMENTO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir tipo de pagamento: ' + ex.Message;
            Result := false;
        end;
    end;


end;

destructor TModelPayment.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelPayment.getPayment(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM TIPO_PAGAMENTO WHERE 1 = 1');

         if ID_PAGAMENTO > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_PAGAMENTO;
         end;

         if order_by = '' then
            SQL.Add('ORDER BY DESCRICAO')
         else
            SQL.Add('ORDER BY' + order_by);

         Active := True;
       end;

       erro := '';
       Result := qry;

     except on ex:exception do
       begin
         erro := 'Erro ao consultar tipos de pagamentos' + ex.Message;
         Result := nil;
       end;
     end;

end;

function TModelPayment.insert(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if DESCRICAO.IsEmpty then
    begin
        Result := false;
        erro := 'Informe um descricao para o pagamento';
        exit;
    end;


    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO TIPO_PAGAMENTO(DESCRICAO)');
            SQL.Add('VALUES(:DESCRICAO)');

            ParamByName('DESCRICAO').Value := DESCRICAO;
            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM TIPO_PAGAMENTO');
            active := true;

            ID_PAGAMENTO := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar tipo de pagamento: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelPayment.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_PAGAMENTO <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. tipo pagamento';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE TIPO_PAGAMENTO SET DESCRICAO=:DESCRICAO');
            SQL.Add('WHERE ID=:ID');
            ParamByName('DESCRICAO').Value := DESCRICAO;
            ParamByName('ID').Value := ID_PAGAMENTO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar tipo de pagamento: ' + ex.Message;
            Result := false;
        end;
    end;

end;

end.
