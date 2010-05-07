program YBBeauty;

uses
  Windows,
  Forms,
  UFormMain in 'BeautyForms\UFormMain.pas' {fFormMain},
  UDataModule in 'BeautyForms\UDataModule.pas' {FDM: TDataModule},
  UBgFormBase in 'BeautyForms\UBgFormBase.pas' {fBgFormBase},
  UFormChangePwd in 'BeautyForms\UFormChangePwd.pas' {fFormChangePwd};

{$R *.res}
var
  gMutexHwnd: Hwnd;
  //������

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_YBBeauty');
  //����������
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //����һ��ʵ��

  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.
