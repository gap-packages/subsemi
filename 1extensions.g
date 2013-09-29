#the closure of base the extension to closure (subsgp)
ClosureByMulTab := function(tab, indexlist,base,extension)
  local queue,diff, closure,i,j,val;
  queue := BlistList(indexlist,extension);
  closure := ShallowCopy(base);
  while SizeBlist(queue) > 0 do
    i := Position(queue,true); # it is not empty, so this is ok
    if closure[i] then
      ; #we already have it, nothing to do
    else
      #we calculate the difference induced by 1
      diff := BlistList(indexlist,[i]);
      for j in indexlist do
        if closure[j] then
          val := tab[j][i];
          if not closure[val] then diff[val] := true; fi;
          val := tab[i][j];
          if not closure[val] then diff[val] := true; fi;
        fi;    
      od;
      diff[tab[i][i]] := true;
      UniteBlist(queue, diff);  
    fi;   
    queue[i] := false;
    closure[i] := true;    
  od;
  return closure;
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

# mt - MulTab, multiplication table
SubSgpsBy1Extensions := function(mt)
  local s, L, extend, result,  indexlist, syms,
        counter, log, dump, p_subs, p_counter, dumpcounter, secs, p_secs, tab,
        extend_conjreponly;
  p_subs := 0; p_counter := 0; dumpcounter := 1;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := TimeInSeconds();
    Print("#", FormattedBigNumberString(counter)," subs:",Size(result)," in ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedFloat(Float((100*(Size(result)-p_subs))/(counter-p_counter)))
          ," sgps/100 checks ");
    if (secs-p_secs) > 0 then
      Print(FormattedFloat(Float((Size(result)-p_subs)/(secs-p_secs))),
            " sgps/sec\c\n");
    else
      Print("\c\n");
    fi;
    p_subs := Size(result); p_counter := counter;
    p_secs := TimeInSeconds();
  end;
  #-----------------------------------------------------------------------------
  dump := function() #write all the subsemigroups into a file
    local r,filename,l,i, S,ll,output;
    p_secs := TimeInSeconds();
    filename := Concatenation(Name(mt.ts),"_", String(dumpcounter),"subs");
    output := OutputTextFile(filename, false);
    for r in AsList(result) do
      AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
    od;
    CloseStream(output);
    dumpcounter := dumpcounter + 1;
    Print("#Dumping in ",
          FormattedTimeString(TimeInSeconds()-p_secs),"\n");
    #resetting the timer no to mess up the speed gauge 
    p_secs := TimeInSeconds();
  end;
  #-----------------------------------------------------------------------------
  #ORIGINAL
  extend := function(base,s)
    local t, bl;
    #HOUSEKEEPING: logging, dumping
    counter := counter + 1;
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      log();
    fi;
    if (counter mod MTROptions.DUMPFREQ)=0 then dump(); fi;
    #calculating the new subsgp
    bl := ClosureByMulTab(tab, indexlist, base, [s]);
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    #STORE
    AddSet(result, bl);
    Perform(List(syms, g -> OnFiniteSet(bl,g)),function(b)AddSet(result,b);end);
    #RECURSION
    for t in Difference(indexlist, ListBlist(indexlist,bl)) do
      extend(bl,t);
    od;
  end;
  #-----------------------------------------------------------------------------
  extend_conjreponly := function(base,s)
    local C,  bl;
    #HOUSEKEEPING: logging, dumping
    counter := counter + 1;
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      log();
    fi;
    if (counter mod MTROptions.DUMPFREQ)=0 then dump(); fi;
    #calculating the new subsgp
    bl := ClosureByMulTab(tab, indexlist, base, [s]);
    #its conjugacy class
    C := [bl];
    Perform(syms, function(g) AddSet(C,OnFiniteSet(bl,g));end);
    bl := C[1]; #the canonical rep
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    #STORE
    AddSet(result, bl);
    #RECURSION
    Perform(Difference(indexlist, ListBlist(indexlist,bl)),
            function(t) extend_conjreponly(bl,t);end);
  end;
  #-----------------------------------------------------------------------------

  if not HasName(mt.ts) then #enforcing proper naming of the semigroup
    Print("#Semigroup has no name. Dump would fail!");
    return fail;
  fi;
  L := mt.sortedts;
  syms := mt.syms;
  indexlist := mt.rn;
  tab := mt.mt;
  result := DynamicIndexedSet([SizeBlist,FirstEntryPosOr1,LastEntryPosOr1]);
    #IndexedSet(13,BinaryBlistIndexer(13), ListWithIdenticalEntries(13,2));
  counter := 0;
  p_secs := TimeInSeconds();
  for s in indexlist do
    Print("# ", String(s),"/",String(Size(indexlist)),"\n");
    #if IsEmpty(syms)
    extend_conjreponly(BlistList(indexlist, []),s);
  od;
  log();
  dump();
  return result;
end;
