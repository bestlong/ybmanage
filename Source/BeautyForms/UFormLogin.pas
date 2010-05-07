{*******************************************************************************
  作者: dmzn@163.com 2009-6-27
  描述: 用户登录
*******************************************************************************}
unit UFormLogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxMaskEdit, cxButtonEdit, cxControls,
  cxContainer, cxEdit, cxTextEdit, StdCtrls, Buttons, ExtCtrls, UTransPanel;

type
  TfFormLogin = class(TfBgFormBase)
    BtnSetup: TBitBtn;
    BtnExit: TBitBtn;
    EditPwd: TcxTextEdit;
    EditUser: TcxButtonEdit;
    Bevel1: TBevel;
    Label1: TLabel;
    Label2: TLabel;
    BtnOK: TBitBtn;
    procedure BtnExitClick(Sender: TObject);
    procedure EditUserPropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure BtnSetupClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure EditUserKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    function ConnDB: Boolean;
  public
    { Public declarations }
  end;

function ShowLoginForm: Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  ULibFun, UMgrPopedom, USysPopedom, USysDB, USysConst, UFormConn, UFormWait,
  UFormUserList, UFormNavMain, UBase64, UUSBReader;

var
  gHintText: string;
  //无采集器时提示

ResourceString
  sUserLogin = '用户[ %s ]尝试登陆系统';
  sUserLoginOK = '登陆系统成功,用户:[ %s ]';
  sConnDBError = '连接数据库失败,配置错误或远程无响应';

//------------------------------------------------------------------------------
function ShowLoginForm: Boolean;
begin
  Result := False;
  with TfFormLogin.Create(Application) do
  begin
    FormStyle := fsStayOnTop;
    Show;
  end;
end;

procedure TfFormLogin.BtnExitClick(Sender: TObject);
begin
  if QueryDlg('确定要退出系统吗?', sAsk) then
  begin
    Application.MainForm.Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: 测试nConnStr是否有效
function ConnCallBack(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: 链接数据库
function TfFormLogin.ConnDB: Boolean;
var nStr: string;
    nMsg: string;
    nList: TStrings;
begin
  Result := FDM.ADOConn.Connected;
  if Result then Exit;
  nStr := BuildConnectDBStr;

  while nStr = '' do
  begin
    FDM.ShowMsg('请输入正确的"数据库"配置参数', sHint);
    if ShowConnectDBSetupForm(ConnCallBack) then
         nStr := BuildConnectDBStr
    else Exit;
  end;

  nMsg := '';
  ShowWaitForm(Self, '连接数据库');
  try
    nList := nil;
    try
      FDM.ADOConn.Connected := False;
      FDM.ADOConn.ConnectionString := nStr;
      FDM.ADOConn.Connected := True;

      nList := TStringList.Create;
      LoadConnecteDBConfig(nList);

      if nList.Values[sConn_Key_DBName] = '单机' then
           gSysDBType := dtAccess
      else gSysDBType := dtSQLServer;
      nList.Free;
    except
      if Assigned(nList) then nList.Free;
      ShowDlg(sConnDBError, sWarn, Handle); Exit;
    end;
  finally
    CloseWaitForm;
    Result := FDM.ADOConn.Connected;
    if nMsg <> '' then ShowDlg(nMsg, sHint);
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormLogin.EditUserKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    BtnOKClick(nil);
  end;
end;

//Desc: 设置
procedure TfFormLogin.BtnSetupClick(Sender: TObject);
begin
  if ShowConnectDBSetupForm(ConnCallBack) then FDM.ADOConn.Connected := False;
end;

//Desc: 选择用户
procedure TfFormLogin.EditUserPropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var nStr: string;
begin
  if ConnDB then
  begin
    nStr := ShowSelectUserForm;
    if nStr <> '' then
    begin
      EditUser.Text := nStr;
      EditPwd.SetFocus;
    end;
  end;
end;

//Desc: 登录
procedure TfFormLogin.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if not IsValidCamera then
  begin
    ShowDlg(gHintText, sWarn, Handle); Exit;
  end;
  if not ConnDB then Exit;

  nStr := 'Select U_NAME from $a Where U_NAME=''$b'' and U_PASSWORD=''$c'' ' +
            'and U_State=$d';
  nStr := MacroValue(nStr, [MI('$a',sTable_User),
                            MI('$b',EditUser.Text),
                            MI('$c',EditPwd.Text),
                            MI('$d', IntToStr(cPopedomUser_Normal))]);

  FDM.QuerySQL(nStr);
  if FDM.SqlQuery.RecordCount <> 1 then
  begin
    EditUser.SetFocus;
    nStr := '错误的用户名或密码,请重新输入';
    ShowDlg(nStr, sHint, Handle); Exit;
  end;

  gSysParam.FUserID := EditUser.Text;
  gSysParam.FUserName := FDM.SqlQuery.Fields[0].AsString;
  gSysParam.FUserPwd := EditPwd.Text;

  FDM.AdjustAllSystemTables;
  gPopedomManager.GetUserIdentity(gSysParam.FUserName);
  //获取用户更多信息

  Visible := False;  
  ShowNavMainForm;
  Application.MainForm.Visible := False;
  
  Application.ProcessMessages;
  CloseForm;
  {+2009.06.29: 本处不要调整位置,会造成释放延迟而报错}
end;

initialization
  gHintText := 'z7XNs860vOyy4rW9v8nTw7XEssm8r8nosbgsx+vIt8jP0tHBrL3TsqK5pNf31f2zoyEh';
  gHintText := DecodeBase64(gHintText);
end.
 