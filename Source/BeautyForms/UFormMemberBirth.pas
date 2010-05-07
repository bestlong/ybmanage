{*******************************************************************************
  作者: dmzn@163.com 2009-6-28
  描述: 生日会员列表
*******************************************************************************}
unit UFormMemberBirth;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UDataModule, UBgFormBase, cxControls, cxContainer, cxMCListBox, StdCtrls,
  UTransPanel;

type
  TfFormMemberBirth = class(TfBgFormBase)
    BtnExit: TButton;
    ListUser1: TcxMCListBox;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BtnExitClick(Sender: TObject);
  private
    { Private declarations }
    procedure InitFormData;
  public
    { Public declarations }
  end;

function ShowBirthMemberForm(const nRect: TRect): TForm;
//入口函数

implementation

{$R *.dfm}

uses
  ULibFun, USysGrid, USysDB, USysConst, USysGobal;

var
  gForm: TForm = nil;

//------------------------------------------------------------------------------
//Desc: 生日会员
function ShowBirthMemberForm(const nRect: TRect): TForm;
begin
  if not Assigned(gForm) then
    gForm := TfFormMemberBirth.Create(gForm);
  Result := gForm;
  
  with TfFormMemberBirth(Result) do
  begin
    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    InitFormData;    
    if not Showing then Show;
  end;
end;

procedure TfFormMemberBirth.FormCreate(Sender: TObject);
begin
  inherited;
  LoadMCListBoxConfig(Name, ListUser1);
end;

procedure TfFormMemberBirth.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  inherited; 
  if Action = caFree then
  begin
    SaveMCListBoxConfig(Name, ListUser1);
    gForm := nil;
    if Assigned(gOnCloseActiveForm) then gOnCloseActiveForm(Self);
  end;
end;

procedure TfFormMemberBirth.BtnExitClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

//------------------------------------------------------------------------------
procedure TfFormMemberBirth.InitFormData;
var nStr,nTmp: string;
begin
  nTmp := 'Select M_ID,M_Name,M_Sex,M_BirthDay From %s Where M_BirthDay Like ''%%%s''';
  nStr := Date2Str(Date); System.Delete(nStr, 1, 4);
  nTmp := Format(nTmp, [sTable_Member, nStr]);

  ListUser1.Clear;
  with FDM.QueryTemp(nTmp) do
   if RecordCount > 0 then
   begin
     First;

     While not Eof do
     begin
       if Fields[2].AsString = sFlag_Man then
            nTmp := '♂、男士'
       else nTmp := '♀、女士';

       nStr := Fields[0].AsString + ListUser1.Delimiter +
               Fields[1].AsString + ListUser1.Delimiter +
               nTmp + ListUser1.Delimiter + Fields[3].AsString;

       ListUser1.Items.Add(nStr);
       Next;
     end;
   end;
end;

end.
