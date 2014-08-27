DClassBitmapFile := function(Dclass, filename)
  local L, H, Lclasses;
  filename := Concatenation(filename,".bitmap");
  PrintTo(filename, ""); #erase
  for L in LClasses(Dclass) do
    for H in HClasses(L) do
      if IsRegularClass(H) then
        AppendTo(filename,"0 ");
      else
        AppendTo(filename,"1 ");
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


