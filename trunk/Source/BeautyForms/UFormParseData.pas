{*******************************************************************************
  ����: dmzn@163.com 2009-7-23
  ����: ͼ���������
*******************************************************************************}
unit UFormParseData;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UBgFormBase, Menus, cxLookAndFeelPainters,
  dxLayoutControl, cxControls, StdCtrls, cxButtons, UTransPanel,
  cxContainer, cxMCListBox, cxGraphics, cxMemo, cxEdit, cxTextEdit,
  cxMaskEdit, cxDropDownEdit, cxButtonEdit, UBitmapButton;

type
  TfFormParseData = class(TfBgFormBase)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    dxGroup2: TdxLayoutGroup;
    ListInfo1: TcxMCListBox;
    dxLayoutControl1Item1: TdxLayoutItem;
    ListInfo2: TcxMCListBox;
    dxLayoutControl1Item2: TdxLayoutItem;
    InfoItems: TcxComboBox;
    dxLayoutControl1Item3: TdxLayoutItem;
    EditInfo: TcxMemo;
    dxLayoutControl1Item4: TdxLayoutItem;
    BtnDel1: TButton;
    dxLayoutControl1Item5: TdxLayoutItem;
    BtnAdd1: TButton;
    dxLayoutControl1Item6: TdxLayoutItem;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditProduct: TcxTextEdit;
    dxLayoutControl1Item7: TdxLayoutItem;
    EditReason: TcxMemo;
    dxLayoutControl1Item8: TdxLayoutItem;
    BtnAdd2: TButton;
    dxLayoutControl1Item9: TdxLayoutItem;
    BtnDel2: TButton;
    dxLayoutControl1Item10: TdxLayoutItem;
    dxLayoutControl1Group2: TdxLayoutGroup;
    PfID: TcxButtonEdit;
    dxLayoutControl1Item13: TdxLayoutItem;
    PfName: TcxTextEdit;
    dxLayoutControl1Item14: TdxLayoutItem;
    dxLayoutControl1Group4: TdxLayoutGroup;
    PFList1: TcxComboBox;
    dxLayoutControl1Item15: TdxLayoutItem;
    CFList1: TcxComboBox;
    dxLayoutControl1Item16: TdxLayoutItem;
    CfID: TcxButtonEdit;
    dxLayoutControl1Item17: TdxLayoutItem;
    CfName: TcxTextEdit;
    dxLayoutControl1Item18: TdxLayoutItem;
    dxLayoutControl1Group5: TdxLayoutGroup;
    BtnExpand: TZnBitmapButton;
    EditCFType: TcxComboBox;
    dxLayoutControl1Item11: TdxLayoutItem;
    procedure BtnExpandClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnAdd1Click(Sender: TObject);
    procedure BtnDel1Click(Sender: TObject);
    procedure PFList1PropertiesEditValueChanged(Sender: TObject);
    procedure CFList1PropertiesEditValueChanged(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure ListInfo2Click(Sender: TObject);
    procedure BtnDel2Click(Sender: TObject);
    procedure BtnAdd2Click(Sender: TObject);
    procedure ListInfo2DblClick(Sender: TObject);
    procedure PfIDPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditReasonExit(Sender: TObject);
  private
    { Private declarations }
    FMemberID: string;
    //��Ա���
    FDisplayRect: TRect;
    //��ʾ����
    FFormWidth,FFormHeight: integer;
    //������
    FProductList: TList;
    //��Ʒ�б�
    FSkinPrefixID,FPlanPrefixID: string;
    //ǰ׺���
    FSkinIDLength,FPlanIDLength: integer;
    //ǰ׺����
    FImageExpand,FImageCollapse: TBitmap;
    //��ťͼ��
    procedure InitFormData;
    //��ʼ����
    procedure ClearProductList(const nFree: Boolean);
    //������Դ
    procedure HideAllCtrl(const nHide: Boolean);
    //�����ؼ�
    procedure ExpandForm(const nExpand: Boolean);
    //��������
    function SaveParseData(var nSkinID: string): Boolean;
    //��������
  public
    { Public declarations }
  end;

function ShowParseDataForm(const nMemberID: string; const nRect: TRect): TForm;
procedure SetParseImage(const nImage: TPicture);
procedure CloseParseDataForm;
function SaveParseData(var nSkinID: string): Boolean;
//��ں���

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, USysGrid, USysDB, USysConst, USysGobal,
  USysFun, UImageControl, UFormProductView, UFormProduct;

const
  cHorInterval     = 1;   //ˮƽ�߾�
  cVerInterval     = 5;   //��ֱ�߾�

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Desc: ��ʾͼ��������ݴ���
function ShowParseDataForm(const nMemberID: string; const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormParseData.Create(gForm);
  Result := gForm;

  with TfFormParseData(Result) do
  begin
    Position := poDesigned;
    FMemberID := nMemberID;
    FDisplayRect := nRect;

    InitFormData;
    if not Showing then Show;
  end;
end;

procedure SetParseImage(const nImage: TPicture);
begin

end;

procedure CloseParseDataForm;
begin
  if Assigned(gForm) then
  begin
    TfFormParseData(gForm).CloseForm;
  end;
end;

//Date: 2009-7-26
//Parm: Ƥ���������
//Desc: �����������
function SaveParseData(var nSkinID: string): Boolean;
begin
  if Assigned(gForm) then
  begin
    with TfFormParseData(gForm) do
     Result := SaveParseData(nSkinID);
  end else Result := False;
end;

//Desc: ��ȡnFileͼƬ
function MyLoadImage(const nFile: string): TBitmap;
var nPic: TPicture;
begin
  Result := nil;
  nPic := TPicture.Create;
  try
    nPic.LoadFromFile(nFile);
    Result := TBitmap.Create;

    Result.Width := nPic.Width;
    Result.Height := nPic.Height;
    
    Result.Canvas.Draw(0, 0, nPic.Graphic);
    FreeAndNil(nPic);
  except
    FreeAndNil(nPic);
    FreeAndNil(Result);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormParseData.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  inherited;
  FFormWidth := Width;
  FFormHeight := Height;

  BtnExpand.BringToFront;
  FProductList := TList.Create;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    FSkinPrefixID := nIni.ReadString(Name, 'SkinIDPrefix', 'PF');
    FSkinIDLength := nIni.ReadInteger(Name, 'SkinIDLength', 8);
    FPlanPrefixID := nIni.ReadString(Name, 'PlanIDPrefix', 'FA');
    FPlanIDLength := nIni.ReadInteger(Name, 'PlanIDLength', 8);

    FreeAndNil(nIni);
    nIni := TIniFile.Create(gPath + sImageConfigFile);

    nStr := nIni.ReadString(sImageExpandButton, sImageExpandFile, '');
    nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);
    if FileExists(nStr) then FImageExpand := MyLoadImage(nStr);

    nStr := nIni.ReadString(sImageExpandButton, sImageCollapse, '');
    nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);
    if FileExists(nStr) then FImageCollapse := MyLoadImage(nStr);
  finally
    nIni.Free;
  end;
end;

procedure TfFormParseData.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    ClearProductList(True);
    ReleaseCtrlData(Self);

    FreeAndNil(FImageExpand);
    FreeAndNil(FImageCollapse);

    gForm := nil;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormParseData.InitFormData;
var nStr: string;
begin
  ExpandForm(False);

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

  if PFList1.Properties.Items.Count < 1 then
  begin
    PFList1.Clear;
    nStr := 'T_ID=Select T_ID,T_Name From %s Where T_MID is Null Or T_MID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, FMemberID]);

    FDM.FillStringsData(PFList1.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(PFList1.Properties.Items, False);
  end;

  if EditCFType.Properties.Items.Count < 1 then
  begin
    EditCFType.Clear;
    nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_PlanItem]);

    FDM.FillStringsData(EditCFType.Properties.Items, nStr, -1, '.');
    AdjustStringsItem(EditCFType.Properties.Items, False);
  end;
end;

//Desc: ��&�����пؼ�
procedure TfFormParseData.HideAllCtrl(const nHide: Boolean);
var i,nCount: integer;
begin
  nCount := ControlCount - 1;
  for i:=0 to nCount do
    Controls[i].Visible := not nHide;
  BtnExpand.Visible := True;
end;

//Desc: ��ʾ���ش���
procedure TfFormParseData.ExpandForm(const nExpand: Boolean);
var nX,nY: integer;
    nSpeed: integer;
begin
  if nExpand then
  begin
    if ClientPanel1.Visible then Exit;
    if Assigned(FImageCollapse) then
      BtnExpand.Bitmap := FImageCollapse;
    Width := FFormWidth;
    
    nY := FDisplayRect.Bottom - FDisplayRect.Top - cVerInterval * 2;
    if nY > FFormHeight then Height := FFormHeight else Height := nY;

    nY := Round((FDisplayRect.Bottom - FDisplayRect.Top - Height) / 2);
    Top := FDisplayRect.Top + nY;

    ClientPanel1.Height := Height - ClientPanel1.Top - FValidRect.Bottom;
    //��������ʾ����,����������ֹ�����
    Application.ProcessMessages;

    HideAllCtrl(False);
    BtnExpand.Left := 0;
    BtnExpand.Top := Round((Height - BtnExpand.Height) / 2);

    //BtnExpand.Parent := FindBgItem(cpForm);
    BtnExpand.BringToFront;

    nSpeed := 1;
    nX := FDisplayRect.Right - FFormWidth - cHorInterval;

    while Left > nX do
    begin
      nY := Left - nSpeed;
      if nY > nX then
           Left := nY
      else Left := nX;

      Application.ProcessMessages;
      Sleep(10);
      nSpeed := nSpeed + Random(8);
    end;
  end else
  begin
    if Assigned(FImageExpand) then
      BtnExpand.Bitmap := FImageExpand;
    //xxxxx
    
    nSpeed := 1;
    nX := FDisplayRect.Right - cHorInterval - BtnExpand.Width;

    while Left < nX do
    begin
      nY := Left + nSpeed;
      if nY < nX then
           Left := nY
      else Left := nX;

      Application.ProcessMessages;
      Sleep(10);
      nSpeed := nSpeed + Random(8);
    end;

    HideAllCtrl(True);
    BtnExpand.Left := 0;
    BtnExpand.Top := 0;

    BtnExpand.Parent := Self;
    BtnExpand.BringToFront;

    Width := BtnExpand.Width;
    Height := BtnExpand.Height;

    nY := Round((FDisplayRect.Bottom - FDisplayRect.Top - Height) / 2);
    Top := FDisplayRect.Top + nY;
  end;
end;

//Desc: �����Ʒ��Ϣ
procedure TfFormParseData.ClearProductList(const nFree: Boolean);
var nIdx: integer;
begin
  while FProductList.Count > 0 do
  begin
    nIdx := FProductList.Count - 1;
    Dispose(PProductItem(FProductList[nIdx]));
    FProductList.Delete(nIdx);
  end;

  if nFree then FProductList.Free;
end;

//------------------------------------------------------------------------------
//Desc: չ��&����
procedure TfFormParseData.BtnExpandClick(Sender: TObject);
begin
  if BtnExpand.Tag = 0 then
  begin
    ExpandForm(True);
    BtnExpand.Tag := 10;
    //BtnExpand.Caption := '>'
  end else
  begin
    ExpandForm(False);
    BtnExpand.Tag := 0;
    //BtnExpand.Caption := '<'
  end;
end;

//Desc: ���֢״
procedure TfFormParseData.BtnAdd1Click(Sender: TObject);
begin
  InfoItems.Text := Trim(InfoItems.Text);
  if InfoItems.Text = '' then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('����д֢״����', sHint); Exit;
  end;

  EditInfo.Text := Trim(EditInfo.Text);
  if EditInfo.Text = '' then
  begin
    EditInfo.SetFocus;
    FDM.ShowMsg('����д������Ϣ', sHint); Exit;
  end;

  ListInfo1.Items.Add(InfoItems.Text + ListInfo1.Delimiter + EditInfo.Text);
end;

//Desc: ɾ��֢״
procedure TfFormParseData.BtnDel1Click(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PProductItem;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('��ѡ��Ҫɾ��������', sHint); Exit;
  end;

  nIdx := ListInfo1.ItemIndex;
  nStr := ListInfo1.Items[nIdx];
  ListInfo1.Items.Delete(ListInfo1.ItemIndex);

  if nIdx >= ListInfo1.Count then Dec(nIdx);
  ListInfo1.ItemIndex := nIdx;

  nStr := Copy(nStr, 1, Pos(ListInfo1.Delimiter, nStr) - 1);
  for nIdx:=FProductList.Count - 1 downto 0 do
  begin
    nItem := FProductList[nIdx];
    if CompareText(nItem.FSkin, nStr) <> 0 then Continue;

    Dispose(nItem);
    FProductList.Delete(nIdx);
  end;

  FDM.ShowMsg('�ѳɹ�ɾ��', sHint);
end;

//Desc: ��Ӳ�Ʒ
procedure TfFormParseData.BtnAdd2Click(Sender: TObject);
var nStr: string;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    ListInfo1.SetFocus;
    FDM.ShowMsg('��ѡ������Ե�֢״', sHint); Exit;
  end;

  nStr := ListInfo1.Items[ListInfo1.ItemIndex];
  nStr := Copy(nStr, 1, Pos(ListInfo1.Delimiter, nStr) - 1);

  Visible := False;
  try
    if ShowSelectProductForm(FProductList, nStr, FDisplayRect) then
      ListInfo1Click(nil);
  finally
    Visible := True;
  end;
end;

//Desc: ɾ����Ʒ
procedure TfFormParseData.BtnDel2Click(Sender: TObject);
var nIdx: integer;
    nStr,nTmp: string;
    nItem: PProductItem;
begin
  if ListInfo2.ItemIndex < 0 then
  begin
    FDM.ShowMsg('��ѡ��Ҫɾ���Ĳ�Ʒ', sHint); Exit;
  end;

  nIdx := ListInfo2.ItemIndex;
  nStr := ListInfo2.Items[nIdx];
  ListInfo2.Items.Delete(ListInfo2.ItemIndex);

  if nIdx >= ListInfo2.Count then Dec(nIdx);
  ListInfo2.ItemIndex := nIdx;

  if ListInfo1.ItemIndex > -1 then
  begin
    nTmp := ListInfo1.Items[ListInfo1.ItemIndex];
    nTmp := Copy(nTmp, 1, Pos(ListInfo1.Delimiter, nTmp) - 1);
    //֢״

    nStr := Copy(nStr, 1, Pos(ListInfo2.Delimiter, nStr) - 1);
    //��Ʒ

    for nIdx:=FProductList.Count - 1 downto 0 do
    begin
      nItem := FProductList[nIdx];
      if (CompareText(nItem.FProduct, nStr) <> 0) or
         (CompareText(nItem.FSkin, nTmp) <> 0) then Continue;
      //��ǰ֢״��Ӧ�Ĳ�Ʒ

      Dispose(nItem);
      FProductList.Delete(nIdx);
    end;
  end;
  
  FDM.ShowMsg('�ѳɹ�ɾ��', sHint);
end;

//Desc: ����ο�Ƥ����Ϣ
procedure TfFormParseData.PFList1PropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
begin
  if PFList1.ItemIndex < 0 then Exit;
  PfID.Text := GetCtrlData(PFList1);

  nStr := PFList1.Text;
  System.Delete(nStr, 1, Pos('.', nStr));
  PfName.Text := nStr;

  ListInfo1.Clear;
  nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                     MI('$Group', sFlag_SkinType), MI('$ID', PfID.Text)]);
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

  nStr := 'P_ID=Select P_ID,P_Name From %s Where P_SkinType=''%s''';
  nStr := Format(nStr, [sTable_Plan, PfID.Text]);

  FDM.FillStringsData(CFList1.Properties.Items, nStr, -1, '.');
  AdjustStringsItem(CFList1.Properties.Items, False);
end;

//Dec: ���봦����Ϣ
procedure TfFormParseData.CFList1PropertiesEditValueChanged(
  Sender: TObject);
var nStr: string;
    nItem: PProductItem;
begin
  if CFList1.ItemIndex < 0 then Exit;
  CfID.Text := GetCtrlData(CFList1);

  nStr := CFList1.Text;
  System.Delete(nStr, 1, Pos('.', nStr));
  CfName.Text := nStr;

  nStr := 'Select P_PlanType From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Plan, CfID.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    SetCtrlData(EditCFType, Fields[0].AsString);
  end;

  nStr := 'Select * From $Ext e' +
          '  Left Join (Select P_ID,P_Name,' +
          '   (Select P_Name From $Plant Where P_ID=p.P_Plant) as P_PlantName ' +
          '  From $Product p) t On t.P_ID=e.E_Product ' +
          'Where E_Plan=''$PID''';

  nStr := MacroValue(nStr, [MI('$Ext', sTable_PlanExt), MI('$PID', CfID.Text),
            MI('$Plant', sTable_Plant), MI('$Product', sTable_Product)]);

  ListInfo2.Clear;
  ClearProductList(False);

  with FDM.QueryTemp(nStr) do
   if RecordCount > 0 then
   begin
     First;

     while not Eof do
     begin
       New(nItem);
       FProductList.Add(nItem);

       nItem.FProduct := FieldByName('P_ID').AsString;
       nItem.FProductName := FieldByName('P_Name').AsString;

       nStr := '%s ������:[ %s ]';
       nStr := Format(nStr, [nItem.FProductName, FieldByName('P_PlantName').AsString]);
       nItem.FExtInfo :=  nStr;

       nItem.FSkin := FieldByName('E_Skin').AsString;
       nItem.FReason := FieldByName('E_Memo').AsString;

       nStr := nItem.FProduct + ListInfo2.Delimiter +
               nItem.FProductName + ' ' + ListInfo2.Delimiter +
               nItem.FReason + ' ';
       ListInfo2.Items.Add(nStr);
       Next;
     end;
   end;
end;

//Desc: ���뵱ǰ��Ϣ
procedure TfFormParseData.ListInfo1Click(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nItem: PProductItem;
begin
  if ListInfo1.ItemIndex < 0 then
  begin
    InfoItems.Clear; EditInfo.Clear; Exit;
  end;

  nStr := ListInfo1.Items[ListInfo1.ItemIndex];
  nIdx := Pos(ListInfo1.Delimiter, nStr);

  InfoItems.Text := Copy(nStr, 1, nIdx - 1);
  System.Delete(nStr, 1, nIdx);
  EditInfo.Text := nStr;

  ListInfo2.Clear;
  for nIdx:=FProductList.Count - 1 downto 0 do
  begin
    nItem := FProductList[nIdx];
    if CompareText(nItem.FSkin, InfoItems.Text) <> 0 then Continue;

    nStr := nItem.FProduct + ListInfo2.Delimiter +
            nItem.FProductName +  ' ' + ListInfo2.Delimiter +
            nItem.FReason + ' ';
    ListInfo2.Items.Add(nStr);
  end;
end;

//Desc: ��nList�м�����ʶΪnID�Ĳ�Ʒ
function FindProdcutInfo(const nList: TList; const nID: string): integer;
var nIdx: integer;
begin
  Result := -1;

  for nIdx:=nList.Count - 1 downto 0 do
  if CompareText(PProductItem(nList[nIdx]).FProduct, nID) = 0 then
  begin
    Result := nIdx; Break;
  end;
end;

procedure TfFormParseData.ListInfo2Click(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nList: TStrings;
begin
  if ListInfo2.ItemIndex > -1 then
  begin
    nStr := ListInfo2.Items[ListInfo2.ItemIndex];
    nList := TStringList.Create;
    try
      if SplitStr(nStr, nList, 3, ListInfo2.Delimiter) then
      begin
        nIdx := FindProdcutInfo(FProductList, nList[0]);
        if nIdx > -1 then
        with PProductItem(FProductList[nIdx])^ do
        begin
          EditProduct.Text := FExtInfo;
          EditReason.Text := FReason; Exit;
        end;
      end;
    finally
      nList.Free;
    end;
  end;

  EditProduct.Clear;
  EditReason.Clear;
end;

//Desc: �Ƽ�����
procedure TfFormParseData.EditReasonExit(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nList: TStrings;
begin
  if ListInfo2.ItemIndex > -1 then
  begin
    nStr := ListInfo2.Items[ListInfo2.ItemIndex];
    nList := TStringList.Create;
    try
      if SplitStr(nStr, nList, 3, ListInfo2.Delimiter) then
      begin
        nIdx := FindProdcutInfo(FProductList, nList[0]);
        if nIdx > -1 then
        with PProductItem(FProductList[nIdx])^ do
        begin
          FReason := Trim(EditReason.Text);
          nStr := nList[0] + ListInfo2.Delimiter +
                  nList[1] + ' ' + ListInfo2.Delimiter +
                  FReason + ' ';
          ListInfo2.Items[ListInfo2.ItemIndex] := nStr;
        end;
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Desc: �鿴��Ʒ
procedure TfFormParseData.ListInfo2DblClick(Sender: TObject);
var nStr: string;
    nList: TStrings;
begin
  if ListInfo2.ItemIndex > -1 then
  begin
    nStr := ListInfo2.Items[ListInfo2.ItemIndex];
    nList := TStringList.Create;
    try
      if SplitStr(nStr, nList, 3, ListInfo2.Delimiter) then
      begin
        ShowViewProductForm(nList[0], FDisplayRect);
      end;
    finally
      Visible := True;
    end;
  end;
end;

//Desc: Ƥ�����
procedure TfFormParseData.PfIDPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  if Sender = PfID then
    PfID.Text := FDM.GetRandomID(FSkinPrefixID, FSkinIDLength);
  if Sender = CfID then
    CfID.Text := FDM.GetRandomID(FPlanPrefixID, FPlanIDLength);
end;

//Date: 2009-7-26
//Parm: Ƥ���������
//Desc: �����ΪTrue��nSkinIDΪ��,�����ñ�������������޸�
function TfFormParseData.SaveParseData(var nSkinID: string): Boolean;
type
  TSaveStatus = (ssNone, ssInsert, ssUpdate);
var nStr,nSQL: string;
    nList: TStrings;
    i,nCount,nIdx: integer;
    nSkin,nPlan: TSaveStatus;
begin
  nSkinID := '';
  Result := False;
  PfID.Text := Trim(PfID.Text);

  if PfID.Text = '' then
  begin
    ExpandForm(True);
    PfID.SetFocus;
    FDM.ShowMsg('����д��Ч��Ƥ��֢״���', sHint); Exit;
  end;

  PfName.Text := Trim(PfName.Text);
  if PfName.Text = '' then
  begin
    ExpandForm(True);
    PfName.SetFocus;
    FDM.ShowMsg('����д��Ч��Ƥ��֢״����', sHint); Exit;
  end;

  CfID.Text := Trim(CfID.Text);
  if CfID.Text = '' then
  begin
    ExpandForm(True);
    CfID.SetFocus;
    FDM.ShowMsg('����д��Ч�Ĵ������', sHint); Exit;
  end;

  CfName.Text := Trim(CfName.Text);
  if CfName.Text = '' then
  begin
    ExpandForm(True);
    CfName.SetFocus;
    FDM.ShowMsg('����д��Ч�Ĵ�������', sHint); Exit;
  end;

  nSkin := ssInsert;
  nStr := 'Select T_MID From %s Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_SkinType, PfID.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    ExpandForm(True);
    PfID.SetFocus;

    if CompareText(Fields[0].AsString, FMemberID) = 0 then
    begin
      nStr := '�ñ�ŵ�Ƥ�������Ѿ�����,�Ƿ�Ҫ����?!';

      if QueryDlg(nStr, sHint, Handle) then
           nSkin := ssUpdate
      else Exit;
    end else
    begin
      nStr := '�ñ�ŵ�Ƥ�������Ǹû�Ա����,�������޸Ľ����ᱻ����!!' + #13#10 +
              '��Ҫ����,���޸��������.������������"ȷ��"��ť!';
              
      if QueryDlg(nStr, sHint, Handle) then
           nSkin := ssNone
      else Exit;
    end;
  end;

  nPlan := ssInsert;
  nStr := 'Select P_MID From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Plan, CfID.Text]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    ExpandForm(True);
    CfID.SetFocus;

    if CompareText(Fields[0].AsString, FMemberID) = 0 then
    begin
      nStr := '�ñ�ŵĴ����Ѿ�����,�Ƿ�Ҫ����?!';

      if QueryDlg(nStr, sHint, Handle) then
           nPlan := ssUpdate
      else Exit;
    end else
    begin
      nStr := '�ñ�ŵĴ����Ѿ�����,���޸Ĵ������';
      ShowDlg(nStr, sHint, Handle); Exit;
    end;
  end;

  nList := nil;
  FDM.ADOConn.BeginTrans;
  try
    if nSkin = ssInsert then
    begin
      nSQL := 'Insert Into %s(T_ID,T_Name,T_MID,T_BID,T_Date) ' +
              'Values(''%s'',''%s'',''%s'',''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SkinType, PfID.Text, PfName.Text,
              FMemberID, gSysParam.FBeautyID, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
    end;

    if nSkin = ssUpdate then
    begin
      nSQL := 'Update %s Set T_Name=''%s'' Where T_ID=''%s''';
      nSQL := Format(nSQL, [sTable_SkinType, PfName.Text, PfID.Text]);
      FDM.ExecuteSQL(nSQL);
    end;

    if nSkin <> ssNone then
    begin
      nSQL := 'Delete From %s Where I_Group=''%s'' and I_ItemID=''%s''';
      nSQL := Format(nSQL, [sTable_ExtInfo, sFlag_SkinType, PfID.Text]);
      FDM.ExecuteSQL(nSQL);

      nList := TStringList.Create;
      nCount := ListInfo1.Items.Count - 1;

      nSQL := 'Insert Into %s(I_Group, I_ItemID, I_Item, I_Info) ' +
              'Values(''%s'', ''%s'', ''%s'', ''%s'')';
      //xxxxx

      for i:=0 to nCount do
      begin
        nStr := ListInfo1.Items[i];
        if not SplitStr(nStr, nList, 2, ListInfo1.Delimiter) then Continue;

        nStr := Format(nSQL, [sTable_ExtInfo, sFlag_SkinType,
                              PfID.Text, nList[0], nList[1]]);
        FDM.ExecuteSQL(nStr);
      end;

      if gSysDBType = dtAccess then
      begin
        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
                'Values(''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_SkinType, 'T_ID', PfID.Text]);
        FDM.ExecuteSQL(nSQL);

        nSQL := 'Insert Into %s(S_Table, S_Field, S_Value, S_ExtField, S_ExtValue) ' +
                'Values(''%s'', ''%s'', ''%s'', ''%s'', ''%s'')';
        nSQL := Format(nSQL, [sTable_SyncItem, sTable_ExtInfo, 'I_ItemID', PfID.Text,
                              'I_Group', sFlag_SkinType]);
        FDM.ExecuteSQL(nSQL);
      end; //��¼���
    end;

    //----------------------------------------------------------------------------
    nStr := GetCtrlData(EditCFType);
    if not IsNumber(nStr, False) then nStr := '-1';

    if nPlan = ssInsert then
    begin
      nSQL := 'Insert Into %s(P_ID,P_Name,P_PlanType,P_SkinType,P_MID,P_Man,P_Date) ' +
              'Values(''%s'',''%s'',%s,''%s'',''%s'', ''%s'',''%s'')';
      nSQL := Format(nSQL, [sTable_Plan, CfID.Text, CfName.Text, nStr,
              PfID.Text, FMemberID, gSysParam.FUserID, DateTime2Str(Now)]);
      FDM.ExecuteSQL(nSQL);
    end;

    if nPlan = ssUpdate then
    begin
      nSQL := 'Update %s Set P_Name=''%s'',P_PlanType=%s Where P_ID =''%s''';
      nSQL := Format(nSQL, [sTable_Plan, CfName.Text, nStr, CfID.Text]);
      FDM.ExecuteSQL(nSQL);
    end;

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_Plan, 'P_ID', CfID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //��¼���

    nSQL := 'Delete From %s Where E_Plan=''%s''';
    nSQL := Format(nSQL, [sTable_PlanExt, CfID.Text]);
    FDM.ExecuteSQL(nSQL); 

    if not Assigned(nList) then
      nList := TStringList.Create;
    nCount := ListInfo2.Items.Count - 1;

    nSQL := 'Insert Into %s(E_Plan, E_Product, E_Skin, E_Memo) ' +
            'Values(''%s'', ''%s'', ''%s'', ''%s'')';
    //xxxxx

    for i:=0 to nCount do
    begin
      nStr := ListInfo2.Items[i];
      if not SplitStr(nStr, nList, 3, ListInfo2.Delimiter) then Continue;
      nIdx := FindProdcutInfo(FProductList, nList[0]);

      if nIdx > -1 then
      with PProductItem(FProductList[nIdx])^ do
      begin
        if Trim(FSkin) = '' then Continue;
        nStr := Format(nSQL, [sTable_PlanExt, CfID.Text, nList[0], FSkin, nList[2]]);
        FDM.ExecuteSQL(nStr);
      end;
    end;

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_PlanExt, 'E_Plan', CfID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //��¼���

    if gSysParam.FGroupID = IntToStr(cBeauticianGroup) then
         nStr := gSysParam.FBeautyID
    else nStr := gSysParam.FUserID;

    nSQL := 'Insert Into %s(U_PID, U_MID, U_BID, U_Date) ' +
            ' Values(''%s'', ''%s'', ''%s'', ''%s'')';
    nSQL := Format(nSQL, [sTable_PlanUsed, CfID.Text, FMemberID, nStr, DateTime2Str(Now)]);
    FDM.ExecuteSQL(nSQL);

    if gSysDBType = dtAccess then
    begin
      nSQL := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nSQL := Format(nSQL, [sTable_SyncItem, sTable_PlanUsed, 'U_PID', CfID.Text]);
      FDM.ExecuteSQL(nSQL);
    end; //��¼���

    //--------------------------------------------------------------------------
    FDM.ADOConn.CommitTrans;
    if nSkin <> ssNone then
      nSkinID := PfID.Text;
    Result := True;
  except
    nList.Free;
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('�������ݱ���ʧ��', sError);
  end;
end;

end.
