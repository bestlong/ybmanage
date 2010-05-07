{*******************************************************************************
  作者: dmzn@163.com 2009-6-17
  描述: 提醒服务
*******************************************************************************}
unit UFrameRemind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl,
  cxDropDownEdit, cxMaskEdit, cxButtonEdit, cxTextEdit, ADODB, cxContainer,
  cxLabel, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameRemind = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditTitle: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    cxLevel2: TcxGridLevel;
    cxView2: TcxGridDBTableView;
    SQLQuery2: TADOQuery;
    DataSource2: TDataSource;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure EditTitlePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditTypePropertiesChange(Sender: TObject);
    procedure cxView2DblClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
  protected
    FQuerySQL: string;
    //查询SQL
    procedure OnLoadPopedom; override;
    procedure OnDestroyFrame; override;
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, UMgrControl, ULibFun, UFormBase, USysDB, USysConst, USysGrid,
  USysPopedom, UFormWait, USysDataDict;

//------------------------------------------------------------------------------
class function TfFrameRemind.FrameID: integer;
begin
  Result := cFI_FrameRemind;
end;

function TfFrameRemind.InitFormDataSQL(const nWhere: string): string;
begin
  if FQuerySQL = '' then
  begin
    Result := 'Select * From ' + sTable_Remind;
    if nWhere <> '' then Result := Result + ' Where ' + nWhere;
  end else Result := FQuerySQL;
end;

procedure TfFrameRemind.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveUserDefineTableView(Name, cxView1, nIni);
    SaveUserDefineTableView(Name, cxView2, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFrameRemind.OnLoadPopedom;
var nStr: string;
    nIni: TIniFile;
begin
  if not gSysParam.FIsAdmin then
  begin
    nStr := gPopedomManager.FindUserPopedom(gSysParam.FUserID, PopedomItem);
    BtnAdd.Enabled := Pos(sPopedom_Add, nStr) > 0;
    BtnEdit.Enabled := Pos(sPopedom_Edit, nStr) > 0;
    BtnDel.Enabled := Pos(sPopedom_Delete, nStr) > 0;
    BtnPrint.Enabled := Pos(sPopedom_Print, nStr) > 0;
    BtnPreview.Enabled := Pos(sPopedom_Preview, nStr) > 0;
    BtnExport.Enabled := Pos(sPopedom_Export, nStr) > 0;
  end;

  FQuerySQL := '';
  Visible := False;
  
  Application.ProcessMessages;
  ShowWaitForm(ParentForm, '读取数据');

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    gSysEntityManager.BuildViewColumn(cxView1, PopedomItem);
    //初始化表头
    InitTableView(Name, cxView1, nIni);
    //初始化风格和顺序

    gSysEntityManager.BuildViewColumn(cxView2, 'MAIN_B02');
    //初始化表头
    InitTableView(Name, cxView2, nIni);
    //初始化风格和顺序

    InitFormData;
    //初始化数据
  finally
    nIni.Free;
    Visible := True;
    CloseWaitForm;
  end;
end;

procedure TfFrameRemind.BtnExitClick(Sender: TObject);
begin
  if not IsBusy then
  begin
    Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 刷新
procedure TfFrameRemind.BtnRefreshClick(Sender: TObject);
begin
  if FQuerySQL = '' then
       InitFormData('')
  else InitFormData('', SQLQuery2);
end;

//Desc: 添加
procedure TfFrameRemind.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormRemind, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

//Desc: 修改
procedure TfFrameRemind.BtnEditClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('R_ID').AsString;
  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := nStr;
  CreateBaseFormItem(cFI_FormRemind, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameRemind.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('R_Title').AsString;
  if not QueryDlg('确定要删除标题为[ ' + nStr + ' ]的记录吗', sAsk) then Exit;

  try
    nStr := SQLQuery.FieldByName('R_ID').AsString;
    nSQL := 'Delete From %s Where R_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Remind, nStr]);
    FDM.ExecuteSQL(nSQL);

    InitFormData(FWhere);
    ShowMsg('已成功删除记录', sHint);
  except
    ShowMsg('删除记录失败', '未知错误');
  end;
end;

//Desc: 查看会员
procedure TfFrameRemind.cxView2DblClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView2.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery2.FieldByName('M_ID').AsString;
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := nStr;
    CreateBaseFormItem(cFI_FormMemberData, PopedomItem, @nParam);
  end;
end;

//Desc: 查看提醒项
procedure TfFrameRemind.cxView1DblClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('R_ID').AsString;
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := nStr;
    CreateBaseFormItem(cFI_FormRemind, PopedomItem, @nParam);
  end;  
end;

//Desc: 打印
procedure TfFrameRemind.BtnPrintClick(Sender: TObject);
var nTitle: string;
    nQuery: TADOQuery;
begin
  if cxGrid1.ActiveView = cxView2 then
  begin
    nQuery := SQLQuery2;
    nTitle := EditType.Text;
  end else
  begin
    nQuery := SQLQuery;
    nTitle := TitleBar.Caption;
  end;

  if nQuery.Active and (nQuery.RecordCount > 0) then
       GridPrintData(cxGrid1, nTitle)
  else ShowMsg('没有可以打印的数据', sHint);
end;

//Desc: 预览
procedure TfFrameRemind.BtnPreviewClick(Sender: TObject);
var nTitle: string;
    nQuery: TADOQuery;
begin
  if cxGrid1.ActiveView = cxView2 then
  begin
    nQuery := SQLQuery2;
    nTitle := EditType.Text;
  end else
  begin
    nQuery := SQLQuery;
    nTitle := TitleBar.Caption;
  end;

  if nQuery.Active and (nQuery.RecordCount > 0) then
       GridPrintPreview(cxGrid1, nTitle)
  else ShowMsg('没有可以预览的数据', sHint);
end;

//Desc: 导出
procedure TfFrameRemind.BtnExportClick(Sender: TObject);
var nQuery: TADOQuery;
begin
  if cxGrid1.ActiveView = cxView2 then
  begin
    nQuery := SQLQuery2;
  end else
  begin
    nQuery := SQLQuery;
  end;

  if nQuery.Active and (nQuery.RecordCount > 0) then
       ExportGridData(cxGrid1)
  else ShowMsg('没有可以导出的数据', sHint);
end;

//------------------------------------------------------------------------------
//Desc: 查询
procedure TfFrameRemind.EditTitlePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditTitle then
  begin
    EditType.ItemIndex := 0;
    FWhere := 'R_Title like ''%' + EditTitle.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//Desc: 选择查询
procedure TfFrameRemind.EditTypePropertiesChange(Sender: TObject);
begin
  BtnAdd.Enabled := EditType.ItemIndex = 0;
  BtnEdit.Enabled := EditType.ItemIndex = 0;
  BtnDel.Enabled := EditType.ItemIndex = 0; 

  if EditType.ItemIndex = 0 then
  begin
    FQuerySQL := '';
    cxLevel1.Active := True;
  end else
  begin
    cxLevel2.Active := True;
    FQuerySQL := 'Select * From %s Where M_BirthDay like ''%%%s%%''';

    if EditType.ItemIndex = 1 then
      FQuerySQL := Format(FQuerySQL, [sTable_Member, FormatDateTime('-MM-DD', Date)])
    else if EditType.ItemIndex = 2 then
      FQuerySQL := Format(FQuerySQL, [sTable_Member, FormatDateTime('-MM-', Date)]);
    InitFormData('', SQLQuery2);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameRemind, TfFrameRemind.FrameID);
end.
