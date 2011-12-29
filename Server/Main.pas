unit Main;

interface

uses
  SysUtils, Classes, Controls, Forms, Dialogs, Graphics, StdCtrls,
  ScktComp, ExtCtrls,
  ClientsList, Client, RoomsList, Room, Error, CommonUtils;

type
  TSimpleChatServer = class(TForm)
    ServerSocket: TServerSocket;
    Panel1: TPanel;
    RoomsListBox: TListBox;
    ClientsListBox: TListBox;
    LogListPanel: TPanel;
    LogListBox: TListBox;
    Label1: TLabel;
    RoomsListPanel: TPanel;
    Label2: TLabel;
    ClientsListPanel: TPanel;
    Label3: TLabel;
    Splitter3: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    StartButton: TButton;
    StopButton: TButton;
    Panel4: TPanel;
    Label4: TLabel;
    PortEdit: TEdit;
    Splitter2: TSplitter;
    procedure StartButtonClick(Sender: TObject);
    procedure StopButtonClick(Sender: TObject);
    procedure ServerSocketClientRead(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure ServerSocketClientDisconnect(Sender: TObject;
      Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure PortEditChange(Sender: TObject);
    procedure ServerSocketListen(Sender: TObject; Socket: TCustomWinSocket);
  private

    // Обработка входящих данных
    procedure Processing(cmd: string; Socket: TCustomWinSocket);
    procedure ProcessU(params: TStringList; Socket: TCustomWinSocket);
    procedure ProcessJ(params: TStringList; Socket: TCustomWinSocket);
    procedure ProcessM(params: TStringList; Socket: TCustomWinSocket);
    procedure ProcessP(params: TStringList; Socket: TCustomWinSocket);
    procedure ProcessI(params: TStringList; Socket: TCustomWinSocket);
  public
    // Журналирование событий
    procedure Log(Text: string);
  end;

var
  SimpleChatServer: TSimpleChatServer;
  ClientsList: TClientsList;
  RoomsList: TRoomsList;

implementation

{$R *.dfm}

procedure TSimpleChatServer.StartButtonClick(Sender: TObject);
var
  port: integer;
begin
  if ValidatePort(PortEdit.Text) then
  begin
    ServerSocket.Port := StrToInt(PortEdit.Text);
    ServerSocket.Open;
    PortEdit.Color := clWindow;
  end
  else
    PortEdit.Color := clRed;
end;

procedure TSimpleChatServer.StopButtonClick(Sender: TObject);
begin
  ClientsListBox.Clear;
  if ServerSocket.Active then
  begin
    ServerSocket.Close;
    Log('Сервер остановлен');
    StartButton.Enabled := True;
  StopButton.Enabled := False;
  end;
  ClientsList.Clear;
  RoomsList.Clear;
end;

procedure TSimpleChatServer.ServerSocketClientRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  params: TStringList;
  para: string;
  recv: string;
  i: integer;
begin
  recv := Socket.ReceiveText;
  params := TStringList.Create;
  params.Text := recv;

  for i := 0 to params.Count - 1 do
    Processing(params[i], Socket);
end;

procedure TSimpleChatServer.Processing(cmd: string; Socket: TCustomWinSocket);
var
  command: string;
  params: TStringList;
begin
  params := TStringList.Create;
  params.Delimiter := ' ';
  params.DelimitedText := cmd;
  if params.Count = 0 then
    Exit;

  command := params[0];
  if command = '$u' then
    ProcessU(params, Socket)
  else if command = '$j' then
    ProcessJ(params, Socket)
  else if command = '$m' then
    ProcessM(params, Socket)
  else if command = '$p' then
    ProcessP(params, Socket)
  else if command = '$i' then
    ProcessI(params, Socket)
  else
    TError.EmitError(TError.ErrorCode.UnknownCommand, Socket, command);
end;

procedure TSimpleChatServer.ProcessU(params: TStringList; Socket: TCustomWinSocket);
var
  Client: TClient;
begin
if params.Count >= 2 then
  try
    Client := ClientsList.AddClient(Socket.SocketHandle, Socket, params[1]);
    if params.Count >= 3 then
      Client.dAge := StrToInt(params[2]);
    if params.Count >= 4 then
      Client.dEmail := params[3];
    Log('Клиент подключился: ' + params[1]);
  except
    on ENickInUse do
      TError.EmitError(TError.ErrorCode.NickNameIsInUse, Socket, params[1]);
    on EIncorrectNick do
      TError.EmitError(TError.ErrorCode.IncorrectNickName, Socket, params[1]);
  end
else
  TError.EmitError(TError.ErrorCode.InvalidCommandFormat, Socket, '$u');
end;

procedure TSimpleChatServer.ProcessJ(params: TStringList; Socket: TCustomWinSocket);
var
  client: TClient;
begin
  client := ClientsList.GetClientByHandle(Socket.SocketHandle);
  if client <> nil then
  begin
    if params.Count = 2 then
      if ValidateRoomName(params[1]) then
      begin
        if not RoomsList.IsRoomExists(params[1]) then
        begin
          RoomsList.AddRoom(params[1]);
          Log('Создана комната: ' + params[1]);
        end;
        with RoomsList.GetRoomByName(params[1]) do
          try
            AddUser(client);
            NotifyUsers(client.NickName);
            Socket.SendText('$l ' + params[1] + ' ' + GetListOfUsers + #13#10);
            Log('Пользователь ' + client.NickName + ' вошел в комнату ' + params[1]);
          except
            on EAlreadyInChannel do
              TError.EmitError(TError.ErrorCode.AlreadyInChannel,
                Socket, params[1])
          end;
      end
      else
        TError.EmitError(TError.ErrorCode.IncorrectRoomName, Socket, params[1])
    else
      TError.EmitError(TError.ErrorCode.InvalidCommandFormat, Socket, '$j');
  end;
end;

procedure TSimpleChatServer.ProcessM(params: TStringList; Socket: TCustomWinSocket);
var
  receiver: string;
  room: TRoom;
  client, client2: TClient;
begin
  receiver := params[1];
  params.Delimiter := ' ';
  if receiver[1] = '#' then
  begin
    room := RoomsList.GetRoomByName(receiver);
    client := ClientsList.GetClientByHandle(Socket.SocketHandle);
    if Assigned(room) then
    begin
      params.Delete(0); params.Delete(0);
      room.SendText(client.NickName, params.DelimitedText);
    end;
  end
  else
  begin
    client := ClientsList.GetClientByHandle(Socket.SocketHandle);
    client2 := ClientsList.GetClientByNick(receiver);
    if Assigned(client) AND Assigned(client2) then
    begin
      params.Delete(0); params.Delete(0);
      client2.dSocket.SendText('$m ' + client.NickName +
        ' ' + params.DelimitedText + #13#10);
      client.dSocket.SendText('$m ' + client.NickName +
        ' ' + params.DelimitedText + #13#10);
    end;
  end;
end;

procedure TSimpleChatServer.ProcessP(params: TStringList; Socket: TCustomWinSocket);
var
  room: TRoom;
  client: TClient;
begin
  client := ClientsList.GetClientByHandle(Socket.SocketHandle);
  if params.Count = 2 then
    if ValidateRoomName(params[1]) then
    begin
      room := nil;
      room := RoomsList.GetRoomByName(params[1]);
      if Assigned(room) AND room.IsUserInRoom(client) then
      begin
        room.RemoveUser(client);
        Log('Пользователь ' + client.NickName + ' покинул комнату ' + room.dRoomName);
        if RoomsList.RemoveEmpty(room) then
          Log('Комната удалена: ' + params[1]);
      end;
    end
    else
      TError.EmitError(TError.ErrorCode.IncorrectRoomName, Socket, params[1])
  else
    TError.EmitError(TError.ErrorCode.InvalidCommandFormat, Socket, '$p');
end;

procedure TSimpleChatServer.ProcessI(params: TStringList; Socket: TCustomWinSocket);
var
  client, client2: TClient;
begin
  if params.Count = 2 then
  begin
    client := ClientsList.GetClientByNick(params[1]);
    client2 := ClientsList.GetClientByHandle(Socket.SocketHandle);
    if Assigned(client) AND Assigned(client2) then
    begin
      client2.dSocket.SendText('$i ' + client.NickName + ' '
        + IntToStr(client.dAge) + ' ' + client.dEmail + #13#10);
    end;
  end
  else
    TError.EmitError(TError.ErrorCode.InvalidCommandFormat, Socket, '$p');
end;

procedure TSimpleChatServer.ServerSocketListen(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  Log('Сервер запущен');
  StartButton.Enabled := False;
  StopButton.Enabled := True;
end;

procedure TSimpleChatServer.FormCreate(Sender: TObject);
begin
  ClientsList := TClientsList.Create;
  ClientsList.SetView(ClientsListBox);

  RoomsList := TRoomsList.Create;
  RoomsList.SetView(RoomsListBox);
end;

procedure TSimpleChatServer.PortEditChange(Sender: TObject);
begin
  PortEdit.Color := clWindow;
end;

procedure TSimpleChatServer.ServerSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
var
  Client: TClient;
  Room: TRoom;
  i: integer;
begin
  Client := ClientsList.GetClientByHandle(Socket.SocketHandle);
  if Client <> nil then
  begin
    for i := RoomsList.Count - 1 downto 0 do
    begin
      Room := RoomsList.Items[i] as TRoom;
      Room.RemoveUser(Client);
      RoomsList.RemoveEmpty(Room);
    end;
    Log('Клиент отключился: ' + Client.NickName);
  end
  else
    Log('Клиент отключился.');
  ClientsList.RemoveClient(Socket.SocketHandle);
end;

procedure TSimpleChatServer.Log(Text: string);
begin
  LogListBox.Items.Append(Text);
  LogListBox.TopIndex := -1 + LogListBox.Items.Count;
end;

end.
