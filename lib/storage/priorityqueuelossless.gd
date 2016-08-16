#############################################################################
##
## priorityqueuelossless.gd           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2016
##
## Priority queue defined by a sorting and a threshold function.
## Dropped items are stored on disk.
##

DeclareCategory("IsPriorityQueueLossless", IsStorage);
DeclareRepresentation( "IsPriorityQueueLosslessRep",
                       IsComponentObjectRep,
        ["l", #list sorted by f
         "s", #set for lookup (sorted by the default comparison)
         "f", #comparison function
         "g"]); #threshold function

PriorityQueueLosslessType  := NewType(
    NewFamily("PriorityQueueLosslessFamily",IsPriorityQueueLossless),
    IsPriorityQueueLossless and IsPriorityQueueLosslessRep and IsMutable);

DeclareGlobalFunction("PriorityQueueLossless");
