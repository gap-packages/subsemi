TLgens := function(n)
  local gens, next, s, i, j;
 
  if n=1 then 
    return BipartitionNC([[1,-1]]);
  fi;

  gens:=[];
  for i in [1..n-1] do 
    next:=[];
    for j in [1..i-1] do 
      next[j]:=j;
      next[n+j]:=j;
    od;
    next[i]:=i; next[i+1]:=i;
    next[i+n]:=n; next[i+n+1]:=n;
    for j in [i+2..n] do 
      next[j]:=j-1;
      next[n+j]:=j-1;
    od;
    gens[i]:=BipartitionByIntRep(next);
  od;
  
  #the other bits
  if n>2 then
    for i in [0..n-3] do
      next := [];
      for j in [1..i] do
        Add(next, [j,-j]);
      od;
      Add(next,[i+1,-(i+3)]);
      Add(next,[i+2,i+3]);
      Add(next,[-(i+2),-(i+1)]);
      for j in [i+4..n] do
        Add(next, [j,-j]);
      od;
      Add(gens,Bipartition(next));  
    od;
  fi;
    #upside down
    if n>2 then
    for i in [0..n-3] do
      next := [];
      for j in [1..i] do
        Add(next, [j,-j]);
      od;
      Add(next,[-(i+1),+(i+3)]);
      Add(next,[-(i+2),-(i+3)]);
      Add(next,[(i+2),(i+1)]);
      for j in [i+4..n] do
        Add(next, [j,-j]);
      od;
      Add(gens,Bipartition(next));  
    od;
    Add(gens,IdentityBipartition(n));
  fi;
  return gens;
end;

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
