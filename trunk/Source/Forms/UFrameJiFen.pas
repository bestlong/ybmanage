{*******************************************************************************
  作者: dmzn@163.com 2009-6-17
  描述: 积分查询
*******************************************************************************}
unit UFrameJiFen;

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
  TfFrameJiFen = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditFirm: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditDate: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure EditTitlePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditDatePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
  protected
    FStart,FEnd: TDate;
    //时间区间
    procedure OnCreateFrame; override;
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
  USysPopedom, UFormWait, USysDataDict, UFormDateFilter;

//------------------------------------------------------------------------------
class function TfFrameJiFen.FrameID: integer;
begin
  Result := cFI_FrameJiFen;
end;

procedure TfFrameJiFen.OnCreateFrame;
begin
  inherited;
  InitDateRange(Name, FStart, FEnd);
end;

procedure TfFrameJiFen.OnDestroyFrame;
begin
  SaveDateRange(Name, FStart, FEnd);
  inherited;
end;

procedure TfFrameJiFen.BtnExitClick(Sender: TObject);
begin
  if not IsBusy then
  begin
    Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 读取数据
function TfFrameJiFen.InitFormDataSQL(const nWhere: string): string;
begin
  EditDate.Text := Format('%s 至 %s', [Date2Str(FStart), Date2Str(FEnd)]);
  
  Result := 'Select * From $JF jf ' +
            ' Left Join $Firm fm On fm.M_ID=jf.F_MID ';
  //xxxxx

  if nWhere = '' then
       Result := Result + 'Where F_Date>=''$Start'' And F_Date<''$End'''
  else Result := Result + 'Where (' + nWhere + ')';

  Result := MacroValue(Result, [MI('$JF', sTable_JiFen), MI('$Firm', sTable_Member),
            MI('$Start', Date2Str(FStart)), MI('$End', Date2Str(FEnd + 1))]);
  //xxxxxx
end;

//Desc: 刷新
procedure TfFrameJiFen.BtnRefreshClick(Sender: TObject);
begin
  InitFormData();
end;

//------------------------------------------------------------------------------
//Desc: 查询
procedure TfFrameJiFen.EditTitlePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditFirm then
  begin
    EditFirm.Text := Trim(EditFirm.Text);
    if EditFirm.Text = '' then Exit;

    FWhere := 'M_ID like ''%%%s%%'' Or M_Name Like ''%%%s%%''';
    FWhere := Format(FWhere, [EditFirm.Text, EditFirm.Text]);
    InitFormData(FWhere);
  end;
end;

//Desc: 日期筛选
procedure TfFrameJiFen.EditDatePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: 添加
procedure TfFrameJiFen.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormJiFen, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFrameJiFen.BtnEditClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('F_ID').AsString;
  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := nStr;
  CreateBaseFormItem(cFI_FormJiFen, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

//Desc: 删除
procedure TfFrameJiFen.BtnDelClick(Sender: TObject);
var nStr: string;
begin
   if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := 'Delete From %s Where F_ID=%s';
  nStr := Format(nStr, [sTable_JiFen, SQLQuery.FieldByName('F_ID').AsString]);
  
  FDM.ExecuteSQL(nStr);
  InitFormData(FWhere);
  ShowMsg('删除完成', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFrameJiFen, TfFrameJiFen.FrameID);
end.
