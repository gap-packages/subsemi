# finding subsemigroups by recursively deleting entries from
# multiplication tables
MTCutter := function(mt,log, waiting, cutpoints, blocker)
  local cargo,processor,logger,i,duplicates,cclasses,ccl,cut,counter,ext,tab,rn,
        completion,extensions;

  # EMBEDDED FUNCTIONS
  #-----------------------------------------------------------------------------
  #tells what to do when a new complete cut is found ###########################
  processor := function(cut)
    local sub;
    if mt.CONJUGACY then
      ccl := ConjugacyClassOfCut(mt,cut);
      Add(cclasses, ccl);
      for sub in ccl do
        Add(cargo, sub);AddSet(log, sub);
      od;
    else
      Add(cargo, cut);
    fi;
  end;
  #-----------------------------------------------------------------------------
  ### Progress and memoryinfo output ###########################################
  logger := function()
    Print("#Log:", Size(log),"=",
          FormattedMemoryString(MemoryUsage(log)),
          " Dups:", duplicates, " Waiting:", Size(waiting),
          " submts:", Size(cargo));
    if mt.CONJUGACY then Print(" conjcls:",Size(cclasses)); fi;
    Print("\n");
  end;
  #-----------------------------------------------------------------------------

  #initializing variables
  tab := mt.mt; #shortcut to the actual table
  rn := mt.rn; #shortcut to full encoded set
  cargo := [];
  duplicates := 0;
  cclasses := [];
  counter := 0;
  Info(MulTabInfoClass,1, AlgorithmIDString(mt)); #tagging the used methods
  # the main loop
  while not IsEmpty(waiting) do
    cut := Retrieve(waiting); # next cut to be processed
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      logger();
    fi;
    counter := counter + 1; # increasing loop counter
    
    if mt.BLOCKING then
      if IsSubsetBlist(cut,blocker) then continue; fi;#meaning cutting into what is done
    fi;
    
    ### Deciding whether we hit a new one or not ###############################
    if not(cut in log) then
      if mt.CONJUGACY then
        #in case we have the symmetries, then we can close down other branches
        Perform(ConjugacyClassOfCut(mt,cut),function(k)AddSet(log,k);end);
      else
        AddSet(log,cut);
      fi;
    else
      #we again hit something that is already in
      duplicates := duplicates+1;
      continue; #cut the search tree at this point, continue to next waiting cut
    fi;

    ### extending the current cut ##############################################
    completion := Completion(tab,rn,cut);
    extensions := [];
    #if there is nothing to cut, then we have a sub
    if SizeBlist(completion) = 0 then
      processor(cut);
      # if we continue then we just take the remaining elements
      if MTROptions.EXHAUSTIVE then
        for i in  ListBlist(rn,DifferenceBlist(cutpoints, cut)) do
          AddSet(extensions, BlistList(rn,[i]));
        od;
      fi;
    else # the cut does not give a semigroup
      if MTROptions.RESCUE then
        for i in ListBlist(rn,completion) do
          AddSet(extensions, ToRescue(tab,rn,cut,completion,i));
        od;
      else
        #just extend one-by-one
        for i in ListBlist(rn,completion) do
          AddSet(extensions, BlistList(rn,[i]));
        od;
      fi;
    fi;
    #making the extensions into cuts and putting them into waiting list
    for ext in extensions do
      if MTROptions.DIAGONAL then CloseDiagonally(tab,rn,ext); fi;
      Store(waiting, UnionBlist(cut,ext));
    od;
  od;
  if InfoLevel(MulTabInfoClass)>0 then Print("#FINAL");logger();Print("\n");fi;
  return [cargo, cclasses];
end;

# this is the main function to call when reducing a multiplication table
# taking care of setting up the startcuts
# pretty administrative
# arguments:
# 1 - multiplication table
# 2 - start cut
# 3 - prohibited sub
ReduceMulTab := function(arg)
local mt,log,waiting,startcut, cutpoints,i,cut,blocker;
  mt := arg[1]; #the mulitplication table data structure
  #the log keeps track of visited cuts, anything that can do AddSet and in
  log := DynamicIndexedSet([SizeBlist,FirstEntryPosOr1,LastEntryPosOr1]);
  waiting := Stack(); #new cuts waiting to be examined, queue is worse
  ### the main function starts here ############################################
  if IsBound(arg[2]) then
    startcut := BlistList(mt.rn,arg[2]);
    cutpoints := DifferenceBlist(BlistList(mt.rn,mt.rn), startcut);
  else
    startcut := BlistList(mt.rn,[]);
    cutpoints := BlistList(mt.rn,mt.rn);
  fi;
  #blocking
  if IsBound(arg[3]) then
    blocker := AsList(arg[3]);
    blocker := List(blocker, x->Position(mt.sortedts, x));
    #Print("Blocker as list:",String(AsList(blocker)),"\n");
    blocker := BlistList(mt.rn, Difference(mt.rn,blocker));
    #Print("Blocker:",DisplayString(blocker), " for ", String(mt.rn),String(mt.sortedts) ,"\n");
    mt.BLOCKING := true;
  else
    blocker := false;
  fi;
  Info(MulTabInfoClass,2, "Starting from ", startcut);
  for i in ListBlist(mt.rn,cutpoints) do
    cut := UnionBlist([startcut, BlistList(mt.rn,[i])]);
    if MTROptions.DIAGONAL then CloseDiagonally(mt.mt, mt.rn, cut);fi;
    Store(waiting, cut);
  od;
  #when everything is prepared, we just call MTCutter
  return MTCutter(mt,log, waiting, cutpoints,blocker);
end;
