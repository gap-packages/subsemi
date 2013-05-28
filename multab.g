#ts - transformation semigroup, permutation group
#returns a record with the multiplication table and other extra info
MulTab := function(arg)
local n,freqs,p,i,j,mt,sortedts,syms,ts,mtrecord;
  ts := arg[1];
  n := Size(ts);
  #this sorting is used to construct the multiplication table
  sortedts := AsSortedList(ts);
  #we store the table and also the frequencies of the elements
  freqs := List([1..n], x -> 0);
  mt := List([1..n], x->ListWithIdenticalEntries(n,0));
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      p := Position(sortedts, sortedts[i]*sortedts[j]);
      mt[i][j] := p;
      freqs[p] := freqs[p] + 1;
    od;
  od;
  mtrecord := rec(freqs:=freqs,
                  mt:=mt,
                  n:=n,
                  rn := [1..n], #for reusing it in loops to avoid excess objects
                  sortedts:=sortedts,
                  CONJUGACY:=false);
  #arg[2] is an automorphism group of ts in case it is there
  if IsBound(arg[2]) then
    syms := List(arg[2], g -> AsPermutation(TransformationOp(g,sortedts,\^)));
    #just getting the conjugacy classes
    mtrecord.conjclasses := DuplicateFreeList(
                                    List([1..n],
                                         x->AsSet(List(syms,g->x^g))));
    Remove(syms, Position(syms,())); #remove the identity to save time later
    mtrecord.syms := syms;
    mtrecord.CONJUGACY:=true;
  fi;
  return mtrecord;
end;

#returns the diagonal elements of a multiplication  table in a list
MulTabDiagonal := function(mt)
  return List([1..mt.n], x -> mt.mt[x][x]);
end;
