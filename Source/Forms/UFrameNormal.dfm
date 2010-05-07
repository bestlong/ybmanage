inherited fFrameNormal: TfFrameNormal
  Width = 602
  Height = 367
  ParentBackground = False
  object ToolBar1: TToolBar
    Left = 0
    Top = 22
    Width = 602
    Height = 39
    AutoSize = True
    ButtonHeight = 35
    ButtonWidth = 67
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Flat = True
    Images = FDM.ImageBar
    ShowCaptions = True
    TabOrder = 0
    object BtnAdd: TToolButton
      Left = 0
      Top = 0
      Caption = '   '#28155#21152'   '
      ImageIndex = 0
    end
    object BtnEdit: TToolButton
      Left = 67
      Top = 0
      Caption = #20462#25913
      ImageIndex = 1
    end
    object BtnDel: TToolButton
      Left = 134
      Top = 0
      Caption = #21024#38500
      ImageIndex = 2
    end
    object S1: TToolButton
      Left = 201
      Top = 0
      Width = 8
      Caption = 'S1'
      ImageIndex = 2
      Style = tbsSeparator
    end
    object BtnRefresh: TToolButton
      Left = 209
      Top = 0
      Caption = #21047#26032
      ImageIndex = 14
      OnClick = BtnRefreshClick
    end
    object S2: TToolButton
      Left = 276
      Top = 0
      Width = 8
      Caption = 'S2'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object BtnPrint: TToolButton
      Left = 284
      Top = 0
      Caption = #25171#21360
      ImageIndex = 3
      OnClick = BtnPrintClick
    end
    object BtnPreview: TToolButton
      Left = 351
      Top = 0
      Caption = #25171#21360#39044#35272
      ImageIndex = 4
      OnClick = BtnPreviewClick
    end
    object BtnExport: TToolButton
      Left = 418
      Top = 0
      Caption = #23548#20986
      ImageIndex = 5
      OnClick = BtnExportClick
    end
    object S3: TToolButton
      Left = 485
      Top = 0
      Width = 8
      Caption = 'S3'
      ImageIndex = 3
      Style = tbsSeparator
    end
    object BtnExit: TToolButton
      Left = 493
      Top = 0
      Caption = #20851#38381
      ImageIndex = 7
    end
  end
  object cxGrid1: TcxGrid
    Left = 0
    Top = 161
    Width = 602
    Height = 206
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
  object dxLayout1: TdxLayoutControl
    Left = 0
    Top = 61
    Width = 602
    Height = 100
    Align = alTop
    BevelEdges = [beLeft, beRight, beBottom]
    BevelKind = bkTile
    TabOrder = 2
    AutoContentSizes = [acsWidth]
    LookAndFeel = FDM.dxLayoutWeb1
    object dxGroup1: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object GroupSearch1: TdxLayoutGroup
        Caption = #24555#36895#26597#35810
        LayoutDirection = ldHorizontal
      end
      object GroupDetail1: TdxLayoutGroup
        Caption = #31616#26126#20449#24687
        LayoutDirection = ldHorizontal
      end
    end
  end
  object TitleBar: TcxLabel
    Left = 0
    Top = 0
    Align = alTop
    AutoSize = False
    Caption = 'title'
    ParentFont = False
    Properties.Alignment.Horz = taCenter
    Properties.Alignment.Vert = taVCenter
    Properties.LabelStyle = cxlsLowered
    Style.TextColor = clBlack
    Height = 22
    Width = 602
  end
  object SQLQuery: TADOQuery
    Connection = FDM.ADOConn
    Parameters = <>
    Left = 6
    Top = 202
  end
  object DataSource1: TDataSource
    DataSet = SQLQuery
    Left = 34
    Top = 202
  end
end
