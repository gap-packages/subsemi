#the refined version of the most useful algorithm

BindGlobal("SUBSEMI_IGSCheckPointData", rec());

### more clever enumeration with SUBSEMI #######################################
# gens - list, mt - MulTab, S - bitlist
# condition: S = SgpInMulTab(gens,mt); - not checked
IsIGS := function(gens,mt,S)
  #local gensblist,x;
  if Size(gens) < 2 then return true; fi;
  #can we omit a generator?
  # no speedup with the following code
  #gensblist := BlistList(Indices(mt), gens);
  #for x in gens do
  #  gensblist[x]:=false;
  #  if SizeBlist(S) = SizeBlist(SgpInMulTab(gensblist,mt)) then
  #    return false;
  #  fi;
  #  gensblist[x]:=true;
  #od;
  #return true;
  return not ForAny(gens,x->
                 SizeBlist(S)=SizeBlist(SgpInMulTab(Difference(gens,[x]),mt)));
end;

# conjugacy class rep defined for list of integers
SetConjugacyClassRep := function(set,mt)
local  min, new, g;
  min := AsSet(set);
  for g in Symmetries(mt) do
    new := OnSets(set,g);
    if new < min then
      min := new;
    fi;
  od;
  return min;
end;

#this also keeps track of the irreducible generating sets in a logged database
#(even if they are not the full ones)
#potgens should be a subset of FullSet(mt)
IGSParametrized := function(mt, potgens,log,candidates, irredgensets)
  local H,set,counter,blistrep,diff,normalizer,n, l;
  counter := 0;
  n := Size(Indices(mt));
  while not IsEmpty(candidates) do
    set := Retrieve(candidates);
    H := SgpInMulTab(set,mt);
    if IsIGS(set,mt,H) then #consider only irreducibles
      blistrep := BlistList(Indices(mt),set);
      if not blistrep in log then
        AddSet(log,blistrep);
        if SizeBlist(H) = n then
          AddSet(irredgensets, set);
        else
          diff := Difference(potgens,ListBlist(Indices(mt),H));#set);
          # orbit reps by the normalizer, making diff smaller, avoid dups
          normalizer := Stabilizer(SymmetryGroup(mt), blistrep, OnFiniteSet);
          diff := List(Orbits(normalizer, diff), x->x[1]);
          #it is enough the compile a List, rather than a Set
          l := List(diff,
                    x->SetConjugacyClassRep(Set(Concatenation(set,[x])),mt));
          Perform(l, function(y) Store(candidates,y);end);
        fi;
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
  return List(irredgensets, x->List(x,y->SortedElements(mt)[y]));
end;

# mt - multiplication table
# potgens - potential generators, e.g. Indices(mt) for all elements
IGS := function(mt,potgens)
  local stack;
  stack := DuplicateFreeStack();#since different cands may have the same rep
  Store(stack, []);
  return IGSParametrized(mt, potgens, LightBlistContainer(),stack,[]);
end;

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
