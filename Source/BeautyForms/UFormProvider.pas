{*******************************************************************************
  作者: dmzn@163.com 2009-7-1
  描述: 供应商浏览
*******************************************************************************}
unit UFormProvider;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxGraphics, dxLayoutControl, cxButtonEdit, cxImage,
  cxMCListBox, cxTextEdit, cxMaskEdit, cxDropDownEdit, cxContainer, cxEdit,
  cxMemo, StdCtrls, cxControls, UTransPanel;

type
  TfFormProvider = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnExit: TButton;
    EditMemo: TcxMemo;
    EditInfo: TcxTextEdit;
    ListInfo1: TcxMCListBox;
    EditAddr: TcxTextEdit;
    ImagePic: TcxImage;
    cxTextEdit2: TcxTextEdit;
    EditName: TcxTextEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group4: TdxLayoutGroup;
    dxLayout1Item12: TdxLayoutItem;
    dxLayout1Item14: TdxLayoutItem;
    dxLayout1Item16: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item8: TdxLayoutItem;
    dxLayout1Item11: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    InfoItems: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
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
  public
    { Public declarations }
  end;

procedure ShowViewProviderForm(const nID: string; const nRect: TRect);
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, UAdjustForm, UFormCtrl, USysConst, USysGrid, USysDB, UFormViewImage;

//Date: 2009-7-1
//Parm: 供应商编号;显示区域
//Desc: 在nRect区域显示nID供应商的信息
procedure ShowViewProviderForm(const nID: string; const nRect: TRect);
begin
  with TfFormProvider.Create(Application) do
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
procedure TfFormProvider.FormCreate(Sender: TObject);
begin
  inherited;
  ResetHintAllCtrl(Self, 'T', sTable_Provider);  
  LoadMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormProvider.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveMCListBoxConfig(Name, ListInfo1);
end;

procedure TfFormProvider.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
procedure TfFormProvider.InitFormData(const nID: string);
var nStr: string;
begin
  nStr := 'Select * From %s Where P_ID=''%s''';
  nStr := Format(nStr, [sTable_Provider, nID]);

  LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '');
  FDM.LoadDBImage(FDM.SqlTemp, 'P_Image', ImagePic.Picture);

  ListInfo1.Clear;
  nStr := MacroValue(sQuery_ExtInfo, [MI('$Table', sTable_ExtInfo),
                     MI('$Group', sFlag_ProviderItem), MI('$ID', nID)]);
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
procedure TfFormProvider.ListInfo1Click(Sender: TObject);
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

procedure TfFormProvider.ImagePicDblClick(Sender: TObject);
begin
  if Assigned(ImagePic.Picture.Graphic) then
  begin
    Visible := False;
    ShowViewImageForm(ImagePic.Picture.Graphic, FDisplayRect);
    Visible := True;
  end;
end;

end.
