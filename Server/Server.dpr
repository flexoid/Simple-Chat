program Server;

uses
  Forms,
  Main in 'Main.pas' {SimpleChatServer},
  Client in 'Client.pas',
  ClientsList in 'ClientsList.pas',
  Room in 'Room.pas',
  RoomsList in 'RoomsList.pas' {$R *.res},
  Error in 'Error.pas' {$R *.res},
  CommonUtils in '..\CommonUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSimpleChatServer, SimpleChatServer);
  Application.Run;
end.
