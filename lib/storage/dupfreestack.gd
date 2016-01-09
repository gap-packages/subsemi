#############################################################################
##
## dupfreestack.gd           Dust package
##
## Copyright (C)  Attila Egri-Nagy 2011-2014
##
## Stack implementation with no duplicates allowed in the stack.
##

DeclareCategory("IsDuplicateFreeStack", IsStack);
DeclareRepresentation( "IsDuplicateFreeStackRep",
                       IsStackRep,
                       [ "set" ] );      #set (sorted list for lookup)

DuplicateFreeStackType  := NewType(
    NewFamily("DuplicateFreeStackFamily",IsDuplicateFreeStack),
    IsDuplicateFreeStack and IsDuplicateFreeStackRep and IsMutable);

#############################################################################
## <#GAPDoc Label="Stack">
##  <ManSection><Heading>Creating an empty stack</Heading>
##   <Func Name="Stack" Arg=""/>
##    <Description>
##    Creates an empty stack.
##    <Example>
##     gap&gt; stack := Stack()
##     Stack: [  ]&lt;-
##    </Example>
##   </Description>
##  </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction("DuplicateFreeStack");
