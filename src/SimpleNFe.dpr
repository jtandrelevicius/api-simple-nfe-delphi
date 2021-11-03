program SimpleNFe;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Controller.Client in 'Controller\Controller.Client.pas',
  Model.Connection in 'Model\Model.Connection.pas',
  Model.Client in 'Model\Model.Client.pas';

procedure OnListen(aListen: THorse);
begin
  WriteLn('Status - HorseSimpleNFe:ON - Porta:' + IntToStr(aListen.Port));
end;

begin
  begin
  THorse.Use(Jhonson());
  //TControllerClient.Router;
  THorse.Listen(9000, OnListen);
  end;
end.
