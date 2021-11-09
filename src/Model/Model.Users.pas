unit Model.Users;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelUsers = class
    private
     FID_USUARIO : Integer;
     FNOME : String;
     FUSUARIO : String;
     FSENHA : String;
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
     FTIPO: String;
     FSTATUS: String;
    public
     constructor Create;
     destructor Destroy; override;
     property ID_USUARIO: Integer read FID_USUARIO write FID_USUARIO;
     property NOME: String read FNOME write FNOME;
     property USUARIO: String read FUSUARIO write FUSUARIO;
     property SENHA: String read FSENHA write FSENHA;
     property EMAIL: String read FEMAIL write FEMAIL;
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
     property TIPO: String read FTIPO write FTIPO;
     property STATUS: String read FSTATUS write FSTATUS;

     function getUsers(order_by: String; out erro:String): TFDQuery;
     function insert(out erro: String): Boolean;
     function delete(out erro: String): Boolean;
     function update(out erro: String): Boolean;
  end;

implementation

{ TModelUsers }

constructor TModelUsers.Create;
begin
Model.Connection.Connect;
end;

function TModelUsers.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM USUARIOS WHERE ID=:ID');
            ParamByName('ID').Value := ID_USUARIO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir usuario: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelUsers.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelUsers.getUsers(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM USUARIOS WHERE 1 = 1');

         if ID_USUARIO > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_USUARIO;
         end;

         if order_by = '' then
            SQL.Add('ORDER BY NOME')
         else
            SQL.Add('ORDER BY' + order_by);

         Active := True;
       end;

       erro := '';
       Result := qry;

     except on ex:exception do
       begin
         erro := 'Erro ao consultar usuarios' + ex.Message;
         Result := nil;
       end;
     end;


end;

function TModelUsers.insert(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if NOME.IsEmpty then
    begin
        Result := false;
        erro := 'Informe o nome do cliente';
        exit;
    end;

    if CELULAR.IsEmpty then
    begin
      Result := false;
      erro := 'Informe o celular do cliente';
      exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO USUARIOS(NOME, USUARIO, SENHA, EMAIL, TELEFONE, CELULAR, CEP, TIPO_LOGRADOURO, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, UF, CIDADE, DATA_CADASTRO, USUARIO_CADASTRO, TIPO, STATUS)');
            SQL.Add('VALUES(:NOME, :USUARIO, :SENHA ,:EMAIL, :TELEFONE, :CELULAR, :CEP, :TIPO_LOGRADOURO, :LOGRADOURO, :NUMERO, :COMPLEMENTO, :BAIRRO, :UF, :CIDADE, :DATA_CADASTRO, :USUARIO_CADASTRO, :TIPO, :STATUS)');

            ParamByName('NOME').Value := NOME;
            ParamByName('USUARIO').Value := USUARIO;
            ParamByName('SENHA').Value := SENHA;
            ParamByName('EMAIL').Value := EMAIL;
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
            ParamByName('TIPO').Value := TIPO;
            ParamByName('STATUS').Value := STATUS;

            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM USUARIOS');
            active := true;

            ID_USUARIO := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar usuario: ' + ex.Message;
            Result := false;
        end;
    end;


end;

function TModelUsers.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_USUARIO <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. usuario';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE USUARIOS SET NOME=:NOME, USUARIO=:USUARIO, SENHA=:SENHA,EMAIL=:EMAIL, TELEFONE=:TELEFONE, CELULAR=:CELULAR, CEP=:CEP, TIPO_LOGRADOURO=:TIPO_LOGRADOURO, LOGRADOURO=:LOGRADOURO, NUMERO=:NUMERO, COMPLEMENTO=:COMPLEMENTO, BAIRRO=:BAIRRO,');
            sql.Add('UF=:UF, CIDADE=:CIDADE, DATA_ALTERACAO=:DATA_ALTERACAO, USUARIO_CADASTRO=:USUARIO_CADASTRO, TIPO=:TIPO, STATUS=:STATUS');
            SQL.Add('WHERE ID=:ID');
            ParamByName('NOME').Value := NOME;
            ParamByName('USUARIO').Value := USUARIO;
            ParamByName('SENHA').Value := SENHA;
            ParamByName('EMAIL').Value := EMAIL;
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
            ParamByName('TIPO').Value := TIPO;
            ParamByName('STATUS').Value := STATUS;
            ParamByName('ID').Value := ID_USUARIO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar usuario: ' + ex.Message;
            Result := false;
        end;
    end;

end;

end.
