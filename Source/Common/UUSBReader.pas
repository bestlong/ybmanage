{*******************************************************************************
  作者: dmzn@163.com 2009-11-3
  描述: 枚举USB设备信息
*******************************************************************************}
unit UUSBReader;

interface

uses
 Windows, Classes, SysUtils, UUSBLib;

function IsValidCamera: Boolean;
procedure EnumUSBDevices(var nUSBNodes: TUSBNodes);
//入口函数

implementation

var
  gIsValidCamera: Boolean = False;

//Desc: 摄像头有效
function IsValidCamera: Boolean;
var nStr: string;
    nIdx: integer;
    nUSB: TUSBNodes;
begin
  Result := gIsValidCamera;
  if Result then Exit;

  EnumUSBDevices(nUSB);
  for nIdx:=Low(nUSB) to High(nUSB) do
  begin
    Result := nUSB[nIdx].USBDevice.ProductID = 13344;
    if not Result then Continue;

    Result := nUSB[nIdx].USBDevice.VendorID = 2760;
    if not Result then Continue;

    nStr := nUSB[nIdx].USBDevice.Product;
    nStr := LowerCase(nStr);
    Result := Pos('venus', nStr) > 0;

    if Result then
    begin
      gIsValidCamera := True; Break;
    end;
  end;
end;

//Desc: 由nName中截取nLen长度的字符串
function UnicodeStr(const nName: TUnicodeName; const nLen: integer): string;
var nIdx: integer;
begin
  Result := '';

  for nIdx:=0 to nLen - 1 do
  if nName[nIdx] <> #0 then
       Result := Result + nName[nIdx]
  else Break;
end;

//Desc: 获取nDevice的指定信息
function GetDeviceName(nDevice: THandle; nIOCTL_Code: Cardinal): string; overload;
var nNum: Cardinal;
    nBuf: THCDDriverKeyName;
begin
  if DeviceIoControl(nDevice, nIOCTL_Code, @nBuf, SizeOf(nBuf), @nBuf,
     SizeOf(nBuf), nNum, nil) then
  begin
    Result := UnicodeStr(nBuf.UnicodeName, nBuf.Length);
  end else
  begin
    Result := SysErrorMessage(GetLastError);
    Result := Format('Error: %s (%d)', [Result, GetLastError]);
  end;
end;

//Desc: 获取nDevice.nPIndx的指定信息
function GetDeviceName(nDevice: THandle; nPIndex: Cardinal;
  nIOCTL_Code: Cardinal): string; overload;
var nNum: Cardinal;
    nBuf: TNodeConnectionDriveKeyName;
begin
  nBuf.ConnectionIndex := nPIndex;
  if DeviceIoControl(nDevice, nIOCTL_Code, @nBuf, SizeOf(nBuf), @nBuf,
     SizeOf(nBuf), nNum, nil) then
  begin
    Result := UnicodeStr(nBuf.UnicodeName, nBuf.Length);
  end else
  begin
    Result := SysErrorMessage(GetLastError);
    Result := Format('Error: %s (%d)', [Result, GetLastError]);
  end;
end;

//Desc: 获取nDevice的节点信息
function GetNodeInformation(nDevice: THandle; var nInfo: TNodeInformation): Integer;
var nNum: Cardinal;
begin
  if DeviceIoControl(nDevice, IOCTL_USB_GET_NODE_INFORMATION, nil, 0,
     @nInfo, SizeOf(nInfo), nNum, nil) and (nNum<=256) then
       Result:=0
  else Result:=GetLastError;
end;

//Desc: 获取nDevice.nPIndex的节点信息
function GetNodeConnection(nDevice: THandle; nPIndex: Cardinal;
 var nInfo: TNodeConnectionInformation): Integer;
var nNum: Cardinal;
begin
  FillChar(nInfo, SizeOf(nInfo), #0);
  nInfo.ConnectionIndex := nPIndex;

  if DeviceIoControl(nDevice, IOCTL_USB_GET_NODE_CONNECTION_INFORMATION,
     @nInfo, SizeOf(nInfo), @nInfo, SizeOf(nInfo), nNum, nil) and
     (nNum <= 256) then
       Result := 0
  else Result:=GetLastError;
end;

function GetConfigurationDescriptor(nHubHandle: THandle; nPIndex: Cardinal;
 var nMaxPower: WORD; var nClassID: integer): Integer;
var nNum: Cardinal;
    nLowByte: Byte;
    nBufferPtr: Byte;
    nPacket: TDescriptorRequest;
begin
  Result := 0;
  nClassID := -1;
  nMaxPower := 0;

  with nPacket do begin
    ConnectionIndex := nPIndex;
    SetupPacket.bmRequest := $80;
    SetupPacket.bRequest := USB_REQUEST_GET_DESCRIPTOR;
    SetupPacket.wValue[0] := 0;
    SetupPacket.wValue[1] := USB_CONFIGURATION_DESCRIPTOR_TYPE;
    SetupPacket.wIndex[0] := 0;
    SetupPacket.wIndex[1] := 0;
    SetupPacket.wLength[0] := 18;
  end;

  if not DeviceIoControl(nHubHandle, IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,
     @nPacket, SizeOf(nPacket), @nPacket, SizeOf(nPacket), nNum, nil) then
  begin
    Result := GetLastError; Exit;
  end;

  with nPacket do begin
    ConnectionIndex := nPIndex;
    SetupPacket.bmRequest := $80;
    SetupPacket.bRequest := USB_REQUEST_GET_DESCRIPTOR;
    SetupPacket.wValue[0] := 0;
    SetupPacket.wValue[1] := USB_CONFIGURATION_DESCRIPTOR_TYPE;
    SetupPacket.wIndex[0] := 0;
    SetupPacket.wIndex[1] := 0;
    SetupPacket.wLength[0] := nPacket.ConfigurationDescriptor[2];
    SetupPacket.wLength[1] := nPacket.ConfigurationDescriptor[3];
  end;

  if not DeviceIoControl(nHubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,
     @nPacket, SizeOf(nPacket), @nPacket, SizeOf(nPacket), nNum, nil) then
  begin
    Result := GetLastError; Exit;
  end;

  nBufferPtr := 9;
  nMaxPower := nPacket.ConfigurationDescriptor[8]*2;
  
  while nPacket.ConfigurationDescriptor[nBufferPtr] <> 0 do
  begin
    if nPacket.ConfigurationDescriptor[nBufferPtr+1]=4 then
    begin
      nLowByte := nPacket.ConfigurationDescriptor[nBufferPtr+5];
      if ((nLowByte > 9) and (nLowByte < 255)) then nLowByte := 11;
      if nLowByte = 255 then nLowByte := 10;
      nClassID := nLowByte; Break;
    end;
    Inc(nBufferPtr,9);
  end;
end;

function GetStringDescriptor(HubHandle: THandle; PortIndex: Cardinal;
 var LanguageID: Word; Index: Byte; var Str: shortstring): integer;
var
  Packet: TDescriptorRequest;
  BytesReturned: Cardinal;
  Success: boolean;
begin
  Str:='';
  Result:=0;
  FillChar(Packet,SizeOf(Packet),0);

  if (LanguageID=0) then
  begin
    Packet.ConnectionIndex:=PortIndex;
    Packet.SetupPacket.bmRequest:=$80;
    Packet.SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
    Packet.SetupPacket.wValue[1]:=USB_STRING_DESCRIPTOR_TYPE;
    Packet.SetupPacket.wLength[0]:=8;
    Success:=DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,@Packet,
             sizeof(Packet),@Packet,sizeof(Packet),BytesReturned,nil);
    if not Success then
      Result:=GetLastError;
    LanguageID:=Packet.ConfigurationDescriptor[2]+(Packet.ConfigurationDescriptor[3] shl 8);
  end;

  Packet.ConnectionIndex:=PortIndex;
  Packet.SetupPacket.bmRequest:=$80;
  Packet.SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
  Packet.SetupPacket.wValue[1]:=USB_STRING_DESCRIPTOR_TYPE;
  Packet.SetupPacket.wValue[0]:=Index;
  Packet.SetupPacket.wIndex[0]:=LanguageID and $FF;
  Packet.SetupPacket.wIndex[1]:=(LanguageID shr 8) and $FF;
  Packet.SetupPacket.wLength[0]:=255;

  if not DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,@Packet,
           sizeof(Packet),@Packet,sizeof(Packet),BytesReturned,nil) then
  begin
    Result := GetLastError; Exit;
  end;

  FillChar(Packet,SizeOf(Packet),0);
  Packet.ConnectionIndex:=PortIndex;
  Packet.SetupPacket.bmRequest:=$80;
  Packet.SetupPacket.bRequest:=USB_REQUEST_GET_DESCRIPTOR;
  Packet.SetupPacket.wValue[1]:=USB_STRING_DESCRIPTOR_TYPE;
  Packet.SetupPacket.wValue[0]:=Index;
  Packet.SetupPacket.wIndex[0]:=LanguageID and $FF;
  Packet.SetupPacket.wIndex[1]:=(LanguageID shr 8) and $FF;
  Packet.SetupPacket.wLength[0]:=255;

  if DeviceIoControl(HubHandle,IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION,@Packet,
           sizeof(Packet),@Packet,sizeof(Packet),BytesReturned,nil) then
  begin
    Str:=WideCharToString(PWideChar(@Packet.ConfigurationDescriptor[2]));
  end else Result := GetLastError;
end;

//Desc: 获取指定端口的信息
function GetPortData(nRH: THandle; nSA: TSecurityAttributes; nPCount: Byte;
  nPIndex: integer; nLevel: Integer; var nUSBNodes: TUSBNodes): Integer;
var nERH: THandle;
    nLangID: Word;
    nIdx: integer;
    nNode: TUSBNode;
    nStr,nRootHubName: string;
    nNInfo: TNodeInformation;
    nCInfo: TNodeConnectionInformation;
begin
  nLangID := 0;

  for nIdx:=1 to nPCount do
  if GetNodeConnection(nRH, nIdx, nCInfo) = ERROR_SUCCESS then
  begin
    if nCInfo.ThisConnectionStatus[0] <> 1 then
    begin
      FillChar(nNode, SizeOf(nNode), #0);
      nNode.ParentIndex := nPIndex;
      nNode.Level := nLevel;
      nNode.USBDevice.Port := nIdx;
      nNode.USBDevice.DeviceAddress := nCInfo.DeviceAddress[0];
      nNode.USBDevice.ConnectionStatus := nCInfo.ThisConnectionStatus[0];

      SetLength(nUSBNodes, Length(nUSBNodes) + 1);
      nUSBNodes[High(nUSBNodes)] := nNode; Continue;
    end;

    nERH := INVALID_HANDLE_VALUE;
    if Boolean(nCInfo.DeviceIsHub) then
    try
      nRootHubName := GetDeviceName(nRH, nIdx, IOCTL_USB_GET_NODE_CONNECTION_NAME);
      nStr := Format('\\%s\%s', [cMachine, nRootHubName]);

      nERH := CreateFile(PChar(nStr), GENERIC_WRITE, FILE_SHARE_WRITE,
                  @nSA, OPEN_EXISTING, 0, 0);
      //xxxxx

      if nERH = INVALID_HANDLE_VALUE then Continue;
      if GetNodeInformation(nRH, nNInfo) <> ERROR_SUCCESS then Continue;

      FillChar(nNode, SizeOf(nNode), #0);
      nNode.ConnectionName := nRootHubName;
      nNode.USBClass := usbExternalHub;
      nNode.ParentIndex := nPIndex;
      nNode.Level := nLevel;
      nNode.USBDevice.Port := nIdx;
      nNode.USBDevice.DeviceAddress := nCInfo.DeviceAddress[0];
      nNode.USBDevice.ConnectionStatus := nCInfo.ThisConnectionStatus[0];

      SetLength(nUSBNodes, Length(nUSBNodes) + 1);
      nUSBNodes[High(nUSBNodes)] := nNode;

      GetPortData(nERH, nSA, nNInfo.NodeDescriptor.PortCount, High(nUSBNodes),
                  nLevel + 1, nUSBNodes);
      Continue;
    finally
      if nERH <> INVALID_HANDLE_VALUE then CloseHandle(nERH);
    end;

    //--------------------------------------------------------------------------
    if (nCInfo.ThisDevice.ProductID = 0) or
       (nCInfo.ThisDevice.VendorID = 0) then Continue;
    //invalid device

    FillChar(nNode, SizeOf(nNode), #0);
    nNode.Keyname := GetDeviceName(nRH, nIdx, IOCTL_USB_GET_NODE_CONNECTION_DRIVERKEY_NAME);
    nNode.ParentIndex := nPIndex;
    nNode.Level := nLevel;

    with nNode.USBDevice do
    begin
      Port := nIdx;
      DeviceAddress := nCInfo.DeviceAddress[0];
      ConnectionStatus := nCInfo.ThisConnectionStatus[0];

      ProductID := nCInfo.ThisDevice.ProductID;
      VendorID := nCInfo.ThisDevice.VendorID;
      MajorVersion := nCInfo.ThisDevice.USBSpec[1];
      MinorVersion := nCInfo.ThisDevice.USBSpec[0];
    end;

    //i := Integer(usbError);
    //GetConfigurationDescriptor(nRH, nIdx, nNode.USBDevice.MaxPower, i);

    if GetStringDescriptor(nRH, nIdx, nLangID, nCInfo.ThisDevice.ProductStringIndex,
      nNode.USBDevice.Product) = 0 then ;
    {
     if GetStringDescriptor(nRH, nIdx, nLangID, nCInfo.ThisDevice.ManufacturerStringIndex,
       nNode.USBDevice.Manufacturer) = 0 then
      GetStringDescriptor(nRH, nIdx, nLangID, nCInfo.ThisDevice.SerialNumberStringIndex,
        nNode.USBDevice.Serial);  

    if i in [Integer(usbReserved)..Integer(usbVendorSpec)] then
      nNode.USBClass := TUSBClass(i)
    else nNode.USBClass := usbError;
    }
    SetLength(nUSBNodes, Length(nUSBNodes) + 1);
    nUSBNodes[High(nUSBNodes)] := nNode;
  end;

  Result := nLevel - 1;
end;

//Desc: 枚举USB节点信息,存入nUSBNodes中
procedure EnumUSBDevices(var nUSBNodes: TUSBNodes);
var nStr: string;
    nIdx: integer;
    nNode: TUSBNode;
    nHCD,nRH: THandle;
    nInfo: TNodeInformation;
    nSA: TSecurityAttributes;
    nRootHubName,nHCDName: ShortString;
begin
  with nSA do
  begin
    nLength:=sizeof(SECURITY_ATTRIBUTES);
    lpSecurityDescriptor:=nil;
    bInheritHandle:=false;
  end;

  SetLength(nUSBNodes, 0);
  nRH := INVALID_HANDLE_VALUE;
  nHCD := INVALID_HANDLE_VALUE;

  for nIdx:=0 to 9 do
  try
    nHCDName := Format('HCD%d', [nIdx]);
    nStr := Format('\\%s\%s', [cMachine, nHCDName]);

    nHCD:=CreateFile(PChar(nStr), GENERIC_WRITE, FILE_SHARE_WRITE,
                     @nSA, OPEN_EXISTING, 0, 0);
    if nHCD = INVALID_HANDLE_VALUE then Continue;

    FillChar(nNode, SizeOf(nNode), #0);
    nNode.ConnectionName := nHCDName;
    nNode.Keyname := GetDeviceName(nHCD, IOCTL_GET_HCD_DRIVERKEY_NAME);
    nNode.USBClass := usbHostController;

    nNode.ParentIndex := -1;
    nNode.Level := 0;
    nNode.USBDevice.Port := nIdx;
    nNode.USBDevice.ConnectionStatus := 1;

    SetLength(nUSBNodes, Length(nUSBNodes) + 1);
    nUSBNodes[High(nUSBNodes)] := nNode;

    //--------------------------------------------------------------------------
    nRootHubName := GetDeviceName(nHCD, IOCTL_USB_GET_NODE_INFORMATION);
    nStr := Format('\\%s\%s', [cMachine, nRootHubName]);

    nRH := CreateFile(PChar(nStr), GENERIC_WRITE, FILE_SHARE_WRITE,
                     @nSA, OPEN_EXISTING, 0, 0);
    //xxxxx
    
    if nRH = INVALID_HANDLE_VALUE then Continue;
    if GetNodeInformation(nRH, nInfo) <> ERROR_SUCCESS then Continue;

    FillChar(nNode, SizeOf(nNode), #0);
    nNode.ConnectionName := nRootHubName;
    nNode.Keyname := '';
    nNode.USBClass := usbHub;

    nNode.ParentIndex := High(nUSBNodes);
    nNode.Level := 1;
    nNode.USBDevice.Port := nIdx;
    nNode.USBDevice.ConnectionStatus := 1;

    SetLength(nUSBNodes, Length(nUSBNodes) + 1);
    nUSBNodes[High(nUSBNodes)] := nNode;

    GetPortData(nRH, nSA, nInfo.NodeDescriptor.PortCount, High(nUSBNodes), 2,
                nUSBNodes);
    //xxxxx
  finally
    if nRH <> INVALID_HANDLE_VALUE then
      CloseHandle(nRH);
    nRH := INVALID_HANDLE_VALUE;

    if nHCD <> INVALID_HANDLE_VALUE then
      CloseHandle(nHCD);
    nHCD := INVALID_HANDLE_VALUE
  end;
end;

end.
