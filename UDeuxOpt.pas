unit UDeuxOpt;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Dessin, GenerationVilles, Distances;

 procedure RandDeuxOpt(flag:Boolean);
 function Renversement(var Tab,T:Array of Longint; Ville1,Ville2:Longint):Real;
 procedure DeuxOpt(var T:array of Longint);

implementation
uses Unit1;


procedure DeuxOpt(var T:array of Longint);
var Ville1, Ville2, i :Longint;
    Dist,NewDist:Real;
    Tab:Array of Longint;
begin
  SetLength(Tab, Nvilles);
  
  NewDist := CalcDistB(T);

  Repeat
    Dist:=NewDist;
    for Ville1:=0 To NVilles-1 do
      Tab[Ville1]:=T[Ville1];

    for Ville1:= 0 To NVilles -2 do
      for Ville2:= Ville1 +1 To Nvilles -1 do
        if Renversement(Tab,T,Ville1,Ville2)<Dist then
          for i:=0 To NVilles -1 do
            T[i]:=Tab[i];

    NewDist := CalcDistB(T);
  Until NewDist = Dist;

  If NewDist < DistDessin then
    DessinCheminB(T)
end;


function Renversement(var Tab,T:array of Longint; Ville1,Ville2:Longint):Real;
var i,PosPrem,PosDeuz:Longint;
begin
  i:=0;
  while (T[i]<>Ville1) and (T[i]<>Ville2) do
  begin
    Tab[i]:=T[i];
    i:=i+1
  end;
  PosPrem:=i;
  i:=i+1;
  while (T[i]<>Ville1) and (T[i]<>Ville2) do
    i:=i+1;
  PosDeuz:=i;

  for i:=PosDeuz +1 to NVilles -1 do
    Tab[i]:=T[i];

  for i:=PosDeuz downto PosPrem do
    Tab[PosPrem + PosDeuz - i]:=T[i];

  Renversement:=CalcDistB(Tab);
end;


procedure RandDeuxOpt(flag:Boolean);
var i,j:longint;
    Tab:Array of Longint;
begin
  SetLength(Tab, NVilles);
  Randomize;

  Tab[0]:=0;
  for i := 1 to NVilles-1 do
  begin
    j := random(i)+1;
    Tab[i] := Tab[j];
    Tab[j] := i;
  end;

  DessinCheminB(Tab);

  if flag then
    DeuxOpt(TDessin)
end;

begin
end.
 