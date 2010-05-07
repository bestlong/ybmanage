inherited fFormImageFilter: TfFormImageFilter
  ClientHeight = 195
  ClientWidth = 311
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 311
    Height = 195
    object Bevel1: TBevel
      Left = 10
      Top = 12
      Width = 289
      Height = 140
      Shape = bsFrame
    end
    object Label1: TLabel
      Left = 30
      Top = 45
      Width = 54
      Height = 12
      Caption = #37096#20301#21517#31216':'
      Transparent = True
    end
    object Label2: TLabel
      Left = 30
      Top = 98
      Width = 54
      Height = 12
      Caption = #24320#22987#26085#26399':'
      Transparent = True
    end
    object Label3: TLabel
      Left = 30
      Top = 122
      Width = 54
      Height = 12
      Caption = #32467#26463#26085#26399':'
      Transparent = True
    end
    object Check1: TcxCheckBox
      Left = 12
      Top = 18
      Caption = #25353#37319#38598#37096#20301
      ParentFont = False
      TabOrder = 0
      Transparent = True
      Width = 121
    end
    object Check2: TcxCheckBox
      Left = 12
      Top = 72
      Caption = #25353#37319#38598#26085#26399
      ParentFont = False
      State = cbsChecked
      TabOrder = 1
      Transparent = True
      Width = 95
    end
    object EditPart: TcxComboBox
      Left = 86
      Top = 40
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 2
      Width = 155
    end
    object EditStart: TcxDateEdit
      Left = 86
      Top = 92
      ParentFont = False
      Properties.SaveTime = False
      TabOrder = 3
      Width = 155
    end
    object EditEnd: TcxDateEdit
      Left = 86
      Top = 118
      ParentFont = False
      Properties.SaveTime = False
      TabOrder = 4
      Width = 155
    end
    object BtnOK: TButton
      Left = 164
      Top = 161
      Width = 65
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #30830#23450
      TabOrder = 5
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 233
      Top = 161
      Width = 65
      Height = 22
      Anchors = [akRight, akBottom]
      Caption = #21462#28040
      TabOrder = 6
      OnClick = BtnExitClick
    end
  end
end
