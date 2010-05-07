{*******************************************************************************
  作者: dmzn@ylsoft.com 2007-10-09
  描述: 项目通用常,变量定义单元
*******************************************************************************}
unit USysConst;

interface

uses
  ComCtrls, Classes;

const
  cSBar_Date            = 0;                         //日期面板索引
  cSBar_Time            = 1;                         //时间面板索引
  cSBar_User            = 2;                         //用户面板索引
  cRecMenuMax           = 5;                         //最近使用导航区最大条目数
  cBeauticianGroup      = 2;                         //美容师所在组

const
  {*Frame ID*}
  cFI_FrameSysLog       = $0001;                     //系统日志
  cFI_FrameViewLog      = $0002;                     //本地日志

  cFI_FrameMemberType   = $0003;                     //会员类型
  cFI_FrameMember       = $0005;                     //会员管理
  cFI_FrameMemberQuery  = $0006;                     //会员查询
  cFI_FrameRemind       = $0007;                     //会员提醒

  cFI_FrameBeautiType   = $0009;                     //美容师类型
  cFI_FrameBeautician   = $0010;                     //美容师

  cFI_FrameProductType  = $0011;                     //产品分类
  cFI_FramePlant        = $0012;                     //生产厂
  cFI_FrameProduct      = $0013;                     //产品管理
  cFI_FrameProductQuery = $0015;                     //产品查询
  cFI_FramePlan         = $0016;                     //方案管理
  cFI_FrameSkinType     = $0017;                     //皮肤状况
  cFI_FrameProvider     = $0018;                     //供应商
  cFI_FrameJiFen        = $0019;                     //积分查询

  cFI_FormBackup        = $1001;                     //数据备份
  cFI_FormRestore       = $1002;                     //数据恢复
  cFI_FormIncInfo       = $1003;                     //公司信息
  cFI_FormChangePwd     = $1005;                     //修改密码
  CFI_FormHardware      = $1006;                     //硬件设置

  cFI_FormMemberType    = $1007;                     //会员类型
  cFI_FormBeautiType    = $1008;                     //美容师类型
  cFI_FormProductType   = $1009;                     //产品分类
  cFI_FormSkinPart      = $1010;                     //皮肤部位
  cFI_FormSkinType      = $1011;                     //皮肤状况
  cFI_FormPlanType      = $1012;                     //方案类型
  cFI_FormRemind        = $1013;                     //提醒服务
  cFI_FormBaseInfo      = $1015;                     //基本信息

  cFI_FormMemberOwner   = $0008;                     //会员过户
  cFI_FormMemberData    = $1020;                     //会员增改
  cFI_FormBeautician    = $1021;                     //美容师增改
  cFI_FormPlant         = $1022;                     //厂商增改
  cFI_FormProduct       = $1023;                     //产品增改
  cFI_FormPlan          = $1025;                     //方案增改
  cFI_FormProvider      = $1026;                     //供应商
  cFI_FormJiFenRule     = $1027;                     //积分规则
  cFI_FormJiFen         = $1028;                     //积分管理

  {*Command*}
  cCmd_RefreshData      = $0002;                     //刷新数据
  cCmd_ViewSysLog       = $0003;                     //系统日志

  cCmd_ModalResult      = $1001;                     //Modal窗体
  cCmd_FormClose        = $1002;                     //关闭窗口
  cCmd_AddData          = $1003;                     //添加数据
  cCmd_EditData         = $1005;                     //修改数据
  cCmd_ViewData         = $1006;                     //查看数据

type
  TSysParam = record
    FProgID     : string;                            //程序标识
    FAppTitle   : string;                            //程序标题栏提示
    FMainTitle  : string;                            //主窗体标题
    FHintText   : string;                            //提示文本
    FCopyRight  : string;                            //主窗体提示内容

    FUserID     : string;                            //用户标识
    FUserName   : string;                            //当前用户
    FUserPwd    : string;                            //用户口令
    FGroupID    : string;                            //所在组
    FBeautyID   : string;                            //美容师编号
    FIsAdmin    : Boolean;                           //是否管理员
    FIsNormal   : Boolean;                           //帐户是否正常

    FRecMenuMax : integer;                           //导航栏个数
    FIconFile   : string;                            //图标配置文件
  end;
  //系统参数

  TModuleItemType = (mtFrame, mtForm);

  PMenuModuleItem = ^TMenuModuleItem;
  TMenuModuleItem = record
    FMenuID: string;                                 //菜单名称
    FModule: integer;                                //模块标识
    FItemType: TModuleItemType;                      //模块类型
  end;

//------------------------------------------------------------------------------
var
  gPath: string;                                     //程序所在路径
  gSysParam:TSysParam;                               //程序环境参数
  gStatusBar: TStatusBar;                            //全局使用状态栏
  gMenuModule: TList = nil;                          //菜单模块映射表

//------------------------------------------------------------------------------
ResourceString
  sProgID             = 'DMZN';                      //默认标识
  sAppTitle           = 'DMZN';                      //程序标题
  sMainCaption        = 'DMZN';                      //主窗口标题

  sHint               = '提示';                      //对话框标题
  sWarn               = '警告';                      //==
  sAsk                = '询问';                      //询问对话框
  sError              = '未知错误';                  //错误提示

  sDate               = '日期:【%s】';               //任务栏日期
  sTime               = '时间:【%s】';               //任务栏时间
  sUser               = '用户:【%s】';               //任务栏用户

  sLogDir             = 'Logs\';                     //日志目录
  sLogExt             = '.log';                      //日志扩展名
  sLogField           = #9;                          //记录分隔符

  sDunHao             = '、';                        //顿号                          
  sBackupDir          = 'Backup\';                   //备份目录
  sBackupFile         = 'Bacup.idx';                 //备份索引

  sConfigFile         = 'Config.Ini';                //主配置文件
  sConfigSec          = 'Config';                    //主配置小节
  sVerifyCode         = ';Verify:';                  //校验码标记

  sFormConfig         = 'FormInfo.ini';              //窗体配置
  sSetupSec           = 'Setup';                     //配置小节
  sDBConfig           = 'DBConn.ini';                //数据连接

  sExportExt          = '.txt';                      //导出默认扩展名
  sExportFilter       = '文本(*.txt)|*.txt|所有文件(*.*)|*.*';
                                                     //导出过滤条件 

  sInvalidConfig      = '配置文件无效或已经损坏';    //配置文件无效
  sCloseQuery         = '确定要退出程序吗?';         //主窗口退出
  
implementation

//------------------------------------------------------------------------------
//Desc: 添加菜单模块映射项
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

//Desc: 菜单模块映射表
procedure InitMenuModuleList;
begin
  gMenuModule := TList.Create;

  AddMenuModuleItem('SYSLOG', cFI_FrameSysLog);
  //系统日志

  AddMenuModuleItem('MAIN_A01', cFI_FrameViewLog);
  //本地日志

  AddMenuModuleItem('MAIN_A02', cFI_FormRestore, mtForm);
  //数据恢复

  AddMenuModuleItem('MAIN_A03', cFI_FormBackup, mtForm);
  //数据备份

  AddMenuModuleItem('MAIN_A06', CFI_FormHardware, mtForm);
  //硬件设置

  AddMenuModuleItem('MAIN_A07', cFI_FormChangePwd, mtForm);
  //修改密码

  AddMenuModuleItem('MAIN_A08', cFI_FormIncInfo, mtForm);
  //公司信息

  AddMenuModuleItem('MAIN_B01', cFI_FormMemberType, mtForm);
  //会员类型

  AddMenuModuleItem('MAIN_B02', cFI_FrameMember);
  //会员管理

  AddMenuModuleItem('MAIN_B03', cFI_FrameMemberQuery);
  //会员查询

  AddMenuModuleItem('MAIN_B06', cFI_FrameRemind);
  //会员提醒

  AddMenuModuleItem('MAIN_C01', cFI_FormBeautiType, mtForm);
  //美容师类型

  AddMenuModuleItem('MAIN_C02', cFI_FrameBeautician);
  //美容师

  AddMenuModuleItem('MAIN_B05', cFI_FormMemberOwner, mtForm);
  AddMenuModuleItem('MAIN_C03', cFI_FormMemberOwner, mtForm);
  //会员过户

  AddMenuModuleItem('MAIN_D01', cFI_FormBaseInfo, mtForm);
  //产品分类

  AddMenuModuleItem('MAIN_D02', cFI_FramePlant);
  //生产厂商

  AddMenuModuleItem('MAIN_D03', cFI_FrameProduct);
   //产品管理

  AddMenuModuleItem('MAIN_D05', cFI_FrameProductQuery);
  //产品查询

  AddMenuModuleItem('MAIN_D07', cFI_FrameProvider);
  //供应商

  AddMenuModuleItem('MAIN_E01', cFI_FormBaseInfo, mtForm);
  //皮肤部位

  AddMenuModuleItem('MAIN_E02', cFI_FrameSkinType);
  //皮肤状况

  AddMenuModuleItem('MAIN_E03', cFI_FormBaseInfo, mtForm);
  //方案类型

  AddMenuModuleItem('MAIN_E05', cFI_FramePlan);
  //方案管理

  AddMenuModuleItem('MAIN_B07', cFI_FormJiFenRule, mtForm);
  //积分管理

  AddMenuModuleItem('MAIN_B08', cFI_FrameJiFen);
  //积分查询
end;

//Desc: 清理模块列表
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


