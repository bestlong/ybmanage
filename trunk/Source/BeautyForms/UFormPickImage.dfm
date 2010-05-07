inherited fFormPickImage: TfFormPickImage
  Left = 185
  Top = 179
  ClientHeight = 361
  ClientWidth = 811
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 811
    Height = 361
    object RTPanel: TZnTransPanel
      Left = 0
      Top = 0
      Width = 811
      Height = 42
      Align = alTop
      object Label2: TLabel
        Left = 8
        Top = 17
        Width = 54
        Height = 12
        Caption = #37319#38598#26085#26399':'
        Transparent = True
      end
      object Label3: TLabel
        Left = 218
        Top = 17
        Width = 54
        Height = 12
        Caption = #37319#38598#37096#20301':'
        Transparent = True
      end
      object Label4: TLabel
        Left = 418
        Top = 17
        Width = 54
        Height = 12
        Caption = #22270#20687#22823#23567':'
        Transparent = True
      end
      object Label6: TLabel
        Left = 565
        Top = 17
        Width = 54
        Height = 12
        Caption = #22270#29255#25551#36848':'
        Transparent = True
      end
      object EditDate: TcxTextEdit
        Left = 65
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 145
      end
      object EditSize: TcxTextEdit
        Left = 475
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 78
      end
      object EditDesc: TcxTextEdit
        Left = 620
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 171
      end
      object EditPart: TcxComboBox
        Left = 275
        Top = 12
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.ImmediateDropDown = False
        Properties.IncrementalSearch = False
        Properties.OnChange = EditPartPropertiesChange
        TabOrder = 3
        Width = 135
      end
    end
    object BPanel1: TZnTransPanel
      Left = 0
      Top = 319
      Width = 811
      Height = 42
      Align = alBottom
      DesignSize = (
        811
        42)
      object Label1: TLabel
        Left = 8
        Top = 16
        Width = 54
        Height = 12
        Caption = #35774#22791#21517#31216':'
        Transparent = True
      end
      object Label5: TLabel
        Left = 218
        Top = 16
        Width = 54
        Height = 12
        Caption = #30011#38754#27604#20363':'
        Transparent = True
      end
      object BtnExit: TButton
        Left = 737
        Top = 10
        Width = 60
        Height = 22
        Anchors = [akRight, akBottom]
        Caption = #36864#20986
        TabOrder = 0
        OnClick = BtnExitClick
      end
      object EditDev: TcxTextEdit
        Left = 65
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 145
      end
      object EditBiLi: TcxTextEdit
        Left = 275
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 135
      end
      object RadioPick: TcxRadioButton
        Left = 418
        Top = 15
        Width = 80
        Height = 17
        Caption = #37319#38598#27169#24335
        Checked = True
        TabOrder = 3
        TabStop = True
        OnClick = RadioPickClick
        Transparent = True
      end
      object RadioView: TcxRadioButton
        Left = 504
        Top = 15
        Width = 80
        Height = 17
        Caption = #27983#35272#27169#24335
        TabOrder = 4
        OnClick = RadioPickClick
        Transparent = True
      end
      object BtnPick: TButton
        Left = 590
        Top = 10
        Width = 60
        Height = 22
        Caption = #37319#38598
        TabOrder = 5
        OnClick = BtnPickClick
      end
      object BtnSave: TButton
        Left = 675
        Top = 10
        Width = 60
        Height = 22
        Anchors = [akRight, akBottom]
        Caption = #20445#23384
        TabOrder = 6
        OnClick = BtnSaveClick
      end
    end
    object wPanel: TZnTransPanel
      Left = 165
      Top = 42
      Width = 646
      Height = 277
      Align = alClient
      object ViewItem1: TImageViewItem
        Left = 8
        Top = 46
        Width = 200
        Height = 100
        PopupMenu = PMenu1
        CanSelected = False
      end
      object VideoWindow1: TVideoWindow
        Left = 8
        Top = 6
        Width = 35
        Height = 35
        FilterGraph = FilterGraph1
        VMROptions.Mode = vmrWindowed
        Color = clBlack
        Visible = False
      end
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 42
      Width = 165
      Height = 277
      VertScrollBar.Tracking = True
      Align = alLeft
      BevelEdges = []
      BevelKind = bkTile
      BorderStyle = bsNone
      TabOrder = 3
    end
  end
  object FilterGraph1: TFilterGraph
    Mode = gmCapture
    GraphEdit = False
    LinearVolume = True
    Left = 7
    Top = 50
  end
  object VideoFilter1: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph1
    Left = 35
    Top = 50
  end
  object SampleGrabber1: TSampleGrabber
    OnBuffer = SampleGrabber1Buffer
    FilterGraph = FilterGraph1
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 63
    Top = 50
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 6
    Top = 80
    object N1: TMenuItem
      Tag = 10
      Caption = #36866#21512#22270#20687
      Enabled = False
      OnClick = N1Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #23454#38469#22823#23567
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N501: TMenuItem
      Tag = 30
      Caption = #32553#25918' 50%'
      OnClick = N1Click
    end
    object N751: TMenuItem
      Tag = 40
      Caption = #32553#25918' 75%'
      OnClick = N1Click
    end
    object N1201: TMenuItem
      Tag = 50
      Caption = #32553#25918' 120%'
      OnClick = N1Click
    end
    object N1501: TMenuItem
      Tag = 60
      Caption = #32553#25918' 150%'
      OnClick = N1Click
    end
    object N2001: TMenuItem
      Tag = 70
      Caption = #32553#25918' 200%'
      OnClick = N1Click
    end
  end
  object PMenu2: TPopupMenu
    AutoHotkeys = maManual
    Left = 34
    Top = 80
    object N4: TMenuItem
      Caption = #28155#21152#25551#36848
      OnClick = N4Click
    end
    object N5: TMenuItem
      Caption = '-'
    end
    object N6: TMenuItem
      Caption = #21024#38500#22270#20687
      OnClick = N6Click
    end
  end
end
