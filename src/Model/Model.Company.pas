unit Model.Company;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;


type
  TModelCompany = class
    private
      FLOGRADOURO: String;
      FFONE: String;
      FFANTASIA: String;
      FCNPJ: String;
      FBAIRRO: String;
      FUSUARIO_CADASTRO: String;
      FUF: String;
      FDATA_CADASTRO: TDate;
      FIE_ESTADUAL: String;
      FCEP: String;
      FNUMERO: String;
      FIE: String;
      FMUNICIPIO: String;
      FCOMPLEMENTO: String;
      FID_EMPRESA: Integer;
      FNOME: String;
      FCRT: String;
      FCOD_MUNICIPIO: String;
    public
      constructor Create;
      destructor Destroy; override;
      property ID_EMPRESA: Integer read FID_EMPRESA write FID_EMPRESA;
      property CNPJ: String read FCNPJ write FCNPJ;
      property IE: String read FIE write FIE;
      property NOME: String read FNOME write FNOME;
      property FANTASIA: String read FFANTASIA write FFANTASIA;
      property FONE: String read FFONE write FFONE;
      property CEP: String read FCEP write FCEP;
      property LOGRADOURO: String read FLOGRADOURO write FLOGRADOURO;
      property NUMERO: String read FNUMERO write FNUMERO;
      property COMPLEMENTO: String read FCOMPLEMENTO write FCOMPLEMENTO;
      property BAIRRO: String read FBAIRRO write FBAIRRO;
      property COD_MUNICIPIO: String read FCOD_MUNICIPIO write FCOD_MUNICIPIO;
      property MUNICIPIO: String read FMUNICIPIO write FMUNICIPIO;
      property UF: String read FUF write FUF;
      property IE_ESTADUAL: String read FIE_ESTADUAL write FIE_ESTADUAL;
      property CRT: String read FCRT write FCRT;
      property DATA_CADASTRO: TDate read FDATA_CADASTRO write FDATA_CADASTRO;
      property USUARIO_CADASTRO: String read FUSUARIO_CADASTRO write FUSUARIO_CADASTRO;

      function getCompany(order_by: String; out erro:String): TFDQuery;
      function insert(out erro: String): Boolean;
      function delete(out erro: String): Boolean;
      function update(out erro: String): Boolean;
  end;

implementation

{ TModelCompany }

constructor TModelCompany.Create;
begin
Model.Connection.Connect;
end;

function TModelCompany.delete(out erro: String): Boolean;
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
            SQL.Add('DELETE FROM EMPRESA WHERE ID=:ID');
            ParamByName('ID').Value := ID_EMPRESA;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir empresa: ' + ex.Message;
            Result := false;
        end;
    end;

end;

destructor TModelCompany.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelCompany.getCompany(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM EMPRESA WHERE 1 = 1');

         if ID_EMPRESA > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_EMPRESA;
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
         erro := 'Erro ao consultar empresa' + ex.Message;
         Result := nil;
       end;
     end;


end;

function TModelCompany.insert(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if NOME.IsEmpty then
    begin
        Result := false;
        erro := 'Informe o raza social da empresa';
        exit;
    end;

    if CNPJ.IsEmpty then
    begin
      Result := false;
      erro := 'Informe o CNPJ da empresa';
      exit;
    end;

    if IE.IsEmpty then
    begin
      Result := false;
      erro := 'Informe o IE da empresa';
      exit;
    end;

    if FANTASIA.IsEmpty then
    begin
      Result := false;
      erro := 'Informe o nome fantasia da empresa';
      exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO EMPRESA(CNPJ, IE, NOME, FANTASIA, FONE, CEP, LOGRADOURO, NUMERO, COMPLEMENTO, BAIRRO, COD_MUNICIPIO, MUNICIPIO, UF, IE_ESTADUAL, CRT, DATA_CADASTRO, USUARIO_CADASTRO)');
            SQL.Add('VALUES(:CNPJ, :IE, :NOME, :FANTASIA, :FONE, :CEP, :LOGRADOURO, :NUMERO, :COMPLEMENTO, :BAIRRO, :COD_MUNICIPIO, :MUNICIPIO, :UF, :IE_ESTADUAL, :CRT, :DATA_CADASTRO, :USUARIO_CADASTRO)');
            ParamByName('CNPJ').Value := CNPJ;
            ParamByName('IE').Value := IE;
            ParamByName('NOME').Value := NOME;
            ParamByName('FANTASIA').Value := FANTASIA;
            ParamByName('FONE').Value := FONE;
            ParamByName('CEP').Value := CEP;
            ParamByName('LOGRADOURO').Value := LOGRADOURO;
            ParamByName('NUMERO').Value := NUMERO;
            ParamByName('COMPLEMENTO').Value := COMPLEMENTO;
            ParamByName('BAIRRO').Value := BAIRRO;
            ParamByName('COD_MUNICIPIO').Value := COD_MUNICIPIO;
            ParamByName('MUNICIPIO').Value := MUNICIPIO;
            ParamByName('UF').Value := UF;
            ParamByName('IE_ESTADUAL').Value := IE_ESTADUAL;
            ParamByName('CRT').Value := CRT;
            ParamByName('DATA_CADASTRO').Value := Now;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(ID) AS ID FROM EMPRESA');
            active := true;

            ID_EMPRESA := FieldByName('ID').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar cliente: ' + ex.Message;
            Result := false;
        end;
    end;

end;

function TModelCompany.update(out erro: String): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if ID_EMPRESA <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. cliente';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE EMPRESA SET CNPJ=:CNPJ, IE=:IE, NOME=:NOME, FANTASIA=:FANTASIA, FONE=:FONE, CEP=:CEP, LOGRADOURO=:LOGRADOURO, NUMERO=:NUMERO, COMPLEMENTO=:COMPLEMENTO, BAIRRO=:BAIRRO,');
            sql.Add('COD_MUNICIPIO=:COD_MUNICIPIO, MUNICIPIO=:MUNICIPIO, UF=:UF, IE_ESTADUAL=:IE_ESTADUAL, CRT=:CRT, DATA_CADASTRO=:DATA_CADASTRO, USUARIO_CADASTRO=:USUARIO_CADASTRO');
            SQL.Add('WHERE ID=:ID');
            ParamByName('CNPJ').Value := CNPJ;
            ParamByName('IE').Value := IE;
            ParamByName('NOME').Value := NOME;
            ParamByName('FANTASIA').Value := FANTASIA;
            ParamByName('FONE').Value := FONE;
            ParamByName('CEP').Value := CEP;
            ParamByName('LOGRADOURO').Value := LOGRADOURO;
            ParamByName('NUMERO').Value := NUMERO;
            ParamByName('COMPLEMENTO').Value := COMPLEMENTO;
            ParamByName('BAIRRO').Value := BAIRRO;
            ParamByName('COD_MUNICIPIO').Value := COD_MUNICIPIO;
            ParamByName('MUNICIPIO').Value := MUNICIPIO;
            ParamByName('UF').Value := UF;
            ParamByName('IE_ESTADUAL').Value := IE_ESTADUAL;
            ParamByName('CRT').Value := CRT;
            ParamByName('DATA_CADASTRO').Value := Now;
            ParamByName('USUARIO_CADASTRO').Value := USUARIO_CADASTRO;
            ParamByName('ID').Value := ID_EMPRESA;
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
