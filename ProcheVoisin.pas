unit ProcheVoisin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Dessin, GenerationVilles, Distances;

 procedure Glouton();

implementation
uses Unit1;


procedure Glouton();
var i,j,k,l,VMin,VilleEnCours:Longint;
    GDist,GMin:Real;
    flag:Boolean;
    Tab:Array of Longint;
begin
  DistDessin:=1000000000;
  SetLength(Tab,NVilles);

  for i:=0 To NVilles -1 do
  begin
    for j:=0 To NVilles -1 do
      Tab[j]:=-1;
    Tab[0]:=i;
    GDist:=0;
    for j:=0 TO NVilles -2 do
    begin
      GMin:=100000000;
      VilleEnCours:=Tab[j];
      for k:=0 To Nvilles -1 do
        if TAllDist[VilleEnCours,k]<GMin then
        begin
          flag:=True;
          for l:=0 To j do
            if Tab[l]=k then flag:=false;
          if flag then
          begin
            Gmin:=TAllDist[VilleEnCours,k];
            VMin:=k
          end;
        end;
      Tab[j+1]:=VMin;
      GDist:=GDist + Gmin;
    end;
    GDist:=GDist + TAllDist[Tab[0],Tab[NVilles-1]];
    if GDist < DistDessin then
      DessinCheminB(Tab);
  end;
end;

begin
end.
 