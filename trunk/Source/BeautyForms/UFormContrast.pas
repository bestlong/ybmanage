{*******************************************************************************
  ����: dmzn@163.com 2009-7-5
  ����: ͼ��Ա�
*******************************************************************************}
unit UFormContrast;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, UDataModule, UBgFormBase, cxGraphics, Menus, ImgList,
  cxDropDownEdit, cxImageComboBox, UImageViewer, StdCtrls, cxTextEdit,
  cxControls, cxContainer, cxEdit, cxMaskEdit, cxButtonEdit, UTransPanel;

type
  TfFormContrast = class(TfBgFormBase)
    cxImage1: TcxImageList;
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
    BtnDel: TButton;
    ZnTransPanel2: TZnTransPanel;
    Label5: TLabel;
    BtnExit: TButton;
    EditStyle: TcxImageComboBox;
    wPanel: TZnTransPanel;
    ViewItem1: TImageViewItem;
    ViewItem3: TImageViewItem;
    ViewItem2: TImageViewItem;
    ViewItem4: TImageViewItem;
    Label6: TLabel;
    EditDesc: TcxTextEdit;
    Label1: TLabel;
    EditFilter: TcxButtonEdit;
    ScrollBox1: TScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure ViewItem1Selected(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure ViewItem1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure ViewItem1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure BtnDelClick(Sender: TObject);
    procedure EditFilterPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditStylePropertiesEditValueChanged(Sender: TObject);
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
    procedure VisibleAll(const nPCtrl: TWinControl; const nVisible: Boolean);
    procedure UpdateViewItem(const nPCtrl: TWinControl);
    procedure OneImageView(nPCtrl: TWinControl);
    procedure TwoModeContrast(const nPCtrl: TWinControl);
    procedure ThreeModeContrast(const nPCtrl: TWinControl);
    procedure FourModeContrast(const nPCtrl: TWinControl);
  public
    { Public declarations }
  end;

function ShowImageContrastForm(const nMemberID: string; const nRect: TRect): TForm;
//��ں���

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, USysGrid, USysDB, USysConst, USysGobal,
  UFormPickImage, UFormImageFilter;

const
  cIntervalBorder = 15;  //�߽�
  cIntervalHor    = 5;   //ˮƽ
  cIntervalVer    = 5;   //��ֱ
  cScaleWidth     = 4;   //�����
  cScaleHeight    = 3;   //�߱���

type
  PImageItem = ^TImageItem;
  TImageItem = record
   FID: integer;         //��ʶ
   FPart: string;        //��λ
   FDate: TDateTime;     //����
   FDesc: string;        //����
   FImage: TPicture;     //ͼ��
  end;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: ��ʾ����
//Desc: ��nRect������ʾͼ��Աȴ���
function ShowImageContrastForm(const nMemberID: string; const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormContrast.Create(Application);
  Result := gForm;

  with TfFormContrast(Result) do
  begin
    {
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );
    }
    FMemberID := nMemberID;
    FDisplayRect := nRect;

    InitFormData;
    if not Showing then Show;
  end;
end;

procedure TfFormContrast.FormCreate(Sender: TObject);
begin
  WindowState := wsMaximized;
  DoubleBuffered := True;

  FActiveViewItem := nil;
  FImageList := TList.Create;
  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;

  LoadImageViewItemConfig(Name, ViewItem1);
  LoadImageViewItemConfig(Name, ViewItem2);
  LoadImageViewItemConfig(Name, ViewItem3);
  LoadImageViewItemConfig(Name, ViewItem4);
  inherited;
end;

procedure TfFormContrast.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    gForm := nil;
    gOnCloseActiveForm := FOldCloseForm;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);

    ClearImageList(True);
    //������Դ
  end;
end;

procedure TfFormContrast.FormShow(Sender: TObject);
begin
  EditStyle.ItemIndex := 1;
  EditStyle.SetFocus;
  TwoModeContrast(wPanel);
end;

procedure TfFormContrast.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

procedure TfFormContrast.OnCloseActiveForm(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
//Desc: ����ͼƬ�б�
procedure TfFormContrast.ClearImageList(const nFree: Boolean);
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

//Desc: ����nPCtrl�ϵ����пؼ�
procedure TfFormContrast.VisibleAll(const nPCtrl: TWinControl;
 const nVisible: Boolean);
var i,nCount: integer;
begin
  nCount := nPCtrl.ControlCount - 1;
  for i:=0 to nCount do
   nPCtrl.Controls[i].Visible := nVisible;
end;

//Desc: �������ģʽ
procedure TfFormContrast.OneImageView(nPCtrl: TWinControl);
var nW,nH: integer;
begin
  VisibleAll(nPCtrl, False);
  ViewItem1.Visible := True;

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

//Desc: ˫�Ա�ģʽ
procedure TfFormContrast.TwoModeContrast(const nPCtrl: TWinControl);
var nW,nH,nX,nY: integer;
begin
  VisibleAll(nPCtrl, False);
  ViewItem1.Visible := True;
  ViewItem2.Visible := True;

  nH := nPCtrl.Height - cIntervalBorder * 2;
  nW := Round((nPCtrl.Width - cIntervalBorder * 2 - cIntervalHor) / 2);

  if (nW / nH) > (cScaleWidth / cScaleHeight) then
  begin
    ViewItem1.Height := nH;
    ViewItem2.Height := nH;
    ViewItem1.Width := Round(nH * cScaleWidth / cScaleHeight);
    ViewItem2.Width := ViewItem1.Width;
  end else
  begin
    ViewItem1.Width := nW;
    ViewItem2.Width := nW;
    ViewItem1.Height := Round(nW / (cScaleWidth / cScaleHeight));
    ViewItem2.Height := ViewItem1.Height;
  end;

  nW := ViewItem1.Width * 2 + cIntervalHor;
  nX := Round((nPCtrl.Width - nW) / 2);
  ViewItem1.Left := nX;
  ViewItem2.Left := nX + ViewItem1.Width + cIntervalHor;

  nY := Round((nPCtrl.Height - ViewItem1.Height) / 2);
  ViewItem1.Top := nY;
  ViewItem2.Top := nY;
end;

//Desc: ���Ա�ģʽ
procedure TfFormContrast.ThreeModeContrast(const nPCtrl: TWinControl);
var nW,nH,nX,nY: integer;
begin
  VisibleAll(nPCtrl, True);
  ViewItem4.Visible := False;

  nW := Round((nPCtrl.Width - cIntervalBorder * 2 - cIntervalHor) / 2);
  nH := Round((nPCtrl.Height - cIntervalBorder * 2 - cIntervalVer) / 2);

  if (nW / nH) > (cScaleWidth / cScaleHeight) then
  begin
    ViewItem1.Height := nH;
    ViewItem2.Height := nH; ViewItem3.Height := nH;

    ViewItem1.Width := Round(nH * cScaleWidth / cScaleHeight);
    ViewItem2.Width := ViewItem1.Width; ViewItem3.Width := ViewItem1.Width;
  end else
  begin
    ViewItem1.Width := nW;
    ViewItem2.Width := nW; ViewItem3.Width := nW;

    ViewItem1.Height := Round(nW / (cScaleWidth / cScaleHeight));
    ViewItem2.Height := ViewItem1.Height; ViewItem3.Height := ViewItem1.Height;
  end;

  nX := Round((nPCtrl.Width - ViewItem1.Width) / 2);
  ViewItem1.Left := nX;

  nW := ViewItem2.Width * 2 + cIntervalHor;
  nX := Round((nPCtrl.Width - nW) / 2);

  ViewItem2.Left := nX;
  ViewItem3.Left := nX + ViewItem2.Width + cIntervalHor;

  nH := ViewItem1.Height * 2 + cIntervalVer;
  nY := Round((nPCtrl.Height - nH) / 2);
  
  ViewItem1.Top := nY;
  ViewItem2.Top := nY + ViewItem1.Height + cIntervalVer;
  ViewItem3.Top := ViewItem2.Top;
end;

//Desc: �ĶԱ�ģʽ
procedure TfFormContrast.FourModeContrast(const nPCtrl: TWinControl);
var nW,nH,nX,nY: integer;
begin
  VisibleAll(nPCtrl, True);
  nW := Round((nPCtrl.Width - cIntervalBorder * 2 - cIntervalHor) / 2);
  nH := Round((nPCtrl.Height - cIntervalBorder * 2 - cIntervalVer) / 2);

  if (nW / nH) > (cScaleWidth / cScaleHeight) then
  begin
    ViewItem1.Height := nH; ViewItem2.Height := nH;
    ViewItem3.Height := nH; ViewItem4.Height := nH;

    ViewItem1.Width := Round(nH * cScaleWidth / cScaleHeight);
    ViewItem2.Width := ViewItem1.Width;
    ViewItem3.Width := ViewItem1.Width; ViewItem4.Width := ViewItem1.Width;
  end else
  begin
    ViewItem1.Width := nW; ViewItem1.Width := nW;
    ViewItem3.Width := nW; ViewItem4.Width := nW;

    ViewItem1.Height := Round(nW / (cScaleWidth / cScaleHeight));
    ViewItem2.Height := ViewItem1.Height;
    ViewItem3.Height := ViewItem1.Height; ViewItem4.Height := ViewItem1.Height;
  end;

  nW := ViewItem1.Width * 2 + cIntervalHor;
  nX := Round((nPCtrl.Width - nW) / 2);
  ViewItem1.Left := nX;
  ViewItem3.Left := nX;
  ViewItem2.Left := nX + ViewItem1.Width + cIntervalHor;
  ViewItem4.Left := ViewItem2.Left;

  nH := ViewItem1.Height * 2 + cIntervalVer;
  nY := Round((nPCtrl.Height - nH) / 2);
  ViewItem1.Top := nY;
  ViewItem2.Top := nY;
  ViewItem3.Top := nY + ViewItem1.Height + cIntervalVer;
  ViewItem4.Top := ViewItem3.Top;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ������
procedure TfFormContrast.InitFormData;
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
procedure TfFormContrast.LoadImageList(const nWhere, nFilter: string);
var nStr: string;
    nItem: PImageItem;
begin
  EditFilter.Text := nFilter;
  ClearImageList(False);

  nStr := 'Select P_ID,P_Date,P_Desc,P_Image,' +
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
       nItem.FDesc := FieldByName('P_Desc').AsString;
       nItem.FDate := FieldByName('P_Date').AsDateTime;

       nItem.FImage := TPicture.Create;
       FDM.LoadDBImage(FDM.SqlTemp, 'P_Image', nItem.FImage);
       Next;
     end;
   end;
end;

//Desc: ��ͼƬ�������
procedure TfFormContrast.LoadImageItem;
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

//Desc: ����ͼ����ʾ
procedure TfFormContrast.UpdateViewItem(const nPCtrl: TWinControl);
var nIdx: integer;
begin
  for nIdx:=nPCtrl.ControlCount - 1 downto 0 do
   if nPCtrl.Controls[nIdx] is TImageViewItem then
    TImageViewItem(nPCtrl.Controls[nIdx]).InvalidateItem;
end;

//Desc: ������ʾ����
procedure TfFormContrast.EditStylePropertiesEditValueChanged(
  Sender: TObject);
begin
  case EditStyle.ItemIndex of
   0: OneImageView(wPanel);
   1: TwoModeContrast(wPanel);
   2: ThreeModeContrast(wPanel);
   3: FourModeContrast(wPanel);
  end;

  wPanel.InvalidPanel;
  UpdateViewItem(wPanel);
end;

//Desc: �����ݲ˵�
procedure TfFormContrast.N1Click(Sender: TObject);
var nItem: TImageViewItem;
begin
  nItem := TImageViewItem(PMenu1.PopupComponent);

  case TComponent(Sender).Tag of
    10: nItem.SetFitSize;
    20: nItem.SetNormalSize;
    30: nItem.SetPercentSize(0.5);
    40: nItem.SetPercentSize(0.75);
    50: nItem.SetPercentSize(1.2);
    60: nItem.SetPercentSize(1.5);
    70: nItem.SetPercentSize(2);
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
procedure TfFormContrast.LoadViewItemInfo(const nID: Integer);
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
procedure TfFormContrast.ViewItem1Selected(Sender: TObject);
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
procedure TfFormContrast.OnViewItemBeginDrag(Sender: TObject; var nCanDrag: Boolean);
begin
  nCanDrag := True;
end;

procedure TfFormContrast.ViewItem1DragOver(Sender, Source: TObject; X,
  Y: Integer; State: TDragState; var Accept: Boolean);
begin
  inherited;
  Accept := Source is TImage;
end;

procedure TfFormContrast.ViewItem1DragDrop(Sender, Source: TObject; X,
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
//Desc: ɾ��ͼ��
procedure TfFormContrast.BtnDelClick(Sender: TObject);
var nStr: string;
    i,nCount,nTag: integer;
begin
  if not (Assigned(FActiveViewItem) and
     QueryDlg('ȷ��Ҫɾ����ͼ����?', sAsk)) then Exit;

  FDM.ADOConn.BeginTrans;
  try
    nStr := 'Delete From %s Where P_ID=%d';
    nTag := FActiveViewItem.Image.Tag;

    nStr := Format(nStr, [sTable_PickImage, nTag]);
    FDM.ExecuteSQL(nStr);

    if gSysDBType = dtAccess then
    begin
      nStr := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nStr := Format(nStr, [sTable_SyncItem, sTable_PickImage, 'P_MID', FMemberID]);
      FDM.ExecuteSQL(nStr);
    end; //��¼���

    FDM.ADOConn.CommitTrans;
    EditDate.Clear;
    EditPart.Clear;
    EditSize.Clear;

    FActiveViewItem := nil;
    nCount := ScrollBox1.ControlCount - 1;

    for i:=0 to nCount do
    if TImageViewItem(ScrollBox1.Controls[i]).Image.Tag = nTag then
    begin
      ScrollBox1.Controls[i].Visible := False;
      TImageViewItem(ScrollBox1.Controls[i]).Image.Tag := 0;
    end;

    nCount := wPanel.ControlCount - 1;
    for i:=0 to nCount do
     if TImageViewItem(wPanel.Controls[i]).Image.Tag = nTag then
     with TImageViewItem(wPanel.Controls[i]) do
     begin
       Image.Tag := 0;
       Image.Picture.Graphic := nil;
       Title := '����Ч';
     end;

    FDM.ShowMsg('ͼ���ѳɹ�ɾ��', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('ɾ��ͼ��ʱ�����쳣', sError);
  end;
end;

//Desc: ɸѡͼ��
procedure TfFormContrast.EditFilterPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nHint: string;
begin
  if ShowImageFilterForm(FWhere, nHint) then
  begin
    LoadImageList(FWhere, nHint);
    LoadImageItem;
  end;
end;

end.
