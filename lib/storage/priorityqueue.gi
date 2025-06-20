#############################################################################
##
## priorityqueue.gi           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2011-2016
##
## Priority queue defined by a sorting and a threshold function.
##

# creating an empty storage
# f - comparison function to sort the elements waiting
# g - threshold function, returning a boolean answering `Can we skip?'
#     if true the element not even stored
InstallGlobalFunction(PriorityQueue,
function(f,g)
  return Objectify(PriorityQueueType, rec(l:=[], s:=[], f:=f, g:=g));
end);

##Storage methods ##############################################################
InstallMethod(Store,"store for a priority queue",
        [IsPriorityQueue and IsPriorityQueueRep,IsObject],
function(st, element)
  #not even storing it              
  if (st!.g(element)) then return; fi;
  #duplicate-free storage
  if element in st!.s then return; fi;
  AddSet(st!.s,element);
  Add(st!.l, element, PositionSorted(st!.l, element, st!.f));
end);

#retrieves a sortedly chosen element
InstallMethod(Retrieve,"retrieve for a priority queue",
        [IsPriorityQueue and IsPriorityQueueRep],
function(st)
local result, element;
  element := Remove(st!.l);
  RemoveSet(st!.s, element);
  return element;
end);

# constant fail since we cannot know the next element to be retrieved
InstallMethod(Peek@,"peeking to top element of a priority queue - constant fail",
        [IsPriorityQueue and IsPriorityQueueRep],
function(st)
  return st!.l[Size(st!.l)];
end);

#General methods ##########################################################
InstallMethod(IsEmpty, "for priority queue",
              [IsPriorityQueue and IsPriorityQueueRep],
function(st) return IsEmpty(st!.l); end);

#WARNING!!! mutable reference is given out
InstallMethod(AsList, "for priority queue",
              [IsPriorityQueue and IsPriorityQueueRep],
        function(st) return st!.l; end);

InstallMethod( Size,"for a priority queue",
               [IsPriorityQueue and IsPriorityQueueRep],
function( st ) return Size(st!.l);end);

InstallMethod( ViewObj,"for a priority queue",
               [IsPriorityQueue and IsPriorityQueueRep],
function( st ) Print("PriorityQueue: ", st!.l); end);

InstallMethod( Display,"for a priority queue",
               [IsPriorityQueue and IsPriorityQueueRep],
function( st ) ViewObj(st); Print("\n"); end);
