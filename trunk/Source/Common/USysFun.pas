{*******************************************************************************
  ����: dmzn@163.com 2007-10-09
  ����: ��Ŀͨ�ú������嵥Ԫ
*******************************************************************************}
unit USysFun;

interface

uses
  Windows, Classes, ComCtrls, Forms, SysUtils, ULibFun, USysConst, IniFiles;

procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
//��״̬����ʾ��Ϣ

procedure InitSystemEnvironment;
//��ʼ��ϵͳ���л����ı���
procedure LoadSysParameter(const nIni: TIniFile = nil);
//����ϵͳ���ò���
function MakeFrameName(const nFrameID: integer): string;
//����Frame����
function RandomItemID(const nPrefix: string; nIDLen: Integer): string;
//������

procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
//�����б��ͷ���
function MakeListViewColumnInfo(const nLv: TListView): string;
//����б��ͷ�����Ϣ
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
//���ѡ�е��������

implementation

//---------------------------------- �������л��� ------------------------------
//Date: 2007-01-09
//Desc: ��ʼ�����л���
procedure InitSystemEnvironment;
begin
  Randomize;
  ShortDateFormat := 'YYYY-MM-DD';
  gPath := ExtractFilePath(Application.ExeName);
end;

//Date: 2007-09-13
//Desc: ����ϵͳ���ò���
procedure LoadSysParameter(const nIni: TIniFile = nil);
var nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sConfigFile);

  try
    with gSysParam, nTmp do
    begin
      FProgID := ReadString(sConfigSec, 'ProgID', sProgID);
      //�����ʶ�����������в���
      FAppTitle := ReadString(FProgID, 'AppTitle', sAppTitle);
      FMainTitle := ReadString(FProgID, 'MainTitle', sMainCaption);
      FHintText := ReadString(FProgID, 'HintText', '');
      FCopyRight := ReadString(FProgID, 'CopyRight', '');
      FRecMenuMax := ReadInteger(FProgID, 'MaxRecent', cRecMenuMax);

      FIconFile := ReadString(FProgID, 'IconFile', gPath + 'Icons\Icon.ini');
      FIconFile := StringReplace(FIconFile, '$Path\', gPath, [rfIgnoreCase]);
    end;
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Desc: ����FrameID���������
function MakeFrameName(const nFrameID: integer): string;
begin
  Result := 'Frame' + IntToStr(nFrameID);
end;

//Desc: ����ǰ׺ΪnPrefix,����ΪnIDLen��������
function RandomItemID(const nPrefix: string; nIDLen: Integer): string;
var nStr,nChar: string;
    nIdx,nMid: integer;
begin
  nStr := FloatToStr(Now);
  nMid := Round(Length(nStr) / 2);

  for nIdx:=1 to nMid do
  begin
    nChar := nStr[nIdx];
    nStr[nIdx] := nStr[2 * nMid - nIdx];
    nStr[2 * nMid - nIdx] := nChar[1];
  end;

  Result := nPrefix + Copy(nStr, 1, nIDLen - Length(nPrefix));
end;

//------------------------------------------------------------------------------
//Desc: ��ȫ��״̬�����һ��Panel����ʾnMsg��Ϣ
procedure ShowMsgOnLastPanelOfStatusBar(const nMsg: string);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > 0) then
  begin
    gStatusBar.Panels[gStatusBar.Panels.Count - 1].Text := nMsg;
    Application.ProcessMessages;
  end;
end;

//Desc: ������nIdx��Panel����ʾnMsg��Ϣ
procedure StatusBarMsg(const nMsg: string; const nIdx: integer);
begin
  if Assigned(gStatusBar) and (gStatusBar.Panels.Count > nIdx) and
     (nIdx > -1) then
  begin
    gStatusBar.Panels[nIdx].Text := nMsg;
    gStatusBar.Panels[nIdx].Width := gStatusBar.Canvas.TextWidth(nMsg) + 20;
    Application.ProcessMessages;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2007-11-30
//Parm: �����Ϣ;�б�
//Desc: ����nList�ı�ͷ���
procedure LoadListViewColumn(const nWidths: string; const nLv: TListView);
var nList: TStrings;
    i,nCount: integer;
begin
  if nLv.Columns.Count > 0 then
  begin
    nList := TStringList.Create;
    try
      if SplitStr(nWidths, nList, nLv.Columns.Count, ';') then
      begin
        nCount := nList.Count - 1;
        for i:=0 to nCount do
         if IsNumber(nList[i], False) then
          nLv.Columns[i].Width := StrToInt(nList[i]);
      end;
    finally
      nList.Free;
    end;
  end;
end;

//Date: 2007-11-30
//Parm: �б�
//Desc: ���nLv�ı�ͷ�����Ϣ
function MakeListViewColumnInfo(const nLv: TListView): string;
var i,nCount: integer;
begin
  Result := '';
  nCount := nLv.Columns.Count - 1;

  for i:=0 to nCount do
  if i = nCount then
       Result := Result + IntToStr(nLv.Columns[i].Width)
  else Result := Result + IntToStr(nLv.Columns[i].Width) + ';';
end;

//Date: 2007-11-30
//Parm: �б�;�б�;�Ƿ�ȫ�����
//Desc: ���nLv�е���Ϣ,��䵽nList��
procedure CombinListViewData(const nList: TStrings; nLv: TListView;
 const nAll: Boolean);
var i,nCount: integer;
begin
  nList.Clear;
  nCount := nLv.Items.Count - 1;

  for i:=0 to nCount do
  if nAll or nLv.Items[i].Selected then
  begin
    nList.Add(nLv.Items[i].Caption + sLogField +
      CombinStr(nLv.Items[i].SubItems, sLogField));
    //combine items's data
  end;
end;

end.


