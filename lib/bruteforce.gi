################################################################################
##
## SubSemi
##
## Brute-force subsemigroup search functions
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#the set of elements  is a semigroup if they don't generate new elements
InstallGlobalFunction(IsSG,
        function(elms) return Size(elms) = Size(Semigroup(elms));end);

#this uses EnumeratorOfCartesianProduct
InstallGlobalFunction(BFSubSemis,
function(S)
local trans, ssgs, bitlist, bl, gens,i, nonsgs, duplicates,n;
  trans := AsSortedList(S);
  n := Size(trans);
  nonsgs := 0;
  duplicates := 0;
  ssgs := [];
  #all bitstrings corresponding to all subsets
  bitlist := EnumeratorOfCartesianProduct(List([1..n], x->[false,true]));
  for i in [1..2^n] do
    gens := [];
    bl := bitlist[i];
    Perform([1..n], function(x) if bl[x] then Add(gens, trans[x]);fi;end);
    if Size(gens) = 0 then
      ;#GAP bug: Size(Semigroup([])) breaks
    elif IsSG(gens) then
      if gens in ssgs then
        duplicates := duplicates + 1;
      else
        AddSet(ssgs,gens);
      fi;
    else
      nonsgs := nonsgs + 1;
    fi;
    if InfoLevel(SubSemiInfoClass)>0
       and (i mod SubSemiOptions.LOGFREQ) = 0 then
      Print("#", Size(ssgs)," at ",
            FormattedBigNumberString(i), "\n\c");
    fi;
  od;
  if InfoLevel(SubSemiInfoClass)>0 then
    Print("#Subs:", Size(ssgs),
          " Dups:", duplicates,
          " NonSubs:", nonsgs,"\n");
  fi;
  return ssgs;
end);
