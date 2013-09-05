SubSgpsBy1Extensions := function(S)
  local s, lS, extend, result, counter, logger, range, 
        dumper, p_subs,p_counter;
  p_subs := 0; p_counter := 0;
  #-----------------------------------------------------------------------------
  logger := function()
    Print("#", FormattedBigNumberString(counter)," subs:",Size(result)," in ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedFloat(Float((100*(Size(result)-p_subs))/(counter-p_counter)))
          ," sgps/100 checks\c\n");
    p_subs := Size(result); p_counter := counter;
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
  result := MultiGradedSet([SizeBlist,FirstEntry,LastEntry]);#[];
  counter := 0;
  for s in lS do
    extend([s]);
  od;
  logger();
  #dumper();
  return result;
end;
