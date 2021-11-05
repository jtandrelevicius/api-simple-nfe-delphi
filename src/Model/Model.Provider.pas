unit Model.Provider;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelProvider = class
    private
     FID_FORNECEDOR : Integer;
     FEMAIL: String;
     FTELEFONE: String;
     FCELULAR: String;
     FCEP: String;
     FTIPO_LOGRADOURO: String;
     FLOGRADOURO: String;
     FNUMERO: String;
     FCOMPLEMENTO: String;
     FBAIRRO: String;
     FUF: String;
     FCIDADE: String;
     FDATA_CADASTRO: TDateTime;
     FDATA_ALTERACAO: TDateTime;
     FUSUARIO_CADASTRO: String;
     FSTATUS: String;
     FCNPJ: String;
     FRAZAO_SOCIAL: String;
     FIE: String;
     FNOME_FANTASIA: String;
     FCONTATO: String;
    public
     constructor Create;
     destructor Destroy; override;
     property ID_FORNECEDOR: Integer read FID_FORNECEDOR write FID_FORNECEDOR;
     property NOME_FANTASIA: String read FNOME_FANTASIA write FNOME_FANTASIA;
     property RAZAO_SOCIAL: String read FRAZAO_SOCIAL write FRAZAO_SOCIAL;
     property IE: String read FIE write FIE;
     property CNPJ: String read FCNPJ write FCNPJ;
     property EMAIL: String read FEMAIL write FEMAIL;
     property CONTATO: String read FCONTATO write FCONTATO;
     property TELEFONE: String read FTELEFONE write FTELEFONE;
     property CELULAR: String read FCELULAR write FCELULAR;
     property CEP: String read FCEP write FCEP;
     property TIPO_LOGRADOURO: String read FTIPO_LOGRADOURO write FTIPO_LOGRADOURO;
     property LOGRADOURO: String read FLOGRADOURO write FLOGRADOURO;
     property NUMERO: String read FNUMERO write FNUMERO;
     property COMPLEMENTO: String read FCOMPLEMENTO write FCOMPLEMENTO;
     property BAIRRO: String read FBAIRRO write FBAIRRO;
     property UF: String read FUF write FUF;
     property CIDADE: String read FCIDADE write FCIDADE;
     property DATA_CADASTRO: TDateTime read FDATA_CADASTRO write FDATA_CADASTRO;
     property DATA_ALTERACAO: TDateTime read FDATA_ALTERACAO write FDATA_ALTERACAO;
     property USUARIO_CADASTRO: String read FUSUARIO_CADASTRO write FUSUARIO_CADASTRO;
     property STATUS: String read FSTATUS write FSTATUS;

     function getProvider(order_by: String; out erro:String): TFDQuery;
     function insert(out erro: String): Boolean;
     function delete(out erro: String): Boolean;
     function update(out erro: String): Boolean;

  end;

implementation

{ TModelProvider }

constructor TModelProvider.Create;
begin
 Model.Connection.Connect;
end;

function TModelProvider.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM FORNECEDOR WHERE ID=:ID');
            ParamByName('ID').Value := ID_FORNECEDOR;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir fornecedor: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelProvider.Destroy;
begin
 Model.Connection.Disconnect;
end;

function TModelProvider.getProvider(order_by: String;
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
         SQL.Add('SELECT * FROM FORNECEDOR WHERE 1 = 1');

         if ID_FORNECEDOR > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_FORNECEDOR;
         end;

         if order_by = '' then
            SQL.Add('ORDER BY NOME_FANTASIA')
         else
            SQL.Add('ORDER BY' + order_by);

         Active := True;
       end;

       erro := '';
       Result := qry;

     except on ex:exception do
       begin
         erro := 'Erro ao consultar fornecedor' + ex.Message;
         Result := nil;
       end;
     end;


end;

function TModelProvider.insert(out erro: String): Boolean;
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
            SQL.Add('INSERT INTO FORNECEDOR(NOME_FANTASIA, RAZAO_SOCIAL, IE, CNPJ, EMAIL, CONTATO, TELEFONE, CELULAR, CEP, TIPO_LOGRADOURO, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, UF, CIDADE, DATA_CADASTRO, USUARIO_CADASTRO, STATUS)');
            SQL.Add('VALUES(:NOME_FANTASIA, :RAZAO_SOCIAL, :IE, :CNPJ, :EMAIL, :CONTATO, :TELEFONE, :CELULAR, :CEP, :TIPO_LOGRADOURO, :LOGRADOURO, :NUMERO, :COMPLEMENTO, :BAIRRO, :UF, :CIDADE, :DATA_CADASTRO, :USUARIO_CADASTRO, :STATUS)');

            ParamByName('NOME_FANTASIA').Value := NOME_FANTASIA;
            ParamByName('RAZAO_SOCIAL').Value := RAZAO_SOCIAL;
            ParamByName('IE').Value := IE;
            ParamByName('CNPJ').Value := CNPJ;
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('CONTATO').Value := CONTATO;
            ParamByName('TELEFONE').Value := TELEFONE;
            ParamByName('CELULAR').Value := CELULAR;
            ParamByName('CEP').Value := CEP;
            ParamByName('TIPO_LOGRADOURO').Value := TIPO_LOGRADOURO;
            ParamByName('LOGRADOURO').Value := LOGRADOURO;
            ParamByName('NUMERO').Value := NUMERO;
            ParamByName('COMPLEMENTO').Value := COMPLEMENTO;
            ParamByName('BAIRRO').Value := BAIRRO;
            ParamByName('UF').Value := UF;
            ParamByName('CIDADE').Value := CIDADE;
            ParamByName('DATA_CADASTRO').Value := Now;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('STATUS').Value := STATUS;

            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM FORNECEDOR');
            active := true;

            ID_FORNECEDOR := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar fornecedor: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelProvider.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_FORNECEDOR <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. fornecedor';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE FORNECEDOR SET NOME_FANTASIA=:NOME_FANTASIA, RAZAO_SOCIAL=:RAZAO_SOCIAL, IE=:IE, CNPJ=:CNPJ EMAIL=:EMAIL, CONTATO=:CONTATO TELEFONE=:TELEFONE, CELULAR=:CELULAR, CEP=:CEP, TIPO_LOGRADOURO=:TIPO_LOGRADOURO,');
            sql.Add('LOGRADOURO=:LOGRADOURO, NUMERO=:NUMERO, COMPLEMENTO=:COMPLEMENTO, BAIRRO=:BAIRRO, UF=:UF, CIDADE=:CIDADE, DATA_ALTERACAO=:DATA_ALTERACAO, USUARIO_CADASTRO=:USUARIO_CADASTRO, STATUS=:STATUS');
            SQL.Add('WHERE ID=:ID');
            ParamByName('NOME_FANTASIA').Value := NOME_FANTASIA;
            ParamByName('RAZAO_SOCIAL').Value := RAZAO_SOCIAL;
            ParamByName('IE').Value := IE;
            ParamByName('CNPJ').Value := CNPJ;
            ParamByName('EMAIL').Value := EMAIL;
            ParamByName('CONTATO').Value := CONTATO;
            ParamByName('TELEFONE').Value := TELEFONE;
            ParamByName('CELULAR').Value := CELULAR;
            ParamByName('CEP').Value := CEP;
            ParamByName('TIPO_LOGRADOURO').Value := TIPO_LOGRADOURO;
            ParamByName('LOGRADOURO').Value := LOGRADOURO;
            ParamByName('NUMERO').Value := NUMERO;
            ParamByName('COMPLEMENTO').Value := COMPLEMENTO;
            ParamByName('BAIRRO').Value := BAIRRO;
            ParamByName('UF').Value := UF;
            ParamByName('CIDADE').Value := CIDADE;
            ParamByName('DATA_ALTERACAO').Value := Now;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('STATUS').Value := STATUS;
            ParamByName('ID').Value := ID_FORNECEDOR;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar fornecedor: ' + ex.Message;
            Result := false;
        end;
    end;


end;

end.
