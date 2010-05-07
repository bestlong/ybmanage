{*******************************************************************************
  作者: dmzn@163.com 2009-7-3
  描述: 对指定会员的操作

  描述:
  *.可用操作包括图像采集,图像对比,方案等.
*******************************************************************************}
unit UFormMemberWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, UTransPanel, dxNavBarCollns, cxClasses,
  dxNavBarBase, ExtCtrls, dxNavBar, dxLayoutControl, cxControls,
  UTransGlass, Menus;

type
  TfFormMemberWork = class(TfBgFormBase)
    dxNavBar1: TdxNavBar;
    Group_SysFun: TdxNavBarGroup;
    Button_Return: TdxNavBarItem;
    Button_MyInfo: TdxNavBarItem;
    Button_Pick: TdxNavBarItem;
    Button_Contrast: TdxNavBarItem;
    Group_Plan: TdxNavBarGroup;
    wPanel: TZnGlassControl;
    Button_Parse: TdxNavBarItem;
    PMenu1: TPopupMenu;
    adsf1: TMenuItem;
    Button_Report: TdxNavBarItem;
    procedure FormCreate(Sender: TObject);
    procedure Button_ReturnClick(Sender: TObject);
    procedure Button_PickClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_ContrastClick(Sender: TObject);
    procedure Button_ParseClick(Sender: TObject);
    procedure Button_MyInfoClick(Sender: TObject);
    procedure Button_ReportClick(Sender: TObject);
  private
    { Private declarations }
    FMemberID: string;
    //会员号
    FActiveForm: TForm;
    //活动窗口
    FOldCloseForm: TNotifyEvent;
    //旧有事件
    procedure InitFormData;
    //初始化数据
    procedure OnItemClick(Sender: TObject);
    //按钮点击
    procedure LoadPlanList;
    //读取方案列表
    procedure OnCloseActiveForm(Sender: TObject);
    //活动窗口关闭
    procedure CloseActiveForm(const nNotClose: TFormClass = nil);
    //关闭活动窗口
  public
    { Public declarations }
    FPlanChanged: Boolean;
    //方案变动
  end;

procedure ShowMemberWorkForm(const nMemberID: string);
//入口函数

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, USysConst, USysDB, USysGobal, UFormPickImage,
  UFormContrast, UFormParse, UFormMember, UFormPlan, UFormEditPlan,
  UFormReport, UFormWait;

//------------------------------------------------------------------------------
//Desc: 显示nMemberID的工作窗口
procedure ShowMemberWorkForm(const nMemberID: string);
begin
  with TfFormMemberWork.Create(Application) do
  begin
    FMemberID := nMemberID;
    FPlanChanged := False;
    InitFormData;
    Show;
  end;
end;

procedure TfFormMemberWork.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  WindowState := wsMaximized;
  FormStyle := fsNormal;
  DoubleBuffered := True;

  FActiveForm := nil;
  dxNavBar1.ActiveGroup := Group_SysFun;

  FOldCloseForm := gOnCloseActiveForm;
  gOnCloseActiveForm := OnCloseActiveForm;
  inherited;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    dxNavBar1.NavigationPaneMaxVisibleGroups := nIni.ReadInteger(Name, 'GroupNum', 0);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMemberWork.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  inherited;
  if Action <> caFree then Exit;

  CloseActiveForm;
  gOnCloseActiveForm := FOldCloseForm;
  if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Sender);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'GroupNum', dxNavBar1.NavigationPaneMaxVisibleGroups);
  finally
    nIni.Free;
  end;
end;

procedure TfFormMemberWork.Button_ReturnClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
//Desc: 初始化界面数据
procedure TfFormMemberWork.InitFormData;
var nStr: string;
    i,nCount: integer;
begin
  nCount := dxNavBar1.Groups.Count - 1;
  for i:=0 to nCount do
  begin
    nStr := dxNavBar1.Groups[i].Name;
    dxNavBar1.Groups[i].SmallImageIndex := FDM.IconIndex(nStr)
  end;

  nCount := dxNavBar1.Items.Count - 1;
  for i:=0 to nCount do
  begin
    nStr := dxNavBar1.Items[i].Name;
    dxNavBar1.Items[i].LargeImageIndex := FDM.IconIndex(nStr);
  end;

  LoadPlanList;
end;

procedure TfFormMemberWork.LoadPlanList;
var nStr: string;
    nIdx: integer;
    nItem: TdxNavBarItem;
begin
  for nIdx:=Group_Plan.LinkCount - 1 downto 0 do
    Group_Plan.Links[nIdx].Item.Free;
  //xxxxx

  nStr := 'Select P_ID, P_Name From $T ' +
          'Where P_ID In (Select U_PID From $Used Where U_MID=''$ID'')';
  nStr := MacroValue(nStr, [MI('$T', sTable_Plan), MI('$Used', sTable_PlanUsed),
                            MI('$ID', FMemberID)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nItem := dxNavBar1.Items.Add;
      nItem.Hint := Fields[0].AsString;
      nItem.Caption := Fields[1].AsString;

      nItem.LargeImageIndex := FDM.IconIndex(sList_Plan);
      nItem.OnClick := OnItemClick;
      Group_Plan.CreateLink(nItem);
      Next;
    end;
  end;
end;

procedure TfFormMemberWork.CloseActiveForm(const nNotClose: TFormClass);
begin
  if Assigned(FActiveForm) and
     ((not Assigned(nNotClose)) or (not (FActiveForm is nNotClose))) then
  begin
    if FActiveForm is TfBgFormBase then
         TfBgFormBase(FActiveForm).CloseForm
    else FActiveForm.Close;

    FActiveForm := nil;
  end;
end;

procedure TfFormMemberWork.OnCloseActiveForm(Sender: TObject);
begin
  FActiveForm := nil;
  
  if Sender is TfFormEditPlan then
  begin
    FPlanChanged := TfFormEditPlan(Sender).FDataChanged;
    if FPlanChanged then LoadPlanList;
  end else

  if Sender is TfFormPlan then
  begin
    FPlanChanged := TfFormPlan(Sender).FDataChanged;
    if FPlanChanged then LoadPlanList;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormMemberWork.OnItemClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormPlan);
  FActiveForm := ShowViewPlanForm(TdxNavBarItem(Sender).Hint, nRect);
end;

//Desc: 会员信息卡
procedure TfFormMemberWork.Button_MyInfoClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormMember);
  FActiveForm := ShowViewMemberForm(FMemberID, nRect);
end;

//Desc: 采集
procedure TfFormMemberWork.Button_PickClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  ShowWaitForm(Self, '正在初始化');
  try
    CloseActiveForm(TfFormPickImage);
    FActiveForm := ShowPickImageForm(FMemberID, nRect);
  finally
    CloseWaitForm;
  end;
end;

//Desc: 对比
procedure TfFormMemberWork.Button_ContrastClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  ShowWaitForm(Self, '正在读取');
  try
    CloseActiveForm(TfFormContrast);
    FActiveForm := ShowImageContrastForm(FMemberID, nRect);
  finally
    CloseWaitForm;
  end;
end;

//Desc: 图像分析
procedure TfFormMemberWork.Button_ParseClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  ShowWaitForm(Self, '正在读取');
  try
    CloseActiveForm(TfFormParse);
    FActiveForm := ShowImageParseForm(FMemberID, nRect);
  finally
    CloseWaitForm;
  end;
end;

//Desc: 生成报告
procedure TfFormMemberWork.Button_ReportClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  ShowWaitForm(Self, '正在读取');
  try
    CloseActiveForm(TfFormReport);
    FActiveForm := ShowReportForm(FMemberID, nRect);
  finally
    CloseWaitForm;
  end;
end;

end.
