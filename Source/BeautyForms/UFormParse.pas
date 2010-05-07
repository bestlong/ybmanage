{*******************************************************************************
  ����: dmzn@163.com 2009-7-20
  ����: ͼ�����
*******************************************************************************}
unit UFormParse;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, UDataModule, UBgFormBase, Menus, UImageViewer, cxMaskEdit,
  cxButtonEdit, StdCtrls, cxControls, cxContainer, cxEdit, cxTextEdit,
  UTransPanel;

type
  TfFormParse = class(TfBgFormBase)
    LPanel1: TZnTransPanel;
    ScrollBox1: TScrollBox;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N501: TMenuItem;
    N751: TMenuItem;
    N1201: TMenuItem;
    N1501: TMenuItem;
    N2001: TMenuItem;
    RTPanel: TZnTransPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditDate: TcxTextEdit;
    EditPart: TcxTextEdit;
    EditSize: TcxTextEdit;
    BPanel1: TZnTransPanel;
    BtnExit: TButton;
    wPanel: TZnTransPanel;
    ViewItem1: TImageViewItem;
    Label6: TLabel;
    EditDesc: TcxTextEdit;
    Label1: TLabel;
    EditFilter: TcxButtonEdit;
    BtnSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ViewItem1Selected(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewItem1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ViewItem1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure EditFilterPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnSaveClick(Sender: TObject);
  private
    { Private declarations }
    FWhere: string;
    //��������
    FMemberID: string;
    //��Ա���
    FDisplayRect: TRect;
    //��ʾ����
    FImageList: TList;
    //ͼƬ�б�
    FActiveViewItem: TImageViewItem;
    //�ͼƬ
    FOldCloseForm: TNotifyEvent;
    //�����¼�
    procedure InitFormData;
    //��ʼ����
    procedure ClearImageList(const nFree: Boolean);
    //������Դ
    procedure LoadImageList(const nWhere, nFilter: string);
    //��ȡͼƬ
    procedure LoadImageItem;
    //���뵽����
    procedure LoadViewItemInfo(const nID: Integer);
    //������Ϣ
    procedure OnCloseActiveForm(Sender: TObject);
    //����ڹر�
    procedure OnViewItemBeginDrag(Sender: TObject; var nCanDrag: Boolean);
    //��ʼ�Ϸ�
    procedure OneImageView(nPCtrl: TWinControl);
    //�������
  public
    { Public declarations }
  end;

function ShowImageParseForm(const nMemberID: string; const nRect: TRect): TForm;
//��ں���

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, USysGrid, USysDB, USysConst, USysGobal,
  UFormPickImage, UFormImageFilter, UFormParseData;

const
  cIntervalBorder = 15;  //�߽�
  cIntervalHor    = 5;   //ˮƽ
  cIntervalVer    = 5;   //��ֱ
  cScaleWidth     = 4;   //�����
  cScaleHeight    = 3;   //�߱���

  cRPanelWidth    = 355; //��������

type
  PImageItem = ^TImageItem;
  TImageItem = record
   FID: integer;         //��ʶ
   FPart: string;        //��λ
   FPartID: Integer;     //��ʶ
   FDate: TDateTime;     //����
   FDesc: string;        //����
   FImage: TPicture;     //ͼ��
  end;

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

  gForm := TfFormParse.Create(Application);
  Result := gForm;

  with TfFormParse(Result) do
  begin
    FormStyle := fsNormal;
    FMemberID := nMemberID;
    FDisplayRect := nRect;

    InitFormData;
    if not Showing then Show;
  end;
end;

procedure TfFormParse.FormCreate(Sender: TObject);
begin
  WindowState := wsMaximized;
  DoubleBuffered := True;

  FActiveViewItem := nil;
  FImageList := TList.Create;
  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;

  LoadImageViewItemConfig(Name, ViewItem1);
  inherited;
end;

procedure TfFormParse.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    gForm := nil;
    gOnCloseActiveForm := FOldCloseForm;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);

    CloseParseDataForm;
    //�ر�������
    ClearImageList(True);
    //������Դ
  end;
end;

procedure TfFormParse.FormShow(Sender: TObject);
var nRect: TRect;
begin
  OneImageView(wPanel);

  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);
  ShowParseDataForm(FMemberID, nRect);
end;

procedure TfFormParse.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

procedure TfFormParse.OnCloseActiveForm(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
//Desc: ����ͼƬ�б�
procedure TfFormParse.ClearImageList(const nFree: Boolean);
var nIdx: integer;
    nItem: PImageItem;
begin
  for nIdx:=FImageList.Count - 1 downto 0 do
  begin
    nItem := FImageList[nIdx];
    if Assigned(nItem.FImage) then
      nItem.FImage.Free;
    Dispose(nItem);
    FImageList.Delete(nIdx);
  end;

  if nFree then FreeAndNil(FImageList);
end;

//Desc: �������ģʽ
procedure TfFormParse.OneImageView(nPCtrl: TWinControl);
var nW,nH: integer;
begin
  nH := nPCtrl.Height - cIntervalBorder * 2;
  nW := nPCtrl.Width - cIntervalBorder * 2;

  if (nW / nH) > (cScaleWidth / cScaleHeight) then
  begin
    ViewItem1.Height := nH;
    ViewItem1.Width := Round(nH * cScaleWidth / cScaleHeight);
  end else
  begin
    ViewItem1.Width := nW;
    ViewItem1.Height := Round(nW / (cScaleWidth / cScaleHeight));
  end;

  ViewItem1.Left := Round((nPCtrl.Width - ViewItem1.Width) / 2);
  ViewItem1.Top := Round((nPCtrl.Height - ViewItem1.Height) / 2);
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormParse.InitFormData;
begin
  if gSysDBType = dtAccess then
       FWhere := 'P_Date>=#%s# And P_Date<#%s#'
  else FWhere := 'P_Date>=''%s'' And P_Date<''%s''';

  FWhere := Format(FWhere, [Date2Str(Date), Date2Str(Date + 1)]); 
  LoadImageList(FWhere, '����ɼ���ͼ��');
  LoadImageItem;
end;

//Date: 2009-7-7
//Parm: ɸѡ����;ɸѡ��ʾ
//Desc: ʹ��nWhere����ͼƬ�б�
procedure TfFormParse.LoadImageList(const nWhere, nFilter: string);
var nStr: string;
    nItem: PImageItem;
begin
  EditFilter.Text := nFilter;
  ClearImageList(False);

  nStr := 'Select P_ID,P_Date,P_Desc,P_Image,P_Part,' +
          ' (Select B_Text From $Base Where B_Group=''$G'' And B_ID=P_Part) as P_PName ' +
          'From $IMG Where P_MID=''$MID''';

  nStr := MacroValue(nStr, [MI('$Base', sTable_BaseInfo), MI('$G', sFlag_SkinPart),
                            MI('$IMG', sTable_PickImage), MI('$MID', FMemberID)]);
  if nWhere <> '' then nStr := nStr + ' And ' + nWhere;

  with FDM.QueryTemp(nStr) do
   if RecordCount > 0 then
   begin
     First;

     while not Eof do
     begin
       New(nItem);
       FImageList.Add(nItem);

       nItem.FID := FieldByName('P_ID').AsInteger;
       nItem.FPart := FieldByName('P_PName').AsString;
       nItem.FPartID := FieldByName('P_Part').AsInteger;
       nItem.FDesc := FieldByName('P_Desc').AsString;
       nItem.FDate := FieldByName('P_Date').AsDateTime;

       nItem.FImage := TPicture.Create;
       FDM.LoadDBImage(FDM.SqlTemp, 'P_Image', nItem.FImage);
       Next;
     end;
   end;
end;

//Desc: ��ͼƬ�������
procedure TfFormParse.LoadImageItem;
var nItem: PImageItem;
    nView: TImageViewItem;
    i,nCount,nIdx: integer;
begin
  nIdx := 0;
  nView := nil;
  nCount := FImageList.Count - 1;

  ScrollBox1.DisableAutoRange;
  try
    for i:=0 to nCount do
    begin
      nItem := FImageList[i];
      if not Assigned(nItem.FImage.Graphic) then Continue;

      if nIdx < ScrollBox1.ControlCount then
      begin
        nView := TImageViewItem(ScrollBox1.Controls[nIdx]);
        nView.Visible := True;
      end else
      begin
        nView := TImageViewItem.Create(ScrollBox1);
        nView.Parent := ScrollBox1;
        nView.Align := alTop;
        nView.Height := Round(ScrollBox1.Width / (4 / 3));

        nView.SetFitSize;
        nView.OnBeginDrag := OnViewItemBeginDrag;
        nView.OnSelected := ViewItem1Selected;
        LoadImageViewItemConfig(Name, nView);
      end;

      Inc(nIdx);
      nView.Title := Date2Str(nItem.FDate);
      nView.Image.Tag := nItem.FID;
      nView.Image.Picture := nItem.FImage;
    end;

    while nIdx < ScrollBox1.ControlCount do
    begin
      ScrollBox1.Controls[nIdx].Visible := False;
      Inc(nIdx);
    end;
  finally
    ScrollBox1.EnableAutoRange;

    if nIdx > 0 then
      ScrollBox1.ScrollInView(nView);
    //xxxxx
  end;
end;

//Desc: �����ݲ˵�
procedure TfFormParse.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: ViewItem1.SetFitSize;
    20: ViewItem1.SetNormalSize;
    30: ViewItem1.SetPercentSize(0.5);
    40: ViewItem1.SetPercentSize(0.75);
    50: ViewItem1.SetPercentSize(1.2);
    60: ViewItem1.SetPercentSize(1.5);
    70: ViewItem1.SetPercentSize(2);
  end;
end;

//Desc: ��nList�м���nID��
function FindImageItem(const nList: TList; const nID: Integer): PImageItem;
var i,nCount: integer;
begin
  Result := nil;
  nCount := nList.Count - 1;

  for i:=0 to nCount do
  if PImageItem(nList[i]).FID = nID then
  begin
    Result := nList[i]; Break;
  end;
end;

//Desc: �����ʶΪnID��ͼ����Ϣ
procedure TfFormParse.LoadViewItemInfo(const nID: Integer);
var nItem: PImageItem;
begin
  nItem := FindImageItem(FImageList, nID);
  if Assigned(nItem) then
  begin
    EditDate.Text := DateTime2Str(nItem.FDate);
    EditPart.Text := nItem.FPart;
    EditDesc.Text := nItem.FDesc;
    
    EditSize.Text := IntToStr(nItem.FImage.Width) + ' x ' +
                     IntToStr(nItem.FImage.Height);
    FActiveViewItem.Title := Date2Str(nItem.FDate);
  end else
  begin
    EditDate.Clear;
    EditPart.Clear;
    EditDesc.Clear;

    EditSize.Clear;
    FActiveViewItem.Title := '';
  end;
end;

//Desc: ȡ������ѡ��
procedure TfFormParse.ViewItem1Selected(Sender: TObject);
var i,nCount: integer;
    nPCtrl: TWinControl;
    nItem: TImageViewItem;
begin
  nItem := TImageViewItem(Sender);
  if not nItem.Selected then Exit;

  FActiveViewItem := nItem;
  LoadViewItemInfo(nItem.Image.Tag);

  nPCtrl := nItem.Parent;
  nCount := nPCtrl.ControlCount - 1;
  
  for i:=0 to nCount do
   if (nPCtrl.Controls[i] <> Sender) and
      (nPCtrl.Controls[i] is TImageViewItem) then
    TImageViewItem(nPCtrl.Controls[i]).Selected := False;
end;

//------------------------------------------------------------------------------
procedure TfFormParse.OnViewItemBeginDrag(Sender: TObject; var nCanDrag: Boolean);
begin
  nCanDrag := True;
end;

procedure TfFormParse.ViewItem1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  Accept := Source is TImage;
end;

procedure TfFormParse.ViewItem1DragDrop(Sender, Source: TObject; X,
  Y: Integer);
var nD: TImageViewItem;
begin
  nD := TImageViewItem(Sender);
  nD.SetFitSize;

  nD.Image.Tag := TImage(Source).Tag;
  nD.Image.Picture.Graphic := TImage(Source).Picture.Graphic;

  FActiveViewItem := nD;
  LoadViewItemInfo(nD.Image.Tag);
end;

//------------------------------------------------------------------------------
//Desc: ɸѡͼ��
procedure TfFormParse.EditFilterPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nHint: string;
begin
  if ShowImageFilterForm(FWhere, nHint) then
  begin
    LoadImageList(FWhere, nHint);
    LoadImageItem;
  end;
end;

//Desc: ��������
procedure TfFormParse.BtnSaveClick(Sender: TObject);
var nStr,nID: string;
    nItem: PImageItem;
begin
  if not SaveParseData(nID) then Exit;

  if (nID <> '') and Assigned(FActiveViewItem) then
  begin
    nStr := 'Select * From %s Where T_ID=''%s''';
    nStr := Format(nStr, [sTable_SkinType, nID]);

    with FDM.QueryTemp(nStr) do
    if RecordCount < 1 then
    begin
      FDM.ShowMsg('������������ʧ��', sError); Exit;
    end;

    if not FDM.SaveDBImage(FDM.SqlTemp, 'T_Image',
       ViewItem1.Image.Picture.Graphic) then
    begin
      FDM.ShowMsg('����Ƥ��ͼ������ʧ��', sError); Exit;
    end;

    nItem := FindImageItem(FImageList, FActiveViewItem.Image.Tag);
    if Assigned(nItem) then
    begin
      nStr := 'Update %s Set T_Part=%s Where T_ID=''%s''';
      nStr := Format(nStr, [sTable_SkinType, IntToStr(nItem.FPartID), nID]);
      FDM.ExecuteSQL(nStr);
    end;
  end;

  CloseForm;
  FDM.ShowMsg('�������ݱ���ɹ�', sHint);
end;

end.
