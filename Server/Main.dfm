object SimpleChatServer: TSimpleChatServer
  Left = 587
  Top = 160
  Caption = 'Simple Chat Server'
  ClientHeight = 347
  ClientWidth = 717
  Color = clBtnFace
  Constraints.MinHeight = 300
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 717
    Height = 277
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object Splitter3: TSplitter
      Left = 564
      Top = 0
      Height = 277
      Align = alRight
      AutoSnap = False
      ExplicitLeft = 700
      ExplicitTop = 13
      ExplicitHeight = 319
    end
    object Splitter2: TSplitter
      Left = 411
      Top = 0
      Height = 277
      Align = alRight
      AutoSnap = False
      ExplicitLeft = 601
      ExplicitTop = 2
      ExplicitHeight = 326
    end
    object LogListPanel: TPanel
      Left = 0
      Top = 0
      Width = 411
      Height = 277
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 411
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1051#1086#1075
        ExplicitWidth = 19
      end
      object LogListBox: TListBox
        Left = 0
        Top = 13
        Width = 411
        Height = 264
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object RoomsListPanel: TPanel
      Left = 414
      Top = 0
      Width = 150
      Height = 277
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object Label2: TLabel
        Left = 0
        Top = 0
        Width = 150
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1086#1084#1085#1072#1090#1099
        ExplicitWidth = 46
      end
      object RoomsListBox: TListBox
        Left = 0
        Top = 13
        Width = 150
        Height = 264
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
    object ClientsListPanel: TPanel
      Left = 567
      Top = 0
      Width = 150
      Height = 277
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 2
      object Label3: TLabel
        Left = 0
        Top = 0
        Width = 150
        Height = 13
        Align = alTop
        Alignment = taCenter
        Caption = #1050#1083#1080#1077#1085#1090#1099
        ExplicitWidth = 44
      end
      object ClientsListBox: TListBox
        Left = 0
        Top = 13
        Width = 150
        Height = 264
        Align = alClient
        ItemHeight = 13
        TabOrder = 0
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 277
    Width = 717
    Height = 70
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Panel3: TPanel
      AlignWithMargins = True
      Left = 564
      Top = 3
      Width = 150
      Height = 64
      Align = alRight
      BevelOuter = bvNone
      Ctl3D = True
      DoubleBuffered = False
      ParentCtl3D = False
      ParentDoubleBuffered = False
      TabOrder = 0
      object StartButton: TButton
        Left = 0
        Top = 0
        Width = 150
        Height = 30
        Align = alTop
        Caption = #1047#1072#1087#1091#1089#1090#1080#1090#1100' '#1089#1077#1088#1074#1077#1088
        TabOrder = 0
        OnClick = StartButtonClick
      end
      object StopButton: TButton
        Left = 0
        Top = 30
        Width = 150
        Height = 30
        Align = alTop
        Caption = #1054#1089#1090#1072#1085#1086#1074#1080#1090#1100' '#1089#1077#1088#1074#1077#1088
        Enabled = False
        TabOrder = 1
        OnClick = StopButtonClick
      end
    end
    object Panel4: TPanel
      Left = 376
      Top = 0
      Width = 185
      Height = 70
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object Label4: TLabel
        Left = 32
        Top = 24
        Width = 36
        Height = 16
        Caption = #1055#1086#1088#1090':'
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        ParentFont = False
      end
      object PortEdit: TEdit
        Left = 74
        Top = 24
        Width = 99
        Height = 21
        TabOrder = 0
        Text = '12345'
        OnChange = PortEditChange
      end
    end
  end
  object ServerSocket: TServerSocket
    Active = False
    Port = 0
    ServerType = stNonBlocking
    OnListen = ServerSocketListen
    OnClientDisconnect = ServerSocketClientDisconnect
    OnClientRead = ServerSocketClientRead
    Left = 344
    Top = 200
  end
end
