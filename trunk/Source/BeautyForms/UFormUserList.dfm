inherited fFormUseList: TfFormUseList
  Left = 348
  Top = 311
  ClientHeight = 296
  ClientWidth = 293
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 293
    Height = 296
    object BtnOK: TButton
      Left = 147
      Top = 267
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = #30830#23450
      TabOrder = 1
      OnClick = BtnOKClick
    end
    object BtnExit: TButton
      Left = 215
      Top = 267
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = #21462#28040
      ModalResult = 2
      TabOrder = 2
    end
    object ListUser1: TcxMCListBox
      Left = 12
      Top = 22
      Width = 268
      Height = 238
      Anchors = [akLeft, akTop, akRight, akBottom]
      HeaderSections = <
        item
          Text = #29992#25143#21517
          Width = 80
        end
        item
          Text = #25152#22312#32452
          Width = 80
        end
        item
          AutoSize = True
          Text = #26159#21542#26377#25928
          Width = 104
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
      OnDblClick = ListUser1DblClick
    end
  end
end
