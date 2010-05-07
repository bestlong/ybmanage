{*******************************************************************************
  ����: dmzn@163.com 2009-6-25
  ����: ����ʦǰ̨��������Ԫ 
*******************************************************************************}
unit UFormMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs;

type
  TfFormMain = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fFormMain: TfFormMain;

implementation

{$R *.dfm}
uses
  IniFiles, Jpeg, UcxChinese, UImageControl, ULibFun, USysFun, USysConst,
  USysGobal, UFormLogin;

//------------------------------------------------------------------------------
procedure TfFormMain.FormCreate(Sender: TObject);
var nStr: string;
begin
  InitSystemEnvironment;
  LoadSysParameter;
  //ϵͳ��������

  nStr := gPath + sFormConfig;
  System.Insert(sFilePostfix, nStr, Pos('.', nStr));

  Application.Title := gSysParam.FAppTitle;
  InitGlobalVariant(gPath, gPath + sConfigFile, nStr, gPath + sDBConfig);
  //ȫ�ֱ�������

  with TImageControl.Create(Self) do
  begin
    Parent := Self;
    Align := alTop;
    Position := cpTop;
  end;

  with TImageControl.Create(Self) do
  begin
    Parent := Self;
    Align := alBottom;
    Position := cpBottom;
  end;

  with TImageControl.Create(Self) do
  begin
    Parent := Self;
    Align := alLeft;
    Position := cpLeft;
  end;

  with TImageControl.Create(Self) do
  begin
    Parent := Self;
    Align := alRight;
    Position := cpRight;
  end;

  with TImageControl.Create(Self) do
  begin
    Parent := Self;
    Align := alClient;
    Position := cpClient;
  end;

  ShowLoginForm;
  //��ʾ��¼
end;

end.
