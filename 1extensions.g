#bitstring stuff
CODEKEY := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz23456789_-+=";

EncodeBitString := function (bitstr)
  local str,k,i,chunk;
  k := Int(Length(bitstr)/6);
  str := "";
  for i in [1..k] do
    chunk := List(bitstr{[(6*(i-1))+1..6*i]},
                  function(x)if x='0' then return 0; else return 1;fi;end);
    Add(str,CODEKEY[Sum(List([0..5],x->2^x*chunk[x+1]))+1]);
  od;
  return Concatenation(str,bitstr{[6*k+1..Length(bitstr)]});
end;

DecodeBitString := function(str)
  local bitstr,c,p,i,l;
  bitstr := "";
  for c in str do
    if c in "01" then
      Add(bitstr, c);
    else
      p := Position(CODEKEY,c);
      l := "";
      for i in Reversed([0..5]) do
        if p > 2^i then
          Add(l,'1');
          p := p - 2^i;
        else
          Add(l,'0');
        fi;
      od;
      Append(bitstr, Reversed(l));
    fi;
  od;
  return bitstr;
end;

AsBitString := function(blist)
  return List(blist,
              function(x)
                if x then
                  return '1';
                else
                  return '0';
                fi;
              end);
end;
            
AsBlist := function(bitstr)
  return BlistList([1..Size(bitstr)],Positions(bitstr,'1'));
end;

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

# mt - MulTab, multiplication table
SubSgpsBy1Extensions := function(mt)
  local s, L, extend, result,  indexlist, syms,
        counter, log, dump, p_subs, p_counter, dumpcounter, secs, p_secs, tab;
  p_subs := 0; p_counter := 0; dumpcounter := 1;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := IO_gettimeofday().tv_sec;
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
    p_subs := Size(result); p_counter := counter; p_secs := secs;
  end;
  #-----------------------------------------------------------------------------
  dump := function() #write all the subsemigroups into a file
    local r,filename,l,i, S,ll,output;
    filename := Concatenation(Name(mt.ts),"_", String(dumpcounter),"subs");
    output := OutputTextFile(filename, false);
    for r in AsList(result) do
      AppendTo(output, AsBitString(r),"\n");
    od;
    CloseStream(output);
    dumpcounter := dumpcounter + 1;
    p_secs := secs; #resetting the timer no to mess up the speed gauge 
  end;
  #-----------------------------------------------------------------------------
  extend := function(base,s)
    local T, t, bl;
    counter := counter + 1;
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      log();
            Print("#",base);
    fi;
    if (counter mod MTROptions.DUMPFREQ)=0 then dump(); fi;
    bl := ClosureByMulTab(tab, indexlist, base, [s]);
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    AddSet(result, bl);
    Perform(List(syms, g -> OnFiniteSet(bl,g)),function(b)AddSet(result,b);end);
    for t in Difference(indexlist, ListBlist(indexlist,bl)) do
      extend(bl,t);
    od;
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
  result := MultiGradedSet([SizeBlist,FirstEntry,LastEntry]);#[];
  counter := 0;
  p_secs := IO_gettimeofday().tv_sec;
  for s in indexlist do
    Print("# ", String(s),"/",String(Size(indexlist)),"\n");
    extend(BlistList(indexlist, []),s);
  od;
  log();
  dump();
  return result;
end;
