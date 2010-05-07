{*******************************************************************************
  作者: dmzn@163.com 2009-6-19
  描述: 方案管理
*******************************************************************************}
unit UFramPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxMaskEdit, cxButtonEdit, cxTextEdit;

type
  TfFramePlan = class(TfFrameNormal)
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item7: TdxLayoutItem;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView1DblClick(Sender: TObject);
  protected
    { Protected declarations }
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrControl, ULibFun, UFormBase, USysDB, USysConst, UDataModule;

//------------------------------------------------------------------------------
class function TfFramePlan.FrameID: integer;
begin
  Result := cFI_FramePlan;
end;

function TfFramePlan.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Plan;
  if nWhere <> '' then Result := Result + ' Where ' + nWhere;
end;

procedure TfFramePlan.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormPlan, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFramePlan.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormPlan, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFramePlan.BtnEditClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('P_ID').AsString;
  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := nStr;
  CreateBaseFormItem(cFI_FormPlan, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFramePlan.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('P_Name').AsString;
  if not QueryDlg('确定要删除名称为[ ' + nStr + ' ]的方案吗', sAsk) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := SQLQuery.FieldByName('P_ID').AsString;
    nSQL := 'Delete From %s Where P_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Plan, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
    nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_PlanItem, nStr]); 
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where E_Plan=''%s''';
    nSQL := Format(nSQL, [sTable_PlanExt, nStr]); 
    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('已成功删除记录', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('删除记录失败', '未知错误');
  end;
end;

//Desc: 查找
procedure TfFramePlan.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    FWhere := 'P_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    FWhere := 'P_Name like ''%' + EditName.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//Desc: 查看内容
procedure TfFramePlan.cxView1DblClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('P_ID').AsString;
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := nStr;
    CreateBaseFormItem(cFI_FormPlan, PopedomItem, @nParam);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFramePlan, TfFramePlan.FrameID);
end.
