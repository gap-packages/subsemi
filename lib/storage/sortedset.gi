#############################################################################
##
## sortedset.gi           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2011-2016
##
## Storage where elements can be retrieved sorted by a function.
##

# creating an empty storage
InstallGlobalFunction(SortedSet,
function(f)
  return Objectify(SortedSetType, rec(l:=[], s:=[], f:=f));
end);

##Storage methods ##############################################################
InstallMethod(Store,"store for a sorted set",
        [IsSortedSet and IsSortedSetRep,IsObject],
function(st, element)
  #duplicate-free storage
  if element in st!.s then return; fi;
  AddSet(st!.s,element);
  Add(st!.l, element, PositionSorted(st!.l, element, st!.f));
end);

#retrieves a sortedly chosen element
InstallMethod(Retrieve,"retrieve for a sorted set",
        [IsSortedSet and IsSortedSetRep],
function(st)
local result, element;
  element := Remove(st!.l);
  RemoveSet(st!.s, element);
  return element;
end);

# constant fail since we cannot know the next element to be retrieved
InstallMethod(Peek,"peeking to top element of a sorted set - constant fail",
        [IsSortedSet and IsSortedSetRep],
function(st)
  return st!.l[Size(st!.l)];
end);

#General methods ##########################################################
InstallMethod(IsEmpty, "for sorted set", [IsSortedSet and IsSortedSetRep],
function(st) return IsEmpty(st!.l); end);

InstallMethod( Size,"for a sorted set", [IsSortedSet and IsSortedSetRep],
function( st ) return Size(st!.l);end);

InstallMethod( ViewObj,"for a sorted set",[IsSortedSet and IsSortedSetRep],
function( st ) Print("SortedSet: ", st!.l); end);

InstallMethod( Display,"for a sorted set", [IsSortedSet and IsSortedSetRep],
function( st ) ViewObj(st); Print("\n"); end);
