inherited fFormProduct: TfFormProduct
  Left = 296
  Top = 137
  ClientHeight = 446
  ClientWidth = 483
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 483
    Height = 446
    inherited BtnOK: TButton
      Left = 334
      Top = 410
      TabOrder = 13
    end
    inherited BtnExit: TButton
      Left = 404
      Top = 410
      TabOrder = 14
    end
    object EditPlant: TcxComboBox [2]
      Left = 81
      Top = 111
      Hint = 'T.P_Plant'
      HelpType = htKeyword
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 15
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Width = 160
    end
    object EditName: TcxTextEdit [3]
      Left = 81
      Top = 61
      Hint = 'T.P_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 160
    end
    object EditMemo: TcxMemo [4]
      Left = 81
      Top = 161
      Hint = 'T.P_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 7
      OnKeyDown = OnCtrlKeyDown
      Height = 40
      Width = 376
    end
    object InfoItems: TcxComboBox [5]
      Left = 81
      Top = 238
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      TabOrder = 8
      OnKeyDown = OnCtrlKeyDown
      Width = 10
    end
    object BtnAdd: TButton [6]
      Left = 352
      Top = 238
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 9
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [7]
      Left = 407
      Top = 238
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 10
      OnClick = BtnDelClick
    end
    object ListInfo1: TcxMCListBox [8]
      Left = 23
      Top = 313
      Width = 434
      Height = 85
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 356
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 12
      OnClick = ListInfo1Click
      OnKeyDown = OnCtrlKeyDown
    end
    object EditID: TcxButtonEdit [9]
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
      Width = 160
    end
    object EditType: TcxComboBox [10]
      Left = 81
      Top = 86
      Hint = 'T.P_Type'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 2
      OnKeyDown = OnCtrlKeyDown
      Width = 160
    end
    object ImagePic: TcxImage [11]
      Left = 362
      Top = 36
      Properties.Stretch = True
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 6
      OnDblClick = ImagePicDblClick
      Height = 120
      Width = 95
    end
    object EditProvider: TcxComboBox [12]
      Left = 81
      Top = 136
      Hint = 'T.P_Provider'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.MaxLength = 15
      TabOrder = 4
      OnKeyDown = OnCtrlKeyDown
      Width = 160
    end
    object EditPrice: TcxTextEdit [13]
      Left = 304
      Top = 136
      Hint = 'T.P_Price'
      HelpType = htKeyword
      HelpKeyword = 'D'
      ParentFont = False
      TabOrder = 5
      Text = '0.00'
      OnKeyDown = OnCtrlKeyDown
      Width = 53
    end
    object EditInfo: TcxMemo [14]
      Left = 81
      Top = 263
      Properties.MaxLength = 500
      Properties.ScrollBars = ssVertical
      TabOrder = 11
      Height = 45
      Width = 10
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
              Caption = #20135#21697#32534#21495':'
              Control = EditID
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item5: TdxLayoutItem
              Caption = #20135#21697#21517#31216':'
              Control = EditName
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item13: TdxLayoutItem
              Caption = #25152#23646#31867#21035':'
              Control = EditType
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              Caption = #29983#20135#21378#21830':'
              Control = EditPlant
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group6: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item14: TdxLayoutItem
                Caption = #20379' '#24212' '#21830':'
                Control = EditProvider
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item15: TdxLayoutItem
                Caption = #21806#20215'('#20803'):'
                Control = EditPrice
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
          ShowBorder = False
          object dxLayout1Group8: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449' '#24687' '#39033':'
              Control = InfoItems
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
          object dxLayout1Item16: TdxLayoutItem
            Caption = #20449#24687#20869#23481':'
            Control = EditInfo
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
