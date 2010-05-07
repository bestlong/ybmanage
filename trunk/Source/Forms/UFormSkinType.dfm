inherited fFormSkinType: TfFormSkinType
  Left = 411
  Top = 184
  ClientHeight = 394
  ClientWidth = 471
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 471
    Height = 394
    inherited BtnOK: TButton
      Left = 323
      Top = 360
      TabOrder = 10
    end
    inherited BtnExit: TButton
      Left = 393
      Top = 360
      TabOrder = 11
    end
    object EditMemo: TcxMemo [2]
      Left = 57
      Top = 111
      Hint = 'T.T_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Height = 50
      Width = 282
    end
    object InfoItems: TcxComboBox [3]
      Left = 57
      Top = 198
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.MaxLength = 30
      TabOrder = 5
      OnKeyDown = OnCtrlKeyDown
      Width = 332
    end
    object EditInfo: TcxTextEdit [4]
      Left = 57
      Top = 223
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 6
      OnKeyDown = OnCtrlKeyDown
      Width = 275
    end
    object BtnAdd: TButton [5]
      Left = 394
      Top = 198
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 7
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [6]
      Left = 394
      Top = 223
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 8
      OnClick = BtnDelClick
    end
    object ListInfo1: TcxMCListBox [7]
      Left = 23
      Top = 248
      Width = 419
      Height = 100
      HeaderSections = <
        item
          Text = #21517#31216
          Width = 74
        end
        item
          AutoSize = True
          Text = #20869#23481
          Width = 341
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 9
      OnClick = ListInfo1Click
      OnKeyDown = OnCtrlKeyDown
    end
    object ImagePic: TcxImage [8]
      Left = 344
      Top = 36
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      OnDblClick = ImagePicDblClick
      Height = 125
      Width = 102
    end
    object EditID: TcxButtonEdit [9]
      Left = 57
      Top = 36
      Hint = 'T.T_ID'
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
      Width = 121
    end
    object EditPart: TcxComboBox [10]
      Left = 57
      Top = 86
      Hint = 'T.T_Part'
      HelpType = htKeyword
      HelpKeyword = 'I'
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 2
      OnKeyDown = OnCtrlKeyDown
      Width = 121
    end
    object EditName: TcxTextEdit [11]
      Left = 57
      Top = 61
      Hint = 'T.T_Name'
      ParentFont = False
      Properties.MaxLength = 32
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        LayoutDirection = ldHorizontal
        object dxLayout1Group4: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #32534#21495':'
            Control = EditID
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item13: TdxLayoutItem
            Caption = #21517#31216':'
            Control = EditName
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item12: TdxLayoutItem
            Caption = #37096#20301':'
            Control = EditPart
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #22791#27880':'
            Control = EditMemo
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
      object dxGroup2: TdxLayoutGroup [1]
        Caption = #30382#32932#29366#24577
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              Caption = #21517#31216':'
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
          end
          object dxLayout1Group7: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
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
