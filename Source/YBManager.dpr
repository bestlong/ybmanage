program YBManager;

uses
  Forms,
  Windows,
  ULibFun,
  USysFun,
  UsysConst,
  UDataModule in 'Forms\UDataModule.pas' {FDM: TDataModule},
  UFormMain in 'Forms\UFormMain.pas' {fMainForm},
  UFrameBase in 'Forms\UFrameBase.pas' {BaseFrame: TBaseFrame},
  UFrameNormal in 'Forms\UFrameNormal.pas' {fFrameNormal: TFrame},
  UFormBase in 'Forms\UFormBase.pas' {BaseForm},
  UFormNormal in 'Forms\UFormNormal.pas' {fFormNormal};

{$R *.res}
var
  gMutexHwnd: Hwnd;
  //������

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_YBManager');
  //����������
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //����һ��ʵ��

  InitSystemEnvironment;
  //��ʼ�����л���
  LoadSysParameter;
  //����ϵͳ������Ϣ

  if not IsValidConfigFile(gPath + sConfigFile, gSysParam.FProgID) then
  begin
    ShowDlg(sInvalidConfig, sHint, GetDesktopWindow); Exit;
  end; //�����ļ����Ķ�
  
  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfMainForm, fMainForm);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.