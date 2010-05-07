inherited fFormCameraSetup: TfFormCameraSetup
  Left = 238
  Top = 177
  ClientHeight = 378
  ClientWidth = 362
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 362
    Height = 378
    inherited BtnOK: TButton
      Left = 216
      Top = 343
      Caption = #30830#23450
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 286
      Top = 343
      TabOrder = 5
    end
    object VideoWindow1: TVideoWindow [2]
      Left = 23
      Top = 36
      Width = 316
      Height = 245
      FilterGraph = FilterGraph1
      VMROptions.Mode = vmrWindowed
      Color = clBlack
    end
    object EditSysDev: TcxComboBox [3]
      Left = 81
      Top = 286
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.OnChange = EditSysDevPropertiesChange
      TabOrder = 1
      Width = 121
    end
    object BtnSetup: TButton [4]
      Left = 279
      Top = 286
      Width = 60
      Height = 20
      Caption = #30011#36136#35843#33410
      TabOrder = 2
      OnClick = BtnSetupClick
    end
    object EditSize: TcxComboBox [5]
      Left = 81
      Top = 311
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      Properties.OnChange = EditSizePropertiesChange
      TabOrder = 3
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #39044#35272
        object dxLayout1Item3: TdxLayoutItem
          Caption = #39044#35272#31383
          ShowCaption = False
          Control = VideoWindow1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #35270#39057#35774#22791':'
            Control = EditSysDev
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnSetup
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #30011#38754#27604#20363':'
          Control = EditSize
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
  object VideoFilter1: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph1
    Left = 87
    Top = 6
  end
  object FilterGraph1: TFilterGraph
    Mode = gmCapture
    GraphEdit = True
    LinearVolume = True
    Left = 116
    Top = 6
  end
end
