inherited fFormPlan: TfFormPlan
  Left = 296
  Top = 137
  ClientHeight = 448
  ClientWidth = 491
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 491
    Height = 448
    inherited BtnOK: TButton
      Left = 341
      Top = 410
      TabOrder = 8
    end
    inherited BtnExit: TButton
      Left = 411
      Top = 410
      TabOrder = 9
    end
    object EditName: TcxTextEdit [2]
      Left = 81
      Top = 61
      Hint = 'T.P_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 10
    end
    object EditMemo: TcxMemo [3]
      Left = 81
      Top = 161
      Hint = 'T.P_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 6
      OnKeyDown = OnCtrlKeyDown
      Height = 42
      Width = 10
    end
    object EditID: TcxButtonEdit [4]
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
      OnKeyDown = OnCtrlKeyDown
      Width = 10
    end
    object EditPlan: TcxComboBox [5]
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
      OnKeyDown = OnCtrlKeyDown
      Width = 10
    end
    object EditSkin: TcxComboBox [6]
      Left = 81
      Top = 111
      Hint = 'T.P_SkinType'
      HelpType = htKeyword
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Width = 10
    end
    object EditDate: TcxTextEdit [7]
      Left = 284
      Top = 136
      Hint = 'T.P_Date'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 5
      OnKeyDown = OnCtrlKeyDown
      Width = 155
    end
    object EditMan: TcxTextEdit [8]
      Left = 81
      Top = 136
      Hint = 'T.P_Man'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 4
      OnKeyDown = OnCtrlKeyDown
      Width = 140
    end
    object wPage: TcxPageControl [9]
      Left = 11
      Top = 215
      Width = 465
      Height = 190
      ActivePage = cxSheet1
      LookAndFeel.Kind = lfOffice11
      LookAndFeel.NativeStyle = False
      ParentColor = False
      ShowFrame = True
      Style = 9
      TabOrder = 7
      TabSlants.Kind = skCutCorner
      OnChange = wPageChange
      ClientRectBottom = 189
      ClientRectLeft = 1
      ClientRectRight = 464
      ClientRectTop = 19
      object cxSheet1: TcxTabSheet
        Caption = #38468#21152#20449#24687
        ImageIndex = 0
        object Label1: TLabel
          Left = 10
          Top = 20
          Width = 54
          Height = 12
          Caption = #20449' '#24687' '#39033':'
        end
        object Label2: TLabel
          Left = 10
          Top = 46
          Width = 54
          Height = 12
          Caption = #20449#24687#20869#23481':'
        end
        object InfoItems: TcxComboBox
          Left = 65
          Top = 15
          ParentFont = False
          TabOrder = 0
          OnKeyDown = OnCtrlKeyDown
          Width = 280
        end
        object BtnAdd: TButton
          Left = 348
          Top = 14
          Width = 50
          Height = 22
          Caption = #28155#21152
          TabOrder = 1
          OnClick = BtnAddClick
        end
        object BtnDel: TButton
          Left = 400
          Top = 14
          Width = 50
          Height = 22
          Caption = #21024#38500
          TabOrder = 2
          OnClick = BtnDelClick
        end
        object ListInfo1: TcxMCListBox
          Left = 10
          Top = 80
          Width = 440
          Height = 85
          HeaderSections = <
            item
              Text = #20449#24687#39033
              Width = 100
            end
            item
              AutoSize = True
              Text = #20449#24687#20869#23481
              Width = 336
            end>
          ParentFont = False
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 3
          OnClick = ListInfo1Click
          OnKeyDown = OnCtrlKeyDown
        end
        object EditInfo: TcxMemo
          Left = 65
          Top = 40
          ParentFont = False
          Properties.MaxLength = 500
          Properties.ScrollBars = ssVertical
          TabOrder = 4
          OnKeyDown = OnCtrlKeyDown
          Height = 35
          Width = 385
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
          OnKeyDown = OnCtrlKeyDown
          Width = 280
        end
        object BtnAdd2: TButton
          Left = 348
          Top = 14
          Width = 50
          Height = 22
          Caption = #28155#21152
          TabOrder = 1
          OnClick = BtnAdd2Click
        end
        object BtnDel2: TButton
          Left = 400
          Top = 14
          Width = 50
          Height = 22
          Caption = #21024#38500
          TabOrder = 2
          OnClick = BtnDel2Click
        end
        object EditReason: TcxMemo
          Left = 65
          Top = 40
          ParentFont = False
          Properties.MaxLength = 255
          Properties.ScrollBars = ssVertical
          TabOrder = 3
          OnKeyDown = OnCtrlKeyDown
          Height = 35
          Width = 385
        end
        object ListProduct1: TcxMCListBox
          Left = 10
          Top = 80
          Width = 440
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
              Width = 336
            end>
          ParentFont = False
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 4
          OnClick = ListProduct1Click
          OnKeyDown = OnCtrlKeyDown
        end
      end
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
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
            Caption = #21019' '#24314' '#20154':'
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
      object dxLayout1Item15: TdxLayoutItem [1]
        Caption = #20998#39029#26639
        ShowCaption = False
        Control = wPage
        ControlOptions.AutoColor = True
        ControlOptions.ShowBorder = False
      end
    end
  end
end
