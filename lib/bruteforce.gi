################################################################################
##
## SubSemi
##
## Brute-force subsemigroup search functions
##
## Copyright (C) 2013-2017  Attila Egri-Nagy
##

#the set of elements  is a semigroup if they don't generate new elements
InstallGlobalFunction(IsSG,
function(elms)
  if IsEmpty(elms) then
    return true; # the empty semigroup
  else
    return Size(elms) = Size(Semigroup(elms));
  fi;
end);

#returns 
#this uses EnumeratorOfCartesianProduct
InstallGlobalFunction(BFSubSemis,
function(S)
local trans, ssgs, bitlists, bl, elms,i, nonsgs, duplicates,n;
  trans := AsSortedList(S);
  n := Size(trans);
  nonsgs := 0;
  duplicates := 0;
  ssgs := [];
  #all bitstrings corresponding to all subsets
  bitlists := EnumeratorOfCartesianProduct(List([1..n], x->[false,true]));
  for i in [1..2^n] do
    bl := bitlists[i];
    elms := Set(Filtered([1..n], x->bl[x]), y->trans[y]);
    if IsSG(elms) then
      if elms in ssgs then
        duplicates := duplicates + 1;
      else
        AddSet(ssgs,elms);
      fi;
    else
      nonsgs := nonsgs + 1;
    fi;
    if InfoLevel(SubSemiInfoClass)>0
       and (i mod SubSemiOptions.LOGFREQ) = 0 then
      Print("#", Size(ssgs)," at ", BigNumberString(i), "\n\c");
    fi;
  od;
  if InfoLevel(SubSemiInfoClass)>0 then
    Print("#Subs:", Size(ssgs),
          " Dups:", duplicates,
          " NonSubs:", nonsgs,"\n");
  fi;
  return ssgs;
end);
