#############################################################################
##
## priorityqueuelossless.gi           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2016
##
## Priority queue defined by a sorting and a threshold function.
## Dropped items are stored on disk.
##

# creating an empty storage
# f - comparison function to sort the elements waiting
# g - threshold function, returning a boolean answering `Can we skip?'
#     if true the element not even stored
InstallGlobalFunction(PriorityQueueLossless,
function(f,g, namef, stringf)
  return Objectify(PriorityQueueLosslessType, rec(l:=[], s:=[], f:=f, g:=g,
                 namefunc:=namef, strfunc:=stringf));
end);

##Storage methods ##############################################################
InstallMethod(Store,"store for a priority queue",
        [IsPriorityQueueLossless and IsPriorityQueueLosslessRep,IsObject],
function(st, element)
  local otf;
  #not even storing it              
  if (st!.g(element)) then 
    otf := OutputTextFile(st!.namefunc(element), true);
    WriteLine(otf, st!.strfunc(element));
    CloseStream(otf);
    return; 
  fi;
  #duplicate-free storage
  if element in st!.s then return; fi;
  AddSet(st!.s,element);
  Add(st!.l, element, PositionSorted(st!.l, element, st!.f));
end);

#retrieves a sortedly chosen element
InstallMethod(Retrieve,"retrieve for a priority queue",
        [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
function(st)
local result, element;
  element := Remove(st!.l);
  RemoveSet(st!.s, element);
  return element;
end);

# constant fail since we cannot know the next element to be retrieved
InstallMethod(Peek,"peeking to top element of a priority queue - constant fail",
        [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
function(st)
  return st!.l[Size(st!.l)];
end);

#General methods ##########################################################
InstallMethod(IsEmpty, "for priority queue",
              [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
function(st) return IsEmpty(st!.l); end);

#WARNING!!! mutable reference is given out
InstallMethod(AsList, "for priority queue",
              [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
        function(st) return st!.l; end);

InstallMethod( Size,"for a priority queue",
               [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
function( st ) return Size(st!.l);end);

InstallMethod( ViewObj,"for a priority queue",
               [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
function( st ) Print("PriorityQueueLossless: ", st!.l); end);

InstallMethod( Display,"for a priority queue",
               [IsPriorityQueueLossless and IsPriorityQueueLosslessRep],
function( st ) ViewObj(st); Print("\n"); end);
