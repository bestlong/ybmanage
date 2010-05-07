inherited fFormJIFen: TfFormJIFen
  Left = 329
  Top = 317
  ClientHeight = 180
  ClientWidth = 356
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 356
    Height = 180
    inherited BtnOK: TButton
      Left = 207
      Top = 143
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 277
      Top = 143
      TabOrder = 6
    end
    object EditMoney: TcxTextEdit [2]
      Left = 81
      Top = 111
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 3
      Width = 226
    end
    object EditSP: TcxComboBox [3]
      Left = 81
      Top = 86
      ParentFont = False
      Properties.ImmediateDropDown = False
      Properties.IncrementalSearch = False
      TabOrder = 2
      Width = 148
    end
    object cxLabel1: TcxLabel [4]
      Left = 312
      Top = 111
      AutoSize = False
      Caption = #20803
      ParentFont = False
      Properties.Alignment.Horz = taCenter
      Properties.Alignment.Vert = taVCenter
      Transparent = True
      Height = 20
      Width = 18
      AnchorX = 321
      AnchorY = 121
    end
    object EditMRS: TcxComboBox [5]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      Properties.OnChange = EditMRSPropertiesChange
      TabOrder = 0
      Width = 121
    end
    object EditFirm: TcxComboBox [6]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.DropDownListStyle = lsEditFixedList
      TabOrder = 1
      Width = 121
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Item4: TdxLayoutItem
          Caption = #32654' '#23481' '#24072':'
          Control = EditMRS
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item5: TdxLayoutItem
          Caption = #20250#21592#21517#31216':'
          Control = EditFirm
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Item17: TdxLayoutItem
          Caption = #21830#21697#21517#31216':'
          Control = EditSP
          ControlOptions.ShowBorder = False
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item12: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahClient
            Caption = #28040#36153#37329#39069':'
            Control = EditMoney
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'cxLabel1'
            ShowCaption = False
            Control = cxLabel1
            ControlOptions.ShowBorder = False
          end
        end
      end
    end
  end
end
