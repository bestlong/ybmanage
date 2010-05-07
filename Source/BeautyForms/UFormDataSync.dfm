inherited fFormDataSync: TfFormDataSync
  ClientHeight = 231
  ClientWidth = 331
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 331
    Height = 231
    object dxLayoutControl1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 331
      Height = 231
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object RadioUp: TcxRadioButton
        Left = 23
        Top = 58
        Width = 285
        Height = 17
        Caption = #19978#20256#25968#25454':'#23558#26412#26426#25968#25454#19978#20256#21040#26381#21153#22120#25968#25454#24211#20013'.'
        ParentColor = False
        TabOrder = 1
        OnClick = CheckFixedPropertiesChange
        LookAndFeel.Kind = lfOffice11
        Transparent = True
      end
      object RadioDown: TcxRadioButton
        Left = 23
        Top = 36
        Width = 285
        Height = 17
        Caption = #19979#36733#25968#25454':'#23558#26381#21153#22120#25968#25454#19979#36733#21040#26412#26426#25968#25454#24211#20013'.'
        Checked = True
        ParentColor = False
        TabOrder = 0
        TabStop = True
        OnClick = CheckFixedPropertiesChange
        Transparent = True
      end
      object CheckFixed: TcxCheckBox
        Left = 23
        Top = 80
        Caption = #21516#27493#25351#23450#20250#21592':'
        ParentFont = False
        Properties.OnChange = CheckFixedPropertiesChange
        TabOrder = 2
        Transparent = True
        Width = 102
      end
      object EditMember: TcxCheckComboBox
        Left = 130
        Top = 80
        ParentFont = False
        Properties.ShowEmptyText = False
        Properties.DropDownRows = 20
        Properties.EditValueFormat = cvfStatesString
        Properties.Glyph.Data = {
          B2030000424DB203000000000000B20100002800000020000000100000000100
          08000000000000020000120B0000120B00005F0000005F00000000000000FFFF
          FF00FF00FF005325000036180000281608007F3C00005F2C0000351F0B005B4C
          3C00FFE6C700FDF8F200A0927F00FFE9CC008F847600F6E4CC00716B6300FAF4
          EC00A7722200A56F2200B37D2D00B5823700A8783400A7783500B6853D00E9B8
          6F00EBBF7D00FAE5C700F8F6F300EABE7A00F8E5C800E9C38000A58020009E84
          240050C44E0051C24D000E92150030BA39001E962B0029C13D003BD15F00409E
          55000C7A2E0083C0960005802C0009772C000C7F30000D80310011833600158A
          3B00198D3E001A9040001B8D40001E8D410026964A002A964C002F96500093D8
          AA009CD5AF00A4D4B400BAE4C800C2E0CC00D0ECD9009DE9B700ACEAC100B5EA
          C700B2E4C300CEF7DC0068F39D0081F4AD008BF8B40096F8BB00BFFCD60038EB
          7E003BEB800045ED87004AED890053EE8F005DEF960066F19C007CF4AA00BDD6
          CA003344470072D8FE0047C0FF004FC5FF004EA7D2003EBBFE0024ABFE001B9E
          F800B8C9D50015344A003B8DD500FEFEFE00FFFFFF0002020202020202020202
          0202020202020202020202020202020202020202020202141313131313131313
          13131313140202020202020202020202020202020202150B0B0B0B0B0B0B0B0B
          0B0B0B0B111502020202020233300202020202020202130B2624242426265D5D
          1A19191A5D1302020202023343433002020202020202130B2627272727265D5D
          191919190B130202020236434A4A4330020202020202135D26285C5C5C515D5D
          0B5D0B5D5D1302020237434B4D4B4943300202020202130B265C5C58595C1C1C
          1F1F1F1A0B13020238434450393F4C4A433002020202130B295C5554575C5A1E
          1D19191A0B13022C4346473A2D2F404D4A4331020202130B0B5C53565B00101E
          1B1B1B1B0B13022F3E483B2D02022F414E4A43320202130B0F05520803040E1B
          1D19191A0B1302022F2B2D020202022E424F4B433202135D0D0C030607091B1B
          191919190B130202022A0202020202022E3C4543340213111E0D0A0D0A0D1B1B
          1B1B1B1B0B1802020202020202020202022E3D34020213252525252525201612
          1212121217020202020202020202020202023502020213232322222323210202
          0202020202020202020202020202020202020202020202181313131318020202
          0202020202020202020202020202020202020202020202020202020202020202
          02020202020202020202020202020202020202020202}
        Properties.GlyphCount = 2
        Properties.ImmediateDropDown = False
        Properties.Items = <>
        TabOrder = 3
        Width = 178
      end
      object ProcessTotal: TcxProgressBar
        Left = 81
        Top = 138
        ParentFont = False
        Properties.PeakValue = 50.000000000000000000
        Style.BorderColor = 15260851
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 4
        Width = 225
      end
      object ProcessNow: TcxProgressBar
        Left = 81
        Top = 163
        ParentFont = False
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 5
        Width = 225
      end
      object BtnExit: TButton
        Left = 255
        Top = 195
        Width = 65
        Height = 22
        Caption = #36864#20986
        TabOrder = 7
        OnClick = BtnExitClick
      end
      object BtnOK: TButton
        Left = 185
        Top = 195
        Width = 65
        Height = 22
        Caption = #24320#22987
        TabOrder = 6
        OnClick = BtnOKClick
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #22522#26412#35774#32622
          object dxLayoutControl1Item2: TdxLayoutItem
            Caption = 'cxRadioButton2'
            ShowCaption = False
            Control = RadioDown
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxLayoutItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = 'cxRadioButton1'
            ShowCaption = False
            Control = RadioUp
            ControlOptions.AutoColor = True
            ControlOptions.ShowBorder = False
          end
          object dxLayoutGroup2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              Caption = 'cxCheckBox1'
              ShowCaption = False
              Control = CheckFixed
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item4: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Control = EditMember
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxGroup2: TdxLayoutGroup
          Caption = #21516#27493#36827#24230
          object dxLayoutControl1Item5: TdxLayoutItem
            Caption = #25972#20307#36827#24230':'
            Control = ProcessTotal
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item6: TdxLayoutItem
            Caption = #24403#21069#36827#24230':'
            Control = ProcessNow
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayoutControl1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayoutControl1Item8: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnOK
            ControlOptions.ShowBorder = False
          end
          object dxLayoutControl1Item7: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnExit
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
  object LocalQuery: TADOQuery
    Connection = ConnLocal
    Parameters = <>
    Left = 38
    Top = 194
  end
  object ConnLocal: TADOConnection
    LoginPrompt = False
    Left = 10
    Top = 194
  end
  object LocalCommand: TADOQuery
    Connection = ConnLocal
    Parameters = <>
    Left = 66
    Top = 194
  end
end
