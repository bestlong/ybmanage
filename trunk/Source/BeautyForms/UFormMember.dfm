inherited fFormMember: TfFormMember
  Left = 436
  Top = 193
  ClientHeight = 481
  ClientWidth = 542
  OldCreateOrder = True
  PixelsPerInch = 96
  TextHeight = 12
  inherited ClientPanel1: TZnTransPanel
    Width = 542
    Height = 481
    object dxLayout1: TdxLayoutControl
      Left = 0
      Top = 0
      Width = 542
      Height = 481
      Align = alClient
      TabOrder = 0
      TabStop = False
      LookAndFeel = FDM.dxLayoutWeb1
      object BtnOK: TButton
        Left = 392
        Top = 446
        Width = 65
        Height = 22
        Caption = #20445#23384
        TabOrder = 14
        OnClick = BtnOKClick
      end
      object BtnExit: TButton
        Left = 462
        Top = 446
        Width = 65
        Height = 22
        Caption = #20851#38381
        TabOrder = 15
        OnClick = BtnExitClick
      end
      object EditID: TcxButtonEdit
        Left = 81
        Top = 36
        Hint = 'T.M_ID'
        ParentFont = False
        Properties.Buttons = <
          item
            Default = True
            Kind = bkEllipsis
          end>
        Properties.MaxLength = 15
        Properties.OnButtonClick = EditIDPropertiesButtonClick
        TabOrder = 0
        OnKeyDown = EditIDKeyDown
        Width = 248
      end
      object cxTextEdit1: TcxTextEdit
        Left = 81
        Top = 61
        Hint = 'T.M_Name'
        ParentFont = False
        Properties.MaxLength = 30
        TabOrder = 1
        OnKeyDown = EditIDKeyDown
        Width = 121
      end
      object EditSex: TcxComboBox
        Left = 81
        Top = 86
        Hint = 'T.M_Sex'
        ParentFont = False
        Properties.DropDownListStyle = lsEditFixedList
        Properties.Items.Strings = (
          'A=A'#12289#30007
          'B=B'#12289#22899)
        TabOrder = 2
        OnKeyDown = EditIDKeyDown
        Width = 110
      end
      object EditAge: TcxTextEdit
        Left = 254
        Top = 86
        Hint = 'T.M_Age'
        ParentFont = False
        Properties.MaxLength = 5
        TabOrder = 3
        Text = '0'
        OnKeyDown = EditIDKeyDown
        Width = 110
      end
      object EditHeight: TcxTextEdit
        Left = 81
        Top = 111
        Hint = 'T.M_Height'
        ParentFont = False
        Properties.MaxLength = 10
        TabOrder = 4
        Text = '0'
        OnKeyDown = EditIDKeyDown
        Width = 110
      end
      object EditBirthday: TcxDateEdit
        Left = 81
        Top = 136
        Hint = 'T.M_BirthDay'
        ParentFont = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 6
        OnKeyDown = EditIDKeyDown
        Width = 110
      end
      object EditWeight: TcxTextEdit
        Left = 254
        Top = 111
        Hint = 'T.M_Weight'
        ParentFont = False
        Properties.MaxLength = 10
        TabOrder = 5
        Text = '0'
        OnKeyDown = EditIDKeyDown
        Width = 110
      end
      object cxTextEdit5: TcxTextEdit
        Left = 81
        Top = 161
        Hint = 'T.M_Phone'
        ParentFont = False
        Properties.MaxLength = 20
        TabOrder = 8
        OnKeyDown = EditIDKeyDown
        Width = 294
      end
      object EditCDate: TcxDateEdit
        Left = 254
        Top = 136
        Hint = 'T.M_CDate'
        ParentFont = False
        Properties.SaveTime = False
        Properties.ShowTime = False
        TabOrder = 7
        OnKeyDown = EditIDKeyDown
        Width = 110
      end
      object cxTextEdit6: TcxTextEdit
        Left = 81
        Top = 186
        Hint = 'T.M_Addr'
        ParentFont = False
        Properties.MaxLength = 50
        TabOrder = 9
        OnKeyDown = EditIDKeyDown
        Width = 294
      end
      object cxImage1: TcxImage
        Left = 380
        Top = 36
        Style.Edges = [bLeft, bTop, bRight, bBottom]
        TabOrder = 10
        OnClick = cxImage1Click
        Height = 170
        Width = 135
      end
      object wPage: TcxPageControl
        Left = 11
        Top = 273
        Width = 396
        Height = 168
        ActivePage = cxSheet1
        ParentColor = False
        ShowFrame = True
        Style = 9
        TabOrder = 12
        TabSlants.Kind = skCutCorner
        OnChange = wPageChange
        ClientRectBottom = 167
        ClientRectLeft = 1
        ClientRectRight = 395
        ClientRectTop = 19
        object cxSheet1: TcxTabSheet
          Caption = #38468#21152#20449#24687
          ImageIndex = 0
          object Label1: TLabel
            Left = 10
            Top = 20
            Width = 42
            Height = 12
            Caption = #20449#24687#39033':'
          end
          object Label2: TLabel
            Left = 175
            Top = 20
            Width = 54
            Height = 12
            Caption = #20449#24687#20869#23481':'
          end
          object InfoItems: TcxComboBox
            Left = 58
            Top = 15
            ParentFont = False
            TabOrder = 0
            OnKeyDown = EditIDKeyDown
            Width = 110
          end
          object EditInfo: TcxTextEdit
            Left = 235
            Top = 15
            ParentFont = False
            TabOrder = 1
            OnKeyDown = EditIDKeyDown
            Width = 160
          end
          object BtnAdd: TButton
            Left = 400
            Top = 14
            Width = 50
            Height = 22
            Caption = #28155#21152
            TabOrder = 2
            OnClick = BtnAddClick
          end
          object BtnDel: TButton
            Left = 452
            Top = 14
            Width = 50
            Height = 22
            Caption = #21024#38500
            TabOrder = 3
            OnClick = BtnDelClick
          end
          object ListInfo1: TcxMCListBox
            Left = 10
            Top = 40
            Width = 492
            Height = 100
            HeaderSections = <
              item
                Text = #20449#24687#39033
                Width = 100
              end
              item
                AutoSize = True
                Text = #20449#24687#20869#23481
                Width = 388
              end>
            ParentFont = False
            Style.Edges = [bLeft, bTop, bRight, bBottom]
            TabOrder = 4
            OnClick = ListInfo1Click
            OnKeyDown = EditIDKeyDown
          end
        end
        object cxSheet2: TcxTabSheet
          Caption = #20250#21592#20851#31995
          ImageIndex = 1
          object Label3: TLabel
            Left = 10
            Top = 20
            Width = 54
            Height = 12
            Caption = #20851#31995#21517#31216':'
          end
          object Label4: TLabel
            Left = 175
            Top = 20
            Width = 54
            Height = 12
            Caption = #20851#31995#20250#21592':'
          end
          object RelationName: TcxComboBox
            Left = 70
            Top = 15
            ParentFont = False
            TabOrder = 0
            OnKeyDown = EditIDKeyDown
            Width = 100
          end
          object ListRelation1: TcxMCListBox
            Left = 10
            Top = 40
            Width = 492
            Height = 100
            HeaderSections = <
              item
                Text = #20851#31995#21517#31216
                Width = 100
              end
              item
                AutoSize = True
                Text = #20851#31995#20250#21592
                Width = 388
              end>
            ParentFont = False
            Style.Edges = [bLeft, bTop, bRight, bBottom]
            TabOrder = 1
            OnClick = ListRelation1Click
            OnKeyDown = EditIDKeyDown
          end
          object BtnAdd2: TButton
            Left = 400
            Top = 14
            Width = 50
            Height = 22
            Caption = #28155#21152
            TabOrder = 2
            OnClick = BtnAdd2Click
          end
          object BtnDel2: TButton
            Left = 452
            Top = 14
            Width = 50
            Height = 22
            Caption = #21024#38500
            TabOrder = 3
            OnClick = BtnDel2Click
          end
          object RelationMember: TcxComboBox
            Left = 235
            Top = 15
            ParentFont = False
            Properties.DropDownListStyle = lsEditFixedList
            Properties.ImmediateDropDown = False
            Properties.IncrementalSearch = False
            TabOrder = 4
            OnKeyDown = EditIDKeyDown
            Width = 160
          end
        end
        object cxTabSheet1: TcxTabSheet
          Caption = #28040#36153#26126#32454
          ImageIndex = 2
          object Label5: TLabel
            Left = 10
            Top = 13
            Width = 54
            Height = 12
            Caption = #21830#21697#21517#31216':'
          end
          object Label6: TLabel
            Left = 252
            Top = 13
            Width = 54
            Height = 12
            Caption = #37329#39069'('#20803'):'
          end
          object Label7: TLabel
            Left = 10
            Top = 35
            Width = 54
            Height = 12
            Caption = #28040#36153#21512#35745':'
          end
          object ListXF: TcxMCListBox
            Left = 10
            Top = 55
            Width = 492
            Height = 85
            HeaderSections = <
              item
                Text = #28040#36153#32534#21495
                Width = 75
              end
              item
                Text = #28040#36153#21830#21697
                Width = 120
              end
              item
                Text = #28040#36153#37329#39069
                Width = 80
              end
              item
                Text = #28040#36153#26085#26399
                Width = 100
              end>
            ParentFont = False
            Style.Edges = [bLeft, bTop, bRight, bBottom]
            TabOrder = 0
            OnClick = ListRelation1Click
            OnKeyDown = EditIDKeyDown
          end
          object BtnAdd3: TButton
            Left = 400
            Top = 10
            Width = 50
            Height = 22
            Caption = #28155#21152
            TabOrder = 1
            OnClick = BtnAdd3Click
          end
          object BtnDel3: TButton
            Left = 452
            Top = 10
            Width = 50
            Height = 22
            Caption = #21024#38500
            TabOrder = 2
            OnClick = BtnDel3Click
          end
          object EditSP: TcxComboBox
            Left = 70
            Top = 10
            ParentFont = False
            Properties.ImmediateDropDown = False
            Properties.IncrementalSearch = False
            Properties.MaxLength = 50
            TabOrder = 3
            OnKeyDown = EditIDKeyDown
            Width = 170
          end
          object EditMoney: TcxTextEdit
            Left = 310
            Top = 10
            ParentFont = False
            TabOrder = 4
            Width = 80
          end
          object EditHJ: TcxTextEdit
            Left = 70
            Top = 33
            ParentFont = False
            TabOrder = 5
            Width = 432
          end
        end
      end
      object cxMemo1: TcxMemo
        Left = 81
        Top = 211
        Hint = 'T.M_Memo'
        ParentFont = False
        Properties.MaxLength = 50
        TabOrder = 11
        OnKeyDown = EditIDKeyDown
        Height = 50
        Width = 434
      end
      object EditBeauty: TcxTextEdit
        Left = 57
        Top = 446
        Hint = 'T.M_Beautician'
        HelpType = htKeyword
        HelpKeyword = 'NI|NU'
        ParentFont = False
        Properties.MaxLength = 15
        TabOrder = 13
        Width = 121
      end
      object dxLayoutGroup1: TdxLayoutGroup
        ShowCaption = False
        Hidden = True
        ShowBorder = False
        object dxGroup1: TdxLayoutGroup
          Caption = #22522#26412#20449#24687
          object dxLayout1Group3: TdxLayoutGroup
            ShowCaption = False
            Hidden = True
            LayoutDirection = ldHorizontal
            ShowBorder = False
            object dxLayout1Group4: TdxLayoutGroup
              ShowCaption = False
              Hidden = True
              ShowBorder = False
              object dxLayout1Item3: TdxLayoutItem
                Caption = #20250#21592#32534#21495':'
                Control = EditID
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Item4: TdxLayoutItem
                Caption = #20250#21592#22995#21517':'
                Control = cxTextEdit1
                ControlOptions.ShowBorder = False
              end
              object dxLayout1Group2: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                LayoutDirection = ldHorizontal
                ShowBorder = False
                object dxLayout1Item5: TdxLayoutItem
                  Caption = #24615#21035':'
                  Control = EditSex
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item6: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  AlignHorz = ahClient
                  Caption = #24180#40836':'
                  Control = EditAge
                  ControlOptions.ShowBorder = False
                end
              end
              object dxLayout1Group5: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                LayoutDirection = ldHorizontal
                ShowBorder = False
                object dxLayout1Item7: TdxLayoutItem
                  Caption = #36523#39640'(CM):'
                  Control = EditHeight
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item9: TdxLayoutItem
                  AutoAligns = [aaVertical]
                  AlignHorz = ahClient
                  Caption = #20307#37325'(KG):'
                  Control = EditWeight
                  ControlOptions.ShowBorder = False
                end
              end
              object dxLayout1Group6: TdxLayoutGroup
                ShowCaption = False
                Hidden = True
                ShowBorder = False
                object dxLayout1Group8: TdxLayoutGroup
                  ShowCaption = False
                  Hidden = True
                  LayoutDirection = ldHorizontal
                  ShowBorder = False
                  object dxLayout1Item8: TdxLayoutItem
                    Caption = #29983#26085':'
                    Control = EditBirthday
                    ControlOptions.ShowBorder = False
                  end
                  object dxLayout1Item11: TdxLayoutItem
                    AutoAligns = [aaVertical]
                    AlignHorz = ahClient
                    Caption = #24314#26723#26085#26399':'
                    Control = EditCDate
                    ControlOptions.ShowBorder = False
                  end
                end
                object dxLayout1Item10: TdxLayoutItem
                  Caption = #32852#31995#26041#24335':'
                  Control = cxTextEdit5
                  ControlOptions.ShowBorder = False
                end
                object dxLayout1Item12: TdxLayoutItem
                  Caption = #32852#31995#22320#22336':'
                  Control = cxTextEdit6
                  ControlOptions.ShowBorder = False
                end
              end
            end
            object dxLayout1Item13: TdxLayoutItem
              Caption = #28857#20987#36873#25321#29031#29255
              CaptionOptions.AlignHorz = taCenter
              CaptionOptions.Layout = clBottom
              ShowCaption = False
              Control = cxImage1
              ControlOptions.ShowBorder = False
            end
          end
          object dxLayout1Item15: TdxLayoutItem
            Caption = #22791#27880#20449#24687':'
            Control = cxMemo1
            ControlOptions.ShowBorder = False
          end
        end
        object dxLayout1Item14: TdxLayoutItem
          Caption = #20998#39029#22841
          ShowCaption = False
          Control = wPage
          ControlOptions.AutoColor = True
          ControlOptions.ShowBorder = False
        end
        object dxLayoutGroup2: TdxLayoutGroup
          ShowCaption = False
          Hidden = True
          LayoutDirection = ldHorizontal
          ShowBorder = False
          object dxLayout1Item16: TdxLayoutItem
            Caption = #32654#23481#24072':'
            Visible = False
            Control = EditBeauty
            ControlOptions.ShowBorder = False
          end
          object dxLayoutItem1: TdxLayoutItem
            AutoAligns = [aaVertical]
            AlignHorz = ahRight
            Caption = 'Button1'
            ShowCaption = False
            Control = BtnOK
            ControlOptions.ShowBorder = False
          end
          object dxLayout1Item2: TdxLayoutItem
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
