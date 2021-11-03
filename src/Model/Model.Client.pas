unit Model.Client;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;

type
  TModelClient = class
    private
     FID_CLIENTE : Integer;
     FNOME : String;
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
     FCPF_CNPJ: String;
     FSTATUS: String;
    public
     constructor Create;
     destructor Destroy; override;
     property ID_CLIENTE: Integer read FID_CLIENTE write FID_CLIENTE;
     property NOME: String read FNOME write FNOME;
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
     property CPF_CNPJ: String read FCPF_CNPJ write FCPF_CNPJ;
     property STATUS: String read FSTATUS write FSTATUS;

     function getClient(order_by: String; out erro:String): TFDQuery;
     function insert(out erro: String): Boolean;
     function delete(out erro: String): Boolean;
  end;


implementation

{ TModelClient }

constructor TModelClient.Create;
begin
Model.Connection.Connect;
end;

function TModelClient.delete(out erro: String): Boolean;
begin

end;

destructor TModelClient.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelClient.getClient(order_by: String; out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM CLIENTES WHERE 1 = 1');

         if ID_CLIENTE > 0 then
         begin
           SQL.Add('AND ID = :ID');
           ParamByName('ID').Value:= ID_CLIENTE;
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
         erro := 'Erro ao consultar clientes' + ex.Message;
         Result := nil;
       end;
     end;

end;

function TModelClient.insert(out erro: String): Boolean;
begin

end;

end.
