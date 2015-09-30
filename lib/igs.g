################################################################################
##
## SubSemi
##
## Finding independent generating sets.
##
## Copyright (C) 2015  Attila Egri-Nagy
##

#global chackpoint data structure is bound here
BindGlobal("SUBSEMI_IGSCheckPointData", rec());

IsIndependentSet := function(A)
  return IsDuplicateFreeList(A) and
         (Size(A)<2 or
          ForAll(A,x-> not (x in Group(Difference(A,[x])))));
end;

# Deciding whether gens is an independent generating set, by taking all
# of its subsets missing a single generator.
# gens - list, mt - MulTab, S - bitlist
# condition: S = SgpInMulTab(gens,mt); - not checked
IsIGS := function(gens,mt,S)
  if Size(gens) < 2 then return true; fi;
  return not ForAny(gens,x->
                 SizeBlist(S)=SizeBlist(SgpInMulTab(Difference(gens,[x]),mt)));
end;

#can we add newgen to gens that it still remains independent
#TODO this is actually very similar to IsIGS, could be written as one function
CanWeAdd := function(gens, newgen, cyclics, mt)
  local g,l,i;
  #first the cheap check: any old gen contained in the cyclic group of newgen?
  #experiments show that this helps a little, maybe asymptotically vanishing
  if (ForAny(gens, x-> cyclics[newgen][x])) then
    return false;
  fi;
  l := ShallowCopy(gens); #defensive copying
  for i  in [1..Size(gens)] do
    g := l[i]; #remembering the knocked out old generator
    l[i] := newgen; #putting in the new generator
    if IsInClosure(EmptySet(mt),l,g,mt) then return false; fi;
    l[i] := g; #undo
  od;
  return true;
end;

#this also keeps track of the irreducible generating sets in a logged database
#(even if they are not the full ones)
#potgens should be a subset of FullSet(mt)
IGSParametrized := function(mt, potgens,log,candidates, irredgensets)
  local H,set,counter,blistrep,diff,normalizer,n, l, deadends, cyclics, ll;
  counter := 0;
  n := Size(Indices(mt));
  deadends := [];
  cyclics := List(Indices(mt), x->SgpInMulTab([x],mt)); #cyclic groups
  while not IsEmpty(candidates) do
    set := Retrieve(candidates);
    H := SgpInMulTab(set,mt);
    blistrep := BlistList(Indices(mt),set);
    if not blistrep in log then
      AddSet(log,blistrep);
      if SizeBlist(H) = n then
        AddSet(irredgensets, set);
      else
        diff := Difference(potgens,ListBlist(Indices(mt),H));
        # orbit reps by the normalizer, making diff smaller, avoid dups
        normalizer := Stabilizer(SymmetryGroup(mt), blistrep, OnFiniteSet);
        diff := List(Orbits(normalizer, diff), x->x[1]);
        # checking whether adding elements from diff would yield igs' or not
        diff := Filtered(diff, x-> CanWeAdd(set, x, cyclics, mt));
        #if diff is empty then there is no way to extend the set irreducibly
        if IsEmpty(diff) then AddSet(deadends, set); fi;
        #it is enough the compile a List, rather than a Set
        ll := List(diff, x->Set(Concatenation(set,[x])));
        l := List(ll, x->SetConjugacyClassRep(x,PossibleMinConjugators(x,mt)));
        Perform(l, function(y) Store(candidates,y);end);
      fi;
    fi;
    counter := counter + 1;#####################################################
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter),
           " igs:", Size(irredgensets)," ~ ",
           FormattedBigNumberString(Size(irredgensets)),
           " db:", Size(log), " ~ ", FormattedBigNumberString(Size(log)),
           " stack:",String(Size(candidates)),
           " ", Peek(candidates));
    fi;#########################################################################
    if (counter mod SubSemiOptions.CHECKPOINTFREQ)=0 then
      SUBSEMI_IGSCheckPointData.candidates := candidates;
      SUBSEMI_IGSCheckPointData.log := log;
      SUBSEMI_IGSCheckPointData.mt := mt;
      SUBSEMI_IGSCheckPointData.potgens := potgens;
      SUBSEMI_IGSCheckPointData.irredgensets := irredgensets;
      SaveWorkspace(Concatenation("IGScheckpoint",
              String(IO_gettimeofday().tv_sec),".ws"));
      Info(SubSemiInfoClass,1,Concatenation("Checkpoint saved after ",
              FormattedBigNumberString(counter), " steps"));
    fi;
  od;
  Info(SubSemiInfoClass,1,"TOTAL: ",###########################################
       String(Size(irredgensets)),
       " in ",String(counter)," steps");########################################
  return rec(igss := List(irredgensets, x->SetByIndicatorFunction(x,mt)),
             deadends := List(deadends, x->SetByIndicatorFunction(x,mt)),
             pigss := List(
                     Filtered(List(AsList(log), x->ListBlist(Indices(mt),x)),
                             x -> not (x in irredgensets)),
                     x->SetByIndicatorFunction(x,mt)));
end;

# mt - multiplication table
# potgens - potential generators, e.g. Indices(mt) for all elements
IGSWithGens := function(mt,potgens)
  local stack;
  stack := DuplicateFreeStack();#since different cands may have the same rep
  Store(stack, []);
  return IGSParametrized(mt, potgens, LightBlistContainer(),stack,[]);
end;

IGS := function(mt) return IGSWithGens(mt, Indices(mt)); end;

#
IGSFromSet := function(mt,set,potgens)
  local stack;
  stack := DuplicateFreeStack();#since different cands may have the same rep
  Store(stack, set);
  return IGSParametrized(mt, potgens, LightBlistContainer(),stack,[]);
end;

# resuming an interrupted calculation by using global variables
# these variables get updated at each checkpoint
ResumeIGS := function()
  return IGSParametrized(SUBSEMI_IGSCheckPointData.mt,
                 SUBSEMI_IGSCheckPointData.potgens,
                 SUBSEMI_IGSCheckPointData.log,
                 SUBSEMI_IGSCheckPointData.candidates,
                 SUBSEMI_IGSCheckPointData.irredgensets);
end;

################################################################################
# another way: trying to do by cardinality

# R - a set of elements in the multiplication table
# mt - multiplication table
# output: conjugacy class representatives of sets of size |R|+1
ExtdConjugacyClassReps := function(A,mt)
  local exts;
  exts := List(Difference(Indices(mt), A), x->Union(A,[x]));
  return Set(exts, x->SetConjugacyClassRep(x,PossibleMinConjugators(x,mt)));
end;

ExtendIGS := function(igs, mt)
  local cls;
  cls := Union(Set(igs, x->ExtdConjugacyClassReps(x,mt)));
  Print("Found cls:", Size(cls), "\n");
  return Filtered(cls, x->IsIGS(x,mt,SgpInMulTab(x,mt)));#should filter for solutions at the same time
end;

process := function(mt)
  local igs, res, sols;
  igs := [[]];
  sols := [];
  res := [];
  repeat
    igs := ExtendIGS(igs,mt);
    Print("Found igs:", Size(igs), "\n");
    sols := Filtered(igs, x-> Size(mt)=SizeBlist(SgpInMulTab(x,mt)));
    Print("Found sols:", Size(sols), "\n");
    igs := Difference(igs,sols);
    Add(res, sols);
  until IsEmpty(igs);
  return res;
end;
