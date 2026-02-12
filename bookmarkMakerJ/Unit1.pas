unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.AnsiStrings, System.StrUtils,
  Vcl.ExtCtrls, System.UITypes;

type
  TForm1 = class(TForm)
    edPage: TEdit;
    edLevel: TEdit;
    edContents: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Memo1: TMemo;
    btnAdd: TButton;
    BtnSaveAs: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    BtnLoad: TButton;
    BtnClear: TButton;
    BtnSave: TButton;
    BtnReset: TButton;
    BtnEdit: TButton;
    Panel1: TPanel;
    btnIns: TButton;
    btnDel: TButton;
    procedure BtnClearClick(Sender: TObject);
    procedure BtnLoadClick(Sender: TObject);
    procedure BtnSaveClick(Sender: TObject);
    procedure BtnSaveAsClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure resetAll();
    procedure clearEdits();
    function convertStr(sline: string): string;
    function convertCode(sline: string): string;
    function getInfo(): string;
    function getLine(): Integer;
    function dspMsg(msg: string):boolean;
    procedure MakeCap();
    procedure BtnResetClick(Sender: TObject);
    procedure BtnEditClick(Sender: TObject);
    procedure btnInsClick(Sender: TObject);
    procedure Memo1Click(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
  private
    { Private 宣言 }
  public
    fname: TFileName;
    isEdit: boolean;
    { Public 宣言 }
  end;

var
  Form1: TForm1;

const
  HEAD = 'Bookmark MakerJ';
  VERSION = '1.2';
  TAB = chr(9);
  MSG_CLR = 'Are you sure to clear all ?';
  MSG_RST = 'Are you sure to reset?';
implementation

{$R *.dfm}

function TForm1.getInfo: string;
var
  buf: string;
begin
  buf := edPage.Text+TAB+edLevel.Text + TAB + convertStr(edContents.Text);
  result := buf;
end;

function TForm1.getLine: Integer;
var
  line, ss: Integer;
begin
  ss := Memo1.SelStart;
  line := Memo1.Perform(EM_LINEFROMCHAR, ss, 0);
  result := line;
end;

procedure TForm1.btnAddClick(Sender: TObject); //Convert
var
  buf: string;
begin
  buf := getInfo;
  Memo1.Lines.Add(buf);
  Form1.ActiveControl := edPage;
end;

procedure TForm1.BtnSaveAsClick(Sender: TObject); //Save as
begin
  if SaveDialog1.Execute() then
    fname := SaveDialog1.FileName;
    Memo1.Lines.SaveToFile(fname);
    MakeCap;
end;

procedure TForm1.BtnLoadClick(Sender: TObject); //Load
begin
  if OpenDialog1.Execute() then begin
    fname := OpenDialog1.FileName;
    Memo1.Lines.LoadFromFile(fname);
    clearEdits;
    MakeCap;
    Form1.ActiveControl := edPage;
  end;
end;

procedure TForm1.btnInsClick(Sender: TObject);
var
  buf: string;
  line: Integer;
begin
  line := getLine;
  buf := getInfo;
  Memo1.Lines.Insert(line+1, buf);
  self.ActiveControl := edPage;
end;

procedure TForm1.BtnClearClick(Sender: TObject); //Clear
begin
  if dspMsg(MSG_CLR) then
    Memo1.Lines.Clear;
end;

procedure TForm1.btnDelClick(Sender: TObject);
var
  line: Integer;
begin
  line := getLine;
  Memo1.Lines.Delete(line);
end;

procedure TForm1.BtnSaveClick(Sender: TObject); //Save
begin
  Memo1.Lines.SaveToFile(fname);
end;

procedure TForm1.BtnResetClick(Sender: TObject); //Reset
begin
  if dspMsg(MSG_RST) then
    resetAll;
end;

procedure TForm1.BtnEditClick(Sender: TObject); //Edit
var
  buf: string;
  line: Integer;
begin
  line := getLine;
  buf := getInfo;
  Memo1.Lines[line] := buf;
  self.ActiveControl := edPage;
end;

function TForm1.dspMsg(msg: string): Boolean;
var
  x,y : Integer;
begin
  x := (self.Left + self.Width)div 2 + 100;
  y := self.Top + 50;
  result := MessageDlgPos(msg,mtConfirmation,[mbYes,mbCancel],0,x,y)=mrYes;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  resetAll;
  isEdit := false;
end;

procedure TForm1.resetAll;
begin
  clearEdits;
  Memo1.Lines.Clear;
  fname := 'untitled';
  MakeCap;
end;

procedure TForm1.clearEdits;
begin
  edPage.Text := '1';
  edLevel.Text := '1';
  edContents.Text := '表紙';
end;

function TForm1.convertStr(sline: string): string;
var
  I, cn: Integer;
  buf, code: string;
begin
  buf := '';
  for I := 1 to Length(sline) do begin
    cn := Ord(sline[I]);
    if cn < 256 then
      code := sline[I]
    else
      code := '&#'+IntToStr(cn)+';';
    buf := buf + code;
  end;
  result := buf;
end;

function TForm1.convertCode(sline: string): string;
var
  buf, res: string;
  I: Integer;
  sbuf: TStringList;
begin
  sbuf := TStringList.Create;
  buf := ReplaceStr(sline, ' ', '_');   //文字列中のスペースを一旦'_'に置換
  buf := ReplaceStr(buf, ';', ',');
  buf := ReplaceStr(buf, '&#', ',#');
  buf := ReplaceStr(buf, ',,', ',');
  sbuf.CommaText := buf;
  res := '';
  for I := 0 to sbuf.Count-1 do begin
    buf := sbuf[I];
    if LeftStr(buf,1)='#' then
      buf := Char(StrToInt(MidStr(buf, 2, 6)));
    res := res + buf
  end;
  res := ReplaceStr(res, '_', ' ');   //'_'をスペースに戻す
  result := res;
  sbuf.Free;
end;

procedure TForm1.MakeCap;
var
  fn: string;
begin
  fn := ExtractFileName(fname);
  Form1.Caption := HEAD + '(ver '+ VERSION + ') - ' + fn;
end;

procedure TForm1.Memo1Click(Sender: TObject);
var
  line, lstr: Integer;
  sbuf: TStringList;
  buf: string;
begin
  line := getLine;
  buf := Memo1.Lines[line];
  sbuf := TStringList.Create;
  sbuf.CommaText := buf;
  edPage.Text := sbuf[0];
  edLevel.Text := sbuf[1];
  lstr := sbuf[0].Length + sbuf[1].Length;
  Delete(buf, 1, lstr+1);
  edContents.Text := convertCode(buf);
end;

end.
