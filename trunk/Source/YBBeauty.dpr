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
  //互斥句柄

begin
  gMutexHwnd := CreateMutex(nil, True, 'RunSoft_YBBeauty');
  //创建互斥量
  if GetLastError = ERROR_ALREADY_EXISTS then
  begin
    ReleaseMutex(gMutexHwnd);
    CloseHandle(gMutexHwnd); Exit;
  end; //已有一个实例

  Application.Initialize;
  Application.CreateForm(TFDM, FDM);
  Application.CreateForm(TfFormMain, fFormMain);
  Application.Run;

  ReleaseMutex(gMutexHwnd);
  CloseHandle(gMutexHwnd);
end.
