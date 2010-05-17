{*******************************************************************************
  作者: dmzn@163.com 2009-6-19
  描述: 皮肤状况管理
*******************************************************************************}
unit UFormSkinType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, 
  cxMemo, cxTextEdit, cxDropDownEdit, cxContainer, cxEdit, cxMaskEdit,
  cxCalendar, cxGraphics, cxMCListBox, cxImage, cxButtonEdit;

type
  TfFormSkinType = class(TfFormNormal)
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
    ImagePic: TcxImage;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    EditID: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    EditPart: TcxComboBox;
    dxLayout1Item12: TdxLayoutItem;
    EditName: TcxTextEdit;
    dxLayout1Item13: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure ImagePicDblClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure EditIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  protected
    FSkinTypeID: string;
    //标识
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    FImageFile: string;
    //照片文件
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //基类方法
    procedure InitFormData(const nID: string);
    //初始化数据
    procedure GetData(Sender: TObject; var nData: string);
    //获取数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
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
  gForm: TfFormSkinType = nil;
  
//------------------------------------------------------------------------------
class function TfFormSkinType.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormSkinType.Create(Application) do
    begin
      FSkinTypeID := '';
      Caption := '皮肤状况 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormSkinType.Create(Application) do
    begin
      FSkinTypeID := nP.FParamA;
      Caption := '皮肤状况 - 修改';

      InitFormData(FSkinTypeID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormSkinType.Create(Application);
        gForm.Caption := '皮肤状况 - 查看';

        gForm.BtnOK.Visible := False;
        gForm.BtnAdd.Enabled := False;
        gform.BtnDel.Enabled := False;
      end;

      with gForm do
      begin
        FSkinTypeID := nP.FParamA;
        InitFormData(FSkinTypeID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
   cCmd_FormClose:
    begin
      if Assigned(gForm) then FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormSkinType.FormID: integer;
begin
  Result := cFI_FormSkinType;
end;

procedure TfFormSkinType.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    LoadFormConfig(Self);
    LoadMCListBoxConfig(Name, ListInfo1);

    FPrefixID := nIni.ReadString(Name, 'IDPrefix', 'PF');
    FIDLength := nIni.ReadInteger(Name, 'IDLength', 8);
  finally
    nIni.Free;
  end;

  AdjustCtrlData(Self);
  ResetHintAllCtrl(Self, 'T', sTable_SkinType);
end;

procedure TfFormSkinType.FormClose(Sender: TObject;
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
procedure TfFormSkinType.GetData(Sender: TObject; var nData: string);
begin

end;

function TfFormSkinType.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;
end;

procedure TfFormSkinType.InitFormData(const nID: string);
var nStr: string;
begin
  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_SkinType)]);
    //数据字典中皮肤状况信息项

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

    FDM.FillStringsData(EditPart.Properties.Items, nStr, -1, sDunHao);
    AdjustStringsItem(EditPart.Properties.Items, False);
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, nID]);
    
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
    FDM.LoadDBImage(FDM.SqlTemp, 'T_Image', ImagePic.Picture);

    ListInfo1.Clear;
    nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                       MI('$Group', sFlag_SkinType), MI('$ID', nID)]);
    //扩展信息

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

//------------------------------------------------------------------------------
//Desc: 添加信息项
procedure TfFormSkinType.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    ShowMsg('请填写 或 选择有效的名称', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    ShowMsg('请填写有效的信息内容', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
end;

//Desc: 删除信息项
procedure TfFormSkinType.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  ShowMsg('已成功删除', sHint);
end;

//Desc: 查看信息
procedure TfFormSkinType.ListInfo1Click(Sender: TObject);
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

//Desc: 选择照片
procedure TfFormSkinType.ImagePicDblClick(Sender: TObject);
begin
  with TOpenDialog.Create(Application) do
  begin
    Title := '照片';
    FileName := FImageFile;
    Filter := '图片文件|*.bmp;*.png;*.jpg';

    if Execute then FImageFile := FileName;
    Free;
  end;

  if FileExists(FImageFile) then ImagePic.Picture.LoadFromFile(FImageFile);
end;

//Desc: 随机编号
procedure TfFormSkinType.EditIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  EditID.Text := FDM.GetRandomID(FPrefixID, FIDLength);
end;

//------------------------------------------------------------------------------
//Desc: 验证数据
function TfFormSkinType.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '请填写有效的编号';
  end else

  if Sender = EditName then
  begin
    EditName.Text := Trim(EditName.Text);
    Result := EditName.Text <> '';
    nHint := '请填写有效的名称';
  end;
end;

//Desc: 保存数据
procedure TfFormSkinType.BtnOKClick(Sender: TObject);
var i,nCount,nPos: integer;
    nStr,nSQL,nTmp: string;
begin
  if not IsDataValid then Exit;

  if FSkinTypeID = '' then
  begin
    nStr := 'Select Count(*) From %s Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, EditID.Text]);
    //查询编号是否存在

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       ShowMsg('该编号的记录已经存在', sHint); Exit;
     end;

     nSQL := MakeSQLByForm(Self, sTable_SkinType, '', True, GetData);
  end else
  begin
    EditID.Text := FSkinTypeID;
    nStr := 'T_ID=''' + FSkinTypeID + '''';
    nSQL := MakeSQLByForm(Self, sTable_SkinType, nStr, False, GetData);
  end;

  FDM.ADOConn.BeginTrans;
  try
    FDM.ExecuteSQL(nSQL);

    if FileExists(FImageFile) then
    begin
      nStr := 'Select * From %s Where T_ID=''%s''';
      nStr := Format(nStr, [sTable_SkinType, EditID.Text]);

      FDM.QueryTemp(nStr);
      FDM.SaveDBImage(FDM.SqlTemp, 'T_Image', FImageFile);
    end;

    if FSkinTypeID <> '' then
    begin
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_SkinType, FSkinTypeID]);
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
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_SkinType, EditID.Text, nTmp, nStr]);
      FDM.ExecuteSQL(nSQL);
    end;  

    FDM.ADOConn.CommitTrans;
    ModalResult := mrOK;
    ShowMsg('数据已保存', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormSkinType, TfFormSkinType.FormID);
end.
