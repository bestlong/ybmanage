{*******************************************************************************
  ����: dmzn@163.com 2008-08-07
  ����: ϵͳ���ݿⳣ������

  ��ע:
  *.�Զ�����SQL���,֧�ֱ���:$Inc,����;$Float,����;$Integer=sFlag_Integer;
    $Decimal=sFlag_Decimal;$Image,��������
*******************************************************************************}
unit USysDB;

{$I Link.inc}
interface

uses
  SysUtils, Classes;

type
  TSysDatabaseType = (dtAccess, dtSQLServer, dtMySQL, dtOracle, dtDB2);
  //ϵͳ���ݿ�����

  PSysTableItem = ^TSysTableItem;
  TSysTableItem = record
    FTable     : string;
    FNewSQL    : string;
  end;
  //ϵͳ����

var
  gSysTableList: TList = nil;
  //ϵͳ������
  gSysDBType: TSysDatabaseType = dtSQLServer;
  //ϵͳ��������

//------------------------------------------------------------------------------
const
  //�����ֶ�
  sField_Access_AutoInc          = 'Counter';
  sField_SQLServer_AutoInc       = 'Integer IDENTITY (1,1) PRIMARY KEY';

  //С���ֶ�
  sField_Access_Decimal          = 'Float';
  sField_SQLServer_Decimal       = 'Decimal(15, 5)';

  //ͼƬ�ֶ�
  sField_Access_Image            = 'OLEObject';
  sField_SQLServer_Image         = 'Image';

ResourceString
  {*Ȩ����*}
  sPopedom_Read       = 'A';                         //���
  sPopedom_Add        = 'B';                         //���
  sPopedom_Edit       = 'C';                         //�޸�
  sPopedom_Delete     = 'D';                         //ɾ��
  sPopedom_Preview    = 'E';                         //Ԥ��
  sPopedom_Print      = 'F';                         //��ӡ
  sPopedom_Export     = 'G';                         //����

  {*��ر��*}
  sFlag_Yes           = 'Y';                         //��
  sFlag_No            = 'N';                         //��
  sFlag_Enabled       = 'Y';                         //����
  sFlag_Disabled      = 'N';                         //����

  sFlag_Man           = 'A';                         //��ʿ
  sFlag_Woman         = 'B';                         //Ůʿ

  sFlag_Integer       = 'I';                         //����
  sFlag_Decimal       = 'D';                         //С��

  sFlag_MemberItem    = 'MemberItem';                //��Ա��Ϣ��
  sFlag_RelationItem  = 'RelationItem';              //��ϵ��Ϣ��
  sFlag_RemindItem    = 'RemindItem';                //������Ϣ��
  sFlag_Beautician    = 'Beautician';                //����ʦ��Ϣ
  sFlag_ProductType   = 'ProductType';               //��Ʒ����
  sFlag_PlantItem     = 'PlantItem';                 //������Ϣ��
  sFlag_ProviderItem  = 'ProviderItem';              //��Ӧ����Ϣ��
  sFlag_ProductItem   = 'ProductItem';               //��Ʒ��Ϣ��
  sFlag_SkinPart      = 'SkinPartItem';              //Ƥ����λ��Ϣ��
  sFlag_SkinType      = 'SkinTypeItem';              //Ƥ��״����Ϣ��
  sFlag_PlanItem      = 'PlanItem';                  //��������
  sFlag_Hardware      = 'HardwareItem';              //Ӳ����Ϣ  
  
  {*���ݱ�*}
  sTable_Group        = 'Sys_Group';                 //�û���
  sTable_User         = 'Sys_User';                  //�û���
  sTable_Menu         = 'Sys_Menu';                  //�˵���
  sTable_Popedom      = 'Sys_Popedom';               //Ȩ�ޱ�
  sTable_PopItem      = 'Sys_PopItem';               //Ȩ����
  sTable_Entity       = 'Sys_Entity';                //�ֵ�ʵ��
  sTable_DictItem     = 'Sys_DataDict';              //�ֵ���ϸ

  sTable_SysDict      = 'Sys_Dict';                  //ϵͳ�ֵ�
  sTable_ExtInfo      = 'Sys_ExtInfo';               //������Ϣ
  sTable_SysLog       = 'Sys_EventLog';              //ϵͳ��־
  sTable_SyncItem     = 'Sys_SyncItem';              //ͬ����ʱ��
  sTable_BaseInfo     = 'Sys_BaseInfo';              //������Ϣ

  sTable_MemberType   = 'Sys_MemberType';            //��Ա����
  sTable_Member       = 'Sys_Member';                //��Ա
  sTable_MemberExt    = 'Sys_MemberExt';             //��Ա��չ
  sTable_BeautiType   = 'Sys_BeautiType';            //����ʦ����
  sTable_Remind       = 'Sys_Remind';                //���ѷ���

  sTable_Beautician   = 'Sys_Beautician';            //����ʦ
  sTable_BeauticianExt= 'Sys_BeauticianExt';         //���֤��
  sTable_ProductType  = 'Sys_ProductType';           //��Ʒ����
  sTable_Plant        = 'Sys_Plant';                 //������
  sTable_Product      = 'Sys_Product';               //��Ʒ
  sTable_SkinType     = 'Sys_SkinType';              //Ƥ��״��

  sTable_Plan         = 'Sys_Plan';                  //����
  sTable_PlanExt      = 'Sys_PlanExt';               //������չ
  sTable_Provider     = 'Sys_Provider';              //��Ӧ��
  sTable_Hardware     = 'Sys_Hardware';              //Ӳ����Ϣ
  sTable_PlanUsed     = 'Sys_PlanUsed';              //��������
  sTable_ProductUsed  = 'Sys_ProductUsed';           //��Ʒʹ��
  sTable_PickImage    = 'Sys_PickImage';             //�ɼ�ͼ��
  sTable_PlanReport   = 'Sys_PlanReport';            //��������

  sTable_JiFenRule    = 'Sys_JiFenRule';             //���ֹ���
  sTable_JiFen        = 'Sys_JiFen';                 //���ֱ�

  {*�½���*}
  sSQL_NewSysDict = 'Create Table $Table(D_ID $Inc, D_Name varChar(15),' +
       'D_Desc varChar(30), D_Value varChar(50), D_Memo varChar(20),' +
       'D_ParamA $Float, D_ParamB varChar(50), D_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ϵͳ�ֵ�: SysDict
   *.D_ID: ���
   *.D_Name: ����
   *.D_Desc: ����
   *.D_Value: ȡֵ
   *.D_Memo: �����Ϣ
  -----------------------------------------------------------------------------}
  
  sSQL_NewExtInfo = 'Create Table $Table(I_ID $Inc, I_Group varChar(20),' +
       'I_ItemID varChar(20), I_Item varChar(30), I_Info varChar(500),' +
       'I_ParamA $Float, I_ParamB varChar(50), I_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.I_ID: ���
   *.I_Group: ��Ϣ����
   *.I_ItemID: ��Ϣ��ʶ
   *.I_Item: ��Ϣ��
   *.I_Info: ��Ϣ����
   *.I_ParamA: �������
   *.I_ParamB: �ַ�����
   *.I_Memo: ��ע��Ϣ
   *.I_Index: ��ʾ����
  -----------------------------------------------------------------------------}

  sSQL_NewSysLog = 'Create Table $Table(L_ID $Inc, L_Date DateTime,' +
       'L_Man varChar(32),L_Group varChar(20), L_ItemID varChar(20),' +
       'L_KeyID varChar(20), L_Event varChar(50))';
  {-----------------------------------------------------------------------------
   ϵͳ��־: SysLog
   *.L_ID: ���
   *.L_Date: ��������
   *.L_Man: ������
   *.L_Group: ��Ϣ����
   *.L_ItemID: ��Ϣ��ʶ
   *.L_KeyID: ������ʶ
   *.L_Event: �¼�
  -----------------------------------------------------------------------------}

  sSQL_NewSyncItem = 'Create Table $Table(S_ID $Inc, S_Table varChar(50),' +
       'S_Field varChar(50), S_Value varChar(50), S_ExtField varChar(50),' +
       'S_ExtValue varChar(50))';
  {-----------------------------------------------------------------------------
   ͬ����ʱ��: SyncItem
   *.S_Table: ����
   *.S_Field: �ֶ�
   *.S_Value: �ֶ�ֵ
   *.S_ExtField: ��չ�ֶ�
   *.S_ExtValue: ��չֵ
  -----------------------------------------------------------------------------}

  sSQL_NewBaseInfo = 'Create Table $Table(B_ID $Inc, B_Group varChar(15),' +
       'B_Text varChar(50), B_Py varChar(25), B_Memo varChar(25),' +
       'B_PID Integer, B_Index Float)';
  {-----------------------------------------------------------------------------
   ������Ϣ��: BaseInfo
   *.B_ID: ���
   *.B_Group: ����
   *.B_Text: ����
   *.B_Py: ƴ����д
   *.B_Memo: ��ע��Ϣ
   *.B_PID: �ϼ��ڵ�
   *.B_Index: ����˳��
  -----------------------------------------------------------------------------}

  sSQL_NewMemberType = 'Create Table $Table(T_ID $Inc, T_Name varChar(20),' +
       'T_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ��Ա����: MemberType
   *.T_ID: ���
   *.T_Name: ����
   *.T_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewBeautiType = 'Create Table $Table(T_ID $Inc, T_Name varChar(20),' +
       'T_Memo varChar(50))';
  {-----------------------------------------------------------------------------
   ����ʦ����: BeautiType
   *.T_ID: ���
   *.T_Name: ����
   *.T_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewMember = 'Create Table $Table(M_ID varChar(15), M_Name varChar(30),' +
         'M_Type varChar(20), M_Sex Char(1), M_Age Integer,' +
         'M_BirthDay varChar(10), M_Height $Float,M_Weight $Float, ' +
         'M_Phone varChar(20), M_Beautician varChar(15),M_CDate DateTime,' +
         'M_Addr varChar(50), M_Memo varChar(50), M_Image $Image)';
  {-----------------------------------------------------------------------------
   ��Ա����: Member
   *.M_ID: ���
   *.M_Name: ����
   *.M_Type: ���
   *.M_Sex: �Ա�
   *.M_Age: ����
   *.M_BirthDay: ����
   *.M_Height: ���
   *.M_Weight: ����
   *.M_Phone: ��ϵ��ʽ
   *.M_Beautician: ����ʦ
   *.M_CDate: ��������
   *.M_Addr: ��ַ
   *.M_Memo: ��ע
   *.M_Image: ͷ��
  -----------------------------------------------------------------------------}

  sSQL_NewMemberExt = 'Create Table $Table(E_ID $Inc, E_FID varChar(15),' +
         'E_Relation varChar(20), E_BID varChar(15))';
  {-----------------------------------------------------------------------------
   ��Ա����: Member
   *.E_ID: ���
   *.E_FID: ǰ�û�Ա��,������ϵ(Front Member)
   *.E_Relation: ��ϵ��
   *.E_BID: ���û�Ա��,������ϵ(Back Member)
  -----------------------------------------------------------------------------}

  sSQL_NewRemin = 'Create Table $Table(R_ID $Inc, R_Date DateTime,' +
         'R_Title varChar(50), R_Type varChar(32), R_Memo varChar(200))';
  {-----------------------------------------------------------------------------
   ���ѷ���: Remin
   *.R_ID: ���
   *.R_Date: ����
   *.R_Title: ����
   *.R_Type: ����
   *.R_Memo: ����
  -----------------------------------------------------------------------------}

  sSQL_NewBeautician = 'Create Table $Table(B_ID varChar(15), B_Name varChar(32),' +
       'B_Sex Char(1), B_Age Integer, B_Birthday varChar(10),B_Phone varChar(20),' +
       'B_Level varChar(20), B_Memo varChar(50), B_Image $Image)';
  {-----------------------------------------------------------------------------
   ����ʦ: Beautician
   *.B_ID: ���
   *.B_Name: ����
   *.B_Sex: �Ա�
   *.B_Age: ����
   *.B_Birthday: ����
   *.B_Phone: ��ϵ��ʽ
   *.B_Level: ����
   *.B_Memo: ��ע
   *.B_Image: ��Ƭ
  -----------------------------------------------------------------------------}

  sSQL_NewBeauticianExt = 'Create Table $Table(E_ID $Inc, E_BID varChar(15),' +
       'E_Title Char(1), E_Memo varChar(50), E_Image $Image)';
  {-----------------------------------------------------------------------------
   ����ʦ֤��: BeauticianExt
   *.E_ID: ���
   *.E_BID: ����ʦ���
   *.E_Title: ����
   *.E_Memo: ��ע
   *.E_Image: ͼ��
  -----------------------------------------------------------------------------}

  sSQL_NewProductType = 'Create Table $Table(P_ID $Inc, P_Name varChar(32),' +
       'P_Py varChar(16), P_Memo varChar(50), P_PID Integer, P_Index Integer)';
  {-----------------------------------------------------------------------------
   ��Ʒ���: ProductType
   *.P_ID: ���
   *.P_Name: ����
   *.P_Py: ƴ��
   *.P_Memo: ��ע
   *.P_PID: �ϼ�
   *.P_Index: ����
  -----------------------------------------------------------------------------}

  sSQL_NewPlant = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_Addr varChar(50), P_Phone varChar(20), P_Memo varChar(50),' +
       'P_Image $Image)';
  {-----------------------------------------------------------------------------
   ��������: Plant
   *.P_ID: ���
   *.P_Name: ����
   *.P_Addr: ��ַ
   *.P_Phone: ��ϵ��ʽ
   *.P_Memo: ��ע
   *.P_Image: �̱�
  -----------------------------------------------------------------------------}

  sSQL_NewProvider = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_Addr varChar(50), P_Phone varChar(20), P_Memo varChar(50),' +
       'P_Image $Image)';
  {-----------------------------------------------------------------------------
   ��Ӧ��: Privider
   *.P_ID: ���
   *.P_Name: ����
   *.P_Addr: ��ַ
   *.P_Phone: ��ϵ��ʽ
   *.P_Memo: ��ע
   *.P_Image: �̱�
  -----------------------------------------------------------------------------}

  sSQL_NewProduct = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_Type Integer, P_Plant varChar(15), P_Provider varChar(15),' +
       'P_Price $Float, P_Memo varChar(50), P_Image $Image)';
  {-----------------------------------------------------------------------------
   ��Ʒ: Product
   *.P_ID: ���
   *.P_Name: Ʒ��
   *.P_Type: ���
   *.P_Plant: ����
   *.P_Provider: ��Ӧ��
   *.P_Price: �۸�
   *.P_Memo: ��ע
   *.P_Image: ͼ��
  -----------------------------------------------------------------------------}

  sSQL_NewProductUsed = 'Create Table $Table(U_ID $Inc, U_PID varChar(15),' +
       'U_MID varChar(15), U_BID varChar(15), U_Date DateTime)';
  {-----------------------------------------------------------------------------
   ��Ʒ: ProductUsed
   *.U_ID: ���
   *.U_PID: ��Ʒ���
   *.U_MID: ��Ա���
   *.U_BID: ����ʦ���
   *.U_Date: �Ƽ�����
  -----------------------------------------------------------------------------}

  sSQL_NewSkinType = 'Create Table $Table(T_ID varChar(15), T_Name varChar(32),' +
       'T_Part Integer, T_Memo varChar(50), T_MID varChar(15),' +
       'T_BID varChar(15), T_Date DateTime, T_Image $Image)';
  {-----------------------------------------------------------------------------
   Ƥ������: SkinType
   *.T_ID: ���
   *.T_Name: ����
   *.T_Part: ��λ
   *.T_MID: ��Ա
   *.T_BID: ����ʦ
   *.T_Date: ����
   *.T_Memo: ��ע
   *.T_Image: ͼ��
  -----------------------------------------------------------------------------}

  sSQL_NewPlan = 'Create Table $Table(P_ID varChar(15), P_Name varChar(32),' +
       'P_PlanType Integer, P_SkinType varChar(15), P_Memo varChar(50),' +
       'P_MID varChar(15), P_Man varChar(32), P_Date varChar(20))';
  {-----------------------------------------------------------------------------
   ����: Plan
   *.P_ID: ���
   *.P_Name: ����
   *.P_PlanType: ��������
   *.P_SkinType: Ƥ������
   *.P_MID: ��Ա���
   *.P_Man: ������
   *.P_Date: ��������
   *.P_Memo: ��ע
  -----------------------------------------------------------------------------}

  sSQL_NewPlanExt = 'Create Table $Table(E_ID $Inc, E_Plan varChar(15),' +
       'E_Skin varChar(32), E_Product varChar(15), E_Memo varChar(255),' +
       'E_Index Integer Default 0)';
  {-----------------------------------------------------------------------------
   ��չ��Ϣ��: ExtInfo
   *.E_ID: ���
   *.E_Plan: ����
   *.E_Skin: Ƥ������
   *.E_Product: ��Ʒ
   *.E_Memo: ��ע��Ϣ
   *.E_Index: ��ʾ����
  -----------------------------------------------------------------------------}
  
  sSQL_NewPlanReport = 'Create Table $Table(R_ID $Inc, R_PID varChar(15),' +
       'R_Skin varChar(250), R_Plan varChar(250), R_Memo varchar(250), R_Date DateTime)';
  {-----------------------------------------------------------------------------
   �����¼: PlanReport
   *.R_ID: ���
   *.R_PID: �������
   *.R_Skin: Ƥ������
   *.R_Plan: ����
   *.R_Memo: ����
   *.R_Date: ����
  -----------------------------------------------------------------------------}

  sSQL_NewPlanUsed = 'Create Table $Table(U_ID $Inc, U_PID varChar(15),' +
       'U_MID varChar(15), U_BID varChar(15), U_Date DateTime)';
  {-----------------------------------------------------------------------------
   �������ñ�: PlanUsed
   *.U_ID: ���
   *.U_PID: �������
   *.U_MID: ��Ա���
   *.U_BID: ����ʦ���
   *.U_Date: ����ʱ��
  -----------------------------------------------------------------------------}

  sSQL_NewHardware = 'Create Table $Table(H_ID varChar(15), H_Dev varChar(100),' +
       'H_Size varChar(100))';
  {-----------------------------------------------------------------------------
   Ӳ����Ϣ��: Hardware
   *.H_ID: ���
   *.H_Dev: �豸��
   *.H_Size: �������
  -----------------------------------------------------------------------------}

  sSQL_NewPickImage = 'Create Table $Table(P_ID $Inc, P_MID varChar(15),' +
       'P_Part Integer, P_Date DateTime, P_Desc varChar(50), P_Image $Image)';
  {-----------------------------------------------------------------------------
   ͼ��ɼ���: PicImage
   *.P_ID: ���
   *.P_MID: ��Ա���
   *.P_Part: �ɼ���λ
   *.P_Date: �ɼ�ʱ��
   *.P_Desc: ������Ϣ
   *.P_Image: ͼ��
  -----------------------------------------------------------------------------}

  sSQL_NewJiFenRule = 'Create Table $Table(R_ID $Inc, R_Money $Float,' +
       'R_JiFen $Float)';
  {-----------------------------------------------------------------------------
   ���ֹ����: JiFenRule
   *.R_ID: ���
   *.R_Money: ���ѽ��
   *.R_JiFen: ����
  -----------------------------------------------------------------------------}

  sSQL_NewJiFen = 'Create Table $Table(F_ID $Inc, F_MID varChar(15),' +
       'F_Product varChar(50), F_Money $Float, F_Rule $Float, F_JiFen $Float,' +
       'F_Date DateTime)';
  {-----------------------------------------------------------------------------
   ���ֱ�: JiFen
   *.F_ID: ���
   *.F_MID: ��Ա���
   *.F_Product: ��Ʒ����
   *.F_Money: ���ѽ��
   *.F_Rule: ���ֱ�׼
   *.F_JiFen: ����
   *.F_Date: ��������
  -----------------------------------------------------------------------------}

//------------------------------------------------------------------------------
// ���ݲ�ѯ
//------------------------------------------------------------------------------
  sQuery_SysDict = 'Select D_ID, D_Value, D_Memo From $Table ' +
                   'Where D_Name=''$Name'' Order By D_Index Desc';
  {-----------------------------------------------------------------------------
   �������ֵ��ȡ����
   *.$Table: �����ֵ��
   *.$Name: �ֵ�������
  -----------------------------------------------------------------------------}

  sQuery_ExtInfo = 'Select I_ID, I_Item, I_Info From $Table Where ' +
                   'I_Group=''$Group'' and I_ItemID=''$ID'' Order By I_Index Desc';    
  {-----------------------------------------------------------------------------
   ����չ��Ϣ���ȡ����
   *.$Table: ��չ��Ϣ��
   *.$Group: ��������
   *.$ID: ��Ϣ��ʶ
  -----------------------------------------------------------------------------}
  
implementation

//------------------------------------------------------------------------------
//Desc: ���ϵͳ����
procedure AddSysTableItem(const nTable,nNewSQL: string);
var nP: PSysTableItem;
begin
  New(nP);
  gSysTableList.Add(nP);

  nP.FTable := nTable;
  nP.FNewSQL := nNewSQL;
end;

//Desc: ϵͳ������
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
end;

//Desc: ����ϵͳ��
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


