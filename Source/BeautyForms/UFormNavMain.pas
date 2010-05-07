{*******************************************************************************
  ����: dmzn@163.com 2009-6-28
  ����: ����������
*******************************************************************************}
unit UFormNavMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, ExtCtrls, dxLayoutControl, cxMaskEdit,
  cxButtonEdit, cxContainer, cxEdit, cxTextEdit, cxControls,
  dxNavBarCollns, cxClasses, dxNavBarBase, dxNavBar, UTransPanel;

type
  TfFormNavMain = class(TfBgFormBase)
    dxNavBar1: TdxNavBar;
    Group_System: TdxNavBarGroup;
    Group_Member: TdxNavBarGroup;
    Button_Exit: TdxNavBarItem;
    Button_Member: TdxNavBarItem;
    Group_Plan: TdxNavBarGroup;
    Timer1: TTimer;
    Button_Plan: TdxNavBarItem;
    Button_Sync: TdxNavBarItem;
    Group_Product: TdxNavBarGroup;
    wPanel: TZnTransPanel;
    dxLayout1: TdxLayoutControl;
    EditUser: TcxTextEdit;
    EditTime: TcxTextEdit;
    EditLevel: TcxTextEdit;
    EditNumber: TcxTextEdit;
    EditFind: TcxButtonEdit;
    EditBirthday: TcxButtonEdit;
    dxLayoutGroup1: TdxLayoutGroup;
    dxGroup1: TdxLayoutGroup;
    dxLayout1Item2: TdxLayoutItem;
    dxLayoutItem1: TdxLayoutItem;
    dxLayout1Item3: TdxLayoutItem;
    dxGroup2: TdxLayoutGroup;
    dxLayoutItem2: TdxLayoutItem;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Item5: TdxLayoutItem;
    Button_Hardware: TdxNavBarItem;
    Button_Product: TdxNavBarItem;
    EditPwd: TcxButtonEdit;
    dxLayout1Item1: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure Button_ExitClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure EditBirthdayPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure wPanelResize(Sender: TObject);
    procedure Button_MemberClick(Sender: TObject);
    procedure Button_PlanClick(Sender: TObject);
    procedure Button_SyncClick(Sender: TObject);
    procedure Button_HardwareClick(Sender: TObject);
    procedure Button_ProductClick(Sender: TObject);
    procedure EditFindPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure EditPwdPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
  private
    FActiveForm: TForm;
    //�����
    procedure InitFormData;
    //��ʼ������
    procedure OnItemClick(Sender: TObject);
    //��ť���  
    procedure LoadMemberList;
    //��ȡ��Ա�б�
    procedure LoadPlanList;
    //��ȡ�����б�
    procedure LoadProductList;
    //��ȡ��Ʒ�б�
    procedure LoadSystemInfo;
    //����ϵͳժҪ
    procedure OnCloseActiveForm(Sender: TObject);
    //����ڹر�
    procedure CloseActiveForm(const nNotClose: TFormClass = nil);
    //�رջ����
  public
  end;

procedure ShowNavMainForm;
//��ں���

implementation

{$R *.dfm}

uses
  IniFiles, ULibFun, USysConst, USysDB, USysGobal, UFormMemberBirth,
  UFormProduct, UFormPlan, UFormMember, UFormMemberWork, UFormCameraSetup,
  UFormDataSync, UFormPlanView, UFormProduct2, UFormChangePwd;

//------------------------------------------------------------------------------
//Desc: ������
procedure ShowNavMainForm;
var nStr: string;
begin
  nStr := gSysParam.FIconFile;
  System.Insert(sFilePostfix, nStr, Pos('.', nStr));

  gSysParam.FIconFile := nStr;
  FDM.LoadSystemIcons(gSysParam.FIconFile);

  with TfFormNavMain.Create(Application) do
  begin
    InitFormData;
    Show;
  end;
end;

procedure TfFormNavMain.FormCreate(Sender: TObject);
var nIni: TIniFile;
begin
  WindowState := wsMaximized;
  FormStyle := fsNormal;
  DoubleBuffered := True;

  FActiveForm := nil;
  dxNavBar1.ActiveGroup := Group_Member;

  gOnCloseActiveForm := OnCloseActiveForm;
  inherited;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    dxNavBar1.NavigationPaneMaxVisibleGroups := nIni.ReadInteger(Name, 'GroupNum', 0);
  finally
    nIni.Free;
  end;
end;

//Desc: �˳�
procedure TfFormNavMain.Button_ExitClick(Sender: TObject);
var nHwnd: THandle;
    nIni: TIniFile;
begin
  if Assigned(FActiveForm) then
       nHwnd := FActiveForm.Handle
  else nHwnd := Handle;

  if not QueryDlg('ȷ��Ҫ�˳�ϵͳ��?', sAsk, nHwnd) then Exit;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteInteger(Name, 'GroupNum', dxNavBar1.NavigationPaneMaxVisibleGroups);
  finally
    nIni.Free;
  end;

  Application.MainForm.Close;
end;

//------------------------------------------------------------------------------
//Desc: ��ʼ����������
procedure TfFormNavMain.InitFormData;
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

  LoadMemberList;
  //LoadPlanList;
  //LoadProductList;
  LoadSystemInfo;
end;

//Desc: ��ȡ��Ա�б�
procedure TfFormNavMain.LoadMemberList;
var nStr: string;
    nIdx: integer;
    nItem: TdxNavBarItem;
begin
  for nIdx:=Group_Member.LinkCount - 1 downto 0 do
    Group_Member.Links[nIdx].Item.Free;
  nStr := 'Select M_ID, M_Name, M_Sex From $T';
  
  if not gSysParam.FIsAdmin then
    nStr := nStr + ' Where M_Beautician=''$B''';
  nStr := MacroValue(nStr, [MI('$T', sTable_Member), MI('$B', gSysParam.FBeautyID)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nItem := dxNavBar1.Items.Add;
      nItem.Hint := Fields[0].AsString;
      nItem.Caption := Fields[1].AsString;

      if Fields[2].AsString = sFlag_Man then
           nItem.LargeImageIndex := FDM.IconIndex(sMember_Man)
      else nItem.LargeImageIndex := FDM.IconIndex(sMember_Woman);

      nItem.OnClick := OnItemClick;
      Group_Member.CreateLink(nItem);
      Next;
    end;
  end;
end;

//Desc: ��ȡ�����б�
procedure TfFormNavMain.LoadPlanList;
var nStr: string;
    nIdx: integer;
    nItem: TdxNavBarItem;
begin
  for nIdx:=Group_Plan.LinkCount - 1 downto 0 do
    Group_Plan.Links[nIdx].Item.Free;
  //xxxxx

  nStr := 'Select P_ID, P_Name From $T';
  nStr := MacroValue(nStr, [MI('$T', sTable_Plan)]);

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

//Desc: ��ȡ��Ʒ�б�
procedure TfFormNavMain.LoadProductList;
var nStr: string;
    nIdx: integer;
    nItem: TdxNavBarItem;
begin
  for nIdx:=Group_Product.LinkCount - 1 downto 0 do
    Group_Product.Links[nIdx].Item.Free;
  //xxxxx

  nStr := 'Select P_ID, P_Name From $T';
  nStr := MacroValue(nStr, [MI('$T', sTable_Product)]);

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nItem := dxNavBar1.Items.Add;
      nItem.Hint := Fields[0].AsString;
      nItem.Caption := Fields[1].AsString;

      nItem.LargeImageIndex := FDM.IconIndex(sList_Product);
      nItem.OnClick := OnItemClick;
      Group_Product.CreateLink(nItem);
      Next;
    end;
  end;
end;

//Desc: ϵͳժҪ
procedure TfFormNavMain.LoadSystemInfo;
var nStr,nTmp: string;
begin
  EditPwd.Text := '�޸��Լ��ĵ�¼���� -->';

  nStr := gSysParam.FUserID;
  nTmp := 'Select G_NAME From %s Where G_ID=%s';
  nTmp := Format(nTmp, [sTable_Group, gSysParam.FGroupID]);

  with FDM.QueryTemp(nTmp) do
  begin
   if RecordCount >0 then
     nStr := nStr + ' ������:[ ' + Fields[0].AsString + ' ]';
  end;
  EditUser.Text := nStr;

  //----------------------------------------------------------------------------
  if gSysParam.FIsAdmin then
       nStr := '��������Ա'
  else nStr := '��ͨ�û�';

  if gSysParam.FBeautyID <> '' then
  begin
    nTmp := 'Select B_Level From %s Where B_ID=''%s''';
    nTmp := Format(nTmp, [sTable_Beautician, gSysParam.FBeautyID]);

    with FDM.QueryTemp(nTmp) do
    begin
      if RecordCount > 0 then
        nStr := Fields[0].AsString;
    end;
  end;
  EditLevel.Text := nStr;

  //----------------------------------------------------------------------------
  nTmp := 'Select Count(*),(Select Count(*) From $T Where M_Sex=''$W''),' +
          '(Select Count(*) From $T Where M_Sex=''$M'') From $T';

  nTmp := MacroValue(nTmp, [MI('$W', sFlag_Woman), MI('$M', sFlag_Man),
                            MI('$T', sTable_Member)]);
  //xxxxx

  with FDM.QueryTemp(nTmp) do
  begin
    nStr := '��[ %s ]λ Ůʿ:[ %s ]λ ��ʿ:[ %s ]λ';
    nStr := Format(nStr, [Fields[0].AsString, Fields[1].AsString, Fields[2].AsString]);
    EditNumber.Text := nStr;
  end;

  //----------------------------------------------------------------------------
  nTmp := 'Select M_Name From %s Where M_BirthDay Like ''%%%s''';
  nStr := Date2Str(Date); System.Delete(nStr, 1, 4);
  nTmp := Format(nTmp, [sTable_Member, nStr]);

  with FDM.QueryTemp(nTmp) do
  if RecordCount > 0 then
  begin
    First;
    nStr := '';

    while not Eof do
    begin
      if nStr = '' then
           nStr := Fields[0].AsString
      else nStr := nStr + ';' + Fields[0].AsString;

      Next;
    end;

    EditBirthday.Text := nStr;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormNavMain.Timer1Timer(Sender: TObject);
begin
  EditTime.Text := DateTimeToStr(Now);
end;

//Desc: ����λ��
procedure TfFormNavMain.wPanelResize(Sender: TObject);
begin
  dxLayout1.Left := Round((wPanel.Width - dxLayout1.Width) / 2);
  dxLayout1.Top := Round((wPanel.Height - dxLayout1.Height) / 2);
end;
 
//Desc: �رջ����
procedure TfFormNavMain.CloseActiveForm(const nNotClose: TFormClass);
begin
  if Assigned(FActiveForm) and
     ((not Assigned(nNotClose)) or (not (FActiveForm is nNotClose))) then
  begin
    if FActiveForm is TfBgFormBase then
         TfBgFormBase(FActiveForm).CloseForm
    else FActiveForm.Close;

    FActiveForm := nil;
  end;

  dxLayout1.Visible := False;
  wPanel.InvalidPanel;
end;

//Desc: ����ڹر�ʱ
procedure TfFormNavMain.OnCloseActiveForm(Sender: TObject);
begin
  FActiveForm := nil;
  dxLayout1.Visible := True;

  if Sender is TfFormMemberWork then
  begin
    if TfFormMemberWork(Sender).FPlanChanged then LoadPlanList;
  end else

  if Sender is TfFormPlan then
  begin
    if TfFormPlan(Sender).FDataChanged then LoadPlanList;
  end else

  if Sender is TfFormMember then
  begin
    if TfFormMember(Sender).FMemberChanged then LoadMemberList;
  end;
end;

//Desc: ���ջ�Ա��ϸ
procedure TfFormNavMain.EditBirthdayPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormMemberBirth);
  FActiveForm := ShowBirthMemberForm(nRect);
end;

//Desc: ���ٶ�λ��Ա
procedure TfFormNavMain.EditFindPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  EditFind.Text := Trim(EditFind.Text);
  if EditFind.Text = '' then
  begin
    EditFind.SetFocus;
    FDM.ShowMsg('�������Ա��Ż�����', sHint); Exit;
  end;

  nStr := 'Select M_ID From $T ' +
          'Where M_ID Like ''%%$P%%'' Or M_Name Like ''%%$P%%''';
  nStr := MacroValue(nStr, [MI('$T', sTable_Member), MI('$P', EditFind.Text)]);

  with FDM.QueryTemp(nSTr) do
  begin
    if RecordCount = 0 then
    begin
      EditFind.SetFocus;
      FDM.ShowMsg('û���ҵ��û�Ա', sHint); Exit;
    end;

    if RecordCount > 1 then
    begin
      EditFind.SetFocus;
      FDM.ShowMsg('����д����ϸ�Ĳ�������', '�ҵ������Ա'); Exit;
    end;

    CloseActiveForm;
    ShowMemberWorkForm(Fields[0].AsString);
  end;
end;

//Desc: �޸ĵ�¼����
procedure TfFormNavMain.EditPwdPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormChangePwd);
  FActiveForm := ChangeUserPwd(nRect, gSysParam.FUserID, gSysParam.FUserPwd);
end;

//Desc: ��Ա����
procedure TfFormNavMain.Button_MemberClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormMember);
  FActiveForm := ShowAddMemberForm(nRect);
end;

//Desc: Ӳ������
procedure TfFormNavMain.Button_HardwareClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(nil);
  ShowCameraSetupForm(False, nRect);
end;

//Desc: ��������
procedure TfFormNavMain.Button_PlanClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormPlanView);
  FActiveForm := ShowPlanViewForm(nRect);
end;

//Desc: ��Ʒ���
procedure TfFormNavMain.Button_ProductClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormProductView2);
  FActiveForm := ShowProductView2Form(nRect);
end;

//Desc: ����ͬ��
procedure TfFormNavMain.Button_SyncClick(Sender: TObject);
var nRect: TRect;
begin
  if gSysDBType = dtAccess then
  begin
    ShowDlg('����ģʽ���޷�����ͬ��!!', sHint); Exit;
  end;

  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  CloseActiveForm(TfFormDataSync);
  FActiveForm := ShowDataSyncForm(nRect);
end;

//Desc: ��������ť���
procedure TfFormNavMain.OnItemClick(Sender: TObject);
var nRect: TRect;
begin
  nRect := wPanel.ClientRect;
  nRect.TopLeft := wPanel.ClientToScreen(nRect.TopLeft);
  nRect.BottomRight := wPanel.ClientToScreen(nRect.BottomRight);

  if dxNavBar1.ActiveGroup = Group_Product then
  begin
    CloseActiveForm(TfFormProduct);
    FActiveForm := ShowViewProductForm(TdxNavBarItem(Sender).Hint, nRect);
  end else

  if dxNavBar1.ActiveGroup = Group_Plan then
  begin
    CloseActiveForm(TfFormPlan);
    FActiveForm := ShowViewPlanForm(TdxNavBarItem(Sender).Hint, nRect);
  end else

  if dxNavBar1.ActiveGroup = Group_Member then
  begin
    if (Assigned(FActiveForm) and (FActiveForm is TfFormMember)) or
       ((GetKeyState(VK_CONTROL) and $8000) <> 0) then
    begin
      CloseActiveForm(TfFormMember);
      FActiveForm := ShowEditMemberForm(TdxNavBarItem(Sender).Hint, nRect);
    end else
    begin
      CloseActiveForm;
      ShowMemberWorkForm(TdxNavBarItem(Sender).Hint);
    end;
  end else
end;

end.
