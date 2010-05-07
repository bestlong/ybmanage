{*******************************************************************************
  作者: dmzn@163.com 2009-7-7
  描述: 图片筛选窗
*******************************************************************************}
unit UFormImageFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, UTransPanel, cxGraphics, cxDropDownEdit,
  cxCalendar, StdCtrls, cxTextEdit, cxMaskEdit, cxControls, cxContainer,
  cxEdit, cxCheckBox, ExtCtrls;

type
  TfFormImageFilter = class(TfBgFormBase)
    Check1: TcxCheckBox;
    Check2: TcxCheckBox;
    EditPart: TcxComboBox;
    Label1: TLabel;
    EditStart: TcxDateEdit;
    EditEnd: TcxDateEdit;
    Label2: TLabel;
    Label3: TLabel;
    BtnOK: TButton;
    BtnExit: TButton;
    Bevel1: TBevel;
    procedure BtnExitClick(Sender: TObject);
    procedure BtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    procedure LoadFilter(var nWhere,nHint: string);
  public
    { Public declarations }
  end;

function ShowImageFilterForm(var nWhere,nHint: string): Boolean;
//入口函数

implementation

{$R *.dfm}
uses
  IniFiles, ULibFun, UAdjustForm, USysDB, USysConst;

//Desc: 显示过滤窗口
function ShowImageFilterForm(var nWhere,nHint: string): Boolean;
begin
  with TfFormImageFilter.Create(Application) do
  begin
    Result := ShowModal = mrOk;
    if Result then
      LoadFilter(nWhere, nHint);    
    AdjustCXComboBoxItem(EditPart, True);
    Free;
  end;
end;

procedure TfFormImageFilter.FormCreate(Sender: TObject);
var nStr: string;
    nIni: TIniFile;
begin
  inherited;
  EditStart.Date := Date;
  EditEnd.Date := Date;

  nStr := 'B_ID=Select B_ID,B_Text From %s Where B_Group=''%s''';
  nStr := Format(nStr, [sTable_BaseInfo, sFlag_SkinPart]);

  FDM.FillStringsData(EditPart.Properties.Items, nStr, 1, '、');
  AdjustCXComboBoxItem(EditPart, False);

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    Check1.Checked := nIni.ReadBool(Name, 'CheckPart', False);
    Check2.Checked := nIni.ReadBool(Name, 'CheckDate', True);

    EditPart.ItemIndex := nIni.ReadInteger(Name, 'PartIndex', -1);
    nStr := nIni.ReadString(Name, 'DateStart', '');
    EditStart.Date := Str2Date(nStr);

    nStr := nIni.ReadString(Name, 'DateEnd', '');
    EditEnd.Date := Str2Date(nStr);
  finally
    nIni.Free;
  end;
end;

procedure TfFormImageFilter.FormClose(Sender: TObject;
  var Action: TCloseAction);
var nIni: TIniFile;
begin
  inherited;
  if Action <> caFree then Exit;

  nIni := TIniFile.Create(gPath + sFormConfig);
  try
    nIni.WriteBool(Name, 'CheckPart', Check1.Checked);
    nIni.WriteBool(Name, 'CheckDate', Check2.Checked);
    nIni.WriteInteger(Name, 'PartIndex', EditPart.ItemIndex);
    nIni.WriteString(Name, 'DateStart', Date2Str(EditStart.Date));
    nIni.WriteString(Name, 'DateEnd', Date2Str(EditEnd.Date));
  finally
    nIni.Free;
  end;
end;

//Desc: 退出
procedure TfFormImageFilter.BtnExitClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfFormImageFilter.BtnOKClick(Sender: TObject);
begin
  if not (Check1.Checked or Check2.Checked) then
  begin
    FDM.ShowMsg('请选择筛选条件', sHint); Exit;
  end;

  if Check1.Checked and (EditPart.ItemIndex < 0) then
  begin
    EditPart.SetFocus;
    FDM.ShowMsg('请选择有效的部位名称', sHint); Exit;
  end;

  if Check2.Checked and (EditEnd.Date < EditStart.Date) then
  begin
    EditEnd.SetFocus;
    FDM.ShowMsg('结束日期不能小于开始日期', sHint); Exit;
  end;

  ModalResult := mrOk;
end;

procedure TfFormImageFilter.LoadFilter(var nWhere, nHint: string);
var nStr: string;
begin
  if Check1.Checked and Check2.Checked then
    nHint := '部位 + 日期' else
  if Check1.Checked then
    nHint := EditPart.Text else
  if Check2.Checked then
    nHint := Date2Str(EditStart.Date) + ' / ' + Date2Str(EditEnd.Date);

  nWhere := '';
  if Check1.Checked then
  begin
    nWhere := 'P_Part=' + GetCtrlData(EditPart);
  end;

  if Check2.Checked then
  begin
    if nWhere <> '' then
      nWhere := nWhere + ' And ';
    //xxxxx

    if gSysDBType = dtAccess then
         nStr := 'P_Date>=#%s# And P_Date<#%s#'
    else nStr := 'P_Date>=''%s'' And P_Date<''%s''';

    nStr := Format(nStr, [Date2Str(EditStart.Date), Date2Str(EditEnd.Date + 1)]);
    nWhere := nWhere + nStr;
  end;
end;

end.
