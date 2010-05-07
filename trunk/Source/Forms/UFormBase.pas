{*******************************************************************************
  作者: dmzn@163.com 2009-6-13
  描述: Form基类,实现统一的函数调用
*******************************************************************************}
unit UFormBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms;

type
  TBaseFormClass = class of TBaseForm;
  //类类型

  PFormCommandParam = ^TFormCommandParam;
  TFormCommandParam = record
    FCommand: integer;
    FParamA: Variant;
    FParamB: Variant;
    FParamC: Variant;
    FParamD: Variant;
    FParamE: Variant;
  end;

  TBaseForm = class(TForm)
  protected
    FPopedom: string;
    procedure SetPopedom(const nItem: string);
    procedure OnLoadPopedom; virtual;
  public
    class function DealCommand(Sender: TObject;
      const nCmd: integer): integer; virtual;
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; virtual;
    class function FormID: integer; virtual; abstract;
    {*标识*}
    property PopedomItem: string read FPopedom write SetPopedom;
    {*属性*}
  end;

function CreateBaseFormItem(const nFormID: Integer; const nPopedom: string = '';
 const nParam: Pointer = nil): TWinControl;
function BroadcastFormCommand(Sender: TObject; const nCmd:integer): integer;
//入口函数

implementation

{$R *.dfm}

uses UMgrControl;

//------------------------------------------------------------------------------
//Desc: 将命令广播给所有的BaseForm类
function BroadcastFormCommand(Sender: TObject; const nCmd:integer): integer;
var nList: TList;
    i,nCount: integer;
    nItem: PControlItem;
begin
  nList := TList.Create;
  try
    Result := 0;
    if not gControlManager.GetCtrls(nList) then Exit;

    nCount := nList.Count - 1;
    for i:=0 to nCount do
    begin
      nItem := nList[i];
      if nItem.FClass.InheritsFrom(TBaseForm) then
        Result := Result or TBaseFormClass(nItem.FClass).DealCommand(Sender, nCmd);
      //broadcast command and combine then result
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2009-6-13
//Parm: 窗体ID;权限项;创建参数
//Desc: 创建标识为nFormID的窗体实例
function CreateBaseFormItem(const nFormID: Integer; const nPopedom: string = '';
 const nParam: Pointer = nil): TWinControl;
var nItem: PControlItem;
begin
  Result := nil;
  nItem := gControlManager.GetCtrl(nFormID);
  if Assigned(nItem) and nItem.FClass.InheritsFrom(TBaseForm) then
  begin
    Result := TBaseFormClass(nItem.FClass).CreateForm(nPopedom, nParam);
    if Assigned(Result) and (Result is TBaseForm) then
      TBaseForm(Result).PopedomItem := nPopedom;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-6-13
//Parm: 权限;参数
//Desc: 创建Form实例
class function TBaseForm.CreateForm(const nPopedom: string = '';
 const nParam: Pointer = nil): TWinControl;
begin
  Result := nil;
end;

//Desc: 设置权限项
procedure TBaseForm.SetPopedom(const nItem: string);
begin
  if FPopedom <> nItem then
  begin
    FPopedom := nItem;
    OnLoadPopedom;
  end;
end;

//Desc: 载入权限
procedure TBaseForm.OnLoadPopedom;
begin

end;

//Desc: 处理命令
class function TBaseForm.DealCommand;
begin
  Result := -1;
end;

end.
