{*******************************************************************************
  作者: dmzn@163.com 2009-6-17
  描述: 美容师管理
*******************************************************************************}
unit UFramBeautician;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxCustomData, cxGraphics, 
  cxDataStorage, cxEdit, DB, cxDBData, ADODB, cxContainer, cxLabel,
  dxLayoutControl, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin, cxMaskEdit, cxButtonEdit, cxTextEdit, cxStyles,
  cxFilter, cxData, Menus;

type
  TfFrameBeautician = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditID: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditName: TcxButtonEdit;
    dxLayout1Item6: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure EditNamePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure cxView1DblClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
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
class function TfFrameBeautician.FrameID: integer;
begin
  Result := cFI_FrameBeautician;
end;

function TfFrameBeautician.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_Beautician;
  if nWhere <> '' then Result := Result + ' Where ' + nWhere;
end;

procedure TfFrameBeautician.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormBeautician, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameBeautician.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormBeautician, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFrameBeautician.BtnEditClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('B_ID').AsString;
  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := nStr;
  CreateBaseFormItem(cFI_FormBeautician, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameBeautician.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('B_Name').AsString;
  if not QueryDlg('确定要删除姓名为[ ' + nStr + ' ]的美容师吗', sAsk) then Exit;

  nStr := SQLQuery.FieldByName('B_ID').AsString;
  nSQL := 'Select Count(*) From %s Where M_Beautician=''%s''';
  nSQL := Format(nSQL, [sTable_Member, nStr]);

  with FDM.QueryTemp(nSQL) do
   if Fields[0].AsInteger > 0 then
   begin
     nStr := '该美容师已服务于 %d 名会员,需要过户后才可删除!!';
     nStr := Format(nStr, [Fields[0].AsInteger]);
     ShowDlg(nStr, sHint, Handle);  Exit;
   end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := SQLQuery.FieldByName('B_ID').AsString;
    nSQL := 'Delete From %s Where B_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Beautician, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
    nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_Beautician, nStr]); 
    FDM.ExecuteSQL(nSQL);

    nStr := SQLQuery.FieldByName('B_Name').AsString;
    nSQL := 'Delete From %s Where U_Name=''%s'' and U_Group=%d';
    nSQL := Format(nSQL, [sTable_User, nStr, cBeauticianGroup]);
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
procedure TfFrameBeautician.EditNamePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    FWhere := 'B_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    FWhere := 'B_Name like ''%' + EditName.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//Desc: 查看内容
procedure TfFrameBeautician.cxView1DblClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('B_ID').AsString;
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := nStr;
    CreateBaseFormItem(cFI_FormBeautician, PopedomItem, @nParam);
  end;
end;

//Desc: 处理菜单
procedure TfFrameBeautician.N3Click(Sender: TObject);
var nParam: TFormCommandParam;
begin
  case (Sender as TComponent).Tag of
    10: //查看资料
     cxView1DblClick(nil);
    20: //过户
     if cxView1.DataController.GetSelectedCount > 0 then
     begin
       FillChar(nParam, SizeOf(nParam), #0);
       nParam.FCommand := cCmd_EditData;
       nParam.FParamB := SQLQuery.FieldByName('B_ID').AsString;
       CreateBaseFormItem(cFI_FormMemberOwner, PopedomItem, @nParam);
     end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameBeautician, TfFrameBeautician.FrameID);
end.
