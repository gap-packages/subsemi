# returns true of the given cut is complete, i.e. there is the
# remaining table does not contain entries from the cut
IsCompleteCut := function(mt, cut)
local i,j;
  #checking systematically the complement of the cut
  for i in [1..mt.n] do #rows
    for j in [1..mt.n] do #columns
      if (not cut[i])
         and (not cut[j])
         and cut[mt.mt[i][j]]
         then
        return false;
      fi;
    od;
  od;
  return true;
end;

#calculates the conjugacy class elements of a cut
ConjugacyClassOfCut := function(mt, cut)
local class, g;
  class := [cut];#since we don't have the identity in mt.syms
  for g in mt.syms do #todo list blists conversions are a bit inefficient
    AddSet(class,BlistList([1..mt.n],List(ListBlist([1..mt.n],cut),x-> x^g)));
  od;
  return class;
end;

# given a cut this function calculates the set of elements whose
# row or column contains elements in the cut, but themselves not in the cut
# brute-force search through the multiplication table
Completion := function(tab, rn, cut)
local rowndx, columnndx, row, completion;
  completion := BlistList(rn,[]);
  for rowndx in rn do
    if not (cut[rowndx]) then
      row := tab[rowndx];
      for columnndx in rn do
        if (not (cut[columnndx])) and (cut[row[columnndx]]) then
          #we found a conflicting element outside the cut
          completion[rowndx] := true;#Add(completion, rowndx);
          completion[columnndx] := true;#Add(completion, columnndx);
        fi;
      od;
    fi;
  od;
  return completion;
end;

#we are trying to save s from the extension
#we keep s but try to cut the offending elements
#makes sense only when the cut is diagonally closed
ToRescue := function(tab,rn,cut,completion,s)
local i, cutsofs;
  cutsofs := BlistList(rn,[]);
  for i in ListBlist(rn,completion) do
    if cut[tab[s][i]] or cut[tab[i][s]] then
      cutsofs[i]:=true;
    fi;
  od;
  return cutsofs;
end;

#if there is an element in the diagonal, then we surely have to cut that entry
#this has to be repeated until there is no extension (like a closure)
CloseDiagonally := function(tab, rn, cut)
local finished,i;
  repeat
    finished := true;
    for i in rn do #this is ok here, same as finiteset iterator
      if not cut[i] then
        if cut[tab[i][i]] then
          cut[i] := true;
          finished := false;
        fi;
      fi;
    od;
  until finished;
end;

#just a quick hack to get the closure info
DiagonalClosure := function(mt,cut)
  local cutcopy;
  cutcopy := ShallowCopy(cut);
  CloseDiagonally(mt.mt,cutcopy);
  return Difference(cutcopy,cut);
end;
