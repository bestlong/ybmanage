{*******************************************************************************
  作者: dmzn@163.com 2009-7-1
  描述: 皮肤类型浏览
*******************************************************************************}
unit UFormSkinType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxGraphics, dxLayoutControl, cxButtonEdit, cxImage,
  cxMCListBox, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxContainer, cxEdit,
  cxMemo, StdCtrls, cxControls, UTransPanel;

type
  TfFormSkinType = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnExit: TButton;
    EditMemo: TcxMemo;
    EditInfo: TcxTextEdit;
    ListInfo1: TcxMCListBox;
    ImagePic: TcxImage;
    EditName: TcxTextEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item13: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditPart: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    InfoItems: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure ListInfo1Click(Sender: TObject);
    procedure ImagePicDblClick(Sender: TObject);
  private
    { Private declarations }
    FDisplayRect: TRect;
    //显示区域
    procedure InitFormData(const nID: string);
    //初始化数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
  public
    { Public declarations }
  end;

procedure ShowViewSkinTypeForm(const nID: string; const nRect: TRect);
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UAdjustForm, UFormCtrl, USysConst, USysGrid, USysDB, UFormViewImage;

//Date: 2009-7-1
//Parm: 供应商编号;显示区域
//Desc: 在nRect区域显示nID供应商的信息
procedure ShowViewSkinTypeForm(const nID: string; const nRect: TRect);
begin
  with TfFormSkinType.Create(Application) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FDisplayRect := nRect;
    InitFormData(nID);
    ShowModal;
    Free;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormSkinType.FormCreate(Sender: TObject);
begin
  inherited;
  ResetHintAllCtrl(Self, 'T', sTable_SkinType);  
  LoadMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormSkinType.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormSkinType.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 设置数据
function TfFormSkinType.SetData(Sender: TObject; const nData: string): Boolean;
var nStr: string;
begin
  Result := False;
  if nData = '' then Exit;

  if Sender = EditPart then
  begin
    Result := True;
    nStr := 'Select B_Text From %s Where B_Group=''%s'' and B_ID=%s';
    nStr := Format(nStr, [sTable_BaseInfo, sFlag_SkinPart, nData]);
    
    with FDM.QueryTemp(nStr) do
     if RecordCount = 1 then
      EditPart.Text := nData + '、' + Fields[0].AsString;
  end;
end;

procedure TfFormSkinType.InitFormData(const nID: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where T_ID=''%s''';
  nStr := Format(nStr, [sTable_SkinType, nID]);
    
  LoadDataToCtrl(FDM.QuerySQL(nStr), Self, '', SetData);
  FDM.LoadDBImage(FDM.SqlQuery, 'T_Image', ImagePic.Picture);

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

procedure TfFormSkinType.ImagePicDblClick(Sender: TObject);
begin
  if Assigned(ImagePic.Picture.Graphic) then
  begin
    Visible := False;
    ShowViewImageForm(ImagePic.Picture.Graphic, FDisplayRect);
    Visible := True;
  end;
end;

end.
