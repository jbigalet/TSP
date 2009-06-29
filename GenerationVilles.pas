unit GenerationVilles;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  RPoint = Record
    X,Y:Longint
  end;
  RealPoint = Record
    X,Y:Real
  end;

var NVilles : Integer;
    TVilles : Array of RPoint;
    CVilles : Array of RealPoint;
    MaxCo : Longint;
    DistMinConnue : Boolean;
    DistMinVal : Real;

 procedure GenerationAleatoire();
 procedure Importation();


implementation
uses Unit1;

procedure GenerationAleatoire();
var i:Longint;
    RCo : RPoint;
    RCc : RealPoint;
begin
  MaxCo := trunc(sqrt(sqr(Form1.Image1.Width)+sqr(Form1.Image1.Height)));

  DistMinVal := NVilles * MaxCo;
  SetLength(TVilles,NVilles);
  SetLength(CVilles,NVilles);

  Randomize;
  for i:= 0 To NVilles-1 do
  begin
    RCo.x := Random(Form1.Image1.Width);        //Generation aleatoire de la position de la ville.
    RCo.y := Random(Form1.Image1.Height);
    RCc.X := RCo.X;
    RCc.Y := RCo.Y;
    TVilles[i] := RCo;                    //Mise en place de cette ville dans le tableau.
    CVilles[i] := RCc;
  end;
end;

procedure Importation();
var Fichier,ligne:string;
    f:TextFile;
    i,er,a:Longint;
    RatioX,RatioY,MaxX,MaxY:Real;
begin
  Form1.OpenDialog1.InitialDir := ExtractFilePath(ParamStr(0));
  Form1.OpenDialog1.Execute;
  Fichier := Form1.OpenDialog1.FileName;
  Form1.Caption := Concat('Probleme du Voyageur de Commerce : ',ExtractFileName(Fichier));

  AssignFile(f, Fichier);
  reset(f);
  readln(f, ligne);

  if StrToBool(ligne) then
  begin
    readln(f, ligne);
    Val(ligne, DistMinVal, er)
  end
  else
    DistMinVal := 0;

  readln(f, ligne);
  NVilles := StrToInt(ligne);

  SetLength(TVilles,NVilles);
  SetLength(CVilles,NVilles);

  For i:=0 To NVilles -1 do
  begin
    Readln(f, ligne);
    a := pos(';',ligne);
    Val(Copy(ligne,1,a-1), CVilles[i].x, er);
    Val(Copy(ligne,a+1,length(ligne)-a), CVilles[i].y, er)
  end;

  MaxX := 0;
  MaxY := 0;
  For i:=0 To NVilles -1 do
  begin
    if MaxX < CVilles[i].X then
      MaxX := CVilles[i].X;
    if MaxY < CVilles[i].Y then
      MaxY := CVilles[i].Y;
  end;

  MaxCo := trunc(sqrt(sqr(MaxX)+sqr(MaxY)));

  if DistMinVal = 0 then
    DistMinVal := NVilles * MaxCo;

  RatioX := (Form1.Image1.Width - 10) / MaxX;
  RatioY := (Form1.Image1.Height - 10) / MaxY;

  For i:=0 To NVilles -1 do
  begin
    TVilles[i].X := Trunc(CVilles[i].X * RatioX);
    TVilles[i].Y := Trunc(CVilles[i].Y * RatioY)
  end;

  CloseFile(f);
end;

begin
end.
 