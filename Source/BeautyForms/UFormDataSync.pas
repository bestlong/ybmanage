{*******************************************************************************
  作者: dmzn@163.com 2009-7-11
  描述: 数据同步
*******************************************************************************}
unit UFormDataSync;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxGraphics, dxLayoutControl, StdCtrls,
  cxProgressBar, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxCheckComboBox,
  cxContainer, cxEdit, cxCheckBox, cxRadioGroup, cxControls, UTransPanel,
  DB, ADODB;

type
  TfFormDataSync = class(TfBgFormBase)
    dxLayoutControl1: TdxLayoutControl;
    RadioUp: TcxRadioButton;
    RadioDown: TcxRadioButton;
    CheckFixed: TcxCheckBox;
    EditMember: TcxCheckComboBox;
    ProcessTotal: TcxProgressBar;
    ProcessNow: TcxProgressBar;
    BtnExit: TButton;
    BtnOK: TButton;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayoutControl1Item2: TdxLayoutItem;
    dxLayoutItem1: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutControl1Item3: TdxLayoutItem;
    dxLayoutControl1Item4: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayoutControl1Item5: TdxLayoutItem;
    dxLayoutControl1Item6: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    dxLayoutControl1Item8: TdxLayoutItem;
    dxLayoutControl1Item7: TdxLayoutItem;
    LocalQuery: TADOQuery;
    ConnLocal: TADOConnection;
    LocalCommand: TADOQuery;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure CheckFixedPropertiesChange(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FNoNeedSync: TStrings;
    //不需要同步
    FNoNeedUpdate: TStrings;
    //不需要上传
    FNeedModified: TStrings;
    //改动后同步
    procedure InitFormData;
    //初始化界面
    function ExchangeQuery(const nQ: TADOQuery): TADOQuery;
    //切换查询组件
    function SyncTableModified(const nTable: string; nS,nD: TADOQuery): Boolean;
    function SyncTableModified2(const nTable: string; nS,nD: TADOQuery): Boolean;
    function SyncTableData(const nTable: string; nS,nD: TADOQuery): Boolean;
    function SyncTable(const nTable: string): Boolean;
    function SyncSyncItem: Boolean;
    //同步表
  public
    { Public declarations }
  end;

function ShowDataSyncForm(const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, UMgrControl, USysDB, USysGrid,
  USysConst, USysGobal, UFormConn;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-6-30
//Parm: 显示区域
//Desc: 在nRect中间位置显示数据同步窗口
function ShowDataSyncForm(const nRect: TRect): TForm;
begin
  Result := nil;
  if Assigned(gForm) then Exit;
  
  gForm := TfFormDataSync.Create(Application);
  with TfFormDataSync(gForm) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    InitFormData;
    ShowModal;
    Free;
  end;
end;

procedure TfFormDataSync.FormCreate(Sender: TObject);
begin
  inherited;
  FNoNeedSync := TStringList.Create;
  FNoNeedUpdate := TStringList.Create;
  FNeedModified := TStringList.Create;
end;

procedure TfFormDataSync.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited; 
  if Action = caFree then
  begin
    gForm := nil;
    FNoNeedSync.Free;
    FNoNeedUpdate.Free;
    FNeedModified.Free;
    
    ReleaseCtrlData(Self);
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
  end;
end;

procedure TfFormDataSync.BtnExitClick(Sender: TObject);
begin
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面
procedure TfFormDataSync.InitFormData;
begin
  RadioDown.Checked := True;
  ProcessTotal.Position := 0;
  ProcessNow.Position := 0;

  try
    ConnLocal.Connected := False;
    ConnLocal.ConnectionString := BuildConnectDBStr(nil, '单机');
    ConnLocal.Connected := True;
  except
    //ignor any error
  end;

  BtnOK.Enabled := ConnLocal.Connected;
  if BtnOK.Enabled then
  begin
    FNoNeedSync.Clear;
    FNoNeedSync.Add(sTable_SysLog);
    FNoNeedSync.Add(sTable_SyncItem);
    //不需要同步的表

    FNoNeedUpdate.Clear;
    FNoNeedUpdate.Add(sTable_Group);
    FNoNeedUpdate.Add(sTable_User);
    FNoNeedUpdate.Add(sTable_Menu);
    FNoNeedUpdate.Add(sTable_Popedom);
    FNoNeedUpdate.Add(sTable_PopItem);
    FNoNeedUpdate.Add(sTable_Entity);
    FNoNeedUpdate.Add(sTable_DictItem);

    FNoNeedUpdate.Add(sTable_SysDict);
    FNoNeedUpdate.Add(sTable_BaseInfo);

    FNoNeedUpdate.Add(sTable_MemberType);
    FNoNeedUpdate.Add(sTable_BeautiType);
    FNoNeedUpdate.Add(sTable_Remind);

    FNoNeedUpdate.Add(sTable_Beautician);
    FNoNeedUpdate.Add(sTable_BeauticianExt);
    FNoNeedUpdate.Add(sTable_ProductType);
    FNoNeedUpdate.Add(sTable_Product);

    FNoNeedUpdate.Add(sTable_Plant);
    FNoNeedUpdate.Add(sTable_Provider);
    FNoNeedUpdate.Add(sTable_Hardware);
    //不需要上传的表

    FNeedModified.Clear;
    FNeedModified.Add(sTable_ExtInfo);
    FNeedModified.Add(sTable_Member);
    FNeedModified.Add(sTable_MemberExt);
    FNeedModified.Add(sTable_SkinType);
    FNeedModified.Add(sTable_Plan);
    FNeedModified.Add(sTable_PlanExt);
    FNeedModified.Add(sTable_PlanUsed);
    FNeedModified.Add(sTable_ProductUsed);
    FNeedModified.Add(sTable_PickImage);
    //改动后才可上传的表    
  end else FDM.ShowMsg('无法连接本机数据库', sHint);
end;

//Desc: 载入会员
procedure TfFormDataSync.CheckFixedPropertiesChange(Sender: TObject);
var nStr: string;
    nQuery: TADOQuery;
begin
  if CheckFixed.Checked then
   if (RadioDown.Checked  and (EditMember.Tag <> 10)) or
      (RadioUp.Checked and (EditMember.Tag <> 20)) then
  begin
    if RadioDown.Checked then
    begin
      EditMember.Tag := 10;
      nQuery := FDM.SqlTemp;
    end else
    if RadioUp.Checked then
    begin
      EditMember.Tag := 20;
      nQuery := LocalQuery;
    end else nQuery := nil;

    EditMember.Properties.Items.Clear;
    nStr := 'Select M_ID,M_Name From ' + sTable_Member;

    FDM.QueryData(nQuery, nStr);
    if nQuery.RecordCount > 0 then
    begin
      nQuery.First;

      while not nQuery.Eof do
      with EditMember.Properties.Items.Add do
      begin
        Description := nQuery.Fields[0].AsString + '、' + nQuery.Fields[1].AsString;
        ShortDescription := nQuery.Fields[1].AsString;
        nQuery.Next;
      end;
    end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 开始同步
procedure TfFormDataSync.BtnOKClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
    i,nCount: integer;
begin
  if RadioDown.Checked then
  begin
    nStr := '该操作会覆盖本机中的所有数据,没有上传的数据将丢失且不可恢复!!' + #13#10 +
            '确定要下载吗?';
  end else

  if RadioUp.Checked then
  begin
    nStr := '该操作会更新服务器的数据,只有本机中最新的数据才会被上传!!' + #13#10 +
            '确定要上传吗?';
  end;

  if not QueryDlg(nStr, sAsk, Handle) then Exit;
  nList := TStringList.Create;
  try
    BtnOK.Enabled := False;
    BtnExit.Enabled := False;

    if RadioUp.Checked and (not SyncSyncItem) then
    begin
      BtnOK.Enabled := True;
      ShowDlg('无法获取需要更新的数据列表!!!', sError); Exit;
    end;

    ProcessTotal.Position := 0;
    ProcessTotal.Properties.Min := 0;

    FDM.ADOConn.GetTableNames(nList);
    ProcessTotal.Properties.Max := nList.Count;
    nCount := nList.Count - 1;
    
    for i:=0 to nCount do
    begin
      if not SyncTable(nList[i]) then
      begin
        BtnOK.Enabled := True; Exit;
      end;
      ProcessTotal.Position := i + 1;
    end;

    ShowDlg('数据已同步成功!!!', sHint, Handle);
  finally
    nlist.Free;
    BtnExit.Enabled := True;
  end;
end;

//Desc: 同步表明为nTable的数据
function TfFormDataSync.SyncTable(const nTable: string): Boolean;
var nStr: string;
    nS,nD: TADOQuery;
    nConn: TADOConnection;
begin
  nConn := nil;
  Result := True;
  try
    if FNoNeedSync.IndexOf(nTable) > -1 then Exit;
    //不需要同步的表
    if RadioUp.Checked and (FNoNeedUpdate.IndexOf(nTable) > -1) then Exit;
    //不需要上传的表
    
    if RadioDown.Checked then
    begin
      nConn := ConnLocal;
      nS := FDM.SqlTemp;
      nD := LocalQuery;
    end else

    if RadioUp.Checked then
    begin
      nConn := FDM.ADOConn;
      nS := LocalQuery;
      nD := FDM.SqlTemp;
    end else Exit;

    nConn.BeginTrans;
    if RadioDown.Checked then
    begin
      Result := SyncTableData(nTable, nS, nD);
    end else

    if RadioUp.Checked then
    begin
      if FNeedModified.IndexOf(nTable) > -1 then
           Result := SyncTableModified(nTable, nS, nD)
      else Result := SyncTableData(nTable, nS, nD);
    end;
    nConn.CommitTrans;
  except
    Result := False;
    if Assigned(nConn) and nConn.InTransaction then nConn.RollbackTrans;
  end;

  if not Result then
  begin
    nStr := '数据表[ %s ]同步失败!!';
    nStr := Format(nStr, [nTable]);
    ShowDlg(nStr, sHint, Handle);
  end;
end;

//------------------------------------------------------------------------------    
//Date: 2009-7-12
//Parm: 查询组件
//Desc: 切换nQ对应的写操作组件
function TfFormDataSync.ExchangeQuery(const nQ: TADOQuery): TADOQuery;
begin
  if nQ = LocalQuery then
    Result := LocalCommand else
  if nQ = FDM.SqlTemp then
    Result := FDM.Command else Result := nil;
end;

//Desc: 使用nQuery执行nSQL语句
function MyExecuteSQL(const nSQL: string; const nQuery: TADOQuery): integer;
begin
  nQuery.Close;
  nQuery.SQL.Text := nSQL;
  Result := nQuery.ExecSQL;
end;

//Desc: 使用nQuery执行nSQL语句
function MyQuerySQL(const nSQL: string; const nQuery: TADOQuery): integer;
begin
  nQuery.Close;
  nQuery.SQL.Text := nSQL;
  nQuery.Open;
  Result := nQuery.RecordCount;
end;

//Desc: 将nS的当前数据移动到nD中
function MoveDataToDS(const nS,nD: TADOQuery; nNew: Boolean = True): Boolean;
var nField: TField;
    i,nCount: integer;
begin
  Result := True;
  try
    if nNew then
         nD.Append
    else nD.Edit;

    nCount := nS.FieldCount - 1;
    for i:=0 to nCount do
    begin
      nField := nD.FindField(nS.Fields[i].FieldName);
      if Assigned(nField) and (not (nField.DataType in [ftAutoInc])) then
        nField.Value := nS.Fields[i].Value;
    end;

    nD.Post;
  except
    nD.Cancel;
    Result := False;
  end;
end;

//Desc: 向服务器同步SyncItem表
function TfFormDataSync.SyncSyncItem: Boolean;
begin
  try
    FDM.ADOConn.BeginTrans;
    Result := SyncTableData(sTable_SyncItem, LocalQuery, FDM.SqlTemp);
    FDM.ADOConn.CommitTrans;
  except
    Result := False;
    if FDM.ADOConn.InTransaction then FDM.ADOConn.RollbackTrans;
  end;
end;

//Date: 2009-7-11
//Parm: 表名;源;目标
//Desc: 在nS,nD中同步nTable表的数据
function TfFormDataSync.SyncTableData(const nTable: string; nS, nD: TADOQuery): Boolean;
var nStr: string;
begin
  Result := True;
  nStr := 'Delete From ' + nTable;
  MyExecuteSQL(nStr, ExchangeQuery(nD));

  nStr := 'Select * From ' + nTable;
  MyQuerySQL(nStr, nD);
  MyQuerySQL(nStr, nS);

  if nS.RecordCount > 0 then
    ProcessNow.Properties.Max := nS.RecordCount;
  ProcessNow.Position := 0;

  if nS.RecordCount > 0 then
  begin
    nS.First;

    while not nS.Eof do
    begin
      Result := MoveDataToDS(nS, nD);
      if not Result then Break;

      ProcessNow.Position := ProcessNow.Position + 1;
      Application.ProcessMessages;
      nS.Next;
    end;
  end;
end;

//Date: 2009-7-11
//Parm: 表名;源;目标
//Desc: 在nS,nD中同步已修改表nTable
function TfFormDataSync.SyncTableModified2(const nTable: string; nS,
  nD: TADOQuery): Boolean;
var nStr,nID,nExt: string;
begin
  Result := True;
  nStr := 'Select Distinct S_Field,S_ExtField,S_ExtValue From %s Where S_Table=''%s''';

  nStr := Format(nStr, [sTable_SyncItem, nTable]);
  if MyQuerySQL(nStr, nS) < 1 then Exit;

  nID := nS.Fields[0].AsString;
  nExt := nS.Fields[1].AsString;
  if nExt <> '' then
    nExt := nExt + '=''' + nS.Fields[2].AsString + '''';
  //获取需更新表的字段名

  nStr := 'Delete From $T ' +
          'Where $Key In (Select S_Value From $Sync Where S_Table=''$T'')';
  if nExt <> '' then nStr := nStr + ' And ' + nExt;

  nStr := MacroValue(nStr, [MI('$T', nTable), MI('$Key', nID), MI('$Sync', sTable_SyncItem)]);
  MyExecuteSQL(nStr, ExchangeQuery(nD));
  //目标删除需更新的数据

  nStr := 'Select * From $T ' +
          'Where $Key In (Select S_Value From $Sync Where S_Table=''$T'')';
  if nExt <> '' then nStr := nStr + ' And ' + nExt;
  
  nStr := MacroValue(nStr, [MI('$T', nTable), MI('$Key', nID), MI('$Sync', sTable_SyncItem)]);
  if MyQuerySQL(nStr, nS) < 1 then Exit;
  //查询是否有可更新数据

  nStr := 'Select * From %s Where 1=0';
  nStr := Format(nStr, [nTable]);
  MyQuerySQL(nStr, nD);
  //目标打开

  if nS.RecordCount > 0 then
    ProcessNow.Properties.Max := nS.RecordCount;
  ProcessNow.Position := 0;

  if nS.RecordCount > 0 then
  begin
    nS.First;

    while not nS.Eof do
    begin
      Result := MoveDataToDS(nS, nD);
      if not Result then Break;

      ProcessNow.Position := ProcessNow.Position + 1;
      Application.ProcessMessages;
      nS.Next;
    end;
  end;
end;

//Date: 2009-7-11
//Parm: 表名;源;目标
//Desc: 在nS,nD中同步已修改表nTable
function TfFormDataSync.SyncTableModified(const nTable: string; nS,nD: TADOQuery): Boolean;
var nStr: string;
begin
  Result := SyncTableModified2(nTable, nS, nD);
  if Result then
  begin
    nStr := 'Delete From %s Where S_Table=''%s''';
    nStr := Format(nStr, [sTable_SyncItem, nTable]);
    MyExecuteSQL(nStr, ExchangeQuery(nS));
    MyExecuteSQL(nStr, ExchangeQuery(nD));
  end;
end;

end.
