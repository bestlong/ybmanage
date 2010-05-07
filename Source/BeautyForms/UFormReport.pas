unit UFormReport;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UBgFormBase, ComCtrls, dxLayoutControl, cxControls,
  cxContainer, cxTreeView, StdCtrls, cxRadioGroup, UTransPanel, cxMemo,
  UImageViewer, cxEdit, cxTextEdit, ImgList, cxImage, cxGraphics,
  cxMaskEdit, cxDropDownEdit, frxClass, frxDesgn, frxGradient, frxRich;

type
  TfFormReport = class(TfBgFormBase)
    TPanel: TZnTransPanel;
    BPanel1: TZnTransPanel;
    BtnExit: TButton;
    Radio1: TcxRadioButton;
    Radio2: TcxRadioButton;
    PlanTree1: TcxTreeView;
    wPanel1: TZnTransPanel;
    BtnSave: TButton;
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    EditMID: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditMName: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditBName: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    EditSkin: TcxMemo;
    dxLayout1Item7: TdxLayoutItem;
    EditChuF: TcxMemo;
    dxLayout1Item9: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item10: TdxLayoutItem;
    ImageList1: TImageList;
    Radio3: TcxRadioButton;
    dxLayout1Group10: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    BtnPrint: TButton;
    EditHeight: TcxTextEdit;
    dxLayout1Item11: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group11: TdxLayoutGroup;
    EditSex: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditAge: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Group12: TdxLayoutGroup;
    EditBPhone: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxImage1: TcxImage;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group9: TdxLayoutGroup;
    EditReportList: TcxComboBox;
    dxLayout1Item6: TdxLayoutItem;
    frxDesigner1: TfrxDesigner;
    frxReport1: TfrxReport;
    frxRichObject1: TfrxRichObject;
    frxGradientObject1: TfrxGradientObject;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure PlanTree1Deletion(Sender: TObject; Node: TTreeNode);
    procedure Radio1Click(Sender: TObject);
    procedure PlanTree1Change(Sender: TObject; Node: TTreeNode);
    procedure BtnSaveClick(Sender: TObject);
    procedure EditReportListPropertiesEditValueChanged(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure dxLayout1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure frxReport1GetValue(const VarName: String;
      var Value: Variant);
    procedure frxReport1BeginDoc(Sender: TObject);
  private
    { Private declarations }
    FPlanID: string;
    //方案编号
    FReportID: string;
    //报告编号
    FMemberID: string;
    //会员编号
    FDisplayRect: TRect;
    //显示区域
    FPlanList: TList;
    //方案列表
    FOldCloseForm: TNotifyEvent;
    //旧有事件
    procedure InitFormData;
    //初始数据
    procedure OnCloseActiveForm(Sender: TObject);
    //活动窗口关闭
    procedure LoadPlanByDate;
    procedure LoadPlanByType;
    procedure LoadPlanBySkin;
    procedure LoadPlanFromDB;
    //读取方案列表
    procedure LoadPlanInfo(const nPlan: Pointer);
    //读取方案信息
    procedure ClearPlanList(const nFree: Boolean);
    //释放资源
    function BuildBaseInfoTree(const nGroup: string): Boolean;
    //构建资料树
  public
    { Public declarations }
  end;

function ShowReportForm(const nMemberID: string; const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, USysGrid, USysDB, USysConst, USysGobal,
  USysDataFun;

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
  cMaxHeight       = 680;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: 显示区域
//Desc: 在nRect区域显示报告窗口
function ShowReportForm(const nMemberID: string; const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormReport.Create(Application);
  Result := gForm;

  with TfFormReport(Result) do
  begin
    FMemberID := nMemberID;
    FDisplayRect := nRect;

    InitFormData;
    if not Showing then Show;
  end;
end;

procedure TfFormReport.FormCreate(Sender: TObject);
var nStr: string;
begin
  WindowState := wsMaximized;
  DoubleBuffered := True;

  FPlanID := '';
  FReportID := '';
  FPlanList := TList.Create;
  
  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;
  inherited;

  nStr := gPath + 'Report.fr3';
  if FileExists(nStr) then frxReport1.LoadFromFile(nStr);
end;

procedure TfFormReport.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    gForm := nil;
    ClearPlanList(True);
    ReleaseCtrlData(Self);
    
    gOnCloseActiveForm := FOldCloseForm;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);
  end;
end;

procedure TfFormReport.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

procedure TfFormReport.OnCloseActiveForm(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
procedure TfFormReport.InitFormData;
begin
  LoadPlanFromDB;
  if Radio1.Checked then LoadPlanByDate else
  if Radio2.Checked then LoadPlanBySkin else
  if Radio3.Checked then LoadPlanByType;
end;

//Desc: 释放方案列表
procedure TfFormReport.ClearPlanList(const nFree: Boolean);
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
procedure TfFormReport.LoadPlanFromDB;
var nStr: string;
    nPlan: PPlanItem;
begin
  nStr := 'Select * From $T ' +
          'Where P_ID In (Select U_PID From $Used Where U_MID=''$ID'') ' +
          'Order By P_Date';

  nStr := MacroValue(nStr, [MI('$T', sTable_Plan), MI('$Used', sTable_PlanUsed),
                            MI('$ID', FMemberID)]);
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
procedure TfFormReport.LoadPlanByDate;
var nStr: string;
    nPlan: PPlanItem;
    nIdx,nCount: integer;
begin
  PlanTree1.Items.BeginUpdate;
  try
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
function TfFormReport.BuildBaseInfoTree(const nGroup: string): Boolean;
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
procedure TfFormReport.LoadPlanByType;
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

procedure TfFormReport.LoadPlanBySkin;
begin
  
end;

//Desc: 读取方案nID到界面
procedure TfFormReport.LoadPlanInfo(const nPlan: Pointer);
var nStr: string;
    nData: PPlanItem;
begin
  nData := PPlanItem(nPlan);
  FPlanID := nData.FID;
  nStr := 'Select M_Name,M_Sex,M_Age,M_Height,M_Weight From %s Where M_ID=''%s''';
  
  nStr := Format(nStr, [sTable_Member, FMemberID]);
  EditMID.Text := FMemberID;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditMName.Text := FieldByName('M_Name').AsString;
    EditAge.Text := FieldByName('M_Age').AsString;
    EditHeight.Text := FieldByName('M_Height').AsString;
    EditWeight.Text := FieldByName('M_Weight').AsString;

    if FieldByName('M_Sex').AsString = sFlag_Man then
         EditSex.Text := '男'
    else EditSex.Text := '女';
  end else
  begin
    EditMName.Clear;
    EditAge.Clear;
    EditSex.Clear;
    EditHeight.Clear;
    EditWeight.Clear;
  end;

  nStr := 'Select B_Name,B_Phone From %s Where B_ID=''%s''';
  nStr := Format(nStr, [sTable_Beautician, gSysParam.FBeautyID]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    EditBName.Text := Fields[0].AsString;
    EditBPhone.Text := Fields[1].AsString;
  end else
  begin
    EditBName.Clear; EditBPhone.Clear;
  end;

  nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                     MI('$Group', sFlag_SkinType), MI('$ID', nData.FSkin)]);
  //xxxxx

  EditSkin.Clear;
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := '%d.特征名:[ %s ] 特征描述:[ %s ]';
      nStr := Format(nStr, [EditSkin.Lines.Count + 1,
              FieldByName('I_Item').AsString, FieldByName('I_Info').AsString]);

      EditSkin.Lines.Add(nStr);
      Next;
    end;
  end;

  nStr := 'Select P_Name,(Select P_Name From $Plant pl ' +
          '               Where pl.P_ID=pr.P_Plant) as P_PlantName ' +
          'From $Product pr ' +
          'Where P_ID in ' +
          '  (Select E_Product From $PE Where E_Plan=''$ID'')';

  nStr := MacroValue(nStr, [MI('$Plant', sTable_Plant),
          MI('$Product', sTable_Product), MI('$PE', sTable_PlanExt),
          MI('$ID', nData.FID)]);

  EditChuF.Clear;
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := '%d.产品名称:[ %s ] 生产商:[ %s ]';
      nStr := Format(nStr, [EditChuF.Lines.Count + 1, Fields[0].AsString,
                            Fields[1].AsString]);
      //xxxxx
      
      EditChuF.Lines.Add(nStr);
      Next;
    end;
  end;

  nStr := 'Select R_ID,R_Date From %s Where R_PID=''%s'' Order By R_Date DESC';
  nStr := Format(nStr, [sTable_PlanReport, nData.FID]);
  AdjustCXComboBoxItem(EditReportList, True);
  
  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := Fields[0].AsString;
      nStr := Format('%s=%s.%s', [nStr, nStr, DateTime2Str(Fields[1].AsDateTime)]);

      EditReportList.Properties.Items.Add(nStr);
      Next;
    end;

    AdjustStringsItem(EditReportList.Properties.Items, False);
  end;

  nStr := 'Select T_Image From %s Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_SkinType, nData.FSkin]);
  FDM.LoadDBImage(FDM.QueryTemp(nStr), 'T_Image', cxImage1.Picture);
end;

//------------------------------------------------------------------------------
//Desc: 调整设置面板位置
procedure TfFormReport.FormResize(Sender: TObject);
var nH: Integer;
begin
  nH := wPanel1.Height - 20;
  if nH < cMaxHeight then
       dxLayout1.Height := nH
  else dxLayout1.Height := cMaxHeight;

  dxLayout1.Top := Round((wPanel1.Height - dxLayout1.Height) / 2);
  dxLayout1.Left := Round((wPanel1.Width - dxLayout1.Width) / 2);
end;

//Desc: 删除节点
procedure TfFormReport.PlanTree1Deletion(Sender: TObject; Node: TTreeNode);
begin
  try
    if Node.ImageIndex = cImageGroup then Dispose(PBaseInfoData(Node.Data));
  except
    //ignor any error
  end;
end;

//Desc: 选择查看方式
procedure TfFormReport.Radio1Click(Sender: TObject);
begin
  if Radio1.Checked then LoadPlanByDate else
  if Radio2.Checked then LoadPlanBySkin else
  if Radio3.Checked then LoadPlanByType;
end;

procedure TfFormReport.PlanTree1Change(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and (Node.ImageIndex = cImagePlan) then
  begin
    LoadPlanInfo(Node.Data);
    BtnPrint.Enabled := True;
    BtnSave.Enabled := True;
  end;
end;

//Desc: 载入报告
procedure TfFormReport.EditReportListPropertiesEditValueChanged(
  Sender: TObject);
var nStr,nID: string;
begin
  nID := GetCtrlData(EditReportList);

  if nID <> '' then
  begin
    nStr := 'Select R_Skin,R_Plan,R_Memo From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_PlanReport, nID]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      EditSkin.Text := Fields[0].AsString;
      EditChuF.Text := Fields[1].AsString;
      EditMemo.Text := Fields[2].AsString;
    end;
  end;
end;

//Desc: 保存
procedure TfFormReport.BtnSaveClick(Sender: TObject);
var nStr,nID: string;
begin
  if FReportID = '' then
  begin
    nStr := 'Insert Into %s(R_PID,R_Skin,R_Plan,R_Memo,R_Date) ' +
            'Values(''%s'',''%s'',''%s'',''%s'',''%s'')';
    nStr := Format(nStr, [sTable_PlanReport, FPlanID, EditSkin.Text,
            EditChuF.Text, EditMemo.Text, DateTime2Str(Now)]);
  end else
  begin
    nStr := 'Update %s Set R_Skin=''%s'',R_Plan=''%s'',R_Memo=''%s'' ' +
            'Where R_ID=%s';
    nStr := Format(nStr, [sTable_PlanReport, EditSkin.Text,
            EditChuF.Text, EditMemo.Text, FReportID]);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nStr);

    if FReportID = '' then
         nID := IntToStr(FDM.GetFieldMax(sTable_PlanReport, 'R_ID'))
    else nID := FReportID;

    if gSysDBType = dtAccess then
    begin
      nStr := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nStr := Format(nStr, [sTable_SyncItem, sTable_PlanReport, 'R_ID', nID]);
      FDM.ExecuteSQL(nStr);
    end; //记录变更

    FDM.ADOConn.CommitTrans;
    FReportID := nID;
    FDM.ShowMsg('报告已成功保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('报告保存失败', sError);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 打印
procedure TfFormReport.BtnPrintClick(Sender: TObject);
begin
  frxReport1.ShowReport;
end;

procedure TfFormReport.dxLayout1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = Ord('d')) or (Key = Ord('D')) then
   if (ssShift in Shift) and (ssCtrl in Shift) then
   begin
     Key := 0;
     frxReport1.DesignReport;
   end;
end;

//Desc: 读取图片 
procedure TfFormReport.frxReport1BeginDoc(Sender: TObject);
var nObj: TfrxComponent;
begin
  nObj := frxReport1.FindObject('SkinPic');
  if Assigned(nObj) then
    TfrxPictureView(nObj).Picture.Graphic := cxImage1.Picture.Graphic;
  //xxxxx
end;

procedure TfFormReport.frxReport1GetValue(const VarName: String;
  var Value: Variant);
begin
  Value := '***';

  if CompareText('MemberID', VarName) = 0 then
  begin
    Value := EditMID.Text;
  end else
  if CompareText('MemberName', VarName) = 0 then
  begin
    Value := EditMName.Text;
  end else
  if CompareText('MemberSex', VarName) = 0 then
  begin
    Value := EditSex.Text;
  end else
  if CompareText('MemberAge', VarName) = 0 then
  begin
    Value := EditAge.Text;
  end else
  if CompareText('MemberHeight', VarName) = 0 then
  begin
    Value := EditHeight.Text;
  end else
  if CompareText('MemberWeight', VarName) = 0 then
  begin
    Value := EditWeight.Text;
  end else
  if CompareText('Beautician', VarName) = 0 then
  begin
    Value := EditBName.Text;
  end else
  if CompareText('PhoneNumber', VarName) = 0 then
  begin
    Value := EditBPhone.Text;
  end else
  if CompareText('Skin', VarName) = 0 then
  begin
    Value := EditSkin.Text;
  end else
  if CompareText('ChuFang', VarName) = 0 then
  begin
    Value := EditChuF.Text;
  end else
  if CompareText('Memo', VarName) = 0 then
  begin
    Value := EditMemo.Text;
  end;
end;

end.
