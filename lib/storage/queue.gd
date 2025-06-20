#############################################################################
##
## queue.gd           Dust package
##
## Copyright (C)  Attila Egri-Nagy 2011-2013
##
## Simple queue implementation.
##

DeclareCategory("IsQueue@", IsStorage);
DeclareRepresentation( "IsQueueRep",
                       IsComponentObjectRep,
                       [ "l",      #list containing the elements
                         "nextfreeslot" # points to the next available slot
                         ] );

QueueType  := NewType(
    NewFamily("QueueFamily",IsQueue@),
    IsQueue@ and IsQueueRep and IsMutable);

#############################################################################
## <#GAPDoc Label="Queue">
##  <ManSection><Heading>Creating an empty queue</Heading>
##   <Func Name="Queue" Arg=""/>
##    <Description>
##    Creates an empty queue.
##    <Example>
##     gap&gt; queue := Queue()
##     Queue: -&gt;[  ]
##    </Example>
##   </Description>
##  </ManSection>
## <#/GAPDoc>
DeclareGlobalFunction("Queue@");
