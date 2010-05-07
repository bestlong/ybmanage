{*******************************************************************************
  作者: dmzn@163.com 2009-7-20
  描述: 采集图像
*******************************************************************************}
unit UFormPickImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, UDataModule, DSUtil, DirectShow9, UBgFormBase, UMgrSync, DSPack,
  StdCtrls, cxRadioGroup, UImageViewer, cxControls, cxContainer, cxEdit,
  cxTextEdit, UTransPanel, cxGraphics, cxMaskEdit, cxDropDownEdit, Menus;

type
  TfFormPickImage = class(TfBgFormBase)
    RTPanel: TZnTransPanel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    EditDate: TcxTextEdit;
    EditSize: TcxTextEdit;
    BPanel1: TZnTransPanel;
    BtnExit: TButton;
    wPanel: TZnTransPanel;
    ViewItem1: TImageViewItem;
    Label6: TLabel;
    EditDesc: TcxTextEdit;
    Label1: TLabel;
    EditDev: TcxTextEdit;
    Label5: TLabel;
    EditBiLi: TcxTextEdit;
    RadioPick: TcxRadioButton;
    RadioView: TcxRadioButton;
    ScrollBox1: TScrollBox;
    FilterGraph1: TFilterGraph;
    VideoFilter1: TFilter;
    SampleGrabber1: TSampleGrabber;
    PMenu1: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N501: TMenuItem;
    N751: TMenuItem;
    N1201: TMenuItem;
    N1501: TMenuItem;
    N2001: TMenuItem;
    PMenu2: TPopupMenu;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    EditPart: TcxComboBox;
    BtnPick: TButton;
    VideoWindow1: TVideoWindow;
    BtnSave: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnPickClick(Sender: TObject);
    procedure SampleGrabber1Buffer(sender: TObject; SampleTime: Double;
      pBuffer: Pointer; BufferLen: Integer);
    procedure RadioPickClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure EditPartPropertiesChange(Sender: TObject);
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
    FDevIndex: integer;
    FSizeName: string;
    FDevList: TStrings;
    FSizeList: TStrings;
    //设备信息
    FInitImagePos: Boolean;
    //初始化图片
    FInitPickSeed: Cardinal;
    FPickInterval: Cardinal;
    FLastPickTime: Cardinal;
    //拍照按钮处理
    FSyncManager: TDataSynchronizer;
    //同步对象
    FOldCloseForm: TNotifyEvent;
    //旧有事件
    procedure InitFormData;
    //初始数据
    procedure OnCloseActiveForm(Sender: TObject);
    //活动窗口关闭
    procedure OneImageView(nPCtrl: TWinControl);
    //单张浏览
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
    procedure DoDataSync(const nData: Pointer; const nSize: Cardinal);
    procedure DoDataFree(const nData: Pointer; const nSize: Cardinal);
    //同步数据
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
  
const
  cIntervalBorder = 15;  //边界
  cIntervalHor    = 5;   //水平
  cIntervalVer    = 5;   //垂直
  cScaleWidth     = 4;   //宽比例
  cScaleHeight    = 3;   //高比例

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

  gForm := TfFormPickImage.Create(Application);
  Result := gForm;

  with TfFormPickImage(Result) do
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

//Desc: 在nDevList中检索nDev设置
function GetDevIndex(const nDevList: TStrings; const nDev: string): Integer;
var i,nCount: integer;
begin
  Result := -1;
  nCount := nDevList.Count - 1;

  for i:=0 to nCount do
  if Pos(nDev, nDevList[i]) > 0 then
  begin
    Result := i; Break;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormPickImage.FormCreate(Sender: TObject);
var nIdx: integer;
begin
  WindowState := wsMaximized;
  DoubleBuffered := True;

  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;

  FInitPickSeed := 0;
  FLastPickTime := 0;

  FSyncManager := TDataSynchronizer.Create;
  FSyncManager.SyncEvent := DoDataSync;
  FSyncManager.SyncFreeEvent := DoDataFree;

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

  if nIdx < 1 then
       EditDev.Text := '没有视频设备'
  else EditDev.Text := '设备未启动';

  LoadImageViewItemConfig(Name, ViewItem1);
  inherited;
end;

procedure TfFormPickImage.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    FreeAndNil(FDevList);
    FreeAndNil(FSizeList);
    ReleaseCtrlData(Self);

    CloseCamera;
    FMediaTypes.Free;
    FSysDev.Free;

    FSyncManager.Free;
    gForm := nil;   
    gOnCloseActiveForm := FOldCloseForm;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);
  end;
end;

//Desc: 尝试开启摄像头
procedure TfFormPickImage.FormShow(Sender: TObject);
begin
  VideoWindow1.Left := - VideoWindow1.Width;
  BtnPick.Enabled := False;

  FInitImagePos := False;
  OneImageView(wPanel); 

  if FDevList.Count > 0 then
  begin
    LoadCameraConfig;
    CloseCamera;

    LoadCameraSizeList(FDevIndex);
    SetCameraSize(FSizeList.IndexOf(FSizeName));
    OpenCamera;
  end;
end;

procedure TfFormPickImage.BtnExitClick(Sender: TObject);
var nStr: string;
begin
  inherited;
  if ScrollBox1.ControlCount > 0 then
  begin
    nStr := '确定要放弃保存已采集的图像吗?';
    if QueryDlg(nStr, sAsk, Handle) then CloseForm;
  end else CloseForm;
end;

procedure TfFormPickImage.OnCloseActiveForm(Sender: TObject);
begin

end;

//------------------------------------------------------------------------------
//Desc: 打开摄像头
procedure TfFormPickImage.OpenCamera;
begin
  FInitPickSeed := 0;
  FilterGraph1.Active := True;

  if VideoFilter1.BaseFilter.DataLength > 0 then
   with FilterGraph1 as ICaptureGraphBuilder2 do
    RenderStream(@PIN_CATEGORY_PREVIEW, nil, VideoFilter1 as IBaseFilter,
                   SampleGrabber1 as IBaseFilter, VideoWindow1 as IBaseFilter);
  //xxxxx

  FilterGraph1.Play;
  BtnPick.Enabled := True;
end;

//Desc: 关闭摄像头
procedure TfFormPickImage.CloseCamera;
begin
  FilterGraph1.ClearGraph;
  FilterGraph1.Active := False;
  FilterGraph1.Mode := gmCapture;

  FInitPickSeed := 0;
  BtnPick.Enabled := False;
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

  FDM.FillStringsData(EditPart.Properties.Items, nStr, -1, '、');
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
    FDevIndex := nIni.ReadInteger('fFormCameraSetup', 'SysDevIndex', -1);
    FSizeName := nIni.ReadString('fFormCameraSetup', 'SysDevSize', '');
    FPickInterval := nIni.ReadInteger('fFormCameraSetup', 'SysDevInterval', 1000);
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

  EditBiLi.Text := FSizeName;
  //nIdx := GetDevIndex(FDevList, FDevName);
  
  if (FDevIndex > -1) and (FDevIndex < FDevList.Count) then
  begin
    nStr := FDevList[FDevIndex];
    System.Delete(nStr, 1, Pos('=', nStr));
    EditDev.Text := nStr;
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

    VideoWindow1.Top := 0;
    VideoWindow1.Left := - VideoWindow1.Width;

    nList := TPinList.Create(VideoFilter1 as IBaseFilter);
    with (nList.First as IAMStreamConfig) do
      SetFormat(FMediaTypes.Items[nIdx].AMMediaType^);
    FreeAndNil(nList);
  except
    CloseCamera;
    FreeAndNil(nList);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 单张浏览模式
procedure TfFormPickImage.OneImageView(nPCtrl: TWinControl);
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
  wPanel.InvalidPanel;
end;

//Desc: 处理快捷菜单
procedure TfFormPickImage.N1Click(Sender: TObject);
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

//Desc: 取消其它选中
procedure TfFormPickImage.DoViewItemSelected(Sender: TObject);
var i,nCount: integer;
    nPCtrl: TWinControl;
    nItem: TImageViewItem;
begin
  nItem := TImageViewItem(Sender);
  if not nItem.Selected then Exit;

  nPCtrl := nItem.Parent;
  nCount := nPCtrl.ControlCount - 1;

  for i:=0 to nCount do
   if (nPCtrl.Controls[i] <> Sender) and
      (nPCtrl.Controls[i] is TImageViewItem) then
    TImageViewItem(nPCtrl.Controls[i]).Selected := False;

  if RadioView.Checked then
  begin
    i := nItem.Image.Tag;
    EditDate.Text := gImageInfo[i].FTime;
    EditDesc.Text := gImageInfo[i].FDesc;

    EditSize.Text := IntToStr(nItem.Image.Picture.Width) + ' x ' +
                     IntToStr(nItem.Image.Picture.Height);
    //xxxxx

    SetCtrlData(EditPart, gImageInfo[i].FPart);
    ViewItem1.Title := gImageInfo[i].FTime;
    ViewItem1.Image.Picture := nItem.Image.Picture;
  end;
end;

//Desc: 采集
procedure TfFormPickImage.BtnPickClick(Sender: TObject);
var nLen: integer;
    nView: TImageViewItem;
begin
  if EditPart.ItemIndex < 0 then
  begin
    EditPart.SetFocus;
    FDM.ShowMsg('请选择采集部位', sHint); Exit;
  end;

  nView := nil;
  ViewItem1.Image.Canvas.Lock;
  ScrollBox1.DisableAutoRange;
  try
    nView := TImageViewItem.Create(ScrollBox1);
    nView.Parent := ScrollBox1;

    nView.Align := alLeft;
    nView.Title := Time2Str(Now);
    nView.PopupMenu := PMenu2;

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

    nView.Align := alTop;
    nView.OnSelected := DoViewItemSelected;

    nView.Height := Round(ScrollBox1.Width / (4 / 3));
    Application.ProcessMessages;
    
    nView.SetFitSize;
    LoadImageViewItemConfig(Name, nView);
  finally
    ScrollBox1.EnableAutoRange;
    ViewItem1.Image.Canvas.Unlock;
     
    if Assigned(nView) then
    begin
      //nView.Visible := True;
      ScrollBox1.ScrollInView(nView);
    end;
  end;
end;

//Desc: 同步采集
procedure TfFormPickImage.DoDataSync(const nData: Pointer;
  const nSize: Cardinal);
begin
  FLastPickTime := GetTickCount;
  if BtnPick.Enabled then BtnPickClick(nil);
end;

//Desc: 释放数据
procedure TfFormPickImage.DoDataFree(const nData: Pointer;
  const nSize: Cardinal);
begin

end;

//Desc: 输出图像
procedure TfFormPickImage.SampleGrabber1Buffer(sender: TObject;
  SampleTime: Double; pBuffer: Pointer; BufferLen: Integer);
begin
  try
    if not RadioPick.Checked then Exit;
    if (FInitPickSeed <> 0) and
       (GetTickCount - FInitPickSeed >= FPickInterval) and
       (GetTickCount - FLastPickTime >= 3000) then
    begin
      FSyncManager.AddData(nil, 0);
      FSyncManager.ApplySync;
    end;

    ViewItem1.Image.Canvas.lock;
    try
      SampleGrabber1.GetBitmap(ViewItem1.Image.Picture.Bitmap, pBuffer, BufferLen);
    finally
      ViewItem1.Image.Canvas.Unlock;
    end;

    if not FInitImagePos then
    begin
      ViewItem1.SetNormalSize;
      FInitImagePos := True;
    end;
  finally
    FInitPickSeed := GetTickCount;
  end;
end;

//Desc: 切换模式
procedure TfFormPickImage.RadioPickClick(Sender: TObject);
begin
  N1.Enabled := RadioView.Checked;
  if RadioPick.Checked then
  begin
    ViewItem1.Title := '';
    ViewItem1.SetNormalSize;
  end;
  BtnPick.Enabled := RadioPick.Checked;
end;

//Desc: 修改选中图像的采集部位
procedure TfFormPickImage.EditPartPropertiesChange(Sender: TObject);
var i,nCount: integer;
    nItem: TImageViewItem;
begin
  if RadioView.Checked then
  begin
    nCount := ScrollBox1.ControlCount - 1;
    for i:=0 to nCount do
    begin
      nItem := TImageViewItem(ScrollBox1.Controls[i]);
      if nItem.Selected then
        gImageInfo[nItem.Image.Tag].FPart := GetCtrlData(EditPart);
      //xxxxx
    end;
  end;
end;

//Desc: 添加描述
procedure TfFormPickImage.N4Click(Sender: TObject);
var nStr: string;
    nItem: TImageViewItem;
begin
  nItem := TImageViewItem(PMenu2.PopupComponent);
  nStr := gImageInfo[nItem.Image.Tag].FDesc;

  if ShowInputBox('请输入图像的描述信息: ' , '添加描述', nStr, 50) then
  begin
    gImageInfo[nItem.Image.Tag].FDesc := nStr;
    if RadioView.Checked then EditDesc.Text := nStr;
  end;
end;

//Desc: 删除图像
procedure TfFormPickImage.N6Click(Sender: TObject);
var nItem: TImageViewItem;
begin
  if QueryDlg('确定要删除该图像吗?', sAsk, Handle) then
  begin
    nItem := TImageViewItem(PMenu2.PopupComponent);
    if RadioView.Checked then
    begin
      EditDesc.Text := '';
      ViewItem1.Title := '已删除';
      ViewItem1.Image.Picture := nil;
    end;

    nItem.Free;
    FDM.ShowMsg('已成功删除', sHint);
  end;
end;

//Desc: 保存采集图像
procedure TfFormPickImage.BtnSaveClick(Sender: TObject);
var nStr,nSQL: string;
    i,nCount,nIdx: integer;
    nItem: TImageViewItem;
begin
  if ScrollBox1.ControlCount < 1 then
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
