{*******************************************************************************
  作者: dmzn@163.com 2009-6-17
  描述: 提醒服务
*******************************************************************************}
unit UFormRemind;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, 
  cxMemo, cxTextEdit, cxDropDownEdit, cxContainer, cxEdit, cxMaskEdit,
  cxCalendar, cxGraphics;

type
  TfFormRemind = class(TfFormNormal)
    EditDate: TcxDateEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditType: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditTitle: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    FRemindID: string;
    procedure GetSaveSQLList(const nList: TStrings); override;
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //基类方法
    procedure InitFormData(const nID: string);
    //初始化数据
    procedure GetData(Sender: TObject; var nData: string);
    //获取数据
    function SetData(Sender: TObject; const nData: string): Boolean;
    //设置数据
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}

uses
  UMgrControl, UFormCtrl, UDataModule, UFormBase, ULibFun, USysConst, USysDB;

var
  gForm: TfFormRemind = nil;
  
//------------------------------------------------------------------------------
class function TfFormRemind.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit;

  case nP.FCommand of
   cCmd_AddData:
    with TfFormRemind.Create(Application) do
    begin
      FRemindID := '';
      Caption := '提醒服务 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormRemind.Create(Application) do
    begin
      FRemindID := nP.FParamA;
      Caption := '提醒服务 - 修改';

      InitFormData(FRemindID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormRemind.Create(Application);
        gForm.Caption := '提醒服务 - 查看';
        gForm.BtnOK.Visible := False;
      end;

      with gForm do
      begin
        FRemindID := nP.FParamA;
        InitFormData(FRemindID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
  end;
end;

class function TfFormRemind.FormID: integer;
begin
  Result := cFI_FormRemind;
end;

procedure TfFormRemind.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  ResetHintAllCtrl(Self, 'T', sTable_Remind);
end;

procedure TfFormRemind.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  gForm := nil;
  Action := caFree;
end;

//------------------------------------------------------------------------------
procedure TfFormRemind.GetData(Sender: TObject; var nData: string);
begin
  if Sender = EditDate then
  begin
    nData := Date2Str(EditDate.Date);
  end;
end;

function TfFormRemind.SetData(Sender: TObject; const nData: string): Boolean;
begin
  Result := False;

  if Sender = EditDate then
  begin
    EditDate.Text := nData;
  end;
end;

procedure TfFormRemind.InitFormData(const nID: string);
var nStr: string;
begin
  EditDate.Date := Date;
  
  if EditType.Properties.Items.Count < 1 then
  begin
    EditType.Clear;
    nStr := MacroValue(sQuery_SysDict, [MI('$Table', sTable_SysDict),
                                        MI('$Name', sFlag_RemindItem)]);
    //数据字典中提醒类型信息项

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        EditType.Properties.Items.Add(FieldByName('D_Value').AsString);
        Next;
      end;
    end;
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where R_ID=%s';
    nStr := Format(nStr, [sTable_Remind, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self, '', SetData);
  end;
end;

//Desc: 验证数据
function TfFormRemind.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditDate then
  begin
    if EditDate.Date < Str2Date('1999-01-01') then
    begin
      Result := False;
      nHint := '请填写正确的日期';
    end;
  end;
end;

procedure TfFormRemind.GetSaveSQLList(const nList: TStrings);
var nStr: string;
begin
  if FRemindID = '' then
  begin
    nList.Text := MakeSQLByForm(Self, sTable_Remind, '', True, GetData);
  end else
  begin
    nStr := 'R_ID=' + FRemindID;
    nList.Text := MakeSQLByForm(Self, sTable_Remind, nStr, False, GetData);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormRemind, TfFormRemind.FormID);
end.
