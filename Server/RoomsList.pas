unit RoomsList;

interface

uses
  Classes, Contnrs, StdCtrls, SysUtils,
  Room, CommonUtils;

type
  ERoomNotFounded = class(Exception);

  TRoomsList = class(TObjectList)
    constructor Create;
    public
      procedure AddRoom(RoomName: string);
      procedure RemoveRoom(RoomName: string);
      function IsRoomExists(RoomName: string) : boolean;
      function GetRoomByName(RoomName: string) : TRoom;
      function View : TListBox;
      procedure SetView(var ListBox: TListBox);
      // Удалить комнату, если она пустая
      function RemoveEmpty(Room: TRoom) : boolean;
      // Синхронизация с отображением
      procedure Sync;
    private
      dView: TListBox;
  end;

implementation

{ TRoomsLists }
constructor TRoomsList.Create;
begin
  Inherited;
end;

procedure TRoomsList.Sync;
var
  i: integer;
  Room: TRoom;
  buff: TStrings;
begin
  buff := TStringList.Create;
  for i := 0 to Self.Count - 1 do
  begin
    Room := Self.Items[i] as TRoom;
    buff.Add(Room.RoomName);
  end;
  AlphabeticSort(buff);
  dView.Items := buff;
end;

procedure TRoomsList.AddRoom(RoomName: string);
var
  Room: TRoom;
begin
  if ValidateRoomName(RoomName) then
    if not IsRoomExists(RoomName) then
    begin
      Room := TRoom.Create(RoomName);
      Add(Room);
      Sync;
    end
    else
      raise ERoomExists.Create('Room is already exists: ' + RoomName)
  else
    raise EIncorrectRoomName.Create('Incorrect room name: ' + RoomName);
end;

procedure TRoomsList.RemoveRoom(RoomName: string);
var
  i: integer;
  tmpRoom: TRoom;
begin
  for i := 0 to Count - 1 do
  begin
    tmpRoom := Items[i] as TRoom;
    if tmpRoom.dRoomName = RoomName then
    begin
      Delete(i);
      Break;
    end;
  end;
  Sync;
end;

function TRoomsList.IsRoomExists(RoomName: string) : boolean;
var
  flag: boolean;
  i: integer;
  tmpRoom: TRoom;
begin
  flag := False;
  for i := 0 to Count - 1 do
  begin
    tmpRoom := Items[i] as TRoom;
    if tmpRoom.dRoomName = RoomName then
    begin
      flag := True;
      Break;
    end;
  end;
  Result := flag;
end;

function TRoomsList.GetRoomByName(RoomName: string) : TRoom;
var
  i: integer;
  tmpRoom: TRoom;
begin
  for i := 0 to Count - 1 do
  begin
    tmpRoom := Items[i] as TRoom;
    if tmpRoom.dRoomName = RoomName then
    begin
      Result := tmpRoom;
        Exit;
    end;
  end;
  Result := nil;
end;

function TRoomsList.View;
begin
  Result := dView;
end;

procedure TRoomsList.SetView(var ListBox: TListBox);
begin
  dView := ListBox;
end;

function TRoomsList.RemoveEmpty(Room: TRoom) : boolean;
var
  i: integer;
begin
  Result := False;
  i := IndexOf(Room);
  if i <> -1 then
    if Room.dUsers.Count = 0 then
    begin
      Delete(i);
      Sync;
      Result := True;
    end;

end;

end.
