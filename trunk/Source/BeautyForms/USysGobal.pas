{*******************************************************************************
  作者: dmzn@163.com 2009-7-1
  描述: 全局定义

  备注:
  *.活动窗体gActiveForm用于表示当前用户在操作的窗口
  *.文件前缀sFilePostfix,指在后台管理相关文件的基础上,添加后缀标致.
    例如配置文件Config.ini,加完后缀为Config_B.ini
*******************************************************************************}
unit USysGobal;

interface

uses
  Classes;

var
  gOnCloseActiveForm: TNotifyEvent = nil;         //窗口关闭

Resourcestring
  sFilePostfix        = '_B';                     //文件后缀

  sMember_Man         = 'Member_Man';             //男会员
  sMember_Woman       = 'Member_Woman';           //女会员
  sList_Plan          = 'List_Plan';              //方案列表
  sList_Product       = 'List_Product';           //产品列表
  sButton_Member      = 'Button_Member';          //会员管理
  sButton_Plan        = 'Button_Plan';            //方案管理
  sButton_Sync        = 'Button_Sync';            //数据同步
  sButton_Exit        = 'Button_Exit';            //退出系统

  sButton_Return      = 'Button_Return';          //返回主菜单
  sButton_MyInfo      = 'Button_MyInfo';          //会员信息
  sButton_Contrast    = 'Button_Contrast';        //图像对比
  sButton_Pick        = 'Button_Pick';            //图像采集

  sGroup_System       = 'Group_System';           //系统管理
  sGroup_Member       = 'Group_Member';           //会员列表
  sGroup_Plan         = 'Group_Plan';             //方案管理
  sGroup_Product      = 'Group_Product';          //产品列表
  sGroup_SysFun       = 'Group_SysFun';           //系统功能

  sImageConfigFile    = 'BeautyConfig.Ini';       //配置文件
  sImageViewItem      = 'ImageViewItem';          //图片查看框
  sImagePointTitle    = 'Point_Title';            //标题位置
  sImageRectValid     = 'RectValid';              //有效区域
  sImageBgFile        = 'Image_BgFile';           //背景文件
  sImageBgStyle       = 'Image_BgStyle';          //背景风格
  sImageBrdSelected   = 'Image_BorderSelected';   //选中边框
  sImageBrdUnSelected = 'Image_BorderUnSelected'; //未选中边框

  sImageExpandButton  = 'ImageExpandButton';      //展开按钮
  sImageExpandFile    = 'Image_Expand';           //展开
  sImageCollapse      = 'Image_Collapse';         //合并

implementation

end.
