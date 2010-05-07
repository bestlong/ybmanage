{*******************************************************************************
  作者: dmzn@163.com 2009-6-15
  描述: 积分管理
*******************************************************************************}
unit UFormJiFen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxGraphics,
  cxImage, cxDropDownEdit, cxCalendar, cxTextEdit, cxContainer, cxEdit,
  cxMaskEdit, cxButtonEdit, cxMemo, cxPC, cxMCListBox, cxLabel;

type
  TfFormJIFen = class(TfFormNormal)
    EditMoney: TcxTextEdit;
    dxLayout1Item12: TdxLayoutItem;
    EditSP: TcxComboBox;
    dxLayout1Item17: TdxLayoutItem;
    cxLabel1: TcxLabel;
    dxLayout1Item3: TdxLayoutItem;
    dxLayout1Group2: TdxLayoutGroup;
    EditMRS: TcxComboBox;
    dxLayout1Item4: TdxLayoutItem;
    EditFirm: TcxComboBox;
    dxLayout1Item5: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditMRSPropertiesChange(Sender: TObject);
  protected
    { Protected declarations }
    FRecordID: string;
    //记录编号
    FMoney,FJiFen: Double;
    //积分规则
    procedure InitFormData(const nID: string);
    //载入数据
    function GetJFRule: Boolean;
    //获取规则
    function MakeSQL: string;
    //构建语句
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, UFormCtrl, UMgrControl, UFormBase,
  USysDB, USysGrid, USysConst, UDataModule;

var
  gForm: TfFormJIFen = nil;

//------------------------------------------------------------------------------
//Desc: 数据还原窗体
class function TfFormJIFen.CreateForm;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit; 

  case nP.FCommand of
   cCmd_AddData:
    with TfFormJIFen.Create(Application) do
    begin
      FRecordID := '';
      Caption := '消费明细 - 添加';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormJIFen.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := '消费明细 - 修改';

      InitFormData(FRecordID);
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormJIFen.Create(Application);
        gForm.Caption := '消费明细 - 查看';
        gForm.BtnOK.Visible := False;
        gForm.EditMRS.Properties.ReadOnly := True;
      end;

      with gForm do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);
        if not gForm.Showing then gForm.Show;
      end;
    end;
  end;
end;

class function TfFormJIFen.FormID: integer;
begin
  Result := cFI_FormJiFen;
end;

//------------------------------------------------------------------------------
procedure TfFormJIFen.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormJIFen.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  gForm := nil;
  Action := caFree;
  ReleaseCtrlData(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormJIFen.InitFormData(const nID: string);
var nStr: string;
begin
  FMoney := 0;
  FJiFen := 0;

  if EditMRS.Properties.Items.Count < 1 then
  begin
    nStr := 'B_ID=Select B_ID,B_Name From %s Order By B_ID';
    nStr := Format(nStr, [sTable_Beautician]);

    FDM.FillStringsData(EditMRS.Properties.Items, nStr);
    AdjustStringsItem(EditMRS.Properties.Items, False);
  end;

  if EditFirm.Properties.Items.Count < 1 then
  begin
    nStr := 'M_ID=Select M_ID,M_Name From %s Order By M_ID';
    nStr := Format(nStr, [sTable_Member]);

    FDM.FillStringsData(EditFirm.Properties.Items, nStr);
    AdjustCXComboBoxItem(EditFirm, False);
  end;

  if EditSP.Properties.Items.Count < 1 then
  begin
    nStr := 'Select a.P_Name,b.P_Name From %s a, %s b ' +
            'Where a.P_Plant=b.P_ID';
    nStr := Format(nStr, [sTable_Product, sTable_Plant]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      First;

      while not Eof do
      begin
        nStr := Fields[1].AsString + ' - ' + Fields[0].AsString;
        EditSP.Properties.Items.Add(nStr);
        Next;
      end;
    end;
  end;

  if nID <> '' then
  begin
    nStr := 'Select * From %s Where F_ID=%s';
    nStr := Format(nStr, [sTable_JiFen, nID]);

    with FDM.QueryTemp(nStr) do
    if RecordCount > 0 then
    begin
      EditSP.Text := FieldByName('F_Product').AsString;
      EditMoney.Text := FieldByName('F_Money').AsString;

      FMoney := FieldByName('F_Rule').AsFloat;
      FJiFen := FieldByName('F_JiFen').AsFloat;
      FJiFen := FJiFen /Trunc(FieldByName('F_Money').AsFloat / FMoney);

      nStr := FieldByName('F_MID').AsString;
      SetCtrlData(EditFirm, nStr);
    end else ShowMsg('无效的消费记录', sHint);
  end;
end;

//Desc: 调整美容师
procedure TfFormJIFen.EditMRSPropertiesChange(Sender: TObject);
var nStr,nSQL: string;
begin
  nStr := GetCtrlData(EditMRS);
  if nStr = '' then Exit;

  nSQL := 'M_ID=Select M_ID,M_Name From %s Where M_Beautician=''%s'' ' +
          'Order By M_ID';
  nSQL := Format(nSQL, [sTable_Member, nStr]);

  AdjustCXComboBoxItem(EditFirm, True);
  FDM.FillStringsData(EditFirm.Properties.Items, nSQL);
  AdjustCXComboBoxItem(EditFirm, False);
end;

//Desc: 获取当前的积分规则
function TfFormJIFen.GetJFRule: Boolean;
var nStr: string;
begin
  if FMoney > 0 then
  begin
    Result := True; Exit;
  end;

  Result := False;
  nStr := 'Select Top 1 * From ' + sTable_JiFenRule;

  with FDM.QueryTemp(nStr) do
  if RecordCount > 0 then
  begin
    FMoney := FieldByName('R_Money').AsFloat;
    FJiFen := FieldByName('R_JiFen').AsFloat;
    Result := True; Exit;
  end;

  nStr := '该金额没有对应的积分标准,操作失败!!' + #13#10 +
          '请联系管理员添加相应标准.';
  ShowDlg(nStr, sHint, Handle);
end;

//Desc: 依据条件构建SQL语句
function TfFormJIFen.MakeSQL: string;
var nJF: Double;
    nStr: string;
begin
  nStr := GetCtrlData(EditFirm);
  nJF := Trunc(StrToFloat(EditMoney.Text) / FMoney) * FJiFen;

  if FRecordID = '' then
  begin
    Result := 'Insert Into $TJF(F_MID,F_Product,F_Money,F_Rule,F_JiFen,F_Date) ' +
          'Values(''$ID'',''$Pro'', $Money, $Rule, $JF, ''$Date'')';
    Result := MacroValue(Result, [MI('$TJF', sTable_JiFen), MI('$ID', nStr),
            MI('$Pro', EditSP.Text), MI('$Money', EditMoney.Text),
            MI('$Rule', FloatToStr(FMoney)), MI('$JF', FloatToStr(nJF)),
            MI('$Date', DateTime2Str(Now))]);
  end else
  begin
    Result := 'Update %s Set F_MID=''%s'',F_Product=''%s'',F_Money=%s,' +
              'F_JiFen=%s Where F_ID=%s';
    Result := Format(Result, [sTable_JiFen, nStr, EditSP.Text, EditMoney.Text,
              FloatToStr(nJF), FRecordID]);
  end;
end;

//Desc: 保存
procedure TfFormJIFen.BtnOKClick(Sender: TObject);
begin
  EditSP.Text := Trim(EditSP.Text);
  if EditSP.Text = '' then
  begin
    EditSP.SetFocus;
    ShowMsg('请填写商品名称', sHint); Exit;
  end;

  if not IsNumber(EditMoney.Text, True) then
  begin
    EditMoney.SetFocus;
    ShowMsg('请填写有效的金额', sHint); Exit;
  end;

  if EditFirm.ItemIndex < 0 then
  begin
    EditFirm.SetFocus;
    ShowMsg('请选择有效的会员', sHint); Exit;
  end;

  if GetJFRule then
  begin
    FDM.ExecuteSQL(MakeSQL);
    ShowMsg('保存成功', sHint);
    ModalResult := mrOk;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormJIFen, TfFormJIFen.FormID);
end.
