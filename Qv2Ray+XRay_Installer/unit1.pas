unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, ComCtrls, IniPropStorage, Process, DefaultTranslator, ExtCtrls;

type

  { TMainForm }

  TMainForm = class(TForm)
    Image1: TImage;
    ImageList1: TImageList;
    IniPropStorage1: TIniPropStorage;
    Label1: TLabel;
    LogMemo: TMemo;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    InstallBtn: TSpeedButton;
    RemoveBtn: TSpeedButton;
    StaticText1: TStaticText;
    Timer2: TTimer;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure InstallBtnClick(Sender: TObject);
    procedure RemoveBtnClick(Sender: TObject);
    procedure StartProcess(command: string);
    procedure Timer2Timer(Sender: TObject);
  private

  public

  end;

resourcestring
  SStartWarning = 'Proceed with the Installation?';
  SWarningClose = 'Installation is running! Cancel?';
  SRemoveMsg = 'Delete the current Installation?';
  SCloseInstance = 'Before deleting, close the running instance!';

var
  MainForm: TMainForm;
  command: string;
  a: integer;

implementation

uses start_trd;

{$R *.lfm}

{ TMainForm }

//Общая процедура запуска команд (асинхронная)
procedure TMainForm.StartProcess(command: string);
var
  ExProcess: TProcess;
begin
  Application.ProcessMessages;
  ExProcess := TProcess.Create(nil);
  try
    ExProcess.Executable := '/bin/bash';
    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add(command);
    //  ExProcess.Options := ExProcess.Options + [poWaitOnExit];
    ExProcess.Execute;
  finally
    ExProcess.Free;
  end;
end;

procedure TMainForm.Timer2Timer(Sender: TObject);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    ImageList1.GetBitmap(a, Bmp);
    Image1.Picture.Assign(Bmp);
    Inc(a);
    if a = ImageList1.Count then a := 0;
  finally
    Bmp.Free;
  end;
end;

//Установка
procedure TMainForm.InstallBtnClick(Sender: TObject);
var
  FStartBackup: TThread;
begin
  //Создаём однострочную команду
  command :=
    'kpath="/home/$LOGNAME/.config/qv2ray/vcore"; [[ -d $kpath ]] || mkdir -p $kpath; ' +
    'urlxray="https://github.com/XTLS/Xray-core/releases/download/v1.5.5/Xray-linux-64.zip"; '
    + 'urlqv2ray="https://github.com/Qv2ray/Qv2ray/releases/download/v2.7.0/Qv2ray-v2.7.0-linux-x64.AppImage"; '
    + 'wget $urlxray 2>&1 | grep "%" && unzip -o ./*.zip -d $kpath && rm -f ./Xray-linux-64.zip && '
    + 'mv -f $kpath/xray $kpath/v2ray && wget -N $urlqv2ray 2>&1 | grep "%" && chmod +x ./*.AppImage; exit 0';

  if MessageDlg(SStartWarning, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    FStartBackup := StartBackup.Create(False);
    FStartBackup.Priority := tpNormal;
  end;
end;

//Удаление установки
procedure TMainForm.RemoveBtnClick(Sender: TObject);
var
  S: ansistring;
  FStartBackup: TThread;
begin
  if RunCommand('/bin/bash', ['-c', 'pgrep "Qv2"'], S) then
    if S <> '' then
    begin
      MessageDlg(SCloseInstance, mtWarning, [mbOK], 0);
      Exit;
    end;

  if MessageDlg(SRemoveMsg, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    LogMemo.Clear;
    command := 'rm -vrf ~/.config/qv2ray; rm -fv ./*.AppImage';
    FStartBackup := StartBackup.Create(False);
    FStartBackup.Priority := tpNormal;
  end;
end;

procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  //Если идёт Установка...
  if not InstallBtn.Enabled then
    if MessageDlg(SWarningClose, mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      StartProcess('killall wget curl unzip');
      CanClose := True;
    end
    else
      Canclose := False;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MainForm.Caption := Application.Title;
end;


procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Счетчик индикатора
  a := 0;
  if not DirectoryExists(GetUserDir + '.config') then MkDir(GetUserDir + '.config');
  IniPropStorage1.IniFileName := GetUserDir + '.config/Qv2Ray+XRay.ini';
end;


end.
