inherited fFormNavMain: TfFormNavMain
  Left = 190
  Top = 143
  ClientHeight = 351
  ClientWidth = 600
  OldCreateOrder = True
  WindowState = wsMaximized
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 600
    Height = 351
    object dxNavBar1: TdxNavBar
      Left = 0
      Top = 0
      Width = 165
      Height = 351
      Align = alLeft
      Locked = True
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
      object Group_Member: TdxNavBarGroup
        Caption = #20250#21592#21015#34920
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
      object Group_Plan: TdxNavBarGroup
        Caption = #26041#26696#21015#34920
        LinksUseSmallImages = False
        SelectedLinkIndex = -1
        ShowAsIconView = False
        ShowControl = False
        TopVisibleLinkIndex = 0
        UseControl = False
        UseSmallImages = True
        Visible = False
        Links = <>
      end
      object Group_Product: TdxNavBarGroup
        Caption = #20135#21697#21015#34920
        LinksUseSmallImages = False
        SelectedLinkIndex = -1
        ShowAsIconView = False
        ShowControl = False
        TopVisibleLinkIndex = 0
        UseControl = False
        UseSmallImages = True
        Visible = False
        Links = <>
      end
      object Group_System: TdxNavBarGroup
        Caption = #31995#32479#31649#29702
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
            Item = Button_Member
          end
          item
            Item = Button_Plan
          end
          item
            Item = Button_Product
          end
          item
            Item = Button_Hardware
          end
          item
            Item = Button_Sync
          end
          item
            Item = Button_Exit
          end>
      end
      object Button_Exit: TdxNavBarItem
        Caption = #36864#20986#31995#32479
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_ExitClick
      end
      object Button_Member: TdxNavBarItem
        Caption = #20250#21592#31649#29702
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_MemberClick
      end
      object Button_Plan: TdxNavBarItem
        Caption = #26041#26696#39044#35272
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_PlanClick
      end
      object Button_Sync: TdxNavBarItem
        Caption = #25968#25454#21516#27493
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_SyncClick
      end
      object Button_Hardware: TdxNavBarItem
        Caption = #30828#20214#35774#32622
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_HardwareClick
      end
      object Button_Product: TdxNavBarItem
        Caption = #20135#21697#27983#35272
        Enabled = True
        LargeImageIndex = -1
        SmallImageIndex = -1
        Visible = True
        OnClick = Button_ProductClick
      end
    end
    object wPanel: TZnTransPanel
      Left = 165
      Top = 0
      Width = 435
      Height = 351
      Align = alClient
      OnResize = wPanelResize
      object dxLayout1: TdxLayoutControl
        Left = 17
        Top = 54
        Width = 382
        Height = 257
        TabOrder = 0
        LookAndFeel = FDM.dxLayoutWeb1
        object EditUser: TcxTextEdit
          Left = 81
          Top = 61
          ParentFont = False
          Properties.ReadOnly = True
          TabOrder = 1
          Width = 278
        end
        object EditTime: TcxTextEdit
          Left = 81
          Top = 36
          ParentFont = False
          Properties.ReadOnly = True
          TabOrder = 0
          Width = 278
        end
        object EditLevel: TcxTextEdit
          Left = 81
          Top = 86
          ParentFont = False
          Properties.ReadOnly = True
          TabOrder = 2
          Width = 278
        end
        object EditNumber: TcxTextEdit
          Left = 81
          Top = 168
          ParentFont = False
          Properties.ReadOnly = True
          TabOrder = 4
          Width = 278
        end
        object EditFind: TcxButtonEdit
          Left = 81
          Top = 218
          ParentFont = False
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = False
          Properties.OnButtonClick = EditFindPropertiesButtonClick
          TabOrder = 6
          Width = 278
        end
        object EditBirthday: TcxButtonEdit
          Left = 81
          Top = 193
          ParentFont = False
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.ReadOnly = True
          Properties.OnButtonClick = EditBirthdayPropertiesButtonClick
          TabOrder = 5
          Width = 278
        end
        object EditPwd: TcxButtonEdit
          Left = 81
          Top = 111
          Properties.Buttons = <
            item
              Default = True
              Kind = bkEllipsis
            end>
          Properties.OnButtonClick = EditPwdPropertiesButtonClick
          TabOrder = 3
          Width = 121
        end
        object dxLayoutGroup1: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxGroup1: TdxLayoutGroup
            Caption = #25688#35201#20449#24687
            object dxLayout1Item2: TdxLayoutItem
              Caption = #24403#21069#26102#38388':'
              Control = EditTime
              ControlOptions.ShowBorder = False
            end
            object dxLayoutItem1: TdxLayoutItem
              Caption = #24403#21069#29992#25143':'
              Control = EditUser
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item3: TdxLayoutItem
              Caption = #29992#25143#32423#21035':'
              Control = EditLevel
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item1: TdxLayoutItem
              Caption = #20462#25913#23494#30721':'
              Control = EditPwd
              ControlOptions.ShowBorder = False
            end
          end
          object dxGroup2: TdxLayoutGroup
            Caption = #20250#21592#20449#24687
            object dxLayoutItem2: TdxLayoutItem
              Caption = #20250#21592#20154#25968':'
              Control = EditNumber
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              Caption = #20170#22825#29983#26085':'
              Control = EditBirthday
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              Caption = #24555#36895#26597#25214':'
              Control = EditFind
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 188
    Top = 12
  end
end
