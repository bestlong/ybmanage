{*******************************************************************************
  作者: dmzn@163.com 2009-6-30
  描述: 会员管理
*******************************************************************************}
unit UFormMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBgFormBase, UTransPanel, cxGraphics, dxLayoutControl, cxMemo,
  cxMCListBox, StdCtrls, cxPC, cxImage, cxDropDownEdit, cxCalendar,
  cxTextEdit, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit, cxControls;

type
  TfFormMember = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditID: TcxButtonEdit;
    cxTextEdit1: TcxTextEdit;
    EditSex: TcxComboBox;
    EditAge: TcxTextEdit;
    EditHeight: TcxTextEdit;
    EditBirthday: TcxDateEdit;
    EditWeight: TcxTextEdit;
    cxTextEdit5: TcxTextEdit;
    EditCDate: TcxDateEdit;
    cxTextEdit6: TcxTextEdit;
    cxImage1: TcxImage;
    wPage: TcxPageControl;
    cxSheet1: TcxTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    InfoItems: TcxComboBox;
    EditInfo: TcxTextEdit;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListInfo1: TcxMCListBox;
    cxSheet2: TcxTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    RelationName: TcxComboBox;
    ListRelation1: TcxMCListBox;
    BtnAdd2: TButton;
    BtnDel2: TButton;
    RelationMember: TcxComboBox;
    cxMemo1: TcxMemo;
    EditBeauty: TcxTextEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Item14: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayout1Item16: TdxLayoutItem;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    cxTabSheet1: TcxTabSheet;
    Label5: TLabel;
    Label6: TLabel;
    ListXF: TcxMCListBox;
    BtnAdd3: TButton;
    BtnDel3: TButton;
    EditSP: TcxComboBox;
    EditMoney: TcxTextEdit;
    Label7: TLabel;
    EditHJ: TcxTextEdit;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure wPageChange(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxImage1Click(Sender: TObject);
    procedure ListRelation1Click(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure EditIDKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnDel3Click(Sender: TObject);
    procedure BtnAdd3Click(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    FImageFile: string;
    //图片文件
    FDataInfoChanged,FDataRelationChanged: Boolean;
    //数据变动
    procedure InitFormData(const nID: string);
    //载入数据
    procedure SetFormModal(const nEdit: Boolean);
    //窗体模式
    function IsDataValid: Boolean;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
    //验证数据
    procedure GetData(Sender: TObject; var nData: string);
    //获取数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
    procedure LoadXFAll;
    //消费合计
  public
    { Public declarations }
    FMemberChanged: Boolean;
    //会员变动
  end;

function ShowAddMemberForm(const nRect: TRect): TForm;
function ShowEditMemberForm(const nID: string; const nRect: TRect): TForm;
function ShowViewMemberForm(const nID: string; const nRect: TRect): TForm;
function DeleteMember(const nID: string): Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, UMgrControl, USysDB, USysGrid,
  USysConst, USysGobal, UDataModule;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-6-30
//Parm: 显示区域
//Desc: 在nRect中间位置显示会员添加窗口
function ShowAddMemberForm(const nRect: TRect): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormMember.Create(Application);
  Result := gForm;

  with TfFormMember(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FRecordID := '';
    SetFormModal(True);

    InitFormData('');
    if not Showing then Show;
  end;
end;

//Date: 2009-7-2
//Parm: 会员编号;显示区域
//Desc: 在nRect区域显示修改nID会员资料的窗口
function ShowEditMemberForm(const nID: string; const nRect: TRect): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormMember.Create(Application);
  Result := gForm;

  with TfFormMember(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FRecordID := nID;
    SetFormModal(True);

    InitFormData(nID);
    if not Showing then Show;
  end;
end;

//Date: 2009-7-2
//Parm: 会员编号;显示区域
//Desc: 在nRect区域显示nID会员的资料卡
function ShowViewMemberForm(const nID: string; const nRect: TRect): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormMember.Create(Application);
  Result := gForm;

  with TfFormMember(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FRecordID := nID;
    SetFormModal(False);
    
    InitFormData(nID);
    if not Showing then Show;
  end;
end;

function DeleteMember(const nID: string): Boolean;
begin
  Result := True;
end;

//------------------------------------------------------------------------------
procedure TfFormMember.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  inherited;
  FMemberChanged := False;
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo1, nIni);
    LoadMCListBoxConfig(Name, ListRelation1, nIni);
    LoadMCListBoxConfig(Name, ListXF, nIni);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'HY');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllForm(Self, 'T', sTable_Member);
  //重置表名称
end;

procedure TfFormMember.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  inherited;
  if Action <> caFree then Exit;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo1, nIni);
    SaveMCListBoxConfig(Name, ListRelation1, nIni);
    SaveMCListBoxConfig(Name, ListXF, nIni);
  finally
    nIni.Free;
  end;

  gForm := nil;
  ReleaseCtrlData(Self);
  if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
end;

procedure TfFormMember.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------ 
//Date: 2009-7-2
//Parm: 是否编辑模式
//Desc: 设置不同模式时的窗口状态
procedure TfFormMember.SetFormModal(const nEdit: Boolean);
begin
  BtnOK.Visible := nEdit;
  BtnAdd.Enabled := nEdit;
  BtnDel.Enabled := nEdit;
  BtnAdd2.Enabled := nEdit;
  BtnDel2.Enabled := nEdit;
  BtnAdd3.Enabled := FRecordID <> '';
  BtnDel3.Enabled := FRecordID <> '';
end;

//Desc: 处理快捷键
procedure TfFormMember.EditIDKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case Key of
     VK_DOWN:
      begin
        Key := 0; SwitchFocusCtrl(Self, True);
      end;
     VK_UP:
      begin
        Key := 0; SwitchFocusCtrl(Self, False);
      end;
    end;
  end;
end;

procedure TfFormMember.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditBirthday then
  begin
    nData := DateToStr(EditBirthday.Date);
  end else

  if Sender = EditCDate then
  begin
    nData := DateToStr(EditCDate.Date);
  end;
end;

function TfFormMember.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditBirthday then
  begin
    Result := True;
    EditBirthday.Date := Str2Date(nData);
  end else

  if Sender = EditCDate then
  begin
    Result := True;
    EditCDate.Date := Str2Date(nData);
  end;
end;

procedure TfFormMember.InitFormData(const nID: string);
var nStr: string;
begin
  EditCDate.Date := Date;
  EditBirthday.Date := Date;

  if gSysParam.FGroupID = IntToStr(cBeauticianGroup) then
  begin
    EditBeauty.HelpKeyword := '';
    EditBeauty.Text := gSysParam.FBeautyID;
  end else
  begin
    EditBeauty.HelpKeyword := 'NI|NU'; //不参与构建SQL
  end;

  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_MemberItem)]);
    //数据字典中会员信息项

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        InfoItems.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if FRecordID <> '' then
  begin
    FDataInfoChanged := False;
    FDataRelationChanged := False;

    nStr := 'Select * from %s Where M_ID=''%s''';
    nStr := Format(nStr, [sTable_Member, nID]);

    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
    FDM.LoadDBImage(FDM.SqlTemp, 'M_Image', cxImage1.Picture);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_MemberItem), MI('$ID', nID)]);
    //扩展信息

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('I_Item').AsString + ListInfo1.Delimiter +
                FieldByName('I_Info').AsString;
        ListInfo1.Items.Add(nStr);

        Next;
      end;
    end;

    ListRelation1.Tag := 0;
    wPageChange(nil);
  end else
  begin
    ListRelation1.Clear;
    FDataInfoChanged := True;
    FDataRelationChanged := True; //数据变动后会保存
  end;
end;

//Desc: 页面切换,载入会员关系
procedure TfFormMember.wPageChange(Sender: TObject);
var nStr: string;
begin
  if RelationName.Properties.Items.Count < 1 then
  begin
    RelationName.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_RelationItem)]);
    //数据字典中会员关系信息项

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        RelationName.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if RelationMember.Properties.Items.Count < 1 then
  begin
    nStr := 'M_ID=Select M_ID, M_Name From $Mem';
    nStr := MacroValue(nStr, [MI('$Mem', sTable_Member)]);
    if FRecordID <> '' then nStr := nStr + ' Where M_ID<>''' + FRecordID + '''';
    
    FDM.FillStringsData(RelationMember.Properties.Items, nStr);
    AdjustCXComboBoxItem(RelationMember, False);
  end;

  if (FRecordID <> '') and (ListRelation1.Tag <> 27) then
  begin
    nStr := 'Select E_FID, E_Relation, E_BID,' +
            ' (Select M_Name From $Mem Where M_ID=t.E_FID) as E_FName, ' +
            ' (Select M_Name From $Mem Where M_ID=t.E_BID) as E_BName ' +
            'From $Ext t Where E_FID=''$ID'' Or E_BID=''$ID''';

    nStr := MacroValue(nStr, [MI('$Mem', sTable_Member),
                              MI('$Ext', sTable_MemberExt), MI('$ID', FRecordID)]);
    ListRelation1.Clear;

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if FieldByName('E_FID').AsString = FRecordID then
        begin
          nStr := FieldByName('E_Relation').AsString + ListRelation1.Delimiter +
                  FieldByName('E_BName').AsString + ' ' + ListRelation1.Delimiter +
                  FieldByName('E_BID').AsString;
        end else
        begin
          nStr := FieldByName('E_Relation').AsString + ListRelation1.Delimiter +
                  FieldByName('E_FName').AsString + ' ' + ListRelation1.Delimiter +
                  FieldByName('E_FID').AsString;
        end;

        ListRelation1.Items.Add(nStr);
        Next;
      end;
    end;

    ListRelation1.Tag := 27;
  end;

  if EditSP.Properties.Items.Count < 1 then
  begin
    nStr := 'Select a.P_Name,b.P_Name From %s a, %s b ' +
            'Where a.P_Plant=b.P_ID';
    nStr := Format(nStr, [sTable_Product, sTable_Plant]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := Fields[1].AsString + ' - ' + Fields[0].AsString;
        EditSP.Properties.Items.Add(nStr);
        Next;
      end;
    end;
  end;

  if (FRecordID <> '') and (ListXF.Tag <> 27) then
  begin
    nStr := 'Select * From %s Where F_MID=''%s'' Order By F_Date';
    nStr := Format(nStr, [sTable_JiFen, FRecordID]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := CombinStr([FieldByName('F_ID').AsString,
                FieldByName('F_Product').AsString + ' ',
                FieldByName('F_Money').AsString,
                DateTime2Str(FieldByName('F_Date').AsDateTime)], ListXF.Delimiter);
        ListXF.Items.Add(nStr);
        Next;
      end;
    end;

    ListXF.Tag := 27;
    LoadXFAll;
  end;
end;

//Desc: 载入消费合计
procedure TfFormMember.LoadXFAll;
var nStr: string;
begin
  if FRecordID = '' then
  begin
    EditHJ.Text := '无消费记录'; Exit;
  end;

  nStr := 'Select Sum(F_Money),Sum(F_JiFen) From %s ' +
          'Where F_MID=''%s''';
  nStr := Format(nStr, [sTable_JiFen, FRecordID]);

  with FDM.QueryTemp(nStr) do
  begin
    nStr := '总金额: %.2f元 总积分: %.2f';
    nStr := Format(nStr, [Fields[0].AsFloat, Fields[1].AsFloat]);
    EditHJ.Text := nStr;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 生成随机编号
procedure TfFormMember.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nChar: string;
    nIdx,nMid: integer;
begin
  nStr := FloatToStr(Now);
  nMid := Round(Length(nStr) / 2);

  for nIdx:=1 to nMid do
  begin
    nChar := nStr[nIdx];
    nStr[nIdx] := nStr[2 * nMid - nIdx];
    nStr[2 * nMid - nIdx] := nChar[1];
  end;

  EditID.Text := FPrefixID + Copy(nStr, 1, FIDLength - Length(FPrefixID));
end;

procedure TfFormMember.cxImage1Click(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    FileName := FImageFile;
    Title := '选择照片';
    Filter := '图片|*.bmp;*.jpg;*.png';

    if Execute then
    try
      cxImage1.Picture.LoadFromFile(FileName);
      FImageFile := FileName;
    except

    end;
    Free;
  end;
end;

//Desc: 添加信息项
procedure TfFormMember.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('请填写有效的信息项', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    FDM.ShowMsg('请填写有效的信息内容', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
  FDataInfoChanged := True;
end;

//Desc: 删除信息项
procedure TfFormMember.BtnDelClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);
  FDataInfoChanged := True;

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  FDM.ShowMsg('信息项已删除', sHint);
end;

//Desc: 查看信息
procedure TfFormMember.ListInfo1Click(Sender: TObject);
var nStr: string;
    nPos: integer;
begin
  if ListInfo1.ItemIndex > -1 then
  begin
    nStr := ListInfo1.Items[ListInfo1.ItemIndex];
    nPos := Pos(ListInfo1.Delimiter, nStr);

    InfoItems.Text := Copy(nStr, 1, nPos - 1);
    System.Delete(nStr, 1, nPos + Length(ListInfo1.Delimiter) - 1);
    EditInfo.Text := nStr;
  end;
end;

//Desc: 添加会员关系
procedure TfFormMember.BtnAdd2Click(Sender: TObject);
var nStr: string;
begin
  RelationName.Text := Trim(RelationName.Text);
  if RelationName.Text = '' then
  begin
    RelationName.SetFocus;
    FDM.ShowMsg('请填写有效的关系名称', sHint); Exit;
  end;

  RelationMember.Text := Trim(RelationMember.Text);
  if RelationMember.Text = '' then
  begin
    RelationMember.SetFocus;
    FDM.ShowMsg('请选择有效的关系会员', sHint); Exit;
  end;

  nStr := RelationMember.Text;
  System.Delete(nStr, 1, Pos('|', nStr));
  nStr := Trim(nStr); //会员名

  nStr := RelationName.Text + ListRelation1.Delimiter + nStr + ' ' +
          ListRelation1.Delimiter + GetCtrlData(RelationMember);

  ListRelation1.Items.Add(nStr);
  FDataRelationChanged := True;
end;

//Desc: 删除关系
procedure TfFormMember.BtnDel2Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListRelation1.ItemIndex < 0 then
  begin
    ListRelation1.SetFocus;
    FDM.ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListRelation1.ItemIndex;
  ListRelation1.Items.Delete(ListRelation1.ItemIndex);
  FDataRelationChanged := True;

  if nIdx >= ListRelation1.Count then Dec(nIdx);
  ListRelation1.ItemIndex := nIdx;
  FDM.ShowMsg('信息项已删除', sHint);
end;

//Desc: 查看关系
procedure TfFormMember.ListRelation1Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  nList := nil;
  if ListRelation1.ItemIndex > -1 then
  try
    nList := TStringList.Create;
    nStr := ListRelation1.Items[ListRelation1.ItemIndex];

    if SplitStr(nStr, nList, 3, ListRelation1.Delimiter) then
    begin
      RelationName.Text := nList[0];
      SetCtrlData(RelationMember, nList[2]);
    end;
  finally
    nList.Free;
  end;
end;

//Desc: 删除消费明细
procedure TfFormMember.BtnDel3Click(Sender: TObject);
var nStr: string;
begin
  if ListXF.ItemIndex < 0 then
  begin
    ListXF.SetFocus;
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := ListXF.Items[ListXF.ItemIndex];
  nStr := Copy(nStr, 1, Pos(ListXF.Delimiter, nStr) - 1);

  if IsNumber(nStr, False) then
  begin
    nStr := 'Delete From %s Where F_ID=' + nStr;
    nStr := Format(nStr, [sTable_JiFen]);
    FDM.ExecuteSQL(nStr);

    ListXF.DeleteSelected;
    LoadXFAll;
    ShowMsg('操作成功', sHint);  
  end else ShowMsg('该记录已无效', sHint);
end;

//Desc: 添加消费明细
procedure TfFormMember.BtnAdd3Click(Sender: TObject);
var nStr: string;
    nRule,nJF: Double;
begin
  EditSP.Text := Trim(EditSP.Text);
  if EditSP.Text = '' then
  begin
    EditSP.SetFocus;
    ShowMsg('请填写商品名称', sHint); Exit;
  end;

  if not IsNumber(EditMoney.Text, True) then
  begin
    EditMoney.SetFocus;
    ShowMsg('请填写有效的金额', sHint); Exit;
  end;

  nStr := 'Select Top 1 * From ' + sTable_JiFenRule;
  with FDM.QueryTemp(nStr) do
  if RecordCount < 1 then
  begin
    nStr := '该金额没有对应的积分标准,操作失败!!' + #13#10 +
            '请联系管理员,在后台添加相应标准.';
    ShowDlg(nStr, sHint, Handle); Exit;
  end else
  begin
    nRule := FieldByName('R_Money').AsFloat;
    if nRule <=0 then
    begin
      ShowMsg('无效的积分标准', sHint); Exit;
    end;

    nJF := FieldByName('R_JiFen').AsFloat;
    nJF := Trunc(StrToFloat(EditMoney.Text) / nRule) * nJF;
  end;


  nStr := 'Insert Into $TJF(F_MID,F_Product,F_Money,F_Rule,F_JiFen,F_Date) ' +
          'Values(''$ID'',''$Pro'', $Money, $Rule, $JF, ''$Date'')';
  nStr := MacroValue(nStr, [MI('$TJF', sTable_JiFen), MI('$ID', FRecordID),
          MI('$Pro', EditSP.Text), MI('$Money', EditMoney.Text),
          MI('$Rule', FloatToStr(nRule)), MI('$JF', FloatToStr(nJF)),
          MI('$Date', DateTime2Str(Now))]);
  FDM.ExecuteSQL(nStr);

  nStr := IntToStr(FDM.GetFieldMax(sTable_JiFen, 'F_ID'));
  nStr := CombinStr([nStr, EditSP.Text, EditMoney.Text, DateTime2Str(Now)],
          ListXF.Delimiter);
  ListXF.Items.Add(nStr);

  LoadXFAll;
  ShowMsg('操作成功', sHint);
end;

//------------------------------------------------------------------------------
//Desc: 验证数据
function TfFormMember.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '请填写有效的会员编号';
  end else

  if Sender = EditSex then
  begin
    Result := EditSex.ItemIndex > -1;
    nHint := '请选择有效的性别';
  end else

  if Sender = EditAge then
  begin
    Result := IsNumber(EditAge.Text, False);
    nHint := '请填写有效的年龄';
  end else

  if Sender = EditHeight then
  begin
    Result := IsNumber(EditHeight.Text, False);
    nHint := '请填写有效的身高';
  end else

  if Sender = EditWeight then
  begin
    Result := IsNumber(EditWeight.Text, False);
    nHint := '请填写有效的体重';
  end;
end;

//Desc: 验证数据是否正确
function TfFormMember.IsDataValid: Boolean;
var nStr: string;
    nCtrls: TList;
    nObj: TObject;
    i,nCount: integer;
begin
  Result := True;

  nCtrls := TList.Create;
  try
    EnumSubCtrlList(Self, nCtrls);
    nCount := nCtrls.Count - 1;

    for i:=0 to nCount do
    begin
      nObj := TObject(nCtrls[i]);
      if not OnVerifyCtrl(nObj, nStr) then
      begin
        if nObj is TWinControl then
          TWinControl(nObj).SetFocus;
        FDM.ShowMsg(nStr, sHint);
        Result := False; Exit;
      end;
    end;
  finally
    nCtrls.Free;
  end;
end;

//Desc: 保存数据
procedure TfFormMember.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i,nCount: integer;
    nStr,nSQL: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
    nStr := 'Select Count(*) From %s Where M_ID=''%s''';
    nStr := Format(nStr, [sTable_Member, EditID.Text]);
    //查询编号是否存在

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       FDM.ShowMsg('该编号的会员已经存在', sHint); Exit;
     end;

     nSQL := MakeSQLByForm(Self, sTable_Member, '', True, GetData);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'M_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Member, nStr, False, GetData);
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_Member, 'M_ID', EditID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //记录变更

    if FileExists(FImageFile) then
    begin
      nStr := 'Select M_ID,M_Image From %s Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, EditID.Text]);

      FDM.QueryTemp(nStr);
      FDM.SaveDBImage(FDM.SqlTemp, 'M_Image', FImageFile);
    end;

    if FDataInfoChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_MemberItem, FRecordID]);
        FDM.ExecuteSQL(nSQL);
      end;

      nList := TStringList.Create;
      nCount := ListInfo1.Items.Count - 1;

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      //xxxxx
      
      for i:=0 to nCount do
      begin
        nStr := ListInfo1.Items[i];
        if not SplitStr(nStr, nList, 2, ListInfo1.Delimiter) then Continue;

        nStr := Format(nSQL, [sTable_ExtInfo, sFlag_MemberItem,
                              EditID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nStr);
      end;

      if gSysDBType = dtAccess then
      begin
        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value, S_ExtField, S_ExtValue) ' +
                'Values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_ExtInfo, 'I_ItemID', EditID.Text,
                              'I_Group', sFlag_MemberItem]);
        FDM.ExecuteSQL(nSQL);
      end; //记录变更
    end;

    if FDataRelationChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where E_FID=''%s'' Or E_BID=''%s''';
        nSQL := Format(nSQL, [sTable_MemberExt, FRecordID, FRecordID]);
        FDM.ExecuteSQL(nSQL);
      end;

      if not Assigned(nList) then
        nList := TStringList.Create;
      nCount := ListRelation1.Items.Count - 1;

      nSQL := 'Insert Into %s(E_FID, E_Relation, E_BID) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      //xxxxx
      
      for i:=0 to nCount do
      begin
        nStr := ListRelation1.Items[i];
        if not SplitStr(nStr, nList, 3, ListRelation1.Delimiter) then Continue;

        nStr := Format(nSQL, [sTable_MemberExt, EditID.Text, nList[0], nList[2]]);
        FDM.ExecuteSQL(nStr);
      end;

      if gSysDBType = dtAccess then
      begin
        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
                'Values(''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_MemberExt, 'E_FID', EditID.Text]);
        FDM.ExecuteSQL(nSQL);
      end; //记录变更
    end;

    FreeAndNil(nList);
    FDM.ADOConn.CommitTrans;

    if FRecordID <> '' then
    begin
      FDataInfoChanged := False;
      FDataRelationChanged := False;
    end;

    FMemberChanged := True;
    FDM.ShowMsg('会员资料已成功保存', sHint);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('会员资料保存失败', '未知原因');
  end;
end;

end.
