################################################################################
##
## SubSemi
##
## Enumerating subsemigroups by recursively extending with a generator.
##
## Copyright (C) 2013-2014  Attila Egri-Nagy
##

# mt - MulTab, multiplication table
InstallGlobalFunction(SubSgpsByMinExtensions,
        function(mt) return SubSgpsByMinExtensionsParametrized(mt,
                                    EmptySet(mt),
                                    RemoveEquivalentGenerators(FullSet(mt),mt),
                                    Stack());end);
  # TODO:understand why this trick does not work with torsos
  # removing generators that are in the base already
  #generators := DifferenceBlist(generators, baseset);
  # removing equivalent generators
  #generators := RemoveEquivalentGenerators(generators,mt);



InstallGlobalFunction(SubSgpsGenSetsByMinExtensions,
        function(mt) return SubSgpsByMinExtensionsParametrized(mt,
                                    EmptySet(mt),
                                    RemoveEquivalentGenerators(FullSet(mt),mt),
                                    Queue());end);

# mt - MulTab, multiplication table
# baseset - the elements already in
# generators - the set of possible extending elements from
InstallGlobalFunction(SubSgpsByMinExtensionsParametrized,
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
        gensets, bl, diff,gens,next,isBreadthFirst,checkpoint, main;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := TimeInSeconds();
    Print("#", FormattedBigNumberString(counter)," #",Size(result)," ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedPercentageString(Size(result)-prev_subs,
                  counter-prev_counter)," ");
    Print(Size(waiting), " ");
    if Size(waiting) > 0 then
      Print(TrueValuePositionsBlistString(Peek(waiting)[1])," ");
    fi;
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
  #binds the internals into global variables and saves the workspace
  checkpoint := function()
    prev_secs := TimeInSeconds();
    BindGlobal("SUBSEMI_waiting",waiting);
    BindGlobal("SUBSEMI_result",result);
    BindGlobal("SUBSEMI_mt",mt);
    SaveWorkspace(Concatenation("checkpoint",String(IO_gettimeofday().tv_sec),".ws"));
    Info(SubSemiInfoClass,1,Concatenation("Checkpoint saved in ",
            FormattedTimeString(TimeInSeconds()-prev_secs)));
    UnbindGlobal("SUBSEMI_waiting");
    UnbindGlobal("SUBSEMI_result");
    UnbindGlobal("SUBSEMI_mt");
    prev_secs:=TimeInSeconds();#resetting the timer not to mess up speed gauge
  end;
  #-----------------------------------------------------------------------------
  # THE MAIN LOOP - the graph search
  main := function()
    while not IsEmpty(waiting)do
      #HOUSEKEEPING: logging, dumping, checkpointing
      counter := counter + 1;
      if InfoLevel(SubSemiInfoClass)>0
         and (counter mod SubSemiOptions.LOGFREQ)=0 then
        log();
      fi;
      if (counter mod SubSemiOptions.DUMPFREQ)=0 then dump(false); fi;
      #calculating the new subsgp
      next := Retrieve(waiting);
      bl := ClosureByIncrements(next[1], [next[2]], mt);
      #its conjugacy class rep
      bl := ConjugacyClassRep(bl,mt);
      if  bl in result then continue; fi; #EXIT if nothing to do
      #STORE
      if isBreadthFirst then gens := next[3]; Add(gensets,gens);fi;
      AddSet(result, bl);
      #REMAINDER
      diff := ListBlist(Indices(mt),DifferenceBlist(generators, bl));
      #RECURSION
      if isBreadthFirst then
        Perform(diff,
                function(t)Store(waiting,[bl,t,Concatenation(gens,[t])]);end);
      else
        Perform(diff,function(t)Store(waiting,[bl,t]);end);
      fi;
    od; 
  end;
  #-----------------------------------------------------------------------------
  # START
  #which search method are we doing?
  if IsStack(waiting) then
    isBreadthFirst := false;
  else
    isBreadthFirst := true;
  fi;
  #do we have nontrivial symmetries?
  if Size(Symmetries(mt)) = 1 then
    fileextension := ".subs";
  else
    fileextension := ".reps";
  fi;
  result := HeavyBlistContainer();
  #the baseset might be closed, in that case it is a sub
  if IsClosedSubTable(baseset, mt) then
    AddSet(result,ConjugacyClassRep(baseset,mt));
  fi;
  prev_subs:=0;prev_counter:=0;dumpcounter:=0;counter:=0;
  prev_secs:=TimeInSeconds();
  # fill up the waiting list with lists of 2 or 3 elements: 
  # 1: baseset, 2: gen the element to be extended with, 3: generating set (opt)
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
  main();
  if InfoLevel(SubSemiInfoClass)>0 and Size(result)>1 then log();fi;
  dump(true);#the final dump
  Info(SubSemiInfoClass,1,Concatenation("Total checks: ",String(counter)));
  if isBreadthFirst then
    return rec(subsgps:=result, gensets:=gensets);
  else
    return result;
  fi;
end);
