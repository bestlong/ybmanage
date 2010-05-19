{*******************************************************************************
  作者: dmzn@163.com 2008-08-07
  描述: 系统数据库常量定义

  备注:
  *.自动创建SQL语句,支持变量:$Inc,自增;$Float,浮点;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,二进制流
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

const
  cSysDatabaseName: array[0..4] of String = (
     'Access', 'SQL', 'MySQL', 'Oracle', 'DB2');
  //db names

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //db types

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable: string;
    FNewSQL: string;
  end;
  //系统表项

var
  gSysTableList: TList = nil;                        //系统表数组
  gSysDBType: TSysDatabaseType = dtSQLServer;        //系统数据类型

//------------------------------------------------------------------------------
const
  //自增字段
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //小数字段
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //图片字段
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

  //日期相关
  sField_SQLServer_Now           = 'getDate()';
  
ResourceString
  {*权限项*}
  sPopedom_Read       = 'A';                         //浏览
  sPopedom_Add        = 'B';                         //添加
  sPopedom_Edit       = 'C';                         //修改
  sPopedom_Delete     = 'D';                         //删除
  sPopedom_Preview    = 'E';                         //预览
  sPopedom_Print      = 'F';                         //打印
  sPopedom_Export     = 'G';                         //导出

  {*相关标记*}
  sFlag_Yes           = 'Y';                         //是
  sFlag_No            = 'N';                         //否
  sFlag_Enabled       = 'Y';                         //启用
  sFlag_Disabled      = 'N';                         //禁用

  sFlag_Man           = 'A';                         //男士
  sFlag_Woman         = 'B';                         //女士

  sFlag_Integer       = 'I';                         //整数
  sFlag_Decimal       = 'D';                         //小数

  sFlag_MemberItem    = 'MemberItem';                //会员信息项
  sFlag_RelationItem  = 'RelationItem';              //关系信息项
  sFlag_RemindItem    = 'RemindItem';                //提醒信息项
  sFlag_Beautician    = 'Beautician';                //美容师信息
  sFlag_ProductType   = 'ProductType';               //产品分类
  sFlag_PlantItem     = 'PlantItem';                 //厂商信息项
  sFlag_ProviderItem  = 'ProviderItem';              //供应商信息项
  sFlag_ProductItem   = 'ProductItem';               //产品信息项
  sFlag_SkinPart      = 'SkinPartItem';              //皮肤部位信息项
  sFlag_SkinType      = 'SkinTypeItem';              //皮肤状况信息项
  sFlag_PlanItem      = 'PlanItem';                  //方案类型
  sFlag_Hardware      = 'HardwareItem';              //硬件信息  
  
  {*数据表*}
  sTable_Group        = 'Sys_Group';                 //用户组
  sTable_User         = 'Sys_User';                  //用户表
  sTable_Menu         = 'Sys_Menu';                  //菜单表
  sTable_Popedom      = 'Sys_Popedom';               //权限表
  sTable_PopItem      = 'Sys_PopItem';               //权限项
  sTable_Entity       = 'Sys_Entity';                //字典实体
  sTable_DictItem     = 'Sys_DataDict';              //字典明细

  sTable_SysDict      = 'Sys_Dict';                  //系统字典
  sTable_ExtInfo      = 'Sys_ExtInfo';               //附加信息
  sTable_SysLog       = 'Sys_EventLog';              //系统日志
  sTable_SyncItem     = 'Sys_SyncItem';              //同步临时表
  sTable_BaseInfo     = 'Sys_BaseInfo';              //基础信息

  sTable_MemberType   = 'Sys_MemberType';            //会员类型
  sTable_Member       = 'Sys_Member';                //会员
  sTable_MemberExt    = 'Sys_MemberExt';             //会员扩展
  sTable_BeautiType   = 'Sys_BeautiType';            //美容师类型
  sTable_Remind       = 'Sys_Remind';                //提醒服务

  sTable_Beautician   = 'Sys_Beautician';            //美容师
  sTable_BeauticianExt= 'Sys_BeauticianExt';         //相关证书
  sTable_ProductType  = 'Sys_ProductType';           //产品分类
  sTable_Plant        = 'Sys_Plant';                 //生产厂
  sTable_Product      = 'Sys_Product';               //产品
  sTable_SkinType     = 'Sys_SkinType';              //皮肤状况

  sTable_Plan         = 'Sys_Plan';                  //方案
  sTable_PlanExt      = 'Sys_PlanExt';               //方案扩展
  sTable_Provider     = 'Sys_Provider';              //供应商
  sTable_Hardware     = 'Sys_Hardware';              //硬件信息
  sTable_PlanUsed     = 'Sys_PlanUsed';              //方案采用
  sTable_ProductUsed  = 'Sys_ProductUsed';           //产品使用
  sTable_PickImage    = 'Sys_PickImage';             //采集图像
  sTable_PlanReport   = 'Sys_PlanReport';            //方案报告

  sTable_JiFenRule    = 'Sys_JiFenRule';             //积分规则
  sTable_JiFen        = 'Sys_JiFen';                 //积分表
  sTable_TuPu         = 'Sys_TuPu';                  //皮肤图谱

  {*新建表*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   系统字典: SysDict
   *.D_ID: 编号
   *.D_Name: 名称
   *.D_Desc: 描述
   *.D_Value: 取值
   *.D_Memo: 相关信息
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.I_ID: 编号
   *.I_Group: 信息分组
   *.I_ItemID: 信息标识
   *.I_Item: 信息项
   *.I_Info: 信息内容
   *.I_ParamA: 浮点参数
   *.I_ParamB: 字符参数
   *.I_Memo: 备注信息
   *.I_Index: 显示索引
  -----------------------------------------------------------------------------}

  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(50))';
  {-----------------------------------------------------------------------------
   系统日志: SysLog
   *.L_ID: 编号
   *.L_Date: 操作日期
   *.L_Man: 操作人
   *.L_Group: 信息分组
   *.L_ItemID: 信息标识
   *.L_KeyID: 辅助标识
   *.L_Event: 事件
  -----------------------------------------------------------------------------}

  sSQL_NewSyncItem = 'Create Table $Table(S_ID $Inc, S_Table varChar(50),' +
       'S_Field varChar(50), S_Value varChar(50), S_ExtField varChar(50),' +
       'S_ExtValue varChar(50))';
  {-----------------------------------------------------------------------------
   同步临时表: SyncItem
   *.S_Table: 表名
   *.S_Field: 字段
   *.S_Value: 字段值
   *.S_ExtField: 扩展字段
   *.S_ExtValue: 扩展值
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(50), B_Py varChar(25), B_Memo varChar(25),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   基本信息表: BaseInfo
   *.B_ID: 编号
   *.B_Group: 分组
   *.B_Text: 内容
   *.B_Py: 拼音简写
   *.B_Memo: 备注信息
   *.B_PID: 上级节点
   *.B_Index: 创建顺序
  -----------------------------------------------------------------------------}

  sSQL_NewMemberType = 'Create Table $Table(T_ID $Inc, T_Name varChar(20),' +
       'T_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   会员类型: MemberType
   *.T_ID: 编号
   *.T_Name: 名称
   *.T_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewBeautiType = 'Create Table $Table(T_ID $Inc, T_Name varChar(20),' +
       'T_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   美容师类型: BeautiType
   *.T_ID: 编号
   *.T_Name: 名称
   *.T_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewMember = 'Create Table $Table(M_ID varChar(15), M_Name varChar(30),' +
         'M_Type varChar(20), M_Sex Char(1), M_Age Integer,' +
         'M_BirthDay varChar(10), M_Height $Float,M_Weight $Float, ' +
         'M_Phone varChar(20), M_Beautician varChar(15),M_CDate DateTime,' +
         'M_Addr varChar(50), M_Memo varChar(50), M_Image $Image)';
  {-----------------------------------------------------------------------------
   会员类型: Member
   *.M_ID: 编号
   *.M_Name: 名称
   *.M_Type: 类别
   *.M_Sex: 性别
   *.M_Age: 年龄
   *.M_BirthDay: 生日
   *.M_Height: 身高
   *.M_Weight: 体重
   *.M_Phone: 联系方式
   *.M_Beautician: 美容师
   *.M_CDate: 建档日期
   *.M_Addr: 地址
   *.M_Memo: 备注
   *.M_Image: 头像
  -----------------------------------------------------------------------------}

  sSQL_NewMemberExt = 'Create Table $Table(E_ID $Inc, E_FID varChar(15),' +
         'E_Relation varChar(20), E_BID varChar(15))';
  {-----------------------------------------------------------------------------
   会员类型: Member
   *.E_ID: 编号
   *.E_FID: 前置会员号,主动关系(Front Member)
   *.E_Relation: 关系名
   *.E_BID: 后置会员名,被动关系(Back Member)
  -----------------------------------------------------------------------------}

  sSQL_NewRemin = 'Create Table $Table(R_ID $Inc, R_Date DateTime,' +
         'R_Title varChar(50), R_Type varChar(32), R_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   提醒服务: Remin
   *.R_ID: 编号
   *.R_Date: 日期
   *.R_Title: 标题
   *.R_Type: 类型
   *.R_Memo: 内容
  -----------------------------------------------------------------------------}

  sSQL_NewBeautician = 'Create Table $Table(B_ID varChar(15), B_Name varChar(32),' +
       'B_Sex Char(1), B_Age Integer, B_Birthday varChar(10),B_Phone varChar(20),' +
       'B_Level varChar(20), B_Memo varChar(50), B_Image $Image)';
  {-----------------------------------------------------------------------------
   美容师: Beautician
   *.B_ID: 编号
   *.B_Name: 姓名
   *.B_Sex: 性别
   *.B_Age: 年龄
   *.B_Birthday: 生日
   *.B_Phone: 联系方式
   *.B_Level: 级别
   *.B_Memo: 备注
   *.B_Image: 照片
  -----------------------------------------------------------------------------}

  sSQL_NewBeauticianExt = 'Create Table $Table(E_ID $Inc, E_BID varChar(15),' +
       'E_Title Char(1), E_Memo varChar(50), E_Image $Image)';
  {-----------------------------------------------------------------------------
   美容师证件: BeauticianExt
   *.E_ID: 编号
   *.E_BID: 美容师编号
   *.E_Title: 标题
   *.E_Memo: 备注
   *.E_Image: 图像
  -----------------------------------------------------------------------------}

  sSQL_NewProductType = 'Create Table $Table(P_ID $Inc, P_Name varChar(32),' +
       'P_Py varChar(16), P_Memo varChar(50), P_PID Integer, P_Index Integer)';
  {-----------------------------------------------------------------------------
   产品类别: ProductType
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_Py: 拼音
   *.P_Memo: 备注
   *.P_PID: 上级
   *.P_Index: 索引
  -----------------------------------------------------------------------------}

  sSQL_NewPlant = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_Addr varChar(50), P_Phone varChar(20), P_Memo varChar(50),' +
       'P_Image $Image)';
  {-----------------------------------------------------------------------------
   生产厂商: Plant
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_Addr: 地址
   *.P_Phone: 联系方式
   *.P_Memo: 备注
   *.P_Image: 商标
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_Addr varChar(50), P_Phone varChar(20), P_Memo varChar(50),' +
       'P_Image $Image)';
  {-----------------------------------------------------------------------------
   供应商: Privider
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_Addr: 地址
   *.P_Phone: 联系方式
   *.P_Memo: 备注
   *.P_Image: 商标
  -----------------------------------------------------------------------------}

  sSQL_NewProduct = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_Type Integer, P_Plant varChar(15), P_Provider varChar(15),' +
       'P_Price $Float, P_Memo varChar(50), P_Image $Image)';
  {-----------------------------------------------------------------------------
   产品: Product
   *.P_ID: 编号
   *.P_Name: 品名
   *.P_Type: 类别
   *.P_Plant: 厂商
   *.P_Provider: 供应商
   *.P_Price: 价格
   *.P_Memo: 备注
   *.P_Image: 图像
  -----------------------------------------------------------------------------}

  sSQL_NewProductUsed = 'Create Table $Table(U_ID $Inc, U_PID varChar(15),' +
       'U_MID varChar(15), U_BID varChar(15), U_Date DateTime)';
  {-----------------------------------------------------------------------------
   产品: ProductUsed
   *.U_ID: 编号
   *.U_PID: 产品编号
   *.U_MID: 会员编号
   *.U_BID: 美容师编号
   *.U_Date: 推荐日期
  -----------------------------------------------------------------------------}

  sSQL_NewSkinType = 'Create Table $Table(T_ID varChar(15), T_Name varChar(32),' +
       'T_Part Integer, T_Memo varChar(50), T_MID varChar(15),' +
       'T_BID varChar(15), T_Date DateTime, T_Image $Image)';
  {-----------------------------------------------------------------------------
   皮肤类型: SkinType
   *.T_ID: 编号
   *.T_Name: 名称
   *.T_Part: 部位
   *.T_MID: 会员
   *.T_BID: 美容师
   *.T_Date: 日期
   *.T_Memo: 备注
   *.T_Image: 图像
  -----------------------------------------------------------------------------}

  sSQL_NewPlan = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_PlanType Integer, P_SkinType varChar(15), P_Memo varChar(50),' +
       'P_MID varChar(15), P_Man varChar(32), P_Date varChar(20))';
  {-----------------------------------------------------------------------------
   方案: Plan
   *.P_ID: 编号
   *.P_Name: 名称
   *.P_PlanType: 方案分类
   *.P_SkinType: 皮肤类型
   *.P_MID: 会员编号
   *.P_Man: 创建人
   *.P_Date: 创建日期
   *.P_Memo: 备注
  -----------------------------------------------------------------------------}

  sSQL_NewPlanExt = 'Create Table $Table(E_ID $Inc, E_Plan varChar(15),' +
       'E_Skin varChar(32), E_Product varChar(15), E_Memo varChar(255),' +
       'E_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   扩展信息表: ExtInfo
   *.E_ID: 编号
   *.E_Plan: 方案
   *.E_Skin: 皮肤特征
   *.E_Product: 产品
   *.E_Memo: 备注信息
   *.E_Index: 显示索引
  -----------------------------------------------------------------------------}
  
  sSQL_NewPlanReport = 'Create Table $Table(R_ID $Inc, R_PID varChar(15),' +
       'R_Skin varChar(250), R_Plan varChar(250), R_Memo varchar(250), R_Date DateTime)';
  {-----------------------------------------------------------------------------
   报告记录: PlanReport
   *.R_ID: 编号
   *.R_PID: 方案编号
   *.R_Skin: 皮肤特征
   *.R_Plan: 方案
   *.R_Memo: 描述
   *.R_Date: 日期
  -----------------------------------------------------------------------------}

  sSQL_NewPlanUsed = 'Create Table $Table(U_ID $Inc, U_PID varChar(15),' +
       'U_MID varChar(15), U_BID varChar(15), U_Date DateTime)';
  {-----------------------------------------------------------------------------
   方案采用表: PlanUsed
   *.U_ID: 编号
   *.U_PID: 方案编号
   *.U_MID: 会员编号
   *.U_BID: 美容师编号
   *.U_Date: 采用时间
  -----------------------------------------------------------------------------}

  sSQL_NewHardware = 'Create Table $Table(H_ID varChar(15), H_Dev varChar(100),' +
       'H_Size varChar(100))';
  {-----------------------------------------------------------------------------
   硬件信息表: Hardware
   *.H_ID: 编号
   *.H_Dev: 设备名
   *.H_Size: 画面比例
  -----------------------------------------------------------------------------}

  sSQL_NewPickImage = 'Create Table $Table(P_ID $Inc, P_MID varChar(15),' +
       'P_Part Integer, P_Date DateTime, P_Desc varChar(50), P_Image $Image)';
  {-----------------------------------------------------------------------------
   图像采集表: PicImage
   *.P_ID: 编号
   *.P_MID: 会员编号
   *.P_Part: 采集部位
   *.P_Date: 采集时间
   *.P_Desc: 描述信息
   *.P_Image: 图像
  -----------------------------------------------------------------------------}

  sSQL_NewJiFenRule = 'Create Table $Table(R_ID $Inc, R_Money $Float,' +
       'R_JiFen $Float)';
  {-----------------------------------------------------------------------------
   积分规则表: JiFenRule
   *.R_ID: 编号
   *.R_Money: 消费金额
   *.R_JiFen: 积分
  -----------------------------------------------------------------------------}

  sSQL_NewJiFen = 'Create Table $Table(F_ID $Inc, F_MID varChar(15),' +
       'F_Product varChar(50), F_Money $Float, F_Rule $Float, F_JiFen $Float,' +
       'F_Date DateTime)';
  {-----------------------------------------------------------------------------
   积分表: JiFen
   *.F_ID: 编号
   *.F_MID: 会员编号
   *.F_Product: 产品名称
   *.F_Money: 消费金额
   *.F_Rule: 积分标准
   *.F_JiFen: 积分
   *.F_Date: 消费日期
  -----------------------------------------------------------------------------}

  sSQL_NewTuPu = 'Create Table $Table(T_ID $Inc, T_LevelA varChar(50),' +
       'T_PYA varChar(50), T_LevelB varChar(50), T_PYB varChar(50),' +
       'T_TuPu $Image, T_Small $Image, T_Memo varChar(50),' +
       'T_Man varChar(32), T_Date DateTime)';
  {-----------------------------------------------------------------------------
   图谱表: TuPu
   *.T_ID: 编号
   *.T_LevelA: 一级标识
   *.T_LevelB: 二级标识
   *.T_PYA,T_PYB: 拼音
   *.T_TuPu: 图谱
   *.T_Small: 微缩图谱
   *.T_Memo: 备注
   *.T_Man: 操作人
   *.T_Date: 操作日期
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// 数据查询
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index Desc';
  {-----------------------------------------------------------------------------
   从数据字典读取数据
   *.$Table: 数据字典表
   *.$Name: 字典项名称
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';    
  {-----------------------------------------------------------------------------
   从扩展信息表读取数据
   *.$Table: 扩展信息表
   *.$Group: 分组名称
   *.$ID: 信息标识
  -----------------------------------------------------------------------------}
  
implementation

//------------------------------------------------------------------------------
//Desc: 添加系统表项
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: 系统表数组
procedure InitSysTableList;
begin
  gSysTableList := TList.Create;

  AddSysTableItem(sTable_SysDict, sSQL_NewSysDict);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);
  AddSysTableItem(sTable_SysLog, sSQL_NewSysLog);

  AddSysTableItem(sTable_SyncItem, sSQL_NewSyncItem);
  AddSysTableItem(sTable_BaseInfo, sSQL_NewBaseInfo);
  AddSysTableItem(sTable_MemberType, sSQL_NewMemberType);
  AddSysTableItem(sTable_ExtInfo, sSQL_NewExtInfo);

  AddSysTableItem(sTable_BeautiType, sSQL_NewBeautiType);
  AddSysTableItem(sTable_Member, sSQL_NewMember);
  AddSysTableItem(sTable_MemberExt, sSQL_NewMemberExt);

  AddSysTableItem(sTable_Remind, sSQL_NewRemin);
  AddSysTableItem(sTable_Beautician, sSQL_NewBeautician);
  AddSysTableItem(sTable_BeauticianExt, sSQL_NewBeauticianExt);

  AddSysTableItem(sTable_ProductType, sSQL_NewProductType);
  AddSysTableItem(sTable_Plant, sSQL_NewPlant);
  AddSysTableItem(sTable_Provider, sSQL_NewProvider);

  AddSysTableItem(sTable_Product, sSQL_NewProduct);
  AddSysTableItem(sTable_SkinType, sSQL_NewSkinType);
  AddSysTableItem(sTable_Plan, sSQL_NewPlan);

  AddSysTableItem(sTable_PlanExt, sSQL_NewPlanExt);
  AddSysTableItem(sTable_Hardware, sSQL_NewHardware);

  AddSysTableItem(sTable_PlanUsed, sSQL_NewPlanUsed);
  AddSysTableItem(sTable_ProductUsed, sSQL_NewProductUsed);
  AddSysTableItem(sTable_PickImage, sSQL_NewPickImage);
  AddSysTableItem(sTable_PlanReport, sSQL_NewPlanReport);

  AddSysTableItem(sTable_JiFenRule, sSQL_NewJiFenRule);
  AddSysTableItem(sTable_JiFen, sSQL_NewJiFen);
  AddSysTableItem(sTable_TuPu, sSQL_NewTuPu);
end;

//Desc: 清理系统表
procedure ClearSysTableList;
var nIdx: integer;
begin
  for nIdx:= gSysTableList.Count - 1 downto 0 do
  begin
    Dispose(PSysTableItem(gSysTableList[nIdx]));
    gSysTableList.Delete(nIdx);
  end;

  FreeAndNil(gSysTableList);
end;

initialization
  InitSysTableList;
finalization
  ClearSysTableList;
end.


