unit ClientsList;

interface

uses
  Classes, StdCtrls, SysUtils, Contnrs, ScktComp,
  Client, CommonUtils;

type
  TClientsList = class(TObjectList)
    constructor Create;
    public
      // Синхронизация с отображением
      procedure Sync;
      function IsNickInUse(NickName: string) : boolean;
      function AddClient(SocketHandle: integer; var Socket: TCustomWinSocket;
        NickName: string) : TClient;
      procedure RemoveClient(SocketHandle: integer);
      function GetClientByHandle(SocketHandle: integer) : TClient;
      function GetClientByNick(NickName: string) : TClient;
      function GetNickByHandle(SocketHandle: integer) : string;
      function View : TListBox;
      // Задать отображение
      procedure SetView(var ListBox: TListBox);
    private
      dView: TListBox;
  end;

implementation

{ TClientsList }
constructor TClientsList.Create;
begin
  Inherited;
end;

procedure TClientsList.Sync;
var
  i: integer;
  Client: TClient;
  buff: TStrings;
begin
  buff := TStringList.Create;
  for i := 0 to Self.Count - 1 do
  begin
    Client := Self.Items[i] as TClient;
    buff.Add(Client.NickName);
  end;
  AlphabeticSort(buff);
  dView.Items := buff;
end;

function TClientsList.IsNickInUse(NickName: string) : boolean;
var
  i: integer;
  Client: TClient;
begin
  for i := 0 to Self.Count - 1 do
  begin
    Client := Self.Items[i] as TClient;
    if Client.NickName = NickName then
    begin
      Result := True;
      Exit;
    end;
  end;
  Result := False;
end;

function TClientsList.AddClient(SocketHandle: Integer;
  var Socket: TCustomWinSocket; NickName: string) : TClient;
var
  Client: TClient;
begin
  if ValidateNickName(NickName) then
    if not IsNickInUse(NickName) then
    begin
      Client := TClient.Create(SocketHandle, Socket, NickName);
      Add(Client);
      Result := Client;
      Sync;
    end
    else
      raise ENickInUse.Create('Nickname is already in use: ' + NickName)
  else
    raise EIncorrectNick.Create('Incorrect nick: ' + NickName);
end;

procedure TClientsList.RemoveClient(SocketHandle: Integer);
var
  i: integer;
  Client: TClient;
begin
  for i := 0 to Count - 1 do
  begin
    Client := Items[i] as TClient;
    if Client.SocketHandle = SocketHandle then
    begin
      Delete(i);
      Break;
    end;
  end;
  Sync;
end;

function TClientsList.GetClientByHandle(SocketHandle: Integer) : TClient;
var
  i: integer;
  Client: TClient;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    Client := Self.Items[i] as TClient;
    if Client.dSocketHandle = SocketHandle then
    begin
      Result := Client;
      Exit;
    end;
  end;
end;

function TClientsList.GetClientByNick(NickName: string) : TClient;
var
  i: integer;
  Client: TClient;
begin
  for i := 0 to Self.Count - 1 do
  begin
    Client := Self.Items[i] as TClient;
    if Client.dNickName = NickName then
    begin
      Result := Client;
      Exit;
    end;
  end;
end;

function TClientsList.GetNickByHandle(SocketHandle: Integer) : string;
var
  Client: TClient;
begin
  Client := GetClientByHandle(SocketHandle);
  if Assigned(Client) then
    Result := Client.NickName
  else
end;

function TClientsList.View;
begin
  Result := dView;
end;

procedure TClientsList.SetView(var ListBox: TListBox);
begin
  dView := ListBox;
end;

end.
