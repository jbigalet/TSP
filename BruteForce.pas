unit BruteForce;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Dessin, Genetique, GenerationVilles, Distances;

 procedure BruteForcing;
 procedure Permutation(k:integer);
 function CalcBFIt(N:integer):Int64;

var NBBfIt : Int64;

implementation

uses Unit1;

procedure BruteForcing;
var j:integer;
    i:int64;
    MiniPath,Path:Real;
begin
  SetLength(Pop, 1, NVilles);
  for j := 0 to NVilles-1 do       // Initialisation de la liste d'ordres
    Pop[0][j]:=j;                  //

  MiniPath := CalcDist(0);                   // Initialisation de tout les champs
                                             // Et du dessin, a partir d'un premier
  DessinChemin(0);                                 // ordre, du type 0-1-2-...

  i:=0;
  while i<NbBFIt do
  begin
    inc(i);
    Permutation(i);
    Path := CalcDist(0);
    If Path < MiniPath then
    begin
      MiniPath := Path;
      DessinChemin(0)
    end;
    if i mod 1000 = 0 then
    begin
      Form1.Label7.Caption := IntToStr(i);
      Form1.Label9.Caption := IntToStr((100 * i) div NBBfIt)
    end;
    Application.ProcessMessages;
    If StopRequ then Break;
  end;

  If StopRequ = False then
  begin
    Form1.Label7.Caption := Form1.Label5.Caption;
    Form1.Label9.Caption := '100';
  end;

  Form1.Button4.Enabled := False;
end;

Procedure Permutation(k:integer);
var i,sauv:integer;
begin
  for i := 0 to NVilles-1 do       // Initialisation de la liste d'ordres
    Pop[0][i]:=i;                  //

  for i := 1 to NVilles-2 do
  begin
    k:=k div i;
    sauv := Pop[0][i];
    Pop[0][i] := Pop[0][k mod (i+1)];
    Pop[0][k mod (i+1)] := sauv;
  end
end;

function CalcBFIt(N:integer):Int64;
begin
  if N = 1 then CalcBFit:=1
  else CalcBFIt := CalcBFIt(N-1)*N
        // Calcul du nombre d'iterations necessaire au Brute Force (Recursion)
end;

begin
end.
 