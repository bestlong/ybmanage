{*******************************************************************************
  作者: dmzn@163.com 2009-6-23
  描述: 会员过户
*******************************************************************************}
unit UFormMemberOwner;

{$I Link.Inc}
interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, {$IFDEF cxLibrary42}cxLookAndFeelPainters, {$ELSE}cxCheckBox, {$ENDIF}
  UFormNormal, cxGraphics, cxDropDownEdit, cxTextEdit, cxMaskEdit,
  cxCheckComboBox, cxContainer, cxEdit, cxLabel, cxPC, dxLayoutControl,
  StdCtrls, cxControls;

type
  TfFormMemberOwner = class(TfFormNormal)
    wPage: TcxPageControl;
    cxSheet1: TcxTabSheet;
    cxSheet2: TcxTabSheet;
    dxLayout1Item11: TdxLayoutItem;
    cxLabel3: TcxLabel;
    cxLabel4: TcxLabel;
    EditMember: TcxCheckComboBox;
    EditFixedBeauty: TcxComboBox;
    cxLabel2: TcxLabel;
    cxLabel5: TcxLabel;
    cxLabel6: TcxLabel;
    EditBeauty: TcxCheckComboBox;
    EditFixedBeauty2: TcxComboBox;
    cxLabel1: TcxLabel;
    procedure wPageChange(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    procedure GetSaveSQLList(const nList: TStrings); override;

    procedure InitFormData(const nMember,nBeauty: string);
    procedure BroadcastRefreshData;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, UAdjustForm, UFrameBase, UFormBase, UDataModule, USysDB,
  USysConst, USysPopedom;

//------------------------------------------------------------------------------
class function TfFormMemberOwner.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nStr: string;
    nP: PFormCommandParam;
begin
  Result := nil;
  nP := nParam;

  with TfFormMemberOwner.Create(Application) do
  begin
    //Caption := '会员过户';
    
    if nPopedom = 'MAIN_C03' then
         wPage.ActivePage := cxSheet2
    else wPage.ActivePage := cxSheet1;

    if not gSysParam.FIsAdmin then
    begin
      nStr := gPopedomManager.FindUserPopedom(gSysParam.FUserID, nPopedom);
      BtnOK.Enabled := Pos(sPopedom_Edit, nStr) > 0;
    end;

    if Assigned(nP) and (nP.FCommand = cCmd_EditData) then
    begin
      if nP.FParamB <> '' then
           wPage.ActivePage := cxSheet2
      else wPage.ActivePage := cxSheet1;

      InitFormData(nP.FParamA, nP.FParamB); 
    end else InitFormData('', '');

    if ShowModal = mrOK then BroadcastRefreshData;
    Free;
  end;
end;

class function TfFormMemberOwner.FormID: integer;
begin
  Result := cFI_FormMemberOwner;
end;

//------------------------------------------------------------------------------
procedure TfFormMemberOwner.InitFormData(const nMember,nBeauty: string);
var nStr: string;
begin
  if EditMember.Properties.Items.Count < 1 then
  begin
    EditMember.Properties.Items.Clear;
    nStr := 'Select M_ID,M_Name From ' + sTable_Member;

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      with EditMember.Properties.Items.Add do
      begin
        Description := Fields[0].AsString + '、' + Fields[1].AsString;
        ShortDescription := Fields[1].AsString;

        if (nMember <> '') and (Fields[0].AsString = nMember) then
          EditMember.SetItemState(Index, cbsChecked);
        //选中

        Next;
      end;
    end;
  end;

  if EditBeauty.Properties.Items.Count < 1 then
  begin
    EditBeauty.Properties.Items.Clear;
    EditFixedBeauty.Properties.Items.Clear;
    EditFixedBeauty2.Properties.Items.Clear;

    nStr := 'Select B_ID,B_Name From ' + sTable_Beautician;
    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := Fields[0].AsString + '、' + Fields[1].AsString;
        EditFixedBeauty.Properties.Items.Add(Fields[0].AsString + '=' + nStr);
        EditFixedBeauty2.Properties.Items.Add(Fields[0].AsString + '=' + nStr);

        with EditBeauty.Properties.Items.Add do
        begin
          Description := nStr;
          ShortDescription := Fields[1].AsString;

          if (nBeauty <> '') and (Fields[0].AsString = nBeauty) then
             EditBeauty.SetItemState(Index, cbsChecked);
          //选中
        end;

        Next;
      end;

      AdjustCXComboBoxItem(EditFixedBeauty, False);
      AdjustCXComboBoxItem(EditFixedBeauty2, False);
    end;
  end;
end;

//Desc: 切换焦点
procedure TfFormMemberOwner.wPageChange(Sender: TObject);
begin
  if Showing then
   if wPage.ActivePage = cxSheet1 then
        EditFixedBeauty.SetFocus
   else EditFixedBeauty2.SetFocus;
end;

//Desc: 验证控件
function TfFormMemberOwner.OnVerifyCtrl(Sender: TObject;
  var nHint: string): Boolean;
begin
  Result := True;

  if wPage.ActivePage = cxSheet1 then
  begin
    if Sender = EditMember then
    begin
      Result := Pos('1', EditMember.EditValue) > 0;
      nHint := '请选择要过户的会员';
    end else

    if Sender = EditFixedBeauty then
    begin
      Result := EditFixedBeauty.ItemIndex > -1;
      nHint := '请指定美容师';
    end;
  end else
  begin
    if Sender = EditBeauty then
    begin
      Result := Pos('1', EditBeauty.EditValue) > 0;
      nHint := '请选择要过户的美容师';
    end else

    if Sender = EditFixedBeauty2 then
    begin
      Result := EditFixedBeauty2.ItemIndex > -1;
      nHint := '请指定美容师';
    end;
  end;
end;

//Desc: 获取保存SQL
procedure TfFormMemberOwner.GetSaveSQLList(const nList: TStrings);
var i,nCount: integer;
    nStr,nSQL,nID,nItems: string;
begin
  nList.Clear;

  if wPage.ActivePage = cxSheet1 then
  begin
    nItems := EditMember.EditValue;
    nCount := Length(nItems);

    nID := GetCtrlData(EditFixedBeauty);
    nSQL := 'Update ' + sTable_Member + ' Set M_Beautician=''%s'' Where M_ID=''%s''';

    for i:=1 to nCount do
    if nItems[i] = '1' then
    begin
      nStr := EditMember.Properties.Items[i - 1].Description;
      nStr := Copy(nStr, 1, Pos('、', nStr) - 1);
      nList.Add(Format(nSQL, [nID, nStr]));
    end;
  end else
  begin
    nItems := EditBeauty.EditValue;
    nCount := Length(nItems);

    nID := GetCtrlData(EditFixedBeauty2);
    nSQL := 'Update ' + sTable_Member + ' Set M_Beautician=''%s'' Where M_Beautician=''%s''';

    for i:=1 to nCount do
    if nItems[i] = '1' then
    begin
      nStr := EditBeauty.Properties.Items[i - 1].Description;
      nStr := Copy(nStr, 1, Pos('、', nStr) - 1);
      nList.Add(Format(nSQL, [nID, nStr]));
    end;
  end;
end;

//Desc: 广播刷新消息
procedure TfFormMemberOwner.BroadcastRefreshData;
begin
  BroadcastFrameCommand(Self, cCmd_RefreshData);
end;

initialization
  gControlManager.RegCtrl(TfFormMemberOwner, TfFormMemberOwner.FormID);
end.
 