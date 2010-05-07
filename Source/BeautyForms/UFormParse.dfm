inherited fFormParse: TfFormParse
  Left = 122
  Top = 183
  ClientHeight = 426
  ClientWidth = 804
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 804
    Height = 426
    object LPanel1: TZnTransPanel
      Left = 0
      Top = 42
      Width = 175
      Height = 342
      Align = alLeft
      object ScrollBox1: TScrollBox
        Left = 0
        Top = 0
        Width = 175
        Height = 342
        VertScrollBar.Tracking = True
        Align = alClient
        BevelEdges = []
        BevelKind = bkTile
        BorderStyle = bsNone
        TabOrder = 0
      end
    end
    object RTPanel: TZnTransPanel
      Left = 0
      Top = 0
      Width = 804
      Height = 42
      Align = alTop
      object Label2: TLabel
        Left = 8
        Top = 17
        Width = 54
        Height = 12
        Caption = #37319#38598#26085#26399':'
        Transparent = True
      end
      object Label3: TLabel
        Left = 218
        Top = 17
        Width = 54
        Height = 12
        Caption = #37319#38598#37096#20301':'
        Transparent = True
      end
      object Label4: TLabel
        Left = 385
        Top = 17
        Width = 54
        Height = 12
        Caption = #22270#20687#22823#23567':'
        Transparent = True
      end
      object Label6: TLabel
        Left = 530
        Top = 17
        Width = 54
        Height = 12
        Caption = #22270#29255#25551#36848':'
        Transparent = True
      end
      object EditDate: TcxTextEdit
        Left = 65
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 0
        Width = 145
      end
      object EditPart: TcxTextEdit
        Left = 275
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 1
        Width = 100
      end
      object EditSize: TcxTextEdit
        Left = 442
        Top = 12
        ParentFont = False
        Properties.ReadOnly = True
        TabOrder = 2
        Width = 78
      end
      object EditDesc: TcxTextEdit
        Left = 588
        Top = 12
        ParentFont = False
        TabOrder = 3
        Width = 200
      end
    end
    object BPanel1: TZnTransPanel
      Left = 0
      Top = 384
      Width = 804
      Height = 42
      Align = alBottom
      DesignSize = (
        804
        42)
      object Label1: TLabel
        Left = 8
        Top = 17
        Width = 54
        Height = 12
        Caption = #31579#36873#22270#20687':'
        Transparent = True
      end
      object BtnExit: TButton
        Left = 730
        Top = 10
        Width = 60
        Height = 22
        Anchors = [akRight, akBottom]
        Caption = #36864#20986
        TabOrder = 0
        OnClick = BtnExitClick
      end
      object EditFilter: TcxButtonEdit
        Left = 65
        Top = 12
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.ReadOnly = True
        Properties.OnButtonClick = EditFilterPropertiesButtonClick
        TabOrder = 1
        Width = 145
      end
      object BtnSave: TButton
        Left = 665
        Top = 10
        Width = 60
        Height = 22
        Anchors = [akRight, akBottom]
        Caption = #20445#23384
        TabOrder = 2
        OnClick = BtnSaveClick
      end
    end
    object wPanel: TZnTransPanel
      Left = 175
      Top = 42
      Width = 629
      Height = 342
      Align = alClient
      object ViewItem1: TImageViewItem
        Left = 10
        Top = 32
        Width = 200
        Height = 100
        PopupMenu = PMenu1
        OnDragDrop = ViewItem1DragDrop
        OnDragOver = ViewItem1DragOver
        CanSelected = True
        OnSelected = ViewItem1Selected
      end
    end
  end
  object PMenu1: TPopupMenu
    AutoHotkeys = maManual
    Left = 2
    Top = 64
    object N1: TMenuItem
      Tag = 10
      Caption = #36866#21512#22270#20687
      OnClick = N1Click
    end
    object N2: TMenuItem
      Tag = 20
      Caption = #23454#38469#22823#23567
      OnClick = N1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object N501: TMenuItem
      Tag = 30
      Caption = #32553#25918' 50%'
      OnClick = N1Click
    end
    object N751: TMenuItem
      Tag = 40
      Caption = #32553#25918' 75%'
      OnClick = N1Click
    end
    object N1201: TMenuItem
      Tag = 50
      Caption = #32553#25918' 120%'
      OnClick = N1Click
    end
    object N1501: TMenuItem
      Tag = 60
      Caption = #32553#25918' 150%'
      OnClick = N1Click
    end
    object N2001: TMenuItem
      Tag = 70
      Caption = #32553#25918' 200%'
      OnClick = N1Click
    end
  end
end
