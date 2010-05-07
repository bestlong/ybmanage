inherited fFormPlan: TfFormPlan
  Left = 280
  Top = 132
  ClientHeight = 445
  ClientWidth = 507
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 507
    Height = 445
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 507
      Height = 445
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnExit: TButton
        Left = 428
        Top = 410
        Width = 65
        Height = 22
        Caption = #20851#38381
        TabOrder = 9
        OnClick = BtnExitClick
      end
      object EditName: TcxTextEdit
        Left = 81
        Top = 61
        Hint = 'T.P_Name'
        ParentFont = False
        Properties.MaxLength = 32
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 121
      end
      object EditMemo: TcxMemo
        Left = 81
        Top = 161
        Hint = 'T.P_Memo'
        ParentFont = False
        Properties.MaxLength = 50
        Properties.ReadOnly = True
        Style.Edges = [bBottom]
        TabOrder = 6
        Height = 42
        Width = 400
      end
      object EditDate: TcxTextEdit
        Left = 269
        Top = 136
        Hint = 'T.P_Date'
        ParentFont = False
        Properties.MaxLength = 20
        Properties.ReadOnly = True
        TabOrder = 5
        Width = 155
      end
      object EditMan: TcxTextEdit
        Left = 81
        Top = 136
        Hint = 'T.P_Man'
        ParentFont = False
        Properties.MaxLength = 32
        Properties.ReadOnly = True
        TabOrder = 4
        Width = 125
      end
      object wPage: TcxPageControl
        Left = 11
        Top = 215
        Width = 482
        Height = 190
        ActivePage = cxSheet1
        LookAndFeel.Kind = lfOffice11
        LookAndFeel.NativeStyle = False
        ParentColor = False
        ShowFrame = True
        Style = 9
        TabOrder = 7
        TabSlants.Kind = skCutCorner
        ClientRectBottom = 189
        ClientRectLeft = 1
        ClientRectRight = 481
        ClientRectTop = 19
        object cxSheet1: TcxTabSheet
          Caption = #38468#21152#20449#24687
          ImageIndex = 0
          object Label1: TLabel
            Left = 10
            Top = 20
            Width = 42
            Height = 12
            Caption = #20449#24687#39033':'
          end
          object Label2: TLabel
            Left = 175
            Top = 20
            Width = 54
            Height = 12
            Caption = #20449#24687#20869#23481':'
          end
          object EditInfo: TcxTextEdit
            Left = 237
            Top = 15
            ParentFont = False
            Properties.ReadOnly = True
            TabOrder = 1
            Width = 235
          end
          object ListInfo1: TcxMCListBox
            Left = 10
            Top = 40
            Width = 462
            Height = 125
            HeaderSections = <
              item
                Text = #20449#24687#39033
                Width = 100
              end
              item
                AutoSize = True
                Text = #20449#24687#20869#23481
                Width = 358
              end>
            ParentFont = False
            Style.Edges = [bLeft, bTop, bRight, bBottom]
            TabOrder = 2
            OnClick = ListInfo1Click
          end
          object InfoItems: TcxTextEdit
            Left = 58
            Top = 15
            ParentFont = False
            Properties.ReadOnly = True
            TabOrder = 0
            Width = 105
          end
        end
        object cxSheet2: TcxTabSheet
          Caption = #25512#33616#20135#21697
          ImageIndex = 1
          object Label3: TLabel
            Left = 10
            Top = 20
            Width = 54
            Height = 12
            Caption = #20135#21697#21517#31216':'
          end
          object Label4: TLabel
            Left = 10
            Top = 46
            Width = 54
            Height = 12
            Caption = #25512#33616#29702#30001':'
          end
          object EditReason: TcxMemo
            Left = 64
            Top = 40
            ParentFont = False
            Properties.MaxLength = 500
            Properties.ReadOnly = True
            TabOrder = 1
            Height = 35
            Width = 408
          end
          object ListProduct1: TcxMCListBox
            Left = 10
            Top = 80
            Width = 462
            Height = 85
            HeaderSections = <
              item
                DataIndex = 1
                Text = #20135#21697#21517#31216
                Width = 100
              end
              item
                AutoSize = True
                DataIndex = 2
                Text = #25512#33616#29702#30001
                Width = 358
              end>
            ParentFont = False
            Style.Edges = [bLeft, bTop, bRight, bBottom]
            TabOrder = 2
            OnClick = ListProduct1Click
          end
          object ProductItmes: TcxComboBox
            Left = 64
            Top = 15
            ParentFont = False
            Properties.DropDownListStyle = lsEditFixedList
            Properties.ImmediateDropDown = False
            Properties.IncrementalSearch = False
            TabOrder = 0
            Width = 408
          end
        end
      end
      object EditType: TcxTextEdit
        Left = 81
        Top = 86
        Hint = 'T.P_PlanType'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 121
      end
      object EditID: TcxTextEdit
        Left = 81
        Top = 36
        Hint = 'T.P_ID'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 121
      end
      object EditSkin: TcxButtonEdit
        Left = 81
        Top = 111
        Hint = 'T.P_SkinType'
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Properties.OnButtonClick = EditSkinPropertiesButtonClick
        TabOrder = 3
        Width = 121
      end
      object BtnDel: TButton
        Left = 358
        Top = 410
        Width = 65
        Height = 22
        Caption = #21024#38500#26041#26696
        TabOrder = 8
        OnClick = BtnDelClick
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #22522#26412#20449#24687
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item8: TdxLayoutItem
              Caption = #26041#26696#32534#21495':'
              Control = EditID
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              Caption = #26041#26696#21517#31216':'
              Control = EditName
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item1: TdxLayoutItem
              Caption = #26041#26696#20998#31867':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item3: TdxLayoutItem
              Caption = #30382#32932#29366#20917':'
              Control = EditSkin
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item14: TdxLayoutItem
              Caption = #21019#24314#20154':'
              Control = EditMan
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item13: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #21019#24314#26085#26399':'
              Control = EditDate
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #22791#27880':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #20998#39029#26639
          ShowCaption = False
          Control = wPage
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group1: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = #21024#38500#26041#26696
            ShowCaption = False
            Control = BtnDel
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item2: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnExit
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
