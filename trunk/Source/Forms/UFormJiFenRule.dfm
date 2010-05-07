inherited fFormJiFenRule: TfFormJiFenRule
  Left = 312
  Top = 312
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  ClientHeight = 236
  ClientWidth = 404
  OldCreateOrder = True
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 12
  object dxLayoutControl1: TdxLayoutControl
    Left = 0
    Top = 0
    Width = 404
    Height = 236
    Align = alClient
    TabOrder = 0
    TabStop = False
    AutoContentSizes = [acsWidth, acsHeight]
    LookAndFeel = FDM.dxLayoutWeb1
    object EditMoney: TcxTextEdit
      Left = 81
      Top = 36
      ParentFont = False
      Properties.MaxLength = 10
      TabOrder = 0
      Width = 158
    end
    object EditFen: TcxTextEdit
      Left = 81
      Top = 63
      ParentFont = False
      Properties.MaxLength = 10
      Properties.PasswordChar = '*'
      TabOrder = 2
      Width = 166
    end
    object ListRule: TcxMCListBox
      Left = 23
      Top = 90
      Width = 362
      Height = 125
      HeaderSections = <
        item
          DataIndex = 1
          Text = #37329#39069'('#20803')'
          Width = 74
        end
        item
          DataIndex = 2
          Text = #31215#20998#20540
          Width = 100
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 4
    end
    object BtnAdd: TButton
      Left = 321
      Top = 36
      Width = 60
      Height = 22
      Caption = #28155#21152
      TabOrder = 1
      OnClick = BtnAddClick
    end
    object BtnDel: TButton
      Left = 321
      Top = 63
      Width = 60
      Height = 22
      Caption = #21024#38500
      TabOrder = 3
      OnClick = BtnDelClick
    end
    object dxLayoutControl1Group_Root: TdxLayoutGroup
      ShowCaption = False
      Hidden = True
      ShowBorder = False
      object dxLayoutControl1Group1: TdxLayoutGroup
        Caption = #26631#20934#26126#32454
        object dxLayoutControl1Group3: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          ShowBorder = False
          object dxLayoutControl1Group4: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item1: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #37329#39069'('#20803'):'
              Control = EditMoney
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item2: TdxLayoutItem
              Caption = 'Button1'
              ShowCaption = False
              Control = BtnAdd
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayoutControl1Group5: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayoutControl1Item3: TdxLayoutItem
              AutoAligns = [aaVertical]
              AlignHorz = ahClient
              Caption = #31215' '#20998' '#20540':'
              Control = EditFen
              ControlOptions.ShowBorder = False
            end
            object dxLayoutControl1Item7: TdxLayoutItem
              Caption = 'Button2'
              ShowCaption = False
              Control = BtnDel
              ControlOptions.ShowBorder = False
            end
          end
        end
        object dxLayoutControl1Item6: TdxLayoutItem
          Caption = 'cxMCListBox1'
          ShowCaption = False
          Control = ListRule
          ControlOptions.ShowBorder = False
        end
      end
    end
  end
end
