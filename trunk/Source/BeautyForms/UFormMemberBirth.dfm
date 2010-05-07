inherited fFormMemberBirth: TfFormMemberBirth
  Left = 348
  Top = 311
  ClientHeight = 343
  ClientWidth = 334
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 334
    Height = 343
    object BtnExit: TButton
      Left = 256
      Top = 314
      Width = 65
      Height = 21
      Anchors = [akRight, akBottom]
      Caption = #20851#38381
      TabOrder = 1
      OnClick = BtnExitClick
    end
    object ListUser1: TcxMCListBox
      Left = 12
      Top = 22
      Width = 309
      Height = 285
      Anchors = [akLeft, akTop, akRight, akBottom]
      HeaderSections = <
        item
          Text = #20250#21592#32534#21495
          Width = 80
        end
        item
          Alignment = taCenter
          Text = #20250#21592#22995#21517
          Width = 80
        end
        item
          Alignment = taCenter
          Text = #20250#21592#24615#21035
          Width = 70
        end
        item
          Alignment = taCenter
          AutoSize = True
          Text = #20986#29983#24180#26376
          Width = 75
        end>
      ParentFont = False
      Style.Edges = [bLeft, bTop, bRight, bBottom]
      TabOrder = 0
    end
  end
end
