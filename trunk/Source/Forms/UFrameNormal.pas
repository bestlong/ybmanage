{*******************************************************************************
  ����: dmzn@163.com 2009-06-11
  ����: �ṩ���ù��ܵĻ�����
*******************************************************************************}
unit UFrameNormal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  cxTextEdit, cxMaskEdit, cxButtonEdit, UFrameBase, 
  cxEdit, DB, cxDBData, ADODB,
  cxContainer, cxLabel, dxLayoutControl, cxGridLevel, cxClasses,
  cxControls, cxGridCustomView, cxGridCustomTableView, cxGridTableView,
  cxGridDBTableView, cxGrid, ComCtrls, ToolWin, 
  cxGraphics, cxDataStorage, cxStyles, cxCustomData, cxFilter, cxData;

type
  TfFrameNormal = class(TBaseFrame)
    ToolBar1: TToolBar;
    BtnAdd: TToolButton;
    BtnEdit: TToolButton;
    BtnDel: TToolButton;
    S1: TToolButton;
    BtnRefresh: TToolButton;
    S2: TToolButton;
    BtnPrint: TToolButton;
    BtnPreview: TToolButton;
    BtnExport: TToolButton;
    S3: TToolButton;
    BtnExit: TToolButton;
    cxGrid1: TcxGrid;
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    dxLayout1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    GroupSearch1: TdxLayoutGroup;
    GroupDetail1: TdxLayoutGroup;
    SQLQuery: TADOQuery;
    DataSource1: TDataSource;
    TitleBar: TcxLabel;
    procedure BtnRefreshClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
    procedure cxView1FocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
  private
    { Private declarations }
  protected
    FWhere: string;
    {*��������*}
    FShowDetailInfo: Boolean;
    {*��ʾ������Ϣ*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadPopedom; override;
    {*���ຯ��*}
    procedure InitFormData(const nWhere: string = '';
     const nQuery: TADOQuery = nil); virtual;
    function InitFormDataSQL(const nWhere: string): string; virtual;
    {*��������*}
    procedure GetData(Sender: TObject; var nData: string); virtual;
    function SetData(Sender: TObject; const nData: string): Boolean; virtual;
    {*��д����*}
  public
    { Public declarations }
  published
    procedure OnCtrlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState); virtual;
    procedure OnCtrlKeyPress(Sender: TObject; var Key: Char); virtual;
    {*��������*}
  end;

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UAdjustForm, UFormWait, UFormCtrl, UDataModule,
  USysFun, USysConst, USysGrid, USysDataDict, USysPopedom, USysDB;

//------------------------------------------------------------------------------
procedure TfFrameNormal.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FWhere := '';
  FShowDetailInfo := True;
end;

procedure TfFrameNormal.OnDestroyFrame;
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveUserDefineTableView(Name, cxView1, nIni);
  finally
    nIni.Free;
  end;
end;

//Desc: ��ȡȨ��
procedure TfFrameNormal.OnLoadPopedom;
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

  Visible := False;
  Application.ProcessMessages;
  ShowWaitForm(ParentForm, '��ȡ����');

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    gSysEntityManager.BuildViewColumn(cxView1, PopedomItem);
    //��ʼ����ͷ
    InitTableView(Name, cxView1, nIni);
    //��ʼ������˳��
    InitFormData;
    //��ʼ������
  finally
    nIni.Free;
    Visible := True;
    CloseWaitForm;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameNormal.GetData(Sender: TObject; var nData: string);
begin

end;

//Desc: ����Sender������ΪnData
function TfFrameNormal.SetData(Sender: TObject; const nData: string): Boolean;
var nStr: string;
    nRIdx,nCIdx: integer;
    nTable,nField: string;
begin
  Result := False;

  if (cxView1.Controller.SelectedRowCount > 0) and (Sender is TComponent) and
     GetTableByHint(Sender as TComponent, nTable, nField)then
  begin
    nRIdx := cxView1.Controller.SelectedRows[0].RecordIndex;
    nCIdx := cxView1.DataController.GetItemByFieldName(nField).Index;
    
    nStr := cxView1.DataController.GetDisplayText(nRIdx, nCIdx);
    if nStr = '' then nStr := nData;

    SetCtrlData(Sender as TComponent, nStr);
    Result := True;
  end;
end;

//Desc: ������������SQL���
function TfFrameNormal.InitFormDataSQL(const nWhere: string): string;
begin
  Result := '';
end;

//Desc: �����������
procedure TfFrameNormal.InitFormData(const nWhere: string; const nQuery: TADOQuery);
var nStr: string;
begin
  nStr := InitFormDataSQL(nWhere);
  if nStr = '' then Exit;

  BtnRefresh.Enabled := False;
  try
    ShowMsgOnLastPanelOfStatusBar('���ڶ�ȡ����,���Ժ�...');
    if Assigned(nQuery) then
         FDM.QueryData(nQuery, nStr)
    else FDM.QueryData(SQLQuery, nStr);
  finally
    ShowMsgOnLastPanelOfStatusBar('');
    BtnRefresh.Enabled := True;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��Ӧ�س�
procedure TfFrameNormal.OnCtrlKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;

    if Sender is TcxButtonEdit then
    with TcxButtonEdit(Sender) do
    begin
      Properties.OnButtonClick(Sender, 0);
      SelectAll;
    end else SwitchFocusCtrl(Self, True);
  end;
end;

//Desc: �����ݼ�
procedure TfFrameNormal.OnCtrlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_DOWN:
      begin
        Key := 0; SwitchFocusCtrl(Self, True);
      end;
    VK_UP:
      begin
        Key := 0; SwitchFocusCtrl(Self, False);
      end;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ˢ��
procedure TfFrameNormal.BtnRefreshClick(Sender: TObject);
begin
  InitFormData('');
end;

//Desc: ����
procedure TfFrameNormal.BtnExportClick(Sender: TObject);
begin
  if SQLQuery.Active and (SQLQuery.RecordCount > 0) then
       ExportGridData(cxGrid1)
  else ShowMsg('û�п��Ե���������', sHint);
end;

//Desc: ��ӡ
procedure TfFrameNormal.BtnPrintClick(Sender: TObject);
begin
  if SQLQuery.Active and (SQLQuery.RecordCount > 0) then
       GridPrintData(cxGrid1, TitleBar.Caption)
  else ShowMsg('û�п��Դ�ӡ������', sHint);
end;

//Desc: Ԥ��
procedure TfFrameNormal.BtnPreviewClick(Sender: TObject);
begin
  if SQLQuery.Active and (SQLQuery.RecordCount > 0) then
       GridPrintPreview(cxGrid1, TitleBar.Caption)
  else ShowMsg('û�п���Ԥ��������', sHint);
end;

//Desc: ������Ϣ
procedure TfFrameNormal.cxView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if FShowDetailInfo and Assigned(APrevFocusedRecord) then
    LoadDataToCtrl(SQLQuery, dxLayout1, '', SetData);
end;

end.
