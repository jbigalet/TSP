unit Distances;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, GenerationVilles;

 function CalcDist(k:integer):Real;
 function CalcDistB(Tab:Array of Longint):Real;
 procedure CalcAllDist;

var TAllDist : Array of Array of Real;
  IsAllDist : Boolean;
 
implementation
uses Unit1;


function CalcDist(k:integer):Real;
var i:Longint;
    Tab:Array of Longint;
begin
  SetLength(Tab, NVilles);
  for i:=0 To NVilles -1 do
    Tab[i]:=Pop[k][i];

  CalcDist:=CalcDistB(Tab);
end;


function CalcDistB(Tab:Array of Longint):Real;
var Dist:Real;
    i, TailleTab:Longint;
    V1,V2:Longint;
begin
  TailleTab:=Length(Tab);

  V1 := Tab[0];
  Dist := TAllDist[V1][Tab[NVilles-1]];

  for i := 1 to NVilles-1 do
  begin
    V2 := Tab[i];
    if V1=V2 then
       V1 := V2;
    Dist := Dist + TAllDist[V1,V2];
    V1 := V2;
  end;

  CalcDistB:=Dist;
end;


procedure CalcAllDist();
var i,j:integer;
    Vmem1,Vmem2:RealPoint;
begin
  SetLength(TAllDist, NVilles, NVilles);

  for i := 0 to NVilles-1 do
  begin
    Vmem1 := CVilles[i];
    for j := 0 to NVilles-1 do
    begin
      Vmem2 := CVilles[j];
      TAllDist[i][j] := Sqrt(Sqr(Vmem2.x-Vmem1.x)+Sqr(Vmem2.y-Vmem1.y));
    end
  end;

  IsAllDist := True
end;


end.
 