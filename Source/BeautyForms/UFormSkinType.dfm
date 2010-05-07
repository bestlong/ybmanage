inherited fFormSkinType: TfFormSkinType
  Left = 276
  Top = 207
  ClientHeight = 380
  ClientWidth = 443
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 443
    Height = 380
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 443
      Height = 380
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnExit: TButton
        Left = 366
        Top = 345
        Width = 65
        Height = 22
        Caption = #20851#38381
        TabOrder = 8
        OnClick = BtnExitClick
      end
      object EditMemo: TcxMemo
        Left = 57
        Top = 111
        Hint = 'T.T_Memo'
        ParentFont = False
        Properties.MaxLength = 50
        Properties.ReadOnly = True
        Style.Edges = [bBottom]
        TabOrder = 3
        Height = 50
        Width = 255
      end
      object EditInfo: TcxTextEdit
        Left = 200
        Top = 198
        ParentFont = False
        Properties.MaxLength = 50
        Properties.ReadOnly = True
        TabOrder = 6
        Width = 133
      end
      object ListInfo1: TcxMCListBox
        Left = 23
        Top = 223
        Width = 240
        Height = 110
        HeaderSections = <
          item
            Text = #21517#31216
            Width = 74
          end
          item
            AutoSize = True
            Text = #20869#23481
            Width = 162
          end>
        ParentFont = False
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 7
        OnClick = ListInfo1Click
      end
      object ImagePic: TcxImage
        Left = 317
        Top = 36
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 4
        OnDblClick = ImagePicDblClick
        Height = 125
        Width = 102
      end
      object EditName: TcxTextEdit
        Left = 57
        Top = 61
        Hint = 'T.T_Name'
        ParentFont = False
        Properties.MaxLength = 32
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 255
      end
      object cxTextEdit1: TcxTextEdit
        Left = 57
        Top = 36
        Hint = 'T.T_ID'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 255
      end
      object EditPart: TcxTextEdit
        Left = 57
        Top = 86
        Hint = 'T.T_Part'
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 255
      end
      object InfoItems: TcxTextEdit
        Left = 57
        Top = 198
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 5
        Width = 104
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #22522#26412#20449#24687
          LayoutDirection = ldHorizontal
          object dxLayout1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            ShowBorder = False
            object dxLayout1Item1: TdxLayoutItem
              Caption = #32534#21495':'
              Control = cxTextEdit1
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item13: TdxLayoutItem
              Caption = #21517#31216':'
              Control = EditName
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item4: TdxLayoutItem
              Caption = #37096#20301':'
              Control = EditPart
              ControlOptions.ShowBorder = False
            end
            object dxLayout1Item6: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #22791#27880':'
              Control = EditMemo
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
        object dxGroup2: TdxLayoutGroup
          Caption = #30382#32932#29366#24577
          object dxLayout1Group2: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Item5: TdxLayoutItem
              Caption = #21517#31216':'
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
