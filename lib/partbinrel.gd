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

BindGlobal("PartitionedBinaryRelationFamily",
        NewFamily("PartitionedBinaryRelationFamily",
                IsPartitionedBinaryRelation,
                CanEasilySortElements,
                CanEasilySortElements));

BindGlobal("PartitionedBinaryRelationType",
        NewType(PartitionedBinaryRelationFamily,IsPartitionedBinaryRelation));

DeclareGlobalFunction("PartitionedBinaryRelation");
