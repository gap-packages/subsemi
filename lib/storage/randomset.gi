#############################################################################
##
## randomset.gi           Dust package
##
## Copyright (C)  Attila Egri-Nagy 2011-2014
##
## Simple storage with randomized Retrieve.
##

InstallGlobalFunction(RandomSet,
function() return Objectify(RandomSetType, rec(l:=[]));end);

##Storage methods ##############################################################
InstallMethod(Store,"store for a random set",[IsRandomSet and IsRandomSetRep,IsObject],
function(rndset, element)
  AddSet(rndset!.l,element);
end);

InstallMethod(Retrieve,"retrieve for a random set", [IsRandomSet and IsRandomSetRep],
function(rndset)
local result, element;
  element := Random(rndset!.l);
  RemoveSet(rndset!.l, element);
  return element;
end);

InstallMethod(Peek,"peeking to top element of a random set - constant fail",
        [IsRandomSet and IsRandomSetRep],
function(rndset)
  return fail; # since it does not make sense
end);

#More general methods ##########################################################
InstallMethod(IsEmpty, "for random set", [IsRandomSet and IsRandomSetRep],
function(rndset) return IsEmpty(rndset!.l); end);

InstallMethod( Size,"for a random set", [IsRandomSet and IsRandomSetRep],
function( rndset ) return Size(rndset!.l);end);


InstallMethod( ViewObj,"for a random set",[IsRandomSet and IsRandomSetRep],
function( rndset ) Print("RandomSet: ", rndset!.l); end);

InstallMethod( Display,"for a random set", [IsRandomSet and IsRandomSetRep],
function( rndset ) ViewObj(rndset); Print("\n"); end);
