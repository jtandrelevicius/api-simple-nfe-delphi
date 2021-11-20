unit Model.NFE;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;


  type
    TModelNFE = class
      private
        FID_VENDA: Integer;
        FDATA_CADASTRO: TDate;
        FCHAVE_NFE: String;
        FID_CLIENTE: Integer;
        FSTATUS: String;
        FHORA_CADASTRO: TTime;
        FID_EMPRESA: Integer;
        FTERMINAL: String;
        FID_NFE: Integer;
        FUSUARIO_CADASTRO: String;
      public
        constructor Create;
        destructor Destroy; override;
        property ID_NFE: Integer read FID_NFE write FID_NFE;
        property ID_VENDA: Integer read FID_VENDA write FID_VENDA;
        property ID_EMPRESA: Integer read FID_EMPRESA write FID_EMPRESA;
        property ID_CLIENTE: Integer read FID_CLIENTE write FID_CLIENTE;
        property DATA_CADASTRO: TDate read FDATA_CADASTRO write FDATA_CADASTRO;
        property HORA_CADASTRO: TTime read FHORA_CADASTRO write FHORA_CADASTRO;
        property STATUS: String read FSTATUS write FSTATUS;
        property USUARIO_CADASTRO: String read FUSUARIO_CADASTRO write FUSUARIO_CADASTRO;
        property TERMINAL: String read FTERMINAL write FTERMINAL;
        property CHAVE_NFE: String read FCHAVE_NFE write FCHAVE_NFE;

        function getNFe(order_by: String; out erro:String): TFDQuery;
        function insert(out erro: String): Boolean;
        function cancel(out erro: String): Boolean;
        function update(out erro: String): Boolean;
        function changeNunNfe(change: String; out erro: String):Boolean;
    end;

implementation

{ TModelNFE }

function TModelNFE.changeNunNfe(change: String; out erro: String): Boolean;
var
    qry : TFDQuery;
begin

  if change <> '' then
  begin
       try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('ALTER SEQUENCE GEN_ID_NFE RESTART WITH ' + change + ';');
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar ultima nfe: ' + ex.Message;
            Result := false;
        end;
    end;
  end
  else
  begin
    Result := false;
    erro := 'Informe a ultima nfe';
    exit;
  end;

end;

constructor TModelNFE.Create;
begin
Model.Connection.Connect;
end;

function TModelNFE.cancel(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_NFE <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. nfe';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE NFE SET STATUS=:STATUS');
            SQL.Add('WHERE ID=:ID');
            ParamByName('STATUS').Value := 'CANCELADA';
            ParamByName('ID').Value := ID_NFE;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cancelar nfe: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelNFE.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelNFE.getNFe(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM NFE WHERE 1 = 1');

         if ID_NFE > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_NFE;
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
         erro := 'Erro ao consultar nfe' + ex.Message;
         Result := nil;
       end;
     end

end;

function TModelNFE.insert(out erro: String): Boolean;
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
            SQL.Add('INSERT INTO NFE(ID_VENDA, ID_CLIENTE, ID_EMPRESA, DATA_CADASTRO, HORA_CADASTRO, STATUS, USUARIO_CADASTRO, TERMINAL)');
            SQL.Add('VALUES(:ID_VENDA, :ID_CLIENTE, :ID_EMPRESA, :DATA_CADASTRO, :HORA_CADASTRO, :STATUS, :USUARIO_CADASTRO, :TERMINAL)');

            ParamByName('ID_VENDA').Value := ID_VENDA;
            ParamByName('ID_CLIENTE').Value := ID_CLIENTE;
            ParamByName('ID_EMPRESA').Value := ID_EMPRESA;
            ParamByName('DATA_CADASTRO').Value := Date;
            ParamByName('HORA_CADASTRO').Value := Time;
            ParamByName('STATUS').Value := STATUS;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('TERMINAL').Value := TERMINAL;
            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM NFE');
            active := true;

            ID_NFE := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar nfe no banco de dados: ' + ex.Message;
            Result := false;
        end;
    end;


end;

function TModelNFE.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_NFE <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. nfe';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE NFE SET CHAVE_NFE=:CHAVE_NFE');
            SQL.Add('WHERE ID=:ID');
            ParamByName('CHAVE_NFE').Value := CHAVE_NFE;
            ParamByName('ID').Value := ID_NFE;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar chave nfe: ' + ex.Message;
            Result := false;
        end;
    end;

end;

end.
