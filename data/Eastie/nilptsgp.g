#from JDM#######################################################################
NrFloatingBlocks := function(a, b)
  local n, anr, fuse, fuseit, ablocks, bblocks, x, y, cblocks, next, made_it, tab, nr, i;

  n := DegreeOfBipartition(a);
  anr := NrBlocks(a);

  fuse := [1 .. anr + NrBlocks(b)];

  fuseit := function(i)
    while fuse[i] < i do
      i := fuse[i];
    od;
    return i;
  end;

  ablocks := a!.blocks;
  bblocks := b!.blocks;

  for i in [1 .. n] do
    x := fuseit(ablocks[i + n]);
    y := fuseit(bblocks[i] + anr);
    if x <> y then
      if x < y then
        fuse[y] := x;
      else
        fuse[x] := y;
      fi;
    fi;
  od;

  cblocks := EmptyPlist(2 * n);
  next := 0;
  made_it := BlistList(fuse, []);
  for i in [1 .. n] do
    made_it[fuseit(ablocks[i])] := true;
  od;

  for i in [n + 1 .. 2 * n] do
    made_it[fuseit(bblocks[i] + anr)] := true;
  od;
  tab := 0 * fuse;
  nr := 0;

  for i in [n + 1 .. 2 * n] do
    x := fuseit(ablocks[i]);
    if not made_it[x] and tab[x] = 0 then
      nr := nr + 1;
      tab[x] := 1;
    fi;
  od;

  for i in [1 .. n] do
    x := fuseit(bblocks[i] + anr);
    if not made_it[x] and tab[x] = 0 then
      nr := nr + 1;
      tab[x] := 1;
    fi;
  od;
  return nr;
end;


InputForDotString := function(S)
  local one, H;

  one := x -> Idempotents(x)[1];
  H := Filtered(HClasses(S), x -> IsGroupHClass(x) and
                                  NrFloatingBlocks(one(x), one(x)) = 0);

                                  return rec(highlight := [rec(HClasses := H)]);
end;
#end from JDM###################################################################

#from JE########################################################################
NilpotentSemigroup := function(S)
  local n, L, rows,    i,j, res;
  n := Size(S);
  L := AsSortedList(S);
  #(n+1)x(n+1) matrix (intialized with value n+1)
  rows := List([1..n+1], x->ListWithIdenticalEntries(n+1,n+1));
  #just a double loop to have all products
  for i in [1..n] do
    for j in [1..n] do
      if NrFloatingBlocks(L[i],L[j])=0 then
        rows[i][j] := Position(L, L[i]*L[j]);
      fi;
    od;
  od;
  res := List([1..n+1], x->Concatenation(rows[x],[x]));
  return Semigroup(List(res, Transformation));
end;
################################################################################
