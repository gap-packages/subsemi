#############################################################################
##
## queue.gi           Dust package
##
## Copyright (C)  Attila Egri-Nagy 2011-2013
##
## Simple queue implementation.
##

InstallGlobalFunction(Queue@,
function() return Objectify(QueueType, rec(l:=[],nextfreeslot:=1));end);

##Storage methods ##############################################################
InstallMethod(Store,"enqueue",[IsQueue@ and IsQueueRep,IsObject],
function(queue, element)
  queue!.l[queue!.nextfreeslot] := element;
  queue!.nextfreeslot := queue!.nextfreeslot + 1;
end);

InstallMethod(Retrieve,"dequeue", [IsQueue@ and IsQueueRep],
function(queue)
local result;
  result := queue!.l[1];
  Remove(queue!.l,1); #the list elements jump down by one after removal
  queue!.nextfreeslot := queue!.nextfreeslot - 1;
  return result;
end);

InstallMethod(Peek@,"peeking to top element of a queue",[IsQueue@ and IsQueueRep],
function(queue) return queue!.l[1];end);

#More general methods ##########################################################
InstallMethod(IsEmpty, "for queues", [IsQueue@ and IsQueueRep],
function(queue) return queue!.nextfreeslot = 1; end);

InstallMethod( Size,"for queue", [IsQueue@ and IsQueueRep],
function( queue ) return queue!.nextfreeslot - 1;end);

InstallMethod( ViewObj,"for queue",[IsQueue@ and IsQueueRep],
function( queue ) Print("Queue: ->", queue!.l);end);

InstallMethod( Display,"for queue", [IsQueue@ and IsQueueRep],
function( queue ) ViewObj(queue); Print("\n"); end);
