inherited fFormChangePwd: TfFormChangePwd
  ClientHeight = 153
  ClientWidth = 273
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 273
    Height = 153
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 273
      Height = 153
      Align = alClient
      TabOrder = 0
      LookAndFeel = FDM.dxLayoutWeb1
      object EditPwd: TcxTextEdit
        Left = 81
        Top = 61
        Properties.EchoMode = eemPassword
        Properties.MaxLength = 16
        Properties.PasswordChar = '*'
        TabOrder = 1
        Width = 140
      end
      object EditPwd2: TcxTextEdit
        Left = 81
        Top = 86
        Properties.EchoMode = eemPassword
        Properties.MaxLength = 16
        Properties.PasswordChar = '*'
        TabOrder = 2
        Width = 121
      end
      object BtnOK: TButton
        Left = 138
        Top = 118
        Width = 58
        Height = 22
        Caption = #20445#23384
        TabOrder = 3
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 201
        Top = 118
        Width = 58
        Height = 22
        Caption = #21462#28040
        TabOrder = 4
        OnClick = BtnExitClick
      end
      object EditOld: TcxTextEdit
        Left = 81
        Top = 36
        Properties.EchoMode = eemPassword
        Properties.MaxLength = 16
        Properties.PasswordChar = '*'
        TabOrder = 0
        Width = 166
      end
      object dxLayout1Group_Root: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #20462#25913#23494#30721
          object dxLayout1Item5: TdxLayoutItem
            Caption = #26087' '#23494' '#30721':'
            Control = EditOld
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item1: TdxLayoutItem
            Caption = #26032' '#23494' '#30721':'
            Control = EditPwd
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item2: TdxLayoutItem
            Caption = #20877#36755#19968#27425':'
            Control = EditPwd2
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Group1: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item3: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnOK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item4: TdxLayoutItem
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
end
