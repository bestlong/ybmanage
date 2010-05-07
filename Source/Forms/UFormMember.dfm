inherited fFormMember: TfFormMember
  Left = 318
  Top = 171
  ClientHeight = 479
  ClientWidth = 539
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 539
    Height = 479
    inherited BtnOK: TButton
      Left = 392
      Top = 446
      TabOrder = 15
    end
    inherited BtnExit: TButton
      Left = 462
      Top = 446
      TabOrder = 16
    end
    object EditID: TcxButtonEdit [2]
      Left = 81
      Top = 36
      Hint = 'T.M_ID'
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.MaxLength = 15
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      Width = 248
    end
    object cxTextEdit1: TcxTextEdit [3]
      Left = 81
      Top = 61
      Hint = 'T.M_Name'
      ParentFont = False
      Properties.MaxLength = 30
      TabOrder = 1
      Width = 110
    end
    object EditSex: TcxComboBox [4]
      Left = 81
      Top = 86
      Hint = 'T.M_Sex'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.Items.Strings = (
        'A=A'#12289#30007
        'B=B'#12289#22899)
      TabOrder = 3
      Width = 110
    end
    object EditAge: TcxTextEdit [5]
      Left = 254
      Top = 86
      Hint = 'T.M_Age'
      ParentFont = False
      Properties.MaxLength = 5
      TabOrder = 4
      Text = '0'
      Width = 110
    end
    object EditHeight: TcxTextEdit [6]
      Left = 81
      Top = 111
      Hint = 'T.M_Height'
      ParentFont = False
      Properties.MaxLength = 10
      TabOrder = 5
      Text = '0'
      Width = 110
    end
    object EditBirthday: TcxDateEdit [7]
      Left = 81
      Top = 136
      Hint = 'T.M_BirthDay'
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 7
      Width = 110
    end
    object EditWeight: TcxTextEdit [8]
      Left = 254
      Top = 111
      Hint = 'T.M_Weight'
      ParentFont = False
      Properties.MaxLength = 10
      TabOrder = 6
      Text = '0'
      Width = 110
    end
    object cxTextEdit5: TcxTextEdit [9]
      Left = 81
      Top = 161
      Hint = 'T.M_Phone'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 9
      Width = 294
    end
    object EditCDate: TcxDateEdit [10]
      Left = 254
      Top = 136
      Hint = 'T.M_CDate'
      ParentFont = False
      Properties.SaveTime = False
      Properties.ShowTime = False
      TabOrder = 8
      Width = 110
    end
    object cxTextEdit6: TcxTextEdit [11]
      Left = 81
      Top = 186
      Hint = 'T.M_Addr'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 10
      Width = 294
    end
    object cxImage1: TcxImage [12]
      Left = 380
      Top = 36
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 11
      OnClick = cxImage1Click
      Height = 170
      Width = 135
    end
    object wPage: TcxPageControl [13]
      Left = 11
      Top = 273
      Width = 396
      Height = 168
      ActivePage = cxSheet1
      ParentColor = False
      ShowFrame = True
      Style = 9
      TabOrder = 13
      TabSlants.Kind = skCutCorner
      OnChange = wPageChange
      ClientRectBottom = 167
      ClientRectLeft = 1
      ClientRectRight = 395
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
        object InfoItems: TcxComboBox
          Left = 58
          Top = 15
          ParentFont = False
          TabOrder = 0
          Width = 110
        end
        object EditInfo: TcxTextEdit
          Left = 235
          Top = 15
          ParentFont = False
          TabOrder = 1
          Width = 160
        end
        object BtnAdd: TButton
          Left = 400
          Top = 14
          Width = 50
          Height = 22
          Caption = #28155#21152
          TabOrder = 2
          OnClick = BtnAddClick
        end
        object BtnDel: TButton
          Left = 452
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
          Width = 492
          Height = 100
          HeaderSections = <
            item
              Text = #20449#24687#39033
              Width = 100
            end
            item
              AutoSize = True
              Text = #20449#24687#20869#23481
              Width = 388
            end>
          ParentFont = False
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 4
          OnClick = ListInfo1Click
        end
      end
      object cxSheet2: TcxTabSheet
        Caption = #20250#21592#20851#31995
        ImageIndex = 1
        object Label3: TLabel
          Left = 10
          Top = 20
          Width = 54
          Height = 12
          Caption = #20851#31995#21517#31216':'
        end
        object Label4: TLabel
          Left = 175
          Top = 20
          Width = 54
          Height = 12
          Caption = #20851#31995#20250#21592':'
        end
        object RelationName: TcxComboBox
          Left = 70
          Top = 15
          ParentFont = False
          TabOrder = 0
          Width = 100
        end
        object ListRelation1: TcxMCListBox
          Left = 10
          Top = 40
          Width = 492
          Height = 100
          HeaderSections = <
            item
              Text = #20851#31995#21517#31216
              Width = 100
            end
            item
              AutoSize = True
              Text = #20851#31995#20250#21592
              Width = 388
            end>
          ParentFont = False
          Style.Edges = [bLeft, bTop, bRight, bBottom]
          TabOrder = 1
          OnClick = ListRelation1Click
        end
        object BtnAdd2: TButton
          Left = 400
          Top = 14
          Width = 50
          Height = 22
          Caption = #28155#21152
          TabOrder = 2
          OnClick = BtnAdd2Click
        end
        object BtnDel2: TButton
          Left = 452
          Top = 14
          Width = 50
          Height = 22
          Caption = #21024#38500
          TabOrder = 3
          OnClick = BtnDel2Click
        end
        object RelationMember: TcxComboBox
          Left = 235
          Top = 15
          ParentFont = False
          Properties.DropDownListStyle = lsEditFixedList
          Properties.ImmediateDropDown = False
          Properties.IncrementalSearch = False
          TabOrder = 4
          Width = 160
        end
      end
    end
    object cxMemo1: TcxMemo [14]
      Left = 81
      Top = 211
      Hint = 'T.M_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      TabOrder = 12
      Height = 50
      Width = 434
    end
    object EditBeauty: TcxTextEdit [15]
      Left = 57
      Top = 446
      Hint = 'T.M_Beautician'
      HelpType = htKeyword
      HelpKeyword = 'NI|NU'
      ParentFont = False
      Properties.MaxLength = 15
      TabOrder = 14
      Width = 121
    end
    object EditType: TcxComboBox [16]
      Left = 254
      Top = 61
      Hint = 'T.M_Type'
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 2
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item3: TdxLayoutItem
              Caption = #20250#21592#32534#21495':'
              Control = EditID
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group7: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item4: TdxLayoutItem
                Caption = #20250#21592#22995#21517':'
                Control = cxTextEdit1
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item17: TdxLayoutItem
                Caption = #31867'    '#21035':'
                Control = EditType
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group2: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item5: TdxLayoutItem
                Caption = #24615'    '#21035':'
                Control = EditSex
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item6: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #24180'    '#40836':'
                Control = EditAge
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group5: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item7: TdxLayoutItem
                Caption = #36523#39640'(CM):'
                Control = EditHeight
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item9: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #20307#37325'(KG):'
                Control = EditWeight
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group6: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              ShowBorder = False
              object dxLayout1Group8: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                LayoutDirection = ldHorizontal
                ShowBorder = False
                object dxLayout1Item8: TdxLayoutItem
                  Caption = #29983'    '#26085':'
                  Control = EditBirthday
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item11: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  AlignHorz = ahClient
                  Caption = #24314#26723#26085#26399':'
                  Control = EditCDate
                  ControlOptions.ShowBorder = False
                end
              end
              object dxLayout1Item10: TdxLayoutItem
                Caption = #32852#31995#26041#24335':'
                Control = cxTextEdit5
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item12: TdxLayoutItem
                Caption = #32852#31995#22320#22336':'
                Control = cxTextEdit6
                ControlOptions.ShowBorder = False
              end
            end
          end
          object dxLayout1Item13: TdxLayoutItem
            Caption = #28857#20987#36873#25321#29031#29255
            CaptionOptions.AlignHorz = taCenter
            CaptionOptions.Layout = clBottom
            ShowCaption = False
            Control = cxImage1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = cxMemo1
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Item14: TdxLayoutItem [1]
        Caption = #20998#39029#22841
        ShowCaption = False
        Control = wPage
        ControlOptions.AutoColor = True
        ControlOptions.ShowBorder = False
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        object dxLayout1Item16: TdxLayoutItem [0]
          Caption = #32654#23481#24072':'
          Visible = False
          Control = EditBeauty
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
