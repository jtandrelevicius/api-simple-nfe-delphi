unit View.NFs;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.FMXUI.Wait, Data.DB,
  FireDAC.Comp.Client, ACBrSocket, ACBrCEP, FireDAC.Comp.DataSet, ACBrDFeReport,
  ACBrDFeDANFeReport, ACBrNFeDANFEClass, ACBrNFeDANFeRLClass, ACBrBase, ACBrDFe,
  ACBrNFe, FireDAC.Phys.FB, FireDAC.Phys.FBDef, FireDAC.Phys.IBBase,
  ACBrNFeNotasFiscais, pcnNFe, pcnConversao, pcnConversaoNFe, ACBrDFeSSL,
  blcksock;

type
  TForm1 = class(TForm)
    NFCe: TACBrNFe;
    NFCeAuto: TACBrNFe;
    NFe: TACBrNFe;
    ACBrNFeDANFeRL1: TACBrNFeDANFeRL;
    FDQueryCLIENTES: TFDQuery;
    FDQueryCLIENTESID: TIntegerField;
    FDQueryCLIENTESNOME: TStringField;
    FDQueryCLIENTESTELEFONE: TStringField;
    FDQueryCLIENTESCELULAR: TStringField;
    FDQueryCLIENTESSTATUS: TStringField;
    FDQueryCLIENTESEMAIL: TStringField;
    FDQueryCLIENTESTIPO_LOGRADOURO: TStringField;
    FDQueryCLIENTESLOGRADOURO: TStringField;
    FDQueryCLIENTESCOMPLEMENTO: TStringField;
    FDQueryCLIENTESBAIRRO: TStringField;
    FDQueryCLIENTESUF: TStringField;
    FDQueryCLIENTESCIDADE: TStringField;
    FDQueryCLIENTESDATA_ALTERACAO: TSQLTimeStampField;
    FDQueryCLIENTESUSUARIO_CADASTRO: TStringField;
    FDQueryCLIENTESCEP: TStringField;
    FDQueryCLIENTESNUMERO: TStringField;
    FDQueryCLIENTESDATA_CADASTRO: TSQLTimeStampField;
    FDQueryCLIENTESCPF_CNPJ: TStringField;
    FDQueryEMPRESA: TFDQuery;
    FDQueryEMPRESAID: TIntegerField;
    FDQueryEMPRESACNPJ: TStringField;
    FDQueryEMPRESAIE: TStringField;
    FDQueryEMPRESANOME: TStringField;
    FDQueryEMPRESAFANTASIA: TStringField;
    FDQueryEMPRESAFONE: TStringField;
    FDQueryEMPRESACEP: TStringField;
    FDQueryEMPRESALOGRADOURO: TStringField;
    FDQueryEMPRESANUMERO: TStringField;
    FDQueryEMPRESACOMPLEMENTO: TStringField;
    FDQueryEMPRESABAIRRO: TStringField;
    FDQueryEMPRESACOD_MUNICIPIO: TStringField;
    FDQueryEMPRESAMUNICIPIO: TStringField;
    FDQueryEMPRESAUF: TStringField;
    FDQueryEMPRESAIE_ESTADUAL: TStringField;
    FDQueryEMPRESACRT: TStringField;
    FDQueryEMPRESADATA_CADASTRO: TDateField;
    FDQueryEMPRESAUSUARIO_CADASTRO: TStringField;
    FDQueryCERTIFICADO: TFDQuery;
    FDQueryCERTIFICADODATA_CADASTRO: TSQLTimeStampField;
    FDQueryCERTIFICADOCERTIFICADO: TBlobField;
    FDQueryCERTIFICADOSENHA: TStringField;
    FDQueryCERTIFICADOAMBIENTE: TStringField;
    FDQueryCERTIFICADOID_TOKEN: TStringField;
    FDQueryCERTIFICADONUMERO_TOKEN: TStringField;
    FDQueryCERTIFICADOULTIMA_NF: TStringField;
    FDQueryNFCE: TFDQuery;
    FDQueryNFCEID: TIntegerField;
    FDQueryNFCEVALOR: TFMTBCDField;
    FDQueryNFCEDESCONTO: TFMTBCDField;
    FDQueryNFCEVALOR_RECEBIDO: TFMTBCDField;
    FDQueryNFCETROCO: TFMTBCDField;
    FDQueryNFCEDATA_CADASTRO: TDateField;
    FDQueryNFCEHORA_CADASTRO: TTimeField;
    FDQueryNFCETIPO_PAGAMENTO: TStringField;
    FDQueryNFCEID_CLIENTE: TIntegerField;
    FDQueryNFCECPF_CNPJ: TStringField;
    FDQueryNFCECELULAR: TStringField;
    FDQueryNFCETERMINAL: TStringField;
    FDQueryNFCECLIENTE: TStringField;
    FDQueryNFCEUSUARIO_CADASTRO: TStringField;
    FDQueryNFCESTATUS: TStringField;
    FDQueryNFCECHAVE_NFE: TStringField;
    ACBrCEP1: TACBrCEP;
    FDConnection1: TFDConnection;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDQueryVENDA: TFDQuery;
    FDQueryVENDA_ITENS: TFDQuery;
    FDQueryNFE: TFDQuery;
    FDQueryVENDAID: TIntegerField;
    FDQueryVENDAID_CLIENTE: TIntegerField;
    FDQueryVENDAID_PAGAMENTO: TIntegerField;
    FDQueryVENDAVALOR: TCurrencyField;
    FDQueryVENDADESCONTO: TCurrencyField;
    FDQueryVENDAVALOR_RECEBIDO: TCurrencyField;
    FDQueryVENDATROCO: TCurrencyField;
    FDQueryVENDADATA_CADASTRO: TDateField;
    FDQueryVENDAHORA_CADASTRO: TTimeField;
    FDQueryVENDAUSUARIO_CADASTRO: TStringField;
    FDQueryVENDASTATUS: TStringField;
    FDQueryVENDA_ITENSID: TIntegerField;
    FDQueryVENDA_ITENSID_VENDA: TIntegerField;
    FDQueryVENDA_ITENSID_PRODUTO: TIntegerField;
    FDQueryVENDA_ITENSPRODUTO: TStringField;
    FDQueryVENDA_ITENSVALOR: TCurrencyField;
    FDQueryVENDA_ITENSTOTAL: TCurrencyField;
    FDQueryVENDA_ITENSQUANTIDADE: TCurrencyField;
    FDQueryVENDA_ITENSUSUARIO_CADASTRO: TStringField;
    FDQueryNFEID: TIntegerField;
    FDQueryNFEID_VENDA: TIntegerField;
    FDQueryNFEID_CLIENTE: TIntegerField;
    FDQueryNFEID_EMPRESA: TIntegerField;
    FDQueryNFEDATA_CADASTRO: TDateField;
    FDQueryNFEHORA_CADASTRO: TTimeField;
    FDQueryNFESTATUS: TStringField;
    FDQueryNFEUSUARIO_CADASTRO: TStringField;
    FDQueryNFETERMINAL: TStringField;
    FDQueryNFECHAVE_NFE: TStringField;
    FDQueryPRODUTOS: TFDQuery;
    FDQueryPRODUTOSID: TIntegerField;
    FDQueryPRODUTOSCOD_BARRAS: TStringField;
    FDQueryPRODUTOSCOD_PRODUTO_FORNECEDOR: TStringField;
    FDQueryPRODUTOSDESCRICAO: TStringField;
    FDQueryPRODUTOSVALOR_UNITARIO: TCurrencyField;
    FDQueryPRODUTOSFORNECEDOR: TStringField;
    FDQueryPRODUTOSSTATUS: TStringField;
    FDQueryPRODUTOSQUANTIDADE: TCurrencyField;
    FDQueryPRODUTOSEAN: TStringField;
    FDQueryPRODUTOSUNIDADE: TStringField;
    FDQueryPRODUTOSNCM: TStringField;
    FDQueryPRODUTOSCFOP: TStringField;
    FDQueryPRODUTOSICMS_CST: TStringField;
    FDQueryPRODUTOSICMS_CSOSN: TStringField;
    FDQueryPRODUTOSICMS_PERCENTUAL: TCurrencyField;
    FDQueryPRODUTOSICMS_VALOR: TCurrencyField;
    FDQueryPRODUTOSPIS_CST: TStringField;
    FDQueryPRODUTOSPIS_PERCENTUAL: TCurrencyField;
    FDQueryPRODUTOSPIS_VALOR: TCurrencyField;
    FDQueryPRODUTOSCOFINS_CST: TStringField;
    FDQueryPRODUTOSCOFINS_PERCENTUAL: TCurrencyField;
    FDQueryPRODUTOSCOFINS_VALOR: TCurrencyField;
    FDQueryPRODUTOSDATA_CADASTRO: TSQLTimeStampField;
    FDQueryPRODUTOSDATA_ALTERACAO: TSQLTimeStampField;
    FDQueryPRODUTOSUSUARIO_CADASTRO: TStringField;
    FDQueryPRODUTOSIMAGEM: TBlobField;
    FDQueryPRODUTOSCEST: TStringField;
    FDQueryPRODUTOSORIGEM: TIntegerField;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure GerarNFe;
    procedure SelectCertificado;
    procedure SelectEmpresa;
    procedure SelectCliente;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ TForm1 }

procedure TForm1.GerarNFe;
var
  I: Integer;
  NotaF: NotaFiscal;
  Item: Integer;
  Produto: TDetCollectionItem;
  InfoPgto: TpagCollectionItem;
  status : string;
  chave_nfe: string;
  id_produto : Integer;
begin

  NFe.NotasFiscais.Clear;
  SelectCertificado;
  NotaF := NFe.NotasFiscais.Add;

  //DADOS DA NOTAFISCAL CABECALHO
  NotaF.NFe.Ide.natOp    := 'VENDA';
  NotaF.NFe.Ide.indPag   := ipVista;
  NotaF.NFe.Ide.modelo   := 55;
  NotaF.NFe.Ide.serie    := 1;
  NotaF.NFe.Ide.nNF      := ID_NFE;
  NotaF.NFe.Ide.dEmi     := Now;
  NotaF.NFe.Ide.dSaiEnt  := Now;
  NotaF.NFe.Ide.hSaiEnt  := Now;
  NotaF.NFe.Ide.tpNF     := tnSaida;
  NotaF.NFe.Ide.tpEmis   := teNormal;
  NotaF.NFe.Ide.tpAmb    := taProducao;
  NotaF.NFe.Ide.verProc  := Versao;
  NotaF.NFe.Ide.cUF      := 50;
  NotaF.NFe.Ide.cMunFG   := 5002704;
  NotaF.NFe.Ide.finNFe   := fnNormal;
  //NotaF.NFe.Ide.tpImp     := tiRetrato;
  NotaF.NFe.Ide.indFinal := cfConsumidorFinal;
  NotaF.NFe.Ide.indPres := pcPresencial;
  if Assigned(NFe.DANFE) then
    NotaF.NFe.Ide.tpImp := NFe.DANFE.TipoDANFE;

  //showmessage('CABECALHO AIDICIONADO CORRETO');
  //DADOS DO EMITENTE
  SelectEmpresa;

   //Showmessage('SELECT DA EMPRESA FEITO');
  NotaF.NFe.Emit.CNPJCPF           := FDQueryEMPRESA.FieldByName('CNPJ').Value;
  NotaF.NFe.Emit.IE                := FDQueryEMPRESA.FieldByName('IE').Value;
  NotaF.NFe.Emit.xNome             := FDQueryEMPRESA.FieldByName('NOME').Value;
  NotaF.NFe.Emit.xFant             := FDQueryEMPRESA.FieldByName('FANTASIA').Value;
  NotaF.NFe.Emit.EnderEmit.fone    := FDQueryEMPRESA.FieldByName('FONE').Value;
  NotaF.NFe.Emit.EnderEmit.CEP     := FDQueryEMPRESA.FieldByName('CEP').Value;
  NotaF.NFe.Emit.EnderEmit.xLgr    := FDQueryEMPRESA.FieldByName('LOGRADOURO').Value;
  NotaF.NFe.Emit.EnderEmit.nro     := FDQueryEMPRESA.FieldByName('NUMERO').Value;
  NotaF.NFe.Emit.EnderEmit.xCpl    := FDQueryEMPRESA.FieldByName('COMPLEMENTO').Value;
  NotaF.NFe.Emit.EnderEmit.xBairro := FDQueryEMPRESA.FieldByName('BAIRRO').Value;
  NotaF.NFe.Emit.EnderEmit.cMun    := FDQueryEMPRESA.FieldByName('COD_MUNICIPIO').Value;
  NotaF.NFe.Emit.EnderEmit.xMun    := FDQueryEMPRESA.FieldByName('MUNICIPIO').Value;
  NotaF.NFe.Emit.EnderEmit.UF      := FDQueryEMPRESA.FieldByName('UF').Value;
  NotaF.NFe.Emit.EnderEmit.cPais   := 1058;
  NotaF.NFe.Emit.EnderEmit.xPais   := 'BRASIL';
  NotaF.NFe.Emit.IEST              := FDQueryEMPRESA.FieldByName('IE_ESTADUAL').Value;
  NotaF.NFe.Emit.CRT               := crtSimplesNacional;// (1-crtSimplesNacional, 2-crtSimplesExcessoReceita, 3-crtRegimeNormal)
  //Showmessage('DADOS EMPRESA PREENCHIDOS');

  // DADOS REPRESENTANTE TECNICO
  NotaF.NFe.infRespTec.CNPJ     := RespTecCNPJ;
  //Showmessage(RespTecCNPJ);
  NotaF.NFe.infRespTec.xContato := RespTecContato;
  //Showmessage(RespTecContato);
  NotaF.NFe.infRespTec.email    := RespTecEmail;
  //Showmessage(RespTecEmail);
  NotaF.NFe.infRespTec.fone     := RespTecFone;
  //Showmessage(RespTecFone);
  //Showmessage('REPRESENTANTE TECNICO');
  if ENTREGA = 'SIM' then
  begin
    // DADOS ENTREGA
    NotaF.NFe.ENTREGA.CNPJCPF := edtCPF_CNPJ.Text;
    NotaF.NFe.ENTREGA.IE      := edtIE.Text;
    NotaF.NFe.ENTREGA.xNome   := edtNOME.Text;
    NotaF.NFe.ENTREGA.xLgr    := edtTIPO.Text + edtESPACO.Text + edtLOGRADOURO.Text;
    NotaF.NFe.ENTREGA.nro     := edtNUMERO.Text;
    NotaF.NFe.ENTREGA.xBairro := edtBAIRRO.Text;
    NotaF.NFe.ENTREGA.cMun    := 5002704;
    NotaF.NFe.ENTREGA.xMun    := edtCIDADE.Text;
    NotaF.NFe.ENTREGA.CEP     := StrToInt(edtCEP.Text);
    NotaF.NFe.ENTREGA.UF      := edtUF.Text;
    NotaF.NFe.ENTREGA.fone    := edtTELEFONE.Text;
    NotaF.NFe.ENTREGA.xCpl    := edtCOMPLEMENTO.Text;
  end
  else
  begin
    // DADOS RETIRADA
    NotaF.NFe.Retirada.CNPJCPF := FDQueryEMPRESA.FieldByName('CNPJ').Value;
    NotaF.NFe.Retirada.IE      := FDQueryEMPRESA.FieldByName('IE').Value;
    NotaF.NFe.Retirada.xNome   := FDQueryEMPRESA.FieldByName('NOME').Value;
    NotaF.NFe.Retirada.fone    := FDQueryEMPRESA.FieldByName('FONE').Value;
    NotaF.NFe.Retirada.CEP     := FDQueryEMPRESA.FieldByName('CEP').Value;
    NotaF.NFe.Retirada.xLgr    := FDQueryEMPRESA.FieldByName('LOGRADOURO').Value;
    NotaF.NFe.Retirada.nro     := FDQueryEMPRESA.FieldByName('NUMERO').Value;
    NotaF.NFe.Retirada.xCpl    := FDQueryEMPRESA.FieldByName('COMPLEMENTO').Value;
    NotaF.NFe.Retirada.xBairro := FDQueryEMPRESA.FieldByName('BAIRRO').Value;
    NotaF.NFe.Retirada.cMun    := FDQueryEMPRESA.FieldByName('COD_MUNICIPIO').Value;
    NotaF.NFe.Retirada.xMun    := FDQueryEMPRESA.FieldByName('MUNICIPIO').Value;
    NotaF.NFe.Retirada.UF      := FDQueryEMPRESA.FieldByName('UF').Value;
  end;

  // DADOS DO DESTINATÁRIO
  NotaF.NFe.Dest.indIEDest         := inNaoContribuinte;
  NotaF.NFe.Dest.CNPJCPF           := edtCPF_CNPJ.Text;
  NotaF.NFe.Dest.IE                := edtIE.Text;
  NotaF.NFe.Dest.ISUF              := '';
  NotaF.NFe.Dest.xNome             := edtNOME.Text;
  NotaF.NFe.Dest.EnderDest.xLgr    := edtTIPO.Text + edtESPACO.Text + edtLOGRADOURO.Text;
  NotaF.NFe.Dest.EnderDest.nro     := edtNUMERO.Text;
  NotaF.NFe.Dest.EnderDest.xBairro := edtBAIRRO.Text;
  NotaF.NFe.Dest.EnderDest.cMun    := 5002704;
  NotaF.NFe.Dest.EnderDest.xMun    := edtCIDADE.Text;
  NotaF.NFe.Dest.EnderDest.CEP     := StrToInt(edtCEP.Text);
  NotaF.NFe.Dest.EnderDest.UF      := edtUF.Text;
  NotaF.NFe.Dest.EnderDest.fone    := edtTELEFONE.Text;
  NotaF.NFe.Dest.EnderDest.xCpl    := edtCOMPLEMENTO.Text;
  NotaF.NFe.autXML.Add.CNPJCPF     := FDQueryEMPRESA.FieldByName('CNPJ').Value;

 // showmessage('DESTINATARIO');
  // ITENS DA VENDA NA NOTA
  // RELACIONANDO OS ITENS COM A  VENDA
  Item := 1;
  FDQueryVENDA_ITENS.Close;
  FDQueryVENDA_ITENS.SQL.Clear;
  FDQueryVENDA_ITENS.SQL.Add('SELECT * FROM VENDA_ITENS WHERE ID_VENDA =:ID');
  FDQueryVENDA_ITENS.ParamByName('ID').Value := ID_VENDA;
  FDQueryVENDA_ITENS.Open;
  FDQueryVENDA_ITENS.First;
   //Messagedlg(IntToStr(ID_NFE),mtinformation,[mbok],0);

  while not FDQueryVENDA_ITENS.Eof do
  begin
    Produto := NotaF.NFe.Det.New;
    Produto.Prod.nItem := Item;
    // Número sequencial, para cada item deve ser incrementado

    Produto.Prod.cProd  := FDQueryVENDA_ITENS.FieldByName('ID_PRODUTO').Value;
    // Showmessage('ID');
    Produto.Prod.xProd  := FDQueryVENDA_ITENS.FieldByName('PRODUTO').Value;
    // Showmessage('PRODUTO');
    Produto.Prod.qCom   := FDQueryVENDA_ITENS.FieldByName ('QUANTIDADE').AsFloat;
    // Showmessage('QTD');
    Produto.Prod.vUnCom := FDQueryVENDA_ITENS.FieldByName('VALOR').AsFloat;
    // Showmessage('VALOR');
    Produto.Prod.vProd  := FDQueryVENDA_ITENS.FieldByName('TOTAL').AsFloat;
    // Showmessage('TOTAL');
    ID_PRODUTO          := FDQueryVENDA_ITENS.FieldByName('ID_PRODUTO').Value;
    // Messagedlg(IntToStr(ID_PROD),mtinformation,[mbok],0);

    FDQueryPRODUTOS.Close;
    FDQueryPRODUTOS.SQL.Clear;
    FDQueryPRODUTOS.SQL.Add('SELECT * FROM PRODUTOS WHERE ID =:ID');
    FDQueryPRODUTOS.ParamByName('ID').Value := ID_PRODUTO;
    FDQueryPRODUTOS.Open;
    //Showmessage('SELECT PRODUTO');
    Produto.Prod.uCom := FDQueryPRODUTOS.FieldByName ('UNIDADE').Value;
    // Showmessage('UNIDADE');
    Produto.Prod.cEAN := FDQueryPRODUTOS.FieldByName ('EAN').Value;
    // Showmessage('EAN');
    Produto.Prod.NCM  := FDQueryPRODUTOS.FieldByName('NCM').Value;
    // Showmessage('NCM');
    Produto.Prod.EXTIPI := '';
    // Showmessage('IPI');
    Produto.Prod.CFOP := '5101';
    // Showmessage('CFOP');

    Produto.Prod.cEANTrib := FDQueryPRODUTOS.FieldByName('EAN').AsString;
    // Showmessage('EAN TRIB');
    Produto.Prod.uTrib   := FDQueryPRODUTOS.FieldByName('UNIDADE').Value;
    // Showmessage('UN TRIB');
    Produto.Prod.qTrib   := FDQueryVENDA_ITENS.FieldByName('QUANTIDADE').AsFloat;
    Produto.Prod.vUnTrib := FDQueryVENDA_ITENS.FieldByName('VALOR').AsFloat;
    // Showmessage('VALOR DO PRODUTO');
    Produto.Prod.vOutro := 0;
    Produto.Prod.vFrete := 0;
    Produto.Prod.vSeg   := 0;
    Produto.Prod.vDesc  := 0;

    Produto.Prod.CEST := '1111111';
    Produto.infAdProd := 'Informacao Adicional do Produto';

    // LEI DA TRANSPARENCIA
    Produto.Imposto.ICMS.CSOSN      := csosn102;
    Produto.Imposto.vTotTrib        := 0;
    // Produto.Imposto.ICMS.CST     := ModelConexaoFiredacRAD.FDQueryPRODUTOS.FieldByName('ICMS_CST').Value;
    Produto.Imposto.ICMS.orig       := FDQueryPRODUTOS.FieldByName('ORIGEM').Value;
    // Showmessage('ORIGEM');
    Produto.Imposto.ICMS.modBC      := dbiValorOperacao;
    Produto.Imposto.ICMS.vBC        := 0;
    Produto.Imposto.ICMS.pICMS      := 0;
    Produto.Imposto.ICMS.vICMS      := 0;
    Produto.Imposto.ICMS.modBCST    := dbisMargemValorAgregado;
    Produto.Imposto.ICMS.pMVAST     := 0;
    Produto.Imposto.ICMS.pRedBCST   := 0;
    Produto.Imposto.ICMS.vBCST      := 0;
    Produto.Imposto.ICMS.pICMSST    := 0;
    Produto.Imposto.ICMS.vICMSST    := 0;
    Produto.Imposto.ICMS.pRedBC     := 0;

    // PARTILHA DO ICMS E FUNDO DE POBREZA
    Produto.Imposto.ICMSUFDest.vBCUFDest      := 0.00;
    Produto.Imposto.ICMSUFDest.pFCPUFDest     := 0.00;
    Produto.Imposto.ICMSUFDest.pICMSUFDest    := 0.00;
    Produto.Imposto.ICMSUFDest.pICMSInter     := 0.00;
    Produto.Imposto.ICMSUFDest.pICMSInterPart := 0.00;
    Produto.Imposto.ICMSUFDest.vFCPUFDest     := 0.00;
    Produto.Imposto.ICMSUFDest.vICMSUFDest    := 0.00;
    Produto.Imposto.ICMSUFDest.vICMSUFRemet   := 0.00;

    Item := Item + 1;
    FDQueryVENDA_ITENS.Next;
  end;
  // PESQUSIANDO VENDAS E TOTALIZANDO
  FDQueryNFE.Close;
  FDQueryNFE.SQL.Clear;
  FDQueryNFE.SQL.Add('SELECT * FROM NFE WHERE ID =:ID');
  FDQueryNFE.ParamByName('ID').Value := ID_NFE;
  FDQueryNFE.Open;

  NotaF.NFe.Total.ICMSTot.vBC      := 0;
  NotaF.NFe.Total.ICMSTot.vICMS    := 0;
  NotaF.NFe.Total.ICMSTot.vBCST    := 0;
  NotaF.NFe.Total.ICMSTot.vST      := 0;
  NotaF.NFe.Total.ICMSTot.vProd    := FDQueryNFE.FieldByName('VALOR').AsFloat;
  // Showmessage('valor total itens ');
  NotaF.NFe.Total.ICMSTot.vFrete   := 0;
  NotaF.NFe.Total.ICMSTot.vSeg     := 0;
  NotaF.NFe.Total.ICMSTot.vDesc    := 0;
  // ModelConexaoFiredacRAD.FDQueryNFCE.FieldByName('VALOR').AsFloat;
  NotaF.NFe.Total.ICMSTot.vII      := 0;
  NotaF.NFe.Total.ICMSTot.vIPI     := 0;
  NotaF.NFe.Total.ICMSTot.vPIS     := 0;
  NotaF.NFe.Total.ICMSTot.vCOFINS  := 0;
  NotaF.NFe.Total.ICMSTot.vOutro   := 0;
  NotaF.NFe.Total.ICMSTot.vNF      := FDQueryNFE.FieldByName('VALOR').AsFloat;

  // Showmessage('valor total da nfe');
  NotaF.NFe.Total.ICMSTot.vTotTrib := 0;

  // PARTILHA DO ICMS E FUNDO DE POBREZA
  NotaF.NFe.Total.ICMSTot.vFCPUFDest   := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFDest  := 0.00;
  NotaF.NFe.Total.ICMSTot.vICMSUFRemet := 0.00;

  // FRETE
  NotaF.NFe.Transp.modFrete := mfSemFrete; // SEM FRETE

  // YA. Informações de pagamento

  InfoPgto := NotaF.NFe.pag.New;
  InfoPgto.indPag  := ipVista;
  InfoPgto.tPag    := fpDinheiro;
  InfoPgto.vPag    := FDQueryNFE.FieldByName('VALOR').AsFloat;
  // Showmessage('valor total nfce');

  // ENVIA NFCE
  NFe.NotasFiscais.GerarNFe;
  NFe.NotasFiscais.Assinar;
  NFe.NotasFiscais.Validar;

  if NFe.NotasFiscais.Count > 1 then
    NFe.Enviar(ID_VENDA) // Envia o lote contendo mais de 1 nota no modo assincrono
  else
    NFe.Enviar(ID_VENDA, True, True);  // Envia o lote contendo apenas 1 nota no modo sincrono

  NFe.NotasFiscais.ImprimirPDF;

  // ShowMessage(NFCE.WebServices.Retorno.NFeRetorno.xMotivo);

  if NFe.WebServices.Retorno.NFeRetorno.xMotivo = 'Lote processado' then
  begin
    CHAVE_NFE := NFe.WebServices.Retorno.ChaveNFe;
    STATUS := NFe.WebServices.Retorno.NFeRetorno.xMotivo;
    // MessageBox(0, 'NF-E Gerada com sucesso!', 'AVISO', mb_OK);
    // NFE.NotasFiscais.Imprimir;
    Exit;
  end
  else
  begin
    STATUS := NFe.WebServices.Retorno.NFeRetorno.xMotivo;
    Showmessage(NFe.WebServices.Retorno.NFeRetorno.xMotivo);
  end;

end;

procedure TForm1.SelectCertificado;
begin
  FDQueryCERTIFICADO.Open;
  try
    NFe.Configuracoes.Geral.SSLLib               := TSSLLib.libWinCrypt;
    NFe.SSL.SSLType                              := TSSLType.LT_TLSv1_2;
    NFe.Configuracoes.Geral.SSLXmlSignLib        := xsLibXml2;

    NFe.Configuracoes.Certificados.DadosPFX := FDQueryCERTIFICADOCERTIFICADO.AsAnsiString;
    NFe.Configuracoes.Certificados.Senha    := FDQueryCERTIFICADOSENHA.AsString;
    NFe.Configuracoes.Geral.IdCSC           := FDQueryCERTIFICADOID_TOKEN.AsString;
    NFe.Configuracoes.Geral.CSC             := FDQueryCERTIFICADONUMERO_TOKEN.AsString;

  finally
    FDQueryCERTIFICADO.Close;
  end;
end;

procedure TForm1.SelectCliente;
begin
  FDQueryCLIENTES.Close;
  FDQueryCLIENTES.SQL.Clear;
  FDQueryCLIENTES.SQL.Add('SELECT * FROM CLIENTES WHERE ID =:ID');
  FDQueryCLIENTES.ParamByName('ID').Value := ID_CLIENTE;
  FDQueryCLIENTES.Open;
end;

procedure TForm1.SelectEmpresa;
begin
  FDQueryEMPRESA.Close;
  FDQueryEMPRESA.SQL.Clear;
  FDQueryEMPRESA.SQL.Add('SELECT * FROM EMPRESA');
  FDQueryEMPRESA.Open;
end;

end.
