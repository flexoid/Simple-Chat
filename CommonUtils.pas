unit CommonUtils;

interface

uses
  SysUtils, Classes, StdCtrls;

function ValidateRoomName(RoomName: string) : boolean;
function ValidateNickName(NickName: string) : boolean;
function IsWrongIP(ip: string): boolean;
function ValidateHost(host: string) : boolean;
function ValidatePort(port: string) : boolean;
function ValidateAge(age: string) : boolean;
procedure AlphabeticSort(var Strings: TStrings); overload;
procedure AlphabeticSort(var ListBox: TListBox); overload;

implementation

function ValidateNickName(NickName: string) : boolean;
var
  i: integer;
begin
  Result := True;
  if (Length(NickName) > 0) AND (Length(NickName) <= 32) then
  begin
    for i := 1 to Length(NickName) do
      begin
      if (not (NickName[i] in ['A'..'z']))
        AND (not (NickName[i] in ['1'..'9']))
        AND (NickName[i] <> '_') AND (NickName[i] <> '-') then
      begin
        Result := False;
        exit;
      end;
    end;
  end
  else
    Result := False;
end;

function ValidateRoomName(RoomName: string) : boolean;
var
  i: integer;
begin
  Result := True;
  if (Length(RoomName) > 0) AND (Length(RoomName) <= 32) then
  begin
    if RoomName[1] <> '#' then
      Result := False
    else
      for i := 2 to Length(RoomName) do
      begin
        if (not (RoomName[i] in ['A'..'z']))
          AND (not (RoomName[i] in ['1'..'9']))
          AND (RoomName[i] <> '_') AND (RoomName[i] <> '-') then
        begin
          Result := False;
          exit;
        end;
      end;
  end
  else
    Result := False;
end;

function IsWrongIP(ip: string): boolean;
var z, i: integer;
   st:   array[1..3] of byte;
const ziff = ['0'..'9'];
begin
  st[1]  := 0;
  st[2]  := 0;
  st[3]  := 0;
  z      := 0;
  Result := False;
  for i := 1 to length(ip) do if ip[i] in ziff then
  else
    begin
       if ip[i] = '.' then
         begin
            inc(z);
            if z < 4 then st[z] := i
            else
              begin
                 IsWrongIP:= True;
                 exit;
              end;
         end
       else
         begin
            IsWrongIP:= True;
            exit;
         end;
    end;
  if (z <> 3) or (st[1] < 2) or (st[3] = length(ip)) or (st[1] + 2 > st[2]) or
     (st[2] + 2 > st[3]) or (st[1] > 4) or (st[2] > st[1] + 4) or (st[3] > st[2] + 4) then
    begin
       IsWrongIP:= True;
       exit;
    end;
  z := StrToInt(copy(ip, 1, st[1] - 1));
  if (z > 255) or (ip[1] = '0') then
    begin
       IsWrongIP:= True;
       exit;
    end;
  z := StrToInt(copy(ip, st[1] + 1, st[2] - st[1] - 1));
  if (z > 255) or ((z <> 0) and (ip[st[1] + 1] = '0')) then
    begin
       IsWrongIP:= True;
       exit;
    end;
  z := StrToInt(copy(ip, st[2] + 1, st[3] - st[2] - 1));
  if (z > 255) or ((z <> 0) and (ip[st[2] + 1] = '0')) then
    begin
       IsWrongIP:= True;
       exit;
    end;
  z := StrToInt(copy(ip, st[3] + 1, length(ip) - st[3]));
  if (z > 255) or ((z <> 0) and (ip[st[3] + 1] = '0')) then
    begin
       IsWrongIP:= True;
       exit;
    end;
end;

function ValidateHost(host: string) : boolean;
begin
  if Length(host) > 0 then
    Result := True
  else
    Result := False;
end;

function ValidatePort(port: string) : boolean;
var
  PortInt: integer;
begin
  try
    PortInt := StrToInt(port);
    if (PortInt >= 0) AND (PortInt <= 65535) then
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end;

function ValidateAge(age: string) : boolean;
var
  AgeInt: integer;
begin
  if age = '' then
  begin
    Result := True;
    exit
  end;
  try
    AgeInt := StrToInt(age);
    if (AgeInt > 0) AND (AgeInt <= 100) then
      Result := True
    else
      Result := False;
  except
    Result := False;
  end;
end;

procedure AlphabeticSort(var Strings: TStrings);
var
  i, x: Integer;
begin
  for i := 0 to (Strings.Count - 1) do
    for x := 0 to (Strings.Count - 1) do
      if (Strings[x] < Strings[i]) and (x > i) then
      begin
        Strings.Insert(i, Strings[x]);
        Strings.Delete(x + 1);
      end;
end;

procedure AlphabeticSort(var ListBox: TListBox);
var
  i, x: Integer;
begin
  for i := 0 to (ListBox.Items.Count - 1) do
    for x := 0 to (ListBox.Items.Count - 1) do
      if (ListBox.Items[x] < ListBox.Items[i]) and (x > i) then
      begin
        ListBox.Items.Insert(i, ListBox.Items[x]);
        ListBox.Items.Delete(x + 1);
      end;
end;

end.
