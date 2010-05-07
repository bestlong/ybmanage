{*******************************************************************************
  作者: dmzn@163.com 2009-7-30
  描述: 产品浏览
*******************************************************************************}
unit UFormProduct2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UDataModule, UBgFormBase, ComCtrls, dxLayoutControl, cxControls,
  cxContainer, cxTreeView, StdCtrls, cxRadioGroup, UTransPanel, cxMemo,
  UImageViewer, cxEdit, cxTextEdit, ImgList, cxGraphics, cxButtonEdit,
  cxMaskEdit, cxDropDownEdit, cxMCListBox, cxPC, cxImage, Menus;

type
  TfFormProductView2 = class(TfBgFormBase)
    TPanel: TZnTransPanel;
    BPanel1: TZnTransPanel;
    BtnExit: TButton;
    Radio1: TcxRadioButton;
    ProductTree1: TcxTreeView;
    wPanel: TZnTransPanel;
    Radio2: TcxRadioButton;
    dxLayout1: TdxLayoutControl;
    cxTextEdit1: TcxTextEdit;
    cxTextEdit2: TcxTextEdit;
    EditPlant: TcxButtonEdit;
    EditProvider: TcxButtonEdit;
    cxTextEdit3: TcxTextEdit;
    ImagePic: TcxImage;
    cxMemo1: TcxMemo;
    ListInfo1: TcxMCListBox;
    InfoItems: TcxTextEdit;
    EditType: TcxTextEdit;
    EditInfo: TcxMemo;
    dxLayoutGroup1: TdxLayoutGroup;
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
    dxLayout1Item9: TdxLayoutItem;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item8: TdxLayoutItem;
    ImageList1: TImageList;
    PMenu1: TPopupMenu;
    N2: TMenuItem;
    N1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Radio1Click(Sender: TObject);
    procedure ProductTree1Change(Sender: TObject; Node: TTreeNode);
    procedure ListInfo1Click(Sender: TObject);
    procedure ImagePicDblClick(Sender: TObject);
    procedure EditPlantPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditProviderPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
    FPlantID,FProviderID: string;
    //记录标识
    FDisplayRect: TRect;
    //显示区域
    FProductList: TList;
    //产品列表
    FOldCloseForm: TNotifyEvent;
    //旧有事件
    procedure InitFormData;
    //初始数据
    procedure ClearProductList(const nFree: Boolean);
    //清理资源
    procedure OnCloseActiveForm(Sender: TObject);
    //活动窗口关闭
    procedure LoadProductByPlant;
    procedure LoadProductByType;
    //载入产品列表 
    procedure LoadProductInfo(const nID: string);
    //载入产品信息
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
    //载入方案信息
  public
    { Public declarations }
  end;

function ShowProductView2Form(const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, USysGrid, USysDB, USysConst,
  USysGobal, USysDataFun, UFormProductView, UFormProvider, UFormPlant,
  UFormViewImage;
                              
const
  cMaxHeight       = 456;
  cImageIndex_Group = 0;
  cImageIndex_Product = 1;
  cImageIndex_Selected = 2;
  cImageIndex_NowSelected = 3;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: 显示区域
//Desc: 在nRect区域显示产品浏览窗口
function ShowProductView2Form(const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormProductView2.Create(Application);
  Result := gForm;

  with TfFormProductView2(Result) do
  begin
    FDisplayRect := nRect;
    InitFormData;
    if not Showing then Show;
  end;
end;

procedure TfFormProductView2.FormCreate(Sender: TObject);
begin
  WindowState := wsMaximized;
  DoubleBuffered := True;

  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;
  inherited;

  FProductList := TList.Create;
  ResetHintAllCtrl(Self, 'T', sTable_Product);
  LoadMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormProductView2.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    SaveMCListBoxConfig(Name, ListInfo1);
    gForm := nil;
    ClearProductList(True);

    gOnCloseActiveForm := FOldCloseForm;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);
  end;
end;

procedure TfFormProductView2.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

procedure TfFormProductView2.OnCloseActiveForm(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
procedure TfFormProductView2.InitFormData;
begin
  if Radio1.Checked then LoadProductByPlant else
  if Radio2.Checked then LoadProductByType;
end;

//Desc: 清理产品信息
procedure TfFormProductView2.ClearProductList(const nFree: Boolean);
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

//Desc: 设置数据
function TfFormProductView2.SetData(Sender: TObject; const nData: string): Boolean;
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

//Desc: 载入编号为nID的产品
procedure TfFormProductView2.LoadProductInfo(const nID: string);
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

//------------------------------------------------------------------------------
//Desc: 调整设置面板位置
procedure TfFormProductView2.FormResize(Sender: TObject);
var nH: integer;
begin
  nH := wPanel.Height - 20;
  if nH <= cMaxHeight then
       dxLayout1.Height := nH
  else dxLayout1.Height := cMaxHeight;

  dxLayout1.Top := Round((wPanel.Height - dxLayout1.Height) / 2);
  dxLayout1.Left := Round((wPanel.Width - dxLayout1.Width) / 2);
end;

//Desc: 选择查看方式
procedure TfFormProductView2.Radio1Click(Sender: TObject);
begin
  if Radio1.Checked then LoadProductByPlant else
  if Radio2.Checked then LoadProductByType;
end;   

//Desc: 按生产商
procedure TfFormProductView2.LoadProductByPlant;
var nStr: string;
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
      nNode := ProductTree1.Items.AddChild(nil, '没有生厂商');
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
            ImageIndex := cImageIndex_Product;
            SelectedIndex := cImageIndex_NowSelected;
            Data := nItem;
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

//Desc: 按产品类型
procedure TfFormProductView2.LoadProductByType;
var nStr: string;
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
      nNode := ProductTree1.Items.AddChild(nil, '没有类别');
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
            ImageIndex := cImageIndex_Product;
            SelectedIndex := cImageIndex_NowSelected;
            Data := nItem;
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

//------------------------------------------------------------------------------
//Desc: 载入方案
procedure TfFormProductView2.ProductTree1Change(Sender: TObject; Node: TTreeNode);
begin
  if Assigned(Node) and (Node.ImageIndex <> cImageIndex_Group) then
  begin
    LoadProductInfo(PProductItem(Node.Data).FProduct);
  end;
end;

//Desc: 查看信息
procedure TfFormProductView2.ListInfo1Click(Sender: TObject);
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

//Desc: 查看图片
procedure TfFormProductView2.ImagePicDblClick(Sender: TObject);
var nRect: TRect;
begin
  if Assigned(ImagePic.Picture.Graphic) then
  begin
    nRect := wPanel.ClientRect;
    nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
    nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);
    ShowViewImageForm(ImagePic.Picture.Graphic, nRect);
  end;
end;

//Desc: 查看生产商
procedure TfFormProductView2.EditPlantPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);
  ShowViewPlantForm(FPlantID, nRect);
end;

//Desc: 查看供应商
procedure TfFormProductView2.EditProviderPropertiesButtonClick(
  Sender: TObject; AButtonIndex: Integer);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);
  ShowViewProviderForm(FProviderID, nRect);
end;

//Desc: 快捷菜单
procedure TfFormProductView2.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: //展开
      ProductTree1.FullExpand;
    20: //收起
      ProductTree1.FullCollapse;
  end;

  ProductTree1.Invalidate;
end;

end.
