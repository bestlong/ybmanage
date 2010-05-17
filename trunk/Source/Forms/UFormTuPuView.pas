{*******************************************************************************
  ����: dmzn@163.com 2010-5-14
  ����: Ƥ��ͼ�ײ鿴
*******************************************************************************}
unit UFormTuPuView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UFormNormal, dxLayoutControl, StdCtrls, cxControls, cxGraphics,
  cxImage, cxDropDownEdit, cxCalendar, cxTextEdit, cxContainer, cxEdit,
  cxMaskEdit, cxButtonEdit, cxMemo, cxPC, cxMCListBox, cxListBox, Menus,
  cxCheckListBox, ImgList;

type
  TfFormTuPuView = class(TfFormNormal)
    dxGroup2: TdxLayoutGroup;
    cxImage1: TcxImage;
    dxLayout1Item4: TdxLayoutItem;
    cxTextEdit1: TcxTextEdit;
    dxLayout1Item3: TdxLayoutItem;
    cxTextEdit2: TcxTextEdit;
    dxLayout1Item5: TdxLayoutItem;
    cxMemo1: TcxMemo;
    dxLayout1Item6: TdxLayoutItem;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    { Protected declarations }
    FRecordID: string;
    //��¼���
    procedure InitFormData(const nID: string);
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
  jpeg, ULibFun, UMgrControl, UFormBase, USysDB, USysConst, UDataModule,
  UFormCtrl;

var
  gForm: TfFormTuPuView = nil;
  //ȫ��ʹ��
  
//------------------------------------------------------------------------------
//Desc: ���ݻ�ԭ����
class function TfFormTuPuView.CreateForm;
var nP: PFormCommandParam;
begin
  Result := nil;
  if Assigned(nParam) then
       nP := nParam
  else Exit; 

  case nP.FCommand of
   cCmd_ViewData:
    begin
      if not Assigned(gForm) then
      begin
        gForm := TfFormTuPuView.Create(Application);
        gForm.Caption := 'ͼ�� - �鿴';
        gForm.FormStyle := fsStayOnTop;
      end;

      with gForm do
      begin
        FRecordID := nP.FParamA;
        InitFormData(FRecordID);

        if Showing then
             BringToFront
        else Show;
      end;
    end;
   cCmd_FormClose:
    begin
      FreeAndNil(gForm);
    end;
  end;
end;

class function TfFormTuPuView.FormID: integer;
begin
  Result := cFI_FormTuPuView;
end;

//------------------------------------------------------------------------------
procedure TfFormTuPuView.FormCreate(Sender: TObject);
begin
  LoadFormConfig(Self);
end;

procedure TfFormTuPuView.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  SaveFormConfig(Self);
  gForm := nil;
  Action := caFree;
end;

//------------------------------------------------------------------------------
procedure TfFormTuPuView.InitFormData(const nID: string);
var nStr: string;
begin
  if nID <> '' then
  begin
    nStr := 'Select * From %s Where T_ID=%s';
    nStr := Format(nStr, [sTable_TuPu, nID]);
    LoadDataToCtrl(FDM.QueryTemp(nStr), Self);

    if FDM.SqlTemp.RecordCount > 0 then
    begin
      FDM.LoadDBImage(FDM.SqlTemp, 'T_Small', cxImage1.Picture);
    end;
  end;
end;

initialization
  gControlManager.RegCtrl(TfFormTuPuView, TfFormTuPuView.FormID);
end.
