inherited fFrameProvider: TfFrameProvider
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
    inherited BtnExit: TToolButton
      OnClick = BtnExitClick
    end
  end
  inherited cxGrid1: TcxGrid
    Top = 196
    Width = 691
    Height = 262
    inherited cxView1: TcxGridDBTableView
      OnDblClick = cxView1DblClick
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Width = 691
    Height = 135
    object cxTextEdit2: TcxTextEdit [0]
      Left = 206
      Top = 93
      Hint = 'T.P_Name'
      ParentFont = False
      TabOrder = 3
      Width = 100
    end
    object cxTextEdit3: TcxTextEdit [1]
      Left = 345
      Top = 93
      Hint = 'T.P_Phone'
      ParentFont = False
      TabOrder = 4
      Width = 120
    end
    object cxTextEdit4: TcxTextEdit [2]
      Left = 504
      Top = 93
      Hint = 'T.P_Addr'
      ParentFont = False
      TabOrder = 5
      Width = 166
    end
    object EditName: TcxButtonEdit [3]
      Left = 206
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      OnKeyPress = OnCtrlKeyPress
      Width = 100
    end
    object cxTextEdit1: TcxTextEdit [4]
      Left = 57
      Top = 93
      Hint = 'T.P_ID'
      ParentFont = False
      TabOrder = 2
      Width = 110
    end
    object EditID: TcxButtonEdit [5]
      Left = 57
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditNamePropertiesButtonClick
      TabOrder = 0
      OnKeyDown = OnCtrlKeyDown
      OnKeyPress = OnCtrlKeyPress
      Width = 110
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item5: TdxLayoutItem
          Caption = #32534#21495':'
          Control = EditID
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #21517#31216':'
          Control = EditName
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #32534#21495':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #21517#31216':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          Caption = #30005#35805':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #22320#22336':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitleBar: TcxLabel
    Caption = #20135#21697#20379#24212#21830#31649#29702
    Width = 691
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 234
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 234
  end
end
