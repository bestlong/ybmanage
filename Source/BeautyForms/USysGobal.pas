{*******************************************************************************
  ����: dmzn@163.com 2009-7-1
  ����: ȫ�ֶ���

  ��ע:
  *.�����gActiveForm���ڱ�ʾ��ǰ�û��ڲ����Ĵ���
  *.�ļ�ǰ׺sFilePostfix,ָ�ں�̨��������ļ��Ļ�����,��Ӻ�׺����.
    ���������ļ�Config.ini,�����׺ΪConfig_B.ini
*******************************************************************************}
unit USysGobal;

interface

uses
  Classes;

var
  gOnCloseActiveForm: TNotifyEvent = nil;         //���ڹر�

Resourcestring
  sFilePostfix        = '_B';                     //�ļ���׺

  sMember_Man         = 'Member_Man';             //�л�Ա
  sMember_Woman       = 'Member_Woman';           //Ů��Ա
  sList_Plan          = 'List_Plan';              //�����б�
  sList_Product       = 'List_Product';           //��Ʒ�б�
  sButton_Member      = 'Button_Member';          //��Ա����
  sButton_Plan        = 'Button_Plan';            //��������
  sButton_Sync        = 'Button_Sync';            //����ͬ��
  sButton_Exit        = 'Button_Exit';            //�˳�ϵͳ

  sButton_Return      = 'Button_Return';          //�������˵�
  sButton_MyInfo      = 'Button_MyInfo';          //��Ա��Ϣ
  sButton_Contrast    = 'Button_Contrast';        //ͼ��Ա�
  sButton_Pick        = 'Button_Pick';            //ͼ��ɼ�

  sGroup_System       = 'Group_System';           //ϵͳ����
  sGroup_Member       = 'Group_Member';           //��Ա�б�
  sGroup_Plan         = 'Group_Plan';             //��������
  sGroup_Product      = 'Group_Product';          //��Ʒ�б�
  sGroup_SysFun       = 'Group_SysFun';           //ϵͳ����

  sImageConfigFile    = 'BeautyConfig.Ini';       //�����ļ�
  sImageViewItem      = 'ImageViewItem';          //ͼƬ�鿴��
  sImagePointTitle    = 'Point_Title';            //����λ��
  sImageRectValid     = 'RectValid';              //��Ч����
  sImageBgFile        = 'Image_BgFile';           //�����ļ�
  sImageBgStyle       = 'Image_BgStyle';          //�������
  sImageBrdSelected   = 'Image_BorderSelected';   //ѡ�б߿�
  sImageBrdUnSelected = 'Image_BorderUnSelected'; //δѡ�б߿�

  sImageExpandButton  = 'ImageExpandButton';      //չ����ť
  sImageExpandFile    = 'Image_Expand';           //չ��
  sImageCollapse      = 'Image_Collapse';         //�ϲ�

implementation

end.
