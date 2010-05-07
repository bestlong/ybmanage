{*******************************************************************************
  ����: dmzn@163.com 2009-6-28
  ����: ��Ч���û��б�
*******************************************************************************}
unit UFormUserList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxControls, cxContainer, cxMCListBox, StdCtrls,
  UTransPanel;

type
  TfFormUseList = class(TfBgFormBase)
    BtnOK: TButton;
    BtnExit: TButton;
    ListUser1: TcxMCListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure ListUser1DblClick(Sender: TObject);
  private
    { Private declarations }
    function GetSelectedUser: string;
    procedure InitFormData;
  public
    { Public declarations }
  end;

function ShowSelectUserForm: string;
//��ں���

implementation

{$R *.dfm}

uses
  ULibFun, UMgrPopedom, USysGrid, USysDB, USysConst;

//Desc: ѡ���û�
function ShowSelectUserForm: string;
begin
  with TfFormUseList.Create(Application) do
  begin
    InitFormData;
    if ShowModal = mrOK then
         Result := GetSelectedUser
    else Result := '';
    Free;
  end;
end;

procedure TfFormUseList.FormCreate(Sender: TObject);
begin
  inherited;
  LoadMCListBoxConfig(Name, ListUser1);
end;

procedure TfFormUseList.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited;
  SaveMCListBoxConfig(Name, ListUser1);
end;

//------------------------------------------------------------------------------
procedure TfFormUseList.InitFormData;
var nStr: string;
begin
  if gSysDBType = dtAccess then
  begin
    nStr := 'Select U_Name,'' '' as U_GName,' +
            'U_State From $U u';
  end else
  begin
    nStr := 'Select U_Name,(Select G_NAME From $G Where G_ID=u.U_Group) as U_GName,' +
            'U_State From $U u';
  end;

  nStr := MacroValue(nStr, [MI('$G', sTable_Group), MI('$U', sTable_User)]);

  ListUser1.Clear;
  with FDM.QueryTemp(nStr) do
   if RecordCount > 0 then
   begin
     First;

     While not Eof do
     begin
       nStr := Fields[0].AsString + ListUser1.Delimiter +
               Fields[1].AsString +  ' ' + ListUser1.Delimiter;

       if Fields[2].AsInteger = cPopedomUser_Normal then
            nStr := nStr + 'Y����Ч'
       else nStr := nStr + 'N������';

       ListUser1.Items.Add(nStr);
       Next;
     end;
   end;
end;

//Desc: ѡ���û�
function TfFormUseList.GetSelectedUser: string;
begin
  if ListUser1.ItemIndex > -1 then
  begin
    Result := ListUser1.Items[ListUser1.ItemIndex];
    Result := Copy(Result, 1, Pos(ListUser1.Delimiter, Result) - 1);
  end else Result := '';
end;

procedure TfFormUseList.ListUser1DblClick(Sender: TObject);
begin
  if ListUser1.ItemIndex > -1 then ModalResult := mrOk;
end;

//Desc; ѡ��
procedure TfFormUseList.BtnOKClick(Sender: TObject);
begin
  if ListUser1.ItemIndex < 0 then
       FDM.ShowMsg('�������б���ѡ���û�', sHint)
  else ModalResult := mrOk;
end;

end.
