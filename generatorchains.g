# type of the chain is the integer list containig the sizes of subsemigroups
GeneratorChain := function(S)
  local genchain,lS, extend, id, result, sgps,type, types;
  #-----------------------------------------------------------------------------
  #extend a generator chain
  extend := function(genchain)
    local T, diff, sizes,pos;
    T := Semigroup(genchain);
    diff := Difference(lS, AsList(T));
    if not IsEmpty(diff) then
      sizes := List(diff, t->Size(ClosureSemigroup(T,[t]))-Size(T));
      for pos in Positions(sizes, Minimum(sizes)) do
        Add(genchain, diff[pos]);
        extend(genchain);
        Remove(genchain);
      od;
    else
      #process
      sgps := List([1..Size(genchain)], x-> Semigroup(genchain{[1..x]}));
      type := List(sgps, Size);
      if not (type in types) then
        Display(type); # for the impatient
        Add(result, ShallowCopy(genchain));
        AddSet(types, type);
      fi;
    fi;
  end;
  #-----------------------------------------------------------------------------
  lS := AsList(S);
  result := [];
  types := [];
  #starting from all idempotents - they are minimal subsemigroups
  for id in Idempotents(S) do
    extend([id]);
  od;
  return result;
end;

# returns an element t from T\<genset> such that <genset,t> is as small
# as possible
RandomMinimalGeneratorSetExtension := function(genset,T)
local S, diff, sizes;
  S := Semigroup(genset);
  #sanity check: if not a proper subsemigroup then we cannot extend
  if Size(S) = Size(T) then return fail; fi;
  # calculating T minus S
  diff := Difference(AsList(T), AsList(S));
  # all possible one element extensions
  sizes := List(diff, t->Size(ClosureSemigroup(S,[t]))-Size(S));
  # returning a random one from the set of minimal extensions
  return diff[Random(Positions(sizes, Minimum(sizes)))];
end;

RandomMinimalGeneratorSetChain := function(T)
local gc, ext;
  gc := [Random(Idempotents(T))];
  ext := RandomMinimalGeneratorSetExtension(gc,T);
  while ext <> fail do
    Add(gc,ext);
    ext := RandomMinimalGeneratorSetExtension(gc,T);
  od;
  return gc;
end;

MinimalSubsemigroupChain := function(gensetchain)
  return List([1..Size(gensetchain)],
              x->Semigroup(gensetchain{[1..x]}));
end;

SubSgpsBy1Extensions := function(S)
  local s, lS, extend, result, counter, logger, range, dumper;
  #-----------------------------------------------------------------------------
  logger := function()
    Print("#", counter, " subs:", Size(result), " in ",
          FormattedMemoryString(MemoryUsage(result)),"\c\n");
  end;
  #-----------------------------------------------------------------------------
  dumper := function()
    local r,filename;
    filename := Concatenation(Name(S),"subs.gz");
    for r in AsList(result) do
      WriteSemigroups(filename, Semigroup(lS{ListBlist(range,r)}));
    od;
  end;
  #-----------------------------------------------------------------------------
  extend := function(genchain)
    local T, t, bl;
    counter := counter + 1;
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      logger();
    fi;
    T := AsList(Semigroup(genchain));
    bl := BlistList(range, List(T,x->Position(lS,x)));
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    AddSet(result, bl);
    for t in Difference(lS, T) do
      Add(genchain, t);
      extend(genchain);
      Remove(genchain);
    od;
  end;
  #-----------------------------------------------------------------------------
  if not HasName(S) then Print("#Semigroup has no name. Dumper will fail!"); fi;
  lS := AsList(S);
  range := [1..Size(lS)];
  result := MultiGradedSet([SizeBlist,FirstEntryPlusOne]);#[];
  counter := 0;
  for s in lS do
    extend([s]);
  od;
  logger();
  dumper();
  return result;
end;
