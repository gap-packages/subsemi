################################################################################
##
## SubSemi
##
## Independent sets in groups and semigroups.
##
## Copyright (C) 2015-2016  Attila Egri-Nagy
##

#global checkpoint data structure is bound here
BindGlobal("SUBSEMI_IS_CheckPointData", rec());

################################################################################
### GRAPH SEARCH FOR INDEPENDENT SETS ##########################################
################################################################################

# graph search algorithm for independent sets, high level algorithm
# mt - multiplication table
# potgens - potential generators, i.e. elements to be in independent sets
# db - database for keeping track visited elements
# candidates - the `waiting list' of the search, can be a Stack, Queue etc.
# result - IsDatabase needs a separate list for the end result
### functions for changing the behaviour of the search
# isnew - decided whether the blist representation of the set is now or not
# store - store the blist in database/ result
# filter - filtering the complement of the generated subsemigroup for generators
InstallGlobalFunction(IS_SEARCH,
function(mt, potgens,db,candidates,result, isnew, store, filter)
  local set, # a subset of the elements of multiplication table (list)
        blist, # set represented as a boolean list
        S, # semigroup generated set (subsemigroup in the multiplication table)
        l, # list used for temporary storage
        counter; #counting the number of search steps for logging, checkpointing
  counter := 0;
  ### MAIN SEARCH LOOP #########################################################
  while not IsEmpty(candidates) do
    set := Retrieve(candidates);
    blist := BlistList(Indices(mt),set);
    if isnew(blist) then
      store(blist);
      S := SgpInMulTab(set,mt);
      if SizeBlist(S) < Size(mt) then
        #filter the complement of semigroup S for candidate elements
        l := filter(Difference(potgens,ListBlist(Indices(mt),S)), set);
        #build the new sets by appending candidates to set
        l := List(l, x->Set(Concatenation(set,[x])));
        #taking conjugacy class representatives
        l := List(l, x->SetConjugacyClassRep(x,PossibleMinConjugators(x,mt)));
        Perform(l, function(x) Store(candidates,x);end);
      fi;
    fi;
    ### LOGGING ################################################################
    counter := counter + 1;
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter),
           " iss:", Size(result)," ~ ",
           FormattedBigNumberString(Size(result)),
           " stack:",String(Size(candidates)),
           " ", Peek(candidates));
    fi;
    ### CHECKPOINTING ##########################################################
    if (counter mod SubSemiOptions.CHECKPOINTFREQ)=0 then
      SUBSEMI_IS_CheckPointData.candidates := candidates;
      SUBSEMI_IS_CheckPointData.mt := mt;
      SUBSEMI_IS_CheckPointData.potgens := potgens;
      SUBSEMI_IS_CheckPointData.db := db;
      SUBSEMI_IS_CheckPointData.result := result;
      SaveWorkspace(Concatenation("IScheckpoint",
              String(IO_gettimeofday().tv_sec),".ws"));
      Info(SubSemiInfoClass,1,Concatenation("Checkpoint saved after ",
              FormattedBigNumberString(counter), " steps"));
    fi;
  od;
  ### FINAL LOG MESSAGE ########################################################
  Info(SubSemiInfoClass,1,"TOTAL: ",
       String(Size(result)),
       " in ",String(counter)," steps");
  return result;
end);

################################################################################
### SEARCH WITH A DATABASE #####################################################
################################################################################

#can we add newgen to gens that it still remains independent
CanWeAdd := function(gens, newgen, mt)
  local g,l,i;
  l := ShallowCopy(gens); #defensive copying
  for i  in [1..Size(gens)] do
    g := l[i]; #remembering the knocked out old generator
    l[i] := newgen; #putting in the new generator
    if IsInSgp(l,g,mt) then return false; fi;
    l[i] := g; #undo
  od;
  return true;
end;
MakeReadOnlyGlobal("CanWeAdd");

# keeping a database for checking against
InstallGlobalFunction(ISDatabase,
function(mt, potgens,db,candidates,result)
  local isnew, store, filter;
  isnew := x -> not IsInBlistStorage(db,x);
  store := function(x) StoreBlist(db,x);Add(result,x); end;
  filter := function(diff, set)
    local normalizer, l;
    # orbit reps by the normalizer, making diff smaller, avoid dups
    normalizer := Stabilizer(SymmetryGroup(mt), set, OnSets);
    l := List(Orbits(normalizer, diff), x->x[1]);
    # checking whether adding elements from diff would yield igs' or not
    return Filtered(l, x -> CanWeAdd(set, x, mt));
  end;
  return IS_SEARCH(mt, potgens, db, candidates, result, isnew, store, filter);
end);

################################################################################
### CANONICAL CONSTRUCTION PATH METHOD #########################################
################################################################################

# we add a new element to a set, then get the permutation that conjugates the
# set to its class representative (lexicographic minimal element of the class)
# the addition is canonical if it corresponds to adding a new maximal element
# in the representative
IsCanonicalAddition := function(gens, newelt, mt)
  local set, p, rep;
  set := Set(Union(gens,[newelt]));
  p := SetConjugacyClassConjugator(set, PossibleMinConjugators(set,mt));
  rep := OnSets(set, p);
  return newelt = Maximum(rep)^(Inverse(p));
end;
MakeReadOnlyGlobal("IsCanonicalAddition");

# canonical construction path method
#potgens should be a subset of FullSet(mt)
InstallGlobalFunction(ISCanCons,
function(mt, potgens, db, candidates)
  local minconjs, isnew, store, filter;
  minconjs := MinimumConjugates(mt);
  isnew := ReturnTrue;
  store := function(blist) Add(db, blist);end;
  filter := function(diff, set)
    local l,min;
    if IsEmpty(set) then min := 0; else min := Minimum(set); fi;
    #adding an element smaller than the minrep can't be canonical construction
    l := Filtered(diff, x->minconjs[x] >= min);
    # checking whether adding elements from diff would yield igs' or not
    return Filtered(l,
                   x -> not ForAny(set, y-> MonogenicSgps(mt)[x][y])
                   and IsCanonicalAddition(set,x,mt)
                   and CanWeAdd(set, x, mt));
  end;
  return IS_SEARCH(mt, potgens, db, candidates, db, isnew, store, filter);
end);

################################################################################
### DISPATCH FUNCTIONS  ########################################################
################################################################################

# mt - multiplication table
# potgens - potential generators, e.g. Indices(mt) for all elements
ISWithGens := function(mt,seed, potgens,ISfunc)
  local stack,db;
  stack := DuplicateFreeStack();#since different cands may have the same rep
  Store(stack, seed);
  if ISfunc = ISDatabase then
    return ISDatabase(mt, potgens, BlistStorage(Size(mt)), stack, []);
  else
    return ISCanCons(mt, potgens, [] ,stack);
  fi;
end;

InstallGlobalFunction(IS,
function(mt,ISfunc)
  return ISWithGens(mt, [], Indices(mt),ISfunc);
end);

# resuming an interrupted calculation by using global variables
# these variables get updated at each checkpoint
InstallGlobalFunction(Resume_IS_SEARCH,
function(ISfunc)
  return ISfunc(SUBSEMI_IS_CheckPointData.mt,
                SUBSEMI_IS_CheckPointData.potgens,
                SUBSEMI_IS_CheckPointData.iss,
                SUBSEMI_IS_CheckPointData.candidates);
end);

################################################################################
### predicates, independent from the actual search algorithm ###################
################################################################################

# using group multiplication
# this takes the identity singleton as independent, unlike the group case
IsSgpIndependentSet := function(A)
  return IsDuplicateFreeList(A)
         and (Size(A)<2
              or ForAll(A, x-> not (x in Group(Difference(A,[x])))));
end;
#TODO Using Magma would make it more general, but slower

# Deciding whether gens is an independent generating set, by taking all
# of its subsets missing a single generator.
# gens - list, mt - MulTab, S - bitlist
# condition: S = SgpInMulTab(gens,mt); - not checked
IsSgpIGS := function(gens,mt,S)
  if Size(gens) < 2 then return true; fi;
  return not ForAny(gens,x->
                 SizeBlist(S)=SizeBlist(SgpInMulTab(Difference(gens,[x]),mt)));
end;

IsDeadEnd := function(gens,G)
  local diff;
  if IsEmpty(gens) then return false; fi;
  diff := Difference(AsList(G), AsList(Group(gens)));
  return (not IsEmpty(diff))
         and ForAll(diff, x-> not IsSgpIndependentSet(Union(gens,[x])));
end;
