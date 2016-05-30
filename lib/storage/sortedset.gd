#############################################################################
##
## priorityqueue.gd           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2011-2016
##
## Priority queue defined by a sorting and a threshold function.
##

DeclareCategory("IsPriorityQueue", IsStorage);
DeclareRepresentation( "IsPriorityQueueRep",
                       IsComponentObjectRep,
        ["l", #list sorted by f
         "s", #set for lookup (sorted by the default comparison)
         "f", #comparison function
         "g"]); #threshold function

PriorityQueueType  := NewType(
    NewFamily("PriorityQueueFamily",IsPriorityQueue),
    IsPriorityQueue and IsPriorityQueueRep and IsMutable);

DeclareGlobalFunction("PriorityQueue");
