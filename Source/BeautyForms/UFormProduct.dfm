inherited fFormProduct: TfFormProduct
  Left = 280
  Top = 132
  AlphaBlend = True
  ClientHeight = 456
  ClientWidth = 472
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 472
    Height = 456
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 472
      Height = 456
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object cxTextEdit1: TcxTextEdit
        Left = 87
        Top = 36
        Hint = 'T.P_ID'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 250
      end
      object cxTextEdit2: TcxTextEdit
        Left = 87
        Top = 61
        Hint = 'T.P_Name'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 250
      end
      object EditPlant: TcxButtonEdit
        Left = 87
        Top = 111
        Hint = 'T.P_Plant'
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Properties.OnButtonClick = EditPlantPropertiesButtonClick
        TabOrder = 3
        Width = 250
      end
      object EditProvider: TcxButtonEdit
        Left = 87
        Top = 136
        Hint = 'T.P_Provider'
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Properties.OnButtonClick = EditProviderPropertiesButtonClick
        TabOrder = 4
        Width = 140
      end
      object cxTextEdit3: TcxTextEdit
        Left = 290
        Top = 136
        Hint = 'T.P_Price'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 5
        Width = 39
      end
      object ImagePic: TcxImage
        Left = 342
        Top = 36
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 6
        OnDblClick = ImagePicDblClick
        Height = 120
        Width = 103
      end
      object cxMemo1: TcxMemo
        Left = 87
        Top = 161
        Hint = 'T.P_Memo'
        ParentFont = False
        TabOrder = 7
        Height = 35
        Width = 358
      end
      object ListInfo1: TcxMCListBox
        Left = 23
        Top = 313
        Width = 364
        Height = 97
        HeaderSections = <
          item
            Text = #20449#24687#39033
            Width = 74
          end
          item
            AutoSize = True
            Text = #20449#24687#20869#23481
            Width = 286
          end>
        ParentFont = False
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 10
        OnClick = ListInfo1Click
      end
      object InfoItems: TcxTextEdit
        Left = 87
        Top = 233
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 8
        Width = 94
      end
      object BtnExit: TButton
        Left = 392
        Top = 422
        Width = 65
        Height = 22
        Caption = #20851#38381
        TabOrder = 11
        OnClick = BtnExitClick
      end
      object EditType: TcxTextEdit
        Left = 87
        Top = 86
        Hint = 'T.P_Type'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 250
      end
      object EditInfo: TcxMemo
        Left = 87
        Top = 258
        ParentFont = False
        Properties.ReadOnly = True
        Properties.ScrollBars = ssVertical
        TabOrder = 9
        Height = 50
        Width = 358
      end
      object dxLayout1Group_Root: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxLayout1Group6: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayout1Group1: TdxLayoutGroup
            Caption = #20135#21697#20449#24687
            object dxLayout1Group4: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              LayoutDirection = ldHorizontal
              ShowBorder = False
              object dxLayout1Group5: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                ShowBorder = False
                object dxLayout1Item1: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  Caption = #20135#21697#32534#21495':'
                  Control = cxTextEdit1
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item2: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  Caption = #20135#21697#21517#31216':'
                  Control = cxTextEdit2
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item12: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  Caption = #25152#23646#31867#21035':'
                  Control = EditType
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item3: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  Caption = #29983#20135#21378#21830':'
                  Control = EditPlant
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Group3: TdxLayoutGroup
                  ShowCaption = False
                  Hidden = True
                  LayoutDirection = ldHorizontal
                  ShowBorder = False
                  object dxLayout1Item4: TdxLayoutItem
                    Caption = #20379' '#24212' '#21830':'
                    Control = EditProvider
                    ControlOptions.ShowBorder = False
                  end
                  object dxLayout1Item5: TdxLayoutItem
                    AutoAligns = [aaVertical]
                    AlignHorz = ahClient
                    Caption = #21806#20215'('#20803'):'
                    Control = cxTextEdit3
                    ControlOptions.ShowBorder = False
                  end
                end
              end
              object dxLayout1Item6: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahRight
                Caption = #22270#29255
                ShowCaption = False
                Control = ImagePic
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item7: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #22791#20449#24687#27880':'
              Control = cxMemo1
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Group2: TdxLayoutGroup
            Caption = #25193#23637#20449#24687
            object dxLayout1Item9: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20449' '#24687'  '#39033':'
              Control = InfoItems
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item13: TdxLayoutItem
              Caption = #20449#24687#20869#23481':'
              Control = EditInfo
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              Caption = #21015#34920':'
              ShowCaption = False
              Control = ListInfo1
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayout1Item11: TdxLayoutItem
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
