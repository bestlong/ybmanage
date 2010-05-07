{*******************************************************************************
  ����: dmzn@163.com 2009-6-14
  ����: ��Ա����
*******************************************************************************}
unit UFramMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFrameNormal, cxStyles, cxCustomData, cxGraphics, cxFilter,
  cxData, cxDataStorage, cxEdit, DB, cxDBData, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxTextEdit, ADODB, cxContainer, cxLabel, cxGridLevel,
  cxClasses, cxControls, cxGridCustomView, cxGridCustomTableView,
  cxGridTableView, cxGridDBTableView, cxGrid, ComCtrls, ToolWin, Menus;

type
  TfFrameMember = class(TfFrameNormal)
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
    procedure cxView1DblClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
  protected
    { Protected declarations }
    function InitFormDataSQL(const nWhere: string): string; override;
  public
    { Public declarations }
    class function FrameID: integer; override;
    function DealCommand(Sender: TObject; const nCmd: integer): integer; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrControl, ULibFun, UFormBase, USysDB, USysConst, UDataModule;

//------------------------------------------------------------------------------
class function TfFrameMember.FrameID: integer;
begin
  Result := cFI_FrameMember;
end;

function TfFrameMember.InitFormDataSQL(const nWhere: string): string;
var nIsBeauty: Boolean;
begin
  Result := 'Select * From ' + sTable_Member;
  nIsBeauty := gSysParam.FGroupID = IntToStr(cBeauticianGroup);

  if nIsBeauty then
    Result := Result + ' Where M_Beautician=''' + gSysParam.FBeautyID + '''';
  //��ʾ�������

  if nWhere <> '' then
   if nIsBeauty then
        Result := Result + ' And (' + nWhere + ')'
   else Result := Result + ' Where ' + nWhere;
end;

//Desc: ��������
function TfFrameMember.DealCommand(Sender: TObject; const nCmd: integer): integer;
begin
  Result := -1;
  if (Sender is TBaseForm) and (TBaseForm(Sender).FormID = cFI_FormMemberOwner) then
    InitFormData(FWhere);
end;

procedure TfFrameMember.BtnExitClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  if not IsBusy then
  begin
    nParam.FCommand := cCmd_FormClose;
    CreateBaseFormItem(cFI_FormProduct, '', @nParam); Close;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFrameMember.BtnAddClick(Sender: TObject);
var nParam: TFormCommandParam;
begin
  nParam.FCommand := cCmd_AddData;
  CreateBaseFormItem(cFI_FormMemberData, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData('');
  end;
end;

procedure TfFrameMember.BtnEditClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫ�༭�ļ�¼', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('M_ID').AsString;
  nParam.FCommand := cCmd_EditData;
  nParam.FParamA := nStr;
  CreateBaseFormItem(cFI_FormMemberData, PopedomItem, @nParam);

  if (nParam.FCommand = cCmd_ModalResult) and (nParam.FParamA = mrOK) then
  begin
    InitFormData(FWhere);
  end;
end;

procedure TfFrameMember.BtnDelClick(Sender: TObject);
var nStr,nSQL: string;
begin
  if cxView1.DataController.GetSelectedCount < 1 then
  begin
    ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
  end;

  nStr := SQLQuery.FieldByName('M_Name').AsString;
  if not QueryDlg('ȷ��Ҫɾ������Ϊ[ ' + nStr + ' ]�Ļ�Ա��', sAsk) then Exit;

  nStr := SQLQuery.FieldByName('M_ID').AsString;
  nSQL := 'Select Count(*) From %s Where E_FID=''%s'' Or E_BID=''%s''';
  nSQL := Format(nSQL, [sTable_MemberExt, nStr, nStr]);

  with FDM.QueryTemp(nSQL) do
  if Fields[0].AsInteger > 0 then
  begin
    nStr := '�û�Ա��������Ա��"��ϵ��Ա",ɾ�����ϵ���Զ����.' + #13#10 +
            'Ҫ����ɾ����?';
    if not QueryDlg(nStr, sAsk, Handle) then Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    nStr := SQLQuery.FieldByName('M_ID').AsString;
    nSQL := 'Delete From %s Where M_ID=''%s''';
    nSQL := Format(nSQL, [sTable_Member, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
    nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_MemberItem, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where E_FID=''%s'' Or E_BID=''%s''';
    nSQL := Format(nSQL, [sTable_MemberExt, nStr, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where P_MID=''%s''';
    nSQL := Format(nSQL, [sTable_PickImage, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where T_MID=''%s''';
    nSQL := Format(nSQL, [sTable_SkinType, nStr]);
    FDM.ExecuteSQL(nSQL);

    nSQL := 'Delete From %s Where U_MID=''%s''';
    nSQL := Format(nSQL, [sTable_PlanUsed, nStr]);
    FDM.ExecuteSQL(nSQL);

    FDM.ADOConn.CommitTrans;
    InitFormData(FWhere);
    ShowMsg('�ѳɹ�ɾ����¼', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('ɾ����¼ʧ��', 'δ֪����');
  end;
end;

//Desc: ����
procedure TfFrameMember.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = EditID then
  begin
    FWhere := 'M_ID like ''%' + EditID.Text + '%''';
    InitFormData(FWhere);
  end else

  if Sender = EditName then
  begin
    FWhere := 'M_Name like ''%' + EditName.Text + '%''';
    InitFormData(FWhere);
  end;
end;

//Desc: �鿴����
procedure TfFrameMember.cxView1DblClick(Sender: TObject);
var nStr: string;
    nParam: TFormCommandParam;
begin
  if cxView1.DataController.GetSelectedCount > 0 then
  begin
    nStr := SQLQuery.FieldByName('M_ID').AsString;
    nParam.FCommand := cCmd_ViewData;
    nParam.FParamA := nStr;
    CreateBaseFormItem(cFI_FormMemberData, PopedomItem, @nParam);
  end;
end;

//Desc: ����˵�
procedure TfFrameMember.N1Click(Sender: TObject);
var nParam: TFormCommandParam;
begin
  case (Sender as TComponent).Tag of
    10: //�鿴����
     cxView1DblClick(nil);
    20: //����
     if cxView1.DataController.GetSelectedCount > 0 then
     begin
       FillChar(nParam, SizeOf(nParam), #0);
       nParam.FCommand := cCmd_EditData;
       nParam.FParamA := SQLQuery.FieldByName('M_ID').AsString;
       CreateBaseFormItem(cFI_FormMemberOwner, PopedomItem, @nParam);
     end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFrameMember, TfFrameMember.FrameID);
end.
