#############################################################################
##
## randomset.gd           Subsemi package
##
## Copyright (C)  Attila Egri-Nagy 2011-2016
##
## Simple storage with randomized Retrieve.
##

DeclareCategory("IsRandomSet", IsStorage);
DeclareRepresentation( "IsRandomSetRep",
                       IsComponentObjectRep,
                       [ "l"      #list containing the elements
                         ] );

RandomSetType  := NewType(
    NewFamily("RandomSetFamily",IsRandomSet),
    IsRandomSet and IsRandomSetRep and IsMutable);

DeclareGlobalFunction("RandomSet");
