inherited fFrameTuPu: TfFrameTuPu
  Width = 691
  Height = 458
  inherited ToolBar1: TToolBar
    Width = 691
    inherited BtnAdd: TToolButton
      OnClick = BtnAddClick
    end
    inherited BtnEdit: TToolButton
      OnClick = BtnEditClick
    end
    inherited BtnDel: TToolButton
      OnClick = BtnDelClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 202
    Width = 691
    Height = 256
    inherited cxView1: TcxGridDBTableView
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 691
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 99
      Top = 93
      Hint = 'T.T_LevelA'
      ParentFont = False
      TabOrder = 1
      Width = 110
    end
    object cxTextEdit2: TcxTextEdit [1]
      Left = 290
      Top = 93
      Hint = 'T.T_LevelB'
      ParentFont = False
      TabOrder = 2
      Width = 110
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 463
      Top = 93
      Hint = 'T.T_Memo'
      ParentFont = False
      TabOrder = 3
      Width = 100
    end
    object EditLevel: TcxButtonEdit [3]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = OnCtrlKeyPress
      Width = 156
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #26816#32034#20869#23481':'
          Control = EditLevel
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #26816#32034#20869#23481'(A):'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #26816#32034#20869#23481'(B):'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22791#27880#20449#24687':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited cxSplitter1: TcxSplitter
    Top = 194
    Width = 691
  end
  inherited TitlePanel1: TZnBitmapPanel
    Width = 691
    inherited TitleBar: TcxLabel
      Caption = #30382#32932#22270#35889#31649#29702
      Style.IsFontAssigned = True
      Width = 691
      AnchorX = 346
      AnchorY = 11
    end
  end
  inherited SQLQuery: TADOQuery
    Left = 2
    Top = 242
  end
  inherited DataSource1: TDataSource
    Left = 30
    Top = 242
  end
end
