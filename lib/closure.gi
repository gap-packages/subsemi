################################################################################
##
## SubSemi
##
## Calculating the closure of a subarray of a multiplication table, i.e.
## a semigroup generated by some elements inside the multiplication table of
## a bigger semigroup.
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

### CLOSURE ALGORITHMS #########################################################
# Calculates the semigroup generated by a semigroup and a new generator element.

# base - a subsgp in S as a blist
# newelt - an element of S encoded as an integer
# mt - multiplication table of a semigroup S
InstallGlobalFunction(ClosureByIncrements,
function(base,newelt,mt)
  local diff,closure,i,j,tab;
  if base[newelt] then return base; fi;
  tab := Rows(mt);
  diff := BlistList(Indices(mt),[]);
  diff[newelt] := true;
  closure := ShallowCopy(base);
  while SizeBlist(diff) > 0 do
    i := Position(diff,true); # just get the first
    closure[i] := true; #adding i
    for j in Indices(mt) do
      if closure[j] then
        diff[tab[j][i]] := true; #scanning the ith column
        diff[tab[i][j]] := true; #scanning the ith row
      fi;
    od;
    SubtractBlist(diff,closure); #now it is a real diff
  od;
  return closure;
end);

#alternative method using local tables
InstallGlobalFunction(ClosureByLocalTables,
function(base,newelt,mt)
  local diff,closure,i,v,tab;
  if base[newelt] then return base; fi;
  tab := LocalTables(mt);
  diff := BlistList(Indices(mt),[]);
  diff[newelt] := true;
  closure := ShallowCopy(base);
  while SizeBlist(diff) > 0 do
    i := Position(diff,true); # it is not empty, so this is ok
    closure[i] := true; #adding i
    #what shall we include?
    for v in tab[i] do
      if not closure[v[1]] and ForAny(v[2], x->closure[x]) then
        diff[v[1]] := true;
        closure[v[1]] := true; #boosting: if in waiting then it is in
      fi;
    od;
    diff[i] := false; #removing i from the waiting list
  od;
  return closure;
end);

#alternative method: we check all the missing points whether to include or not
InstallGlobalFunction(ClosureByGlobalTables,
function(base,newelt,mt)
  local complement,closure,i,globtab,flag;
  if base[newelt] then return base; fi;
  globtab := GlobalTables(mt);
  closure := ShallowCopy(base);
  closure[newelt] := true;
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
end);

### GENERATING SEMIGROUPS BY ITERATED CLOSURES #################################
# Blists are lot faster like 4x-7x
SgpInMulTabFunc := function(closure_func)
  return function(gens, mt)
    local closure, i;
    if IsEmpty(gens) then return EmptySet(mt);fi;
    # we allow both lists and blists as input
    if IsBlist(gens) then
      if SizeBlist(gens) = 0 then return EmptySet(mt); fi;
      gens := ListBlist(Indices(mt), gens);
    fi;
    closure := MonogenicSgps(mt)[gens[1]];
    for i in [2..Length(gens)] do
      closure := closure_func(closure, gens[i], mt);
    od;
    return closure;
  end;
end;
MakeReadOnlyGlobal("SgpInMulTabFunc");

InstallGlobalFunction(SgpInMulTab, SgpInMulTabFunc(ClosureByIncrements));

#trying to leave the function as early as possible
InstallGlobalFunction(IsInSgp,
function(gens,elt,mt)
  local diff,closure,i,j,tab;
  #first the monogenic semigroups
  if elt in gens or ForAny(gens, x->MonogenicSgps(mt)[x][elt]) then
    return true;
  fi;
  tab := Rows(mt);
  closure := BlistList(Indices(mt),[]);
  diff := BlistList(Indices(mt),gens);
  while SizeBlist(diff) > 0 do
    i := Position(diff,true); # just get the first
    if i = elt then return true; fi;
    closure[i] := true; #adding i
    for j in Indices(mt) do
      if closure[j] then
        diff[tab[j][i]] := true; #scanning the ith column
        diff[tab[i][j]] := true; #scanning the ith row
      fi;
    od;
    if diff[elt] then return true; fi;
    SubtractBlist(diff,closure); #now it is a real diff
  od;
  return false;
end);


InstallGlobalFunction(IsMaximalSubSgp,
function(set,mt)
  local diff, full;
  diff := ShallowCopy(Indices(mt));
  SubtractSet(diff, AsSet(ListBlist(Indices(mt), set)));
  if IsEmpty(diff) then return false; fi;
  full := BlistList(Indices(mt),Indices(mt));
  return ForAll(diff, i-> full = ClosureByIncrements(set,i,mt));
end);

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
