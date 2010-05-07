{*******************************************************************************
  ����: dmzn@163.com 2009-6-25
  ����: �����屳��
*******************************************************************************}
unit UImageControl;

interface

uses
  Windows, Classes, Controls, Graphics, SysUtils;

type
  TImageControlPosition = (cpTop, cpLeft, cpRight, cpBottom, cpClient, cpForm);
  //����λ��

  TImageItemStyle = (isTile, isRTile, isStretch);
  //���÷��

  PImageItemData = ^TImageItemData;
  TImageItemData = record
    FSize: Integer;               //�� or ��
    FRect: TRect;                 //��������
    FCtrlRect: TRect;             //�ؼ�����
    
    FAlign: TAlign;               //������ʽ
    FPicture: TPicture;           //ͼƬ����
    FStyle: TImageItemStyle;      //���÷��
  end;

  TImageControl = class(TGraphicControl)
  private
    FImages: TList;
    {*ͼƬ*}
    FFormName: string;
    {*���ڴ���*}
    FPosition: TImageControlPosition;
    {*λ��*}
    FClientBmp: TBitmap;
    {*�ͻ���*}
  protected
    procedure ClearImageList(const nFree: Boolean);
    {*������Դ*}
    procedure SetPosition(AValue: TImageControlPosition);
    {*����λ��*}
    procedure AdjustImageRect;
    procedure PaintToCanvas(const nCanvas: TCanvas);
    procedure Paint; override;
    {*��������*}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*�����ͷ�*}
    function GetItemData(const nIdx: Integer): PImageItemData;
    {*��ȡ����*}
    property FormName: string read FFormName write FFormName;
    property Position: TImageControlPosition read FPosition write SetPosition;
    {*�������*}
  end; 

implementation

uses
  IniFiles, ULibFun, USysConst;

ResourceString
  sConfigFile      = 'BeautyConfig.Ini';  //�����ļ�
  sClientWidth     = 'Image_Width';       //�����
  sClientHeight    = 'Image_Height';      //�����

  sImageNumber     = 'Image_Number';      //ͼƬ����
  sImageFile       = 'Image_File_';       //ͼƬ�ļ�

  sImageWidth      = 'Image_Width_';      //ͼƬ��
  sImageHeight     = 'Image_Height_';     //ͼƬ��

  sImageStyle      = 'Image_Style_';      //���÷��
  sImageTile       = 'Tile';              //ƽ��
  sImageRTile      = 'RTile';             //��ƽ��
  sImageStretch    = 'Stretch';           //����

  sImageAlphaColor = 'Image_Alpha_Color'; //͸��ɫ
  sImageAlphaFile  = 'Image_Alpha_File';  //͸���ļ�

  sImageAlign      = 'Image_Align_';      //����
  sImageLeft       = 'Left';              //����
  sImageRight      = 'Right';             //����
  sImageTop        = 'Top';               //����
  sImageBottom     = 'Bottom';            //����
  sImageClient     = 'Client';            //�ͻ���

  sBgTop           = 'BgTop';             //��
  sBgBottom        = 'BgBottom';          //��
  sBgLeft          = 'BgLeft';            //��
  sBgRight         = 'BgRight';           //��
  sBgClient        = 'BgClient';          //�м�
  sBgForm          = 'BgForm';            //����
  sValidRect       = 'RectValid';         //��Ч����

//------------------------------------------------------------------------------
constructor TImageControl.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FClientBmp := nil;
  FImages := TList.Create;
  FFormName := AOwner.Name;
end;

destructor TImageControl.Destroy;
begin
  if Assigned(FClientBmp) then
    FClientBmp.Free;
  ClearImageList(True);
  inherited;
end;

//Desc: ����ͼƬ�б�
procedure TImageControl.ClearImageList(const nFree: Boolean);
var nIdx: integer;
    nP: PImageItemData;
begin
  for nIdx:=FImages.Count - 1 downto 0 do
  begin
    nP := FImages[nIdx];
    if Assigned(nP.FPicture) then FreeAndNil(nP.FPicture);

    Dispose(nP);
    FImages.Delete(nIdx);
  end;

  if nFree then FreeAndNil(FImages);
end;

//Desc: ��ȡ����ΪnIdx��ͼƬ����
function TImageControl.GetItemData(const nIdx: Integer): PImageItemData;
begin
  if (nIdx > -1) and (nIdx < FImages.Count) then
    Result := FImages[nIdx]
  else if (FImages.Count > 0) then
       Result := FImages[0]
  else Result := nil;
end;

//Desc: �ַ�ת����
function StrToAlign(const nStr: string): TAlign;
begin
  if CompareText(nStr, sImageLeft) = 0 then
    Result := alLeft
  else if CompareText(nStr, sImageRight) = 0 then
    Result := alRight
  else if CompareText(nStr, sImageTop) = 0 then
    Result := alTop
  else if CompareText(nStr, sImageBottom) = 0 then
    Result := alBottom
  else if CompareText(nStr, sImageClient) = 0 then
       Result := alClient
  else Result := alLeft;
end;

//Desc: ͼƬ��ʽ���
function Str2ImageStyle(const nStyle: string): TImageItemStyle;
begin
  if CompareText(nStyle, sImageTile) = 0 then
    Result := isTile else
  if CompareText(nStyle, sImageRTile) = 0 then
       Result := isRTile
  else Result := isStretch;
end;

//Desc: ���뱳������
procedure TImageControl.SetPosition(AValue: TImageControlPosition);
var nIni: TIniFile;
    nP: PImageItemData;
    nIdx,nCount: Integer;
    nStr,nTmp,nSection: string;
begin
  FPosition := AValue;
  nIni := nil;
  try
    ClearImageList(False);
    FreeAndNil(FClientBmp);
    nIni := TIniFile.Create(gPath + sConfigFile);

    case AValue of
      cpTop,cpBottom: //��,��
       begin
         if AValue = cpTop then
              nSection := sBgTop
         else nSection := sBgBottom;

         nStr := nSection + '_' + FFormName;
         if nIni.ReadString(nStr, sImageStyle + '1', '') <> '' then
           nSection := nStr;
         //xxxxx

         Height := nIni.ReadInteger(nSection, sClientHeight, 20);
         nCount := nIni.ReadInteger(nSection, sImageNumber, 0);

         for nIdx:=1 to nCount do
         begin
           New(nP);
           FImages.Add(nP);
           FillChar(nP^, SizeOf(TImageItemData), #0);

           nP.FSize := nIni.ReadInteger(nSection, sImageWidth + IntToStr(nIdx), 0);
           nStr := nIni.ReadString(nSection, sImageAlign + IntToStr(nIdx), '');
           nP.FAlign := StrToAlign(nStr);

           nStr := nIni.ReadString(nSection, sImageStyle + IntToStr(nIdx), '');
           nP.FStyle := Str2ImageStyle(nStr);

           nStr := nIni.ReadString(nSection, sImageFile + IntToStr(nIdx), '');
           nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);
           if FileExists(nStr) then
           begin
             nP.FPicture := TPicture.Create;
             nP.FPicture.LoadFromFile(nStr);
           end else nP.FPicture := nil;
         end;
       end;
      cpLeft,cpRight: //��,��
       begin
         if AValue = cpLeft then
              nSection := sBgLeft
         else nSection := sBgRight;

         nStr := nSection + '_' + FFormName;
         if nIni.ReadString(nStr, sImageStyle + '1', '') <> '' then
           nSection := nStr;
         //xxxxx

         Width := nIni.ReadInteger(nSection, sClientWidth, 20);
         nCount := nIni.ReadInteger(nSection, sImageNumber, 0);

         for nIdx:=1 to nCount do
         begin
           New(nP);
           FImages.Add(nP);
           FillChar(nP^, SizeOf(TImageItemData), #0);

           nP.FSize := nIni.ReadInteger(nSection, sImageHeight + IntToStr(nIdx), 0);
           nStr := nIni.ReadString(nSection, sImageAlign + IntToStr(nIdx), '');
           nP.FAlign := StrToAlign(nStr);

           nStr := nIni.ReadString(nSection, sImageStyle + IntToStr(nIdx), '');
           nP.FStyle := Str2ImageStyle(nStr);

           nStr := nIni.ReadString(nSection, sImageFile + IntToStr(nIdx), '');
           nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);
           if FileExists(nStr) then
           begin
             nP.FPicture := TPicture.Create;
             nP.FPicture.LoadFromFile(nStr);
           end else nP.FPicture := nil;
         end;
       end;
      cpClient,cpForm: //�ͻ���,����
       begin
         if AValue = cpForm then
         begin
           if nIni.ReadString(FFormName, sImageStyle + '1', '') = '' then
                nSection := sBgForm
           else nSection := FFormName;
         end else
         begin
           nSection := sBgClient;

           nStr := nSection + '_' + FFormName;
           if nIni.ReadString(nStr, sImageStyle + '1', '') <> '' then
             nSection := nStr;
           //xxxxx
         end;

         New(nP);
         FImages.Add(nP);
         FillChar(nP^, SizeOf(TImageItemData), #0);

         nStr := nIni.ReadString(nSection, sImageStyle + '1', '');
         if nStr = sImageStretch then
              nP.FStyle := isStretch
         else nP.FStyle := isTile;

         nStr := nIni.ReadString(nSection, sImageFile + '1', '');
         nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);

         if FileExists(nStr) then
         begin
           nP.FPicture := TPicture.Create;
           nP.FPicture.LoadFromFile(nStr);
         end else nP.FPicture := nil;

         nCount := 0;
         nStr := nIni.ReadString(nSection, sValidRect, '') + ',';
         nIdx := Pos(',', nStr);

         while nIdx > 1 do
         begin
           nTmp := Copy(nStr, 1, nIdx - 1);
           if not IsNumber(nTmp, False) then Break;

           case nCount of
            0: nP.FCtrlRect.Left := StrToInt(nTmp);
            1: nP.FCtrlRect.Top := StrToInt(nTmp);
            2: nP.FCtrlRect.Right := StrToInt(nTmp);
            3: nP.FCtrlRect.Bottom := StrToInt(nTmp);
           end;

           Inc(nCount);
           System.Delete(nStr, 1, nIdx);
           nIdx := Pos(',', nStr);
         end;

         nStr := nIni.ReadString(nSection, sImageAlphaFile, '');
         nStr := StringReplace(nStr, '$Path\', gPath, [rfIgnoreCase]);

         if FileExists(nStr) then
         begin
           New(nP);
           FImages.Add(nP);
           FillChar(nP^, SizeOf(TImageItemData), #0);

           nP.FPicture := TPicture.Create;
           nP.FPicture.LoadFromFile(nStr);

           nStr := nIni.ReadString(nSection, sImageAlphaColor, '');
           if IsNumber(nStr, False) then nP.FSize := TColor(StrToInt(nStr));
         end;
       end;
    end;

    FreeAndNil(nIni);
  except
    FreeAndNil(nIni);
  end;
end;

//Date: 2009-7-26
//Parm: ��ͼ;ͼƬ;͸��ɫ
//Desc: ��nBg���м�λ��,����һ��nAlpha͸����nImageͼƬ
procedure CombineAlphaImage(nBg: TBitmap; nImage: TPicture; nAlpha: Integer);
var nBmp: TBitmap;
    nX,nY: integer;
begin
  nBmp := TBitmap.Create;
  try
    nBmp.Width := nImage.Width;
    nBmp.Height := nImage.Height;

    nBmp.PixelFormat := nBg.PixelFormat;
    nBmp.Canvas.Draw(0, 0, nImage.Graphic);

    nBmp.TransparentColor := nAlpha;
    nBmp.TransparentMode := tmFixed;
    nBmp.Transparent := True;

    nX := Round((nBg.Width - nBmp.Width) / 2);
    nY := Round((nBg.Height - nBmp.Height) / 2);
    nBg.Canvas.Draw(nX, nY, nBmp);
  finally
    nBmp.Free;
  end;
end;

//Desc: ��������ͼƬ�ɻ��Ƶ�����
procedure TImageControl.AdjustImageRect;
var nP: PImageItemData;
    nIdx,nCount,nValueA,nValueB: Integer;
begin
  case FPosition of
   cpTop,cpBottom: //��,��
    begin
      nValueA := 0;
      nCount := FImages.Count - 1;

      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alLeft then Continue;

        nP.FRect := Rect(nValueA, 0, nValueA + nP.FSize, Height);
        Inc(nValueA, nP.FSize);
      end;
      //�������

      nValueB := Width;
      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alRight then Continue;

        nP.FRect := Rect(nValueB - nP.FSize, 0, nValueB, Height);
        Dec(nValueB, nP.FSize);
      end;
      //�������

      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alClient then Continue;

        nP.FRect := Rect(nValueA, 0, nValueB, Height);
        Break;
      end;
      //�ͻ���
    end;
   cpLeft,cpRight: //��,��
    begin
      nValueA := 0;
      nCount := FImages.Count - 1;

      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alTop then Continue;

        nP.FRect := Rect(0, nValueA, Width, nValueA + nP.FSize);
        Inc(nValueA, nP.FSize);
      end;
      //�������

      nValueB := Height;
      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alBottom then Continue;

        nP.FRect := Rect(0, nValueB - nP.FSize, Width, nValueB);
        Dec(nValueB, nP.FSize);
      end;
      //�������

      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alClient then Continue;

        nP.FRect := Rect(0, nValueA, Width, nValueB);
        Break;
      end;
      //�ͻ���
    end;
   cpClient,cpForm: //�ͻ���,����
    begin
      if FImages.Count > 0 then
      begin
        nP := FImages[0];
        nP.FRect := ClientRect;
      end;

      if FImages.Count = 2 then
      begin
        if not Assigned(FClientBmp) then
          FClientBmp := TBitmap.Create;
        //xxxxx
        
        if (FClientBmp.Width <> Width) or (FClientBmp.Height <> Height) then
        begin
          FClientBmp.Width := Width;
          FClientBmp.Height := Height;
          PaintToCanvas(FClientBmp.Canvas);

          nP := FImages[1];
          CombineAlphaImage(FClientBmp, nP.FPicture, nP.FSize);
        end;
      end; //��Alpha��
    end;
  end;
end;

//Desc: ��ͼƬ���Ƶ�nCanvas��
procedure TImageControl.PaintToCanvas(const nCanvas: TCanvas);
var nP: PImageItemData;
    nIdx,nCount,nValueA,nValueB: Integer;
begin
  nCount := FImages.Count - 1;
  for nIdx:=0 to nCount do
  begin
    nP := FImages[nIdx];
    if not (Assigned(nP.FPicture) and Assigned(nP.FPicture.Graphic)) then Continue;

    if nIdx > 0 then
     if (FPosition = cpClient) or (FPosition = cpForm) then Break;
    //�����ַ��ֻ��һ����Ч��ͼ,���µ�ΪAlphaͼ

    if nP.FStyle = isTile then
    begin
      nValueA := nP.FRect.Left;
      while nValueA < nP.FRect.Right do
      begin
        nValueB := nP.FRect.Top;

        while nValueB < nP.FRect.Bottom do
        begin
          nCanvas.Draw(nValueA, nValueB, nP.FPicture.Graphic);
          Inc(nValueB, nP.FPicture.Height);
        end;

        Inc(nValueA, nP.FPicture.Width);
      end;
    end else //��ƽ��

    if nP.FStyle = isRTile then
    begin
      nValueA := nP.FRect.Right;
      Dec(nValueA, nP.FPicture.Width);
      
      while nValueA > -nP.FPicture.Width do
      begin
        nValueB := nP.FRect.Top;

        while nValueB < nP.FRect.Bottom do
        begin
          nCanvas.Draw(nValueA, nValueB, nP.FPicture.Graphic);
          Inc(nValueB, nP.FPicture.Height);
        end;

        Dec(nValueA, nP.FPicture.Width);
      end;
    end else //��ƽ��

    if nP.FStyle = isStretch then
    begin
      nCanvas.StretchDraw(nP.FRect, nP.FPicture.Graphic);
    end; //��������
  end;
end;

//Desc: ����
procedure TImageControl.Paint;
begin
  AdjustImageRect;
  if Assigned(FClientBmp) then
       Canvas.StretchDraw(ClientRect, FClientBmp)
  else PaintToCanvas(Canvas);
end;

end.
