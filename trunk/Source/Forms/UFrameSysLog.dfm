inherited fFrameSysLog: TfFrameSysLog
  Width = 789
  Height = 471
  object ToolBar1: TToolBar
    Left = 0
    Top = 22
    Width = 789
    Height = 39
    AutoSize = True
    ButtonHeight = 35
    ButtonWidth = 67
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Flat = True
    Images = FDM.ImageBar
    ShowCaptions = True
    TabOrder = 0
    object BtnFilter: TToolButton
      Left = 0
      Top = 0
      Caption = '   '#31579#36873'   '
      ImageIndex = 19
      OnClick = BtnFilterClick
    end
    object BtnRefresh: TToolButton
      Left = 67
      Top = 0
      Caption = #21047#26032
      ImageIndex = 14
      OnClick = BtnRefreshClick
    end
    object S2: TToolButton
      Left = 134
      Top = 0
      Width = 8
      Caption = 'S2'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object BtnPrint: TToolButton
      Left = 142
      Top = 0
      Caption = #25171#21360
      ImageIndex = 3
      OnClick = BtnPrintClick
    end
    object BtnPreview: TToolButton
      Left = 209
      Top = 0
      Caption = #25171#21360#39044#35272
      ImageIndex = 4
      OnClick = BtnPreviewClick
    end
    object BtnExport: TToolButton
      Left = 276
      Top = 0
      Caption = #23548#20986
      ImageIndex = 5
      OnClick = BtnExportClick
    end
    object S3: TToolButton
      Left = 343
      Top = 0
      Width = 8
      Caption = 'S3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object BtnExit: TToolButton
      Left = 351
      Top = 0
      Caption = #20851#38381
      ImageIndex = 7
      OnClick = BtnExitClick
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 197
    Width = 789
    Height = 274
    Align = alClient
    TabOrder = 1
    object cxView1: TcxGridDBTableView
      NavigatorButtons.ConfirmDelete = False
      OnFocusedRecordChanged = cxView1FocusedRecordChanged
      DataController.DataSource = DataSource1
      DataController.Summary.DefaultGroupSummaryItems = <>
      DataController.Summary.FooterSummaryItems = <>
      DataController.Summary.SummaryGroups = <>
    end
    object cxLevel1: TcxGridLevel
      GridView = cxView1
    end
  end
  object TitlePanel: TPanel
    Left = 0
    Top = 0
    Width = 789
    Height = 22
    Align = alTop
    BevelOuter = bvNone
    Caption = #31995#32479#25805#20316#26085#24535
    ParentColor = True
    TabOrder = 2
  end
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 61
    Width = 789
    Height = 136
    Align = alTop
    BevelEdges = [beLeft, beRight, beBottom]
    BevelKind = bkTile
    TabOrder = 3
    TabStop = False
    AutoContentSizes = [acsWidth]
    LookAndFeel = FDM.dxLayoutWeb1
    object EditMan: TcxButtonEdit
      Left = 69
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 0
      OnKeyPress = EditManKeyPress
      Width = 110
    end
    object EditItem: TcxButtonEdit
      Left = 242
      Top = 36
      ParentFont = False
      Properties.Buttons = <
        item
          Default = True
          Kind = bkEllipsis
        end>
      Properties.OnButtonClick = EditIDPropertiesButtonClick
      TabOrder = 1
      OnKeyPress = EditManKeyPress
      Width = 110
    end
    object EditValue: TcxTextEdit
      Left = 588
      Top = 93
      Hint = 'T.L_Event'
      ParentFont = False
      TabOrder = 5
      Width = 110
    end
    object cxTextEdit2: TcxTextEdit
      Left = 69
      Top = 93
      Hint = 'T.L_Man'
      ParentFont = False
      TabOrder = 2
      Width = 110
    end
    object cxTextEdit3: TcxTextEdit
      Left = 242
      Top = 93
      Hint = 'T.L_Date'
      ParentFont = False
      TabOrder = 3
      Width = 110
    end
    object cxTextEdit4: TcxTextEdit
      Left = 415
      Top = 93
      Hint = 'T.L_ItemID'
      ParentFont = False
      TabOrder = 4
      Width = 110
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #24555#36895#26597#35810
        LayoutDirection = ldHorizontal
        object dxLayoutControl1Item2: TdxLayoutItem
          Caption = #25805#20316#20154':'
          Control = EditMan
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item1: TdxLayoutItem
          Caption = #20107#20214#23545#35937':'
          Control = EditItem
          ControlOptions.ShowBorder = False
        end
      end
      object dxLayoutControl1Group2: TdxLayoutGroup
        Caption = #31616#26126#20449#24687
        LayoutDirection = ldHorizontal
        object dxLayoutControl1Item4: TdxLayoutItem
          Caption = #25805#20316#20154':'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item5: TdxLayoutItem
          Caption = #25805#20316#26102#38388':'
          Control = cxTextEdit3
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item6: TdxLayoutItem
          Caption = #20107#20214#23545#35937':'
          Control = cxTextEdit4
          ControlOptions.ShowBorder = False
        end
        object dxLayoutControl1Item3: TdxLayoutItem
          AutoAligns = []
          AlignHorz = ahClient
          AlignVert = avClient
          Caption = #20107#20214#20869#23481':'
          Control = EditValue
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object SQLQuery: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 8
    Top = 242
  end
  object DataSource1: TDataSource
    DataSet = SQLQuery
    Left = 36
    Top = 242
  end
end
