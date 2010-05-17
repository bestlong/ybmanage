{*******************************************************************************
  ����: dmzn@ylsoft.com 2007-10-09
  ����: ��Ŀͨ�ó�,�������嵥Ԫ
*******************************************************************************}
unit USysConst;

interface

uses
  ComCtrls, Classes;

const
  cSBar_Date            = 0;                         //�����������
  cSBar_Time            = 1;                         //ʱ���������
  cSBar_User            = 2;                         //�û��������
  cRecMenuMax           = 5;                         //���ʹ�õ����������Ŀ��
  cBeauticianGroup      = 2;                         //����ʦ������

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //ϵͳ��־
  cFI_FrameViewLog      = $0002;                     //������־

  cFI_FrameMemberType   = $0003;                     //��Ա����
  cFI_FrameMember       = $0005;                     //��Ա����
  cFI_FrameMemberQuery  = $0006;                     //��Ա��ѯ
  cFI_FrameRemind       = $0007;                     //��Ա����

  cFI_FrameBeautiType   = $0009;                     //����ʦ����
  cFI_FrameBeautician   = $0010;                     //����ʦ

  cFI_FrameProductType  = $0011;                     //��Ʒ����
  cFI_FramePlant        = $0012;                     //������
  cFI_FrameProduct      = $0013;                     //��Ʒ����
  cFI_FrameProductQuery = $0015;                     //��Ʒ��ѯ
  cFI_FramePlan         = $0016;                     //��������
  cFI_FrameSkinType     = $0017;                     //Ƥ��״��
  cFI_FrameProvider     = $0018;                     //��Ӧ��
  cFI_FrameJiFen        = $0019;                     //���ֲ�ѯ
  cFI_FrameTuPu         = $0020;                     //Ƥ��ͼ��

  cFI_FormBackup        = $1001;                     //���ݱ���
  cFI_FormRestore       = $1002;                     //���ݻָ�
  cFI_FormIncInfo       = $1003;                     //��˾��Ϣ
  cFI_FormChangePwd     = $1005;                     //�޸�����
  CFI_FormHardware      = $1006;                     //Ӳ������

  cFI_FormMemberType    = $1007;                     //��Ա����
  cFI_FormBeautiType    = $1008;                     //����ʦ����
  cFI_FormProductType   = $1009;                     //��Ʒ����
  cFI_FormSkinPart      = $1010;                     //Ƥ����λ
  cFI_FormSkinType      = $1011;                     //Ƥ��״��
  cFI_FormPlanType      = $1012;                     //��������
  cFI_FormRemind        = $1013;                     //���ѷ���
  cFI_FormBaseInfo      = $1015;                     //������Ϣ

  cFI_FormMemberOwner   = $0008;                     //��Ա����
  cFI_FormMemberData    = $1020;                     //��Ա����
  cFI_FormBeautician    = $1021;                     //����ʦ����
  cFI_FormPlant         = $1022;                     //��������
  cFI_FormProduct       = $1023;                     //��Ʒ����
  cFI_FormPlan          = $1025;                     //��������
  cFI_FormProvider      = $1026;                     //��Ӧ��
  cFI_FormJiFenRule     = $1027;                     //���ֹ���
  cFI_FormJiFen         = $1028;                     //���ֹ���
  
  cFI_FormTuPu          = $1029;                     //Ƥ��ͼ��
  cFI_FormTuPuView      = $1030;                     //ͼ�ײ鿴

  {*Command*}
  cCmd_RefreshData      = $0002;                     //ˢ������
  cCmd_ViewSysLog       = $0003;                     //ϵͳ��־

  cCmd_ModalResult      = $1001;                     //Modal����
  cCmd_FormClose        = $1002;                     //�رմ���
  cCmd_AddData          = $1003;                     //�������
  cCmd_EditData         = $1005;                     //�޸�����
  cCmd_ViewData         = $1006;                     //�鿴����

type
  TSysParam = record
    FProgID     : string;                            //�����ʶ
    FAppTitle   : string;                            //�����������ʾ
    FMainTitle  : string;                            //���������
    FHintText   : string;                            //��ʾ�ı�
    FCopyRight  : string;                            //��������ʾ����

    FUserID     : string;                            //�û���ʶ
    FUserName   : string;                            //��ǰ�û�
    FUserPwd    : string;                            //�û�����
    FGroupID    : string;                            //������
    FBeautyID   : string;                            //����ʦ���
    FIsAdmin    : Boolean;                           //�Ƿ����Ա
    FIsNormal   : Boolean;                           //�ʻ��Ƿ�����

    FRecMenuMax : integer;                           //����������
    FIconFile   : string;                            //ͼ�������ļ�
  end;
  //ϵͳ����

  TModuleItemType = (mtFrame, mtForm);

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //�˵�����
    FModule: integer;                                //ģ���ʶ
    FItemType: TModuleItemType;                      //ģ������
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //��������·��
  gSysParam:TSysParam;                               //���򻷾�����
  gStatusBar: TStatusBar;                            //ȫ��ʹ��״̬��
  gMenuModule: TList = nil;                          //�˵�ģ��ӳ���

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //Ĭ�ϱ�ʶ
  sAppTitle           = 'DMZN';                      //�������
  sMainCaption        = 'DMZN';                      //�����ڱ���

  sHint               = '��ʾ';                      //�Ի������
  sWarn               = '����';                      //==
  sAsk                = 'ѯ��';                      //ѯ�ʶԻ���
  sError              = 'δ֪����';                  //������ʾ

  sDate               = '����:��%s��';               //����������
  sTime               = 'ʱ��:��%s��';               //������ʱ��
  sUser               = '�û�:��%s��';               //�������û�

  sLogDir             = 'Logs\';                     //��־Ŀ¼
  sLogExt             = '.log';                      //��־��չ��
  sLogField           = #9;                          //��¼�ָ���

  sDunHao             = '��';                        //�ٺ�                          
  sBackupDir          = 'Backup\';                   //����Ŀ¼
  sBackupFile         = 'Bacup.idx';                 //��������
  sImageDir           = 'Images\';                   //ͼƬĿ¼

  sConfigFile         = 'Config.Ini';                //�������ļ�
  sConfigSec          = 'Config';                    //������С��
  sVerifyCode         = ';Verify:';                  //У������

  sFormConfig         = 'FormInfo.ini';              //��������
  sSetupSec           = 'Setup';                     //����С��
  sDBConfig           = 'DBConn.ini';                //��������

  sExportExt          = '.txt';                      //����Ĭ����չ��
  sExportFilter       = '�ı�(*.txt)|*.txt|�����ļ�(*.*)|*.*';
                                                     //������������ 

  sInvalidConfig      = '�����ļ���Ч���Ѿ���';    //�����ļ���Ч
  sCloseQuery         = 'ȷ��Ҫ�˳�������?';         //�������˳�
  
implementation

//------------------------------------------------------------------------------
//Desc: ��Ӳ˵�ģ��ӳ����
procedure AddMenuModuleItem(const nMenu: string; const nModule: Integer;
 const nType: TModuleItemType = mtFrame);
var nItem: PMenuModuleItem;
begin
  New(nItem);
  gMenuModule.Add(nItem);

  nItem.FMenuID := nMenu;
  nItem.FModule := nModule;
  nItem.FItemType := nType;
end;

//Desc: �˵�ģ��ӳ���
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('SYSLOG', cFI_FrameSysLog);
  //ϵͳ��־

  AddMenuModuleItem('MAIN_A01', cFI_FrameViewLog);
  //������־

  AddMenuModuleItem('MAIN_A02', cFI_FormRestore, mtForm);
  //���ݻָ�

  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  //���ݱ���

  AddMenuModuleItem('MAIN_A06', CFI_FormHardware, mtForm);
  //Ӳ������

  AddMenuModuleItem('MAIN_A07', cFI_FormChangePwd, mtForm);
  //�޸�����

  AddMenuModuleItem('MAIN_A08', cFI_FormIncInfo, mtForm);
  //��˾��Ϣ

  AddMenuModuleItem('MAIN_B01', cFI_FormMemberType, mtForm);
  //��Ա����

  AddMenuModuleItem('MAIN_B02', cFI_FrameMember);
  //��Ա����

  AddMenuModuleItem('MAIN_B03', cFI_FrameMemberQuery);
  //��Ա��ѯ

  AddMenuModuleItem('MAIN_B06', cFI_FrameRemind);
  //��Ա����

  AddMenuModuleItem('MAIN_C01', cFI_FormBeautiType, mtForm);
  //����ʦ����

  AddMenuModuleItem('MAIN_C02', cFI_FrameBeautician);
  //����ʦ

  AddMenuModuleItem('MAIN_B05', cFI_FormMemberOwner, mtForm);
  AddMenuModuleItem('MAIN_C03', cFI_FormMemberOwner, mtForm);
  //��Ա����

  AddMenuModuleItem('MAIN_D01', cFI_FormBaseInfo, mtForm);
  //��Ʒ����

  AddMenuModuleItem('MAIN_D02', cFI_FramePlant);
  //��������

  AddMenuModuleItem('MAIN_D03', cFI_FrameProduct);
   //��Ʒ����

  AddMenuModuleItem('MAIN_D05', cFI_FrameProductQuery);
  //��Ʒ��ѯ

  AddMenuModuleItem('MAIN_D07', cFI_FrameProvider);
  //��Ӧ��

  AddMenuModuleItem('MAIN_E01', cFI_FormBaseInfo, mtForm);
  //Ƥ����λ

  AddMenuModuleItem('MAIN_E02', cFI_FrameSkinType);
  //Ƥ��״��

  AddMenuModuleItem('MAIN_E03', cFI_FormBaseInfo, mtForm);
  //��������

  AddMenuModuleItem('MAIN_E05', cFI_FramePlan);
  //��������

  AddMenuModuleItem('MAIN_B07', cFI_FormJiFenRule, mtForm);
  //���ֹ���

  AddMenuModuleItem('MAIN_B08', cFI_FrameJiFen);
  //���ֲ�ѯ

  AddMenuModuleItem('MAIN_E07', cFI_FrameTuPu);
  //Ƥ��ͼ��
end;

//Desc: ����ģ���б�
procedure ClearMenuModuleList;
var nIdx: integer;
begin
  for nIdx:=gMenuModule.Count - 1 downto 0 do
  begin
    Dispose(PMenuModuleItem(gMenuModule[nIdx]));
    gMenuModule.Delete(nIdx);
  end;

  gMenuModule.Free;
  gMenuModule := nil;
end;

initialization
  InitMenuModuleList;
finalization
  ClearMenuModuleList;
end.


