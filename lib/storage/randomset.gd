#############################################################################
##
## randomset.gd           Dust package
##
## Copyright (C)  Attila Egri-Nagy 2011-2014
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

#############################################################################
## <#GAPDoc Label="RandomSet">
##  <ManSection><Heading>Creating an empty randomized set</Heading>
##   <Func Name="RandomSet" Arg=""/>
##    <Description>
##    Creates an empty stack.
##    <Example>
##     gap&gt; stack := RandomSet()
##     RandomSet: [  ]&lt;-
##    </Example>
##   </Description>
##  </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction("RandomSet");
