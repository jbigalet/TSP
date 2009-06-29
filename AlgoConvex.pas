unit AlgoConvex;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Dessin, GenerationVilles, Distances;

 procedure Enveloppe_Convexe();
 procedure PGMing();
 procedure InsDsTabl(var Tabl:array of Integer; Pos, Val, LimTabl:integer);

var TConvexe : Array of integer;
    NConvexe : Integer;


implementation
uses Unit1;


procedure PGMing();
var InTConvexe:array of Integer;
    i,j,PosMin,VMin,k,kSuiv:longint;
    Perte,PerteMin:Real;
begin
  SetLength(InTConvexe, NVilles);

  Enveloppe_Convexe;

  For i:=0 To NConvexe do
    InTConvexe[TConvexe[i]]:=1;

  While NConvexe<>NVilles-1 do
  begin
    PerteMin:=100000000;
    for i:=0 To NVilles-1 do
      if InTConvexe[i]=0 then
        for j:=0 To NVilles-1 do
          if InTConvexe[j]=1 then
          begin
            k:=0;
            while TConvexe[k]<>j do
              k:=k+1;
            KSuiv:=(k+1) mod (NConvexe+1);
            Perte:=TAllDist[j,i]+TAllDist[TConvexe[KSuiv],i]-TAllDist[j,TConvexe[KSuiv]];
            if Perte<PerteMin then
            begin
              PerteMin:=Perte;
              VMin:=i;
              PosMin:=k+1;
            end;
          end;

    InsDsTabl(TConvexe, PosMin, VMin, NConvexe);
    InTConvexe[VMin]:=1;
    NConvexe:= NConvexe +1;
  end;

  DessinCheminB(TConvexe);
end;


procedure InsDsTabl(var Tabl:array of Integer; Pos, Val, LimTabl:integer);
var i:integer;
begin
  for i:=LimTabl DownTo Pos do
    Tabl[i+1]:=Tabl[i];

  Tabl[Pos]:=Val;
end;

procedure Enveloppe_Convexe();
var i,b,a,k,h,j:integer;
    d,m,w,t,p,q,u,v:real;
begin
  SetLength(TConvexe,NVilles);
  DessinerVilles();

  m:=0;
  for i:=1 to NVilles do
    if TVilles[i-1].x>m then
    begin
      m:=TVilles[i-1].x;
      b:=i
    end;

  a:=(b+1) mod NVilles;

  i:=-1;
  Repeat
    i:=i+1;
    TConvexe[i]:=b;
    p:=TVilles[a-1].x-TVilles[b-1].x;
    q:=TVilles[a-1].y-TVilles[b-1].y;
    d:=sqrt(p*p+q*q);
    t:=2;
    for j:=1 to NVilles do
    begin
      if j<>b then
      begin
        u:=TVilles[j-1].x-TVilles[b-1].x;
        v:=TVilles[j-1].y-TVilles[b-1].y;
        w:=(p*u+q*v)/(d*sqrt(u*u+v*v));
        if w<t then
        begin
          t:=w;
          k:=j
        end
      end
    end;
    h:=b;
    b:=k;
    a:=h;
    Form1.Image1.Canvas.MoveTo(Trunc(TVilles[a-1].x), Trunc(TVilles[a-1].y));
    Form1.Image1.Canvas.LineTo(Trunc(TVilles[b-1].x), Trunc(TVilles[b-1].y));
  Until b=TConvexe[1];

  NConvexe:=i-1;

  for i:=0 To NConvexe do
    TConvexe[i]:=TConvexe[i]-1;
end;


end.
 