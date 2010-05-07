inherited fFormBeautician: TfFormBeautician
  Left = 296
  Top = 137
  ClientHeight = 421
  ClientWidth = 474
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 474
    Height = 421
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 324
      Top = 385
      TabOrder = 14
    end
    inherited BtnExit: TButton
      Left = 394
      Top = 385
      TabOrder = 15
    end
    object EditType: TcxComboBox [2]
      Left = 57
      Top = 136
      Hint = 'T.B_Level'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 20
      TabOrder = 5
      Width = 110
    end
    object EditName: TcxTextEdit [3]
      Left = 57
      Top = 61
      Hint = 'T.B_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      Width = 121
    end
    object EditMemo: TcxMemo [4]
      Left = 57
      Top = 186
      Hint = 'T.B_Memo'
      ParentFont = False
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 8
      Height = 40
      Width = 390
    end
    object InfoItems: TcxComboBox [5]
      Left = 69
      Top = 263
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      TabOrder = 9
      Width = 94
    end
    object EditInfo: TcxTextEdit [6]
      Left = 202
      Top = 263
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 10
      Width = 94
    end
    object BtnAdd: TButton [7]
      Left = 342
      Top = 263
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 11
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [8]
      Left = 397
      Top = 263
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 12
      OnClick = BtnDelClick
    end
    object ListInfo1: TcxMCListBox [9]
      Left = 23
      Top = 288
      Width = 372
      Height = 85
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 294
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 13
      OnClick = ListInfo1Click
    end
    object EditID: TcxButtonEdit [10]
      Left = 57
      Top = 36
      Hint = 'T.B_ID'
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
      Width = 268
    end
    object EditSex: TcxComboBox [11]
      Left = 57
      Top = 86
      Hint = 'T.B_Sex'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.Items.Strings = (
        'A=A'#12289#30007
        'B=B'#12289#22899)
      TabOrder = 2
      Width = 121
    end
    object EditAge: TcxTextEdit [12]
      Left = 57
      Top = 111
      Hint = 'T.B_Age'
      ParentFont = False
      TabOrder = 3
      Width = 82
    end
    object EditDate: TcxDateEdit [13]
      Left = 178
      Top = 111
      Hint = 'T.B_Birthday'
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object ImagePic: TcxImage [14]
      Left = 330
      Top = 36
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 7
      OnDblClick = ImagePicDblClick
      Height = 145
      Width = 117
    end
    object cxTextEdit2: TcxTextEdit [15]
      Left = 57
      Top = 161
      Hint = 'T.B_Phone'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 6
      Width = 268
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
            object dxLayout1Item12: TdxLayoutItem
              Caption = #32534#21495':'
              Control = EditID
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              Caption = #22995#21517':'
              Control = EditName
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item13: TdxLayoutItem
              Caption = #24615#21035':'
              Control = EditSex
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group6: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item14: TdxLayoutItem
                Caption = #24180#40836':'
                Control = EditAge
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item15: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #29983#26085':'
                Control = EditDate
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Group5: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              ShowBorder = False
              object dxLayout1Item4: TdxLayoutItem
                Caption = #32423#21035':'
                Control = EditType
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item16: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #30005#35805':'
                Control = cxTextEdit2
                ControlOptions.ShowBorder = False
              end
            end
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = []
            AlignHorz = ahRight
            AlignVert = avBottom
            Caption = #28857#20987#36873#25321#29031#29255
            CaptionOptions.AlignHorz = taCenter
            CaptionOptions.Layout = clBottom
            ShowCaption = False
            Control = ImagePic
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
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #38468#21152#20449#24687
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #20449#24687#39033':'
            Control = InfoItems
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #20869#23481':'
            Control = EditInfo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item9: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnAdd
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item10: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnDel
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item11: TdxLayoutItem
          Caption = #21015#34920
          ShowCaption = False
          Control = ListInfo1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
