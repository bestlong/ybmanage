{*******************************************************************************
  ����: dmzn@163.com 2009-7-25
  ����: ��Ʒѡ�����
*******************************************************************************}
unit UFormProductView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UBgFormBase, ComCtrls, cxTreeView, StdCtrls,
  cxRadioGroup, dxLayoutControl, cxMCListBox, cxMemo, cxImage, cxMaskEdit,
  cxButtonEdit, cxContainer, cxEdit, cxTextEdit, cxControls, UTransPanel,
  ImgList, cxCheckBox, Menus;

type
  PProductItem = ^TProductItem;
  TProductItem = record
    FProduct: string;      //��Ʒ���
    FProductName: string;  //��Ʒ����
    FExtInfo: string;      //��չ��Ϣ
    FSkin: string;         //Ƥ��֢״
    FReason: string;       //�Ƽ�����
  end;

  TfFormProductView = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    cxTextEdit1: TcxTextEdit;
    EditName: TcxTextEdit;
    EditPlant: TcxButtonEdit;
    EditProvider: TcxButtonEdit;
    cxTextEdit3: TcxTextEdit;
    ImagePic: TcxImage;
    cxMemo1: TcxMemo;
    ListInfo1: TcxMCListBox;
    InfoItems: TcxTextEdit;
    BtnExit: TButton;
    EditType: TcxTextEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxLayout1Group6: TdxLayoutGroup;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Group5: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Group7: TdxLayoutGroup;
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    dxLayout1Group8: TdxLayoutGroup;
    dxLayout1Group9: TdxLayoutGroup;
    dxLayout1Group10: TdxLayoutGroup;
    Radio2: TcxRadioButton;
    dxLayout1Item1: TdxLayoutItem;
    Radio1: TcxRadioButton;
    dxLayout1Item13: TdxLayoutItem;
    ProductTree1: TcxTreeView;
    dxLayout1Item14: TdxLayoutItem;
    BtnOK: TButton;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group11: TdxLayoutGroup;
    ImageList1: TImageList;
    Check1: TcxCheckBox;
    dxLayout1Item16: TdxLayoutItem;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    EditInfo: TcxMemo;
    dxLayout1Item17: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure EditPlantPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditProviderPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ImagePicDblClick(Sender: TObject);
    procedure Radio1Click(Sender: TObject);
    procedure ProductTree1Change(Sender: TObject; Node: TTreeNode);
    procedure Check1PropertiesEditValueChanged(Sender: TObject);
    procedure ProductTree1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure PMenu1Popup(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FPlantID,FProviderID: string;
    //��¼��ʶ
    FDisplayRect: TRect;
    //��ʾ����
    FSkinName: string;
    //Ƥ������
    FResultList,FProductList: TList;
    //��Ʒ�б�
    procedure InitFormData;
    //��ʼ������
    procedure ClearProductList(const nFree: Boolean);
    //������Դ
    procedure LoadProductByPlant;
    procedure LoadProductByType;
    //�����Ʒ�б�
    function ProductHasSelected(const nID: string): integer;
    //�Ƿ���ѡ��
    procedure LoadProductInfo(const nID: string);
    //�����Ʒ��Ϣ
    function SetData(Sender: TObject; const nData: string): Boolean;
    //��������
    procedure GetSelectProductList(const nList: TList);
    //��ȡѡ�в�Ʒ
  public
    { Public declarations }
  end;

function ShowSelectProductForm(const nProducts: TList; const nSkin: string;
 const nRect: TRect): Boolean;
procedure ShowViewProductForm(const nRect: TRect);
//��ں���

implementation

{$R *.dfm}

uses
  ULibFun, UAdjustForm, UFormCtrl, USysConst, USysDB, USysGrid, USysGobal,
  UFormProvider, UFormPlant, UFormViewImage;

const
  cImageIndex_Group = 0;
  cImageIndex_Product = 1;
  cImageIndex_Selected = 2;
  cImageIndex_NowSelected = 3;

//------------------------------------------------------------------------------
//Desc: ѡ���Ʒ
function ShowSelectProductForm(const nProducts: TList; const nSkin: string;
 const nRect: TRect): Boolean;
begin
  with TfFormProductView.Create(Application) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FSkinName := nSkin;
    FResultList := nProducts;
    FDisplayRect := nRect;

    InitFormData;
    Result := ShowModal = mrOk;

    if Result then
      GetSelectProductList(nProducts);
    ClearProductList(True);
    Free;
  end;
end;

procedure ShowViewProductForm(const nRect: TRect);
begin

end;

//------------------------------------------------------------------------------
procedure TfFormProductView.FormCreate(Sender: TObject);
begin
  inherited;
  FProductList := TList.Create;

  ResetHintAllCtrl(Self, 'T', sTable_Product);
  LoadMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormProductView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;

  if Action = caFree then
  begin
    SaveMCListBoxConfig(Name, ListInfo1);
  end;
end;

procedure TfFormProductView.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: �����Ʒ��Ϣ
procedure TfFormProductView.ClearProductList(const nFree: Boolean);
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

//Desc: ��ʼ������
procedure TfFormProductView.InitFormData;
begin
  Radio1Click(nil);
end;

//Desc: ��������
function TfFormProductView.SetData(Sender: TObject; const nData: string): Boolean;
var nStr: string;
begin
  Result := False;

  if Sender = EditType then
  begin
    Result := True;
    nStr := 'Select B_Text From %s Where B_Group=''%s'' And B_ID=%s';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_ProductType, nData]);;

    EditType.Text := nData;
    with FDM.QueryTemp(nStr) do
     if RecordCount = 1 then
      EditType.Text := Fields[0].AsString;
  end else

  if Sender = EditPlant then
  begin
    Result := True;
    nStr := 'Select P_Name From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Plant, nData]);

    FPlantID := nData;
    EditPlant.Text := nData;

    with FDM.QueryTemp(nStr) do
     if RecordCount = 1 then
      EditPlant.Text := Fields[0].AsString;
  end else

  if Sender = EditProvider then
  begin
    Result := True;
    nStr := 'Select P_Name From %s Where P_ID=''%s''';
    nStr := Format(nStr, [sTable_Provider, nData]);

    FProviderID := nData;
    EditProvider.Text := nData;

    with FDM.QueryTemp(nStr) do
     if RecordCount = 1 then
      EditProvider.Text := Fields[0].AsString;
  end;
end;

//Desc: ������ΪnID�Ĳ�Ʒ
procedure TfFormProductView.LoadProductInfo(const nID: string);
var nStr: string;
begin
  ImagePic.Clear;
  EditInfo.Clear;
  InfoItems.Clear;

  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Product, nID]);

  LoadDataToCtrl(FDM.QuerySQL(nStr), Self, '', SetData);
  FDM.LoadDBImage(FDM.SqlQuery, 'P_Image', ImagePic.Picture);

  ListInfo1.Clear;
  nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                     MI('$Group', sFlag_ProductItem), MI('$ID', nID)]);
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

//Desc: �鿴��Ϣ
procedure TfFormProductView.ListInfo1Click(Sender: TObject);
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

//Desc: �鿴��Ӧ��
procedure TfFormProductView.EditPlantPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  Visible := False;
  ShowViewProviderForm(FProviderID, FDisplayRect);
  Visible := True;
end;

//Desc: �鿴������
procedure TfFormProductView.EditProviderPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
begin
  Visible := False;
  ShowViewPlantForm(FPlantID, FDisplayRect);
  Visible := True;
end;

//Desc: �鿴ͼƬ
procedure TfFormProductView.ImagePicDblClick(Sender: TObject);
begin
  if Assigned(ImagePic.Picture.Graphic) then
  begin
    Visible := False;
    ShowViewImageForm(ImagePic.Picture.Graphic, FDisplayRect);
    Visible := True;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ȡѡ�в�Ʒ�б�,����nList��
procedure TfFormProductView.GetSelectProductList(const nList: TList);
var nIdx: Integer;
    nItem: PProductItem;
begin
  for nIdx:=nList.Count - 1 downto 0 do
  begin
    nItem := nList[nIdx];
    if CompareText(nItem.FSkin, FSkinName) = 0 then
    begin
      Dispose(nItem);
      nList.Delete(nIdx);
    end;
  end;

  for nIdx:=ProductTree1.Items.Count - 1 downto 0 do
  if ProductTree1.Items[nIdx].ImageIndex = cImageIndex_Selected then
  begin
    nItem := ProductTree1.Items[nIdx].Data;
    nList.Add(nItem);
    FProductList.Delete(FProductList.IndexOf(nItem));
  end;
end;

//Desc: ����ͼ�����Ʒ�б�
procedure TfFormProductView.Radio1Click(Sender: TObject);
begin
  if Radio1.Checked then LoadProductByPlant else
  if Radio2.Checked then LoadProductByType;
end;

//Desc: �ж�nID��Ʒ�Ƿ��Ѿ���ѡ���б���
function TfFormProductView.ProductHasSelected(const nID: string): integer;
var nIdx: integer;
    nItem: PProductItem;
begin
  Result := -1;

  for nIdx:=FResultList.Count - 1 downto 0 do
  begin
    nItem := FResultList[nIdx];
    if (CompareText(nID, nItem.FProduct) = 0) and
       (CompareText(nItem.FSkin, FSkinName) = 0) then
    begin
      Result := nIdx; Break;
    end;
  end;
end;

//Desc: ��������
procedure TfFormProductView.LoadProductByPlant;
var nStr: string;
    nIdx: integer;
    nNode: TTreeNode;
    nItem: PProductItem;
begin
  ProductTree1.Items.BeginUpdate;
  try
    ProductTree1.Items.Clear;
    ClearProductList(False);

    nStr := 'Select P_ID,P_Name From %s Order By P_Name';
    nStr := Format(nStr, [sTable_Plant]);

    if FDM.QueryTemp(nStr).RecordCount < 1 then
    begin
      nNode := ProductTree1.Items.AddChild(nil, 'û��������');
      nNode.ImageIndex := cImageIndex_Group;
      nNode.SelectedIndex := nNode.ImageIndex; Exit;
    end;

    with FDM.SqlTemp do
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        FProductList.Add(nItem);

        nItem.FProduct := FieldByName('P_ID').AsString;
        nItem.FProductName := FieldByName('P_Name').AsString;

        nNode := ProductTree1.Items.AddChild(nil, nItem.FProductName);
        nNode.ImageIndex := cImageIndex_Group;
        nNode.SelectedIndex := nNode.ImageIndex;
        nNode.Data := nItem;

        Next;
      end;
    end;

    nNode := ProductTree1.Items[0];
    while Assigned(nNode)do
    begin
      nItem := nNode.Data;
      nStr := 'Select P_ID,P_Name From %s Where P_Plant=''%s'' Order By P_Name';
      nStr := Format(nStr, [sTable_Product, nItem.FProduct]);

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

          with ProductTree1.Items.AddChildFirst(nNode, nItem.FProductName) do
          begin
            nIdx := ProductHasSelected(nItem.FProduct);

            if nIdx < 0 then
                 ImageIndex := cImageIndex_Product
            else ImageIndex := cImageIndex_Selected;

            SelectedIndex := cImageIndex_NowSelected;
            Data := nItem;

            if nIdx > -1 then
            with PProductItem(FResultList[nIdx])^ do
            begin
              nItem.FProductName := FProductName;
              nItem.FExtInfo := FExtInfo;
              nItem.FSkin := FSkin;
              nItem.FReason := FReason;
            end;
          end;

          Next;
        end;
      end;

      nNode := nNode.getNextSibling;
    end; 
  finally
    ProductTree1.Items.EndUpdate;
  end;
end;

//Desc: ����Ʒ����
procedure TfFormProductView.LoadProductByType;
var nStr: string;
    nIdx: integer;
    nNode: TTreeNode;
    nItem: PProductItem;
begin
  ProductTree1.Items.BeginUpdate;
  try
    ProductTree1.Items.Clear;
    ClearProductList(False);

    nStr := 'Select B_ID, B_Text From %s Where B_Group=''%s'' Order By B_Index';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_ProductType]);;

    if FDM.QueryTemp(nStr).RecordCount < 1 then
    begin
      nNode := ProductTree1.Items.AddChild(nil, 'û�����');
      nNode.ImageIndex := cImageIndex_Group;
      nNode.SelectedIndex := nNode.ImageIndex; Exit;
    end;

    with FDM.SqlTemp do
    begin
      First;

      while not Eof do
      begin
        New(nItem);
        FProductList.Add(nItem);

        nItem.FProduct := FieldByName('B_ID').AsString;
        nItem.FProductName := FieldByName('B_Text').AsString;

        nNode := ProductTree1.Items.AddChild(nil, nItem.FProductName);
        nNode.ImageIndex := cImageIndex_Group;
        nNode.SelectedIndex := nNode.ImageIndex;
        nNode.Data := nItem;

        Next;
      end;
    end;

    nNode := ProductTree1.Items[0];
    while Assigned(nNode)do
    begin
      nItem := nNode.Data;
      nStr := 'Select P_ID,P_Name From %s Where P_Type=%s Order By P_Name';
      nStr := Format(nStr, [sTable_Product, nItem.FProduct]);

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

          with ProductTree1.Items.AddChildFirst(nNode, nItem.FProductName) do
          begin
            nIdx := ProductHasSelected(nItem.FProduct);

            if nIdx < 0 then
                 ImageIndex := cImageIndex_Product
            else ImageIndex := cImageIndex_Selected;

            SelectedIndex := cImageIndex_NowSelected;
            Data := nItem;

            if nIdx > -1 then
            with PProductItem(FResultList[nIdx])^ do
            begin
              nItem.FProductName := FProductName;
              nItem.FExtInfo := FExtInfo;
              nItem.FSkin := FSkin;
              nItem.FReason := FReason;
            end;
          end;

          Next;
        end;
      end;

      nNode := nNode.getNextSibling;
    end; 
  finally
    ProductTree1.Items.EndUpdate;
  end;
end;

//Desc: ѡ�нڵ�䶯
procedure TfFormProductView.ProductTree1Change(Sender: TObject;
  Node: TTreeNode);
begin
  Check1.Enabled := Assigned(Node) and (Node.ImageIndex <> cImageIndex_Group);
  if Check1.Enabled then
  begin
    Check1.Checked := Node.ImageIndex = cImageIndex_Selected;
    LoadProductInfo(PProductItem(Node.Data).FProduct);
  end;
end;

//Desc: ѡ�в�Ʒ
procedure TfFormProductView.Check1PropertiesEditValueChanged(Sender: TObject);
var nItem: PProductItem;
begin
  with ProductTree1 do
    Check1.Enabled := Assigned(Selected) and (Selected.ImageIndex <> cImageIndex_Group);
  if not Check1.Enabled then Exit;

  nItem := ProductTree1.Selected.Data;
  nItem.FSkin := FSkinName;
  nItem.FExtInfo := Format('%s ������:[ %s ]', [nItem.FProductName, EditPlant.Text]);

  if Check1.Checked then
       ProductTree1.Selected.ImageIndex := cImageIndex_Selected
  else ProductTree1.Selected.ImageIndex := cImageIndex_Product;
end;

procedure TfFormProductView.ProductTree1KeyDown(Sender: TObject;
  var Key: Word; Shift: TShiftState);
begin
  if CompareText('x', Char(Key)) = 0 then
  begin
    Key := 0;
    Check1.Checked := not Check1.Checked;
    Check1PropertiesEditValueChanged(nil);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ��ݲ˵�
procedure TfFormProductView.PMenu1Popup(Sender: TObject);
begin
  N4.Enabled := Check1.Enabled;

  if Check1.Checked then
       N4.Caption := 'ȡ��ѡ��'
  else N4.Caption := 'ѡ�в�Ʒ';
end;

procedure TfFormProductView.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: //ѡ��
      begin
        Check1.Checked := not Check1.Checked;
        Check1PropertiesEditValueChanged(nil);
      end;
    20: //չ��
      ProductTree1.FullExpand;
    30: //����
      ProductTree1.FullCollapse;
  end;

  ProductTree1.Invalidate;
end;

//Desc: ȷ��
procedure TfFormProductView.BtnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
