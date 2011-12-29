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
    // Эмиттировать ошибку у клиента
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
    UnknownError: ErrorString := 'Неизвестная ошибка';
    UnknownCommand: ErrorString := 'Неизвестная команда: ' + AdditionalInfo;
    InvalidCommandFormat: ErrorString := 'Неправильный формат команды: ' + AdditionalInfo;
    IncorrectNickName:
    begin
      ErrorString := 'Неправильный ник: ' + AdditionalInfo;
      ForFree := True;
    end;
    NickNameIsInUse:
    begin
      ErrorString := 'Такой ник уже используется: ' + AdditionalInfo;
      ForFree := True;
    end;
    IncorrectRoomName: ErrorString := 'Неправильное имя комнаты: ' + AdditionalInfo;
    AlreadyInChannel: ErrorString := 'Уже в комнате: ' + AdditionalInfo;
  end;
  Socket.SendText('$e ' + ErrorString);
  if ForFree then
    Socket.Free;
end;

end.
