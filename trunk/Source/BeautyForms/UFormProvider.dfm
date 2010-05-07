inherited fFormProvider: TfFormProvider
  Left = 367
  Top = 204
  ClientHeight = 382
  ClientWidth = 438
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 438
    Height = 382
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 438
      Height = 382
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnExit: TButton
        Left = 361
        Top = 345
        Width = 65
        Height = 22
        Caption = #20851#38381
        TabOrder = 9
        OnClick = BtnExitClick
      end
      object EditMemo: TcxMemo
        Left = 69
        Top = 136
        Hint = 'T.P_Memo'
        ParentFont = False
        Properties.ReadOnly = True
        Style.Edges = [bBottom]
        TabOrder = 5
        Height = 50
        Width = 308
      end
      object EditInfo: TcxTextEdit
        Left = 198
        Top = 223
        ParentFont = False
        Properties.MaxLength = 50
        TabOrder = 7
        Width = 90
      end
      object ListInfo1: TcxMCListBox
        Left = 23
        Top = 248
        Width = 336
        Height = 85
        HeaderSections = <
          item
            Text = #20449#24687#39033
            Width = 74
          end
          item
            AutoSize = True
            Text = #20449#24687#20869#23481
            Width = 258
          end>
        ParentFont = False
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 8
        OnClick = ListInfo1Click
      end
      object EditAddr: TcxTextEdit
        Left = 69
        Top = 86
        Hint = 'T.P_Addr'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 260
      end
      object ImagePic: TcxImage
        Left = 334
        Top = 36
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 4
        OnDblClick = ImagePicDblClick
        Height = 95
        Width = 80
      end
      object cxTextEdit2: TcxTextEdit
        Left = 69
        Top = 111
        Hint = 'T.P_Phone'
        ParentFont = False
        Properties.MaxLength = 20
        Properties.ReadOnly = True
        TabOrder = 3
        Width = 260
      end
      object EditName: TcxTextEdit
        Left = 69
        Top = 61
        Hint = 'T.P_Name'
        ParentFont = False
        Properties.MaxLength = 32
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 121
      end
      object cxTextEdit1: TcxTextEdit
        Left = 69
        Top = 36
        Hint = 'T.P_ID'
        HelpType = htKeyword
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 121
      end
      object InfoItems: TcxTextEdit
        Left = 69
        Top = 223
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 6
        Width = 90
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #22522#26412#20449#24687
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Group4: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              ShowBorder = False
              object dxLayout1Item1: TdxLayoutItem
                Caption = #32534#21495':'
                Control = cxTextEdit1
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item12: TdxLayoutItem
                Caption = #21517#31216':'
                Control = EditName
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item14: TdxLayoutItem
                Caption = #22320#22336':'
                Control = EditAddr
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item16: TdxLayoutItem
                AutoAligns = [aaVertical]
                AlignHorz = ahClient
                Caption = #30005#35805':'
                Control = cxTextEdit2
                ControlOptions.ShowBorder = False
              end
            end
            object dxLayout1Item3: TdxLayoutItem
              AutoAligns = []
              AlignHorz = ahRight
              AlignVert = avBottom
              Caption = #28857#20987#36873#25321#29031#29255
              CaptionOptions.AlignHorz = taCenter
              CaptionOptions.Layout = clBottom
              ShowCaption = False
              Control = ImagePic
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item6: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #22791#27880':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
        end
        object dxGroup2: TdxLayoutGroup
          Caption = #38468#21152#20449#24687
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item4: TdxLayoutItem
              Caption = #20449#24687#39033':'
              Control = InfoItems
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item8: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #20869#23481':'
              Control = EditInfo
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item11: TdxLayoutItem
            Caption = #21015#34920
            ShowCaption = False
            Control = ListInfo1
            ControlOptions.ShowBorder = False
          end
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
