{*******************************************************************************
  作者: dmzn@163.com 2009-6-24
  描述: 摄像头设置
*******************************************************************************}
unit UFormCameraSetup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  DSUtil, DirectShow9, UFormNormal, cxGraphics, DSPack, cxContainer,
  cxEdit, cxTextEdit, cxMaskEdit, cxDropDownEdit, dxLayoutControl,
  StdCtrls, cxControls;

type
  TfFormCameraSetup = class(TfFormNormal)
    VideoWindow1: TVideoWindow;
    dxLayout1Item3: TdxLayoutItem;
    EditSysDev: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    BtnSetup: TButton;
    dxLayout1Item5: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditSize: TcxComboBox;
    dxLayout1Item6: TdxLayoutItem;
    VideoFilter1: TFilter;
    FilterGraph1: TFilterGraph;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure EditSysDevPropertiesChange(Sender: TObject);
    procedure BtnSetupClick(Sender: TObject);
    procedure EditSizePropertiesChange(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Private declarations }
    FSaveToDB: Boolean;
    //是否保存
    FSysDev: TSysDevEnum;
    //设备对象
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
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

function ShowCameraSetupForm(const nSaveToDB: Boolean): Boolean;
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, UMgrControl, UDataModule, USysDB, USysConst;

//------------------------------------------------------------------------------
//Date: 2009-6-24
//Parm: 是否需要保存到数据库
//Desc: 显示摄像头设置窗口
function ShowCameraSetupForm(const nSaveToDB: Boolean): Boolean;
begin
  with TfFormCameraSetup.Create(Application) do
  try
    Caption := '硬件设置';
    FSaveToDB := nSaveToDB;

    Result := ShowModal = mrOK;
  finally
    Free;
  end;
end;

class function TfFormCameraSetup.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;

  with TfFormCameraSetup.Create(Application) do
  try
    Caption := '硬件设置';
    FSaveToDB := (gSysDBType <> dtAccess) and gSysParam.FIsAdmin;
    
    ConfigWithDB(False);
    ShowModal;
  finally
    Free;
  end;
end;

class function TfFormCameraSetup.FormID: integer;
begin
  Result := CFI_FormHardware;
end;

//------------------------------------------------------------------------------

procedure TfFormCameraSetup.FormCreate(Sender: TObject);
var nIdx: integer;
begin
  EditSize.Enabled := False;
  BtnSetup.Enabled := False;
  EditSysDev.Properties.Items.Clear;

  FMediaTypes := TEnumMediaType.Create;
  FSysDev := TSysDevEnum.Create(CLSID_VideoInputDeviceCategory);

  nIdx := 0;
  while nIdx < FSysDev.CountFilters do
  begin
    EditSysDev.Properties.Items.Add(FSysDev.Filters[nIdx].FriendlyName);
    Inc(nIdx);
  end;

  if nIdx = 0 then
       dxGroup1.Caption := '预览 - 没有视频设备'
  else dxGroup1.Caption := '预览 - 未启动';
end;

procedure TfFormCameraSetup.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  CloseCamera;
  FMediaTypes.Free;
  FSysDev.Free;
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
    nIni: TIniFile;
begin
  nIni := nil;
  try
    if nSave then
    begin
      if FSaveToDB then
      begin
        nStr := 'Update %s Set H_Dev=''%s'',H_Size=''%s'' Where H_ID=''%s''';
        nStr := Format(nStr, [sTable_Hardware, EditSysDev.Text,
                              EditSize.Text, sFlag_Hardware]);

        if FDM.ExecuteSQL(nStr) < 1 then
        begin
          nStr := 'Insert Into %s(H_ID,H_Dev,H_Size) Values(''%s'',''%s'',''%s'')';
          nStr := Format(nStr, [sTable_Hardware, sFlag_Hardware,
                                EditSysDev.Text, EditSize.Text]);
          FDM.ExecuteSQL(nStr);
        end;
      end else
      begin
        nIni := TIniFile.Create(gPath + sFormConfig);
        nIni.WriteString(Name, 'SysDevName', EditSysDev.Text);
        nIni.WriteString(Name, 'SysDevSize', EditSize.Text);
      end;

      ShowMsg('保存成功', sHint);
    end else
    begin
      if FSaveToDB then
      begin
        nStr := 'Select H_Dev,H_Size From %s Where H_ID=''%s''';
        nStr := Format(nStr, [sTable_Hardware, sFlag_Hardware]);

        with FDM.QueryTemp(nStr) do
         if RecordCount > 0 then
         begin
           nStr := Fields[0].AsString;
           EditSysDev.ItemIndex := EditSysDev.Properties.Items.IndexOf(nStr);

           Application.ProcessMessages;
           nStr := Fields[1].AsString;
           EditSize.ItemIndex := EditSize.Properties.Items.IndexOf(nStr);
         end;
      end else
      begin
        nIni := TIniFile.Create(gPath + sFormConfig);
        nStr := nIni.ReadString(Name, 'SysDevName', '');
        EditSysDev.ItemIndex := EditSysDev.Properties.Items.IndexOf(nStr);

        Application.ProcessMessages;
        nStr := nIni.ReadString(Name, 'SysDevSize', '');
        EditSize.ItemIndex := EditSize.Properties.Items.IndexOf(nStr);
      end;
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
    nP := GetMediaTypeOfSize(FMediaTypes.Items[EditSize.ItemIndex].AMMediaType^);

    if nP.X > 0 then VideoWindow1.Width := nP.X;
    if nP.Y > 0 then VideoWindow1.Height := nP.Y;

    Application.ProcessMessages;
    Self.ClientWidth := BtnExit.Left + BtnExit.Width + 15;
    Self.ClientHeight := BtnExit.Top + BtnExit.Height + 15;

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
    ShowMsg('请选择设备', sHint); Exit;
  end;

  if EditSize.ItemIndex < 0 then
  begin
    EditSize.SetFocus;
    ShowMsg('请选择画面比例', sHint); Exit;
  end;

  ConfigWithDB(True);
  ModalResult := mrOk;
end;

initialization
  gControlManager.RegCtrl(TfFormCameraSetup, TfFormCameraSetup.FormID);
end.
