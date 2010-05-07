{*******************************************************************************
  作者: dmzn@163.com 2009-6-25
  描述: 处理窗体背景
*******************************************************************************}
unit UImageControl;

interface

uses
  Windows, Classes, Controls, Graphics, SysUtils;

type
  TImageControlPosition = (cpTop, cpLeft, cpRight, cpBottom, cpClient, cpForm);
  //背景位置

  TImageItemStyle = (isTile, isRTile, isStretch);
  //放置风格

  PImageItemData = ^TImageItemData;
  TImageItemData = record
    FSize: Integer;               //宽 or 高
    FRect: TRect;                 //绘制区域
    FCtrlRect: TRect;             //控件区域
    
    FAlign: TAlign;               //布局样式
    FPicture: TPicture;           //图片对象
    FStyle: TImageItemStyle;      //放置风格
  end;

  TImageControl = class(TGraphicControl)
  private
    FImages: TList;
    {*图片*}
    FFormName: string;
    {*所在窗体*}
    FPosition: TImageControlPosition;
    {*位置*}
    FClientBmp: TBitmap;
    {*客户区*}
  protected
    procedure ClearImageList(const nFree: Boolean);
    {*清理资源*}
    procedure SetPosition(AValue: TImageControlPosition);
    {*设置位置*}
    procedure AdjustImageRect;
    procedure PaintToCanvas(const nCanvas: TCanvas);
    procedure Paint; override;
    {*绘制内容*}
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    {*创建释放*}
    function GetItemData(const nIdx: Integer): PImageItemData;
    {*获取数据*}
    property FormName: string read FFormName write FFormName;
    property Position: TImageControlPosition read FPosition write SetPosition;
    {*属性相关*}
  end; 

implementation

uses
  IniFiles, ULibFun, USysConst;

ResourceString
  sConfigFile      = 'BeautyConfig.Ini';  //配置文件
  sClientWidth     = 'Image_Width';       //区域宽
  sClientHeight    = 'Image_Height';      //区域高

  sImageNumber     = 'Image_Number';      //图片个数
  sImageFile       = 'Image_File_';       //图片文件

  sImageWidth      = 'Image_Width_';      //图片宽
  sImageHeight     = 'Image_Height_';     //图片高

  sImageStyle      = 'Image_Style_';      //放置风格
  sImageTile       = 'Tile';              //平铺
  sImageRTile      = 'RTile';             //右平铺
  sImageStretch    = 'Stretch';           //拉伸

  sImageAlphaColor = 'Image_Alpha_Color'; //透明色
  sImageAlphaFile  = 'Image_Alpha_File';  //透明文件

  sImageAlign      = 'Image_Align_';      //布局
  sImageLeft       = 'Left';              //居左
  sImageRight      = 'Right';             //居右
  sImageTop        = 'Top';               //居上
  sImageBottom     = 'Bottom';            //居下
  sImageClient     = 'Client';            //客户区

  sBgTop           = 'BgTop';             //上
  sBgBottom        = 'BgBottom';          //下
  sBgLeft          = 'BgLeft';            //左
  sBgRight         = 'BgRight';           //右
  sBgClient        = 'BgClient';          //中间
  sBgForm          = 'BgForm';            //窗体
  sValidRect       = 'RectValid';         //有效区域

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

//Desc: 清理图片列表
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

//Desc: 获取索引为nIdx的图片数据
function TImageControl.GetItemData(const nIdx: Integer): PImageItemData;
begin
  if (nIdx > -1) and (nIdx < FImages.Count) then
    Result := FImages[nIdx]
  else if (FImages.Count > 0) then
       Result := FImages[0]
  else Result := nil;
end;

//Desc: 字符转布局
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

//Desc: 图片方式风格
function Str2ImageStyle(const nStyle: string): TImageItemStyle;
begin
  if CompareText(nStyle, sImageTile) = 0 then
    Result := isTile else
  if CompareText(nStyle, sImageRTile) = 0 then
       Result := isRTile
  else Result := isStretch;
end;

//Desc: 载入背景配置
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
      cpTop,cpBottom: //上,下
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
      cpLeft,cpRight: //左,右
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
      cpClient,cpForm: //客户区,窗体
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
//Parm: 底图;图片;透明色
//Desc: 在nBg的中间位置,绘制一个nAlpha透明的nImage图片
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

//Desc: 调整各个图片可绘制的区域
procedure TImageControl.AdjustImageRect;
var nP: PImageItemData;
    nIdx,nCount,nValueA,nValueB: Integer;
begin
  case FPosition of
   cpTop,cpBottom: //上,下
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
      //处理居左

      nValueB := Width;
      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alRight then Continue;

        nP.FRect := Rect(nValueB - nP.FSize, 0, nValueB, Height);
        Dec(nValueB, nP.FSize);
      end;
      //处理居右

      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alClient then Continue;

        nP.FRect := Rect(nValueA, 0, nValueB, Height);
        Break;
      end;
      //客户区
    end;
   cpLeft,cpRight: //左,右
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
      //处理居上

      nValueB := Height;
      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alBottom then Continue;

        nP.FRect := Rect(0, nValueB - nP.FSize, Width, nValueB);
        Dec(nValueB, nP.FSize);
      end;
      //处理居下

      for nIdx:=0 to nCount do
      begin
        nP := FImages[nIdx];
        if nP.FAlign <> alClient then Continue;

        nP.FRect := Rect(0, nValueA, Width, nValueB);
        Break;
      end;
      //客户区
    end;
   cpClient,cpForm: //客户区,窗体
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
      end; //带Alpha层
    end;
  end;
end;

//Desc: 将图片绘制到nCanvas上
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
    //这两种风格只有一张有效底图,余下的为Alpha图

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
    end else //左平铺

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
    end else //右平铺

    if nP.FStyle = isStretch then
    begin
      nCanvas.StretchDraw(nP.FRect, nP.FPicture.Graphic);
    end; //绘制拉伸
  end;
end;

//Desc: 绘制
procedure TImageControl.Paint;
begin
  AdjustImageRect;
  if Assigned(FClientBmp) then
       Canvas.StretchDraw(ClientRect, FClientBmp)
  else PaintToCanvas(Canvas);
end;

end.
