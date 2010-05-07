{*******************************************************************************
  ����: dmzn@163.com 2009-8-16
  ����: �޸��û�����
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
    //�û���Ϣ
  public
    { Public declarations }
  end;

function ChangeUserPwd(const nRect: TRect; const nUser,nPwd: string): TForm;
//��ں���

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

//Desc: ����
procedure TfFormChangePwd.BtnOKClick(Sender: TObject);
var nStr: string;
begin
  if gSysDBType = dtAccess then
  begin
    nStr := '����ģʽ��������ֻ�ڱ�����Ч,Ҫ������?';
    if not QueryDlg(nStr, sAsk, Handle) then Exit;
  end;

  if EditOld.Text <> FPassword then
  begin
    EditOld.SetFocus;
    FDM.ShowMsg('��������ȷ�ľ�����', sHint); Exit;
  end;

  if EditPwd.Text = '' then
  begin
    EditPwd.SetFocus;
    FDM.ShowMsg('����д������', sHint); Exit;
  end;

  if EditPwd.Text <> EditPwd2.Text then
  begin
    EditPwd2.SetFocus;
    FDM.ShowMsg('��������������벻һ��', sHint); Exit;
  end;

  nStr := 'Update %s Set U_PASSWORD=''%s'' Where U_NAME=''%s''';
  nStr := Format(nStr, [sTable_User, EditPwd.Text, FUserName]);
  FDM.ExecuteSQL(nStr);

  gSysParam.FUserPwd := EditPwd.Text;
  CloseForm;
  ShowMsg('�������Ѿ���Ч', sHint);
end;

end.
