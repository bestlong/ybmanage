{*******************************************************************************
  ����: dmzn@163.com 2009-7-1
  ����: �鿴ͼƬ
*******************************************************************************}
unit UFormViewImage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UBgFormBase, UTransPanel, ExtCtrls;

type
  TfFormViewImage = class(TfBgFormBase)
    ImageView1: TImage;
    procedure ImageView1DblClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

procedure ShowViewImageForm(const nImg: TGraphic; const nRect: TRect);
//��ں���

implementation

{$R *.dfm}

//Date: 2009-7-1
//Parm: ͼ��;��ʾ����
//Desc: ��nRect����ʾnImg���������
procedure ShowViewImageForm(const nImg: TGraphic; const nRect: TRect);
begin
  if Assigned(nImg) then
  with TfFormViewImage.Create(Application) do
  begin
    ClientPanel1.Width := nImg.Width;
    ClientPanel1.Height := nImg.Height;
    ImageView1.Picture.Graphic := nImg;

    Width := ClientPanel1.Left + ClientPanel1.Width + FValidRect.Right;
    Height := ClientPanel1.Top + ClientPanel1.Height + FValidRect.Bottom;

    Position := poDesigned;
    Left := nRect.Left + Round((nRect.Right - nRect.Left - Width) /2 );
    Top := nRect.Top + Round((nRect.Bottom - nRect.Top - Height) /2 );

    ShowModal;
    Free;
  end;
end;

procedure TfFormViewImage.ImageView1DblClick(Sender: TObject);
begin
  inherited;
  CloseForm;
end;

end.
