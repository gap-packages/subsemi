#############################################################################
##
## sortedset.gd           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2011-2016
##
## Storage where elements can be retrieved sorted by a function.
##

DeclareCategory("IsSortedSet", IsStorage);
DeclareRepresentation( "IsSortedSetRep",
                       IsComponentObjectRep,
        ["l", #list sorted by f
         "s", #set for lookup (sorted by the default comparison)
         "f"]); #comparison function

SortedSetType  := NewType(
    NewFamily("SortedSetFamily",IsSortedSet),
    IsSortedSet and IsSortedSetRep and IsMutable);

DeclareGlobalFunction("SortedSet");
