unit Model.Connection;

interface

uses FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  Data.DB, FireDAC.Comp.Client;

var
   FConnection : TFDConnection;

function SetupConnection(FConn: TFDConnection):String;
function Connect: TFDConnection;
procedure Disconnect;

implementation

end.
