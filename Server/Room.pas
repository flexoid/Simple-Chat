unit Room;

interface

uses
  Classes, SysUtils, Contnrs,
  Client;

type

  EIncorrectRoomName = class(Exception);
  ERoomExists = class(Exception);
  EAlreadyInChannel = class(Exception);

  TRoom = class
    constructor Create(RoomName: string);
    public
      dRoomName: string;
      dUsers: TObjectList;

      procedure AddUser(Client: TClient);
      procedure RemoveUser(var Client: TClient);
      function IsUserInRoom(var Client: TClient) : boolean;
      function RoomName : string;
      // Уведомить всех о выходе пользователя
      procedure NotifyUsers(NickName: string);
      // Отправить текст всем пользователям в комнате
      procedure SendText(NickName, Text: string);
      function GetListOfUsers : string;
  end;

implementation

{ TRoom }
constructor TRoom.Create(RoomName: string);
begin
  dRoomName := RoomName;
  dUsers := TObjectList.Create;
  dUsers.OwnsObjects := False;
end;

procedure TRoom.AddUser(Client: TClient);
begin
  if dUsers.IndexOf(Client) = -1 then
    dUsers.Add(Client)
  else
    raise EAlreadyInChannel.CreateFmt('Client #%d / %s is already in channel ' +
      '%s', [Client.SocketHandle, Client.NickName, RoomName]);
end;

procedure TRoom.RemoveUser(var Client: TClient);
var
  i, j: integer;
  tmpClient: TClient;
begin
  for i := 0 to dUsers.Count - 1 do
  begin
    tmpClient := dUsers.Items[i] as TClient;
    if tmpClient.dSocketHandle = Client.dSocketHandle then
    begin
      dUsers.Delete(i);
      for j := 0 to dUsers.Count - 1 do
      begin
        tmpClient := dUsers.Items[j] as TClient;
        tmpClient.dSocket.SendText('$p ' + Client.NickName + ' ' + dRoomName + #13#10);
      end;
      Exit;
    end;
  end;
end;

function TRoom.IsUserInRoom(var Client: TClient) : boolean;
var
  flag: boolean;
  i: integer;
  tmpClient: TClient;
begin
  flag := False;
  for i := 0 to dUsers.Count - 1 do
  begin
    tmpClient := dUsers.Items[i] as TClient;
    if tmpClient.dSocketHandle = Client.dSocketHandle then
    begin
      flag := True;
      Break;
    end;
  end;
  Result := flag;
end;

function TRoom.RoomName : string;
begin
  Result := dRoomName;
end;

procedure TRoom.NotifyUsers(NickName: string);
var
  i: integer;
  tmpClient: TClient;
begin
  for i := 0 to dUsers.Count - 1 do
  begin
    tmpClient := dUsers.Items[i] as TClient;
    tmpClient.dSocket.SendText('$n ' + NickName + ' ' + dRoomName + #13#10);
  end;
end;

procedure TRoom.SendText(NickName, Text: string);
var
  i: integer;
  tmpClient: TClient;
begin
  for i := 0 to dUsers.Count - 1 do
  begin
    tmpClient := dUsers.Items[i] as TClient;
    tmpClient.dSocket.SendText('$m ' + dRoomName + ' ' +
      NickName + ' ' + Text + #13#10);
  end;
end;

function TRoom.GetListOfUsers : string;
var
  str: string;
  i: integer;
  tmpClient: TClient;
begin
  str := '';
  for i := 0 to dUsers.Count - 1 do
  begin
    tmpClient := dUsers.Items[i] as TClient;
    str := str + tmpClient.NickName + ' ';
  end;
  Result := str;
end;

end.
