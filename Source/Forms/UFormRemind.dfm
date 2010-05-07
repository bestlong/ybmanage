inherited fFormRemind: TfFormRemind
  Left = 248
  Top = 265
  ClientHeight = 231
  ClientWidth = 350
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 350
    Height = 231
    inherited BtnOK: TButton
      Left = 204
      Top = 198
      TabOrder = 4
    end
    inherited BtnExit: TButton
      Left = 274
      Top = 198
      TabOrder = 5
    end
    object EditDate: TcxDateEdit [2]
      Left = 57
      Top = 36
      Hint = 'T.R_Date'
      ParentFont = False
      TabOrder = 0
      OnKeyDown = OnCtrlKeyDown
      Width = 168
    end
    object EditType: TcxComboBox [3]
      Left = 57
      Top = 61
      Hint = 'T.R_Type'
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 1
      OnKeyDown = OnCtrlKeyDown
      Width = 121
    end
    object EditTitle: TcxTextEdit [4]
      Left = 57
      Top = 86
      Hint = 'T.R_Title'
      ParentFont = False
      TabOrder = 2
      OnKeyDown = OnCtrlKeyDown
      Width = 121
    end
    object EditMemo: TcxMemo [5]
      Left = 57
      Top = 111
      Hint = 'T.R_Memo'
      ParentFont = False
      Properties.ScrollBars = ssVertical
      Style.Edges = [bBottom]
      TabOrder = 3
      OnKeyDown = OnCtrlKeyDown
      Height = 75
      Width = 270
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item3: TdxLayoutItem
          Caption = #26085#26399':'
          Control = EditDate
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item4: TdxLayoutItem
          Caption = #31867#22411':'
          Control = EditType
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #26631#39064':'
          Control = EditTitle
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item6: TdxLayoutItem
          Caption = #20869#23481':'
          Control = EditMemo
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
