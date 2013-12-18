# mt - MulTab, multiplication table
InstallGlobalFunction(SubSgpsBy1Extensions,
        function(mt) return SubSgpsBy1ExtensionsWithLimitSet(mt,
                                    BlistList(Indices(mt), []),
                                    FullSet(mt));end);

# mt - MulTab, multiplication table
# limitset - the set where to get the extending elements from
InstallGlobalFunction(SubSgpsBy1ExtensionsWithLimitSet,
function(mt,startset,limitset)
  local s, extend, result, counter, log, dump, p_subs, p_counter, dumpcounter,
        secs, p_secs, fileextension, dosyms;
  p_subs := 0; p_counter := 0; dumpcounter := 1;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := TimeInSeconds();
    Print("#", FormattedBigNumberString(counter)," #",Size(result)," ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedPercentageString(Size(result)-p_subs,counter-p_counter)," ");
    if (secs-p_secs) > 0 then
      Print(FormattedFloat(Float((Size(result)-p_subs)/(secs-p_secs))),
            "/s\c\n");
    else
      Print("\c\n");
    fi;
    p_subs := Size(result); p_counter := counter;
    p_secs := TimeInSeconds();
  end;
  #-----------------------------------------------------------------------------
  dump := function() #write all the subsemigroups into a file
    local r,l,i, S,ll,output;
    p_secs := TimeInSeconds();
    if not HasOriginalName(mt) then
      Info(SubSemiInfoClass,1,"# No name, no dump!"); return;
    fi;
    output := OutputTextFile(Concatenation(OriginalName(mt),"_",
                        String(dumpcounter),fileextension), false);
    for r in AsList(result) do
      AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
    od;
    CloseStream(output);
    dumpcounter := dumpcounter + 1;
    Info(SubSemiInfoClass,1,Concatenation("#Dumping in ",
          FormattedTimeString(TimeInSeconds()-p_secs)));
    #resetting the timer no to mess up the speed gauge 
    p_secs := TimeInSeconds();
  end;
  #-----------------------------------------------------------------------------
  extend := function(base,s)
    local class, bl, diff,flag,i;
    #HOUSEKEEPING: logging, dumping
    counter := counter + 1;
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      log();
    fi;
    if (counter mod SubSemiOptions.DUMPFREQ)=0 then dump(); fi;
    #calculating the new subsgp
    bl := ClosureByQueue(base, [s], mt);
    #its conjugacy class rep
    if dosyms then bl := ConjugacyClassRep(bl,mt);fi;
    if  bl in result then
      return; #just bail out if we already have it
    fi;
    #STORE
    AddSet(result, bl);
    #REMAINDER
    diff := DifferenceBlist(limitset, bl);
    #REDUCTION
    for class in EquivalentGenerators(mt) do #keep max one from each equiv class
      flag := false;
      for i in class  do
        if diff[i] then
          if flag then diff[i] := false; else flag := true;fi;
        fi;
      od;
    od;
    #RECURSION
    Perform(ListBlist(Indices(mt),diff), function(t) extend(bl,t);end);
  end;
  #-----------------------------------------------------------------------------
  #MAIN
  if Size(Symmetries(mt)) = 1 then
    dosyms := false;
    fileextension := ".subs";
  else
    dosyms := true;
    fileextension := ".reps";
  fi;
  result := HeavyBlistContainer();
  counter := 0;
  p_secs := TimeInSeconds();
  for s in ListBlist(Indices(mt),DifferenceBlist(limitset, startset)) do
    Info(SubSemiInfoClass,1,
         Concatenation("# ",String(s),"/",String(Size(Indices(mt)))));#TODO fix
    extend(startset,s);
  od;
  if InfoLevel(SubSemiInfoClass)>0 then log();fi;
  dump();
  Info(SubSemiInfoClass,1,Concatenation("# Total checks: ",String(counter)));
  return result;
end);
