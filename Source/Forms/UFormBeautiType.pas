{*******************************************************************************
  作者: dmzn@163.com 2009-6-14
  描述: 美容师类型
*******************************************************************************}
unit UFormBeautiType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMCListBox;

type
  TfFormBeautiType = class(TfFormNormal)
    EditType: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    EditMemo: TcxTextEdit;
    dxLayout1Item4: TdxLayoutItem;
    BtnAdd: TButton;
    dxLayout1Item5: TdxLayoutItem;
    BtnDel: TButton;
    dxLayout1Item6: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxLayout1Group2: TdxLayoutGroup;
    TypeList1: TcxMCListBox;
    dxLayout1Item7: TdxLayoutItem;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure TypeList1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    { Private declarations }
    FDataChanged: Boolean;
    //数据变动
    procedure InitFormData(const nWhere: string);
    procedure GetSaveSQLList(const nList: TStrings); override;
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  UMgrControl, ULibFun, UDataModule, USyspopedom, USysGrid, USysDB, USysConst;

//------------------------------------------------------------------------------
class function TfFormBeautiType.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  
  with TfFormBeautiType.Create(Application) do
  begin
    Caption := '美容师类别';
    FDataChanged := False;
    
    InitFormData('');
    ShowModal;
    Free;
  end;
end;

class function TfFormBeautiType.FormID: integer;
begin
  Result := cFI_FormBeautiType;
end;

procedure TfFormBeautiType.FormCreate(Sender: TObject);
begin
  LoadMCListBoxConfig(Name, TypeList1);
end;

procedure TfFormBeautiType.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, TypeList1);
end;

//------------------------------------------------------------------------------
//Desc: 载入数据
procedure TfFormBeautiType.InitFormData(const nWhere: string);
var nStr: string;
begin
  TypeList1.Clear;
  nStr := 'Select * From ' + sTable_BeautiType;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;
    
    while not Eof do
    begin
      nStr := FieldByName('T_Name').AsString + TypeList1.Delimiter +
              FieldByName('T_Memo').AsString + ' ';
      TypeList1.Items.Add(nStr);
      
      Next;
    end;
  end;
end;

//Desc: 获取保存SQL列表
procedure TfFormBeautiType.GetSaveSQLList(const nList: TStrings);
var i,nCount,nPos: integer;
    nStr,nTemp,nSQL: string;
begin
  if not FDataChanged then Exit;
  nStr := 'Delete From ' + sTable_BeautiType;
  nList.Add(nStr);

  nSQL := 'Insert Into ' + sTable_BeautiType +
          '(T_Name, T_Memo) Values(''%s'', ''%s'')';
  nCount := TypeList1.Items.Count - 1;

  for i:=0 to nCount do
  begin
    nStr := TypeList1.Items[i];
    nPos := Pos(TypeList1.Delimiter, nStr);

    nTemp := Copy(nStr, 1, nPos - 1);
    System.Delete(nStr, 1, nPos);
    nList.Add(Format(nSQL, [nTemp, Trim(nStr)]));
  end;
end;

//Desc: 添加项
procedure TfFormBeautiType.BtnAddClick(Sender: TObject);
var nStr: string;
    i,nCount: integer;
begin
  EditType.Text := Trim(EditType.Text);
  if EditType.Text = '' then
  begin
    EditType.SetFocus;
    ShowMsg('请填写有效的等级名称', sHint); Exit;
  end;

  nStr := EditType.Text + TypeList1.Delimiter;
  nCount := TypeList1.Items.Count - 1;

  for i:=0 to nCount do
  if Pos(nStr, TypeList1.Items[i]) = 1 then
  begin
    EditType.SetFocus;
    ShowMsg('该等级已经存在', sHint); Exit;
  end;

  nStr := EditType.Text + TypeList1.Delimiter + EditMemo.Text + ' ';
  TypeList1.Items.Add(nStr);
  FDataChanged := True;

  EditType.SetFocus;
  EditType.SelectAll;
end;

//Desc: 删除类别
procedure TfFormBeautiType.BtnDelClick(Sender: TObject);
var nIdx: integer;
begin
  nIdx := TypeList1.ItemIndex;
  if nIdx > -1 then
  begin
    TypeList1.Items.Delete(nIdx);
    FDataChanged := True;
    
    if nIdx >= TypeList1.Items.Count then Dec(nIdx);
    if nIdx > -1 then TypeList1.ItemIndex := nIdx;
  end;
end;

//------------------------------------------------------------------------------
procedure TfFormBeautiType.TypeList1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var nStr: string;
    nIdx: integer;
begin
  if ssCtrl in Shift then
  begin
    if TypeList1.ItemIndex < 0 then
         Exit
    else nStr := TypeList1.Items[TypeList1.ItemIndex];

    if Key = VK_UP then
    begin
      nIdx := TypeList1.ItemIndex - 1;
      if nIdx < 0 then Exit;
    end else

    if Key = VK_Down then
    begin
      nIdx := TypeList1.ItemIndex + 1;
      if nIdx >= TypeList1.Items.Count then Exit;
    end else Exit;

    Key := 0;
    TypeList1.Items.Delete(TypeList1.ItemIndex);
    TypeList1.Items.Insert(nIdx, nStr);
    TypeList1.ItemIndex := nIdx;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormBeautiType, TfFormBeautiType.FormID);
end.
