################################################################################
##
## SubSemi
##
## Enumerating subsemigroups by recursively extending with a generator.
##
## Copyright (C) 2013-2017  Attila Egri-Nagy
##

# depth-first search of nonempty subsemigroups
InstallGlobalFunction(SubSgpsByMinExtensions,
function(mt) return SubSgpsByMinExtensionsParametrized(
                            mt,
                            EmptySet(mt),
                            DistinctGenerators(FullSet(mt),mt),
                            Stack(),
                            BlistStorage(Size(mt)),
                            []);
end);

# depth-first search of subsemigroups containing the given subset
# in case of nontrivial symmetries conjugacy representative subsgps may not
# contain the given set
InstallGlobalFunction(SubSgpsContaining,
function(set,mt)
  return SubSgpsByMinExtensionsParametrized(
                 mt,
                 BlistConjClassRep(set,mt),
                 DistinctGenerators(FullSet(mt),mt),
                 Stack(),
                 BlistStorage(Size(mt)),
                 []);
end);

# depth-first search of nonempty subsemigroups of a given subsemigroup
# in a bigger semigroup (defined by the multiplication table)
# purpose: to minimize the need for recoding the results
InstallGlobalFunction(SubsOfSubInAmbientSgp,
function(sgp,mt)
  #sanity check that sgp is really a sub (it doesn't generate anything bigger)
  if (SizeBlist(sgp) <> SizeBlist(SgpInMulTab(sgp,mt))) then return fail; fi;
  return SubSgpsByMinExtensionsParametrized(
                 mt,
                 EmptySet(mt),
                 DistinctGenerators(sgp,mt),
                 Stack(),
                 BlistStorage(SizeBlist(sgp)),
                 []);
end);

#global datastructure for resuming search
BindGlobal("SUBSEMI_MinExtensionsCheckPointData", rec());
ResumeMinExtensions := function()
  return SubSgpsByMinExtensionsParametrized(
                 SUBSEMI_MinExtensionsCheckPointData.mt,
                 [], #this does not matter
                 SUBSEMI_MinExtensionsCheckPointData.generators,
                 SUBSEMI_MinExtensionsCheckPointData.waiting,
                 SUBSEMI_MinExtensionsCheckPointData.db,
                 SUBSEMI_MinExtensionsCheckPointData.result);
end;

# returns all extensions of the given baseset (empty baseset not collected,
# but the closure of the baseset is added to the final result)
# mt - MulTab, multiplication table
# baseset - the seeding set of elements
# generators - the set of possible extending elements from
# waiting - the new and yet unchecked extensions in a some data structure
# result - the collected subs so far in a collection admitting AddSet
InstallGlobalFunction(SubSgpsByMinExtensionsParametrized,
function(mt,seed,generators, waiting, db, result)
  local gen, # the generator to be added to the base
        counter, # counting the recursive calls
        prev_counter, # the value of counter at previous measurement (log, dump)
        log, # function logging some info to standart output
        secs, prev_secs, # current time in secs and the previous check
        prev_subs, # number of subsemigroups at previous measurement
        gensets, bl, diff,gens,next,checkpoint, main,init,
        normalizer, peeked;
  #-----------------------------------------------------------------------------
  log := function() #put some information on the screen
    secs := TimeInSeconds();
    Print("#", BigNumberString(counter)," #",Size(result)," ",
          MemoryString(MemoryUsage(result))," ");
    Print(Size(waiting), " ");
    if Size(waiting) > 0 then
      peeked := Peek(waiting);
      if peeked <> fail then
        Print(TrueValuePositionsBlistString(peeked));
      fi;
    fi;
    if (secs-prev_secs) > 0 then # printing speed only if it measurable
      Print(Float(Float((Size(result)-prev_subs)/(secs-prev_secs))),
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
    SUBSEMI_MinExtensionsCheckPointData.db := db;
    SUBSEMI_MinExtensionsCheckPointData.mt := mt;
    SUBSEMI_MinExtensionsCheckPointData.generators := generators;
    SaveWorkspace(Concatenation("checkpoint",
            String(IO_gettimeofday().tv_sec),".ws"));
    Info(SubSemiInfoClass,1,Concatenation("Checkpoint saved in ",
            TimeString(TimeInSeconds()-prev_secs)));
    prev_secs:=TimeInSeconds();#resetting the timer not to mess up speed gauge
  end;
  #-----------------------------------------------------------------------------
  init := function()
    for gen in ListBlist(Indices(mt), DifferenceBlist(generators,seed)) do
      Store(waiting, BlistConjClassRep(
              ClosureByIncrements(seed,gen,mt),mt));
    od;
  end;
  #-----------------------------------------------------------------------------
  # THE MAIN LOOP - the graph search
  main := function()
    while not IsEmpty(waiting) do
      #HOUSEKEEPING: logging, dumping, checkpointing
      counter := counter + 1;
      if InfoLevel(SubSemiInfoClass)>0
         and (counter mod SubSemiOptions.LOGFREQ)=0 then
        log();
      fi;
      if (counter mod SubSemiOptions.CHECKPOINTFREQ)=0 then checkpoint(); fi;
      #PROCESSING next waiting element
      bl := Retrieve(waiting);
      if  IsInBlistStorage(db,bl) then continue; fi; #EXIT if nothing to do
      #STORING new subsgp
      Add(result, bl);
      StoreBlist(db,bl);
      #REMAINDER elts for further extensions
      diff := ListBlist(Indices(mt),DifferenceBlist(generators, bl));
      normalizer := Stabilizer(SymmetryGroup(mt), bl, OnBlist);
      if Size(normalizer) > 1 then #do it only if it is nontrivial
        diff := List(Orbits(normalizer, diff, OnPoints ), x->x[1]);
      fi;
      #RECURSION
      Perform(diff,
              function(t) Store(waiting,
                      BlistConjClassRep(
                              ClosureByIncrements(bl,t,mt),mt));end);
    od;
  end;
  #-----------------------------------------------------------------------------
  # START
  if IsEmpty(result) and IsEmpty(waiting) then init(); fi; # initialize
  prev_subs:=0;prev_counter:=0;counter:=0;
  prev_secs:=TimeInSeconds();
  main();
  if InfoLevel(SubSemiInfoClass)>0 and Size(result)>1 then log();fi;
  Info(SubSemiInfoClass,1,Concatenation("Total checks: ",String(counter)));
  return result;
end);

# a wasteful implementation
SubSgpsIncreasingOrder := function(mt)
  local f;
  f := function(A,B)
    return SizeBlist(A) > SizeBlist(B);
  end;
  return SubSgpsByMinExtensionsParametrized(mt,
                 EmptySet(mt),
                 DistinctGenerators(FullSet(mt),mt),
                 PriorityQueue(f, x->false),
                 BlistStorage(Size(mt)),[]);
end;
