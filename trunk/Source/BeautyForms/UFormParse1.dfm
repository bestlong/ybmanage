inherited fFormParse: TfFormParse
  Left = 341
  Top = 224
  ClientHeight = 413
  ClientWidth = 477
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 477
    Height = 413
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 477
      Height = 413
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnOK: TButton
        Left = 330
        Top = 380
        Width = 65
        Height = 22
        Caption = #24320#22788#26041
        TabOrder = 12
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 400
        Top = 380
        Width = 65
        Height = 22
        Caption = #21462#28040
        TabOrder = 13
        OnClick = BtnExitClick
      end
      object EditMemo: TcxMemo
        Left = 57
        Top = 111
        Hint = 'T.T_Memo'
        ParentFont = False
        Properties.MaxLength = 50
        Style.Edges = [bBottom]
        TabOrder = 4
        Height = 50
        Width = 262
      end
      object InfoItems: TcxComboBox
        Left = 57
        Top = 198
        ParentFont = False
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        Properties.MaxLength = 30
        TabOrder = 6
        Width = 338
      end
      object EditInfo: TcxTextEdit
        Left = 57
        Top = 223
        ParentFont = False
        Properties.MaxLength = 50
        TabOrder = 7
        Width = 338
      end
      object BtnAdd: TButton
        Left = 400
        Top = 198
        Width = 50
        Height = 20
        Caption = #28155#21152
        TabOrder = 8
        OnClick = BtnAddClick
      end
      object BtnDel: TButton
        Left = 400
        Top = 223
        Width = 50
        Height = 20
        Caption = #21024#38500
        TabOrder = 9
        OnClick = BtnDelClick
      end
      object ListInfo1: TcxMCListBox
        Left = 23
        Top = 248
        Width = 388
        Height = 120
        HeaderSections = <
          item
            Text = #21517#31216
            Width = 74
          end
          item
            AutoSize = True
            Text = #20869#23481
            Width = 310
          end>
        ParentFont = False
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 10
        OnClick = ListInfo1Click
      end
      object ImagePic: TcxImage
        Left = 348
        Top = 36
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 5
        OnDblClick = ImagePicDblClick
        OnEditing = ImagePicEditing
        Height = 125
        Width = 105
      end
      object EditID: TcxButtonEdit
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
        Width = 286
      end
      object EditPart: TcxComboBox
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
        Width = 112
      end
      object EditName: TcxTextEdit
        Left = 57
        Top = 61
        Hint = 'T.T_Name'
        ParentFont = False
        Properties.MaxLength = 32
        TabOrder = 1
        Width = 104
      end
      object EditHistory: TcxComboBox
        Left = 69
        Top = 380
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        Properties.OnChange = EditHistoryPropertiesChange
        TabOrder = 11
        Width = 165
      end
      object EditDate: TcxTextEdit
        Left = 208
        Top = 86
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 3
        Width = 135
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #22522#26412#20449#24687
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
            object dxLayout1Group1: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item12: TdxLayoutItem
                Caption = #37096#20301':'
                Control = EditPart
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item5: TdxLayoutItem
                Caption = #26102#38388':'
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
        object dxGroup2: TdxLayoutGroup
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
        object dxLayoutGroup2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item1: TdxLayoutItem
            Caption = #21382#21490#20998#26512':'
            Control = EditHistory
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
