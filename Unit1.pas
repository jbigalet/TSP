unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls,
  BruteForce, Dessin, Genetique, ProcheVoisin, UDeuxOpt, AlgoConvex, GenerationVilles, Distances, DeuxOptVariation, AlgoLittle;

type
  TForm1 = class(TForm)
    Image1: TImage;
    Label1: TLabel;
    Edit1: TEdit;
    Button1: TButton;
    Label2: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    Button2: TButton;
    Bevel3: TBevel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Button4: TButton;
    RadioButton5: TRadioButton;
    Label13: TLabel;
    RadioButton6: TRadioButton;
    RadioButton7: TRadioButton;
    RadioButton8: TRadioButton;
    RadioButton9: TRadioButton;
    RadioButton10: TRadioButton;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    RadioButton11: TRadioButton;
    Label14: TLabel;
    RadioButton12: TRadioButton;
    CheckBox1: TCheckBox;
    Edit2: TEdit;
    RadioButton13: TRadioButton;
    RadioButton14: TRadioButton;
    RadioButton15: TRadioButton;
    RadioButton16: TRadioButton;
    RadioButton17: TRadioButton;
    RadioButton18: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure RadioButton2Click(Sender: TObject);
    procedure RadioButton1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure CheckBox1Click(Sender: TObject);
  end;

var
  Form1: TForm1;
  StopRequ : Boolean;
  Pop : Array of Array of Longint;


implementation

uses Unit2;
{$R *.dfm}

procedure InitGeneration(flag:Boolean);
begin
  IsAllDist := False;
  StopRequ := True;

  If flag then
    Importation
  else
  begin
    NVilles := StrToInt(Form1.Edit1.Text);
    GenerationAleatoire
  end;

  Form1.Edit2.Text := FloatToStr(DistMinVal);

  NBBfIt := CalcBFIt(NVilles-1) div 2;

  If Form1.RadioButton1.Checked then Form1.Label5.Caption := IntToStr(NBBfIt);
  If Form1.RadioButton2.Checked then Form1.Label5.Caption := Form2.Edit3.Text;
         // Calcul du nombre d'iterations pour le Brute Force
  Form1.Label7.Caption := '0';
  Form1.Label9.Caption := '0';

  DessinerVilles;

  calcTps := False;
  Form1.Button2.Enabled := True       // Possibilité de cliquer sur "Go !"
end;



procedure TForm1.FormCreate(Sender: TObject);
begin
  Image1.Canvas.Brush.Color := clWhite;
  Image1.Canvas.Rectangle(0, 0, Image1.Width, Image1.Height);
  Image1.Canvas.Pen.Color := clBlack;
         //Initialisation du graphe.
end;


procedure TForm1.Button2Click(Sender: TObject);
begin
  SetLength(TDessin, NVilles);

  Button4.Enabled := True;
  StopRequ := False;
  if IsAllDist=False then CalcAllDist;

  if RadioButton1.Checked then BruteForcing
  else if RadioButton7.Checked and (DistDessin<>0) then DeuxOpt(TDessin)
  else if RadioButton7.Checked then ShowMessage('Commences par faire un trace !')
  else if RadioButton13.Checked and (DistDessin<>0) then
  begin
     CapturePoints1(TDessin);
     DessinCheminB(TDessin);
  end
  else if RadioButton13.Checked then ShowMessage('Commences par faire un trace !')
  else if RadioButton14.Checked and (DistDessin<>0) then
  begin
    CapturePoints2(TDessin);
    DessinCheminB(TDessin);
  end
  else if RadioButton14.Checked then ShowMessage('Commences par faire un trace !')
  else if RadioButton15.Checked and (DistDessin<>0) then
  begin
    Decroise(TDessin);
    DessinCheminB(TDessin);
  end
  else if RadioButton15.Checked then ShowMessage('Commences par faire un trace !')
  else if RadioButton6.Checked then Glouton
  else if RadioButton2.Checked then Genetiquing
  else if RadioButton5.Checked then PGMing
  else if RadioButton8.Checked then RandDeuxOpt(True)
  else if RadioButton9.Checked then RandDeuxOpt(False)
  else if RadioButton10.Checked then Enveloppe_Convexe()
  else if RadioButton11.Checked then DOV(0)
  else if RadioButton12.Checked then DOV(1)
  else if RadioButton16.Checked then DOV(2)
  else if RadioButton17.Checked then IniLittle(False)
  else if RadioButton18.Checked then IniLittle(True)
end;


procedure TForm1.Button4Click(Sender: TObject);
begin
  StopRequ := True
end;


procedure TForm1.RadioButton2Click(Sender: TObject);
begin
  Form2.Visible := True;
  Form1.Enabled := False
end;


procedure TForm1.RadioButton1Click(Sender: TObject);
begin
  Label5.Caption := IntToStr(NBBfIt);
  Label7.Caption := '0';
  Label9.Caption := '0';
  Label12.Caption := 'XXXXXXX';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  InitGeneration(False);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  InitGeneration(True);
end;

procedure TForm1.CheckBox1Click(Sender: TObject);
begin
  if CheckBox1.Checked then
  begin
    Edit2.Color := clWindow;
    Edit2.Enabled := True;
  end
  else
  begin
    Edit2.Color := clBtnFace;
    Edit2.Enabled := False;
  end
end;

end.
