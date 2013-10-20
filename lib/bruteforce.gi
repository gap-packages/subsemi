#this uses EnumeratorOfCartesianProduct
BruteForceSubSemiEnum := function(S)
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
    elif Size(gens) = Size(Semigroup(gens)) then
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
end;

################################################################################
# GAP 4.5 function implementing a brute force search for submagmas of a magma.
# (C) 2012 Attila Egri-Nagy www.egri-nagy.hu
# GAP can be obtained from www.gap-system.org
################################################################################
# The function goes through all the subsets of the given magma (groups,
# semigroups) and checks whether they form a magma or not.
# If yes, then the submagma is collected.
# The function returns the list of all (nonempty) submagmas.
BruteForceSubMagmaSearch := function(M)
local bitlist, #the characteristic function of a subest
      i, #an integer to index through the bitlist
      n, #size of the input magma
      elms, #elements of the magma
      gens, #generator set of a submagma
      submagmas, #the submagmas
      duplicates, #for counting how many times we encounter the same submagma
      nonsubmagmas; #counting how many subsets are not submagmas
      # duplicates + nonsubmagmas = 2^n-1

  n := Size(M);
  submagmas := [];
  elms := AsList(M);
  duplicates := 0;
  nonsubmagmas := 0;
  bitlist := BlistList([1..n],[1]); #we start with the first element, the
  #empty set can be added afterwards, if the magma's definition allows it
  repeat
    #constructing a generator set based on the bitlist##########################
    gens := [];
    Perform([1..n],function(x) if bitlist[x] then Add(gens, elms[x]);fi;end);
    #checking whether it is a submagma
    if Size(gens) = Size(Magma(gens)) then
      if gens in submagmas then
        duplicates := duplicates + 1;
      else
        AddSet(submagmas,gens);
      fi;
    else
      nonsubmagmas := nonsubmagmas + 1;
    fi;
    #binary +1 applied to bitlist###############################################
    i := 1;
    while (i<=n) and (bitlist[i]) do
      bitlist[i] := false;
      i := i + 1;
    od;
    if i <= n then bitlist[i] := true;fi;
    ############################################################################
  until SizeBlist(bitlist) = 0;
  Print("#I Submagmas:", Size(submagmas),
        " Duplicates:", duplicates,
        " Nonsubmagmas:", nonsubmagmas,"\n");
  return submagmas;
end;

################################################################################
# GAP 4.5 function calculating the conjugacy classes of a set of subsemigrops.
# (C) 2012 Attila Egri-Nagy www.egri-nagy.hu
# GAP can be obtained from www.gap-system.org
################################################################################
# Input: list of subsemigroups of a transformation semigroup,
#        automorphism group of the semigroup
# Output: list of conjugacy classes
ConjugacyClassesSubsemigroups := function(subsemigroups, G)
local ssg, #subsemigroup
      ccl, #conjugacy class
      ccls; #result: all conjugacy classes
  ccls := [];
  for ssg in subsemigroups do
    #we check whether the subsemigroup is already in a conjugacy class
    if not ForAny(ccls, x -> ssg in x) then
      #conjugating by all group elements
      ccl := DuplicateFreeList(
                     List(G,
                          g -> AsSortedList(List(ssg, t-> t^g))));
      Add(ccls, ccl);
    fi;
  od;
  return ccls;
end;
