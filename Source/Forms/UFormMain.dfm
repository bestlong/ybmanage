object fMainForm: TfMainForm
  Left = 278
  Top = 255
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
      Top = 40
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
    Top = 362
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
  object WorkPanel: TPanel
    Left = 195
    Top = 80
    Width = 399
    Height = 282
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 2
    object PaintBg1: TPaintBox
      Left = 0
      Top = 0
      Width = 399
      Height = 282
      Align = alClient
      OnPaint = PaintBg1Paint
    end
    object ImageBg1: TImage
      Left = 6
      Top = 6
      Width = 105
      Height = 105
      Visible = False
    end
  end
  object Splitter1: TcxSplitter
    Left = 187
    Top = 80
    Width = 8
    Height = 282
    HotZoneClassName = 'TcxXPTaskBarStyle'
    Control = NavBar1
  end
  object NavBar1: TdxNavBar
    Left = 0
    Top = 80
    Width = 187
    Height = 282
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
