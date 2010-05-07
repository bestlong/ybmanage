{*******************************************************************************
  ����: dmzn@163.com 2009-6-15
  ����: ��Ա����
*******************************************************************************}
unit UFormMember;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxGraphics,
  cxImage, cxDropDownEdit, cxCalendar, cxTextEdit, cxContainer, cxEdit,
  cxMaskEdit, cxButtonEdit, cxMemo, cxPC, cxMCListBox;

type
  TfFormMember = class(TfFormNormal)
    EditID: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditSex: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    EditAge: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditHeight: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditBirthday: TcxDateEdit;
    dxLayout1Item8: TdxLayoutItem;
    EditWeight: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    cxTextEdit5: TcxTextEdit;
    dxLayout1Item10: TdxLayoutItem;
    EditCDate: TcxDateEdit;
    dxLayout1Item11: TdxLayoutItem;
    cxTextEdit6: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    cxImage1: TcxImage;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    wPage: TcxPageControl;
    dxLayout1Item14: TdxLayoutItem;
    cxSheet1: TcxTabSheet;
    cxSheet2: TcxTabSheet;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    cxMemo1: TcxMemo;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    Label1: TLabel;
    InfoItems: TcxComboBox;
    Label2: TLabel;
    EditInfo: TcxTextEdit;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListInfo1: TcxMCListBox;
    Label3: TLabel;
    RelationName: TcxComboBox;
    Label4: TLabel;
    ListRelation1: TcxMCListBox;
    BtnAdd2: TButton;
    BtnDel2: TButton;
    RelationMember: TcxComboBox;
    EditBeauty: TcxTextEdit;
    dxLayout1Item16: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item17: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnOKClick(Sender: TObject);
    procedure cxImage1Click(Sender: TObject);
    procedure wPageChange(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure ListRelation1Click(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
  protected
    { Protected declarations }
    FRecordID: string;
    //��¼���
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    FImageFile: string;
    //ͼƬ�ļ�
    FDataInfoChanged,FDataRelationChanged: Boolean;
    //���ݱ䶯
    procedure InitFormData(const nID: string);
    //��������
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
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
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, UMgrControl, UFormBase,
  USysDB, USysGrid, USysConst, UDataModule;

var
  gForm: TfFormMember = nil;

//------------------------------------------------------------------------------
//Desc: ���ݻ�ԭ����
class function TfFormMember.CreateForm;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit; 

  case nP.FCommand of
   cCmd_AddData:
    with TfFormMember.Create(Application) do
    begin
      FRecordID := '';
      Caption := '��Ա - ���';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormMember.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '��Ա - �޸�';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormMember.Create(Application);
        gForm.Caption := '��Ա - �鿴';

        gForm.BtnOK.Visible := False;
        gForm.BtnAdd.Enabled := False;
        gForm.BtnDel.Enabled := False;
        gForm.BtnAdd2.Enabled := False;
        gForm.BtnDel2.Enabled := False;
      end;

      with gForm do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
  end;
end;

class function TfFormMember.FormID: integer;
begin
  Result := cFI_FormMemberData;
end;

//------------------------------------------------------------------------------
procedure TfFormMember.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self, nIni);
    LoadMCListBoxConfig(Name, ListInfo1);
    LoadMCListBoxConfig(Name, ListRelation1);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'HY');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllForm(Self, 'T', sTable_Member);
  //���ñ�����
end;

procedure TfFormMember.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    SaveFormConfig(Self, nIni);
    SaveMCListBoxConfig(Name, ListInfo1);
    SaveMCListBoxConfig(Name, ListRelation1);
  finally
    nIni.Free;
  end;

  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormMember.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditBirthday then
  begin
    nData := DateToStr(EditBirthday.Date);
  end else

  if Sender = EditCDate then
  begin
    nData := DateToStr(EditCDate.Date);
  end;
end;

function TfFormMember.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditBirthday then
  begin
    Result := True;
    EditBirthday.Date := StrToDate(nData);
  end else

  if Sender = EditCDate then
  begin
    Result := True;
    EditCDate.Date := StrToDate(nData);
  end;
end;

procedure TfFormMember.InitFormData(const nID: string);
var nStr: string;
begin
  EditCDate.Date := Date;
  EditBirthday.Date := Date;
  SetCtrlData(EditSex, sFlag_Woman);

  if gSysParam.FGroupID = IntToStr(cBeauticianGroup) then
  begin
    EditBeauty.HelpKeyword := '';
    EditBeauty.Text := gSysParam.FBeautyID;
  end else
  begin
    EditBeauty.HelpKeyword := 'NI|NU'; //�����빹��SQL
  end;

  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_MemberItem)]);
    //�����ֵ��л�Ա��Ϣ��

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
    nStr := 'Select T_Name From ' + sTable_MemberType;
    FDM.FillStringsData(EditType.Properties.Items, nStr);
  end;

  if FRecordID <> '' then
  begin
    FDataInfoChanged := False;
    FDataRelationChanged := False;

    nStr := 'Select * from %s Where M_ID=''%s''';
    nStr := Format(nStr, [sTable_Member, nID]);

    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
    FDM.LoadDBImage(FDM.SqlTemp, 'M_Image', cxImage1.Picture);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_MemberItem), MI('$ID', nID)]);
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
    FDataRelationChanged := True; //���ݱ䶯��ᱣ��
  end;
end;

//Desc: ҳ���л�,�����Ա��ϵ
procedure TfFormMember.wPageChange(Sender: TObject);
var nStr: string;
begin
  if RelationName.Properties.Items.Count < 1 then
  begin
    RelationName.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_RelationItem)]);
    //�����ֵ��л�Ա��ϵ��Ϣ��

    with FDM.QueryTemp(nStr) do
    begin
      First;

      while not Eof do
      begin
        RelationName.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if RelationMember.Properties.Items.Count < 1 then
  begin
    nStr := 'M_ID=Select M_ID, M_Name From $Mem';
    nStr := MacroValue(nStr, [MI('$Mem', sTable_Member)]);
    if FRecordID <> '' then nStr := nStr + ' Where M_ID<>''' + FRecordID + '''';
    
    FDM.FillStringsData(RelationMember.Properties.Items, nStr);
    AdjustCXComboBoxItem(RelationMember, False);
  end;

  if (FRecordID <> '') and (ListRelation1.Tag <> 27) then
  begin
    nStr := 'Select E_FID, E_Relation, E_BID,' +
            ' (Select M_Name From $Mem Where M_ID=t.E_FID) as E_FName, ' +
            ' (Select M_Name From $Mem Where M_ID=t.E_BID) as E_BName ' +
            'From $Ext t Where E_FID=''$ID'' Or E_BID=''$ID''';

    nStr := MacroValue(nStr, [MI('$Mem', sTable_Member),
                              MI('$Ext', sTable_MemberExt), MI('$ID', FRecordID)]);
    ListRelation1.Clear;

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        if FieldByName('E_FID').AsString = FRecordID then
        begin
          nStr := FieldByName('E_Relation').AsString + ListRelation1.Delimiter +
                  FieldByName('E_BName').AsString + ' ' + ListRelation1.Delimiter +
                  FieldByName('E_BID').AsString;
        end else
        begin
          nStr := FieldByName('E_Relation').AsString + ListRelation1.Delimiter +
                  FieldByName('E_FName').AsString + ' ' + ListRelation1.Delimiter +
                  FieldByName('E_FID').AsString;
        end;

        ListRelation1.Items.Add(nStr);
        Next;
      end;
    end;

    ListRelation1.Tag := 27;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����������
procedure TfFormMember.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr,nChar: string;
    nIdx,nMid: integer;
begin
  nStr := FloatToStr(Now);
  nMid := Round(Length(nStr) / 2);

  for nIdx:=1 to nMid do
  begin
    nChar := nStr[nIdx];
    nStr[nIdx] := nStr[2 * nMid - nIdx];
    nStr[2 * nMid - nIdx] := nChar[1];
  end;

  EditID.Text := FPrefixID + Copy(nStr, 1, FIDLength - Length(FPrefixID));
end;

procedure TfFormMember.cxImage1Click(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    FileName := FImageFile;
    Title := 'ѡ����Ƭ';
    Filter := 'ͼƬ|*.bmp;*.jpg;*.png';

    if Execute then
    try
      cxImage1.Picture.LoadFromFile(FileName);
      FImageFile := FileName;
    except

    end;
    Free;
  end;
end;

//Desc: �����Ϣ��
procedure TfFormMember.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    ShowMsg('����д��Ч����Ϣ��', sHint); Exit;
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
procedure TfFormMember.BtnDelClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ListInfo1.SetFocus;
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
procedure TfFormMember.ListInfo1Click(Sender: TObject);
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

//Desc: ��ӻ�Ա��ϵ
procedure TfFormMember.BtnAdd2Click(Sender: TObject);
var nStr: string;
begin
  RelationName.Text := Trim(RelationName.Text);
  if RelationName.Text = '' then
  begin
    RelationName.SetFocus;
    ShowMsg('����д��Ч�Ĺ�ϵ����', sHint); Exit;
  end;

  RelationMember.Text := Trim(RelationMember.Text);
  if RelationMember.Text = '' then
  begin
    RelationMember.SetFocus;
    ShowMsg('��ѡ����Ч�Ĺ�ϵ��Ա', sHint); Exit;
  end;

  nStr := RelationMember.Text;
  System.Delete(nStr, 1, Pos('|', nStr));
  nStr := Trim(nStr); //��Ա��

  nStr := RelationName.Text + ListRelation1.Delimiter + nStr + ' ' +
          ListRelation1.Delimiter + GetCtrlData(RelationMember);

  ListRelation1.Items.Add(nStr);
  FDataRelationChanged := True;
end;

//Desc: ɾ����ϵ
procedure TfFormMember.BtnDel2Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListRelation1.ItemIndex < 0 then
  begin
    ListRelation1.SetFocus;
    ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
  end;

  nIdx := ListRelation1.ItemIndex;
  ListRelation1.Items.Delete(ListRelation1.ItemIndex);
  FDataRelationChanged := True;

  if nIdx >= ListRelation1.Count then Dec(nIdx);
  ListRelation1.ItemIndex := nIdx;
  ShowMsg('��Ϣ����ɾ��', sHint);
end;

//Desc: �鿴��ϵ
procedure TfFormMember.ListRelation1Click(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  nList := nil;
  if ListRelation1.ItemIndex > -1 then
  try
    nList := TStringList.Create;
    nStr := ListRelation1.Items[ListRelation1.ItemIndex];

    if SplitStr(nStr, nList, 3, ListRelation1.Delimiter) then
    begin
      RelationName.Text := nList[0];
      SetCtrlData(RelationMember, nList[2]);
    end;
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��֤����
function TfFormMember.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '����д��Ч�Ļ�Ա���';
  end else

  if Sender = EditSex then
  begin
    Result := EditSex.ItemIndex > -1;
    nHint := '��ѡ����Ч���Ա�';
  end else

  if Sender = EditAge then
  begin
    Result := IsNumber(EditAge.Text, False);
    nHint := '����д��Ч������';
  end else

  if Sender = EditHeight then
  begin
    Result := IsNumber(EditHeight.Text, False);
    nHint := '����д��Ч�����';
  end else

  if Sender = EditWeight then
  begin
    Result := IsNumber(EditWeight.Text, False);
    nHint := '����д��Ч������';
  end;
end;

//Desc: ��������
procedure TfFormMember.BtnOKClick(Sender: TObject);
var nList: TStrings;
    i,nCount: integer;
    nStr,nSQL: string;
begin
  if not IsDataValid then Exit;

  if FRecordID = '' then
  begin
    nStr := 'Select Count(*) From %s Where M_ID=''%s''';
    nStr := Format(nStr, [sTable_Member, EditID.Text]);
    //��ѯ����Ƿ����

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       ShowMsg('�ñ�ŵĻ�Ա�Ѿ�����', sHint); Exit;
     end;

     nSQL := MakeSQLByForm(Self, sTable_Member, '', True, GetData);
  end else
  begin
    EditID.Text := FRecordID;
    nStr := 'M_ID=''' + FRecordID + '''';
    nSQL := MakeSQLByForm(Self, sTable_Member, nStr, False, GetData);
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FileExists(FImageFile) then
    begin
      nStr := 'Select M_ID,M_Image From %s Where M_ID=''%s''';
      nStr := Format(nStr, [sTable_Member, EditID.Text]);

      FDM.QueryTemp(nStr);
      FDM.SaveDBImage(FDM.SqlTemp, 'M_Image', FImageFile);
    end;

    if FDataInfoChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_MemberItem, FRecordID]);
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

        nStr := Format(nSQL, [sTable_ExtInfo, sFlag_MemberItem,
                              EditID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    if FDataRelationChanged then
    begin
      if FRecordID <> '' then
      begin
        nSQL := 'Delete From %s Where E_FID=''%s'' Or E_BID=''%s''';
        nSQL := Format(nSQL, [sTable_MemberExt, FRecordID, FRecordID]);
        FDM.ExecuteSQL(nSQL);
      end;

      if not Assigned(nList) then
        nList := TStringList.Create;
      nCount := ListRelation1.Items.Count - 1;

      nSQL := 'Insert Into %s(E_FID, E_Relation, E_BID) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      //xxxxx
      
      for i:=0 to nCount do
      begin
        nStr := ListRelation1.Items[i];
        if not SplitStr(nStr, nList, 3, ListRelation1.Delimiter) then Continue;

        nStr := Format(nSQL, [sTable_MemberExt, EditID.Text, nList[0], nList[2]]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    FreeAndNil(nList);
    FDM.ADOConn.CommitTrans;

    ModalResult := mrOK;
    ShowMsg('�����ѱ���', sHint);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    ShowMsg('���ݱ���ʧ��', 'δ֪ԭ��');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormMember, TfFormMember.FormID);
end.
