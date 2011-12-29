program Client;

uses
  Forms,
  Main in 'Main.pas' {SimpleChatClient},
  AboutDlg in 'AboutDlg.pas' {About},
  CommonUtils in '..\CommonUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TSimpleChatClient, SimpleChatClient);
  Application.CreateForm(TAbout, About);
  Application.Run;
end.
