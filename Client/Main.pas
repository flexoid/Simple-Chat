unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Menus, ScktComp,
  CommonUtils, ExtCtrls, ComCtrls, AboutDlg;

type
  TSimpleChatClient = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    SettingsPanel: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    IpEdit: TEdit;
    NickEdit: TEdit;
    N5: TMenuItem;
    Panel2: TPanel;
    ClientSocket: TClientSocket;
    OkSettingsButton: TButton;
    PortEdit: TEdit;
    Label3: TLabel;
    N6: TMenuItem;
    N7: TMenuItem;
    PageControl: TPageControl;
    Panel1: TPanel;
    SendButton: TButton;
    SendEdit: TEdit;
    UserPopupMenu: TPopupMenu;
    d1: TMenuItem;
    TabPopup: TPopupMenu;
    N8: TMenuItem;
    GroupBox1: TGroupBox;
    EmailEdit: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    AgeEdit: TEdit;
    N9: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    procedure N5Click(Sender: TObject);
    procedure OkSettingsButtonClick(Sender: TObject);
    procedure IpEditChange(Sender: TObject);
    procedure NickEditChange(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure ConnectClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure ClientSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure N7Click(Sender: TObject);
    procedure ClientSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: Integer);
    procedure ClientSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure PageControlChange(Sender: TObject);
    procedure ListBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure d1Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure PageControlMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
  private

    // Проверка настроек на валидность
    function VerifySettings : Boolean;

    // Поиск вкладки с заданным именем и типом
    function FindPage(Name: string; PageType: integer = 1) : TTabSheet;

    // Обработка входящих данных
    procedure Processing(cmd: string);
    procedure ProcessN(params: TStringList);
    procedure ProcessL(params: TStringList);
    procedure ProcessM(params: TStringList);
    procedure ProcessP(params: TStringList);
    procedure ProcessE(params: TStringList);
    procedure ProcessI(params: TStringList);

    // Журналирование событий
    procedure Log(Text: string);

    function CreatePrivateChat(nick: string) : TTabSheet;

    // Является ли таб комнатой
    function IsRoom(TabSheet: TTabSheet) : boolean;
    procedure OnDisconnect;
  public
    { Public declarations }
  end;

const
  defaultRoom = '#general';

var
  SimpleChatClient: TSimpleChatClient;
  LastUserClicked: string;
  LastPageClicked: integer;

implementation

{$R *.dfm}

procedure TSimpleChatClient.OkSettingsButtonClick(Sender: TObject);
begin
  if VerifySettings then
  begin
    SettingsPanel.Visible := False;
  end;
end;

procedure TSimpleChatClient.SendButtonClick(Sender: TObject);
var
  ActivePage: TTabSheet;
  TmpListBox: TListBox;
begin
  ActivePage := PageControl.ActivePage;
  if Assigned(ActivePage) then
  begin
    TmpListBox := ActivePage.FindChildControl('UserList_' +
                                                ActivePage.Name) as TListBox;
    if Assigned(TmpListBox) then
      ClientSocket.Socket.SendText('$m ' + '#' +
                                     ActivePage.Name + ' ' + SendEdit.Text + #13#10)
    else
      ClientSocket.Socket.SendText('$m ' +
                                     ActivePage.Name + ' ' + SendEdit.Text + #13#10);
    SendEdit.Clear;
  end;
end;

procedure TSimpleChatClient.ClientSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
var
  NewTabSheet: TTabSheet;
  str: string;
begin
  {$IFNDEF DEBUG}

  NewTabSheet := TTabSheet.Create(PageControl);
  NewTabSheet.Parent := PageControl;
  NewTabSheet.Name := 'Server';
  NewTabSheet.Caption := 'Сервер';
  with TListBox.Create(NewTabSheet) do
  begin
    Parent := NewTabSheet;
    Width := 120;
    Name := 'Server_Log';
    Align := alClient;
  end;

  NewTabSheet.PageControl := PageControl;
  PageControl.ActivePage := NewTabSheet;

  {$ENDIF}

  SendButton.Enabled := False;

  N2.Enabled := False;
  N3.Enabled := True;
  N6.Enabled := True;
  SettingsPanel.Visible := False;
  N5.Enabled := False;

  str := '$u ' + NickEdit.Text;
  if AgeEdit.Text <> '' then
    str := str + ' ' + AgeEdit.Text
  else
    str := str + ' ' + IntToStr(0);
  if EmailEdit.Text <> '' then
    str := str + ' ' + EmailEdit.Text;

  ClientSocket.Socket.SendText(str + #13#10);
  ClientSocket.Socket.SendText('$j ' + defaultRoom + #13#10);
end;

procedure TSimpleChatClient.IpEditChange(Sender: TObject);
begin
  IpEdit.Color := clWindow;
end;

procedure TSimpleChatClient.ConnectClick(Sender: TObject);
begin
  if not VerifySettings then
    SettingsPanel.Visible := True
  else
  begin
    ClientSocket.Host := IpEdit.Text;
    ClientSocket.Port := StrToInt(PortEdit.Text);
    try
      ClientSocket.Open;
    except
      on E: ESocketError do
        ShowMessage(E.Message);
    end;
  end;
end;

procedure TSimpleChatClient.N11Click(Sender: TObject);
begin
  About.ShowModal;
end;

procedure TSimpleChatClient.N3Click(Sender: TObject);
begin
  while PageControl.ComponentCount > 0 do
  begin
    PageControl.Components[0].Free;
  end;
  ClientSocket.Close;
end;

procedure TSimpleChatClient.N4Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TSimpleChatClient.N5Click(Sender: TObject);
begin
  SettingsPanel.Visible := True;
end;

procedure TSimpleChatClient.N7Click(Sender: TObject);
var
  RoomName: string;
begin
  RoomName := InputBox('Имя комнаты', 'Введите имя комнаты (без префикса #)', '');
  if Length(RoomName) > 0 then
    ClientSocket.Socket.SendText('$j #' + RoomName + #13#10);
end;

procedure TSimpleChatClient.N8Click(Sender: TObject);
begin
  if LastPageClicked <> -1 then
    if IsRoom(PageControl.Pages[LastPageClicked]) then
    begin
      ClientSocket.Socket.SendText('$p ' +
        PageControl.Pages[LastPageClicked].Caption + #13#10);
      PageControl.Pages[LastPageClicked].Free;
    end
    else
      PageControl.Pages[LastPageClicked].Free;
  LastPageClicked := -1;
end;

procedure TSimpleChatClient.N9Click(Sender: TObject);
begin
  if LastUserClicked <> '' then
  begin
    ClientSocket.Socket.SendText('$i ' + LastUserClicked + #13#10);
  end;
end;

procedure TSimpleChatClient.NickEditChange(Sender: TObject);
begin
  NickEdit.Color := clWindow;
end;

procedure TSimpleChatClient.ClientSocketDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  OnDisconnect;
end;

procedure TSimpleChatClient.ClientSocketError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: Integer);
begin
  case ErrorEvent of
    TErrorEvent.eeGeneral: MessageDlg('Общая ошибка сокета',
      mtError, [mbOK], 0);
    TErrorEvent.eeSend: MessageDlg('Ошибка отправки данных',
      mtError, [mbOK], 0);
    TErrorEvent.eeReceive: MessageDlg('Ошибка получения данных',
      mtError, [mbOK], 0);
    TErrorEvent.eeConnect: MessageDlg('Ошибка подключения',
      mtError, [mbOK], 0);
    TErrorEvent.eeDisconnect: MessageDlg('Ошибка отключения',
      mtError, [mbOK], 0);
    TErrorEvent.eeAccept: MessageDlg('Ошибка соединения',
      mtError, [mbOK], 0);
    TErrorEvent.eeLookup: MessageDlg('Ошибка поиска адреса',
      mtError, [mbOK], 0);
  end;
  ErrorCode := 0;
end;

procedure TSimpleChatClient.ClientSocketRead(Sender: TObject;
  Socket: TCustomWinSocket);
var
  params: TStringList;
  recv: string;
  i: integer;
begin
  recv := Socket.ReceiveText;
  params := TStringList.Create;
  params.Text := recv;

  for i := 0 to params.Count - 1 do
  begin
    Log(params[i]);
    Processing(params[i]);
  end;
end;

function TSimpleChatClient.VerifySettings : Boolean;
begin
  Result := True;
  if not ValidateHost(IpEdit.Text) then
  begin
    IpEdit.Color := clRed;
    Result := False;
  end
  else
    IpEdit.Color := clWindow;
  if not ValidateNickName(NickEdit.Text) then
  begin
    NickEdit.Color := clRed;
    Result := False;
  end
  else
  begin
    NickEdit.Color := clWindow;
    Caption := 'Simple Chat Client - ' + NickEdit.Text;
  end;
  if not ValidatePort(PortEdit.Text) then
  begin
    PortEdit.Color := clRed;
    Result := False;
  end
  else
    PortEdit.Color := clWindow;
  if not ValidateAge(AgeEdit.Text) then
  begin
    AgeEdit.Color := clRed;
    Result := False;
  end
  else
    AgeEdit.Color := clWindow;
end;

function TSimpleChatClient.CreatePrivateChat(nick: string) : TTabSheet;
var
  TmpTabSheet: TTabSheet;
  text: string;
begin
  TmpTabSheet := FindPage(nick);
  if not Assigned(TmpTabSheet) then
  begin
    TmpTabSheet := TTabSheet.Create(PageControl);
    TmpTabSheet.Parent := PageControl;
    TmpTabSheet.Name := nick;
    with TMemo.Create(TmpTabSheet) do
    begin
      Parent := TmpTabSheet;
      Align := alClient;
      Name := 'PrivateChat_' + nick;
      ReadOnly := True;
      Lines.Clear;
    end;
  end;
  TmpTabSheet.PageControl := PageControl;
  PageControl.ActivePage := TmpTabSheet;
  SendButton.Enabled := True;
  Result := TmpTabSheet;
end;

function TSimpleChatClient.IsRoom(TabSheet: TTabSheet) : boolean;
var
  TmpListBox: TListBox;
begin
  TmpListBox := TabSheet.FindChildControl('UserList_' + TabSheet.Name) as TListBox;
  if Assigned(TmpListBox) then
    Result := True
  else
    Result := False;
end;

procedure TSimpleChatClient.d1Click(Sender: TObject);
begin
  if LastUserClicked <> '' then
    CreatePrivateChat(LastUserClicked);
  LastUserClicked := '';
end;

function TSimpleChatClient.FindPage(Name: string; PageType: integer = 1) : TTabSheet;
var
  i: integer;
  TmpListBox: TListBox;
begin
  Result := nil;
  for i := 0 to PageControl.PageCount - 1 do
    if PageControl.Pages[i].Name = Name then
    begin
      TmpListBox := PageControl.Pages[i].FindChildControl('UserList_' +
        PageControl.Pages[i].Name) as TListBox;
      if (PageType = 1) AND Assigned(TmpListBox) then
        Result := PageControl.Pages[i]
      else if (PageType = 2) AND not Assigned(TmpListBox) then
        Result := PageControl.Pages[i]
      else
        Result := PageControl.Pages[i];
    end;
end;

procedure TSimpleChatClient.PageControlChange(Sender: TObject);
var
  ActivePage: TTabSheet;
begin
  ActivePage := PageControl.ActivePage;
  if ActivePage.Name = 'Server' then
    SendButton.Enabled := False
  else
    SendButton.Enabled := True;
end;

procedure TSimpleChatClient.PageControlMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  TmpTabControl: TTabControl;
  i: integer;
begin
  if ssRight in Shift then
  begin
    LastPageClicked := PageControl.IndexOfTabAt(X, Y);
    TabPopup.Popup(PageControl.ClientOrigin.X + X,
      PageControl.ClientOrigin.Y + Y);
  end;
end;

procedure TSimpleChatClient.Processing(cmd: string);
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
  if command = '$n' then
    ProcessN(params)
  else if command = '$l' then
    ProcessL(params)
  else if command = '$m' then
    ProcessM(params)
  else if command = '$p' then
    ProcessP(params)
  else if command = '$e' then
    ProcessE(params)
  else if command = '$i' then
    ProcessI(params)
end;

procedure TSimpleChatClient.ProcessN(params: TStringList);
var
  NewTabSheet: TTabSheet;
  TmpListBox: TListBox;
begin
  if params.Count = 3 then
  begin
    if params[1] = NickEdit.Text then
    begin
      NewTabSheet := TTabSheet.Create(PageControl);
      NewTabSheet.Parent := PageControl;
      NewTabSheet.Name := Copy(params[2], 2, Length(params[2]) - 1);
      NewTabSheet.Caption := params[2];
      with TListBox.Create(NewTabSheet) do
      begin
        Parent := NewTabSheet;
        Width := 120;
        Align := TAlign.alRight;
        Name := 'UserList_' + Copy(params[2], 2, Length(params[2]) - 1);
        OnMouseDown := ListBoxMouseDown;
        PopupMenu := UserPopupMenu;
      end;
      with TSplitter.Create(NewTabSheet) do
      begin
        Parent := NewTabSheet;
        Align := TAlign.alRight;
      end;
      with TMemo.Create(NewTabSheet) do
      begin
        Parent := NewTabSheet;
        Align := TAlign.alClient;
        Name := 'Chat_' + Copy(params[2], 2, Length(params[2]) - 1);
        ReadOnly := True;
        Lines.Clear;
      end;
      NewTabSheet.PageControl := PageControl;
      PageControl.ActivePage := NewTabSheet;
      SendButton.Enabled := True;
    end
    else
    begin
      NewTabSheet := FindPage(Copy(params[2], 2, Length(params[2]) - 1));
      if Assigned(NewTabSheet) then
      begin
        TmpListBox := NewTabSheet.FindChildControl('UserList_' +
          Copy(params[2], 2, Length(params[2]) - 1)) as TListBox;
        if Assigned(TmpListBox) then
        begin
          TmpListBox.Items.Add(params[1]);
          AlphabeticSort(TmpListBox);
        end;
      end;
    end;
  end;
end;

procedure TSimpleChatClient.ProcessL(params: TStringList);
var
  i: integer;
  NewTabSheet: TTabSheet;
  TmpListBox: TListBox;
begin
  if params.Count > 2 then
  begin
    NewTabSheet := FindPage(Copy(params[1], 2, Length(params[1]) - 1));
    if Assigned(NewTabSheet) then
    begin
      TmpListBox := NewTabSheet.FindChildControl('UserList_' +
        Copy(params[1], 2, Length(params[1]) - 1)) as TListBox;
      if Assigned(TmpListBox) then
      begin
        for i := 2 to params.Count - 1 do
          TmpListBox.Items.Add(params[i]);
        AlphabeticSort(TmpListBox);
      end;
    end;
  end;
end;

procedure TSimpleChatClient.ProcessM(params: TStringList);
var
  i: integer;
  TmpTabSheet: TTabSheet;
  TmpMemo: TMemo;
  text: string;
begin
  if params[1][1] = '#' then
  begin
    TmpTabSheet := FindPage(Copy(params[1], 2, Length(params[1]) - 1));
    if Assigned(TmpTabSheet) then
    begin
      TmpMemo := TmpTabSheet.FindChildControl('Chat_' +
        Copy(params[1], 2, Length(params[1]) - 1)) as TMemo;
      params.Delete(0); params.Delete(0);
      if Assigned(TmpMemo) then
      begin
        text := params[0] + '> ';
        params.Delete(0);
        text := text + params.DelimitedText;
        TmpMemo.Lines.Add(text);
      end;
    end;
  end
  else
  begin
    if params[1] <> NickEdit.Text then
      TmpTabSheet := CreatePrivateChat(params[1])
    else
      TmpTabSheet := PageControl.ActivePage;
    if Assigned(TmpTabSheet) then
    begin
      for i := 0 to TmpTabSheet.ComponentCount - 1 do
        if StrPos(PChar(TmpTabSheet.Components[i].Name), PChar('PrivateChat_')) <> nil then
          TmpMemo := TmpTabSheet.Components[i] as TMemo;
      params.Delete(0);
      if Assigned(TmpMemo) then
      begin
        text := params[0] + '> ';
        params.Delete(0);
        text := text + params.DelimitedText;
        TmpMemo.Lines.Add(text);
      end;
    end;
  end;
end;

procedure TSimpleChatClient.ProcessP(params: TStringList);
var
  i: integer;
  TmpTabSheet: TTabSheet;
  TmpListBox: TListBox;
  text: string;
begin
  text := params[1];
  TmpTabSheet := FindPage(Copy(params[2], 2, Length(params[2]) - 1));
  if Assigned(TmpTabSheet) then
  begin
    TmpListBox := TmpTabSheet.FindChildControl('UserList_' +
      Copy(params[2], 2, Length(params[2]) - 1)) as TListBox;
    if Assigned(TmpListBox) then
    begin
      i := TmpListBox.Items.IndexOf(params[1]);
      if i <> -1 then
        TmpListBox.Items.Delete(i);
    end;
  end;
end;

procedure TSimpleChatClient.ProcessE(params: TStringList);
begin
  params.Delete(0);
  MessageDlg(params.DelimitedText, mtError, [mbOK], 0);
end;

procedure TSimpleChatClient.ProcessI(params: TStringList);
var
  str: string;
  isInfo: boolean;
begin
  isInfo := False;
  str := 'Пользователь ' + params[1] + #13;
  if params[2] <> '0' then
  begin
    str := str + 'Возраст: ' + params[2] + #13;
    isInfo := True;
  end;
  if params.Count = 4 then
  begin
    str := str + 'Email: ' + params[3];
    isInfo := True;
  end;

  if isInfo = False then
    str := str + 'Информация не указана';
  ShowMessage(str);
end;

procedure TSimpleChatClient.ListBoxMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  point: TPoint;
  index: integer;
  TmpListBox: TListBox;
begin
  if Button = mbRight then
  begin
    TmpListBox := Sender as TListBox;
    point.X := X;
    point.Y := Y;
    index := TmpListBox.ItemAtPos(point, true);
    if index >= 0 then
    begin
      TmpListBox.Selected[index] := true;
      if TmpListBox.Items[index] <> NickEdit.Text then
      begin
        LastUserClicked := TmpListBox.Items[index];
        UserPopupMenu.Popup(TmpListBox.ClientOrigin.X + X,
          TmpListBox.ClientOrigin.Y + Y);
      end;
    end;
  end;
end;

procedure TSimpleChatClient.Log(Text: string);
var
  TmpTabSheet: TTabSheet;
  TmpListBox: TListBox;
begin
  TmpTabSheet := FindPage('Server', 0);
  if Assigned(TmpTabSheet) then
  begin
    TmpListBox := TmpTabSheet.FindChildControl('Server_Log') as TListBox;
    if Assigned(TmpListBox) then
    begin
      TmpListBox.Items.Add(Text);
      TmpListBox.TopIndex := -1 + TmpListBox.Items.Count;
    end;
  end;
end;

procedure TSimpleChatClient.OnDisconnect;
begin
  N3.Enabled := False;
  N2.Enabled := True;
  N6.Enabled := False;
  N5.Enabled := True;
  while PageControl.ComponentCount > 0 do
  begin
    PageControl.Components[0].Free;
  end;
end;

end.
