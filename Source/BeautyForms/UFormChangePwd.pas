{*******************************************************************************
  作者: dmzn@163.com 2009-8-16
  描述: 修改用户口令
*******************************************************************************}
unit UFormChangePwd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, dxLayoutControl, cxControls, UTransPanel, StdCtrls,
  cxContainer, cxEdit, cxTextEdit;

type
  TfFormChangePwd = class(TfBgFormBase)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    EditPwd: TcxTextEdit;
    dxLayout1Item1: TdxLayoutItem;
    EditPwd2: TcxTextEdit;
    dxLayout1Item2: TdxLayoutItem;
    BtnOK: TButton;
    dxLayout1Item3: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item4: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    EditOld: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  private
    { Private declarations }
    FUserName: string;
    FPassword: string;
    //用户信息
  public
    { Public declarations }
  end;

function ChangeUserPwd(const nRect: TRect; const nUser,nPwd: string): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, USysConst, USysDB, USysGobal;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
function ChangeUserPwd(const nRect: TRect; const nUser,nPwd: string): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormChangePwd.Create(Application);
  Result := gForm;

  with TfFormChangePwd(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );
    
    FUserName := nUser;
    FPassword := nPwd;
    if not Showing then Show;
  end;
end;

procedure TfFormChangePwd.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  if Action = caFree then
  begin
    gForm := nil;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
  end;
end;

procedure TfFormChangePwd.BtnExitClick(Sender: TObject);
begin
  CloseForm;
end;

//Desc: 保存
procedure TfFormChangePwd.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if gSysDBType = dtAccess then
  begin
    nStr := '单机模式下新密码只在本机有效,要继续吗?';
    if not QueryDlg(nStr, sAsk, Handle) then Exit;
  end;

  if EditOld.Text <> FPassword then
  begin
    EditOld.SetFocus;
    FDM.ShowMsg('请输入正确的旧密码', sHint); Exit;
  end;

  if EditPwd.Text = '' then
  begin
    EditPwd.SetFocus;
    FDM.ShowMsg('请填写新密码', sHint); Exit;
  end;

  if EditPwd.Text <> EditPwd2.Text then
  begin
    EditPwd2.SetFocus;
    FDM.ShowMsg('两次输入的新密码不一致', sHint); Exit;
  end;

  nStr := 'Update %s Set U_PASSWORD=''%s'' Where U_NAME=''%s''';
  nStr := Format(nStr, [sTable_User, EditPwd.Text, FUserName]);
  FDM.ExecuteSQL(nStr);

  gSysParam.FUserPwd := EditPwd.Text;
  CloseForm;
  ShowMsg('新密码已经生效', sHint);
end;

end.
