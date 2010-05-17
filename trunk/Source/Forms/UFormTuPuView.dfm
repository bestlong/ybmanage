inherited fFormTuPuView: TfFormTuPuView
  Left = 330
  Top = 242
  ClientHeight = 373
  ClientWidth = 374
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 374
    Height = 373
    AutoContentSizes = [acsWidth, acsHeight]
    AutoControlAlignment = False
    inherited BtnOK: TButton
      Left = 228
      Top = 340
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 298
      Top = 340
      Caption = #20851#38381
      TabOrder = 5
    end
    object cxImage1: TcxImage [2]
      Left = 112
      Top = 36
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      Height = 150
      Width = 150
    end
    object cxTextEdit1: TcxTextEdit [3]
      Left = 87
      Top = 223
      Hint = 'T.T_LevelA'
      Properties.ReadOnly = True
      TabOrder = 1
      Width = 121
    end
    object cxTextEdit2: TcxTextEdit [4]
      Left = 87
      Top = 248
      Hint = 'T.T_LevelB'
      Properties.ReadOnly = True
      TabOrder = 2
      Width = 121
    end
    object cxMemo1: TcxMemo [5]
      Left = 81
      Top = 273
      Hint = 'T.T_Memo'
      Properties.ReadOnly = True
      Properties.ScrollBars = ssVertical
      TabOrder = 3
      Height = 54
      Width = 253
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        Caption = #32553#30053#22270
        object dxLayout1Item4: TdxLayoutItem
          AutoAligns = [aaVertical]
          AlignHorz = ahCenter
          Caption = 'cxImage1'
          ShowCaption = False
          Control = cxImage1
          ControlOptions.ShowBorder = False
        end
      end
      object dxGroup2: TdxLayoutGroup [1]
        AutoAligns = [aaHorizontal]
        AlignVert = avClient
        Caption = #22522#26412#20449#24687
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26816#32034#20869#23481'A:'
          Control = cxTextEdit1
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #26816#32034#20869#23481'B:'
          Control = cxTextEdit2
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #22791#27880#20449#24687':'
          Control = cxMemo1
          ControlOptions.ShowBorder = False
        end
      end
      inherited dxLayout1Group1: TdxLayoutGroup
        inherited dxLayout1Item1: TdxLayoutItem
          Visible = False
        end
      end
    end
  end
end
