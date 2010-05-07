{*******************************************************************************
  ����: dmzn 2008-9-23
  ����: �����غ���
*******************************************************************************}
unit USysGrid;

interface

uses
  Windows, Classes, Dialogs, SysUtils, IniFiles, cxGrid, cxGridTableView,
  cxGridDBTableView, cxGridExportLink, dxPScxGrid6Lnk, cxMCListBox;

type
  TGridReportLinkData = record
    FTitle: string;     //�������
    FCaption: string;   //���������
    FCreator: string;   //��������
    FDescript: string;  //��������
  end;

procedure InitTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
procedure InitTableViewStyle(const nView: TcxGridTableView);
//��ʼ�������ͼ
procedure SaveUserDefineTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
procedure UserDefineViewWidth(const nWidth: string; const nView: TcxGridTableView);
procedure UserDefineViewIndex(const nIndex: string; const nView: TcxGridTableView);
procedure UserDefineViewVisible(const nVisible: string; const nView: TcxGridTableView);
//�û��Զ�������ͼ

function ExportGridData(const nGrid: TcxGrid): Boolean;
//��������
function GridPrintPreview(const nGrid: TcxGrid; const nTitle: string): Boolean;
//��ӡԤ��
function GridPrintData(const nGrid: TcxGrid; const nTitle: string): Boolean;
//��ӡ����

procedure LoadMCListBoxConfig(const nID: string; const nListbox: TcxMCListBox;
 const nIni: TIniFile = nil);
procedure SaveMCListBoxConfig(const nID: string; const nListbox: TcxMCListBox;
 const nIni: TIniFile = nil);
//mcListbox����

implementation

uses
   ULibFun, USysConst, USysFun, UDataModule;

//Date: 2008-9-23
//Parm: Ψһ���;����ʼ�����
//Desc: ��ʼ�����ΪnID�ı����ͼnView
procedure InitTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
var nStr: string;
    nTmp: TIniFile;
begin
  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sFormConfig);
  try
    InitTableViewStyle(nView);
    nStr := nTmp.ReadString(nID, 'GridIndex_' + nView.Name + nViewID, '');
    if nStr <> '' then UserDefineViewIndex(nStr, nView);

    nStr := nTmp.ReadString(nID, 'GridWidth_' + nView.Name + nViewID, '');
    if nStr <> '' then UserDefineViewWidth(nStr, nView);

    nStr := nTmp.ReadString(nID, 'GridVisible_' + nView.Name + nViewID, '');
    if nStr <> '' then UserDefineViewVisible(nStr, nView);
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Date: 2008-9-23
//Parm: �����ͼ
//Desc: ��ʼ��nView�ķ������
procedure InitTableViewStyle(const nView: TcxGridTableView);
begin
  nView.OptionsView.Indicator := True;
  nView.OptionsCustomize.ColumnsQuickCustomization := True;
  nView.OptionsData.Editing := False;
end;

//Date: 2008-9-23
//Parm: Ψһ���;����ʼ�����
//Desc: ��nView���û����ݱ��浽nIDС����
procedure SaveUserDefineTableView(const nID: string; const nView: TcxGridTableView;
  const nIni: TIniFile = nil; const nViewID: string = '');
var nStr: string;
    nTmp: TIniFile;
    i,nCount: integer;
begin
  nCount := nView.ColumnCount - 1;
  if nCount < 0 then Exit;

  if Assigned(nIni) then
       nTmp := nIni
  else nTmp := TIniFile.Create(gPath + sFormConfig);
  try
    nStr := '';
    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nView.Columns[i].Width);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, 'GridWidth_' + nView.Name + nViewID, nStr);
    nStr := '';

    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nView.Columns[i].Tag);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, 'GridIndex_' + nView.Name + nViewID, nStr);
    nStr := '';

    for i:=0 to nCount do
    begin
      if nView.Columns[i].Visible then
           nStr := nStr + '1'
      else nStr := nStr + '0';
      if i <> nCount then nStr := nStr + ';';
    end;
    nTmp.WriteString(nID, 'GridVisible_' + nView.Name + nViewID, nStr);
  finally
    if not Assigned(nIni) then nTmp.Free;
  end;
end;

//Date: 2008-9-23
//Parm: ��";"�ָ�Ŀ��;������ı����ͼ
//Desc: ��nWidthӦ�õ�nView�����ͼ��
procedure UserDefineViewWidth(const nWidth: string; const nView: TcxGridTableView);
var nList: TStrings;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    nList.Text := StringReplace(nWidth, ';', #13, [rfReplaceAll]);
    if nList.Count <> nView.ColumnCount then Exit;

    nCount := nView.ColumnCount - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
       nView.Columns[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
  end;
end;

//Date: 2008-9-23
//Parm: ��","�ָ�ı�ͷ˳��;������ı����ͼ
//Desc: ��nIndexӦ�õ�nView�����ͼ��
procedure UserDefineViewIndex(const nIndex: string; const nView: TcxGridTableView);
var nList: TStrings;
    i,nCount,nIdx: integer;
begin
  nList := TStringList.Create;
  try
    nList.Text := StringReplace(nIndex, ';', #13, [rfReplaceAll]);
    if nList.Count <> nView.ColumnCount then Exit;
    nCount := nList.Count - 1;

    for i:=0 to nCount do
    begin
      nIdx := nList.IndexOf(IntToStr(nView.Columns[i].Tag));
      if nIdx > -1 then nView.Columns[i].Index := nIdx;
    end;
  finally
    nList.Free;
  end;
end;

//Date: 2008-9-23
//Parm: ��","�ָ����������;������ı����ͼ
//Desc: ��nVisibleӦ�õ�nView�����ͼ��
procedure UserDefineViewVisible(const nVisible: string; const nView: TcxGridTableView);
var nList: TStrings;
    i,nCount: integer;
begin
  nList := TStringList.Create;
  try
    nList.Text := StringReplace(nVisible, ';', #13, [rfReplaceAll]);
    if nList.Count <> nView.ColumnCount then Exit;

    nCount := nView.ColumnCount - 1;
    for i:=0 to nCount do
      nView.Columns[i].Visible := nList[i] <> '0';
    //xxxxx
  finally
    nList.Free;
  end;
end;

//------------------------------------------------------------------------------
//Date: 2009-6-9
//Parm: ����С����;�б�;��ȡ����
//Desc: ��nIDָ����С�ڶ�ȡnListBox��������Ϣ
procedure LoadMCListBoxConfig(const nID: string; const nListbox: TcxMCListBox;
 const nIni: TIniFile = nil);
var nTmp: TIniFile;
    nList: TStrings;
    i,nCount: integer;
begin
  nTmp := nil;
  nList := TStringList.Create;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nList.Text := StringReplace(nTmp.ReadString(nID, nListBox.Name + '_Head', ''),
                                ';', #13, [rfReplaceAll]);
    if nList.Count <> nListBox.HeaderSections.Count then Exit;

    nCount := nListBox.HeaderSections.Count - 1;
    for i:=0 to nCount do
     if IsNumber(nList[i], False) then
      nListBox.HeaderSections[i].Width := StrToInt(nList[i]);
    //xxxxx
  finally
    nList.Free;
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//Date: 2009-6-9
//Parm: ����С����;�б�;д�����
//Desc: ��nListbox����Ϣ����nIDָ����С��
procedure SaveMCListBoxConfig(const nID: string; const nListbox: TcxMCListBox;
 const nIni: TIniFile = nil);
var nStr: string;
    nTmp: TIniFile;
    i,nCount: integer;
begin
  nTmp := nil;
  try
    if Assigned(nIni) then
         nTmp := nIni
    else nTmp := TIniFile.Create(gPath + sFormConfig); 

    nStr := '';
    nCount := nListBox.HeaderSections.Count - 1;

    for i:=0 to nCount do
    begin
      nStr := nStr + IntToStr(nListBox.HeaderSections[i].Width);
      if i <> nCount then nStr := nStr + ';';
    end;

    nTmp.WriteString(nID, nListBox.Name + '_Head', nStr);
  finally
    if not Assigned(nIni) then FreeAndNil(nTmp);
  end;
end;

//------------------------------------------------------------------------------
//Desc: ����nGrid������
function ExportGridData(const nGrid: TcxGrid): Boolean;
var nFile: string;
    nFilter: integer;
begin
  with TSaveDialog.Create(nil) do
  begin
    Title := '����';
    Filter := '��ͨ�ı�(*.txt)|*.txt|��ʽ���ı�(*.xml)|*.xml|��ҳ�ļ�(*.htm)|' +
              '*.html|Excell���(*.xls)|*.xls';
    Options := Options + [ofOverwritePrompt];

    if Execute then
    begin
      nFilter := FilterIndex;
      case nFilter of
        1: nFile := '.txt';
        2: nFile := '.xml';
        3: nFile := '.html';
        4: nFile := '.xls';
      end;

      nFile := ChangeFileExt(FileName, nFile);
      Free;
    end else
    begin
      Free;
      Result := False; Exit;
    end;
  end;

  try
    case nFilter of
      1: ExportGridToText(nFile, nGrid);
      2: ExportGridToXML(nFile, nGrid);
      3: ExportGridToHTML(nFile, nGrid);
      4: ExportGridToExcel(nFile, nGrid);
    end;
    Result := True;
  except
    Result := False;
  end;
end;

//Desc: ��ӡԤ��nGrid���
function GridPrintPreview(const nGrid: TcxGrid; const nTitle: string): Boolean;
begin
  with FDM.dxGridLink1 do
  begin
    ReportDocument.Creator := gSysParam.FUserName;
    //ReportDocument.Caption := gSysParam
    Component := nGrid;
    ReportTitle.Text := nTitle;
    Preview;
    Result := True;
  end;
end;

//Desc: ��ӡnGrid���
function GridPrintData(const nGrid: TcxGrid; const nTitle: string): Boolean;
begin
  with FDM.dxGridLink1 do
  begin
    Component := nGrid;
    ReportTitle.Text := nTitle;
    Print(True, nil);
    Result := True;
  end;
end;

end.
