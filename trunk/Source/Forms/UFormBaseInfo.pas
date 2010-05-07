{*******************************************************************************
  ����: dmzn@163.com 2009-06-19
  ����: ������Ϣ����
*******************************************************************************}
unit UFormBaseInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  USysDataFun, UFormBase, ComCtrls, dxLayoutControl, StdCtrls, cxMemo,
  cxEdit, cxTextEdit, cxMCListBox, cxContainer, cxTreeView, cxControls,
  cxMaskEdit, cxButtonEdit, Menus;

type
  TfFormBaseInfo = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    InfoTv1: TcxTreeView;
    dxLayout1Item1: TdxLayoutItem;
    InfoList1: TcxMCListBox;
    dxLayout1Item2: TdxLayoutItem;
    EditText: TcxTextEdit;
    dxItemName: TdxLayoutItem;
    EditPY: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item7: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item8: TdxLayoutItem;
    BtnSave: TButton;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    EditSearch: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure InfoTv1Deletion(Sender: TObject; Node: TTreeNode);
    procedure InfoTv1Change(Sender: TObject; Node: TTreeNode);
    procedure InfoList1Click(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure EditTextExit(Sender: TObject);
    procedure InfoTv1Click(Sender: TObject);
    procedure InfoTv1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure InfoTv1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure InfoTv1DblClick(Sender: TObject);
    procedure EditSearchPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditSearchKeyPress(Sender: TObject; var Key: Char);
    procedure N2Click(Sender: TObject);
  protected
    FGroup: string;
    //����
    FSelected,FChanged: Boolean;
    //ѡ��ģʽ,�����б䶯
    FNodeCanDispose: Boolean;
    //�ڵ���ͷ�
    procedure OnLoadPopedom; override;
    //����Ȩ��
    procedure ChangeNodeIndex;
    //�ڵ�����
    procedure LoadInfoData(const nGroup: string);
    //��ȡ����
    procedure GetSelectedData(const nInfo: PBaseInfoData);
    //��ȡ����
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UMgrControl, UFormInputBox, UDataModule, USysPopedom, ULibFun,
  USysGrid, USysDB, USysConst;

//------------------------------------------------------------------------------
class function TfFormBaseInfo.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  nP := nParam;
  Result := nil;

  with TfFormBaseInfo.Create(Application) do
  begin
    if nPopedom = 'MAIN_D01' then
    begin
      Caption := '��Ʒ����';
      dxItemName.Caption := '��������:';
      FGroup := sFlag_ProductType;
    end else

    if nPopedom = 'MAIN_E01' then
    begin
      Caption := 'Ƥ����λ';
      dxItemName.Caption := '��λ����:';
      FGroup := sFlag_SkinPart;
    end else

    if nPopedom = 'MAIN_E03' then
    begin
      Caption := '��������';
      dxItemName.Caption := '��������:';
      FGroup := sFlag_PlanItem;
    end;

    PopedomItem := nPopedom;
    LoadInfoData(FGroup);
    FSelected := Assigned(nP);

    if (ShowModal = mrOK) and FSelected then
    begin
      GetSelectedData(Pointer(Integer(nP.FParamA)));
    end;
    Free;
  end;
end;

class function TfFormBaseInfo.FormID: integer;
begin
  Result := cFI_FormBaseInfo;
end;

procedure TfFormBaseInfo.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  FChanged := False;
  FSelected := False;
  
  FNodeCanDispose := True;
  BtnSave.Enabled := False;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;
end;

procedure TfFormBaseInfo.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, InfoList1, nIni);
  finally
    nIni.Free;
  end;
end;

//Desc: ����Ȩ��
procedure TfFormBaseInfo.OnLoadPopedom;
var nStr: string;
begin
  if not gSysParam.FIsAdmin then
  begin
    nStr := gPopedomManager.FindUserPopedom(gSysParam.FUserID, FPopedom);
    BtnAdd.Enabled := Pos(sPopedom_Add, nStr) > 0;
    BtnDel.Enabled := Pos(sPopedom_Delete, nStr) > 0;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ȡ����
procedure TfFormBaseInfo.LoadInfoData(const nGroup: string);
var nStr: string;
    i,nCount: integer;
    nData: PBaseInfoData;
begin
  BuildBaseInfoTree(InfoTv1.InnerTreeView, nGroup);
  InfoList1.Clear;
  nCount := InfoTv1.Items.Count - 1;

  for i:=0 to nCount do
  begin
    nData := InfoTv1.Items[i].Data;
    nStr := IntToStr(nData.FID) + InfoList1.Delimiter +
            nData.FText + InfoList1.Delimiter + nData.FMemo + ' ';
    InfoList1.Items.Add(nStr);
  end;
end;

//Desc: ��ȡѡ�нڵ������
procedure TfFormBaseInfo.GetSelectedData(const nInfo: PBaseInfoData);
var nData: PBaseInfoData;
begin
  if Assigned(InfoTv1.Selected) and Assigned(InfoTv1.Selected.Data) then
  begin
    nData := InfoTv1.Selected.Data;

    nInfo.FSub := nil;
    nInfo.FID := nData.FID;
    nInfo.FPID := nData.FPID;
    nInfo.FIndex := nData.FIndex;

    nInfo.FText := nData.FText;
    nInfo.FPY := nData.FPY;
    nInfo.FMemo := nData.FMemo;
    nInfo.FPText := nData.FPText;
    nInfo.FGroup := nData.FGroup;
  end;
end;

//Desc: �ͷ���Դ
procedure TfFormBaseInfo.InfoTv1Deletion(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node.Data) and FNodeCanDispose then
  try
    DisposeBaseInfoData(Node.Data);
  except
    //ignor any error
  end;
end;

//Desc: �ڵ�ı�
procedure TfFormBaseInfo.InfoTv1Change(Sender: TObject; Node: TTreeNode);
var nData: PBaseInfoData;
begin
  if Assigned(Node) then
  begin
    if not BtnAdd.Enabled then Exit;
    //���״̬���ø���

    nData := Node.Data;
    EditText.Text := nData.FText;
    EditPy.Text := nData.FPY;
    EditMemo.Text := nData.FMemo;
  end else
  begin
    EditText.Clear;
    EditPy.Clear;
    EditMemo.Clear;
  end;

  if InfoTv1.Focused then InfoList1.ItemIndex := -1;
end;

//Desc: �ڵ�ı�
procedure TfFormBaseInfo.InfoList1Click(Sender: TObject);
var nStr: string;
    i,nCount,nID: integer;
begin
  if InfoList1.ItemIndex < 0 then Exit;
  nStr := InfoList1.Items[InfoList1.ItemIndex];
  nStr := Copy(nStr, 1, Pos(InfoList1.Delimiter, nStr) - 1);

  if IsNumber(nStr, False) then
       nID := StrToInt(nStr)
  else Exit;

  nCount := InfoTv1.Items.Count - 1;
  for i:=0 to nCount do
   if PBaseInfoData(InfoTv1.Items[i].Data).FID = nID then
  begin
    InfoTv1.Items[i].Selected := True;
    InfoTv1.Items[i].MakeVisible;
  end;
end;

//Desc: ����
procedure TfFormBaseInfo.EditSearchPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var i,nCount: integer;
    nData: PBaseInfoData;
begin
  EditSearch.Text := Trim(EditSearch.Text);
  if EditSearch.Text = '' then
  begin
    EditSearch.SetFocus;
    ShowMsg('����д��ѯ����', sHint); Exit;
  end;

  nCount := InfoTv1.Items.Count - 1;       
  for i:=0 to nCount do
  begin
    nData := InfoTv1.Items[i].Data;
    if (Pos(LowerCase(EditSearch.Text), LowerCase(nData.FText)) > 0) or
       (Pos(LowerCase(EditSearch.Text), LowerCase(nData.FPY)) > 0) then
    begin
      InfoTv1.Items[i].Selected := True;
      InfoTv1.Items[i].MakeVisible; Break;
    end;
  end;
end;

procedure TfFormBaseInfo.EditSearchKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    EditSearch.Properties.OnButtonClick(Sender, 0);
    EditSearch.SelectAll;
  end;
end;

//Desc: �ı�ڵ�����
procedure TfFormBaseInfo.ChangeNodeIndex;
var nStr,nIdx: string;
    nP: PBaseInfoData;
begin
  if Assigned(InfoTv1.Selected) then
  begin
    nP := InfoTv1.Selected.Data;
    nIdx := FloatToStr(nP.FIndex);
    
    nStr := '������ڵ��λ������:';
    if not ShowInputBox(nStr, '�ڵ�λ��', nIdx) then Exit;
    if not IsNumber(nIdx, True) then Exit;

    nStr := 'Update %s Set B_Index=%s Where B_ID=%s';
    nStr := Format(nStr, [sTable_BaseInfo, nIdx, IntToStr(nP.FID)]);
    
    FDM.ExecuteSQL(nStr);
    LoadInfoData(FGroup);
  end;
end;

//Desc: ����˵�
procedure TfFormBaseInfo.N2Click(Sender: TObject);
begin
  case (Sender as TComponent).Tag of
   10: InfoTv1.FullExpand;
   20: InfoTv1.FullCollapse;
   30: ChangeNodeIndex;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ���
procedure TfFormBaseInfo.BtnAddClick(Sender: TObject);
begin
  BtnSave.Enabled := True;
  BtnAdd.Enabled := False;

  BtnDel.Caption := 'ȡ��';
  BtnDel.Tag := 20;

  EditText.Clear;
  EditText.SetFocus;
  EditPY.Clear;
  EditMemo.Clear;
end;

//Desc: ɾ��
procedure TfFormBaseInfo.BtnDelClick(Sender: TObject);
var nStr: string;
    nNode: TTreeNode;
    nData: PBaseInfoData;
begin
  if BtnDel.Tag > 0 then
  begin
    BtnSave.Enabled := False;
    BtnAdd.Enabled := True;

    BtnDel.Caption := 'ɾ��';
    BtnDel.Tag := 0; Exit;
  end;

  if not Assigned(InfoTv1.Selected) then
  begin
    ShowMsg('��ѡ��Ҫɾ���Ľڵ�', sHint); Exit;
  end;

  nData := InfoTv1.Selected.Data;
  nStr := 'ȷ��Ҫɾ������Ϊ[ %s ]�Ľڵ���?���ӽڵ�Ҳ�ᱻһ��ɾ��.';
  
  nStr := Format(nStr, [nData.FText]);
  if not QueryDlg(nStr, sAsk, Handle) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nNode := InfoTv1.Selected;
    while Assigned(nNode) do
    begin
      nData := nNode.Data;
      nStr := 'Delete From %s Where B_ID=%s';
      nStr := Format(nStr, [sTable_BaseInfo, IntToStr(nData.FID)]);
      FDM.ExecuteSQL(nStr);

      nNode := nNode.GetNext;
      if Assigned(nNode) and (nNode.Level = InfoTv1.Selected.Level) then Break;
    end;

    FDM.ADOConn.CommitTrans;
    LoadInfoData(FGroup);
    FChanged := True;
    ShowMsg('�ѳɹ�ɾ��', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('ɾ������ʧ��', 'δ֪����');
  end;
end;

//Desc: ��ȡƴ����д
procedure TfFormBaseInfo.EditTextExit(Sender: TObject);
begin
  EditPY.Text := GetPinYinOfStr(EditText.Text);
end;

//Desc: �հ׵�����ʱ,�ÿ�ѡ�нڵ�
procedure TfFormBaseInfo.InfoTv1Click(Sender: TObject);
var nP: TPoint;
begin
  GetCursorPos(nP);
  nP := InfoTv1.ScreenToClient(nP);
  if InfoTv1.GetNodeAt(nP.X, nP.Y) = nil then InfoTv1.Selected := nil;
end;

//Desc: ˫��ѡ��
procedure TfFormBaseInfo.InfoTv1DblClick(Sender: TObject);
begin
  if Assigned(InfoTv1.Selected) and FSelected then ModalResult := mrOK;
end;

//Desc: ����
procedure TfFormBaseInfo.BtnSaveClick(Sender: TObject);
var nStr,nPID: string;
begin
  EditText.Text := Trim(EditText.Text);
  if EditText.Text = '' then
  begin
    EditText.SetFocus;
    ShowMsg('����д��Ч������', sHint); Exit;
  end;

  if Assigned(InfoTv1.Selected) then
       nPID := IntToStr(PBaseInfoData(InfoTv1.Selected.Data).FID)
  else nPID := '0';

  nStr := 'Insert Into %s(B_Group,B_Text,B_Py,B_Memo,B_PID) Values(' +
          '''%s'', ''%s'', ''%s'', ''%s'', %s)';
  nStr := Format(nStr, [sTable_BaseInfo, FGroup, EditText.Text,
                        Trim(EditPY.Text), Trim(EditMemo.Text), nPID]);

  try
    FDM.ExecuteSQL(nStr);
    LoadInfoData(FGroup);
    FChanged := True;
    ShowMsg('�ѳɹ�����', sHint);
  except
    ShowMsg('���ݱ���ʧ��', 'δ֪����');
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormBaseInfo.InfoTv1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  Accept := Assigned(InfoTv1.Selected) and (not InfoTv1.Selected.HasChildren);
end;

//Desc: ����
procedure TfFormBaseInfo.InfoTv1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var nSLevel: Boolean;
    nStr,nSQL: string;
    nData: PBaseInfoData;
    nNode,nNew: TTreeNode;
begin
  nNode := InfoTv1.GetNodeAt(X, Y);
  if not Assigned(nNode) then Exit;

  nSLevel := InfoTv1.Selected.Parent = nNode.Parent;
  if nSLevel then
       nNew := InfoTv1.Items.Insert(nNode, InfoTv1.Selected.Text)
  else nNew := InfoTv1.Items.AddChild(nNode, InfoTv1.Selected.Text);
  //ͬ���ƶ�,�缶���

  FDM.ADOConn.BeginTrans;
  try
    nNew.Assign(InfoTv1.Selected);
    FNodeCanDispose := False;
    InfoTv1.Selected.Delete;
    FNodeCanDispose := True;
    
    if nSLevel then
         PBaseInfoData(nNew.Data).FPID := PBaseInfoData(nNode.Data).FPID
    else PBaseInfoData(nNew.Data).FPID := PBaseInfoData(nNode.Data).FID;

    if nSLevel then
    begin
      nNode := nNew.Parent;
      if Assigned(nNode) then
           nNode := nNode.getFirstChild
      else nNode := InfoTv1.Items.GetFirstNode;

      nStr := 'Update %s Set B_Index=%d Where B_ID=%d';
      while Assigned(nNode) do
      begin
        nData := nNode.Data;
        nSQL := Format(nStr, [sTable_BaseInfo, nNode.Index, nData.FID]);

        FDM.ExecuteSQL(nSQL);
        nNode := nNode.getNextSibling;
      end;
    end else
    begin
      nData := nNew.Data;
      nStr := 'Update %s Set B_PID=%d where B_ID=%d';
      nSQL := Format(nStr, [sTable_BaseInfo, nData.FPID, nData.FID]);
      FDM.ExecuteSQL(nSQL);
    end;

    FDM.ADOConn.CommitTrans;
    FChanged := True;
    nNew.Selected := True;
    nNew.MakeVisible;
  except
    FNodeCanDispose := True;
    if FDM.ADOConn.InTransaction then FDM.ADOConn.RollbackTrans;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBaseInfo, TfFormBaseInfo.FormID);
end.
