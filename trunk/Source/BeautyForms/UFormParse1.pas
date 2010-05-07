{*******************************************************************************
  ����: dmzn@163.com 2009-7-8
  ����: ͼ�����
*******************************************************************************}
unit UFormParse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UBgFormBase, UTransPanel, cxGraphics, dxLayoutControl,
  cxButtonEdit, cxImage, cxMCListBox, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxContainer, cxEdit, cxMemo, StdCtrls, cxControls;

type
  TfFormParse = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    EditMemo: TcxMemo;
    InfoItems: TcxComboBox;
    EditInfo: TcxTextEdit;
    BtnAdd: TButton;
    BtnDel: TButton;
    ListInfo1: TcxMCListBox;
    ImagePic: TcxImage;
    EditID: TcxButtonEdit;
    EditPart: TcxComboBox;
    EditName: TcxTextEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Item10: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    EditHistory: TcxComboBox;
    dxLayout1Item1: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    EditDate: TcxTextEdit;
    dxLayout1Group5: TdxLayoutGroup;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure ImagePicDblClick(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditHistoryPropertiesChange(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure ImagePicEditing(Sender: TObject; var CanEdit: Boolean);
  private
    { Private declarations }
    FMemberID: string;
    //��Ա���
    FDisplayRect: TRect;
    //��ʾ����
    FPrefixID: string;
    //ǰ׺���
    FIDLength: integer;
    //ǰ׺����
    FImageChanged,FInfoChanged: Boolean;
    //���ݱ䶯
    procedure InitFormData(const nID: string);
    //��ʼ������
    function SaveData: Boolean;
    //��������
  public
    { Public declarations }
    FActiveForm: TForm;
    //�����
  end;

function ShowImageParseForm(const nMemberID: string; const nRect: TRect): TForm;
//��ں���

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UFormCtrl, UAdjustForm, USysGrid, USysDB, USysConst,
  USysFun, USysGobal, UFormEditPlan;
  
var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: ��ʾ����
//Desc: ��nRect������ʾͼ���������
function ShowImageParseForm(const nMemberID: string; const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormParse.Create(gForm);
  Result := gForm;

  with TfFormParse(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FMemberID := nMemberID;
    FDisplayRect := nRect;

    InitFormData('');
    if not Showing then Show;
  end;
end;

procedure TfFormParse.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  inherited;
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadMCListBoxConfig(Name, ListInfo1);
    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'PF');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_SkinType);
end;

procedure TfFormParse.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    gForm := nil;
    ReleaseCtrlData(Self);
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(self);

    SaveMCListBoxConfig(Name, ListInfo1);
    ReleaseCtrlData(Self);
  end;
end;

procedure TfFormParse.BtnExitClick(Sender: TObject);
begin
  CloseForm;
end;

//------------------------------------------------------------------------------
procedure TfFormParse.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Text := DateTime2Str(Now);

  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_SkinType)]);
    //�����ֵ���Ƥ��״����Ϣ��

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

  if EditPart.Properties.Items.Count < 1 then
  begin
    nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_SkinPart]);

    FDM.FillStringsData(EditPart.Properties.Items, nStr, -1, '��');
    AdjustStringsItem(EditPart.Properties.Items, False);
  end;

  if EditHistory.Properties.Items.Count < 1 then
  begin
    nStr := 'T_ID=Select T_ID,T_Name From %s Where T_MID is Null Or T_MID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, FMemberID]);

    FDM.FillStringsData(EditHistory.Properties.Items, nStr, -1, '��');
    AdjustStringsItem(EditHistory.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    FInfoChanged := False;
    FImageChanged := False;

    nStr := 'Select * From %s Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, nID]);
    
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '');
    FDM.LoadDBImage(FDM.SqlTemp, 'T_Image', ImagePic.Picture);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_SkinType), MI('$ID', nID)]);
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

//Desc: �����Ϣ��
procedure TfFormParse.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('����д �� ѡ����Ч������', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    FDM.ShowMsg('����д��Ч����Ϣ����', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
  FInfoChanged := True;
end;

//Desc: ɾ����Ϣ��
procedure TfFormParse.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    FDM.ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);
  FInfoChanged := True;

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  FDM.ShowMsg('�ѳɹ�ɾ��', sHint);
end;

//Desc: �鿴��Ϣ
procedure TfFormParse.ListInfo1Click(Sender: TObject);
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
procedure TfFormParse.ImagePicDblClick(Sender: TObject);
var nStr: string;
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := '��Ƭ';
    Filter := 'ͼƬ�ļ�|*.bmp;*.png;*.jpg';

    if Execute then nStr := FileName else nStr := '';
    Free;
  end;

  if FileExists(nStr) then
  begin
    ImagePic.Picture.LoadFromFile(nStr);
    FImageChanged := True;
  end;
end;

//Desc: ������
procedure TfFormParse.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := RandomItemID(FPrefixID, FIDLength);
end;

//Desc: ѡ�񷽰�
procedure TfFormParse.EditHistoryPropertiesChange(Sender: TObject);
begin
  InitFormData(GetCtrlData(EditHistory));
end;
 
procedure TfFormParse.ImagePicEditing(Sender: TObject;
  var CanEdit: Boolean);
begin
  FImageChanged := True;
end;

//------------------------------------------------------------------------------
//Desc: ��������
function TfFormParse.SaveData: Boolean;
var nIsNew: Boolean;
    nList: TStrings;
    i,nCount: integer;
    nStr,nSQL: string;
begin
  Result := True;
  nStr := 'Select * From %s Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_SkinType, EditID.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    if FieldByName('T_MID').AsString <> FMemberID then Exit;
    //���÷���

    if EditID.Text <> GetCtrlData(EditHistory) then
    begin
      EditID.SetFocus;
      FDM.ShowMsg('�ñ���Ѿ���ʹ��', sHint); Exit;
    end else nIsNew := False;
  end else
  begin
    nIsNew := True;
    FInfoChanged := True;
    FImageChanged := True;
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    nList := TStringList.Create;
    nList.Add('T_BID=''' + gSysParam.FBeautyID + '''');
    nList.Add('T_MID=''' + FMemberID + '''');

    nStr := 'T_ID=''' + EditID.Text + '''';
    nSQL := MakeSQLByForm(Self, sTable_SkinType, nStr, nIsNew, nil, nList);
    FDM.ExecuteSQL(nSQL);

    if FImageChanged then
    begin
      nStr := 'Select * From %s Where T_ID=''%s''';
      nStr := Format(nStr, [sTable_SkinType, EditID.Text]);

      FDM.QueryTemp(nStr);
      FDM.SaveDBImage(FDM.SqlTemp, 'T_Image', ImagePic.Picture.Graphic);
    end;

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_SkinType, 'T_ID', EditID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //��¼���

    if FInfoChanged then
    begin
      if not nIsNew then
      begin
        nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_SkinType, EditID.Text]);
        FDM.ExecuteSQL(nSQL);
      end;

      nCount := ListInfo1.Items.Count - 1;
      for i:=0 to nCount do
      begin
        nStr := ListInfo1.Items[i];
        if not SplitStr(nStr, nList, 2, ListInfo1.Delimiter) then Continue;

        nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
                'Values(''%s'', ''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_SkinType, EditID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nSQL);
      end;

      if gSysDBType = dtAccess then
      begin
        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value, S_ExtField, S_ExtValue) ' +
                'Values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_ExtInfo, 'I_ItemID', EditID.Text,
                              'I_Group', sFlag_SkinType]);
        FDM.ExecuteSQL(nSQL);
      end; //��¼���
    end; 

    FreeAndNil(nList);
    FDM.ADOConn.CommitTrans;
  except
    Result := False;
    FreeAndNil(nList);
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('����������ʧ��', 'δ֪ԭ��');
  end;
end;

//Desc: ������
procedure TfFormParse.BtnOKClick(Sender: TObject);
begin
  EditID.Text := Trim(EditID.Text);
  if EditID.Text = '' then
  begin
    EditID.SetFocus;
    FDM.ShowMsg('����д��Ч�ı��', sHint); Exit;
  end;

  EditName.Text := Trim(EditName.Text);
  if EditName.Text = '' then
  begin
    EditName.SetFocus;
    FDM.ShowMsg('����д��Ч������', sHint); Exit;
  end;

  if SaveData then
  begin
    FActiveForm := ShowPlanEditForm(FMemberID, EditID.Text, FDisplayRect);
    CloseForm;
  end;
end;

end.
