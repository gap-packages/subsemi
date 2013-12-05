#the closure of base the extension to closure (subsgp)
# when adding a new point we check for new entries (filtered out by exisitng positions)
ClosureByMulTab := function(base,extension,mt)
  local queue,diff, closure,i,j,tab;
  tab := Rows(mt);
  if IsBlist(extension) then #to make it type agnostic
    queue := ShallowCopy(extension);
  else
    queue := BlistList(Indices(mt),extension);
  fi;
  closure := ShallowCopy(base);
  while SizeBlist(queue) > 0 do
    i := Position(queue,true); # it is not empty, so this is ok
    if closure[i] then
      ; #we already have it, nothing to do
    else
      #we calculate the difference induced by 1
      diff := BlistList(Indices(mt),[i]);
      for j in Indices(mt) do
        if closure[j] then
          diff[tab[j][i]] := true;
          diff[tab[i][j]] := true;
        fi;
      od;
      diff[tab[i][i]] := true;
      SubtractBlist(diff,closure);
      UniteBlist(queue, diff);
      closure[i] := true; #adding i
    fi;
    queue[i] := false; #removing i from the queue
  od;
  return closure;
end;

ClosureByMulTab1 := function(base,extension,mt)
  local queue,diff, closure,i,v,tab;
  tab := LogicTable2(mt);
  if IsBlist(extension) then #to make it type agnostic
    queue := ShallowCopy(extension);
  else
    queue := BlistList(Indices(mt),extension);
  fi;
  closure := ShallowCopy(base);
  while SizeBlist(queue) > 0 do
    i := Position(queue,true); # it is not empty, so this is ok
    if not closure[i] then
      closure[i] := true; #adding i
      #what shall we include?
      for v in tab[i] do
        if not closure[v[1]] and ForAny(v[2], x->closure[x]) then
          queue[v[1]] := true;
          #closure[v[1]] := true; #boosting does not work, it explodes
        fi;
      od;
    fi;
    queue[i] := false; #removing i from the queue
  od;
  return closure;
end;


#alternative method: we check all the missing points and add them by their logic
ClosureByMulTab2 := function(base,extension,mt)
  local diff, closure,i,j,booltab,size,flag;
  booltab := LogicTable(mt);
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

InstallGlobalFunction(SgpInMulTab,function(gens,mt)
  return ClosureByMulTab(BlistList(Indices(mt),[]),gens,mt);
end);

#since the nonincluded points are less, this is faster with CBMT2 in general
SgpInMulTabWithKick := function(gens,mt)
  return ClosureByMulTab2(gens,MissingElements(gens,mt),mt);
end;

IsMaximalSubSgp := function(set,mt)
  local diff, full;
  diff := ShallowCopy(Indices(mt)); 
  SubtractSet(diff, AsSet(ListBlist(Indices(mt), set)));
  if IsEmpty(diff) then return false; fi;
  full := BlistList(Indices(mt),Indices(mt));
  return ForAll(diff, i-> full = ClosureByMulTab(set,[i],mt));
end;

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
