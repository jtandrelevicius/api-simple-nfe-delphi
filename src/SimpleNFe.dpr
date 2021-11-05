program SimpleNFe;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Controller.Client in 'Controller\Controller.Client.pas',
  Model.Connection in 'Model\Model.Connection.pas',
  Model.Client in 'Model\Model.Client.pas',
  Controller.Product in 'Controller\Controller.Product.pas',
  Model.Product in 'Model\Model.Product.pas',
  Controller.Company in 'Controller\Controller.Company.pas',
  Model.Company in 'Model\Model.Company.pas',
  Controller.Provider in 'Controller\Controller.Provider.pas',
  Model.Provider in 'Model\Model.Provider.pas',
  Controller.Sales in 'Controller\Controller.Sales.pas',
  Model.Sales in 'Model\Model.Sales.pas',
  Controller.Sales.Items in 'Controller\Controller.Sales.Items.pas',
  Model.Sales.Items in 'Model\Model.Sales.Items.pas',
  Controller.Payment in 'Controller\Controller.Payment.pas',
  Model.Payment in 'Model\Model.Payment.pas',
  Controller.Box in 'Controller\Controller.Box.pas',
  Model.Box in 'Model\Model.Box.pas',
  Controller.Users in 'Controller\Controller.Users.pas',
  Model.Users in 'Model\Model.Users.pas',
  uFormat in 'Units\uFormat.pas',
  uFunctions in 'Units\uFunctions.pas';

procedure OnListen(aListen: THorse);
begin
  WriteLn('Status - HorseSimpleNFe:ON - Porta:' + IntToStr(aListen.Port));
end;

begin
  begin
  THorse.Use(Jhonson());
  TControllerClient.Router;
  TControllerProduct.Router;
  TControllerBox.Router;
  TControllerCompany.Router;
  TControllerPayment.Router;
  TControllerProvider.Router;
  TControllerSalesItems.Router;
  THorse.Listen(9000, OnListen);
  end;
end.
