{*******************************************************************************
  作者: dmzn@163.com 2009-6-30
  描述: 方案浏览
*******************************************************************************}
unit UFormPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxGraphics, dxLayoutControl, cxMaskEdit,
  cxDropDownEdit, cxMCListBox, StdCtrls, cxPC, cxMemo, cxContainer, cxEdit,
  cxTextEdit, cxControls, UTransPanel, cxButtonEdit;

type
  TfFormPlan = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnExit: TButton;
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
    cxSheet2: TcxTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    EditReason: TcxMemo;
    ListProduct1: TcxMCListBox;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    InfoItems: TcxTextEdit;
    EditType: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditID: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditSkin: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    ProductItmes: TcxComboBox;
    BtnDel: TButton;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure ListProduct1Click(Sender: TObject);
    procedure EditSkinPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    FSkinType: string;
    //记录标识
    FDisplayRect: TRect;
    //显示区域
    procedure InitFormData(const nID: string);
    //初始化数据
    function SetData(Sender: TObject; const nData: string): Boolean;
  public
    { Public declarations }
    FDataChanged: Boolean;
    //数据变动
  end;

function ShowViewPlanForm(const nID: string; const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UAdjustForm, UFormCtrl, USysConst, USysDB, USysGrid, USysGobal,
  UFormSkinType;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-1
//Parm: 方案编号;显示区域
//Desc: 在nRect区域显示nID方案的信息
function ShowViewPlanForm(const nID: string; const nRect: TRect): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormPlan.Create(Application);
  Result := gForm;

  with TfFormPlan(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FRecordID := nID;
    FDisplayRect := nRect;
    FDataChanged := False;

    InitFormData(nID);
    if not Showing then Show;
  end;
end;

procedure TfFormPlan.FormCreate(Sender: TObject);
begin
  inherited;
  LoadMCListBoxConfig(Name, ListInfo1);
  LoadMCListBoxConfig(Name, ListProduct1);
  ResetHintAllCtrl(Self, 'T', sTable_Plan);
end;

procedure TfFormPlan.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    SaveMCListBoxConfig(Name, ListInfo1);
    SaveMCListBoxConfig(Name, ListProduct1);
    
    gForm := nil;
    ReleaseCtrlData(Self);
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
  end;
end;

procedure TfFormPlan.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 设置数据
function TfFormPlan.SetData(Sender: TObject; const nData: string): Boolean;
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

procedure TfFormPlan.InitFormData(const nID: string);
var nStr: string;
begin
  EditInfo.Clear; InfoItems.Clear;
  ProductItmes.Clear; EditReason.Clear;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Plan, nID]);
  LoadDataToCtrl(FDM.QuerySQL(nStr), Self, '', SetData);

  BtnDel.Enabled := gSysParam.FIsAdmin;
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
                            MI('$Plan', sTable_PlanExt), MI('$ID', FRecordID)]);
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

//Desc: 查看信息
procedure TfFormPlan.ListInfo1Click(Sender: TObject);
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
procedure TfFormPlan.ListProduct1Click(Sender: TObject);
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

//Desc: 皮肤状况
procedure TfFormPlan.EditSkinPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  Visible := False;
  ShowViewSkinTypeForm(FSkinType, FDisplayRect);
  Visible := True;
end;

//Desc: 删除方案
procedure TfFormPlan.BtnDelClick(Sender: TObject);
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
    FDataChanged := True;
    FDM.ShowMsg('方案已成功删除', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('删除失败', sError);
  end;
end;

end.
