inherited fFormPickImage: TfFormPickImage
  Left = 199
  Top = 144
  ClientHeight = 393
  ClientWidth = 607
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 607
    Height = 393
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 607
      Height = 393
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object VideoWindow1: TVideoWindow
        Left = 23
        Top = 36
        Width = 265
        Height = 210
        FilterGraph = FilterGraph1
        VMROptions.Mode = vmrWindowed
        Color = clBlack
      end
      object EditPart: TcxComboBox
        Left = 81
        Top = 251
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        TabOrder = 1
        Width = 100
      end
      object BtnPick: TButton
        Left = 226
        Top = 251
        Width = 62
        Height = 20
        Caption = #37319#38598' -->'
        TabOrder = 2
        OnClick = BtnPickClick
      end
      object BtnOK: TButton
        Left = 459
        Top = 355
        Width = 65
        Height = 22
        Caption = #20445#23384
        TabOrder = 6
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 529
        Top = 355
        Width = 65
        Height = 22
        Caption = #21462#28040
        TabOrder = 7
        OnClick = BtnExitClick
      end
      object ViewItem1: TImageViewItem
        Left = 317
        Top = 36
        Width = 265
        Height = 210
        PopupMenu = PMenu1
        CanSelected = True
      end
      object ScrollBox1: TScrollBox
        Left = 12
        Top = 284
        Width = 581
        Height = 65
        HorzScrollBar.Tracking = True
        BorderStyle = bsNone
        Color = clWindow
        ParentColor = False
        TabOrder = 5
      end
      object EditDesc: TcxTextEdit
        Left = 375
        Top = 251
        ParentFont = False
        TabOrder = 4
        Width = 121
      end
      object dxLayout1Group_Root: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxLayout1Group1: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxGroup1: TdxLayoutGroup
            Caption = #37319#38598#21306
            object dxLayout1Item1: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #25668#20687#22836
              ShowCaption = False
              Control = VideoWindow1
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Group3: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Item3: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #37319#38598#37096#20301':'
                Control = EditPart
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item4: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahRight
                Caption = 'Button1'
                ShowCaption = False
                Control = BtnPick
                ControlOptions.ShowBorder = False
              end
            end
          end
          object dxGroup2: TdxLayoutGroup
            Caption = #24050#37319#38598#22270#20687
            object dxLayout1Item2: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #26597#30475#39033':'
              ShowCaption = False
              Control = ViewItem1
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              Caption = #25551#36848#20449#24687':'
              Control = EditDesc
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Group5: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Item7: TdxLayoutItem
            Caption = #37319#38598#21015#34920
            ShowCaption = False
            Control = ScrollBox1
            ControlOptions.AutoColor = True
          end
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahRight
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnOK
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
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
  end
  object FilterGraph1: TFilterGraph
    Mode = gmCapture
    GraphEdit = False
    LinearVolume = True
    Left = 91
    Top = 2
  end
  object SampleGrabber1: TSampleGrabber
    FilterGraph = FilterGraph1
    MediaType.data = {
      7669647300001000800000AA00389B717DEB36E44F52CE119F530020AF0BA770
      FFFFFFFF0000000001000000809F580556C3CE11BF0100AA0055595A00000000
      0000000000000000}
    Left = 147
    Top = 2
  end
  object VideoFilter1: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph1
    Left = 119
    Top = 2
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 18
    Top = 290
    object N1: TMenuItem
      Tag = 10
      Caption = #36866#21512#22270#20687
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
    Left = 46
    Top = 290
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
