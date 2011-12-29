unit Error;

interface

uses
  ScktComp;

type
  TError = class
    type ErrorCode = (
      UnknownError,
      UnknownCommand,
      InvalidCommandFormat,
      IncorrectNickName,
      NickNameIsInUse,
      IncorrectRoomName,
      AlreadyInChannel
    );
    // ������������ ������ � �������
    class procedure EmitError(Error: ErrorCode; Socket: TCustomWinSocket;
      AdditionalInfo: string = '');
  end;

implementation

{ TError }
class procedure TError.EmitError(Error: TError.ErrorCode; Socket: TCustomWinSocket;
  AdditionalInfo: string = '');
var
  ErrorString: string;
  ForFree: boolean;
begin
  ForFree := False;
  case Error of
    UnknownError: ErrorString := '����������� ������';
    UnknownCommand: ErrorString := '����������� �������: ' + AdditionalInfo;
    InvalidCommandFormat: ErrorString := '������������ ������ �������: ' + AdditionalInfo;
    IncorrectNickName:
    begin
      ErrorString := '������������ ���: ' + AdditionalInfo;
      ForFree := True;
    end;
    NickNameIsInUse:
    begin
      ErrorString := '����� ��� ��� ������������: ' + AdditionalInfo;
      ForFree := True;
    end;
    IncorrectRoomName: ErrorString := '������������ ��� �������: ' + AdditionalInfo;
    AlreadyInChannel: ErrorString := '��� � �������: ' + AdditionalInfo;
  end;
  Socket.SendText('$e ' + ErrorString);
  if ForFree then
    Socket.Free;
end;

end.
