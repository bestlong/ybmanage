{*******************************************************************************
  作者: dmzn@163.com 2009-7-8
  描述: 方案管理
*******************************************************************************}
unit UFormEditPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, UTransPanel, cxGraphics, dxLayoutControl,
  cxMCListBox, StdCtrls, cxPC, cxDropDownEdit, cxMaskEdit, cxButtonEdit,
  cxMemo, cxContainer, cxEdit, cxTextEdit, cxControls;

type
  TfFormEditPlan = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditName: TcxTextEdit;
    EditMemo: TcxMemo;
    EditID: TcxButtonEdit;
    EditPlan: TcxComboBox;
    EditSkin: TcxComboBox;
    EditDate: TcxTextEdit;
    EditMan: TcxTextEdit;
    wPage: TcxPageControl;
    cxSheet1: TcxTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    EditInfo: TcxTextEdit;
    InfoItems: TcxComboBox;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListInfo1: TcxMCListBox;
    cxSheet2: TcxTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    ProductItmes: TcxComboBox;
    BtnAdd2: TButton;
    BtnDel2: TButton;
    EditReason: TcxMemo;
    ListProduct1: TcxMCListBox;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item15: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    EditPlanList: TcxComboBox;
    dxLayout1Item1: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure ListProduct1Click(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure EditPlanListPropertiesChange(Sender: TObject);
  private
    { Private declarations }
    FMemberID: string;
    //会员编号
    FSkinType: string;
    //皮肤标识
    FDisplayRect: TRect;
    //显示区域
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    FDataInfoChanged,FDataProductChanged: Boolean;
    //数据变动
    procedure InitFormData(const nID: string);
    //初始化数据
    function SaveData: Boolean;
    //保存数据
  public
    { Public declarations }
    FDataChanged: Boolean;
    //数据变动
  end;
          
function ShowPlanEditForm(const nMemberID,nSkinType: string; const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, USysGrid, USysDB, USysConst,
  USysFun, USysGobal;
  
var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: 会员号;皮肤标识;显示区域
//Desc: 在nRect区域显示方案管理窗口
function ShowPlanEditForm(const nMemberID,nSkinType: string; const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormEditPlan.Create(gForm);
  Result := gForm;

  with TfFormEditPlan(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FMemberID := nMemberID;
    FSkinType := nSkinType;
    FDisplayRect := nRect;

    FDataChanged := False;
    InitFormData('');
    if not Showing then Show;
  end;
end;

procedure TfFormEditPlan.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  inherited;
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadMCListBoxConfig(Name, ListInfo1, nIni);
    LoadMCListBoxConfig(Name, ListProduct1, nIni);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'FA');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_Plan); 
end;

procedure TfFormEditPlan.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  inherited;
  if Action <> caFree then Exit;

  gForm := nil;
  ReleaseCtrlData(Self);
  if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
  
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveMCListBoxConfig(Name, ListInfo1, nIni);
    SaveMCListBoxConfig(Name, ListProduct1, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormEditPlan.BtnExitClick(Sender: TObject);
begin
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormEditPlan.InitFormData(const nID: string);
var nStr: string;
begin
  EditMan.Text := gSysParam.FUserName;
  EditDate.Text := DateTime2Str(Now);

  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_PlanItem)]);
    //数据字典中护理方案信息项

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

  if EditSkin.Properties.Items.Count < 1 then
  begin
    nStr := 'T_ID=Select T_ID,T_Name From ' + sTable_SkinType;
    FDM.FillStringsData(EditSkin.Properties.Items, nStr, -1, '、');

    AdjustCXComboBoxItem(EditSkin, False);
    SetCtrlData(EditSkin, FSkinType);
  end;

  if EditPlan.Properties.Items.Count < 1 then
  begin
    nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_PlanItem]);

    FDM.FillStringsData(EditPlan.Properties.Items, nStr, -1, '、');
    AdjustCXComboBoxItem(EditPlan, False);
  end;

  if EditPlanList.Properties.Items.Count < 1 then
  begin
    nStr := 'P_ID=Select P_ID,P_Name From %s';
    nStr := Format(nStr, [sTable_Plan]);

    FDM.FillStringsData(EditPlanList.Properties.Items, nStr, -1, '、');
    AdjustStringsItem(EditPlanList.Properties.Items, False);
  end;

  if ProductItmes.Properties.Items.Count < 1 then
  begin
    nStr := 'P_ID=Select P_ID, P_Name, ' +
            ' (Select B_Text From $Base a Where a.B_ID=t.P_Type) as P_TName,' +
            ' (Select P_Name From $Plant b Where b.P_ID=t.P_Plant) as P_PName ' +
            'From $Pro t';

    nStr := MacroValue(nStr, [MI('$Base', sTable_BaseInfo),MI('$Plant', sTable_Plant),
                              MI('$Pro', sTable_Product)]);
    FDM.FillStringsData(ProductItmes.Properties.Items, nStr);
    AdjustCXComboBoxItem(ProductItmes, False);
  end;

  if nID <> '' then
  begin
    FDataInfoChanged := False;
    FDataProductChanged := False;

    nStr := 'Select * From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Plan, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '');

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_PlanItem), MI('$ID', nID)]);
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

    nStr := 'Select E_Product, E_Memo, ' +
            ' (Select P_Name From $Pro Where P_ID=E_Product) as E_PName ' +
            'From $Plan Where E_Plan=''$ID''';

    nStr := MacroValue(nStr, [MI('$Pro', sTable_Product),
                              MI('$Plan', sTable_PlanExt), MI('$ID', nID)]);
    ListProduct1.Clear;

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := FieldByName('E_Product').AsString + ListInfo1.Delimiter +
                FieldByName('E_PName').AsString + ListInfo1.Delimiter +
                FieldByName('E_Memo').AsString + ' ';

        ListProduct1.Items.Add(nStr);
        Next;
      end;
    end;
  end;
end;

//Desc: 添加信息项
procedure TfFormEditPlan.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('请填写 或 选择有效的信息项', sHint); Exit;
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
procedure TfFormEditPlan.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
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
procedure TfFormEditPlan.ListInfo1Click(Sender: TObject);
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

//Desc: 增加产品
procedure TfFormEditPlan.BtnAdd2Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if ProductItmes.ItemIndex < 0 then
  begin
    ProductItmes.SetFocus;
    FDM.ShowMsg('请选择有效的产品', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    nStr := ProductItmes.Properties.Items[ProductItmes.ItemIndex];
    if not SplitStr(nStr, nList, 4, '|') then
    begin
      FDM.ShowMsg('无效的产品记录', sHint); Exit;
    end;

    nStr := GetCtrlData(ProductItmes) + ListProduct1.Delimiter +
            nList[1] + ListProduct1.Delimiter + EditReason.Text + ' ';
    ListProduct1.Items.Add(nStr);
    FDataProductChanged := True;
  finally
    nList.Free;
  end;
end;

//Desc: 删除产品
procedure TfFormEditPlan.BtnDel2Click(Sender: TObject);
var nIdx: integer;
begin
  if ListProduct1.ItemIndex < 0 then
  begin
    FDM.ShowMsg('请选择要删除的产品', sHint); Exit;
  end;

  nIdx := ListProduct1.ItemIndex;
  ListProduct1.Items.Delete(ListProduct1.ItemIndex);
  FDataProductChanged := True;

  if nIdx >= ListProduct1.Count then Dec(nIdx);
  ListProduct1.ItemIndex := nIdx;
  FDM.ShowMsg('已成功删除', sHint);
end;

//Desc: 查看明细
procedure TfFormEditPlan.ListProduct1Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  nList := nil;
  if ListProduct1.ItemIndex > -1 then
  try
    nList := TStringList.Create;
    nStr := ListProduct1.Items[ListProduct1.ItemIndex];

    if SplitStr(nStr, nList, 3, ListProduct1.Delimiter) then
    begin
      SetCtrlData(ProductItmes, nList[0]);
      EditReason.Text := Trim(nList[2]);
    end;
  finally
    if Assigned(nList) then nList.Free;
  end;
end;

//Desc: 随机编号
procedure TfFormEditPlan.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditMan.Text := gSysParam.FUserID;
  EditDate.Text := DateTime2Str(Now);
  SetCtrlData(EditSkin, FSkinType);
  EditID.Text := FDM.GetRandomID(FPrefixID, FIDLength);
end;

procedure TfFormEditPlan.EditPlanListPropertiesChange(Sender: TObject);
begin
  InitFormData(GetCtrlData(EditPlanList));
end;

//------------------------------------------------------------------------------
//Desc: 保存数据
function TfFormEditPlan.SaveData: Boolean;
var nIsNew: Boolean;
    nList: TStrings;
    i,nCount: integer;
    nStr,nSQL: string;
begin
  Result := True;
  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Plan, EditID.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if not (gSysParam.FIsAdmin or
       (FieldByName('P_Man').AsString = gSysParam.FUserName)) then Exit;

    if EditID.Text <> GetCtrlData(EditPlanList) then
    begin
      EditID.SetFocus;
      FDM.ShowMsg('该编号已经被使用', sHint); Exit;
    end else nIsNew := False;
  end else
  begin
    nIsNew := True;
    FDataInfoChanged := True;
    FDataProductChanged := True;
    
    EditMan.Text := gSysParam.FUserID;
    EditDate.Text := DateTime2Str(Now);
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    nStr := 'P_ID=''' + EditID.Text + '''';
    nSQL := MakeSQLByForm(Self, sTable_Plan, nStr, nIsNew, nil);
    FDM.ExecuteSQL(nSQL);

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_Plan, 'P_ID', EditID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //记录变更

    if FDataInfoChanged then
    begin
      if not nIsNew then
      begin
        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_PlanItem, EditID.Text]);
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

        nStr := Format(nSQL, [sTable_ExtInfo, sFlag_PlanItem,
                              EditID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nStr);
      end;

      if gSysDBType = dtAccess then
      begin
        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value, S_ExtField, S_ExtValue) ' +
                'Values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_ExtInfo, 'I_ItemID', EditID.Text,
                              'I_Group', sFlag_PlanItem]);
        FDM.ExecuteSQL(nSQL);
      end; //记录变更
    end;

    if FDataProductChanged then
    begin
      if not nIsNew then
      begin
        nSQL := 'Delete From %s Where E_Plan=''%s''';
        nSQL := Format(nSQL, [sTable_PlanExt, EditID.Text]);
        FDM.ExecuteSQL(nSQL);
      end;

      if not Assigned(nList) then
        nList := TStringList.Create;
      nCount := ListProduct1.Items.Count - 1;

      nSQL := 'Insert Into %s(E_Plan, E_Product, E_Memo) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      //xxxxx
      
      for i:=0 to nCount do
      begin
        nStr := ListProduct1.Items[i];
        if not SplitStr(nStr, nList, 3, ListProduct1.Delimiter) then Continue;        

        nStr := Format(nSQL, [sTable_PlanExt, EditID.Text, nList[0], nList[2]]);
        FDM.ExecuteSQL(nStr);
      end;

      if gSysDBType = dtAccess then
      begin
        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
                'Values(''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_PlanExt, 'E_Plan', EditID.Text]);
        FDM.ExecuteSQL(nSQL);
      end; //记录变更
    end;

    if gSysParam.FGroupID = IntToStr(cBeauticianGroup) then
         nStr := gSysParam.FBeautyID
    else nStr := gSysParam.FUserID;

    nSQL := 'Insert Into %s(U_PID, U_MID, U_BID, U_Date) ' +
            ' Values(''%s'', ''%s'', ''%s'', ''%s'')';
    nSQL := Format(nSQL, [sTable_PlanUsed, EditID.Text, FMemberID, nStr, DateTime2Str(Now)]);
    FDM.ExecuteSQL(nSQL);

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_PlanUsed, 'U_PID', EditID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //记录变更

    FreeAndNil(nList);
    FDM.ADOConn.CommitTrans;
    FDM.ShowMsg('数据已保存', sHint);
  except
    Result := False;
    FreeAndNil(nList);
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('保存分析结果失败', '未知原因');
  end;
end;

//Desc: 保存
procedure TfFormEditPlan.BtnOKClick(Sender: TObject);
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    FDM.ShowMsg('请填写有效的方案编号', sHint); Exit;
  end;

  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    FDM.ShowMsg('请填写有效的方案名称', sHint); Exit;
  end;

  if SaveData then
  begin
    FDataChanged := True;
    CloseForm;
  end;
end;

end.
