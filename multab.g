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
  mtrecord := rec(ts:=ts,
                  freqs:=freqs,
                  mt:=mt,
                  n:=n,
                  rn := [1..n], #for reusing it in loops to avoid excess objects
                  sortedts:=sortedts,
                  CONJUGACY:=false,
                  syms:=[],
                  BLOCKING:=false
                  );
  #arg[2] is an automorphism group of ts in case it is there
  if IsBound(arg[2]) then
    if IsBound(arg[3]) then
      mtrecord.syms := NonTrivialSymmetriesOfElementIndicesThroughHom(ts,arg[2],arg[3]);
    else
      mtrecord.syms := NonTrivialSymmetriesOfElementIndices(ts,arg[2]);
    fi;
    mtrecord.CONJUGACY:=true;
  fi;
  return mtrecord;
end;

#returns the diagonal elements of a multiplication  table in a list
MulTabDiagonal := function(mt)
  return List([1..mt.n], x -> mt.mt[x][x]);
end;
