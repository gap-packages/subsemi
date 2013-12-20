################################################################################
##
## SubSemi
##
## Calculating the closure of a subarray of a multiplication table.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#the closure of base the extension to closure (subsgp)
# when adding a new point we check for new entries (filtered out by exisitng positions)
ClosureByQueue := function(base,extension,mt)
  local queue,diff, closure,i,j,tab;
  tab := Rows(mt);
  if IsBlist(extension) then #to make it type agnostic
    queue := ShallowCopy(extension);
  else
    queue := BlistList(Indices(mt),extension);
  fi;
  closure := ShallowCopy(base);
  diff := BlistList(Indices(mt),[]);
  while SizeBlist(queue) > 0 do
    i := Position(queue,true); # it is not empty, so this is ok
    #we calculate the difference induced by i
    for j in Indices(mt) do
      if closure[j] then
        diff[tab[j][i]] := true;
        diff[tab[i][j]] := true;
      fi;
    od;
    diff[tab[i][i]] := true;
    SubtractBlist(diff,closure);
    UniteBlist(queue, diff);
    SubtractBlist(diff,queue);#cleaning for reusing diff object
    closure[i] := true; #adding i
    queue[i] := false; #removing i from the queue
  od;
  return closure;
end;

#alternative method
ClosureByQueueAndLocalTables := function(base,extension,mt)
  local queue,closure,i,v,tab;
  tab := LocalTables(mt);
  if IsBlist(extension) then #to make it type agnostic
    queue := ShallowCopy(extension);
  else
    queue := BlistList(Indices(mt),extension);
  fi;
  closure := ShallowCopy(base);
  while SizeBlist(queue) > 0 do
    i := Position(queue,true); # it is not empty, so this is ok
    closure[i] := true; #adding i
    #what shall we include?
    for v in tab[i] do
      if not closure[v[1]] and ForAny(v[2], x->closure[x]) then
        queue[v[1]] := true;
        closure[v[1]] := true; #boosting: if in queue then it is in
      fi;
    od;
    queue[i] := false; #removing i from the queue
  od;
  return closure;
end;

#alternative method: we check all the missing points and add them by their logic
ClosureByComplement := function(base,extension,mt)
  local diff, closure,i,j,booltab,size,flag;
  booltab := GlobalTables(mt);
  if IsBlist(extension) then #to make it type agnostic
    closure := UnionBlist([base,extension]);
  else
    closure := UnionBlist([base,BlistList(Indices(mt),extension)]);
  fi;
  diff := FullSet(mt);
  SubtractBlist(diff, closure);
  flag := true;
  while flag do
    flag := false;
    for i in Indices(mt) do
      if diff[i] then
            #do we include i?
        if   ForAny(booltab[i],
                    function(bt)
          return closure[bt[1]] and ForAny(bt[2], y->closure[y]);
        end) then
          closure[i] := true;
          flag := true;
        fi;
      fi;
    od;
    diff := FullSet(mt);
    SubtractBlist(diff, closure);
  od;
  return closure;
end;

InstallGlobalFunction(SgpInMulTab,
function(arg)
  #arg[1] - gens
  #arg[2] - mt
  #arg[3] - closure function
  if IsBound(arg[3]) then
    return arg[3](BlistList(Indices(arg[2]),[]),arg[1],arg[2]);
  else
    return ClosureByQueue(BlistList(Indices(arg[2]),[]),arg[1],arg[2]);
  fi;
end);

IsMaximalSubSgp := function(set,mt)
  local diff, full;
  diff := ShallowCopy(Indices(mt)); 
  SubtractSet(diff, AsSet(ListBlist(Indices(mt), set)));
  if IsEmpty(diff) then return false; fi;
  full := BlistList(Indices(mt),Indices(mt));
  return ForAll(diff, i-> full = ClosureByQueue(set,[i],mt));
end;

InstallGlobalFunction(IsClosedSubTable,
function(set,mt)
  return IsEmpty(MissingElements(set,mt));
end);


#just to kickstart the closure, calculate the missing elements
#this may not be a closure
InstallGlobalFunction(MissingElements,
function(gens,mt)
  local i,j,rows,completion;
  rows := Rows(mt);
  completion := [];
  for i in Indices(mt) do
    for j in Indices(mt) do
      if gens[i] and gens[j] then
        if not gens[rows[i][j]] then
          AddSet(completion,rows[i][j]);
        fi;
      fi;
    od;
  od;
  return completion;
end);
