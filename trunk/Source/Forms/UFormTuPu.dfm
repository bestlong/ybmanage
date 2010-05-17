inherited fFormTuPu: TfFormTuPu
  Left = 498
  Top = 244
  ClientHeight = 376
  ClientWidth = 400
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 400
    Height = 376
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 254
      Top = 343
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 324
      Top = 343
      TabOrder = 6
    end
    object EditLevelA: TcxTextEdit [2]
      Left = 87
      Top = 36
      Hint = 'T.T_LevelA'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 0
      Width = 110
    end
    object EditLevelB: TcxTextEdit [3]
      Left = 87
      Top = 61
      Hint = 'T.T_LevelB'
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 1
      Width = 110
    end
    object EditMemo: TcxMemo [4]
      Left = 81
      Top = 86
      Hint = 'T.T_Memo'
      ParentFont = False
      Properties.MaxLength = 50
      Properties.ScrollBars = ssVertical
      TabOrder = 2
      Height = 50
      Width = 434
    end
    object ListFile: TcxCheckListBox [5]
      Left = 23
      Top = 198
      Width = 354
      Height = 19
      Items = <>
      ParentFont = False
      PopupMenu = PMenu1
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
    end
    object EditFile: TcxButtonEdit [6]
      Left = 81
      Top = 173
      Properties.Buttons = <
        item
          Caption = #28155#21152
          Default = True
          Kind = bkText
        end>
      Properties.ReadOnly = True
      Properties.OnButtonClick = EditFilePropertiesButtonClick
      TabOrder = 3
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26816#32034#20869#23481'A:'
            Control = EditLevelA
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #26816#32034#20869#23481'B:'
            Control = EditLevelB
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item15: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #22270#35889#21015#34920
        object dxLayout1Item3: TdxLayoutItem
          Caption = #22270#35889#25991#20214':'
          Control = EditFile
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaHorizontal]
          AlignVert = avClient
          Caption = 'cxCheckListBox1'
          ShowCaption = False
          Control = ListFile
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 32
    Top = 204
    object N1: TMenuItem
      Tag = 10
      Caption = #20840#37096#36873#20013
      OnClick = N2Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #20840#37096#21462#28040
      OnClick = N2Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N4: TMenuItem
      Tag = 10
      Caption = #21024#38500#36873#20013
      OnClick = N5Click
    end
    object N5: TMenuItem
      Tag = 20
      Caption = #21024#38500#24403#21069
      OnClick = N5Click
    end
  end
end
