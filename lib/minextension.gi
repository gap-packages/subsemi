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
                                    Stack(),
                                    []);end);
  # TODO:understand why this trick does not work with torsos
  # removing generators that are in the base already
  #generators := DifferenceBlist(generators, baseset);
  # removing equivalent generators
  #generators := RemoveEquivalentGenerators(generators,mt);



InstallGlobalFunction(SubSgpsGenSetsByMinExtensions,
        function(mt) return SubSgpsByMinExtensionsParametrized(mt,
                                    EmptySet(mt),
                                    RemoveEquivalentGenerators(FullSet(mt),mt),
                                    Queue(),
                                    []);end);

BindGlobal("SUBSEMI_MinExtensionsCheckPointData", rec());
ResumeMinExtensions := function()
  return SubSgpsByMinExtensionsParametrized(SUBSEMI_MinExtensionsCheckPointData.mt,
                 [], #this does not matter
                 SUBSEMI_MinExtensionsCheckPointData.generators,
                 SUBSEMI_MinExtensionsCheckPointData.waiting,
                 SUBSEMI_MinExtensionsCheckPointData.result
                 );
end;

# returns all extensions of the given baseset (empty baseset not collected,
# but the closure of the baseset is added to the final result)
# mt - MulTab, multiplication table
# baseset - the elements already in
# generators - the set of possible extending elements from
# waiting - the new and yet unchecked extensions in a stack or a queue
# result - the collected subs so far in a collection admitting AddSet
InstallGlobalFunction(SubSgpsByMinExtensionsParametrized,
function(mt,baseset,generators, waiting, result)
  local gen, # the generator to be added to the base
        counter, # counting the recursive calls
        prev_counter, # the value of counter at previous measurement (log, dump)
        log, # function logging some info to standart output
        secs, prev_secs, # current time in secs and the previous check
        prev_subs, # number of subsemigroups at previous measurement
        gensets, bl, diff,gens,next,isBreadthFirst,checkpoint, main,init,
        normalizer,seed, peeked;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := TimeInSeconds();
    Print("#", FormattedBigNumberString(counter)," #",Size(result)," ",
          FormattedMemoryString(MemoryUsage(result))," ",
          FormattedPercentageString(Size(result)-prev_subs,
                  counter-prev_counter)," ");
    Print(Size(waiting), " ");
    if Size(waiting) > 0 then
      peeked := Peek(waiting);
      if peeked <> fail then
        Print(TrueValuePositionsBlistString(peeked[1]),"+",peeked[2]," ");
      fi;
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
  #binds the internals into global variables and saves the workspace
  checkpoint := function()
    prev_secs := TimeInSeconds();
    SUBSEMI_MinExtensionsCheckPointData.waiting := waiting;
    SUBSEMI_MinExtensionsCheckPointData.result := result;
    SUBSEMI_MinExtensionsCheckPointData.mt := mt;
    SUBSEMI_MinExtensionsCheckPointData.generators := generators;
    SaveWorkspace(Concatenation("checkpoint",String(IO_gettimeofday().tv_sec),".ws"));
    Info(SubSemiInfoClass,1,Concatenation("Checkpoint saved in ",
            FormattedTimeString(TimeInSeconds()-prev_secs)));
    prev_secs:=TimeInSeconds();#resetting the timer not to mess up speed gauge
  end;
  #-----------------------------------------------------------------------------
  init := function()
    result := HeavyBlistContainer();
    #if baseset not empty then close it and add it as a sub
    if SizeBlist(baseset) > 0 then
      seed := ConjugacyClassRep(SgpInMulTab(baseset,mt),mt);
      AddSet(result, seed);
    else
      seed := baseset; 
    fi;
    # fill up the waiting list with lists of 2 or 3 elements: 
    # 1: baseset, 2: gen the element to be extended with, 3: generating set (opt)
    if isBreadthFirst then
      gensets := [];
      for gen in ListBlist(Indices(mt),generators) do
        Store(waiting, [seed, gen,[gen]]);
      od;
    else
      for gen in ListBlist(Indices(mt),generators) do
        Store(waiting, [seed, gen]);
      od;
    fi;
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
      if (counter mod SubSemiOptions.CHECKPOINTFREQ)=0 then checkpoint(); fi;
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
      normalizer := Stabilizer(SymmetryGroup(mt), bl, OnFiniteSet);       
      if Size(normalizer) > 1 then #do it only if it is nontrivial
        #Print(Size(diff));
        diff := List(Orbits(normalizer, diff, OnPoints ), x->x[1]);
        #Print("->",Size(diff)," by " , Size(normalizer),"  ");  
      fi;
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
  isBreadthFirst := IsQueue(waiting);
  if IsEmpty(AsList(result)) and IsEmpty(waiting) then init(); fi; # initialize
  prev_subs:=0;prev_counter:=0;counter:=0;
  prev_secs:=TimeInSeconds();  
  main();
  if InfoLevel(SubSemiInfoClass)>0 and Size(result)>1 then log();fi;
  Info(SubSemiInfoClass,1,Concatenation("Total checks: ",String(counter)));
  if isBreadthFirst then
    return rec(subsgps:=result, gensets:=gensets);
  else
    return result;
  fi;
end);
