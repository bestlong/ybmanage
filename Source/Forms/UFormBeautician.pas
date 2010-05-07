{*******************************************************************************
  ����: dmzn@163.com 2009-6-17
  ����: ����ʦ����
*******************************************************************************}
unit UFormBeautician;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, 
  cxMemo, cxTextEdit, cxDropDownEdit, cxContainer, cxEdit, cxMaskEdit,
  cxCalendar, cxGraphics, cxMCListBox, cxImage, cxButtonEdit;

type
  TfFormBeautician = class(TfFormNormal)
    EditType: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    InfoItems: TcxComboBox;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    EditInfo: TcxTextEdit;
    BtnAdd: TButton;
    dxLayout1Item9: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item10: TdxLayoutItem;
    ListInfo1: TcxMCListBox;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditSex: TcxComboBox;
    dxLayout1Item13: TdxLayoutItem;
    EditAge: TcxTextEdit;
    dxLayout1Item14: TdxLayoutItem;
    EditDate: TcxDateEdit;
    dxLayout1Item15: TdxLayoutItem;
    ImagePic: TcxImage;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ImagePicDblClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
  protected
    FBeauticianID: string;
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    FDefPassword: string;
    //Ĭ�Ͽ���
    FImageFile: string;
    //��Ƭ�ļ�
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
  gForm: TfFormBeautician = nil;
  
//------------------------------------------------------------------------------
class function TfFormBeautician.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormBeautician.Create(Application) do
    begin
      FBeauticianID := '';
      Caption := '����ʦ - ���';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormBeautician.Create(Application) do
    begin
      FBeauticianID := nP.FParamA;
      Caption := '����ʦ - �޸�';

      InitFormData(FBeauticianID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormBeautician.Create(Application);
        gForm.Caption := '����ʦ - �鿴';

        gForm.BtnOK.Visible := False;
        gForm.BtnAdd.Enabled := False;
        gform.BtnDel.Enabled := False;
      end;

      with gForm do
      begin
        FBeauticianID := nP.FParamA;
        InitFormData(FBeauticianID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormBeautician.FormID: integer;
begin
  Result := cFI_FormBeautician;
end;

procedure TfFormBeautician.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    LoadMCListBoxConfig(Name, ListInfo1);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'MRS');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
    FDefPassword := nIni.ReadString(Name, 'DefPassword', '111111')
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_Beautician);
end;

procedure TfFormBeautician.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self);
    SaveMCListBoxConfig(Name, ListInfo1);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
//Desc: �����Ϣ��
procedure TfFormBeautician.BtnAddClick(Sender: TObject);
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
end;

//Desc: ɾ����Ϣ��
procedure TfFormBeautician.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  ShowMsg('��Ϣ����ɾ��', sHint);
end;

//Desc: �鿴��Ϣ
procedure TfFormBeautician.ListInfo1Click(Sender: TObject);
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

//Desc: ѡ����Ƭ
procedure TfFormBeautician.ImagePicDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := '��Ƭ';
    FileName := FImageFile;
    Filter := 'ͼƬ�ļ�|*.bmp;*.png;*.jpg';

    if Execute then FImageFile := FileName;
    Free;
  end;

  if FileExists(FImageFile) then ImagePic.Picture.LoadFromFile(FImageFile);
end;

procedure TfFormBeautician.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditDate then
  begin
    nData := Date2Str(EditDate.Date);
  end;
end;

function TfFormBeautician.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditDate then
  begin
    EditDate.Date := Str2Date(nData);
  end;
end;

procedure TfFormBeautician.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Date := Date;
  
  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_Beautician)]);
    //�����ֵ�������ʦ��Ϣ��

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

  if EditType.Properties.Items.Count < 1 then
  begin
    EditType.Clear;
    nStr := 'Select T_Name From ' + sTable_BeautiType;
    //����

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        EditType.Properties.Items.Add(Fields[0].AsString);
        Next;
      end;
    end;
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where B_ID=''%s''';
    nStr := Format(nStr, [sTable_Beautician, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
    FDM.LoadDBImage(FDM.SqlTemp, 'B_Image', ImagePic.Picture);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_Beautician), MI('$ID', nID)]);
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
  end;
end;

//Desc: ������
procedure TfFormBeautician.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := RandomItemID(FPrefixID, FIDLength);
end;

//Desc: ��֤����
function TfFormBeautician.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '����д��Ч�ı��';
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '����д��Ч������';
  end else

  if Sender = EditSex then
  begin
    Result := EditSex.ItemIndex > -1;
    nHint := '��ѡ����Ч���Ա�';
  end else

  if Sender = EditAge then
  begin
    Result := IsNumber(EditAge.Text, False) and (StrToInt(EditAge.Text) < 200);
    nHint := '����д��Ч������';
  end;
end;

//Desc: ��������
procedure TfFormBeautician.BtnOKClick(Sender: TObject);
var nStr,nSQL,nTmp: string;
    i,nCount,nPos: integer;
begin
  if not IsDataValid then Exit;

  if FBeauticianID = '' then
  begin
    nStr := 'Select Count(*) From %s Where B_ID=''%s''';
    nStr := Format(nStr, [sTable_Beautician, EditID.Text]);
    //��ѯ����Ƿ����

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       ShowMsg('�ñ�ŵ�����ʦ�Ѿ�����', sHint); Exit;
     end;

    nStr := 'Select Count(*) From %s Where U_Name=''%s''';
    nStr := Format(nStr, [sTable_User, EditName.Text]);
    //��ѯ�û����Ƿ����

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditName.SetFocus;
       ShowMsg('�����Ƶ�����ʦ�Ѿ�����', sHint); Exit;
     end;

     nSQL := MakeSQLByForm(Self, sTable_Beautician, '', True, GetData);
  end else
  begin
    EditID.Text := FBeauticianID;
    nStr := 'B_ID=''' + FBeauticianID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Beautician, nStr, False, GetData);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FileExists(FImageFile) then
    begin
      nStr := 'Select * From %s Where B_ID=''%s''';
      nStr := Format(nStr, [sTable_Beautician, EditID.Text]);

      FDM.QueryTemp(nStr);
      FDM.SaveDBImage(FDM.SqlTemp, 'B_Image', FImageFile);
    end;

    if FBeauticianID = '' then
    begin
      nSQL := 'Insert Into %s(U_Name,U_Password,U_Identity,U_Group) Values(' +
              '''%s'', ''%s'', 1, %d)';
      nSQL := Format(nSQL, [sTable_User, EditName.Text ,
                            FDefPassword, cBeauticianGroup]);
      FDM.ExecuteSQL(nSQL);
    end else
    begin
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_Beautician, FBeauticianID]);
      FDM.ExecuteSQL(nSQL);
    end;

    nCount := ListInfo1.Items.Count - 1;
    for i:=0 to nCount do
    begin
      nStr := ListInfo1.Items[i];
      nPos := Pos(ListInfo1.Delimiter, nStr);

      nTmp := Copy(nStr, 1, nPos - 1);
      System.Delete(nStr, 1, nPos + Length(ListInfo1.Delimiter) - 1);

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_Beautician, EditID.Text, nTmp, nStr]);
      FDM.ExecuteSQL(nSQL);
    end;  

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('�����ѱ���', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݱ���ʧ��', 'δ֪ԭ��');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBeautician, TfFormBeautician.FormID);
end.
