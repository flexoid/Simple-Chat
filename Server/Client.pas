unit Client;

interface

uses
  SysUtils, ScktComp,
  CommonUtils;

type

  EIncorrectNick = class(Exception);
  ENickInUse = class(Exception);

  TClient = class
    constructor Create; overload;
    constructor Create(SocketHandle: integer; var Socket: TCustomWinSocket;
      NickName: string); overload;
    public
      dSocketHandle: integer;
      dSocket: TCustomWinSocket;
      dNickName: string;
      dEmail: string;
      dAge: byte;

      procedure SetSocketHandle(SocketHandle: integer);
      procedure SetNickName(NickName: string);
      function NickName: string;
      function SocketHandle: integer;
  end;

implementation

{ TClient}
constructor TClient.Create;
begin
  dAge := 0;
end;

constructor TClient.Create(SocketHandle: Integer; var Socket: TCustomWinSocket;
  NickName: string);
begin
  Self.dSocketHandle := SocketHandle;
  Self.dNickName := NickName;
  Self.dSocket := Socket;
end;

procedure TClient.SetSocketHandle(SocketHandle: Integer);
begin
  Self.dSocketHandle := SocketHandle;
end;

procedure TClient.SetNickName(NickName: string);
begin
  if ValidateNickName(NickName) then
    Self.dNickName := NickName
  else
    raise EIncorrectNick.Create('Incorrect nick: ' + NickName);
end;

function TClient.NickName : string;
begin
  Result := dNickName;
end;

function TClient.SocketHandle;
begin
  Result := dSocketHandle;
end;

end.
