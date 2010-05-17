{*******************************************************************************
  ����: dmzn@163.com 2010-5-14
  ����: Ƥ��ͼ��
*******************************************************************************}
unit UFormTuPu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxGraphics,
  cxImage, cxDropDownEdit, cxCalendar, cxTextEdit, cxContainer, cxEdit,
  cxMaskEdit, cxButtonEdit, cxMemo, cxPC, cxMCListBox, cxListBox, Menus,
  cxCheckListBox, ImgList;

type
  TfFormTuPu = class(TfFormNormal)
    EditLevelA: TcxTextEdit;
    dxLayout1Item6: TdxLayoutItem;
    EditLevelB: TcxTextEdit;
    dxLayout1Item7: TdxLayoutItem;
    EditMemo: TcxMemo;
    dxLayout1Item15: TdxLayoutItem;
    dxLayout1Group3: TdxLayoutGroup;
    dxGroup2: TdxLayoutGroup;
    PMenu1: TPopupMenu;
    ListFile: TcxCheckListBox;
    dxLayout1Item4: TdxLayoutItem;
    EditFile: TcxButtonEdit;
    dxLayout1Item3: TdxLayoutItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnOKClick(Sender: TObject);
    procedure EditFilePropertiesButtonClick(Sender: TObject;
      AButtonIndex: Integer);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
  protected
    { Protected declarations }
    FRecordID: string;
    //��¼���
    procedure InitFormData(const nID: string);
    //��������
    function OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean; override;
    //��֤����
  public
    { Public declarations }
    class function CreateForm(const nPopedom: string = '';
      const nParam: Pointer = nil): TWinControl; override;
    class function FormID: integer; override;
  end;

implementation

{$R *.dfm}
uses
  jpeg, cxLookAndFeelPainters, ULibFun, UAdjustForm, UFormCtrl, UMgrControl,
   UFormBase, USysDB, USysConst, UDataModule, UFormWait;

//------------------------------------------------------------------------------
//Desc: ���ݻ�ԭ����
class function TfFormTuPu.CreateForm;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit; 

  case nP.FCommand of
   cCmd_AddData:
    with TfFormTuPu.Create(Application) do
    begin
      FRecordID := '';
      Caption := 'ͼ�� - ���';

      InitFormData('');
      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
   cCmd_EditData:
    with TfFormTuPu.Create(Application) do
    begin
      FRecordID := nP.FParamA;
      Caption := 'ͼ�� - �޸�';

      EditFile.Enabled := False;
      InitFormData(FRecordID);             

      nP.FCommand := cCmd_ModalResult;
      nP.FParamA := ShowModal;
      Free;
    end;
  end;
end;

class function TfFormTuPu.FormID: integer;
begin
  Result := cFI_FormTuPu;
end;

//------------------------------------------------------------------------------
procedure TfFormTuPu.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
  ResetHintAllForm(Self, 'T', sTable_TuPu);
end;

procedure TfFormTuPu.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
end;

//------------------------------------------------------------------------------
procedure TfFormTuPu.InitFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where T_ID=%s';
    nStr := Format(nStr, [sTable_TuPu, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);
  end;
end;

//Desc: ����ļ�
procedure TfFormTuPu.EditFilePropertiesButtonClick(Sender: TObject;
  AButtonIndex: Integer);
var i,nLen: Integer;
begin
  with TOpenDialog.Create(Self) do
  begin
    Title := 'ͼ���ļ�';
    Filter := '֧�ָ�ʽ(bmp,jpg)|*.bmp;*.jpg';
    Options := Options + [ofAllowMultiSelect];

    if Execute then
    begin
      nLen := Files.Count - 1;
      for i:=0 to nLen do
      with ListFile.Items.Add do
      begin
        Text := Files[i];
        State := cbsChecked;
      end;
    end;

    EditFile.Text := Format('�����[ %d ]���ļ�', [Files.Count]);
    Free;
  end;
end;

//Desc: ѡ��
procedure TfFormTuPu.N2Click(Sender: TObject);
var i,nCount: Integer;
    nStatus: TcxCheckBoxState;
begin
  case TComponent(Sender).Tag of
    10: nStatus := cbsChecked;
    20: nStatus := cbsUnchecked else nStatus := cbsGrayed;
  end;

  nCount := ListFile.Items.Count - 1;
  for i:=0 to nCount do
    ListFile.Items[i].State := nStatus;
  //xxxxx
end;

//Desc: ɾ��
procedure TfFormTuPu.N5Click(Sender: TObject);
var nIdx: Integer;
begin
  if TComponent(Sender).Tag = 20 then
  begin
    if ListFile.ItemIndex > -1 then
      ListFile.Items.Delete(ListFile.ItemIndex);
    Exit;
  end; //ɾ����ǰѡ��

  for nIdx:=ListFile.Items.Count - 1 downto 0 do
   if ListFile.Items[nIdx].State = cbsChecked then
    ListFile.Items.Delete(nIdx);
  //xxxxx
end;

//------------------------------------------------------------------------------
function TfFormTuPu.OnVerifyCtrl(Sender: TObject; var nHint: string): Boolean;
begin
  Result := True;

  if Sender = EditLevelA then
  begin
    Result := Trim(EditLevelA.Text) <> '';
    nHint := '����д��Ч������';
  end else

  if Sender = ListFile then
  begin
    if FRecordID = '' then
      Result := ListFile.Items.Count > 0;
    nHint := '�����ͼ���ļ�';
  end;
end;

//Desc: ����
procedure TfFormTuPu.BtnOKClick(Sender: TObject);
var nStr,nSQL: string;
    i,nLen: Integer;
    nBig,nSmall: TPicture;
begin
  if not IsDataValid then Exit;
  if FRecordID <> '' then
  begin
    nStr := 'T_ID=' + FRecordID;
    nStr := MakeSQLByStr([Format('T_LevelA=''%s''', [EditLevelA.Text]),
            Format('T_PYA=''%s''', [GetPinYinOfStr(EditLevelA.Text)]),
            Format('T_LevelB=''%s''', [EditLevelB.Text]),
            Format('T_PYB=''%s''', [GetPinYinOfStr(EditLevelB.Text)]),
            Format('T_Memo=''%s''', [EditMemo.Text])], sTable_TuPu, nStr, False);
    //xxxxx

    FDM.ExecuteSQL(nStr);
    ModalResult := mrOk; Exit;
  end;

  nBig := nil;
  nSmall := nil;
  FDM.ADOConn.BeginTrans;
  ShowWaitForm(Self, 'ͼ�ױ�����');
  try
    nSQL := MakeSQLByStr([Format('T_LevelA=''%s''', [EditLevelA.Text]),
            Format('T_PYA=''%s''', [GetPinYinOfStr(EditLevelA.Text)]),
            Format('T_LevelB=''%s''', [EditLevelB.Text]),
            Format('T_PYB=''%s''', [GetPinYinOfStr(EditLevelB.Text)]),
            Format('T_Memo=''%s''', [EditMemo.Text]),
            Format('T_Man=''%s''', [gSysParam.FUserID]),
            Format('T_Date=%s', [FDM.SQLServerNow])], sTable_TuPu, '', True);
    //xxxxx
              
    nSmall := TPicture.Create;
    nSmall.Bitmap.Width := 150;
    nSmall.Bitmap.Height := 150;

    nBig := TPicture.Create;
    nLen := ListFile.Items.Count - 1;
    
    for i:=0 to nLen do
    begin
      FDM.ExecuteSQL(nSQL);
      nStr := 'Select Top 1 * From %s Order By T_ID DESC';
      nStr := Format(nStr, [sTable_TuPu]);
      FDM.QueryTemp(nStr);

      nBig.LoadFromFile(ListFile.Items[i].Text);
      FDM.SaveDBImage(FDM.SqlTemp, 'T_TuPu', nBig.Graphic);

      nSmall.Bitmap.Canvas.StretchDraw(Rect(0, 0, 150, 150), nBig.Graphic);
      FDM.SaveDBImage(FDM.SqlTemp, 'T_Small', nSmall.Graphic);
    end;

    FDM.ADOConn.CommitTrans;
    FreeAndNil(nBig);
    FreeAndNil(nSmall);

    CloseWaitForm;
    ModalResult := mrOk;
    ShowMsg('ͼ���ѳɹ�����', sHint);
  except
    FDM.ADOConn.RollbackTrans;
    if Assigned(nBig) then nBig.Free;
    if Assigned(nSmall) then nSmall.Free;
    
    CloseWaitForm;
    ShowMsg('��������ʧ��', sError);
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTuPu, TfFormTuPu.FormID);
end.
