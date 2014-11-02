
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
