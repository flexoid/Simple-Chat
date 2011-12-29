object SimpleChatClient: TSimpleChatClient
  Left = 0
  Top = 0
  Caption = 'Simple Chat Client'
  ClientHeight = 350
  ClientWidth = 749
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 500
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SettingsPanel: TPanel
    Left = 564
    Top = 0
    Width = 185
    Height = 350
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 0
    Visible = False
    object Label1: TLabel
      Left = 24
      Top = 16
      Width = 75
      Height = 13
      Caption = #1040#1076#1088#1077#1089' '#1089#1077#1088#1074#1077#1088#1072
    end
    object Label2: TLabel
      Left = 84
      Top = 67
      Width = 19
      Height = 13
      Caption = #1053#1080#1082
    end
    object Label3: TLabel
      Left = 136
      Top = 16
      Width = 25
      Height = 13
      Caption = #1055#1086#1088#1090
    end
    object IpEdit: TEdit
      Left = 15
      Top = 35
      Width = 107
      Height = 21
      Align = alCustom
      TabOrder = 0
      Text = '127.0.0.1'
      OnChange = IpEditChange
    end
    object NickEdit: TEdit
      Left = 36
      Top = 85
      Width = 121
      Height = 21
      TabOrder = 1
      Text = 'Anonymous'
      OnChange = NickEditChange
    end
    object GroupBox1: TGroupBox
      Left = 6
      Top = 126
      Width = 171
      Height = 105
      Caption = #1053#1077#1086#1073#1103#1079#1072#1090#1077#1083#1100#1085#1099#1077' '#1087#1072#1088#1072#1084#1077#1090#1088#1099
      TabOrder = 2
      object Label4: TLabel
        Left = 14
        Top = 31
        Width = 28
        Height = 13
        Caption = 'Email:'
      end
      object Label5: TLabel
        Left = 14
        Top = 65
        Width = 44
        Height = 13
        Caption = #1042#1086#1079#1088#1072#1089#1090':'
      end
      object EmailEdit: TEdit
        Left = 52
        Top = 28
        Width = 107
        Height = 21
        TabOrder = 0
      end
      object AgeEdit: TEdit
        Left = 88
        Top = 62
        Width = 71
        Height = 21
        TabOrder = 1
      end
    end
    object PortEdit: TEdit
      Left = 129
      Top = 35
      Width = 42
      Height = 21
      TabOrder = 3
      Text = '12345'
      OnChange = IpEditChange
    end
    object OkSettingsButton: TButton
      Left = 56
      Top = 237
      Width = 75
      Height = 25
      Caption = 'OK'
      Default = True
      TabOrder = 4
      OnClick = OkSettingsButtonClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 564
    Height = 350
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 1
    object PageControl: TPageControl
      Left = 0
      Top = 0
      Width = 564
      Height = 317
      Align = alClient
      DoubleBuffered = False
      MultiLine = True
      ParentDoubleBuffered = False
      PopupMenu = TabPopup
      TabOrder = 0
      OnChange = PageControlChange
      OnMouseDown = PageControlMouseDown
    end
    object Panel1: TPanel
      Left = 0
      Top = 317
      Width = 564
      Height = 33
      Align = alBottom
      BevelOuter = bvNone
      Caption = 'Panel1'
      TabOrder = 1
      object SendButton: TButton
        AlignWithMargins = True
        Left = 484
        Top = 5
        Width = 75
        Height = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alRight
        Caption = #1054#1090#1087#1088#1072#1074#1080#1090#1100
        Default = True
        TabOrder = 1
        OnClick = SendButtonClick
      end
      object SendEdit: TEdit
        AlignWithMargins = True
        Left = 5
        Top = 5
        Width = 469
        Height = 23
        Margins.Left = 5
        Margins.Top = 5
        Margins.Right = 5
        Margins.Bottom = 5
        Align = alClient
        TabOrder = 0
        ExplicitHeight = 21
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 704
    Top = 312
    object N1: TMenuItem
      Caption = #1057#1086#1077#1076#1080#1085#1077#1085#1080#1077
      object N2: TMenuItem
        Caption = #1055#1086#1076#1082#1083#1102#1095#1080#1090#1100#1089#1103
        OnClick = ConnectClick
      end
      object N3: TMenuItem
        Caption = #1054#1090#1082#1083#1102#1095#1080#1090#1100#1089#1103
        Enabled = False
        OnClick = N3Click
      end
    end
    object N6: TMenuItem
      Caption = #1044#1077#1081#1089#1090#1074#1080#1103
      Enabled = False
      object N7: TMenuItem
        Caption = #1042#1086#1081#1090#1080' '#1074' '#1082#1086#1084#1085#1072#1090#1091'...'
        OnClick = N7Click
      end
    end
    object N5: TMenuItem
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080
      OnClick = N5Click
    end
    object N4: TMenuItem
      Caption = #1042#1099#1093#1086#1076
      OnClick = N4Click
    end
    object N10: TMenuItem
      Caption = '-'
    end
    object N11: TMenuItem
      Caption = #1054' '#1087#1088#1086#1075#1088#1072#1084#1084#1077
      OnClick = N11Click
    end
  end
  object ClientSocket: TClientSocket
    Active = False
    ClientType = ctNonBlocking
    Port = 0
    OnConnect = ClientSocketConnect
    OnDisconnect = ClientSocketDisconnect
    OnRead = ClientSocketRead
    OnError = ClientSocketError
    Left = 688
    Top = 272
  end
  object UserPopupMenu: TPopupMenu
    AutoPopup = False
    Left = 608
    Top = 280
    object d1: TMenuItem
      Caption = #1055#1088#1080#1074#1072#1090#1085#1099#1081' '#1095#1072#1090
      OnClick = d1Click
    end
    object N9: TMenuItem
      Caption = #1048#1085#1092#1086#1088#1084#1072#1094#1080#1103
      OnClick = N9Click
    end
  end
  object TabPopup: TPopupMenu
    AutoPopup = False
    Left = 192
    Top = 240
    object N8: TMenuItem
      Caption = #1047#1072#1082#1088#1099#1090#1100
      OnClick = N8Click
    end
  end
end
