{*******************************************************************************
  作者: dmzn@163.com 2010-5-14
  描述: 皮肤图谱
*******************************************************************************}
unit UFramTuPu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus,
  UBitmapPanel, cxSplitter;

type
  TfFrameTuPu = class(TfFrameNormal)
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditLevel: TcxButtonEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure cxView1DblClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
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
class function TfFrameTuPu.FrameID: integer;
begin
  Result := cFI_FrameTuPu;
end;

function TfFrameTuPu.InitFormDataSQL(const nWhere: string): string;
begin
  Result := 'Select * From ' + sTable_TuPu;
  if nWhere <> '' then
    Result := Result + ' Where (' + nWhere + ')';
  //xxxxx
end;

procedure TfFrameTuPu.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormTuPuView, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameTuPu.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormTuPu, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFrameTuPu.BtnEditClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要编辑的记录', sHint); Exit;
  end;

  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := SQLQuery.FieldByName('T_ID').AsString;
  CreateBaseFormItem(cFI_FormTuPu, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameTuPu.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('请选择要删除的记录', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('T_ID').AsString;
  if QueryDlg('确定要删除编号为[ ' + nStr + ' ]的记录吗', sAsk) then
  begin
    nSQL := 'Delete From %s Where T_ID=%s';
    nSQL := Format(nSQL, [sTable_TuPu, nStr]);
    FDM.ExecuteSQL(nSQL);

    InitFormData(FWhere);
    ShowMsg('记录已成功删除', sHint);
  end;
end;

//Desc: 查找
procedure TfFrameTuPu.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nPos: Integer;
    nA,nB: string;
begin
  if Sender = EditLevel then
  begin
    EditLevel.Text := Trim(EditLevel.Text);
    if EditLevel.Text = '' then Exit;

    nPos := Pos(' ', EditLevel.Text);
    if nPos > 0 then
    begin
      nB := EditLevel.Text;
      nA := Copy(nB, 1, nPos - 1);
      System.Delete(nB, 1, nPos);

      FWhere := '(T_LevelA like ''%%%s%%'' or T_PYA like ''%%%s%%'') and ' +
                '(T_LevelB like ''%%%s%%'' or T_PYB like ''%%%s%%'')';
      FWhere := Format(FWhere, [nA, nA, nB, nB]);
    end else
    begin
      FWhere := 'T_LevelA like ''%%%s%%'' or T_PYA like ''%%%s%%''';
      FWhere := Format(FWhere, [EditLevel.Text, EditLevel.Text]);
    end;

    InitFormData(FWhere);
  end;
end;

//Desc: 查看内容
procedure TfFrameTuPu.cxView1DblClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := SQLQuery.FieldByName('T_ID').AsString;
    CreateBaseFormItem(cFI_FormTuPuView, PopedomItem, @nParam);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameTuPu, TfFrameTuPu.FrameID);
end.
