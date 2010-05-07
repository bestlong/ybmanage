inherited fFormPlant: TfFormPlant
  Left = 359
  Top = 141
  ClientHeight = 426
  ClientWidth = 452
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 452
    Height = 426
    inherited BtnOK: TButton
      Left = 303
      Top = 390
      TabOrder = 11
    end
    inherited BtnExit: TButton
      Left = 373
      Top = 390
      TabOrder = 12
    end
    object EditMemo: TcxMemo [2]
      Left = 81
      Top = 136
      Hint = 'T.P_Memo'
      ParentFont = False
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 5
      OnKeyDown = OnCtrlKeyDown
      Height = 45
      Width = 345
    end
    object InfoItems: TcxComboBox [3]
      Left = 81
      Top = 218
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      TabOrder = 6
      OnKeyDown = OnCtrlKeyDown
      Width = 90
    end
    object BtnAdd: TButton [4]
      Left = 321
      Top = 218
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 7
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [5]
      Left = 376
      Top = 218
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 8
      OnClick = BtnDelClick
    end
    object ListInfo1: TcxMCListBox [6]
      Left = 23
      Top = 293
      Width = 336
      Height = 85
      HeaderSections = <
        item
          Text = #20449#24687#39033
          Width = 74
        end
        item
          AutoSize = True
          Text = #20449#24687#20869#23481
          Width = 258
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 10
      OnClick = ListInfo1Click
      OnKeyDown = OnCtrlKeyDown
    end
    object EditAddr: TcxTextEdit [7]
      Left = 81
      Top = 86
      Hint = 'T.P_Addr'
      ParentFont = False
      TabOrder = 2
      OnKeyDown = OnCtrlKeyDown
      Width = 260
    end
    object ImagePic: TcxImage [8]
      Left = 346
      Top = 36
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      OnDblClick = ImagePicDblClick
      OnKeyDown = OnCtrlKeyDown
      Height = 95
      Width = 80
    end
    object cxTextEdit2: TcxTextEdit [9]
      Left = 81
      Top = 111
      Hint = 'T.P_Phone'
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Width = 260
    end
    object EditID: TcxButtonEdit [10]
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
      Width = 260
    end
    object EditName: TcxTextEdit [11]
      Left = 81
      Top = 61
      Hint = 'T.P_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 121
    end
    object EditInfo: TcxMemo [12]
      Left = 81
      Top = 243
      Properties.MaxLength = 500
      Properties.ScrollBars = ssVertical
      TabOrder = 9
      Height = 45
      Width = 345
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
            object dxLayout1Item4: TdxLayoutItem
              Caption = #32534#21495':'
              Control = EditID
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item12: TdxLayoutItem
              Caption = #21517#31216':'
              Control = EditName
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item14: TdxLayoutItem
              Caption = #22320#22336':'
              Control = EditAddr
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
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20449#24687#20869#23481':'
          Control = EditInfo
          ControlOptions.ShowBorder = False
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
