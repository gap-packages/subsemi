# finding subsemigroups by recursively deleting entries from
# multiplication tables
ReduceMulTab := function(arg)
local log,cargo,processor,i,duplicates,cclasses,ccl,startcut,waiting,cut,
      cutpoints,counter,mt,ext,tab,kut,rn, newcut,completion,extensions;
  mt := arg[1]; #the mulitplication table data structure
  tab := mt.mt; #shortcut to the actual table
  rn := mt.rn; #shortcut to full encoded set
  #the log keeps track of visited cuts, n sorted lists for each size of cut
  log := MultiGradedSet([SizeBlist,FirstEntryPlusOne]);
  cargo := [];
  duplicates := 0;
  cclasses := [];
  counter := 0;
  waiting := Stack();#new cuts waiting to be examined
  Info(MulTabInfoClass,1, AlgorithmIDString(mt));
  #-----------------------------------------------------------------------------
  #tells what to do when a new complete cut is found
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
  ### the main function starts here ############################################
  if IsBound(arg[2]) then
    startcut := BlistList(rn,arg[2]);
    cutpoints := DifferenceBlist(BlistList(rn,rn), startcut);
  else
    cutpoints := BlistList(rn,rn);
    startcut := BlistList(rn,[]);
  fi;
  Info(MulTabInfoClass,2, "Starting from ", startcut);
  for i in ListBlist(rn,cutpoints) do
    kut := UnionBlist([startcut, BlistList(rn,[i])]);
    if MTROptions.DIAGONAL then CloseDiagonally(tab, rn, kut);fi;
    #Info(MulTabInfoClass,2, "Fresh cut with ", i);
    Store(waiting, kut);
  od;
  while not IsEmpty(waiting) do
    cut := Retrieve(waiting);
    ### Progress and memoryinfo output #########################################
    counter := counter + 1;
    if InfoLevel(MulTabInfoClass)>0 and (counter mod MTROptions.LOGFREQ)=0 then
      Print("#Log:", Size(log),"=",
            FormattedMemoryString(MemoryUsage(log)),
            " Dups:", duplicates, " Waiting:", Size(waiting),
            " submts:", Size(cargo));
      if mt.CONJUGACY then Print(" conjcls:",Size(cclasses)); fi;
      Print("\n");
    fi;
    ############################################################################

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
      continue;#return; #cut the search tree at this point
    fi;
    ############################################################################

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
    else
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
    #recursion for new cuts
    for ext in extensions do
      if MTROptions.DIAGONAL then CloseDiagonally(tab,rn,ext); fi;
      Store(waiting, UnionBlist(cut,ext));
    od;
  od;

  if InfoLevel(MulTabInfoClass) > 0 then
    Print("\n#Log:", Size(log),"=",
          FormattedMemoryString(MemoryUsage(log)),
          " Dups:", duplicates, " submts:", Size(cargo));
    if mt.CONJUGACY then Print(" ConjugacyClasses:",Size(cclasses) ); fi;
    Print("\n");
  fi;
  #returning the result
  if mt.CONJUGACY then
    return cclasses;
  else
    return rec(cuts:=cargo,
               logsize:=Size(log),
               dups:=duplicates,
               log:=log);
  fi;
end;
