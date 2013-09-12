ClosureByMulTab := function(tab, indexlist, set)
local rowndx, columnndx, row, closure;
  closure := BlistList(indexlist,[]);
  for rowndx in rn do
    if not (cut[rowndx]) then
      row := tab[rowndx];
      for columnndx in rn do
        if (not (cut[columnndx])) and (cut[row[columnndx]]) then
          #we found a conflicting element outside the cut
          completion[rowndx] := true;#Add(completion, rowndx);
          completion[columnndx] := true;#Add(completion, columnndx);
        fi;
      od;
    fi;
  od;
  return completion;
end;

# S  - a semigroup
SubSgpsBy1Extensions := function(S,G)
  local s, L, extend, result,  indices, syms,
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
    filename := Concatenation(Name(S),"_", String(dumpcounter),"subs");
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
    if (counter mod MTROptions.DUMPFREQ)=0 then dump(); fi;
    T := AsList(Semigroup(genchain));
    bl := BlistList(indices, List(T,x->Position(L,x)));
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    AddSet(result, bl);
    Perform(List(syms, g -> BlistList(indices,List(ListBlist(indices,bl), x->x^g))),
            function(b)AddSet(result,b);end);
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
  syms := NonTrivialSymmetriesOfElementIndices(S,G);
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
