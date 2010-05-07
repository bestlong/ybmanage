{*******************************************************************************
  作者: dmzn@163.com 2009-6-27
  描述: 带背景窗体
*******************************************************************************}
unit UBgFormBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  UImageControl, UTransPanel;

type
  TfBgFormBase = class(TForm)
    ClientPanel1: TZnTransPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  protected
    FValidRect: TRect;
    FCanClose: Boolean;
  public
    procedure CloseForm(const nRes: TModalResult = mrCancel);
    function FindBgItem(const nPos: TImageControlPosition): TImageControl;
  end;

implementation

{$R *.dfm}

procedure TfBgFormBase.FormCreate(Sender: TObject);
var nP: PImageItemData;
begin
  FCanClose := False;
  DoubleBuffered := True;

  if WindowState = wsMaximized then
  begin
    with TImageControl.Create(Self) do
    begin
      Parent := Self;
      Align := alTop;
      Position := cpTop;
    end;

    with TImageControl.Create(Self) do
    begin
      Parent := Self;
      Align := alBottom;
      Position := cpBottom;
    end;

    with TImageControl.Create(Self) do
    begin
      Parent := Self;
      Align := alLeft;
      Position := cpLeft;
    end;

    with TImageControl.Create(Self) do
    begin
      Parent := Self;
      Align := alRight;
      Position := cpRight;
    end;

    with TImageControl.Create(Self) do
    begin
      Parent := Self;
      Align := alClient;
      Position := cpClient;
      nP := GetItemData(0);
    end;
  end else
  begin
    with TImageControl.Create(Self) do
    begin
      Parent := Self;
      Align := alClient;
      Position := cpForm;
      nP := GetItemData(0);
    end;
  end;

  ClientPanel1.BringToFront;
  FValidRect := Rect(0, 0, 0, 0);
  
  if not Assigned(nP) then Exit;
  FValidRect := nP.FCtrlRect;

  ClientPanel1.Align := alNone;
  ClientPanel1.Left := FValidRect.Left;
  ClientPanel1.Top := FValidRect.Top;

  if WindowState = wsMaximized then
  begin
    ClientPanel1.Width := Screen.Width - FValidRect.Left - FValidRect.Right;
    ClientPanel1.Height := Screen.Height - FValidRect.Top - FValidRect.Bottom;
  end else
  begin
    Self.Width := ClientPanel1.Left + ClientPanel1.Width + FValidRect.Right;
    Self.Height := ClientPanel1.Top + ClientPanel1.Height + FValidRect.Bottom;
  end;
end;

procedure TfBgFormBase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  if FCanClose or (ModalResult <> mrNone) then
       Action := caFree
  else Action := caNone;
end;

//Desc: 关闭窗口
procedure TfBgFormBase.CloseForm(const nRes: TModalResult);
begin
  if fsModal in FFormState then
  begin
    ModalResult := nRes;
  end else
  begin
    FCanClose := True; Close;
  end;
end;

procedure TfBgFormBase.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
  begin
    Key := 0; Close;
  end;
end;

function TfBgFormBase.FindBgItem(const nPos: TImageControlPosition): TImageControl;
var i,nCount: integer;
begin
  Result := nil;
  nCount := ControlCount - 1;

  for i:=0 to nCount do
  if (Controls[i] is TImageControl) and
     (TImageControl(Controls[i]).Position = nPos) then
  begin
    Result := TImageControl(Controls[i]); Break;
  end;
end;

end.
