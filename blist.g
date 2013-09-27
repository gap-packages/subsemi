#functions for dealing with bolean lists

### INDEXING ###################################################################
# returns the position of the 1st entry or 1 if empty
FirstEntryPosOr1 := function(blist)
  if SizeBlist(blist) = 0 then return 1; fi;
  return Position(blist,true);
end;

# returns the position of the last entry or 1 if empty
LastEntryPosOr1 := function(blist)
local i;
  if SizeBlist(blist) = 0 then return 1; fi;
  i := Size(blist);
  while not blist[i] do i := i - 1; od;
  return i;
end;
