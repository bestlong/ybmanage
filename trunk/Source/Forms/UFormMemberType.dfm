inherited fFormMemberType: TfFormMemberType
  ClientHeight = 242
  ClientWidth = 362
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  inherited dxLayout1: TdxLayoutControl
    Width = 362
    Height = 242
    inherited BtnOK: TButton
      Left = 213
      Top = 208
      TabOrder = 5
    end
    inherited BtnExit: TButton
      Left = 283
      Top = 208
      TabOrder = 6
    end
    object EditType: TcxTextEdit [2]
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 20
      TabOrder = 0
      Width = 200
    end
    object EditMemo: TcxTextEdit [3]
      Left = 81
      Top = 61
      ParentFont = False
      Properties.MaxLength = 50
      TabOrder = 2
      Width = 200
    end
    object BtnAdd: TButton [4]
      Left = 286
      Top = 36
      Width = 50
      Height = 20
      Caption = #28155#21152
      TabOrder = 1
      OnClick = BtnAddClick
    end
    object BtnDel: TButton [5]
      Left = 286
      Top = 61
      Width = 50
      Height = 20
      Caption = #21024#38500
      TabOrder = 3
      OnClick = BtnDelClick
    end
    object TypeList1: TcxMCListBox [6]
      Left = 23
      Top = 86
      Width = 313
      Height = 110
      HeaderSections = <
        item
          Text = #31867#21035#21517#31216
          Width = 85
        end
        item
          AutoSize = True
          Text = #22791#27880#20449#24687
          Width = 224
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
      OnKeyDown = TypeList1KeyDown
    end
    inherited dxLayout1Group_Root: TdxLayoutGroup
      inherited dxGroup1: TdxLayoutGroup
        object dxLayout1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            Caption = #31867#21035#21517#31216':'
            Control = EditType
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item5: TdxLayoutItem
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnAdd
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item4: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = EditMemo
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item6: TdxLayoutItem
            Caption = 'Button2'
            ShowCaption = False
            Control = BtnDel
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item7: TdxLayoutItem
          Control = TypeList1
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
