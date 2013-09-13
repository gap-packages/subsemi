#
Diff1Step := function(tab, indexlist, base, extender)
  local diff, rowndx,columnndx,i,val;
  #if the extender is already in base then there is nothing to do
  if base[extender] then
    return BlistList(indexlist,[]);;
  fi;
  diff := BlistList(indexlist,[extender]);
  for i in indexlist do
    if base[i] then
      val := tab[i][extender];
      if not base[val] then diff[val] := true; fi;
      val := tab[extender][i];
      if not base[val] then diff[val] := true; fi;
    fi;    
  od;
  diff[tab[extender][extender]] := true;
  return diff;
end;

#the closure of the set (subsgp)
ClosureByMulTab := function(tab, indexlist,base,extension)
  local queue,diff1step, nbase,i;
  queue := BlistList(indexlist,extension);
  nbase := ShallowCopy(base);
  while SizeBlist(queue) > 0 do
    i := FirstEntry(queue);
    diff1step := Diff1Step(tab, indexlist,nbase, i);
    UniteBlist(queue, diff1step);
    queue[i] := false;
    nbase[i] := true;    
  od;
  return nbase;
end;

GenerateSg := function(tab, indexlist,gens)
  return ClosureByMulTab(tab, indexlist,BlistList(indexlist,[]),gens );
end;


TestGenerateSg := function(mt)
  local gens,numofgens,blT,T;
  numofgens := Random([1..7]);
  gens := DuplicateFreeList(List([1..numofgens], x->Random(mt.rn)));
  blT := GenerateSg(mt.mt, mt.rn, gens);
  T := Semigroup(List(gens, x->mt.sortedts[x]));
  return blT = BlistList(mt.rn, List(AsList(T), t->Position(mt.sortedts,t)));
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
