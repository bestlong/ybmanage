{*******************************************************************************
  作者: dmzn@163.com 2009-7-29
  描述: 浏览方案
*******************************************************************************}
unit UFormPlanView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UBgFormBase, ComCtrls, dxLayoutControl, cxControls,
  cxContainer, cxTreeView, StdCtrls, cxRadioGroup, UTransPanel, cxMemo,
  UImageViewer, cxEdit, cxTextEdit, ImgList, cxGraphics, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxPC;

type
  TfFormPlanView = class(TfBgFormBase)
    TPanel: TZnTransPanel;
    BPanel1: TZnTransPanel;
    BtnExit: TButton;
    Radio1: TcxRadioButton;
    Radio2: TcxRadioButton;
    PlanTree1: TcxTreeView;
    wPanel1: TZnTransPanel;
    ImageList1: TImageList;
    Radio3: TcxRadioButton;
    dxLayout1: TdxLayoutControl;
    EditName: TcxTextEdit;
    EditMemo: TcxMemo;
    EditDate: TcxTextEdit;
    EditMan: TcxTextEdit;
    wPage: TcxPageControl;
    cxSheet1: TcxTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    EditInfo: TcxTextEdit;
    ListInfo1: TcxMCListBox;
    InfoItems: TcxTextEdit;
    cxSheet2: TcxTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    EditReason: TcxMemo;
    ListProduct1: TcxMCListBox;
    ProductItmes: TcxComboBox;
    EditType: TcxTextEdit;
    EditID: TcxTextEdit;
    EditSkin: TcxButtonEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item15: TdxLayoutItem;
    BtnDel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlanTree1Deletion(Sender: TObject; Node: TTreeNode);
    procedure Radio1Click(Sender: TObject);
    procedure PlanTree1Change(Sender: TObject; Node: TTreeNode);
    procedure EditSkinPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ListInfo1Click(Sender: TObject);
    procedure ListProduct1Click(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    FMemberID: string;
    //会员编号
    FDisplayRect: TRect;
    //显示区域
    FPlanList: TList;
    //方案列表
    FSkinType: string;
    //记录标识
    FNeedReleaseData: Boolean;
    //数据标记
    FOldCloseForm: TNotifyEvent;
    //旧有事件
    procedure InitFormData;
    //初始数据
    procedure ClearPlanList(const nFree: Boolean);
    //释放资源
    function BuildBaseInfoTree(const nGroup: string): Boolean;
    //构建资料树
    procedure OnCloseActiveForm(Sender: TObject);
    //活动窗口关闭
    procedure LoadPlanByDate;
    procedure LoadPlanByType;
    procedure LoadPlanBySkin;
    procedure LoadPlanFromDB;
    //读取方案列表
    function SetData(Sender: TObject; const nData: string): Boolean;
    procedure LoadPlanInfo(const nID: string);
    //载入方案信息
  public
    { Public declarations }
  end;

function ShowPlanViewForm(const nRect: TRect; const nMemberID: string=''): TForm;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, USysGrid, USysDB, USysConst,
  USysGobal, USysDataFun, UFormSkinType;

type
  PPlanItem = ^TPlanItem;
  TPlanItem = record
    FID: string;
    FName: string;
    FDate: string;
    FSkin: string;
    FType: integer;
  end;

const
  cImageGroup      = 0;
  cImagePlan       = 1;
  cImageSelected   = 2;
  cMaxHeight       = 445;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: 显示区域
//Desc: 在nRect区域显示方案浏览窗口
function ShowPlanViewForm(const nRect: TRect; const nMemberID: string=''): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormPlanView.Create(Application);
  Result := gForm;

  with TfFormPlanView(Result) do
  begin
    FMemberID := nMemberID;
    FDisplayRect := nRect;

    InitFormData;
    if not Showing then Show;
  end;
end;

procedure TfFormPlanView.FormCreate(Sender: TObject);
begin
  WindowState := wsMaximized;
  DoubleBuffered := True;
  wPage.ActivePageIndex := 0;

  FPlanList := TList.Create;
  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;
  inherited;

  LoadMCListBoxConfig(Name, ListInfo1);
  LoadMCListBoxConfig(Name, ListProduct1);
  ResetHintAllCtrl(Self, 'T', sTable_Plan);
end;

procedure TfFormPlanView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    SaveMCListBoxConfig(Name, ListInfo1);
    SaveMCListBoxConfig(Name, ListProduct1);
    
    gForm := nil;
    ClearPlanList(True);
    ReleaseCtrlData(Self);
    
    gOnCloseActiveForm := FOldCloseForm;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);
  end;
end;

procedure TfFormPlanView.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

procedure TfFormPlanView.OnCloseActiveForm(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
procedure TfFormPlanView.InitFormData;
begin
  FNeedReleaseData := False;
  LoadPlanFromDB;
  
  if Radio1.Checked then LoadPlanByDate else
  if Radio2.Checked then LoadPlanBySkin else
  if Radio3.Checked then LoadPlanByType;
end;

//Desc: 释放方案列表
procedure TfFormPlanView.ClearPlanList(const nFree: Boolean);
var nIdx: integer;
begin
  for nIdx:=FPlanList.Count - 1 downto 0 do
  begin
    Dispose(PPlanItem(FPlanList[nIdx]));
    FPlanList.Delete(nIdx);
  end;

  if nFree then FPlanList.Free;
end;

//Desc: 从数据库读取
procedure TfFormPlanView.LoadPlanFromDB;
var nStr: string;
    nPlan: PPlanItem;
begin
  if FMemberID = '' then
  begin
    nStr := 'Select * From %s Order By P_Date';
    nStr := Format(nStr, [sTable_Plan]);
  end else
  begin
    nStr := 'Select * From $T ' +
          'Where P_ID In (Select U_PID From $Used Where U_MID=''$ID'') ' +
          'Order By P_Date';

    nStr := MacroValue(nStr, [MI('$T', sTable_Plan), MI('$Used', sTable_PlanUsed),
                              MI('$ID', FMemberID)]);
  end;

  ClearPlanList(False);
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      New(nPlan);
      FPlanList.Add(nPlan);

      nPlan.FID := FieldByName('P_ID').AsString;
      nPlan.FName := FieldByName('P_Name').AsString;
      nPlan.FDate := Date2Str(FieldByName('P_Date').AsDateTime);
      nPlan.FType := FieldByName('P_PlanType').AsInteger;
      nPlan.FSkin := FieldByName('P_SkinType').AsString;

      Next;
    end;
  end;
end;

//Desc: 按日期查看 
procedure TfFormPlanView.LoadPlanByDate;
var nStr: string;
    nPlan: PPlanItem;
    nIdx,nCount: integer;
begin
  PlanTree1.Items.BeginUpdate;
  try
    FNeedReleaseData := False;
    PlanTree1.Items.Clear;
    nCount := FPlanList.Count - 1;

    for nIdx:=0 to nCount do
    begin
      nPlan := FPlanList[nIdx];
      nStr := '[%s] %s';
      nStr := Format(nStr, [nPlan.FDate, nPlan.FName]);

      with PlanTree1.Items.AddChild(nil, nStr) do
      begin
        ImageIndex := cImagePlan;
        SelectedIndex := cImageSelected;
        Data := nPlan;
      end;
    end;
  finally
    PlanTree1.Items.EndUpdate;
  end;
end;

//Desc: 构建基本资料表中分为nGroup的节点树
function TfFormPlanView.BuildBaseInfoTree(const nGroup: string): Boolean;
var nNode: TTreeNode;
    nInfoList: TList;
    i,nCount: integer;
    nData: PBaseInfoData;

    //Desc: 依据nSub构建nPNode的子节点
    procedure BuildSubBaseInfoTree(const nPNode: TTreeNode; const nSub: TList);
    var m,nLen: integer;
        nSNode: TTreeNode;
        nSData: PBaseInfoData;
    begin
      nLen := nSub.Count - 1;
      for m:=0 to nLen do
      begin
        nSData := nSub[m];
        nSNode := PlanTree1.Items.AddChild(nPNode, nSData.FText);
        nSNode.Data := nSData;

        if Assigned(nSData.FSub) then
        begin
          nSNode.ImageIndex := cImageGroup;
          BuildSubBaseInfoTree(nSNode, nSData.FSub);
        end else nSNode.ImageIndex := cImageGroup;

        nSNode.SelectedIndex := cImageGroup;
      end;
    end;
begin
  Result := False;
  nInfoList := TList.Create;

  PlanTree1.Items.BeginUpdate;
  try
    PlanTree1.Items.Clear;
    if not LoadBaseInfoList(nInfoList, nGroup) then Exit;

    FNeedReleaseData := True;
    nCount := nInfoList.Count - 1;

    for i:=0 to nCount do
    begin
      nData := nInfoList[i];
      nNode := PlanTree1.Items.AddChild(nil, nData.FText);
      nNode.Data := nData;

      if Assigned(nData.FSub) then
      begin
        nNode.ImageIndex := cImageGroup;
        BuildSubBaseInfoTree(nNode, nData.FSub);
      end else nNode.ImageIndex := cImageGroup;

      nNode.SelectedIndex := cImageGroup;
    end;
  finally
    nInfoList.Free;
    PlanTree1.FullExpand;
    
    PlanTree1.Items.EndUpdate;
    Result := PlanTree1.Items.Count > 0;
  end;
end;

//Desc: 按类型查看
procedure TfFormPlanView.LoadPlanByType;
var nNode: TTreeNode;

    //Desc: 添加nNode的子节点
    procedure AddSubNode(const nType: Integer);
    var nPlan: PPlanItem;
        nIdx,nCount: integer;
    begin
      nCount := FPlanList.Count - 1;
      for nIdx:=0 to nCount do
      begin
        nPlan := FPlanList[nIdx];
        if nPlan.FType <> nType then Continue;

        with PlanTree1.Items.AddChild(nNode, nPlan.FName) do
        begin
          ImageIndex := cImagePlan;
          SelectedIndex := cImageSelected;
          Data := nPlan;
        end;
      end;
    end;
begin
  if BuildBaseInfoTree(sFlag_PlanItem) then
  begin
    nNode := PlanTree1.Items[0];

    while Assigned(nNode) do
    begin
      if nNode.ImageIndex = cImageGroup then
        AddSubNode(PBaseInfoData(nNode.Data).FID);
      nNode := nNode.GetNext;
    end;
  end;
end;

//Desc: 按皮肤类型查看
procedure TfFormPlanView.LoadPlanBySkin;
var nStr: string;
    nNode: TTreeNode;

    //Desc: 添加nNode的子节点
    procedure AddSubNode(const nSkin: string);
    var nPlan: PPlanItem;
        nIdx,nCount: integer;
    begin
      nCount := FPlanList.Count - 1;
      for nIdx:=0 to nCount do
      begin
        nPlan := FPlanList[nIdx];
        if nPlan.FSkin <> nSkin then Continue;

        with PlanTree1.Items.AddChild(nNode, nPlan.FName) do
        begin
          ImageIndex := cImagePlan;
          SelectedIndex := cImageSelected;
          Data := nPlan;
        end;
      end;
    end;
begin
  PlanTree1.Items.BeginUpdate;
  try
    FNeedReleaseData := False;
    PlanTree1.Items.Clear;
    
    nStr := 'Select T_ID,T_Name From %s Order By T_Part';
    nStr := Format(nStr, [sTable_SkinType]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      While not Eof do
      begin
        nNode := PlanTree1.Items.AddChild(nil, Fields[1].AsString);
        nNode.ImageIndex := cImageGroup;
        nNode.SelectedIndex := cImageGroup;

        AddSubNode(Fields[0].AsString);
        nNode.Expanded := True;
        Next;
      end;
    end;
  finally
    PlanTree1.Items.EndUpdate;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 设置数据
function TfFormPlanView.SetData(Sender: TObject; const nData: string): Boolean;
var nStr: string;
begin
  Result := False;
  if nData = '' then Exit;

  if Sender = EditType then
  begin
    Result := True;
    nStr := 'Select B_Text From %s Where B_Group=''%s'' And B_ID=%s';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_PlanItem, nData]);;

    EditType.Text := nData;
    with FDM.QueryTemp(nStr) do
     if RecordCount = 1 then
      EditType.Text := Fields[0].AsString;
  end else

  if Sender = EditSkin then
  begin
    Result := True;
    nStr := 'Select T_Name From %s Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, nData]);

    FSkinType := nData;
    EditSkin.Text := nData;

    with FDM.QueryTemp(nStr) do
     if RecordCount = 1 then
      EditSkin.Text := Fields[0].AsString;
  end;
end;

//Desc: 载入nID方案的信息
procedure TfFormPlanView.LoadPlanInfo(const nID: string);
var nStr: string;
begin
  EditInfo.Clear; InfoItems.Clear;
  ProductItmes.Clear; EditReason.Clear;
  BtnDel.Enabled := gSysParam.FIsAdmin;
  
  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Plan, nID]);
  LoadDataToCtrl(FDM.QuerySQL(nStr), Self, '', SetData);

  if not BtnDel.Enabled then
  begin
    nStr := FDM.SqlQuery.FieldByName('P_Man').AsString;
    BtnDel.Enabled := CompareText(nStr, gSysParam.FUserName) = 0;
  end;

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

//------------------------------------------------------------------------------
//Desc: 调整设置面板位置
procedure TfFormPlanView.FormResize(Sender: TObject);
var nH: integer;
begin
  nH := wPanel1.Height - 20;
  if nH <= cMaxHeight then
       dxLayout1.Height := nH
  else dxLayout1.Height := cMaxHeight;

  dxLayout1.Top := Round((wPanel1.Height - dxLayout1.Height) / 2);
  dxLayout1.Left := Round((wPanel1.Width - dxLayout1.Width) / 2);
end;

//Desc: 删除节点
procedure TfFormPlanView.PlanTree1Deletion(Sender: TObject; Node: TTreeNode);
begin
  if FNeedReleaseData then
  try
    if Node.ImageIndex = cImageGroup then DisposeBaseInfoData(Node.Data);
  except
    //ignor any error
  end;
end;

//Desc: 选择查看方式
procedure TfFormPlanView.Radio1Click(Sender: TObject);
begin    
  if Radio1.Checked then LoadPlanByDate else
  if Radio2.Checked then LoadPlanBySkin else
  if Radio3.Checked then LoadPlanByType;
end;

//Desc: 载入方案
procedure TfFormPlanView.PlanTree1Change(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and (Node.ImageIndex = cImagePlan) then
  begin
    FRecordID := PPlanItem(Node.Data).FID;
    LoadPlanInfo(FRecordID);
  end;
end;

//Desc: 皮肤状况
procedure TfFormPlanView.EditSkinPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  ShowViewSkinTypeForm(FSkinType, FDisplayRect);
end;

//Desc: 查看信息
procedure TfFormPlanView.ListInfo1Click(Sender: TObject);
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

//Desc: 查看产品明细
procedure TfFormPlanView.ListProduct1Click(Sender: TObject);
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

//Desc: 删除方案
procedure TfFormPlanView.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if not QueryDlg('确定要删除该方案吗?', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Plan, FRecordID]);
    FDM.ExecuteSQL(nStr);

    nStr := 'Delete From %s Where U_PID=''%s''';
    nStr := Format(nStr, [sTable_PlanUsed, FRecordID]);
    FDM.ExecuteSQL(nStr);

    FDM.ADOConn.CommitTrans;
    BtnDel.Enabled := False;
    FDM.ShowMsg('方案已成功删除', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('删除失败', sError);
  end;
end;

end.
