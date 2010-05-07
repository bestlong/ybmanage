{*******************************************************************************
  作者: dmzn@163.com 2009-6-30
  描述: 产品浏览
*******************************************************************************}
unit UFormProduct;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, UTransPanel, dxLayoutControl, cxControls,
  cxMemo, cxImage, cxMaskEdit, cxButtonEdit, cxContainer, cxEdit,
  cxTextEdit, StdCtrls, cxMCListBox;

type
  TfFormProduct = class(TfBgFormBase)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxLayout1Group1: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    EditPlant: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditProvider: TcxButtonEdit;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit3: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    ImagePic: TcxImage;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    cxMemo1: TcxMemo;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group4: TdxLayoutGroup;
    ListInfo1: TcxMCListBox;
    dxLayout1Item8: TdxLayoutItem;
    InfoItems: TcxTextEdit;
    dxLayout1Item9: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Group6: TdxLayoutGroup;
    EditType: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditInfo: TcxMemo;
    dxLayout1Item13: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure EditProviderPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditPlantPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure ImagePicDblClick(Sender: TObject);
  private
    { Private declarations }
    FRecordID: string;
    //记录编号
    FPlantID,FProviderID: string;
    //记录标识
    FDisplayRect: TRect;
    //显示区域
    procedure InitFormData(const nID: string);
    //初始化数据
    function SetData(Sender: TObject; const nData: string): Boolean;
  public
    { Public declarations }
  end;

function ShowViewProductForm(const nID: string; const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UAdjustForm, UFormCtrl, USysConst, USysDB, USysGrid, USysGobal,
  UFormProvider, UFormPlant, UFormViewImage;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-1
//Parm: 产品编号;显示区域
//Desc: 在nRect区域显示nID产品的信息
function ShowViewProductForm(const nID: string; const nRect: TRect): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormProduct.Create(Application);
  Result := gForm;

  with TfFormProduct(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FRecordID := nID;
    FDisplayRect := nRect;

    InitFormData(nID);
    if not Showing then Show;
  end;
end;

procedure TfFormProduct.FormCreate(Sender: TObject);
begin
  inherited;
  ResetHintAllCtrl(Self, 'T', sTable_Product);
  LoadMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormProduct.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    SaveMCListBoxConfig(Name, ListInfo1);
    gForm := nil;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
  end;
end;

procedure TfFormProduct.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 设置数据
function TfFormProduct.SetData(Sender: TObject; const nData: string): Boolean;
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

procedure TfFormProduct.InitFormData(const nID: string);
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

//Desc: 查看信息
procedure TfFormProduct.ListInfo1Click(Sender: TObject);
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

//Desc: 查看供应商
procedure TfFormProduct.EditProviderPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  Visible := False;
  ShowViewProviderForm(FProviderID, FDisplayRect);
  Visible := True;
end;

procedure TfFormProduct.EditPlantPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
begin
  Visible := False;
  ShowViewPlantForm(FPlantID, FDisplayRect);
  Visible := True;
end;

procedure TfFormProduct.ImagePicDblClick(Sender: TObject);
begin
  if Assigned(ImagePic.Picture.Graphic) then
  begin
    Visible := False;
    ShowViewImageForm(ImagePic.Picture.Graphic, FDisplayRect);
    Visible := True;
  end;
end;

end.
