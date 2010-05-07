{*******************************************************************************
  作者: dmzn@163.com 2009-6-13
  描述: 添加、修改、删除、浏览处理Form基类
*******************************************************************************}
unit UFormNormal;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UFormBase, dxLayoutControl, cxControls, StdCtrls;

type
  TfFormNormal = class(TBaseForm)
    dxLayout1Group_Root: TdxLayoutGroup;
    dxLayout1: TdxLayoutControl;
    dxGroup1: TdxLayoutGroup;
    BtnOK: TButton;
    dxLayout1Item1: TdxLayoutItem;
    BtnExit: TButton;
    dxLayout1Item2: TdxLayoutItem;
    dxLayout1Group1: TdxLayoutGroup;
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
  protected
    { Private declarations }
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; virtual;
    function IsDataValid: Boolean; virtual;
    {*验证数据*}
    procedure GetSaveSQLList(const nList: TStrings); virtual;
    {*写SQL列表*}
  published
    procedure OnCtrlKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState); virtual;
    {*按键处理*}
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UAdjustForm, USysConst;

procedure TfFormNormal.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

//Desc: 处理快捷键
procedure TfFormNormal.OnCtrlKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if ssCtrl in Shift then
  begin
    case Key of
     VK_DOWN:
      begin
        Key := 0; SwitchFocusCtrl(Self, True);
      end;
     VK_UP:
      begin
        Key := 0; SwitchFocusCtrl(Self, False);
      end;
    end;
  end;
end;

procedure TfFormNormal.BtnExitClick(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Desc: 写数据SQL列表
procedure TfFormNormal.GetSaveSQLList(const nList: TStrings);
begin
  nList.Clear;
end;

//Desc: 验证Sender的数据是否正确,返回提示内容
function TfFormNormal.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  nHint := '';
  Result := True;
end;

//Desc: 验证数据是否正确
function TfFormNormal.IsDataValid: Boolean;
var nStr: string;
    nCtrls: TList;
    nObj: TObject;
    i,nCount: integer;
begin
  Result := True;

  nCtrls := TList.Create;
  try
    EnumSubCtrlList(Self, nCtrls);
    nCount := nCtrls.Count - 1;

    for i:=0 to nCount do
    begin
      nObj := TObject(nCtrls[i]);
      if not OnVerifyCtrl(nObj, nStr) then
      begin
        if nObj is TWinControl then
          TWinControl(nObj).SetFocus;
        ShowMsg(nStr, sHint);
        Result := False; Exit;
      end;
    end;
  finally
    nCtrls.Free;
  end;
end;

//Desc: 保存
procedure TfFormNormal.BtnOKClick(Sender: TObject);
var nSQLs: TStrings;
    i,nCount: integer;
begin
  if not IsDataValid then Exit;
  
  nSQLs := nil;
  try
    nSQLs := TStringList.Create;
    GetSaveSQLList(nSQLs);

    if nSQLs.Count > 0 then
    begin
      FDM.ADOConn.BeginTrans;
      nCount := nSQLs.Count - 1;

      for i:=0 to nCount do
        FDM.ExecuteSQL(nSQLs[i]);
      FDM.ADOConn.CommitTrans;
    end;

    ModalResult := mrOK;
    nSQLs.Free;
    ShowMsg('已保存成功', sHint);
  except
    if Assigned(nSQLs) then nSQLs.Free;
    if FDM.ADOConn.InTransaction then FDM.ADOConn.RollbackTrans;
    ShowMsg('保存数据失败', '未知错误');
  end;
end;

end.
