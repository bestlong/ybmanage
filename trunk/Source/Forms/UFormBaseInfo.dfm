inherited fFormBaseInfo: TfFormBaseInfo
  Left = 220
  Top = 134
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 354
  ClientWidth = 537
  OldCreateOrder = True
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 537
    Height = 354
    Align = alClient
    TabOrder = 0
    TabStop = False
    LookAndFeel = FDM.dxLayoutWeb1
    object InfoTv1: TcxTreeView
      Left = 23
      Top = 36
      Width = 154
      Height = 268
      Align = alClient
      DragMode = dmAutomatic
      ParentFont = False
      PopupMenu = PMenu1
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnClick = InfoTv1Click
      OnDblClick = InfoTv1DblClick
      OnDragDrop = InfoTv1DragDrop
      OnDragOver = InfoTv1DragOver
      HideSelection = False
      Images = FDM.ImageBar
      ReadOnly = True
      OnChange = InfoTv1Change
      OnDeletion = InfoTv1Deletion
    end
    object InfoList1: TcxMCListBox
      Left = 206
      Top = 36
      Width = 307
      Height = 120
      HeaderSections = <
        item
          DataIndex = 1
          Text = #33410#28857
          Width = 74
        end
        item
          AutoSize = True
          DataIndex = 2
          Text = #22791#27880
          Width = 229
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 2
      OnClick = InfoList1Click
      OnDblClick = InfoTv1DblClick
    end
    object EditText: TcxTextEdit
      Left = 264
      Top = 193
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 3
      OnExit = EditTextExit
      Width = 121
    end
    object EditPY: TcxTextEdit
      Left = 264
      Top = 218
      TabStop = False
      ParentFont = False
      Properties.MaxLength = 25
      TabOrder = 4
      Width = 121
    end
    object EditMemo: TcxMemo
      Left = 264
      Top = 243
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 5
      Height = 63
      Width = 225
    end
    object BtnAdd: TButton
      Left = 317
      Top = 311
      Width = 62
      Height = 22
      Caption = #28155#21152
      TabOrder = 6
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 384
      Top = 311
      Width = 62
      Height = 22
      Caption = #21024#38500
      TabOrder = 7
      OnClick = BtnDelClick
    end
    object BtnSave: TButton
      Left = 451
      Top = 311
      Width = 62
      Height = 22
      Caption = #20445#23384
      TabOrder = 8
      OnClick = BtnSaveClick
    end
    object EditSearch: TcxButtonEdit
      Left = 57
      Top = 309
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditSearchPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = EditSearchKeyPress
      Width = 120
    end
    object dxLayout1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      LayoutDirection = ldHorizontal
      ShowBorder = False
      object dxLayout1Group1: TdxLayoutGroup
        Caption = #26641#24418#26174#31034
        object dxLayout1Item1: TdxLayoutItem
          Caption = #26641#29366#21015#34920
          ShowCaption = False
          Control = InfoTv1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26597#25214':'
          Control = EditSearch
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayout1Group4: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxLayout1Group2: TdxLayoutGroup
          Caption = #21015#34920#26174#31034
          object dxLayout1Item2: TdxLayoutItem
            Caption = 'cxMCListBox1'
            ShowCaption = False
            Control = InfoList1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group3: TdxLayoutGroup
          Caption = #32534#36753#21306
          object dxItemName: TdxLayoutItem
            Caption = #33410#28857#20869#23481':'
            Control = EditText
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = #25340#38899#31616#20889':'
            Control = EditPY
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button3'
              ShowCaption = False
              Control = BtnSave
              ControlOptions.ShowBorder = False
            end
          end
        end
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 30
    Top = 48
    object N1: TMenuItem
      Tag = 10
      Caption = #20840#37096#23637#24320
      OnClick = N2Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #20840#37096#25910#36215
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Tag = 30
      Caption = #20462#25913#20301#32622
      OnClick = N2Click
    end
  end
end
