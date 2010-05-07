{*******************************************************************************
  作者: dmzn@163.com 2009-7-9
  描述: 摄像头设置
*******************************************************************************}
unit UFormCameraSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DSUtil, DirectShow9, UBgFormBase, cxGraphics, DSPack, dxLayoutControl,
  cxContainer, cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, StdCtrls,
  cxControls, UTransPanel, cxCheckBox;

type
  TfFormCameraSetup = class(TfBgFormBase)
    dxLayout1: TdxLayoutControl;
    BtnOK: TButton;
    BtnExit: TButton;
    VideoWindow1: TVideoWindow;
    EditSysDev: TcxComboBox;
    BtnSetup: TButton;
    EditSize: TcxComboBox;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayoutGroup2: TdxLayoutGroup;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item2: TdxLayoutItem;
    VideoFilter1: TFilter;
    FilterGraph1: TFilterGraph;
    CheckSync1: TcxCheckBox;
    dxLayout1Item1: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSysDevPropertiesChange(Sender: TObject);
    procedure EditSizePropertiesChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure BtnSetupClick(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    FSaveToDB: Boolean;
    //是否保存
    FSysDev: TSysDevEnum;
    //设备对象
    FDisplayRect: TRect;
    //显示区域
    FMediaTypes: TEnumMediaType;
    //媒体类型
    procedure OpenCamera;
    procedure CloseCamera;
    //开&关摄像头
    procedure ConfigWithDB(const nSave: Boolean);
    //载入&保存配置
    function GetMediaTypeOfSize(const nMediaType: TAMMediaType): TPoint;
    //屏幕尺寸
  public
    { Public declarations }
  end;

function ShowCameraSetupForm(const nSaveToDB: Boolean; const nRect: TRect): Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UAdjustForm, UDataModule, USysDB, USysConst, USysGobal;

//------------------------------------------------------------------------------
//Date: 2009-6-24
//Parm: 是否需要保存到数据库
//Desc: 显示摄像头设置窗口
function ShowCameraSetupForm(const nSaveToDB: Boolean; const nRect: TRect): Boolean;
begin
  with TfFormCameraSetup.Create(Application) do
  try
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    FSaveToDB := nSaveToDB; 
    FDisplayRect := nRect;
    Result := ShowModal = mrOK;
  finally
    Free;
  end;
end;

procedure TfFormCameraSetup.FormCreate(Sender: TObject);
var nStr: string;
    nIdx: integer;
begin
  inherited;
  EditSize.Enabled := False;
  BtnSetup.Enabled := False;
  EditSysDev.Properties.Items.Clear;

  FMediaTypes := TEnumMediaType.Create;
  FSysDev := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);

  nIdx := 0;
  while nIdx < FSysDev.CountFilters do
  begin
    nStr := GUIDToString(FSysDev.Filters[nIdx].CLSID) + '=' +
            FSysDev.Filters[nIdx].FriendlyName;
    EditSysDev.Properties.Items.Add(nStr);
    Inc(nIdx);
  end;

  if nIdx > 0 then
  begin
    dxGroup1.Caption := '预览 - 未启动';
    AdjustStringsItem(EditSysDev.Properties.Items, False);
  end else dxGroup1.Caption := '预览 - 没有视频设备'
end;

procedure TfFormCameraSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    CloseCamera;
    FMediaTypes.Free;
    FSysDev.Free;

    if Assigned(gOnCloseActiveForm) then
      gOnCloseActiveForm(Self);
    ReleaseCtrlData(Self);
  end;
end;

procedure TfFormCameraSetup.FormShow(Sender: TObject);
begin
  ConfigWithDB(False);
end;

procedure TfFormCameraSetup.BtnExitClick(Sender: TObject);
begin
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 打开摄像头
procedure TfFormCameraSetup.OpenCamera;
begin
  FilterGraph1.Active := True; 
  if VideoFilter1.BaseFilter.DataLength > 0 then
   with FilterGraph1 as ICaptureGraphBuilder2 do
    RenderStream(@PIN_CATEGORY_PREVIEW, nil, VideoFilter1 as IBaseFilter,
                   nil, VideoWindow1 as IBaseFilter);
  //xxxxx

  FilterGraph1.Play;
  dxGroup1.Caption := '预览';
end;

//Desc: 关闭摄像头
procedure TfFormCameraSetup.CloseCamera;
begin
  FilterGraph1.ClearGraph;
  FilterGraph1.Active := False;
  FilterGraph1.Mode := gmCapture;
  dxGroup1.Caption := '预览 - 未启动';
end;

//Desc: 获取nMediaType画面比例的屏幕尺寸
function TfFormCameraSetup.GetMediaTypeOfSize(const nMediaType: TAMMediaType): TPoint;
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

//Desc: 读取&保存配置
procedure TfFormCameraSetup.ConfigWithDB(const nSave: Boolean);
var nStr: string;
    nIdx: integer;
    nIni: TIniFile;
    nDev,nSize: string;
begin
  nIni := nil;
  try
    if nSave then
    begin
      if FSaveToDB then
      begin
        nStr := 'Update %s Set H_Dev=''%s'',H_Size=''%s'' Where H_ID=''%s''';
        nStr := Format(nStr, [sTable_Hardware, GetCtrlData(EditSysDev),
                              EditSize.Text, sFlag_Hardware]);

        if FDM.ExecuteSQL(nStr) < 1 then
        begin
          nStr := 'Insert Into %s(H_ID,H_Dev,H_Size) Values(''%s'',''%s'',''%s'')';
          nStr := Format(nStr, [sTable_Hardware, sFlag_Hardware,
                                GetCtrlData(EditSysDev), EditSize.Text]);
          FDM.ExecuteSQL(nStr);
        end;
      end else
      begin
        nIni := TIniFile.Create(gPath + sFormConfig);
        nIni.WriteString(Name, 'SysDevName', GetCtrlData(EditSysDev));
        nIni.WriteInteger(Name, 'SysDevIndex', EditSysDev.ItemIndex);
        nIni.WriteString(Name, 'SysDevSize', EditSize.Text);
      end;

      FDM.ShowMsg('保存成功', sHint);
    end else
    begin
      nIni := TIniFile.Create(gPath + sFormConfig);
      nDev := nIni.ReadString(Name, 'SysDevName', '');
      nIdx := nIni.ReadInteger(Name, 'SysDevIndex', -1);
      nSize := nIni.ReadString(Name, 'SysDevSize', '');

      if (nDev = '') or (nSize = '') then
      begin
        nStr := 'Select H_Dev,H_Size From %s Where H_ID=''%s''';
        nStr := Format(nStr, [sTable_Hardware, sFlag_Hardware]);

        with FDM.QueryTemp(nStr) do
         if RecordCount > 0 then
         begin
           nDev := Fields[0].AsString;
           nSize := Fields[1].AsString;
         end;
      end;

      //SetCtrlData(EditSysDev, nDev);
      EditSysDev.ItemIndex := nIdx;
      Application.ProcessMessages;
      EditSize.ItemIndex := EditSize.Properties.Items.IndexOf(nSize);
    end;
  finally
    FreeAndNil(nIni);
  end;
end;

//------------------------------------------------------------------------------
//Desc: 设备变动
procedure TfFormCameraSetup.EditSysDevPropertiesChange(Sender: TObject);
var nStr: string;
    nIdx: integer;
    nList: TPinList;
begin
  EditSize.Enabled := False;
  BtnSetup.Enabled := False;
  if EditSysDev.ItemIndex < 0 then Exit;

  nList := nil;
  try
    CloseCamera;
    FSysDev.SelectGUIDCategory(CLSID_VideoInputDeviceCategory);
    VideoFilter1.BaseFilter.Moniker := FSysDev.GetMoniker(EditSysDev.ItemIndex);

    VideoFilter1.FilterGraph := FilterGraph1;
    FilterGraph1.Active := True;
    nList := TPinList.Create(VideoFilter1 as IBaseFilter);

    EditSize.Properties.Items.Clear;
    FMediaTypes.Assign(nList.First);

    for nIdx:=0 to FMediaTypes.Count - 1 do
    begin
      nStr := FMediaTypes.MediaDescription[nIdx];
      System.Delete(nStr, 1, Pos('VideoInfo', nStr) - 1);
      EditSize.Properties.Items.Add(nStr);
    end;

    FreeAndNil(nList);
    EditSize.Enabled := EditSize.Properties.Items.Count > 0;
    BtnSetup.Enabled := EditSize.Enabled;
  except
    CloseCamera;
    FreeAndNil(nList);
  end;
end;

//Desc: 修改屏幕尺寸
procedure TfFormCameraSetup.EditSizePropertiesChange(Sender: TObject);
var nP: TPoint;
    nList: TPinList;
begin
  nList := nil;
  if EditSize.ItemIndex > -1 then
  try
    CloseCamera;    
    FilterGraph1.Active := True;

    if CheckSync1.Checked then
    begin
      nP := GetMediaTypeOfSize(FMediaTypes.Items[EditSize.ItemIndex].AMMediaType^);

      if nP.X > 0 then VideoWindow1.Width := nP.X;
      if nP.Y > 0 then VideoWindow1.Height := nP.Y;

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
    end;

    nList := TPinList.Create(VideoFilter1 as IBaseFilter);
    with (nList.First as IAMStreamConfig) do
      SetFormat(FMediaTypes.Items[EditSize.ItemIndex].AMMediaType^);
    FreeAndNil(nList);

    OpenCamera;
  except
    CloseCamera;
    FreeAndNil(nList);
  end;
end;

//Desc: 设置
procedure TfFormCameraSetup.BtnSetupClick(Sender: TObject);
begin
  try
    if FilterGraph1.State <> gsPlaying then OpenCamera;
    ShowFilterPropertyPage(Self.Handle, VideoFilter1 as IBaseFilter);
  except
    //ignor any error
  end;
end;

//Desc: 保存
procedure TfFormCameraSetup.BtnOKClick(Sender: TObject);
begin
  if EditSysDev.ItemIndex < 0 then
  begin
    EditSysDev.SetFocus;
    FDM.ShowMsg('请选择设备', sHint); Exit;
  end;

  if EditSize.ItemIndex < 0 then
  begin
    EditSize.SetFocus;
    FDM.ShowMsg('请选择画面比例', sHint); Exit;
  end;

  ConfigWithDB(True);
  ModalResult := mrOk;
end;

end.
