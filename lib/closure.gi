################################################################################
##
## SubSemi
##
## Calculating the closure of a subarray of a multiplication table.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#returning a mutable bitlist from a bitlist or a list of pos integers
MutableBlist := function(set, universe)
  if IsBlist(set) then #to make it type agnostic
    return ShallowCopy(set);
  else
    return BlistList(universe,set);
  fi;
end;

#TODO duplicated code, do proper abstraction!
IsInClosure := function(base,extension,elt,mt)
  local waiting,diff,closure,i,j,tab;
  tab := Rows(mt);
  waiting := MutableBlist(extension, Indices(mt));
  closure := ShallowCopy(base);
  diff := BlistList(Indices(mt),[]);
  while SizeBlist(waiting) > 0 do
    i := Position(waiting,true); # it is not empty, so this is ok, not a queue
    for j in Indices(mt) do
      if closure[j] then
        diff[tab[j][i]] := true; #scanning the ith column
        diff[tab[i][j]] := true; #scanning the ith row
      fi;
    od;
    diff[tab[i][i]] := true; # adding the diagonal
    SubtractBlist(diff,closure); #now it is a real diff
    UniteBlist(waiting, diff);
    SubtractBlist(diff,waiting);#cleaning for reusing diff object
    closure[i] := true; #adding i
    if (elt = i) then return true; fi;
    waiting[i] := false; #removing i from the waiting
  od;
  return false;
end;


#the closure of base the extension to closure (subsgp)
# when adding a new point we check for new entries (filtered out by exisitng positions)
ClosureByIncrements := function(base,extension,mt)
  local waiting,diff,closure,i,j,tab;
  tab := Rows(mt);
  waiting := MutableBlist(extension, Indices(mt));
  closure := ShallowCopy(base);
  diff := BlistList(Indices(mt),[]);
  while SizeBlist(waiting) > 0 do
    i := Position(waiting,true); # it is not empty, so this is ok, not a queue
    for j in Indices(mt) do
      if closure[j] then
        diff[tab[j][i]] := true; #scanning the ith column
        diff[tab[i][j]] := true; #scanning the ith row
      fi;
    od;
    diff[tab[i][i]] := true; # adding the diagonal
    SubtractBlist(diff,closure); #now it is a real diff
    UniteBlist(waiting, diff);
    SubtractBlist(diff,waiting);#cleaning for reusing diff object
    closure[i] := true; #adding i
    waiting[i] := false; #removing i from the waiting
  od;
  return closure;
end;

#alternative method
ClosureByIncrementsAndLocalTables := function(base,extension,mt)
  local waiting,closure,i,v,tab;
  tab := LocalTables(mt);
  waiting := MutableBlist(extension, Indices(mt));
  closure := ShallowCopy(base);
  while SizeBlist(waiting) > 0 do
    i := Position(waiting,true); # it is not empty, so this is ok
    closure[i] := true; #adding i
    #what shall we include?
    for v in tab[i] do
      if not closure[v[1]] and ForAny(v[2], x->closure[x]) then
        waiting[v[1]] := true;
        closure[v[1]] := true; #boosting: if in waiting then it is in
      fi;
    od;
    waiting[i] := false; #removing i from the waiting list
  od;
  return closure;
end;

#alternative method: we check all the missing points whether to include or not
ClosureByComplement := function(base,extension,mt)
  local complement,closure,i,globtab,flag;
  globtab := GlobalTables(mt);
  closure := UnionBlist([base, MutableBlist(extension, Indices(mt))]);
  complement := DifferenceBlist(FullSet(mt), closure);
  flag := true; # true means we still have work to do
  while flag do
    flag := false;
    for i in Indices(mt) do
      if complement[i] then #is it in the complement
        if ForAny(globtab[i], function(bt) #do we include i?
             return closure[bt[1]] and ForAny(bt[2], y->closure[y]);end) then
          closure[i] := true;
          flag := true;
        fi;
      fi;
    od;
    complement := DifferenceBlist(FullSet(mt), closure);
  od;
  return closure;
end;

DirectlyExpressible := function(elt, gens, mt)
  return elt in gens
         or ForAny(GlobalTables(mt)[elt],
                 x -> x[1] in gens
                 and ForAny(x[2], y -> y in gens));
end;

InstallGlobalFunction(SgpInMulTab,
function(arg)
  #arg[1] - gens
  #arg[2] - mt
  #arg[3] - closure function
  if IsBound(arg[3]) then
    return arg[3](BlistList(Indices(arg[2]),[]),arg[1],arg[2]);
  else
    return ClosureByIncrements(BlistList(Indices(arg[2]),[]),arg[1],arg[2]);
  fi;
end);

IsMaximalSubSgp := function(set,mt)
  local diff, full;
  diff := ShallowCopy(Indices(mt));
  SubtractSet(diff, AsSet(ListBlist(Indices(mt), set)));
  if IsEmpty(diff) then return false; fi;
  full := BlistList(Indices(mt),Indices(mt));
  return ForAll(diff, i-> full = ClosureByIncrements(set,[i],mt));
end;

InstallGlobalFunction(IsClosedSubTable,
function(set,mt)
  return IsEmpty(MissingElements(set,mt));
end);


#just to kickstart the closure, calculate the missing elements
#this may not be a closure
InstallGlobalFunction(MissingElements,
function(gens,mt)
  local completion, rows;
  rows := Rows(mt);
  completion := [];
  Perform(Tuples(ListBlist(Indices(mt), gens),2),
          function(p)
            if (not gens[rows[p[1]][p[2]]]) then
              AddSet(completion,rows[p[1]][p[2]]);
            fi;end);
  return completion;
end);
