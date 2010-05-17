object fMainForm: TfMainForm
  Left = 272
  Top = 226
  Width = 602
  Height = 428
  Color = clWhite
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object HintPanel: TPanel
    Left = 0
    Top = 0
    Width = 594
    Height = 80
    Align = alTop
    BevelOuter = bvNone
    Ctl3D = True
    ParentCtl3D = False
    TabOrder = 0
    object HintLabel: TLabel
      Left = 8
      Top = 26
      Width = 90
      Height = 20
      Caption = 'HintLabel'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      Transparent = True
    end
  end
  object sBar: TStatusBar
    Left = 0
    Top = 354
    Width = 594
    Height = 20
    Panels = <
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end
      item
        Width = 50
      end>
  end
  object Splitter1: TcxSplitter
    Left = 187
    Top = 80
    Width = 8
    Height = 274
    HotZoneClassName = 'TcxXPTaskBarStyle'
    Control = NavBar1
  end
  object NavBar1: TdxNavBar
    Left = 0
    Top = 80
    Width = 187
    Height = 274
    Align = alLeft
    ActiveGroupIndex = 0
    DragCopyCursor = -1119
    DragCursor = -1120
    DragDropFlags = [fAllowDragLink, fAllowDropLink, fAllowDragGroup, fAllowDropGroup]
    HotTrackedGroupCursor = crDefault
    HotTrackedLinkCursor = -1118
    LargeImages = FDM.ImageMid
    SmallImages = FDM.Imagesmall
    View = 10
    object BarGroup1: TdxNavBarGroup
      Caption = #24120#29992#21151#33021
      LargeImageIndex = 0
      LinksUseSmallImages = True
      SelectedLinkIndex = -1
      ShowAsIconView = False
      ShowControl = False
      TopVisibleLinkIndex = 0
      UseControl = False
      UseSmallImages = False
      Visible = True
      Links = <>
    end
    object BarGroup2: TdxNavBarGroup
      Caption = #26368#36817#20351#29992
      LargeImageIndex = 1
      LinksUseSmallImages = True
      SelectedLinkIndex = -1
      ShowAsIconView = False
      ShowControl = False
      TopVisibleLinkIndex = 0
      UseControl = False
      UseSmallImages = False
      Visible = True
      Links = <>
    end
  end
  object wTab: TcxTabControl
    Left = 195
    Top = 80
    Width = 399
    Height = 274
    Align = alClient
    Options = [pcoAlwaysShowGoDialogButton, pcoGoDialog, pcoGradient, pcoGradientClientArea, pcoRedrawOnResize]
    ShowFrame = True
    Style = 9
    TabIndex = 0
    TabOrder = 4
    Tabs.Strings = (
      'test')
    TabSlants.Kind = skCutCorner
    OnChange = wTabChange
    ClientRectBottom = 273
    ClientRectLeft = 1
    ClientRectRight = 398
    ClientRectTop = 19
    object WorkPanel: TZnBitmapPanel
      Left = 1
      Top = 19
      Width = 397
      Height = 254
      Align = alClient
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 16
    Top = 186
    object N1: TMenuItem
      Caption = #25991#20214
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 44
    Top = 186
  end
end
