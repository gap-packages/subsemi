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
  Dclasses := GreensDClasses(S);
  ndigits := Size(String(Size(Dclasses)));
  for i in [1..Size(Dclasses)] do
    DClassBitmapFile(Dclasses[i],
            Concatenation(prefix,"_", PaddedNumString(i,ndigits)));
  od;
end;


