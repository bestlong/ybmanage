{*******************************************************************************
  ����: dmzn@163.com 2009-6-19
  ����: ����������
*******************************************************************************}
unit UFormPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, 
  cxMemo, cxTextEdit, cxDropDownEdit, cxContainer, cxEdit, cxMaskEdit,
  cxCalendar, cxGraphics, cxMCListBox, cxImage, cxButtonEdit, cxPC;

type
  TfFormPlan = class(TfFormNormal)
    EditName: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditPlan: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditSkin: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    EditDate: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    EditMan: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    wPage: TcxPageControl;
    dxLayout1Item15: TdxLayoutItem;
    cxSheet1: TcxTabSheet;
    cxSheet2: TcxTabSheet;
    Label1: TLabel;
    InfoItems: TcxComboBox;
    Label2: TLabel;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListInfo1: TcxMCListBox;
    ProductItmes: TcxComboBox;
    Label3: TLabel;
    BtnAdd2: TButton;
    BtnDel2: TButton;
    Label4: TLabel;
    EditReason: TcxMemo;
    ListProduct1: TcxMCListBox;
    EditInfo: TcxMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure wPageChange(Sender: TObject);
    procedure ListProduct1Click(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    FRecordID: string;
    //��ʶ
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    FDataInfoChanged,FDataProductChanged: Boolean;
    //���ݱ䶯
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //���෽��
    procedure InitFormData(const nID: string);
    //��ʼ������
    procedure GetData(Sender: TObject; var nData: string);
    //��ȡ����
    function SetData(Sender: TObject; const nData: string): Boolean;
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  IniFiles, UMgrControl, UAdjustForm, UFormCtrl, ULibFun, UDataModule,
  UFormBase, USysFun, USysGrid, USysConst, USysDB;

var
  gForm: TfFormPlan = nil;
  
//------------------------------------------------------------------------------
class function TfFormPlan.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormPlan.Create(Application) do
    begin
      FRecordID := '';
      Caption := '������ - ���';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormPlan.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '������ - �޸�';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormPlan.Create(Application);
        gForm.Caption := '������ - �鿴';

        gForm.BtnOK.Visible := False;
        gForm.BtnAdd.Enabled := False;
        gform.BtnDel.Enabled := False;
        gForm.BtnAdd2.Enabled := False;
        gform.BtnDel2.Enabled := False;
      end;

      with gForm do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormPlan.FormID: integer;
begin
  Result := cFI_FormPlan;
end;

procedure TfFormPlan.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    LoadMCListBoxConfig(Name, ListInfo1);
    LoadMCListBoxConfig(Name, ListProduct1);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'FA');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;
    
  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_Plan);
end;

procedure TfFormPlan.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    SaveMCListBoxConfig(Name, ListInfo1);
    SaveMCListBoxConfig(Name, ListProduct1);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormPlan.GetData(Sender: TObject; var nData: string);
begin

end;

function TfFormPlan.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;
end;

procedure TfFormPlan.InitFormData(const nID: string);
var nStr: string;
begin
  EditMan.Text := gSysParam.FUserName;
  EditDate.Text := DateTime2Str(Now);

  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_PlanItem)]);
    //�����ֵ��л�������Ϣ��

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        InfoItems.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if EditSkin.Properties.Items.Count < 1 then
  begin
    nStr := 'T_ID=Select T_ID,T_Name From ' + sTable_SkinType;
    FDM.FillStringsData(EditSkin.Properties.Items, nStr, -1, sDunHao);
    AdjustCXComboBoxItem(EditSkin, False);
  end;

  if EditPlan.Properties.Items.Count < 1 then
  begin
    nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_PlanItem]);

    FDM.FillStringsData(EditPlan.Properties.Items, nStr, -1, sDunHao);
    AdjustCXComboBoxItem(EditPlan, False);
  end;

  if nID <> '' then
  begin
    FDataInfoChanged := False;
    FDataProductChanged := False;

    nStr := 'Select * From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Plan, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_PlanItem), MI('$ID', nID)]);
    //��չ��Ϣ

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
  end else
  begin
    FDataInfoChanged := True;
    FDataProductChanged := True; //���ݱ䶯��ᱣ��
  end;
end;

//Desc: ҳ���л�,�����Ʒ�б�
procedure TfFormPlan.wPageChange(Sender: TObject);
var nStr: string;
begin
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

  if (FRecordID <> '') and (ListProduct1.Tag <> 27) then
  begin
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

    ListProduct1.Tag := 27;
  end;
end;

//------------------------------------------------------------------------------
//Desc: �����Ϣ��
procedure TfFormPlan.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    ShowMsg('����д �� ѡ����Ч����Ϣ��', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    ShowMsg('����д��Ч����Ϣ����', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
  FDataInfoChanged := True;
end;

//Desc: ɾ����Ϣ��
procedure TfFormPlan.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);
  FDataInfoChanged := True;

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  ShowMsg('��Ϣ����ɾ��', sHint);
end;

//Desc: �鿴��Ϣ
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

//Desc: ���Ӳ�Ʒ
procedure TfFormPlan.BtnAdd2Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if ProductItmes.ItemIndex < 0 then
  begin
    ProductItmes.SetFocus;
    ShowMsg('��ѡ����Ч�Ĳ�Ʒ', sHint); Exit;
  end;

  nList := TStringList.Create;
  try
    nStr := ProductItmes.Properties.Items[ProductItmes.ItemIndex];
    if not SplitStr(nStr, nList, 4, '|') then
    begin
      ShowMsg('��Ч�Ĳ�Ʒ��¼', sHint); Exit;
    end;

    nStr := GetCtrlData(ProductItmes) + ListProduct1.Delimiter +
            nList[1] + ListProduct1.Delimiter + EditReason.Text + ' ';
    ListProduct1.Items.Add(nStr);
    FDataProductChanged := True;
  finally
    nList.Free;
  end;
end;

//Desc: ɾ����Ʒ
procedure TfFormPlan.BtnDel2Click(Sender: TObject);
var nIdx: integer;
begin
  if ListProduct1.ItemIndex < 0 then
  begin
    ShowMsg('��ѡ��Ҫɾ���Ĳ�Ʒ', sHint); Exit;
  end;

  nIdx := ListProduct1.ItemIndex;
  ListProduct1.Items.Delete(ListProduct1.ItemIndex);
  FDataProductChanged := True;

  if nIdx >= ListProduct1.Count then Dec(nIdx);
  ListProduct1.ItemIndex := nIdx;
  ShowMsg('�ѳɹ�ɾ��', sHint);
end;

//Desc: �鿴��ϸ
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

//Desc: ������
procedure TfFormPlan.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := RandomItemID(FPrefixID, FIDLength);
end;

//------------------------------------------------------------------------------
//Desc: ��֤����
function TfFormPlan.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '����д��Ч�ķ������';
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '����д��Ч�ķ�������';
  end;
end;

//Desc: ��������
procedure TfFormPlan.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i,nCount: integer;
    nStr,nSQL: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
     nSQL := MakeSQLByForm(Self, sTable_Plan, '', True, GetData);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'P_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Plan, nStr, False, GetData);
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FDataInfoChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_PlanItem, FRecordID]);
        FDM.ExecuteSQL(nSQL);
      end;

      nList := TStringList.Create;
      nCount := ListInfo1.Items.Count - 1;

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      //xxxxx
      
      for i:=0 to nCount do
      begin
        nStr := ListInfo1.Items[i];
        if not SplitStr(nStr, nList, 2, ListInfo1.Delimiter) then Continue;

        nStr := Format(nSQL, [sTable_ExtInfo, sFlag_PlanItem,
                              EditID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    if FDataProductChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where E_Plan=''%s''';
        nSQL := Format(nSQL, [sTable_PlanExt, FRecordID]);
        FDM.ExecuteSQL(nSQL);
      end;

      if not Assigned(nList) then
        nList := TStringList.Create;
      nCount := ListProduct1.Items.Count - 1;

      nSQL := 'Insert Into %s(E_Plan, E_Product, E_Memo) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      //xxxxx
      
      for i:=0 to nCount do
      begin
        nStr := ListProduct1.Items[i];
        if not SplitStr(nStr, nList, 3, ListProduct1.Delimiter) then Continue;        

        nStr := Format(nSQL, [sTable_PlanExt, EditID.Text, nList[0], nList[2]]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    FreeAndNil(nList);
    FDM.ADOConn.CommitTrans;
    
    ModalResult := mrOK;
    ShowMsg('�����ѱ���', sHint);
  except
    FreeAndNil(nList);
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݱ���ʧ��', 'δ֪ԭ��');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormPlan, TfFormPlan.FormID);
end.
