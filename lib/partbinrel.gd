################################################################################
##
## SubSemi
##
## Partitioned Binary Relations
## Binary relations on 2n points with a different multiplication
##
## Copyright (C) 2015  Attila Egri-Nagy
##

DeclareCategory("IsPartitionedBinaryRelation", IsMultiplicativeElementWithOne
        and IsAssociativeElement and IsAttributeStoringRep
        and IsMultiplicativeElementWithInverse);

DeclareCategoryCollections("IsPartitionedBinaryRelation");

DeclareRepresentation( "IsPartitionedBinaryRelationRep",
                       IsComponentObjectRep,
                       [ "a11","a12","a21","a22"]);

BindGlobal("PartitionedBinaryRelationFamily",
        NewFamily("PartitionedBinaryRelationFamily",
                IsPartitionedBinaryRelation and IsPartitionedBinaryRelationRep,
                CanEasilySortElements,
                CanEasilySortElements));

BindGlobal("PartitionedBinaryRelationType",
        NewType(PartitionedBinaryRelationFamily,IsPartitionedBinaryRelation));

DeclareOperation("PartitionedBinaryRelation",[IsBinaryRelation]);
DeclareGlobalFunction("DegreeOfPartitionedBinaryRelation");
DeclareGlobalFunction("CombinePartitionedBinaryRelations");
