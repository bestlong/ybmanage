{*******************************************************************************
  ����: dmzn 2008-9-22
  ����: ���ֹ���
*******************************************************************************}
unit UFormJiFenRule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, StdCtrls, ExtCtrls, dxLayoutControl, cxControls,
  cxContainer, cxEdit, cxTextEdit, UFormBase, cxMCListBox;

type
  TfFormJiFenRule = class(TBaseForm)
    dxLayoutControl1Group_Root: TdxLayoutGroup;
    dxLayoutControl1: TdxLayoutControl;
    dxLayoutControl1Group1: TdxLayoutGroup;
    EditMoney: TcxTextEdit;
    dxLayoutControl1Item1: TdxLayoutItem;
    EditFen: TcxTextEdit;
    dxLayoutControl1Item3: TdxLayoutItem;
    ListRule: TcxMCListBox;
    dxLayoutControl1Item6: TdxLayoutItem;
    dxLayoutControl1Group3: TdxLayoutGroup;
    BtnAdd: TButton;
    dxLayoutControl1Item2: TdxLayoutItem;
    BtnDel: TButton;
    dxLayoutControl1Item7: TdxLayoutItem;
    dxLayoutControl1Group4: TdxLayoutGroup;
    dxLayoutControl1Group5: TdxLayoutGroup;
    procedure BtnAddClick(Sender: TObject);
    procedure BtnDelClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
    //��������
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  ULibFun, UMgrControl, USysConst, USysDB, USysPopedom;

//------------------------------------------------------------------------------
class function TfFormJiFenRule.CreateForm;
begin
  Result := nil;

  with TfFormJiFenRule.Create(Application) do
  begin
    Caption := '���ֱ�׼';
    BtnAdd.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Add);
    BtnDel.Enabled := gPopedomManager.HasPopedom(nPopedom, sPopedom_Delete);

    InitFormData;
    ShowModal;
    Free;
  end;
end;

class function TfFormJiFenRule.FormID: integer;
begin
  Result := cFI_FormJiFenRule;
end;

//------------------------------------------------------------------------------
//Desc: ��������
procedure TfFormJiFenRule.InitFormData;
var nStr: string;
begin
  ListRule.Clear;
  nStr := 'Select * from ' + sTable_JiFenRule;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    First;

    while not Eof do
    begin
      nStr := CombinStr([FieldByName('R_ID').AsString,
              FieldByName('R_Money').AsString,
              FieldByName('R_JiFen').AsString], ListRule.Delimiter);
      ListRule.Items.Add(nStr);
      Next;
    end;
  end;
end;

//Desc: ���
procedure TfFormJiFenRule.BtnAddClick(Sender: TObject);
var nStr: string;
begin
  if not IsNumber(EditMoney.Text, True) then
  begin
    EditMoney.SetFocus;
    ShowMsg('��������Ч���', sHint); Exit;
  end;

  if not IsNumber(EditMoney.Text, True) then
  begin
    EditMoney.SetFocus;
    ShowMsg('��������Ч����ֵ', sHint); Exit;
  end;

  nStr := 'Select Count(*) From %s Where R_Money=%s';
  nStr := Format(nStr, [sTable_JiFenRule, EditMoney.Text]);

  with FDM.QueryTemp(nStr) do
  if Fields[0].AsInteger > 0 then
  begin
    EditMoney.SetFocus;
    ShowMsg('�ý���׼�Ѵ���', sHint); Exit;
  end;

  nStr := 'Insert Into %s(R_Money,R_JiFen) Values(%s, %s)';
  nStr := Format(nStr, [sTable_JiFenRule, EditMoney.Text, EditFen.Text]);
  FDM.ExecuteSQL(nStr);

  nStr := IntToStr(FDM.GetFieldMax(sTable_JiFenRule, 'R_ID'));
  nStr := CombinStr([nStr, EditMoney.Text, EditFen.Text], ListRule.Delimiter);
  ListRule.Items.Add(nStr);
  ShowMsg('�����ɹ�', sHint);
end;

//Desc: ɾ��
procedure TfFormJiFenRule.BtnDelClick(Sender: TObject);
var nStr: string;
begin
  if ListRule.ItemIndex < 0 then
  begin
    ListRule.SetFocus;
    ShowMsg('��ѡ��Ҫɾ���ļ�¼', sHint); Exit;
  end;

  nStr := ListRule.Items[ListRule.ItemIndex];
  nStr := Copy(nStr, 1, Pos(ListRule.Delimiter, nStr) - 1);

  if IsNumber(nStr, False) then
  begin
    nStr := 'Delete From %s Where R_ID=' + nStr;
    nStr := Format(nStr, [sTable_JiFenRule]);
    FDM.ExecuteSQL(nStr);

    ListRule.DeleteSelected;
    ShowMsg('�����ɹ�', sHint);
  end else ShowMsg('�ü�¼����Ч', sHint);
end;

initialization
  gControlManager.RegCtrl(TfFormJiFenRule, TfFormJiFenRule.FormID);
end.
