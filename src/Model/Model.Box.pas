unit Model.Box;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelBox = class
    private
      FID_CAIXA: Integer;
      FVALOR_ABERTURA: Double;
      FDATA_ABERTURA: TDate;
      FHORA_ABERTURA: TTime;
      FUSUARIO_ABERTURA: String;
      FOPERADOR: String;
      FTERMINAL: String;
      FVALOR_FECHAMENTO : Double;
      FDATA_FECHAMENTO: TDate;
      FHORA_FECHAMENTO: TTime;
      FUSUARIO_FECHAMENTO: String;
      FSTATUS: String;
    public
      constructor Create;
      destructor Destroy;override;
      property ID_CAIXA: Integer read FID_CAIXA write FID_CAIXA;
      property VALOR_ABERTURA: Double read FVALOR_ABERTURA write FVALOR_ABERTURA;
      property DATA_ABERTURA: TDate read FDATA_ABERTURA write FDATA_ABERTURA;
      property HORA_ABERTURA: TTime read FHORA_ABERTURA write FHORA_ABERTURA;
      property USUARIO_ABERTURA: String read FUSUARIO_ABERTURA write FUSUARIO_ABERTURA;
      property OPERADOR: String read FOPERADOR write FOPERADOR;
      property TERMINAL: String read FTERMINAL write FTERMINAL;
      property VALOR_FECHAMENTO: Double read FVALOR_FECHAMENTO write FVALOR_FECHAMENTO;
      property DATA_FECHAMENTO: TDate read FDATA_FECHAMENTO write FDATA_FECHAMENTO;
      property HORA_FECHAMENTO: TTime read FHORA_FECHAMENTO write FHORA_FECHAMENTO;
      property USUARIO_FECHAMENTO: String read FUSUARIO_FECHAMENTO write FUSUARIO_FECHAMENTO;
      property STATUS: String read FSTATUS write FSTATUS;

      function getBox(order_by: String; out erro:String): TFDQuery;
      function insert(out erro: String): Boolean;
      function delete(out erro: String): Boolean;
      function update(out erro: String): Boolean;
  end;

implementation

{ TModelBox }

constructor TModelBox.Create;
begin
Model.Connection.Connect;
end;

function TModelBox.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM CAIXA WHERE ID=:ID');
            ParamByName('ID').Value := ID_CAIXA;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir caixa: ' + ex.Message;
            Result := false;
        end;
    end;
end;

destructor TModelBox.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelBox.getBox(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM CAIXA WHERE 1 = 1');

         if ID_CAIXA > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_CAIXA;
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
         erro := 'Erro ao consultar caixa' + ex.Message;
         Result := nil;
       end;
     end;

end;

function TModelBox.insert(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
   // if NOME.IsEmpty then
   // begin
       // Result := false;
      //  erro := 'Informe o nome do cliente';
     //   exit;
   // end;



    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO CAIXA(VALOR_ABERTURA, DATA_ABERTURA, HORA_ABERTURA, USUARIO_ABERTURA, OPERADOR, TERMINAL, STATUS)');
            SQL.Add('VALUES(:VALOR_ABERTURA, :DATA_ABERTURA, :HORA_ABERTURA, :USUARIO_ABERTURA, :OPERADOR, :TERMINAL, :STATUS)');

            ParamByName('VALOR_ABERTURA').Value := VALOR_ABERTURA;
            ParamByName('DATA_ABERTURA').Value := Date;
            ParamByName('HORA_ABERTURA').Value := Time;
            ParamByName('USUARIO_ABERTURA').Value := USUARIO_ABERTURA;
            ParamByName('OPERADOR').Value := OPERADOR;
            ParamByName('TERMINAL').Value := TERMINAL;
            ParamByName('STATUS').Value := 'A';
            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM CAIXA');
            active := true;

            ID_CAIXA := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar caixa: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelBox.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_CAIXA <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. caixa';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE CAIXA SET VALOR_FECHAMENTO=:VALOR_FECHAMENTO, DATA_FECHAMENTO=:DATA_FECHAMENTO, HORA_FECHAMENTO=:HORA_FECHAMENTO, USUARIO_FECHAMENTO:=USUARIO_FECHAMENTO, STATUS=:STATUS)');
            SQL.Add('WHERE 1 = 1');

            SQL.Add('AND ID = :ID');
            ParamByName('ID').Value:= ID_CAIXA;

            SQL.Add('AND TERMINAL = :TERMINAL');
            ParamByName('TERMINAL').Value:= TERMINAL;

            SQL.Add('AND OPERADOR = :OPERADOR');
            ParamByName('OPERADOR').Value:= OPERADOR;

            //CRIAR VALIDADOR SE O CAIXA JA ESTA ABERTO OU NAO

            ParamByName('VALOR_FECHAMENTO').Value := VALOR_FECHAMENTO;
            ParamByName('DATA_FECHAMENTO').Value := Date;
            ParamByName('HORA_FECHAMENTO').Value := Time;
            ParamByName('USUARIO_FECHAMENTO').Value := USUARIO_FECHAMENTO;
            ParamByName('STATUS').Value := 'F';
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar caixa: ' + ex.Message;
            Result := false;
        end;
    end;

end;

end.
