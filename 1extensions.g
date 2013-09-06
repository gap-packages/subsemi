# S  - a semigroup
SubSgpsBy1Extensions := function(S)
  local s, L, extend, result,  indices,
        counter, log, dump, p_subs, p_counter, dumpcounter;
  p_subs := 0; p_counter := 0; dumpcounter := 1;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    Print("#", FormattedBigNumberString(counter)," subs:",Size(result)," in ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedFloat(Float((100*(Size(result)-p_subs))/(counter-p_counter)))
          ," sgps/100 checks\c\n");
    p_subs := Size(result); p_counter := counter;
  end;
  #-----------------------------------------------------------------------------
  dump := function() #write all the subsemigroups into a file
    local r,filename;
    filename := Concatenation(Name(S),"_", String(dumpcounter),"_subs.gz");
    for r in AsList(result) do
      WriteSemigroups(filename, Semigroup(L{ListBlist(indices,r)}));
    od;
    dumpcounter := dumpcounter + 1;
  end;
  #-----------------------------------------------------------------------------
  extend := function(genchain)
    local T, t, bl;
    counter := counter + 1;
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      log();
    fi;
    if (counter mod MTROptions.LOGFREQ)=0 then dump(); fi;
    T := AsList(Semigroup(genchain));
    bl := BlistList(indices, List(T,x->Position(L,x)));
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    AddSet(result, bl);
    for t in Difference(L, T) do
      Add(genchain, t);
      extend(genchain);
      Remove(genchain);
    od;
  end;
  #-----------------------------------------------------------------------------
  if not HasName(S) then #enforcing proper naming of the semigroup
    Print("#Semigroup has no name. Dump would fail!");
    return fail;
  fi;
  L := AsSortedList(S);
  indices := [1..Size(L)];
  result := MultiGradedSet([SizeBlist,FirstEntry,LastEntry]);#[];
  counter := 0;
  for s in L do
    extend([s]);
  od;
  log();
  dump();
  return result;
end;
