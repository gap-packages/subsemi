################################################################################
##
## SubSemi
##
## Enumerating subsemigroups by recursively extending with a generator.
##
## Copyright (C) 2013-2014  Attila Egri-Nagy
##

# mt - MulTab, multiplication table
InstallGlobalFunction(SubSgpsByMinClosures,
        function(mt) return SubSgpsByMinClosuresParametrized(mt,
                                    EmptySet(mt),
                                    FullSet(mt),
                                    Stack());end);

InstallGlobalFunction(SubSgpsGenSetsByMinClosures,
        function(mt) return SubSgpsByMinClosuresParametrized(mt,
                                    EmptySet(mt),
                                    FullSet(mt),
                                    Queue());end);

# mt - MulTab, multiplication table
# baseset - the elements already in
# generators - the set of possible extending elements from
InstallGlobalFunction(SubSgpsByMinClosuresParametrized,
function(mt,baseset,generators, waiting)
  local gen, # the generator to be added to the base
        result, # container for the end result, the subsemigroups
        counter, # counting the recursive calls
        prev_counter, # the value of counter at previous measurement (log, dump)
        log, # function logging some info to standart output
        dump, # writing the found subsemigroups to a file
        dumpcounter, # counting the number of dumps so far
        fileextension, # reps for conjugacy class reps, subs otherwise
        secs, prev_secs, # current time in secs and the previous check
        prev_subs, # number of subsemigroups at previous measurement
        dosyms, # flag showing whether we do nontrivial conjugacy classes
        gensets, class, bl, diff,flag,i,base,s,gens,next,isBreadthFirst;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := TimeInSeconds();
    Print("#", FormattedBigNumberString(counter)," #",Size(result)," ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedPercentageString(Size(result)-prev_subs,
                  counter-prev_counter)," ");
    Print(Size(waiting), " ");
    if (secs-prev_secs) > 0 then # printing speed only if it measurable
      Print(FormattedFloat(Float((Size(result)-prev_subs)/(secs-prev_secs))),
            "/s\c\n");
    else
      Print("\c\n");
    fi;
    prev_subs:=Size(result);prev_counter:=counter;prev_secs:=TimeInSeconds();
  end;
  #-----------------------------------------------------------------------------
  dump := function(isfinal) #write all the subsemigroups into a file
    local r,l,i, S,ll,output;
    prev_secs := TimeInSeconds();
    if not HasOriginalName(mt) then
      Info(SubSemiInfoClass,1,"No name, no dump!"); return;
    fi;
    dumpcounter := dumpcounter + 1;
    if isfinal then #for the last one we do not count dumping
      output := OutputTextFile(Concatenation(OriginalName(mt),
                        fileextension), false);
    else
      output := OutputTextFile(Concatenation(OriginalName(mt),"_",
                        String(dumpcounter),fileextension), false);
    fi;
    for r in AsList(result) do
      AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
    od;
    CloseStream(output);
    Info(SubSemiInfoClass,1,Concatenation("Dumping in ",
          FormattedTimeString(TimeInSeconds()-prev_secs)));
    prev_secs:=TimeInSeconds();#resetting the timer not to mess up speed gauge
  end;
  #-----------------------------------------------------------------------------
  #MAIN
  if IsStack(waiting) then
    isBreadthFirst := false;
  else
    isBreadthFirst := true;
  fi;
  if Size(Symmetries(mt)) = 1 then
    dosyms := false;fileextension := ".subs";
  else
    dosyms := true;fileextension := ".reps";
  fi;
  result := HeavyBlistContainer();
  if IsClosedSubTable(baseset, mt) then
    AddSet(result,ConjugacyClassRep(baseset,mt));
  fi;
  prev_subs:=0;prev_counter:=0;dumpcounter:=0;counter:=0;
  prev_secs:=TimeInSeconds();
  # removing generators that are in the base already
  generators := DifferenceBlist(generators, baseset); 
  if isBreadthFirst then
    gensets := [];  
    for gen in ListBlist(Indices(mt),generators) do
      Store(waiting, [baseset, gen,[gen]]);
    od;
  else
    for gen in ListBlist(Indices(mt),generators) do
      Store(waiting, [baseset, gen]);
    od;    
  fi;
  while not IsEmpty(waiting)do 
    #HOUSEKEEPING: logging, dumping
    counter := counter + 1;
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      log();
    fi;
    if (counter mod SubSemiOptions.DUMPFREQ)=0 then dump(false); fi;
    #calculating the new subsgp
    next := Retrieve(waiting);
    base := next[1];
    s := next[2];
    bl := ClosureByIncrements(base, [s], mt);
    #its conjugacy class rep
    if dosyms then bl := ConjugacyClassRep(bl,mt);fi;
    #EXIT if nothing to do
    if  bl in result then continue; fi;
    #STORE
    if isBreadthFirst then gens := next[3]; Add(gensets,gens);fi;
    AddSet(result, bl);
    #REMAINDER
    diff := DifferenceBlist(generators, bl);
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
    if isBreadthFirst then
      Perform(ListBlist(Indices(mt),diff), function(t) Store(waiting,[bl,t,Concatenation(gens,[t])]);end);    
    else
      Perform(ListBlist(Indices(mt),diff), function(t) Store(waiting,[bl,t]);end);    
    fi;
  od;
  if InfoLevel(SubSemiInfoClass)>0 and Size(result)>1 then log();fi;
  dump(true);#the final dump
  Info(SubSemiInfoClass,1,Concatenation("Total checks: ",String(counter)));
  if isBreadthFirst then
    return [result, gensets];
  else
    return result;
  fi;
end);
