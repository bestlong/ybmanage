{*******************************************************************************
  作者: dmzn@163.com 2009-11-3
  描述: USB头文件
*******************************************************************************}
unit UUSBLib;

interface

const
  cMachine = '.';
  
const
  USB_SUBMIT_URB                    = 0;
  USB_RESET_PORT                    = 1;
  USB_GET_ROOTHUB_PDO               = 3;
  USB_GET_PORT_STATUS               = 4;
  USB_ENABLE_PORT                   = 5;
  USB_GET_HUB_COUNT                 = 6;
  USB_CYCLE_PORT                    = 7;
  USB_GET_HUB_NAME                  = 8;
  USB_IDLE_NOTIFICATION             = 9;
  USB_GET_BUS_INFO                  = 264;
  USB_GET_CONTROLLER_NAME           = 265;
  USB_GET_BUSGUID_INFO              = 266;
  USB_GET_PARENT_HUB_INFO           = 267;
  USB_GET_DEVICE_HANDLE             = 268;

  HCD_GET_STATS_1                   = 255;
  HCD_DIAGNOSTIC_MODE_ON            = 256; 
  HCD_DIAGNOSTIC_MODE_OFF           = 257; 
  HCD_GET_ROOT_HUB_NAME             = 258; 
  HCD_GET_DRIVERKEY_NAME            = 265; 
  HCD_GET_STATS_2                   = 266; 
  HCD_DISABLE_PORT                  = 268; 
  HCD_ENABLE_PORT                   = 269; 
  HCD_USER_REQUEST                  = 270; 
 
  USB_GET_NODE_INFORMATION                = 258; 
  USB_GET_NODE_CONNECTION_INFORMATION     = 259; 
  USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION = 260; 
  USB_GET_NODE_CONNECTION_NAME            = 261; 
  USB_DIAG_IGNORE_HUBS_ON                 = 262; 
  USB_DIAG_IGNORE_HUBS_OFF                = 263; 
  USB_GET_NODE_CONNECTION_DRIVERKEY_NAME  = 264; 
  USB_GET_HUB_CAPABILITIES                = 271; 
  USB_GET_NODE_CONNECTION_ATTRIBUTES      = 272; 
 
  METHOD_BUFFERED      = 0; 
  METHOD_IN_DIRECT     = 1; {+} 
  METHOD_OUT_DIRECT    = 2; {+} 
  METHOD_NEITHER       = 3; 
 
  FILE_ANY_ACCESS      =  0;
  FILE_SPECIAL_ACCESS  = (FILE_ANY_ACCESS); {+}
  FILE_READ_ACCESS     = ( $0001 );    // file & pipe {+}
  FILE_WRITE_ACCESS    = ( $0002 );    // file & pipe {+} 
 
  FILE_DEVICE_UNKNOWN  = $00000022; 
  FILE_DEVICE_USB      = FILE_DEVICE_UNKNOWN; 
 
  USB_CTL_BASE         = (FILE_DEVICE_USB shl 16) or (FILE_ANY_ACCESS shl 14); 
  USB_CTL_CONST        = USB_CTL_BASE or METHOD_BUFFERED; 
  USB_KERNEL_CTL_CONST = USB_CTL_BASE or METHOD_NEITHER;

  IOCTL_USB_DIAG_IGNORE_HUBS_ON          = USB_CTL_CONST or (USB_DIAG_IGNORE_HUBS_ON shl 2); 
  IOCTL_USB_DIAG_IGNORE_HUBS_OFF         = USB_CTL_CONST or (USB_DIAG_IGNORE_HUBS_OFF shl 2); 
  IOCTL_USB_DIAGNOSTIC_MODE_OFF          = USB_CTL_CONST or (HCD_DIAGNOSTIC_MODE_OFF shl 2); 
  IOCTL_USB_DIAGNOSTIC_MODE_ON           = USB_CTL_CONST or (HCD_DIAGNOSTIC_MODE_ON shl 2); 
  IOCTL_USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION = USB_CTL_CONST or (USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION shl 2); 
  IOCTL_USB_GET_HUB_CAPABILITIES         = USB_CTL_CONST or (USB_GET_HUB_CAPABILITIES shl 2); 
  IOCTL_USB_GET_ROOT_HUB_NAME            = USB_CTL_CONST or (HCD_GET_ROOT_HUB_NAME shl 2); 
  IOCTL_GET_HCD_DRIVERKEY_NAME           = USB_CTL_CONST or (HCD_GET_DRIVERKEY_NAME shl 2); 
  IOCTL_USB_GET_NODE_INFORMATION         = USB_CTL_CONST or (USB_GET_NODE_INFORMATION shl 2);
  IOCTL_USB_GET_NODE_CONNECTION_INFORMATION = USB_CTL_CONST or (USB_GET_NODE_CONNECTION_INFORMATION shl 2);
  IOCTL_USB_GET_NODE_CONNECTION_ATTRIBUTES  = USB_CTL_CONST or (USB_GET_NODE_CONNECTION_ATTRIBUTES shl 2);
  IOCTL_USB_GET_NODE_CONNECTION_NAME     = USB_CTL_CONST or (USB_GET_NODE_CONNECTION_NAME shl 2); 
  IOCTL_USB_GET_NODE_CONNECTION_DRIVERKEY_NAME = USB_CTL_CONST or (USB_GET_NODE_CONNECTION_DRIVERKEY_NAME shl 2); 
  IOCTL_USB_HCD_DISABLE_PORT             = USB_CTL_CONST or (HCD_DISABLE_PORT shl 2); 
  IOCTL_USB_HCD_ENABLE_PORT              = USB_CTL_CONST or (HCD_ENABLE_PORT shl 2); 
  IOCTL_USB_HCD_GET_STATS_1              = USB_CTL_CONST or (HCD_GET_STATS_1 shl 2); 
  IOCTL_USB_HCD_GET_STATS_2              = USB_CTL_CONST or (HCD_GET_STATS_2 shl 2); 

const
  MAXIMUM_USB_STRING_LENGTH                  = 255;
 
  USB_DEVICE_CLASS_RESERVED                  = $00;
  USB_DEVICE_CLASS_AUDIO                     = $01; 
  USB_DEVICE_CLASS_COMMUNICATIONS            = $02; 
  USB_DEVICE_CLASS_HUMAN_INTERFACE           = $03; 
  USB_DEVICE_CLASS_MONITOR                   = $04; 
  USB_DEVICE_CLASS_PHYSICAL_INTERFACE        = $05; 
  USB_DEVICE_CLASS_POWER                     = $06; 
  USB_DEVICE_CLASS_PRINTER                   = $07; 
  USB_DEVICE_CLASS_STORAGE                   = $08; 
  USB_DEVICE_CLASS_HUB                       = $09; 
  USB_DEVICE_CLASS_VENDOR_SPECIFIC           = $FF; 
 
  USB_RESERVED_DESCRIPTOR_TYPE               = $06; 
  USB_CONFIG_POWER_DESCRIPTOR_TYPE           = $07; 
  USB_INTERFACE_POWER_DESCRIPTOR_TYPE        = $08; 
 
  USB_REQUEST_GET_STATUS                     = $00; 
  USB_REQUEST_CLEAR_FEATURE                  = $01; 
  USB_REQUEST_SET_FEATURE                    = $03; 
  USB_REQUEST_SET_ADDRESS                    = $05; 
  USB_REQUEST_GET_DESCRIPTOR                 = $06; 
  USB_REQUEST_SET_DESCRIPTOR                 = $07; 
  USB_REQUEST_GET_CONFIGURATION              = $08; 
  USB_REQUEST_SET_CONFIGURATION              = $09; 
  USB_REQUEST_GET_INTERFACE                  = $0A; 
  USB_REQUEST_SET_INTERFACE                  = $0B; 
  USB_REQUEST_SYNC_FRAME                     = $0C;

  USB_GETSTATUS_SELF_POWERED                 = $01; 
  USB_GETSTATUS_REMOTE_WAKEUP_ENABLED        = $02;
 
  BMREQUEST_HOST_TO_DEVICE                   = 0; 
  BMREQUEST_DEVICE_TO_HOST                   = 1; 
 
  BMREQUEST_STANDARD                         = 0;
  BMREQUEST_CLASS                            = 1;
  BMREQUEST_VENDOR                           = 2;

  BMREQUEST_TO_DEVICE                        = 0;
  BMREQUEST_TO_INTERFACE                     = 1;
  BMREQUEST_TO_ENDPOINT                      = 2;
  BMREQUEST_TO_OTHER                         = 3;

  // USB_COMMON_DESCRIPTOR.bDescriptorType constants
  USB_DEVICE_DESCRIPTOR_TYPE                 = $01;
  USB_CONFIGURATION_DESCRIPTOR_TYPE          = $02;
  USB_STRING_DESCRIPTOR_TYPE                 = $03;
  USB_INTERFACE_DESCRIPTOR_TYPE              = $04;
  USB_ENDPOINT_DESCRIPTOR_TYPE               = $05;

type
  TUnicodeName = array[0..MAXIMUM_USB_STRING_LENGTH] of WideChar;
  
  THCDDriverKeyName = record
    Length: Cardinal;
    UnicodeName: TUnicodeName;
  end;

  TNodeConnectionDriveKeyName = record
    ConnectionIndex: Cardinal;
    Length: Cardinal;
    UnicodeName: TUnicodeName;
  end;

  THubDescriptor = record
    Length: Byte;
    HubType: Byte;
    PortCount: Byte;
    Characteristics: array[0..1] of Byte;
    PowerOnToPowerGood: Byte;
    HubControlCurrent: Byte;
    RemoveAndPowerMask: array[0..63] of Byte;
  end;

  TEndPointDescriptor = record
    Length: Byte;
    DescriptorType: Byte;
    EndpointAddress: Byte;
    Attributes: Byte;
    MaxPacketSize: WORD;
    PollingInterval: Byte;
  end;

  TNodeInformation = record
    NodeType: Cardinal;
    NodeDescriptor: THubDescriptor;
    HubIsBusPowered: Byte;
  end;

  TDeviceDescriptor = record
    Length: Byte;
    DescriptorType: Byte;
    USBSpec: array[0..1] of Byte;
    DeviceClass: Byte;
    DeviceSubClass: Byte;
    DeviceProtocol: Byte;
    MaxPacketSize0: Byte;
    VendorID: Word;//array[0..1] of Byte;
    ProductID: Word; //array[0..1] of Byte;
    DeviceRevision: array[0..1] of byte;
    ManufacturerStringIndex: byte;
    ProductStringIndex: Byte;
    SerialNumberStringIndex: Byte;
    ConfigurationCount: Byte;
  end;
  
  TUSBPipeInfo = record
    EndPointDescriptor: TEndpointDescriptor;
    ScheduleOffset: Cardinal;
  end;

  TNodeConnectionInformation = record
    ConnectionIndex: Cardinal;
    ThisDevice: TDeviceDescriptor;
    CurrentConfiguration: Byte;
    LowSpeed: Byte;
    DeviceIsHub: Byte;
    DeviceAddress: array[0..1] of Byte;
    NumberOfOpenEndPoints: array[0..3] of Byte;
    ThisConnectionStatus: array[0..3] of Byte;
    PipeList: array[0..31] of TUSBPipeInfo;
  end;

  TSetupPacket = record
    bmRequest: Byte;
    bRequest: Byte;
    wValue: array[0..1] of Byte;
    wIndex: array[0..1] of Byte;
    wLength: array[0..1] of Byte;
  end;

  TDescriptorRequest = record
    ConnectionIndex: Cardinal;
    SetupPacket: TSetupPacket;
    ConfigurationDescriptor: array[0..2047] of Byte;
  end;
  
type
  TUSBClass = (usbReserved, usbAudio, usbCommunications, usbHID, usbMonitor,
               usbPhysicalIntf, usbPower, usbPrinter, usbStorage, usbHub,
               usbVendorSpec, // illegal values
               usbExternalHub, usbHostController, usbUnknown, usbError);

  TRegistryRecord = record
    Name,
    USBClass,
    DeviceClass: shortstring;
    IntfGUID: shortstring;
    Drive: shortstring;
    Timestamp: TDateTime;
  end;

  TRegistrySet = array of TRegistryRecord;
  
  TUSBDevice = record
    Port: Cardinal;
    DeviceAddress: Cardinal;
    Manufacturer,
    Product,
    Serial: Shortstring;
    ConnectionStatus: Byte;
    MaxPower: WORD;
    MajorVersion,
    MinorVersion: Byte;
    ProductID,
    VendorID: Word;
    USBClassname: string;
    Registry: TRegistrySet;
  end;

  TUSBNode = record
    ConnectionName: Shortstring;
    Keyname: ShortString;
    USBClass: TUSBClass;
    ParentIndex: Integer;
    Level: Integer;
    TimeStamp: TDateTime;
    USBDevice: TUSBDevice;
  end;

  TUSBNodes = array of TUSBNode;

implementation

end.
