{*******************************************************************************
  作者: dmzn@163.com 2009-7-3
  描述: 图像采集
*******************************************************************************}
unit UFormPickImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, DSUtil, DirectShow9, UBgFormBase, cxGraphics, DSPack,
  dxLayoutControl, StdCtrls, cxContainer, cxEdit, cxTextEdit, cxMaskEdit,
  cxDropDownEdit, cxControls, UTransPanel, ExtCtrls, Menus, UImageViewer;

type
  TfFormPickImage = class(TfBgFormBase)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    dxGroup2: TdxLayoutGroup;
    VideoWindow1: TVideoWindow;
    dxLayout1Item1: TdxLayoutItem;
    EditPart: TcxComboBox;
    dxLayout1Item3: TdxLayoutItem;
    BtnPick: TButton;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item5: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group5: TdxLayoutGroup;
    FilterGraph1: TFilterGraph;
    SampleGrabber1: TSampleGrabber;
    VideoFilter1: TFilter;
    ViewItem1: TImageViewItem;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N501: TMenuItem;
    N751: TMenuItem;
    N1201: TMenuItem;
    N1501: TMenuItem;
    N2001: TMenuItem;
    ScrollBox1: TScrollBox;
    dxLayout1Item7: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    PMenu2: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    EditDesc: TcxTextEdit;
    dxLayout1Item8: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnPickClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
  private
    { Private declarations }
    FMemberID: string;
    //会员编号
    FDisplayRect: TRect;
    //显示区域
    FSysDev: TSysDevEnum;
    //设备对象
    FMediaTypes: TEnumMediaType;
    //媒体类型

    FDevName: string;
    FSizeName: string;
    FDevList: TStrings;
    FSizeList: TStrings;
    //设备信息

    procedure InitFormData;
    //初始数据
    procedure LoadCameraConfig;
    //载入配置
    procedure LoadCameraSizeList(const nDevIdx: integer);
    procedure SetCameraSize(const nSizeIdx: integer);
    //画面比例
    procedure OpenCamera;
    procedure CloseCamera;
    //开&关摄像头
    procedure DoViewItemSelected(Sender: TObject);
    //图像选中
  public
    { Public declarations }
  end;

procedure LoadImageViewItemConfig(const nID: string; const nItem: TImageViewItem);
function ShowPickImageForm(const nMemberID: string; const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UAdjustForm, USysGrid, USysDB, USysConst, USysGobal,
  UFormInputbox;

type
  TImageViewInfo = record
    FTime: string;      //采集时间
    FPart: string;      //采集部位
    FDesc: string;      //图片描述
  end;

var
  gForm: TForm = nil;
  gImageInfo: array of TImageViewInfo;

//------------------------------------------------------------------------------
//Date: 2009-7-3
//Parm: 显示区域
//Desc: 在nRect区域显示图像采集窗口
function ShowPickImageForm(const nMemberID: string; const nRect: TRect): TForm;
begin
  Result := gForm;
  if Assigned(gForm) then Exit;

  gForm := TfFormPickImage.Create(gForm);
  Result := gForm;

  with TfFormPickImage(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FMemberID := nMemberID;
    FDisplayRect := nRect;
    
    InitFormData;
    if not Showing then Show;
  end;
end;

//Date: 2009-7-5
//Parm: 特定标识;待配置对象
//Desc: 使用nID配置nItem对象,若不存在则使用默认配置
procedure LoadImageViewItemConfig(const nID: string; const nItem: TImageViewItem);
var nIni: TIniFile;
    nList: TStrings;
    nImage: TPicture;
    nStr,nSection: string;
begin
  nIni := nil;
  nList := nil;
  nImage := nil;
  try
    nIni := TIniFile.Create(gPath + sImageConfigFile);
    nImage := TPicture.Create;

    nSection := sImageViewItem + '_' + nID;
    nStr := nIni.ReadString(nSection, sImageBgFile, '');

    if nStr = '' then
    begin
      nSection := sImageViewItem;
      nStr := nIni.ReadString(nSection, sImageBgFile, '');
    end;

    nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);
    if FileExists(nStr) then
    begin
      nImage.LoadFromFile(nStr);
      nItem.BgImage := nImage.Graphic;
    end; //背景

    nStr := nIni.ReadString(nSection, sImageBgStyle, '');
    if CompareText(nStr, 'Tile') = 0 then
         nItem.BgStyle := bsTile
    else nItem.BgStyle := bsStretch; //背景风格

    nStr := nIni.ReadString(nSection, sImageBrdSelected, '');
    nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);

    if FileExists(nStr) then
    begin
      nImage.LoadFromFile(nStr);
      nItem.BorderSelected := nImage.Graphic;
    end; //选中边框

    nStr := nIni.ReadString(nSection, sImageBrdUnSelected, '');
    nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);

    if FileExists(nStr) then
    begin
      nImage.LoadFromFile(nStr);
      nItem.BorderUnSelected := nImage.Graphic;
    end; //未选中风格

    nList := TStringList.Create;
    nStr := nIni.ReadString(nSection, sImagePointTitle, '');

    if SplitStr(nStr, nList, 2, ',') and
       IsNumber(nList[0], False) and IsNumber(nList[1], False) then
    begin
      nItem.TitlePos := Point(StrToInt(nList[0]), StrToInt(nList[1]));
    end; //标题位置

    nStr := nIni.ReadString(nSection, sImageRectValid, '');
    if SplitStr(nStr, nList, 4, ',') and
       IsNumber(nList[0], False) and IsNumber(nList[1], False) and
       IsNumber(nList[2], False) and IsNumber(nList[3], False) then
    begin
      nItem.ValidRect := Rect(StrToInt(nList[0]), StrToInt(nList[1]),
                              StrToInt(nList[2]), StrToInt(nList[3]));
    end; //有效区域

    FreeAndNil(nIni);
    FreeAndNil(nList);
    FreeAndNil(nImage);
  except
    FreeAndNil(nIni);
    FreeAndNil(nList);
    FreeAndNil(nImage);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormPickImage.FormCreate(Sender: TObject);
var nIdx: integer;
begin
  BtnPick.Enabled := False;
  FDevList := TStringList.Create;
  FSizeList := TStringList.Create;

  FMediaTypes := TEnumMediaType.Create;
  FSysDev := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);

  nIdx := 0;
  while nIdx < FSysDev.CountFilters do
  begin
    FDevList.Add(GUIDToString(FSysDev.Filters[nIdx].CLSID) + '=' +
                 FSysDev.Filters[nIdx].FriendlyName);
    Inc(nIdx);
  end;

  if nIdx > 0 then
       dxGroup1.Caption := '采集区 - 没有视频设备'
  else dxGroup1.Caption := '采集区 - 未启动';

  LoadImageViewItemConfig(Name, ViewItem1);
  inherited;
end;

procedure TfFormPickImage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    gForm := nil;
    FreeAndNil(FDevList);
    FreeAndNil(FSizeList);
    ReleaseCtrlData(Self);

    CloseCamera;
    FMediaTypes.Free;
    FSysDev.Free;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(self);
  end;
end;

procedure TfFormPickImage.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

procedure TfFormPickImage.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; CloseForm;
  end;
end;

//Desc: 尝试开启摄像头
procedure TfFormPickImage.FormShow(Sender: TObject);
begin
  if FDevList.Count > 0 then
  begin
    LoadCameraConfig;
    CloseCamera;

    LoadCameraSizeList(FDevList.IndexOf(FDevName));
    SetCameraSize(FSizeList.IndexOf(FSizeName));
    OpenCamera;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 打开摄像头
procedure TfFormPickImage.OpenCamera;
begin
  FilterGraph1.Active := True; 
  if VideoFilter1.BaseFilter.DataLength > 0 then
   with FilterGraph1 as ICaptureGraphBuilder2 do
    RenderStream(@PIN_CATEGORY_PREVIEW, nil, VideoFilter1 as IBaseFilter,
                   SampleGrabber1 as IBaseFilter, VideoWindow1 as IBaseFilter);
  //xxxxx

  FilterGraph1.Play;
  BtnPick.Enabled := True;
  dxGroup1.Caption := '采集区 - 预览';
end;

//Desc: 关闭摄像头
procedure TfFormPickImage.CloseCamera;
begin
  FilterGraph1.ClearGraph;
  FilterGraph1.Active := False;
  FilterGraph1.Mode := gmCapture;

  BtnPick.Enabled := False;
  dxGroup1.Caption := '采集区 - 未启动';
end;

//Desc: 获取nMediaType画面比例的屏幕尺寸
function GetMediaTypeOfSize(const nMediaType: TAMMediaType): TPoint;
begin
  if IsEqualGUID(nMediaType.formattype, FORMAT_VideoInfo) or
     IsEqualGUID(nMediaType.formattype, FORMAT_VideoInfo2) or
     IsEqualGUID(nMediaType.formattype, FORMAT_MPEGVideo) or
     IsEqualGUID(nMediaType.formattype, FORMAT_MPEG2Video) then
  begin
    if ((nMediaType.cbFormat > 0) and Assigned(nMediaType.pbFormat)) then
      with PVideoInfoHeader(nMediaType.pbFormat)^.bmiHeader do
        Result := Point(biWidth, biHeight);
  end else Result := Point(0, 0);
end;

//------------------------------------------------------------------------------
//Desc: 读取配置
procedure TfFormPickImage.InitFormData;
var nStr: string;
begin
  nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
  nStr := Format(nStr, [sTable_BaseInfo, sFlag_SkinPart]);

  FDM.FillStringsData(EditPart.Properties.Items, nStr);
  AdjustStringsItem(EditPart.Properties.Items, False);
end;

//Desc: 读取摄像头配置
procedure TfFormPickImage.LoadCameraConfig;
var nStr: string;
    nIni: TIniFile;
begin
  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    FDevName := nIni.ReadString('fFormCameraSetup', 'SysDevName', '');
    FSizeName := nIni.ReadString('fFormCameraSetup', 'SysDevSize', '');
  finally
    nIni.Free;
  end;

  if (FDevName = '') or (FSizeName = '') then
  begin
    nStr := 'Select * From ' + sTable_Hardware;

    with FDM.QueryTemp(nStr) do
     if RecordCount > 0 then
     begin
       FDevName := FieldByName('H_Dev').AsString;
       FSizeName := FieldByName('H_Size').AsString;
     end;
  end;
end;

//Desc: 载入摄像头支持的画面比例
procedure TfFormPickImage.LoadCameraSizeList(const nDevIdx: integer);
var nStr: string;
    nIdx: integer;
    nList: TPinList;
begin
  FSizeList.Clear;
  if (nDevIdx < 0) or (nDevIdx >= FDevList.Count) then
       nIdx := 0
  else nIdx := nDevIdx;
  if nIdx >= FDevList.Count then Exit;

  nList := nil;
  try
    //CloseCamera;
    FSysDev.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);
    VideoFilter1.BaseFilter.Moniker := FSysDev.GetMoniker(nIdx);

    VideoFilter1.FilterGraph := FilterGraph1;
    FilterGraph1.Active := True;

    nList := TPinList.Create(VideoFilter1 as IBaseFilter);
    FMediaTypes.Assign(nList.First);

    for nIdx:=0 to FMediaTypes.Count - 1 do
    begin
      nStr := FMediaTypes.MediaDescription[nIdx];
      System.Delete(nStr, 1, Pos('VideoInfo', nStr) - 1);
      FSizeList.Add(nStr);
    end;

    FreeAndNil(nList);
  except
    CloseCamera;
    FreeAndNil(nList);
  end;
end;

//Desc: 设置画面比例
procedure TfFormPickImage.SetCameraSize(const nSizeIdx: integer);
var nP: TPoint;
    nIdx: integer;
    nList: TPinList;
begin
  nList := nil;
  if (nSizeIdx < 0) or (nSizeIdx >= FSizeList.Count) then
       nIdx := 0
  else nIdx := nSizeIdx;

  if nIdx < FSizeList.Count then
  try
    //CloseCamera;
    FilterGraph1.Active := True;
   nP := GetMediaTypeOfSize(FMediaTypes.Items[nIdx].AMMediaType^);

    if nP.X > 0 then VideoWindow1.Width := nP.X;
    if nP.Y > 0 then VideoWindow1.Height := nP.Y;

    ViewItem1.Width := VideoWindow1.Width;
    ViewItem1.Height := VideoWindow1.Height;
    Application.ProcessMessages;

    ClientPanel1.Width := BtnExit.Left + BtnExit.Width + 15;
    ClientPanel1.Height := BtnExit.Top + BtnExit.Height + 15;
    //工作区大小

    Width := ClientPanel1.Left + ClientPanel1.Width + FValidRect.Right;
    Height := ClientPanel1.Top + ClientPanel1.Height + FValidRect.Bottom;
    //窗体大小

    with FDisplayRect do
    begin
      Self.Left := Left + Round((Right - Left - Width) /2 );
      Self.Top := Top + Round((Bottom - Top - Height) /2 );
    end;
    Application.ProcessMessages;

    nList := TPinList.Create(VideoFilter1 as IBaseFilter);
    with (nList.First as IAMStreamConfig) do
      SetFormat(FMediaTypes.Items[nIdx].AMMediaType^);
    FreeAndNil(nList);
  except
    CloseCamera;
    FreeAndNil(nList);
  end;
end;

//Desc: 采集
procedure TfFormPickImage.BtnPickClick(Sender: TObject);
var nLen: integer;
    nView: TImageViewItem;
begin
  if EditPart.ItemIndex < 0 then
  begin
    FDM.ShowMsg('请选择采集部位', sHint); Exit;
  end;

  if not SampleGrabber1.GetBitmap(ViewItem1.Image.Picture.Bitmap) then
  begin
    FDM.ShowMsg('图像采集失败', sError); Exit;
  end;

  ViewItem1.SetFitSize;
  ViewItem1.Title := DateTime2Str(Now);
  
  nView := TImageViewItem.Create(ScrollBox1);
  try
    nView.Visible := False;
    nView.PopupMenu := PMenu2;
    nView.OnSelected := DoViewItemSelected;

    nView.Parent := ScrollBox1;
    nView.Align := alRight;
    Application.ProcessMessages;

    nView.Width := ScrollBox1.Height + 5;
    nView.SetFitSize;
    LoadImageViewItemConfig(Name, nView);

    nLen := Length(gImageInfo);
    SetLength(gImageInfo, nLen + 1);

    with gImageInfo[nLen] do
    begin
      FTime := DateTime2Str(Now);
      FPart := GetCtrlData(EditPart);
      FDesc := '';
    end;

    nView.Image.Tag := nLen;
    nView.Image.Picture := ViewItem1.Image.Picture;
    nView.Align := alLeft;
  finally
    nView.Visible := True;
    ScrollBox1.ScrollInView(nView);
  end;
end;

//Desc: 取消其它选中
procedure TfFormPickImage.DoViewItemSelected(Sender: TObject);
var i,nCount: integer;
    nPCtrl: TWinControl;
    nItem: TImageViewItem;
begin
  nItem := TImageViewItem(Sender);
  if not nItem.Selected then Exit;

  i := nItem.Image.Tag;
  EditDesc.Text := gImageInfo[i].FDesc;
  SetCtrlData(EditPart, gImageInfo[i].FPart);

  ViewItem1.Title := gImageInfo[i].FTime;
  ViewItem1.Image.Picture := nItem.Image.Picture;
  
  nPCtrl := nItem.Parent;
  nCount := nPCtrl.ControlCount - 1;
  
  for i:=0 to nCount do
   if (nPCtrl.Controls[i] <> Sender) and
      (nPCtrl.Controls[i] is TImageViewItem) then
    TImageViewItem(nPCtrl.Controls[i]).Selected := False;
end;

//Desc: 添加描述
procedure TfFormPickImage.N4Click(Sender: TObject);
var nStr: string;
    nItem: TImageViewItem;
begin
  nStr := '';
  if ShowInputBox('请输入图像的描述信息: ' , '添加描述', nStr, 50) then
  begin
    nItem := TImageViewItem(PMenu2.PopupComponent);
    gImageInfo[nItem.Image.Tag].FDesc := nStr;
    if nItem.Selected then EditDesc.Text := nStr;
  end;
end;

//Desc: 删除图像
procedure TfFormPickImage.N6Click(Sender: TObject);
var nItem: TImageViewItem;
begin
  if QueryDlg('确定要删除该图像吗?', sAsk, Handle) then
  begin
    nItem := TImageViewItem(PMenu2.PopupComponent);
    if nItem.Selected then
    begin
      EditDesc.Text := '';
      ViewItem1.Title := '已删除';
      ViewItem1.Image.Picture := nil;
    end;

    nItem.Free;
    FDM.ShowMsg('已成功删除', sHint);
  end;
end;

//Desc: 处理快捷菜单
procedure TfFormPickImage.N1Click(Sender: TObject);
begin
  case TComponent(Sender).Tag of
    10: ViewItem1.SetFitSize;
    20: ViewItem1.SetNormalSize;
    30: Viewitem1.SetPercentSize(0.5);
    40: Viewitem1.SetPercentSize(0.75);
    50: Viewitem1.SetPercentSize(1.2);
    60: Viewitem1.SetPercentSize(1.5);
    70: Viewitem1.SetPercentSize(2);
  end;
end;

//Desc: 保存
procedure TfFormPickImage.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    i,nCount,nIdx: integer;
    nItem: TImageViewItem;
begin
  if EditPart.ItemIndex < 0 then
  begin
    EditPart.SetFocus;
    FDM.ShowMsg('请选择采集的部位', sHint); Exit;
  end;

  if not Assigned(ViewItem1.Image.Picture.Graphic) then
  begin
    FDM.ShowMsg('请先采集图像', sHint); Exit;
  end;

  FDM.ADOConn.BeginTrans;
  try
    nCount := ScrollBox1.ControlCount - 1;
    nStr := 'Insert Into %s(P_MID, P_Part, P_Date, P_Desc) ' +
            'Values(''%s'', %s, ''%s'', ''%s'')';

    for i:=0 to nCount do
    begin
      nItem := TImageViewItem(ScrollBox1.Controls[i]);
      nIdx := nItem.Image.Tag;

      nSQL := Format(nStr, [sTable_PickImage, FMemberID, gImageInfo[nIdx].FPart,
                            gImageInfo[nIdx].FTime, gImageInfo[nIdx].FDesc]);
      FDM.ExecuteSQL(nSQL);

      nIdx := FDM.GetFieldMax(sTable_PickImage, 'P_ID');
      nSQL := 'Select * From %s Where P_ID=%d';
      nSQL := Format(nSQL, [sTable_PickImage, nIdx]);

      with FDM.QueryTemp(nSQL) do
       if RecordCount > 0 then
        FDM.SaveDBImage(FDM.SqlTemp, 'P_Image', nItem.Image.Picture.Graphic);
    end;

    if gSysDBType = dtAccess then
    begin
      nStr := 'Insert Into %s(S_Table, S_Field, S_Value) ' +
              'Values(''%s'', ''%s'', ''%s'')';
      nStr := Format(nStr, [sTable_SyncItem, sTable_PickImage, 'P_MID', FMemberID]);
      FDM.ExecuteSQL(nStr);
    end; //记录变更

    FDM.ADOConn.CommitTrans;
    FDM.ShowMsg('图像已成功保存', sHint);
    CloseForm;
  except
    FDM.ADOConn.RollbackTrans;
    FDM.ShowMsg('图像保存失败', sError);
  end;
end;

end.
