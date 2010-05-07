{*******************************************************************************
  ����: dmzn 2009-06-04
  ����: ������ͬ����
*******************************************************************************}
unit UFrameSysLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UFrameBase, cxStyles, cxCustomData, cxGraphics,
  cxFilter, cxData, cxDataStorage, cxEdit, DB, cxDBData, Menus, ADODB,
  dxLayoutControl, cxTextEdit, cxContainer, cxMaskEdit, cxButtonEdit,
  ExtCtrls, cxGridLevel, cxClasses, cxControls, cxGridCustomView,
  cxGridCustomTableView, cxGridTableView, cxGridDBTableView, cxGrid,
  ComCtrls, ToolWin;

type
  TfFrameSysLog = class(TBaseFrame)
    ToolBar1: TToolBar;
    BtnExit: TToolButton;
    SQLQuery: TADOQuery;
    DataSource1: TDataSource;
    cxView1: TcxGridDBTableView;
    cxLevel1: TcxGridLevel;
    cxGrid1: TcxGrid;
    BtnFilter: TToolButton;
    BtnPrint: TToolButton;
    S3: TToolButton;
    BtnPreview: TToolButton;
    BtnExport: TToolButton;
    TitlePanel: TPanel;
    S2: TToolButton;
    BtnRefresh: TToolButton;
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    dxLayoutControl1Group2: TdxLayoutGroup;
    EditMan: TcxButtonEdit;
    dxLayoutControl1Item2: TdxLayoutItem;
    EditItem: TcxButtonEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditValue: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayoutControl1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayoutControl1Item5: TdxLayoutItem;
    cxTextEdit4: TcxTextEdit;
    dxLayoutControl1Item6: TdxLayoutItem;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnPrintClick(Sender: TObject);
    procedure BtnPreviewClick(Sender: TObject);
    procedure BtnRefreshClick(Sender: TObject);
    procedure cxView1FocusedRecordChanged(Sender: TcxCustomGridTableView;
      APrevFocusedRecord, AFocusedRecord: TcxCustomGridRecord;
      ANewItemRecordFocusingChanged: Boolean);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditManKeyPress(Sender: TObject; var Key: Char);
    procedure BtnFilterClick(Sender: TObject);
  private
    { Private declarations }
  protected
    FWhere: string;
    {*��������*}
    FStart,FEnd: TDate;
    {*ɸѡʱ���*}
    procedure OnCreateFrame; override;
    procedure OnDestroyFrame; override;
    procedure OnLoadPopedom; override;
    {*���ຯ��*}
    procedure InitFormData(const nWhere: string = '');
    {*��������*}
  public
    { Public declarations }
    class function FrameID: integer; override;
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, USysFun, USysConst, USysGrid, USysDataDict, USysPopedom,
  USysDB, UFormWait, UFormCtrl, UMgrControl, UFormDateFilter;

class function TfFrameSysLog.FrameID: integer;
begin
  Result := cFI_FrameSysLog;
end;

procedure TfFrameSysLog.OnCreateFrame;
begin
  Name := MakeFrameName(FrameID);
  FWhere := '';

  FStart := Date;
  FEnd := Date;
  OnLoadPopedom;
end;

procedure TfFrameSysLog.OnDestroyFrame;
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
procedure TfFrameSysLog.OnLoadPopedom;
var nStr: string;
    nIni: TIniFile;
begin
  if not gSysParam.FIsAdmin then
  begin
    nStr := gPopedomManager.FindUserPopedom(gSysParam.FUserID, 'MAIN_A01');
    BtnPrint.Enabled := Pos(sPopedom_Print, nStr) > 0;
    BtnPreview.Enabled := Pos(sPopedom_Preview, nStr) > 0;
    BtnExport.Enabled := Pos(sPopedom_Export, nStr) > 0;
  end;

  nIni := TIniFile.Create(gPath + sFormConfig);
  Visible := False;
  Application.ProcessMessages;

  ShowWaitForm(ParentForm, '��ȡ����');
  try
    gSysEntityManager.BuildViewColumn(cxView1, 'SYSLOG');
    //��ʼ����ͷ
    InitTableView(Name, cxView1, nIni);
    //��ʼ������˳��
  finally
    nIni.Free;
    Visible := True;
    CloseWaitForm;
  end;
end;

procedure TfFrameSysLog.BtnExitClick(Sender: TObject);
begin
  if not FIsBusy then Close;
end;

//------------------------------------------------------------------------------
//Desc: ��������
procedure TfFrameSysLog.InitFormData(const nWhere: string = '');
var nStr: string;
begin
  nStr := 'Select * From %s Where L_Date>=''%s'' And L_Date<=''%s''';
  nStr := Format(nStr, [sTable_SysLog, DateToStr(FStart), DateToStr(FEnd)]);
  if nWhere <> '' then nStr := nStr + ' And ' + nWhere;

  BtnRefresh.Enabled := False;
  try
    ShowMsgOnLastPanelOfStatusBar('���ڶ�ȡ����,���Ժ�...');
    FDM.QueryData(SQLQuery, nStr);
  finally
    ShowMsgOnLastPanelOfStatusBar('');
    BtnRefresh.Enabled := True;
  end;
end;

//Date: 2009-6-8
//Parm: ����ͷ�;����ṹָ��
//Desc: ִ��Sender���͵�nCmd����
function TfFrameSysLog.DealCommand(Sender: TObject; const nCmd: integer): integer;
var nParam: PFrameCommandParam;
begin
  Result := -1;
  nParam := Pointer(nCmd);

  if nParam.FCommand = cCmd_ViewSysLog then
  begin
    BringToFront;
    Application.ProcessMessages;

    FStart := Str2Date(nParam.FParamA);
    FEnd := Str2Date(nParam.FParamB);
    
    FWhere := nParam.FParamC;
    InitFormData(FWhere);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����ɸѡ
procedure TfFrameSysLog.BtnFilterClick(Sender: TObject);
begin
  inherited;
  if ShowDateFilterForm(FStart, FEnd) then InitFormData(FWhere);
end;

//Desc: ˢ��
procedure TfFrameSysLog.BtnRefreshClick(Sender: TObject);
begin
  InitFormData(FWhere);
end;

//Desc: ����
procedure TfFrameSysLog.BtnExportClick(Sender: TObject);
begin
  if SQLQuery.Active and (SQLQuery.RecordCount > 0) then
       ExportGridData(cxGrid1)
  else ShowMsg('û�п��Ե���������', sHint);
end;

//Desc: ��ӡ
procedure TfFrameSysLog.BtnPrintClick(Sender: TObject);
begin
  if SQLQuery.Active and (SQLQuery.RecordCount > 0) then
       GridPrintData(cxGrid1, TitlePanel.Caption)
  else ShowMsg('û�п��Դ�ӡ������', sHint);
end;

//Desc: Ԥ��
procedure TfFrameSysLog.BtnPreviewClick(Sender: TObject);
begin
  if SQLQuery.Active and (SQLQuery.RecordCount > 0) then
       GridPrintPreview(cxGrid1, TitlePanel.Caption)
  else ShowMsg('û�п���Ԥ��������', sHint);
end;

//Desc: ��ʾ������Ϣ
procedure TfFrameSysLog.cxView1FocusedRecordChanged(
  Sender: TcxCustomGridTableView; APrevFocusedRecord,
  AFocusedRecord: TcxCustomGridRecord;
  ANewItemRecordFocusingChanged: Boolean);
begin
  if Assigned(APrevFocusedRecord) then
    LoadDataToCtrl(SQLQuery, dxLayoutControl1);
end;

//Desc: ����
procedure TfFrameSysLog.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditMan then
  begin
    FWhere := 'L_Man like ''%' + EditMan.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditItem then
  begin
    FWhere := 'L_ItemID like ''%' + EditItem.Text + '%''';
    InitFormData(FWhere);
  end;

  TcxButtonEdit(Sender).SelectAll;
end;

//Desc: ��Ӧ�س�
procedure TfFrameSysLog.EditManKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    if Sender is TcxButtonEdit then
     TcxButtonEdit(Sender).Properties.OnButtonClick(Sender, 0);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameSysLog, TfFrameSysLog.FrameID);
end.
