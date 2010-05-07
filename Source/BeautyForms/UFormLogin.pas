{*******************************************************************************
  ����: dmzn@163.com 2009-6-27
  ����: �û���¼
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
//��ں���

implementation

{$R *.dfm}
uses
  ULibFun, UMgrPopedom, USysPopedom, USysDB, USysConst, UFormConn, UFormWait,
  UFormUserList, UFormNavMain, UBase64, UUSBReader;

var
  gHintText: string;
  //�޲ɼ���ʱ��ʾ

ResourceString
  sUserLogin = '�û�[ %s ]���Ե�½ϵͳ';
  sUserLoginOK = '��½ϵͳ�ɹ�,�û�:[ %s ]';
  sConnDBError = '�������ݿ�ʧ��,���ô����Զ������Ӧ';

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
  if QueryDlg('ȷ��Ҫ�˳�ϵͳ��?', sAsk) then
  begin
    Application.MainForm.Close;
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����nConnStr�Ƿ���Ч
function ConnCallBack(const nConnStr: string): Boolean;
begin
  FDM.ADOConn.Close;
  FDM.ADOConn.ConnectionString := nConnStr;
  FDM.ADOConn.Open;
  Result := FDM.ADOConn.Connected;
end;

//Desc: �������ݿ�
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
    FDM.ShowMsg('��������ȷ��"���ݿ�"���ò���', sHint);
    if ShowConnectDBSetupForm(ConnCallBack) then
         nStr := BuildConnectDBStr
    else Exit;
  end;

  nMsg := '';
  ShowWaitForm(Self, '�������ݿ�');
  try
    nList := nil;
    try
      FDM.ADOConn.Connected := False;
      FDM.ADOConn.ConnectionString := nStr;
      FDM.ADOConn.Connected := True;

      nList := TStringList.Create;
      LoadConnecteDBConfig(nList);

      if nList.Values[sConn_Key_DBName] = '����' then
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

//Desc: ����
procedure TfFormLogin.BtnSetupClick(Sender: TObject);
begin
  if ShowConnectDBSetupForm(ConnCallBack) then FDM.ADOConn.Connected := False;
end;

//Desc: ѡ���û�
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

//Desc: ��¼
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
    nStr := '������û���������,����������';
    ShowDlg(nStr, sHint, Handle); Exit;
  end;

  gSysParam.FUserID := EditUser.Text;
  gSysParam.FUserName := FDM.SqlQuery.Fields[0].AsString;
  gSysParam.FUserPwd := EditPwd.Text;

  FDM.AdjustAllSystemTables;
  gPopedomManager.GetUserIdentity(gSysParam.FUserName);
  //��ȡ�û�������Ϣ

  Visible := False;  
  ShowNavMainForm;
  Application.MainForm.Visible := False;
  
  Application.ProcessMessages;
  CloseForm;
  {+2009.06.29: ������Ҫ����λ��,������ͷ��ӳٶ�����}
end;

initialization
  gHintText := 'z7XNs860vOyy4rW9v8nTw7XEssm8r8nosbgsx+vIt8jP0tHBrL3TsqK5pNf31f2zoyEh';
  gHintText := DecodeBase64(gHintText);
end.
 