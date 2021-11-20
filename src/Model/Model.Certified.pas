unit Model.Certified;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client, System.SysUtils, Model.Connection;


  type
    TModelCertified = class
      private
        FDATA_CADASTRO: TDateTime;
        FID_SENHA: String;
        FID_TOKEN: String;
        FID_AMBIENTE: String;
        FNUMERO_TOKEN: String;
        FCERTIFICADO: TBlobType;
      public
        constructor Create;
        destructor Destroy; override;
        property DATA_CADASTRO: TDateTime read FDATA_CADASTRO write FDATA_CADASTRO;
        property CERTIFICADO: TBlobType read FCERTIFICADO write FCERTIFICADO;
        property SENHA: String read FID_SENHA write FID_SENHA;
        property AMBIENTE: String read FID_AMBIENTE write FID_AMBIENTE;
        property ID_TOKEN: String read FID_TOKEN write FID_TOKEN;
        property NUMERO_TOKEN: String read FNUMERO_TOKEN write FNUMERO_TOKEN;
        function getCertified(out erro:String): TFDQuery;
    end;

implementation

{ TModelCertified }

constructor TModelCertified.Create;
begin
Model.Connection.Connect;
end;

destructor TModelCertified.Destroy;
begin
Model.Connection.Disconnect;
end;

function TModelCertified.getCertified(out erro: String): TFDQuery;
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
         SQL.Add('SELECT * FROM CERTIFICADO');
         Active := True;
       end;

       erro := '';
       Result := qry;

     except on ex:exception do
       begin
         erro := 'Erro ao consultar certificado' + ex.Message;
         Result := nil;
       end;
     end


end;

end.
