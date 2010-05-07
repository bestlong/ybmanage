inherited fFormEditPlan: TfFormEditPlan
  Left = 351
  Top = 178
  ClientHeight = 444
  ClientWidth = 507
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 507
    Height = 444
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 507
      Height = 444
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnOK: TButton
        Left = 358
        Top = 410
        Width = 65
        Height = 22
        Caption = #20445#23384
        TabOrder = 9
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 428
        Top = 410
        Width = 65
        Height = 22
        Caption = #21462#28040
        TabOrder = 10
        OnClick = BtnExitClick
      end
      object EditName: TcxTextEdit
        Left = 81
        Top = 61
        Hint = 'T.P_Name'
        ParentFont = False
        Properties.MaxLength = 32
        TabOrder = 1
        Width = 121
      end
      object EditMemo: TcxMemo
        Left = 81
        Top = 161
        Hint = 'T.P_Memo'
        ParentFont = False
        Properties.MaxLength = 50
        Properties.ScrollBars = ssVertical
        Style.Edges = [bBottom]
        TabOrder = 6
        Height = 42
        Width = 400
      end
      object EditID: TcxButtonEdit
        Left = 81
        Top = 36
        Hint = 'T.P_ID'
        HelpType = htKeyword
        HelpKeyword = 'NU'
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.MaxLength = 15
        Properties.OnButtonClick = EditIDPropertiesButtonClick
        TabOrder = 0
        Width = 400
      end
      object EditPlan: TcxComboBox
        Left = 81
        Top = 86
        Hint = 'T.P_PlanType'
        HelpType = htKeyword
        HelpKeyword = 'I'
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        TabOrder = 2
        Width = 165
      end
      object EditSkin: TcxComboBox
        Left = 81
        Top = 111
        Hint = 'T.P_SkinType'
        HelpType = htKeyword
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        TabOrder = 3
        Width = 121
      end
      object EditDate: TcxTextEdit
        Left = 299
        Top = 136
        Hint = 'T.P_Date'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 5
        Width = 155
      end
      object EditMan: TcxTextEdit
        Left = 81
        Top = 136
        Hint = 'T.P_Man'
        ParentFont = False
        Properties.MaxLength = 32
        TabOrder = 4
        Width = 155
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
            Left = 185
            Top = 20
            Width = 54
            Height = 12
            Caption = #20449#24687#20869#23481':'
          end
          object EditInfo: TcxTextEdit
            Left = 245
            Top = 15
            ParentFont = False
            TabOrder = 0
            Width = 114
          end
          object InfoItems: TcxComboBox
            Left = 58
            Top = 15
            ParentFont = False
            TabOrder = 1
            Width = 110
          end
          object BtnAdd: TButton
            Left = 370
            Top = 14
            Width = 50
            Height = 22
            Caption = #28155#21152
            TabOrder = 2
            OnClick = BtnAddClick
          end
          object BtnDel: TButton
            Left = 422
            Top = 14
            Width = 50
            Height = 22
            Caption = #21024#38500
            TabOrder = 3
            OnClick = BtnDelClick
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
            TabOrder = 4
            OnClick = ListInfo1Click
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
          object ProductItmes: TcxComboBox
            Left = 65
            Top = 15
            ParentFont = False
            Properties.DropDownListStyle = lsEditFixedList
            Properties.ImmediateDropDown = False
            Properties.IncrementalSearch = False
            TabOrder = 0
            Width = 300
          end
          object BtnAdd2: TButton
            Left = 368
            Top = 14
            Width = 50
            Height = 22
            Caption = #28155#21152
            TabOrder = 1
            OnClick = BtnAdd2Click
          end
          object BtnDel2: TButton
            Left = 422
            Top = 14
            Width = 50
            Height = 22
            Caption = #21024#38500
            TabOrder = 2
            OnClick = BtnDel2Click
          end
          object EditReason: TcxMemo
            Left = 64
            Top = 40
            ParentFont = False
            Properties.MaxLength = 500
            Properties.ScrollBars = ssVertical
            TabOrder = 3
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
            TabOrder = 4
            OnClick = ListProduct1Click
          end
        end
      end
      object EditPlanList: TcxComboBox
        Left = 69
        Top = 410
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        Properties.OnChange = EditPlanListPropertiesChange
        TabOrder = 8
        Width = 184
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
            object dxLayout1Item3: TdxLayoutItem
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
            object dxLayout1Item4: TdxLayoutItem
              Caption = #26041#26696#20998#31867':'
              Control = EditPlan
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item12: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
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
        object dxLayoutGroup2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item1: TdxLayoutItem
            Caption = #29616#26377#26041#26696':'
            Control = EditPlanList
            ControlOptions.ShowBorder = False
          end
          object dxLayoutItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnOK
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
