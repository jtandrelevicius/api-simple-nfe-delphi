unit Model.Product;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelProduct = class
    private
      FID_PRODUTO : Integer;
      FCOD_PRODUTO_FORNECEDOR : String;
      FDESCRICAO : String;
      FVALOR_UNITARIO : Double;
      FFORNECEDOR : String;
      FEAN  : String;
      FCOD_BARRAS : String;
      FUNIDADE : String;
      FNCM   : String;
      FCFOP  : String;
      FQUANTIDADE : Double;
      FICMS_CST : String;
      FICMS_CSON  : String;
      FICMS_PERCENTUAL: Double;
      FICMS_VALOR : Double;
      FPIS_CST  : String;
      FPIS_PERCENTUAL : Double;
      FPIS_VALOR : Double;
      FCOFINS_CST  : String;
      FCOFINS_PERCENTUAL : Double;
      FCOFINS_VALOR : Double;
      FUSUARIO_CADASTRO : String;
      FSTATUS : String;
      FCEST : String;
      FORIGEM : Double;
      FDATA_ALTERACAO: TDateTime;
      FDATA_CADASTRO: TDateTime;
    public
      constructor Create;
      destructor Destroy; override;
      property ID_PRODUTO : Integer read FID_PRODUTO write FID_PRODUTO;
      property COD_PRODUTO_FORNECEDOR: String read FCOD_PRODUTO_FORNECEDOR write FCOD_PRODUTO_FORNECEDOR;
      property DESCRICAO: String read FDESCRICAO write FDESCRICAO;
      property VALOR_UNITARIO : Double read FVALOR_UNITARIO write FVALOR_UNITARIO;
      property FORNECEDOR: String read FFORNECEDOR write FFORNECEDOR;
      property EAN: String read FEAN write FEAN;
      property COD_BARRAS: String read FCOD_BARRAS write FCOD_BARRAS;
      property UNIDADE: String read FUNIDADE write FUNIDADE;
      property NCM: String read FNCM write FNCM;
      property CFOP: String read FCFOP write FCFOP;
      property QUANTIDADE: Double read FQUANTIDADE write FQUANTIDADE;
      property ICMS_CST: String read FICMS_CST write FICMS_CST;
      property ICMS_CSON: String read FICMS_CSON write FICMS_CSON;
      property ICMS_PERCENTUAL: Double read FICMS_PERCENTUAL write FICMS_PERCENTUAL;
      property ICMS_VALOR: Double read FICMS_VALOR write FICMS_VALOR;
      property PIS_CST: String read FPIS_CST write FPIS_CST;
      property PIS_PERCENTUAL: Double read FPIS_PERCENTUAL write FPIS_PERCENTUAL;
      property PIS_VALOR: Double read FPIS_VALOR write FPIS_VALOR;
      property COFINS_CST: String read FCOFINS_CST write FCOFINS_CST;
      property COFINS_PERCENTUAL: Double read FCOFINS_PERCENTUAL write FCOFINS_PERCENTUAL;
      property COFINS_VALOR: Double read FCOFINS_VALOR write FCOFINS_VALOR;
      property DATA_CADASTRO: TDateTime read FDATA_CADASTRO write FDATA_CADASTRO;
      property DATA_ALTERACAO: TDateTime read FDATA_ALTERACAO write FDATA_ALTERACAO;
      property USUARIO_CADASTRO: String read FUSUARIO_CADASTRO write FUSUARIO_CADASTRO;
      property STATUS: String read FSTATUS write FSTATUS;
      property CEST: String read FCEST write FCEST;
      property ORIGEM: Double read FORIGEM write FORIGEM;

      function getProduct(order_by: String; out erro:String): TFDQuery;
      function insert(out erro: String): Boolean;
      function delete(out erro: String): Boolean;
      function update(out erro: String): Boolean;

  end;

implementation

{ TModelProduct }

constructor TModelProduct.Create;
begin
Model.Connection.Connect;
end;

function TModelProduct.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM PRODUTOS WHERE ID=:ID');
            ParamByName('ID').Value := ID_PRODUTO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir produto: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelProduct.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelProduct.getProduct(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM PRODUTOS WHERE 1 = 1');

         if ID_PRODUTO > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_PRODUTO;
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
         erro := 'Erro ao consultar produtos' + ex.Message;
         Result := nil;
       end;
     end;

end;

function TModelProduct.insert(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if DESCRICAO.IsEmpty then
    begin
        Result := false;
        erro := 'Informe a decricao do produto';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO PRODUTOS(COD_PRODUTO_FORNECEDOR, DESCRICAO, VALOR_UNITARIO, FORNECEDOR, EAN, COD_BARRAS, UNIDADE, NCM, CFOP, QUANTIDADE, ICMS_CST, ICMS_CSON, ICMS_PERCENTUAL, ICMS_VALOR, PIS_CST, PIS_PERCENTUAL, PIS_VALOR,');
            SQL.Add('COFINS_CST, COFINS_PERCENTUAL, COFINS_VALOR, DATA_CADASTRO, USUARIO_CADASTRO, STATUS, CEST, ORIGEM)');
            SQL.Add('VALUES(:COD_PRODUTO_FORNECEDOR, :DESCRICAO, :VALOR_UNITARIO, :FORNECEDOR, :EAN, :COD_BARRAS, :UNIDADE, :NCM, :CFOP, :QUANTIDADE, :ICMS_CST, :ICMS_CSON, :ICMS_PERCENTUAL, :ICMS_VALOR, :PIS_CST, :PIS_PERCENTUAL, :PIS_VALOR,');
            SQL.Add(':COFINS_CST, :COFINS_PERCENTUAL, :COFINS_VALOR, :DATA_CADASTRO, :USUARIO_CADASTRO, :STATUS, :CEST, :ORIGEM)');
            ParamByName('COD_PRODUTO_FORNECEDOR').Value := COD_PRODUTO_FORNECEDOR;
            ParamByName('DESCRICAO').Value := DESCRICAO;
            ParamByName('VALOR_UNITARIO').Value := VALOR_UNITARIO;
            ParamByName('FORNECEDOR').Value := FORNECEDOR;
            ParamByName('EAN').Value := EAN;
            ParamByName('COD_BARRAS').Value := COD_BARRAS;
            ParamByName('UNIDADE').Value := UNIDADE;
            ParamByName('NCM').Value := NCM;
            ParamByName('CFOP').Value := CFOP;
            ParamByName('QUANTIDADE').Value := QUANTIDADE;
            ParamByName('ICMS_CST').Value := ICMS_CST;
            ParamByName('ICMS_CSON').Value := ICMS_CSON;
            ParamByName('ICMS_PERCENTUAL').Value := ICMS_PERCENTUAL;
            ParamByName('ICMS_VALOR').Value := ICMS_VALOR;
            ParamByName('PIS_CST').Value := PIS_CST;
            ParamByName('PIS_PERCENTUAL').Value := PIS_PERCENTUAL;
            ParamByName('PIS_VALOR').Value := PIS_VALOR;
            ParamByName('COFINS_CST').Value := COFINS_CST;
            ParamByName('COFINS_PERCENTUAL').Value := COFINS_PERCENTUAL;
            ParamByName('COFINS_VALOR').Value := COFINS_VALOR;
            ParamByName('DATA_CADASTRO').Value := Now;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('STATUS').Value := STATUS;
            ParamByName('CEST').Value := CEST;
            ParamByName('ORIGEM').Value := ORIGEM;
            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM PRODUTOS');
            SQL.Add('WHERE DESCRICAO=:DESCRICAO');
            ParamByName('DESCRICAO').Value := DESCRICAO;
            active := true;

            ID_PRODUTO := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar produto: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelProduct.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_PRODUTO <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. produto';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE PRODUTOS SET COD_PRODUTO_FORNECEDOR=:COD_PRODUTO_FORNECEDOR, DESCRICAO=:DESCRICAO, VALOR_UNITARIO=:VALOR_UNITARIO, FORNECEDOR=:FORNECEDOR, EAN=:EAN, COD_BARRAS=:COD_BARRAS,');
            SQL.Add('UNIDADE=:UNIDADE, NCM=:NCM, CFOP=:CFOP, QUANTIDADE=:QUANTIDADE, ICMS_CST=:ICMS_CST, ICMS_CSON=:ICMS_CSON, ICMS_PERCENTUAL=:ICMS_PERCENTUAL, ICMS_VALOR=:ICMS_VALOR,');
            SQL.Add('PIS_CST=:PIS_CST, PIS_PERCENTUAL=:PIS_PERCENTUAL, PIS_VALOR=:PIS_VALOR, COFINS_CST=:COFINS_CST, COFINS_PERCENTUAL=:COFINS_PERCENTUAL, COFINS_VALOR=:COFINS_VALOR, USUARIO_CADASTRO=:USUARIO_CADASTRO, STATUS=:STATUS, CEST=:CEST, ORIGEM=:ORIGEM');
            SQL.Add('WHERE ID=:ID');
            ParamByName('COD_PRODUTO_FORNECEDOR').Value := COD_PRODUTO_FORNECEDOR;
            ParamByName('DESCRICAO').Value := DESCRICAO;
            ParamByName('VALOR_UNITARIO').Value := VALOR_UNITARIO;
            ParamByName('FORNECEDOR').Value := FORNECEDOR;
            ParamByName('EAN').Value := EAN;
            ParamByName('COD_BARRAS').Value := COD_BARRAS;
            ParamByName('UNIDADE').Value := UNIDADE;
            ParamByName('NCM').Value := NCM;
            ParamByName('CFOP').Value := CFOP;
            ParamByName('QUANTIDADE').Value := QUANTIDADE;
            ParamByName('ICMS_CST').Value := ICMS_CST;
            ParamByName('ICMS_CSON').Value := ICMS_CSON;
            ParamByName('ICMS_PERCENTUAL').Value := ICMS_PERCENTUAL;
            ParamByName('ICMS_VALOR').Value := ICMS_VALOR;
            ParamByName('PIS_CST').Value := PIS_CST;
            ParamByName('PIS_PERCENTUAL').Value := PIS_PERCENTUAL;
            ParamByName('PIS_VALOR').Value := PIS_VALOR;
            ParamByName('COFINS_CST').Value := COFINS_CST;
            ParamByName('COFINS_PERCENTUAL').Value := COFINS_PERCENTUAL;
            ParamByName('COFINS_VALOR').Value := COFINS_VALOR;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('STATUS').Value := STATUS;
            ParamByName('CEST').Value := CEST;
            ParamByName('ORIGEM').Value := ORIGEM;
            ParamByName('ID').Value := ID_PRODUTO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar cliente: ' + ex.Message;
            Result := false;
        end;
    end;


end;

end.
