BFGenSets := function(S,N)
local trans, gs, bitlist, bl, gens,i, nongs, duplicates,n;
  trans := AsSortedList(S);
  n := Size(trans);
  nongs := 0;
  duplicates := 0;
  gs := [];
  #all bitstrings corresponding to all subsets
  bitlist := EnumeratorOfCartesianProduct(List([1..n], x->[false,true]));
  Info(SubSemiInfoClass,1, FormattedBigNumberString(Size(bitlist)));
  for i in [1..2^n] do
    gens := [];
    bl := bitlist[i];
    Perform([1..n], function(x) if bl[x] then Add(gens, trans[x]);fi;end);
    if Size(gens) = 0 then
      ;#GAP bug: Size(Semigroup([])) breaks
    elif Size(Semigroup(gens)) = N then
      if gens in gs then
        duplicates := duplicates + 1;
      else
        AddSet(gs,gens);
      fi;
    else
      nongs := nongs + 1;
    fi;
    if InfoLevel(SubSemiInfoClass)>0
       and (i mod SubSemiOptions.LOGFREQ) = 0 then
      Print("#", Size(gs)," at ",
            FormattedBigNumberString(i), "\n\c");
    fi;
  od;
  if InfoLevel(SubSemiInfoClass)>0 then
    Print("#Gensets:", Size(gs),
          " Dups:", duplicates,
          " Nongensets:", nongs,"\n");
  fi;
  return gs;
end;
