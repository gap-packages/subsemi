#############################################################################
##
## stack.gi           Dust package
##
## Copyright (C)  Attila Egri-Nagy 2011-13
##
## Simple stack implementation.
##

InstallGlobalFunction(DuplicateFreeStack,
function() return Objectify(DuplicateFreeStackType, rec(l:=[],pointer:=0,set:=[]));end);

##Storage methods ##############################################################
InstallMethod(Store,"push for a stack",[IsDuplicateFreeStack and IsDuplicateFreeStackRep,IsObject],
function(stack, element)
  #Print("#\c");
  if element in stack!.set then return; fi;
  stack!.pointer := stack!.pointer + 1;
  stack!.l[stack!.pointer] := element;
  AddSet(stack!.set,element);
end);

InstallMethod(Retrieve,"pop for a stack", [IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function(stack)
local result, pointer;
  #for quicker access, avoiding record member search
  pointer := stack!.pointer;
  result := stack!.l[pointer];
  Remove(stack!.l,pointer);
  stack!.pointer := pointer - 1;
  Remove(stack!.set, Position(stack!.set, result));
  return result;
end);

InstallMethod(Peek,"peeking to top element of a stack",[IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function(stack)
  if Size(stack!.l) = 0 then
    return fail;
  else
    return stack!.l[stack!.pointer];
  fi;  
end);

#More general methods ##########################################################
InstallMethod(IsEmpty, "for stacks", [IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function(stack) return stack!.pointer = 0; end);

InstallMethod( Size,"for stack", [IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function( stack ) return Size(stack!.l);end);


InstallMethod( ViewObj,"for stack",[IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function( stack ) Print("DuplicateFreeStack: ", stack!.l, "<-"); end);

InstallMethod( Display,"for stack", [IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function( stack ) ViewObj(stack); Print("\n"); end);

#exposing the underlying list TODO maybe do the other way around, accept a function
InstallMethod(AsList, "for duplicate free stack", [IsDuplicateFreeStack and IsDuplicateFreeStackRep],
function(stack) return ShallowCopy(stack!.l);end);
