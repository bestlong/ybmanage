inherited fFormCameraSetup: TfFormCameraSetup
  ClientHeight = 377
  ClientWidth = 363
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 363
    Height = 377
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 363
      Height = 377
      Align = alClient
      TabOrder = 0
      TabStop = False
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnOK: TButton
        Left = 216
        Top = 343
        Width = 65
        Height = 22
        Caption = #30830#23450
        TabOrder = 5
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 286
        Top = 343
        Width = 65
        Height = 22
        Caption = #21462#28040
        TabOrder = 6
        OnClick = BtnExitClick
      end
      object VideoWindow1: TVideoWindow
        Left = 23
        Top = 36
        Width = 316
        Height = 245
        FilterGraph = FilterGraph1
        VMROptions.Mode = vmrWindowed
        Color = clBlack
      end
      object EditSysDev: TcxComboBox
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
      object BtnSetup: TButton
        Left = 279
        Top = 286
        Width = 60
        Height = 20
        Caption = #30011#36136#35843#33410
        TabOrder = 2
        OnClick = BtnSetupClick
      end
      object EditSize: TcxComboBox
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
      object CheckSync1: TcxCheckBox
        Left = 11
        Top = 343
        Caption = #21516#27493#35843#25972#31383#21475#22823#23567
        ParentFont = False
        TabOrder = 4
        Width = 121
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
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
        object dxLayoutGroup2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item1: TdxLayoutItem
            Caption = 'cxCheckBox1'
            ShowCaption = False
            Control = CheckSync1
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
