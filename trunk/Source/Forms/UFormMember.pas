{*******************************************************************************
  作者: dmzn@163.com 2009-6-15
  描述: 会员管理
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
    //记录编号
    FPrefixID: string;
    //前缀编号
    FIDLength: integer;
    //前缀长度
    FImageFile: string;
    //图片文件
    FDataInfoChanged,FDataRelationChanged: Boolean;
    //数据变动
    procedure InitFormData(const nID: string);
    //载入数据
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
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
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, UMgrControl, UFormBase,
  USysDB, USysGrid, USysConst, UDataModule;

var
  gForm: TfFormMember = nil;

//------------------------------------------------------------------------------
//Desc: 数据还原窗体
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
      Caption := '会员 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormMember.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '会员 - 修改';

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
        gForm.Caption := '会员 - 查看';

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
  //重置表名称
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
    EditBeauty.HelpKeyword := 'NI|NU'; //不参与构建SQL
  end;

  if InfoItems.Properties.Items.Count < 1 then
  begin
    InfoItems.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_MemberItem)]);
    //数据字典中会员信息项

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
  end else
  begin
    FDataInfoChanged := True;
    FDataRelationChanged := True; //数据变动后会保存
  end;
end;

//Desc: 页面切换,载入会员关系
procedure TfFormMember.wPageChange(Sender: TObject);
var nStr: string;
begin
  if RelationName.Properties.Items.Count < 1 then
  begin
    RelationName.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_RelationItem)]);
    //数据字典中会员关系信息项

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
//Desc: 生成随机编号
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
    Title := '选择照片';
    Filter := '图片|*.bmp;*.jpg;*.png';

    if Execute then
    try
      cxImage1.Picture.LoadFromFile(FileName);
      FImageFile := FileName;
    except

    end;
    Free;
  end;
end;

//Desc: 添加信息项
procedure TfFormMember.BtnAddClick(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    ShowMsg('请填写有效的信息项', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    ShowMsg('请填写有效的信息内容', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
  FDataInfoChanged := True;
end;

//Desc: 删除信息项
procedure TfFormMember.BtnDelClick(Sender: TObject);
var nIdx: Integer;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ListInfo1.SetFocus;
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);
  FDataInfoChanged := True;

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;
  ShowMsg('信息项已删除', sHint);
end;

//Desc: 查看信息
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

//Desc: 添加会员关系
procedure TfFormMember.BtnAdd2Click(Sender: TObject);
var nStr: string;
begin
  RelationName.Text := Trim(RelationName.Text);
  if RelationName.Text = '' then
  begin
    RelationName.SetFocus;
    ShowMsg('请填写有效的关系名称', sHint); Exit;
  end;

  RelationMember.Text := Trim(RelationMember.Text);
  if RelationMember.Text = '' then
  begin
    RelationMember.SetFocus;
    ShowMsg('请选择有效的关系会员', sHint); Exit;
  end;

  nStr := RelationMember.Text;
  System.Delete(nStr, 1, Pos('|', nStr));
  nStr := Trim(nStr); //会员名

  nStr := RelationName.Text + ListRelation1.Delimiter + nStr + ' ' +
          ListRelation1.Delimiter + GetCtrlData(RelationMember);

  ListRelation1.Items.Add(nStr);
  FDataRelationChanged := True;
end;

//Desc: 删除关系
procedure TfFormMember.BtnDel2Click(Sender: TObject);
var nIdx: Integer;
begin
  if ListRelation1.ItemIndex < 0 then
  begin
    ListRelation1.SetFocus;
    ShowMsg('请选择要删除的内容', sHint); Exit;
  end;

  nIdx := ListRelation1.ItemIndex;
  ListRelation1.Items.Delete(ListRelation1.ItemIndex);
  FDataRelationChanged := True;

  if nIdx >= ListRelation1.Count then Dec(nIdx);
  ListRelation1.ItemIndex := nIdx;
  ShowMsg('信息项已删除', sHint);
end;

//Desc: 查看关系
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
//Desc: 验证数据
function TfFormMember.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;
  if Sender = EditID then
  begin
    EditID.Text := Trim(EditID.Text);
    Result := EditID.Text <> '';
    nHint := '请填写有效的会员编号';
  end else

  if Sender = EditSex then
  begin
    Result := EditSex.ItemIndex > -1;
    nHint := '请选择有效的性别';
  end else

  if Sender = EditAge then
  begin
    Result := IsNumber(EditAge.Text, False);
    nHint := '请填写有效的年龄';
  end else

  if Sender = EditHeight then
  begin
    Result := IsNumber(EditHeight.Text, False);
    nHint := '请填写有效的身高';
  end else

  if Sender = EditWeight then
  begin
    Result := IsNumber(EditWeight.Text, False);
    nHint := '请填写有效的体重';
  end;
end;

//Desc: 保存数据
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
    //查询编号是否存在

    with FDM.QueryTemp(nStr) do
     if Fields[0].AsInteger > 0 then
     begin
       EditID.SetFocus;
       ShowMsg('该编号的会员已经存在', sHint); Exit;
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
    ShowMsg('数据已保存', sHint);
  except
    if FDM.ADOConn.InTransaction then
      FDM.ADOConn.RollbackTrans;
    ShowMsg('数据保存失败', '未知原因');
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormMember, TfFormMember.FormID);
end.
