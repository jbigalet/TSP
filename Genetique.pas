unit Genetique;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Dessin, GenerationVilles, Distances;

 procedure NouvellePop(M,n:Longint);
 function IsNotFind(k,RangParent,NCar,RangEnf:Longint):boolean;
 function ChercheDaBest(n:Longint):Longint;
 procedure PermAleat(k:Longint);
 procedure Genetiquing;
 procedure COBest(M,n:Longint);
 procedure MutationBest(M,n,t:Longint);
 procedure SelecBest(M,NPop:Longint);
 procedure DistEnf(M,n:Longint);
 procedure Intervertir(i,Un,Deux:Longint);
 procedure GarderMauvais(N,NPop,RangDebut:Longint);

var BestPop : Array of Array of Longint;
    TDist : Array of Real;


implementation
uses Unit1, Unit2;


procedure NouvellePop(M,n:integer);
var i:integer;
begin
  for i := M to n-1 do
  begin
    PermAleat(i);
    TDist[i] := CalcDist(i)
  end
end;


procedure PermAleat(k:integer);
var i,j:integer;
begin
  Pop[k][0]:=0;
  for i := 1 to NVilles-1 do
  begin
    j := random(i)+1;
    Pop[k][i] := Pop[k][j];
    Pop[k][j] := i;
  end
end;


procedure DistEnf(M,n:integer);
var i:integer;
begin
  for i := M to n-1 do
    TDist[i] := CalcDist(i)
end;


procedure MutationBest(M,n,t:integer);
var i:integer;
begin
  for i:=M to M+n-1 do
    while random(1000)<t do
      Intervertir(i,random(NVilles),random(NVilles))
end;


procedure Intervertir(i,Un,Deux:integer);
var Mini,Maxi,Mem:integer;
begin
  If Un > Deux then
    begin
    Mini := Deux;
    Maxi := Un
    end
  else
    begin
    Mini := Un;
    Maxi := Deux
  end;

  While Maxi>Mini do
  begin
    Mem := Pop[i][Mini];
    Pop[i][Mini] := Pop[i][Maxi];
    Pop[i][Maxi] := Mem;
    inc(Mini);
    dec(Maxi)
  end
end;


procedure COBest(M,n:integer);
var i,j,Parent1,Parent2,NumCar,Rang,DejaRempli1:integer;
begin
  rang := M - 1;
  for i:=0 to n-1 do
  begin
    Parent1 := random(M);
    Parent2 := random(M);
    While Parent2 = Parent1 do
      Parent2 := random(M);
    NumCar := random(NVilles-2)+1;

    inc(Rang);
    for j := 0 to NumCar do
      Pop[Rang][j] := Pop[Parent1][j];

    DejaRempli1 := NumCar;
    for j := 0 to NVilles-1 do
       If IsNotFind(j,Parent2,NumCar,Rang) then
       begin
          Inc(DejaRempli1);
          Pop[Rang][DejaRempli1] := Pop[Parent2][j];
       end;
  end

end;


function IsNotFind(k,RangParent,NCar,RangEnf:integer):boolean;
var flag:boolean;
    CarToFind,i:integer;
begin
  i:=-1;
  flag:=false;
  CarToFind := Pop[RangParent][k];
  while (i<NCar) and (flag=False) do
  begin
    inc(i);
    if Pop[RangEnf][i] = CarToFind then
      flag:=true;
  end;
  IsNotFind := Not flag
end;


procedure Genetiquing;
var NPop,NBest,DABest,NEnf,TauxMut,NMauvais,j,k : integer;
    NBIt,i : int64;
    BestDist:Real;
begin
  Randomize;

  NPop := StrToInt(Form2.Edit1.Text);
  NBest := StrToInt(Form2.Edit2.Text);
  NBIt := StrToInt(Form2.Edit3.Text);
  TauxMut := trunc(1000*StrToFloat(Form2.Edit4.Text));
  NEnf := StrToInt(Form2.Edit5.Text);
  NMauvais := StrToInt(Form2.Edit6.Text);

  SetLength(Pop, NPop, NVilles);
  SetLength(BestPop, NBest, NVilles);
  SetLength(TDist, NPop);

  NouvellePop(0, NPop);
  BestDist := TDist[0];
  DessinChemin(0);

  i:=0;
  while i < NBIt do
  begin
    inc(i);
    SelecBest(NBest,NPop);
    for j:= 0 to NBest - 1 do
      for k:= 0 to NVilles - 1 do
        Pop[j][k] := BestPop[j][k];


    GarderMauvais(NMauvais,NPop,NBest);
    COBest(NBest + NMauvais,NEnf);
    MutationBest(NBest + NMauvais,NEnf,TauxMut);
    DistEnf(0,NEnf);
    NouvellePop(NBest + NEnf + NMauvais,NPop);

    DABest := ChercheDaBest(NPop);

    If TDist[DaBest] < BestDist then
    begin
      BestDist := TDist[DaBest];
      DessinChemin(DaBest)
    end;

    if i mod 10 = 0 then
    begin
      Form1.Label7.Caption := IntToStr(i);
      Form1.Label9.Caption := IntToStr((100 * i) div NBIt)
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


function ChercheDaBest(n:integer):integer;
var i,IMini:integer;
    mini:Real;
begin
  mini := TDist[0];
  IMini:=0;
  for i:=1 to n-1 do
    if TDist[i] < mini then
    begin
      mini := TDist[i];
      IMini := i;
    end;

  ChercheDaBest := IMini
end;


procedure SelecBest(M,NPop:integer);
var i,j,RangEnCours:integer;
    MaxDist, TotalSum, SumEnCours:Real;
    Aleat:int64;
    NewTDist:Array of Real;
begin
  SetLength(NewTDist, NPop);

  MaxDist := 0;
  for i := 0 to NPop - 1 do
    if TDist[i]>MaxDist then
      MaxDist := TDist[i];

  for i := 0 to NPop - 1 do
    NewTDist[i] := MaxDist - TDist[1];

  TotalSum := 0;
  for i := 0 to NPop - 1 do
    TotalSum := TotalSum + NewTDist[i];

  for i := 0 to M - 1 do
  begin
    Aleat := random(Trunc(TotalSum));
    RangEnCours := 0;
    SumEnCours := NewTDist[0];
    while SumEnCours < Aleat do
    begin
      Inc(RangEnCours);
      SumEnCours := SumEnCours + NewTDist[RangEnCours]
    end;

    for j := 0 to NVilles - 1 do
      BestPop[i][j] := Pop[RangEnCours][j];

  end
end;


procedure GarderMauvais(N,NPop,RangDebut:integer);
var i,j,IMauvais:integer;
    MiniObl,maxi:Real;
begin
  MiniObl := TDist[0] + 1;

  for i:= 0 to N-1 do
  begin
    IMauvais := 0;
    maxi := TDist[0];
    for j:= 0 to NPop - 1 do
      if TDist[j] > maxi then
        if TDist[j] < MiniObl then
        begin
          maxi := TDist[j];
          IMauvais := j
        end;

    MiniObl := maxi;
    for j := 0 to NVilles-1 do
      Pop[RangDebut + i][j] := Pop[IMauvais][j];

  end
end;


begin
end.
 