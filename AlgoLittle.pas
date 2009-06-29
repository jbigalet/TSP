unit AlgoLittle;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Dessin, GenerationVilles, Distances;

 procedure IniLittle(flag:Boolean);
 procedure JoinArretes;
 procedure addDansArrete(nLigne, Val:Longint);
 procedure EnleveArrete(nLigne:Longint);
 function MinInCo(nCo, Exclu : Longint):Real;
 function MinInLigne(nLigne, Exclu : Longint):Real;


var TCopyDist : Array of Array of Real;
    TArretes : Array of Array of Longint;
    NArretes : Longint;

implementation
uses Unit1;


procedure IniLittle(flag:Boolean);
var i,j,b, CoRegretMaxX, CoRegretMaxY:longint;
    min, DistMini, RegretMax, Regret, DistTot: Real;
    Tab : Array of Longint;
begin
  SetLength(TCopyDist, NVilles, NVilles);
  for i:=0 To NVilles -1 do
    for j:=0 To NVilles -1 do
      TCopyDist[i,j] := TAllDist[i,j];

  for i:=0 To NVilles -1 do
    TCopyDist[i,i]:=MaxCo;

  for i:=0 To NVilles -1 do
  begin
    min := MinInLigne(i,-1);
    for j:=0 To NVilles -1 do
      TCopyDist[i,j] := TCopyDist[i,j] - min
  end;
  DistTot := min;


  for i:=0 To NVilles -1 do
  begin
    min := MinInCo(i,-1);
    for j:=0 To NVilles -1 do
      if (TCopyDist[j,i]<>-1) then
        TCopyDist[j,i] := TCopyDist[j,i] - min
  end;
  DistTot := DistTot + min;

  for i:=0 To NVilles -1 do
  TCopyDist[i,i]:=MaxCo;

  SetLength(TArretes, NVilles, NVilles +1);
  NArretes := 0;
  for i:=0 To NVilles -1 do
    TArretes[i,0] := 0;

  for b := 0 to NVilles -2 do
  begin

  DistMini := MaxCo;
  for i:=0 To NVilles -1 do
    for j:=0 To NVilles -1 do
      if DistMini > TCopyDist[i,j] then
        DistMini := TCopyDist[i,j];

  if flag then
  begin
    RegretMax := 0;
    for i:=0 To NVilles -1 do
      for j:=0 To NVilles -1 do
      begin
        Regret := MinInCo(j,i) + MinInLigne(i,j) - TCopyDist[i,j];
        if (Regret > RegretMax) and (TCopyDist[i,j]<>MaxCo) then
        begin
          RegretMax := Regret;
          CoRegretMaxX := i;
          CoRegretMaxY := j;
        end;
      end;
  end
  else
  begin
    RegretMax := 0;
    for i:=0 To NVilles -1 do
     for j:=0 To NVilles -1 do
        if DistMini = TCopyDist[i,j] then
        begin
          Regret := MinInCo(j,i) + MinInLigne(i,j);
          if Regret > RegretMax then
          begin
            RegretMax := Regret;
           CoRegretMaxX := i;
           CoRegretMaxY := j;
          end;
        end;
  end;

  DistTot := DistTot + DistMini;

  addDansArrete(NArretes, CoRegretMaxX);
  addDansArrete(NArretes -1, CoRegretMaxY);

  for i:=0 to NVilles -1 do
  begin
    TCopyDist[CoRegretMaxX, i] := MaxCo;
    TCopyDist[i, CoRegretMaxY] := MaxCo;
  end;

  JoinArretes;

  for i:=0 to NArretes -1 do
    TCopyDist[TArretes[i,TArretes[i,0]],TArretes[i,1]] := MaxCo;

  end;


  SetLength(Tab, NVilles);
  for i:=0 to NVilles -1 do
    Tab[i]:=TArretes[0,i+1];

  DessinCheminB(Tab);

end;

procedure JoinArretes;
var i,j,k:Longint;
label debut;
begin
  debut :
  for i:=0 To NArretes -1 do
    for j:=0 To NArretes -1 do
      if i<>j then
        if TArretes[i,1]=Tarretes[j,Tarretes[j,0]] then
        begin
          for k:=2 To TArretes[i,0] do
            addDansArrete(j,Tarretes[i,k]);
          EnleveArrete(i);
          goto debut
        end
end;


procedure addDansArrete(nLigne, Val:Longint);
begin
  if TArretes[nLigne,0]=0 then
    NArretes := NArretes +1;
  inc(TArretes[nLigne, 0]);
  TArretes[nLigne, TArretes[nLigne, 0]] := Val
end;


procedure EnleveArrete(nLigne:Longint);
var i,j:longint;
begin
  for i:=nLigne to NArretes -1 do
    for j:=0 to TArretes[i+1,0] do
      TArretes[i,j]:=TArretes[i+1,j];
      
  NArretes := NArretes -1
end;


function MinInCo(nCo, Exclu : Longint):Real;
var i:longint;
    min:Real;
begin
  min := MaxCo;
  for i:=0 to NVilles -1 do
    if (min > TCopyDist[i,nCo]) and (i<>Exclu) then
      min := TCopyDist[i,nCo];

  MinInCo := min;
end;


function MinInLigne(nLigne, Exclu : Longint):Real;
var i:longint;
    min:Real;
begin
  min := MaxCo;
  for i:=0 to NVilles -1 do
    if (min > TCopyDist[nLigne,i]) and (i<>Exclu) then
      min := TCopyDist[nLigne,i];

  MinInLigne := min;
end;


end.
