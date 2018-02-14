DClassBitmapFile := function(Dclass, filename)
  local L, H, Lclasses;
  filename := Concatenation(filename,".pbm");
  PrintTo(filename, ""); #erase
  AppendTo(filename,"P1\n");
  AppendTo(filename,String(Size(LClasses(Dclass))),
          " ",String(Size(RClasses(Dclass))),"\n");
  for L in LClasses(Dclass) do
    for H in HClasses(L) do
      if IsRegularClass(H) then
        AppendTo(filename,"1 ");
      else
        AppendTo(filename,"0 ");
      fi;
    od;
    AppendTo(filename,"\n");
  od;
end;

DClassesBitmapFiles := function(S, prefix)
  local Dclasses,i,ndigits;
  ndigits := Size(String(NrDClasses(S)));
  for i in [1..NrDClasses(S)] do
    DClassBitmapFile(DClasses(S)[i],
            Concatenation(prefix,"_", PaddedNumString(i,ndigits)));
    S := Semigroup(GeneratorsOfSemigroup(S)); #silly but avoids memory crash
  od;
end;


for i in [1..42] do DClassesBitmapFiles(JonesMonoid(i), Concatenation("J",PaddedNumString(i,2))); Display(i);od;
