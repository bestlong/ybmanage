inherited fFrameRemind: TfFrameRemind
  inherited ToolBar1: TToolBar
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
    Height = 171
    inherited cxView1: TcxGridDBTableView
      OnDblClick = cxView1DblClick
    end
    object cxView2: TcxGridDBTableView [1]
      OnDblClick = cxView2DblClick
      NavigatorButtons.ConfirmDelete = False
      DataController.DataSource = DataSource2
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxLevel2: TcxGridLevel
      GridView = cxView2
    end
  end
  inherited dxLayout1: TdxLayoutControl
    Height = 135
    object cxTextEdit1: TcxTextEdit [0]
      Left = 57
      Top = 97
      Hint = 'T.R_Title'
      ParentFont = False
      TabOrder = 2
      Width = 125
    end
    object cxTextEdit2: TcxTextEdit [1]
      Left = 245
      Top = 97
      Hint = 'T.R_Type'
      ParentFont = False
      TabOrder = 3
      Width = 125
    end
    object cxTextEdit3: TcxTextEdit [2]
      Left = 409
      Top = 97
      Hint = 'T.R_Memo'
      ParentFont = False
      TabOrder = 4
      Width = 121
    end
    object EditTitle: TcxButtonEdit [3]
      Left = 57
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditTitlePropertiesButtonClick
      TabOrder = 0
      OnKeyDown = OnCtrlKeyDown
      OnKeyPress = OnCtrlKeyPress
      Width = 125
    end
    object EditType: TcxComboBox [4]
      Left = 245
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.Items.Strings = (
        'A.'#25552#37266#26381#21153#39033
        'B.'#20170#22825#29983#26085#20250#21592
        'C.'#26412#26376#29983#26085#20250#21592)
      Properties.OnChange = EditTypePropertiesChange
      TabOrder = 1
      Text = 'A.'#25552#37266#26381#21153#39033
      OnKeyDown = OnCtrlKeyDown
      Width = 125
    end
    inherited dxGroup1: TdxLayoutGroup
      inherited GroupSearch1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #26631#39064':'
          Control = EditTitle
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #26597#35810#20998#31867':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
      end
      inherited GroupDetail1: TdxLayoutGroup
        object dxLayout1Item1: TdxLayoutItem
          Caption = #26631#39064':'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item2: TdxLayoutItem
          Caption = #25552#37266#31867#22411':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item3: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahClient
          Caption = #20869#23481':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  inherited TitleBar: TcxLabel
    Caption = #25552#37266#26381#21153#31649#29702
  end
  inherited SQLQuery: TADOQuery
    Left = 4
    Top = 234
  end
  inherited DataSource1: TDataSource
    Left = 32
    Top = 234
  end
  object SQLQuery2: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 4
    Top = 262
  end
  object DataSource2: TDataSource
    DataSet = SQLQuery2
    Left = 32
    Top = 262
  end
end
