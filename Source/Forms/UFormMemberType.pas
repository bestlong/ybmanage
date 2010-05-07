{*******************************************************************************
  作者: dmzn@163.com 2009-6-14
  描述: 会员类型
*******************************************************************************}
unit UFormMemberType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxContainer,
  cxEdit, cxTextEdit, cxMCListBox;

type
  TfFormMemberType = class(TfFormNormal)
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
class function TfFormMemberType.CreateForm(const nPopedom: string;
  const nParam: Pointer): TWinControl;
begin
  Result := nil;
  
  with TfFormMemberType.Create(Application) do
  begin
    Caption := '会员类别';
    FDataChanged := False;
    
    InitFormData('');
    ShowModal;
    Free;
  end;
end;

class function TfFormMemberType.FormID: integer;
begin
  Result := cFI_FormMemberType;
end;

procedure TfFormMemberType.FormCreate(Sender: TObject);
begin
  LoadMCListBoxConfig(Name, TypeList1);
end;

procedure TfFormMemberType.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveMCListBoxConfig(Name, TypeList1);
end;

//------------------------------------------------------------------------------
//Desc: 载入数据
procedure TfFormMemberType.InitFormData(const nWhere: string);
var nStr: string;
begin
  TypeList1.Clear;
  nStr := 'Select * From ' + sTable_MemberType;

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
procedure TfFormMemberType.GetSaveSQLList(const nList: TStrings);
var i,nCount,nPos: integer;
    nStr,nTemp,nSQL: string;
begin
  if not FDataChanged then Exit;
  nStr := 'Delete From ' + sTable_MemberType;
  nList.Add(nStr);

  nSQL := 'Insert Into ' + sTable_MemberType +
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
procedure TfFormMemberType.BtnAddClick(Sender: TObject);
var nStr: string;
    i,nCount: integer;
begin
  EditType.Text := Trim(EditType.Text);
  if EditType.Text = '' then
  begin
    EditType.SetFocus;
    ShowMsg('请填写有效的会员类别', sHint); Exit;
  end;

  nStr := EditType.Text + TypeList1.Delimiter;
  nCount := TypeList1.Items.Count - 1;

  for i:=0 to nCount do
  if Pos(nStr, TypeList1.Items[i]) = 1 then
  begin
    EditType.SetFocus;
    ShowMsg('该类别已经存在', sHint); Exit;
  end;

  nStr := EditType.Text + TypeList1.Delimiter + EditMemo.Text + ' ';
  TypeList1.Items.Add(nStr);
  FDataChanged := True;

  EditType.SetFocus;
  EditType.SelectAll;
end;

//Desc: 删除类别
procedure TfFormMemberType.BtnDelClick(Sender: TObject);
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
procedure TfFormMemberType.TypeList1KeyDown(Sender: TObject; var Key: Word;
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
  gControlManager.RegCtrl(TfFormMemberType, TfFormMemberType.FormID);
end.
