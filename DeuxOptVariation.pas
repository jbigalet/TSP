unit DeuxOptVariation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Dessin, Genetique, GenerationVilles, Distances, UDeuxOpt;

type
  ModeNouveau = (Brasse, flip);

  procedure DOV(Param : Shortint);
  procedure TesterBtnClick;
  procedure CapturePoints1(var Tab:array of Longint);
  procedure CapturePoints2(var Tab:array of Longint);
  procedure ChoisisPremierParcours;
  procedure Decroise(var Tab:array of Longint);
  function Indice(n: integer) : integer;
  procedure NouveauParcours(mode : modeNouveau);
  procedure NouvelEssai;
  procedure TraiteParcours;


var P, PBase, PMin, PMinAbsolu : Array of integer;
  lg, lgMin, lgMinAbsolu, lgBase, lgSol, MinPrTps : extended;
  cmptEssais, nbEchecs, nbMaxEchecs : integer;
  ParamT : Shortint;
  abandon, calcTps : boolean;
  sTime : TTime;

implementation

uses Unit1;

procedure DOV(Param : Shortint);
Var
  i : integer;
begin
  if Form1.CheckBox1.Checked then
    lgSol := StrToFloat(Form1.Edit2.Text)
  else
    lgSol := NVilles * MaxCo;
    
  sTime := now;
  Form1.Label14.Caption := 'XXXXXXX';
  ParamT := Param;

  SetLength(P, NVilles);
  SetLength(PMin,NVilles);
  SetLength(PMinAbsolu,NVilles);
  SetLength(PBase,NVilles);

  for i:=0 To NVilles -1 do
  begin
    P[i] := i;
    PMin[i]:=i;
    PBase[i]:=i;
    PMinAbsolu[i]:=i;
  end;

  DessinCheminB(P);
  lg := DistDessin;
  lgMin := lg;
  lgBase := lg;
  lgMinAbsolu := lg;
  nbMaxEchecs := NVilles;

  NouveauParcours(Brasse);
  DessinCheminB(P);

  TesterBtnClick();
end;


procedure TesterBtnClick();
Var
  NbTest, noTest: integer;
begin
  cmptEssais := 0;
  lgMin := MaxCo*NVilles;
  nbTest := StrToInt(InputBox('2-Opt Variation', 'Combien de tests ?', '50'));
  for noTest := 1 to nbTest do
  begin
    Form1.Label9.Caption := IntToStr((noTest * 100) div nbTest);
    Application.ProcessMessages;
    TraiteParcours;
    if lgBase < lgSol+1E-5 then
      lgMin := MaxCo*NVilles;
  end;

  Form1.Label13.Caption := FloatToStr(DistDessin);
  calcTps := True;
  MinPrTps := lgSol;
  DessinCheminB(PMinAbsolu);
end;


Procedure CapturePoints1(var Tab:array of Longint);
var
  i, j, k, val : integer;
  i1, j0, j1, j2 : integer;
  l0, l1: extended;
  capture       : boolean;
begin
  capture := true;
  while capture do
  begin
    capture := false;
    for i := 0 to NVilles-1 do
    begin
      i1 := Indice(i+1);
      for j := i+2 to i+NVilles-3 do
      begin
        j0 := Indice(j);
        j1 := Indice(j0+1); j2 := Indice(j1+1);
        l0 := TAllDist[Tab[i],Tab[i1]] + TAllDist[Tab[j0],Tab[j1]] + TAllDist[Tab[j1],Tab[j2]];
        l1 := TAllDist[Tab[i],Tab[j1]] + TAllDist[Tab[j1],Tab[i1]] + TAllDist[Tab[j0],Tab[j2]];
        if l1 + 1E-10 < l0 then 
        begin
          capture := true;
          val := Tab[j1];
          if j1 < i then     
          begin
            for k := j1 to i-1 do
              Tab[k] := Tab[k+1];
            Tab[i] := val;
          end
          else
          begin
            for k := j1 downto i+2 do
              Tab[k] := Tab[k-1];
            Tab[i1] := val;
          end;
        end;
      end;
    end;
  end;
end;


procedure CapturePoints2(var Tab:array of Longint); 
var
  i, j, k, val1, val2 : integer;
  i1, j0, j1, j2, j3 : integer;
  l0, l1 : extended;
  capture       : boolean;
begin
  capture := true;
  while capture do
  begin
    capture := false;
    for i := 0 to NVilles-1 do
    begin
      i1 := Indice(i+1);
      for j := i+2 to i+NVilles-4 do
      begin
        j0 := Indice(j); j1 := Indice(j0+1);
        j2 := Indice(j0+2); j3 := Indice(j0+3);
        l0 := TAllDist[Tab[i],Tab[i1]] + TAllDist[Tab[j0],Tab[j1]] + TAllDist[Tab[j1],Tab[j2]] + TAllDist[Tab[j2],Tab[j3]];
        l1 := TAllDist[Tab[i],Tab[j2]] + TAllDist[Tab[j2],Tab[j1]] + TAllDist[Tab[j1],Tab[i1]] + TAllDist[Tab[j0],Tab[j3]];
        if l1 + 1E-5 < l0 then
        begin
          capture := true;
          val1 := Tab[j1]; val2 := Tab[j2];
          if j1 < i then
          begin
            for k := j1 to i-2 do
              Tab[k] := Tab[k+2];
            Tab[i-1] := val2; Tab[i] := val1;
          end
          else
          if j1 < NVilles-1 then
          begin
            for k := j2 downto i+3 do
              Tab[k] := Tab[k-2];
            Tab[i+1] := val2; Tab[i+2] := val1;
          end
          else
          begin
            for k := 0 to i-1 do
              Tab[k] := Tab[k+1];
            for k := NVilles-1 downto i+2 do
              Tab[k] := Tab[k-1];
            Tab[i] := val2; Tab[i1] := val1;
          end;
        end;
      end;
    end;
  end;
end;


procedure ChoisisPremierParcours;
Var
  cmpt,i : integer;
  accepte : boolean;
begin
  lgBase := MaxCo*NVilles;
  accepte := false; cmpt := 0;
  While not accepte do
  begin
    inc(cmpt);
    NouveauParcours(brasse);

    if paramT = 2 then
      DeuxOpt(P)
    else
    begin

      if ParamT = 1 then
        DeuxOpt(P)
      else
        Decroise(P);

      CapturePoints1(P);
      CapturePoints2(P);
      Decroise(P);
    end;

    lg := CalcDistB(P);
    if lg + 1E-10 < lgBase then
    begin
      lgBase := lg;
      for i:=0 To NVilles -1 do
        PBase[i]:=P[i];
    end;
    if (lgMin = MaxCo*NVilles) then
    begin
      if (NVilles < 500) then
        accepte := cmpt > (NVilles div 10)
      else
        accepte := true;
    end
    else
    begin
      if NVilles <= 250 then
        accepte := lgBase < lgMin*1.04
      else
        accepte := lgBase < lgMin*1.05;
    end;
  end;
  nbEchecs := 0;
end;


procedure Decroise(var Tab:array of Longint);
var
  a, i, j, j0, j1, k, val : integer;
  croise       : boolean;
begin
  croise := true;
  while croise do
  begin
    a := NVilles div 4;
    Croise := false;
    for i := 0 to NVilles-4 do
      for j := 0 to NVilles-i-3 do
      begin
        j0 := i+2 + ((j + a) mod (NVilles-i-2));
        j1 := Indice(j0 + 1);
        if (TAllDist[Tab[i], Tab[i+1]] > 0.3 * MaxCo) and
           (TAllDist[Tab[i],Tab[i+1]]+TAllDist[Tab[j0],Tab[j1]] > TAllDist[Tab[i],Tab[j0]]+TAllDist[Tab[i+1],Tab[j1]]+1E-10) then
        begin
          croise := true;
          for k := i+1 to (j0+i) div 2 do
          begin
            val := Tab[k];
            Tab[k] := Tab[j0+i+1-k];
            Tab[j0+i+1-k] := val;
          end;
        end;
      end;
  end;
  croise := true;
  while croise do
  begin
    a := NVilles div 4;
    Croise := false;
    for i := 0 to NVilles-4 do
      for j := 0 to NVilles-i-3 do
      begin
        j0 := i+2 + ((j + a) mod (NVilles-i-2));
        j1 := Indice(j0 + 1);
        if TAllDist[Tab[i],Tab[i+1]] + TAllDist[Tab[j0],Tab[j1]] > TAllDist[Tab[i],Tab[j0]] + TAllDist[Tab[i+1],Tab[j1]] + 1E-10 then
        begin
          croise := true;
          for k := i+1 to (j0+i) div 2 do
          begin
            val := Tab[k];
            Tab[k] := Tab[j0+i+1-k];
            Tab[j0+i+1-k] := val;
          end;
        end;
      end;
  end;
end;


function Indice(n: integer) : integer;
begin
  if n < NVilles then
    result := n
  else
    result := n-NVilles;
end;


procedure NouvelEssai;
Var
  ch : string;
  i:integer;
begin
  inc(cmptEssais);
  nouveauParcours(flip);

  if paramT = 2 then
    DeuxOpt(P)
  else
  begin

    if ParamT = 1 then
      DeuxOpt(P)
    else
      Decroise(P);

    CapturePoints1(P);
    CapturePoints2(P);
    Decroise(P);
  end;

  lg := CalcDistB(P);
  if (lg + 1E-10 < lgBase) then
  begin
    nbEchecs := 0;
    for i:=0 To NVilles -1 do
      PBase[i]:=P[i];

    lgBase := lg;
    if lg + 1E-10 < lgMin then
    begin
      for i:=0 To NVilles -1 do
        PMin[i]:=P[i];

      lgMin := lg;
      if lgMin < lgMinAbsolu then
      begin
        lgMinAbsolu := lgMin;

        for i:=0 To NVilles -1 do
          PMinAbsolu[i]:=P[i];
      end;
    end;

    if lgMinAbsolu < lgSol + 1E-5 then
    begin
      if calcTps then
        if (lgMinAbsolu < MinPrTps + 1E-5) and (Form1.Label14.Caption='XXXXXXX') then
          Form1.Label14.Caption := TimeToStr(now - sTime);
      lgSol := lgMinAbsolu
    end;

    if lgMinAbsolu < DistDessin then
      DessinCheminB(PMinAbsolu);

    Application.ProcessMessages;

  end
  else
  begin
    inc(nbEchecs);
    if ((cmptEssais > (nbMaxEchecs div 4)) and (lgBase > lgMin*1.02)) or
       ((cmptEssais > (nbMaxEchecs div 2)) and (lgBase > lgMin*1.01)) or
       ((cmptEssais > nbMaxEchecs) and (lgBase > lgMin*1.006)) then
      abandon := true
    else
      abandon := nbEchecs = nbMaxEchecs;
  end;
end;


procedure NouveauParcours(mode : modeNouveau);
Var
  b    : integer;
  i, j : integer;

begin
  Randomize;
  Case mode of
    Brasse : begin
        for i := 3 to (NVilles-1) do
        begin
          j := Random(i-2);
          b := P[i]; P[i] := P[j]; P[j] := b;
        end;
      end;
    Flip : begin

        for i:=0 To NVilles -1 do
          PBase[i]:=P[i];

        i := random(NVilles);
        Repeat
          j := Random(NVilles);
        until abs(i-j) > 2;
        b := P[i]; P[i] := P[j]; P[j] := b;
      end;
  end;
end;


procedure TraiteParcours;
begin
  cmptEssais := 0;
  nbEchecs := 0;
  ChoisisPremierParcours;
  abandon := false;
  Repeat
    NouvelEssai;
    if lg < lgSol + 1E-5 then
      abandon := true;
  until abandon;
end;


end.
