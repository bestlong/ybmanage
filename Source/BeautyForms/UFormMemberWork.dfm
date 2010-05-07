inherited fFormMemberWork: TfFormMemberWork
  Left = 286
  Top = 168
  ClientHeight = 347
  ClientWidth = 561
  OldCreateOrder = True
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 561
    Height = 347
    object dxNavBar1: TdxNavBar
      Left = 0
      Top = 0
      Width = 165
      Height = 347
      Align = alLeft
      Locked = True
      PopupMenu = PMenu1
      ActiveGroupIndex = 0
      DragCopyCursor = -1119
      DragCursor = -1120
      DragDropFlags = [fAllowDropLink, fAllowDropGroup]
      HotTrackedGroupCursor = crDefault
      HotTrackedLinkCursor = -1118
      LargeImages = FDM.ImageBig
      NavigationPaneMaxVisibleGroups = 0
      SmallImages = FDM.Imagesmall
      View = 13
      object Group_SysFun: TdxNavBarGroup
        Caption = #31995#32479#21151#33021
        LinksUseSmallImages = False
        SelectedLinkIndex = -1
        ShowAsIconView = False
        ShowControl = False
        TopVisibleLinkIndex = 0
        UseControl = False
        UseSmallImages = True
        Visible = True
        Links = <
          item
            Item = Button_MyInfo
          end
          item
            Item = Button_Pick
          end
          item
            Item = Button_Contrast
          end
          item
            Item = Button_Parse
          end
          item
            Item = Button_Report
          end
          item
            Item = Button_Return
          end>
      end
      object Group_Plan: TdxNavBarGroup
        Caption = #26041#26696#21015#34920
        LinksUseSmallImages = False
        SelectedLinkIndex = -1
        ShowAsIconView = False
        ShowControl = False
        TopVisibleLinkIndex = 0
        UseControl = False
        UseSmallImages = True
        Visible = True
        Links = <>
      end
      object Button_Return: TdxNavBarItem
        Caption = #36820#22238#20027#33756#21333
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_ReturnClick
      end
      object Button_MyInfo: TdxNavBarItem
        Caption = #20250#21592#20449#24687
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_MyInfoClick
      end
      object Button_Pick: TdxNavBarItem
        Caption = #22270#20687#37319#38598
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_PickClick
      end
      object Button_Contrast: TdxNavBarItem
        Caption = #22270#20687#23545#27604
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_ContrastClick
      end
      object Button_Parse: TdxNavBarItem
        Caption = #22270#20687#20998#26512
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_ParseClick
      end
      object Button_Report: TdxNavBarItem
        Caption = #29983#25104#25253#21578
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_ReportClick
      end
    end
    object wPanel: TZnGlassControl
      Left = 165
      Top = 0
      Width = 396
      Height = 347
      Align = alClient
      Color = clWhite
      Ctl3D = False
    end
  end
  object PMenu1: TPopupMenu
    Left = 4
    Top = 30
    object adsf1: TMenuItem
      Caption = 'adsf'
    end
  end
end
