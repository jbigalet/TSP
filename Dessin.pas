unit Dessin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GenerationVilles, Distances;

 procedure DessinChemin(k:integer);
 procedure DessinerVilles;
 procedure DessinCheminB(Tab:array of Longint);

var TDessin : Array of integer;
    DistDessin : Real;


implementation
uses Unit1;


procedure DessinerVilles;
var i : Integer;
    RCo : RPoint;
begin
  Form1.Image1.Canvas.Pen.Width := 1;
  Form1.Image1.Canvas.Pen.Color := clBlack;
  Form1.Image1.Canvas.Rectangle(0, 0, Form1.Image1.Width, Form1.Image1.Height);
          // Effacement du graphe

  for i := 0 to NVilles-1 do
  begin
    RCo := TVilles[i];
    Form1.Image1.Canvas.Ellipse(Trunc(RCo.x)-3, Trunc(RCo.y)-3, Trunc(RCo.x)+3, Trunc(RCo.y)+3);
    // Form1.Image1.Canvas.TextOut(RCo.x-3,RCo.y+8,IntToStr(i));
          // Dessin de cette ville sur le graphe.
  end;
end;


Procedure DessinCheminB(Tab:array of Longint);
var i,TailleTab:Longint;
    Vmem1,Vmem2:RPoint;
    Cmem1,Cmem2:RealPoint;
begin
  DessinerVilles;
  TailleTab := Length(Tab);

  for i:=0 To TailleTab -1 do
    TDessin[i]:=Tab[i];

  Vmem1 := TVilles[Tab[0]];
  Cmem1 := CVilles[Tab[0]];
  Vmem2 := TVilles[Tab[NVilles -1]];
  Cmem2 := CVilles[Tab[NVilles -1]];
  Form1.Image1.Canvas.MoveTo(Trunc(Vmem1.x), Trunc(Vmem1.y));

  DistDessin := Sqrt(Sqr(Cmem2.x-Cmem1.x)+Sqr(Cmem2.y-Cmem1.y));

  for i := 1 to TailleTab -1 do
  begin
    Vmem2 := Vmem1;
    Cmem2 := Cmem1;
    Vmem1 := TVilles[Tab[i]];
    Cmem1 := CVilles[Tab[i]];
    DistDessin := DistDessin + Sqrt(Sqr(Cmem2.x-Cmem1.x)+Sqr(Cmem2.y-Cmem1.y));
    Form1.Image1.Canvas.LineTo(Trunc(Vmem1.x), Trunc(Vmem1.y));
        // Après avoir tracer la ligne, le curseur est placé sur la nouvelle ville.
  end;

        // Au final, le curseur est sur la derniere ville. On le relie donc à la premiere.

  Vmem1 := TVilles[Tab[0]];
  Form1.Image1.Canvas.LineTo(Trunc(Vmem1.x), Trunc(Vmem1.y));

  Form1.Label12.Caption := FloatToStr(DistDessin);

  if DistDessin < StrToFloat(Form1.Edit2.Text) then
    Form1.Edit2.Text := FloatToStr(DistDessin);

  Application.ProcessMessages;
end;


Procedure DessinChemin(k:integer);
var Tab:array of Longint;
    i:Longint;
begin
  SetLength(Tab, NVilles);

  for i:=0 to NVilles -1 do
    Tab[i] := Pop[k][i];

  DessinCheminB(Tab);
end;


begin
end.
