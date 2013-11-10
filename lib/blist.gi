################################################################################
##
## SubSemi
##
## Extra functions for boolean lists. Indexing, encoding.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#functions for dealing with bolean lists

### INDEXING ###################################################################
# returns the position of the 1st entry or 1 if empty
InstallGlobalFunction(FirstEntryPosOr1,
function(blist)
  if SizeBlist(blist) = 0 then return 1; fi;
  return Position(blist,true);
end);

# returns the position of the last entry or 1 if empty
InstallGlobalFunction(LastEntryPosOr1,
function(blist)
local i;
  if SizeBlist(blist) = 0 then return 1; fi;
  i := Size(blist);
  while not blist[i] do i := i - 1; od;
  return i;
end);

#TODO this is some fancy indexing tool, but needs some description
BinaryBlistIndexer := function(n)
  local f;
  f := function(blist)
    local i,l;
    l := EmptyPlist(n);
    i := (Size(blist) - n)+1; 
    while i <= Size(blist) do
      if blist[i] then
        Add(l,2);
      else
        Add(l,1);
      fi;
      i :=  i +1;
    od;
    return l;
  end;  
  return f;
end;

### BITLIST - BITSTRING - COMPRESSED STRING ####################################
#the idea is to pack 6 bits into a single character by using this lookup string
#trailing bits are just written out (that is why no 1s and 0s in the key)
CODEKEY := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz23456789_-+=";
MakeReadOnlyGlobal("CODEKEY");

InstallGlobalFunction(EncodeBitString,
function (bitstr)
  local str,k,i,chunk;
  k := Int(Length(bitstr)/6);
  str := "";
  for i in [1..k] do
    chunk := List(bitstr{[(6*(i-1))+1..6*i]},
                  function(x)if x='0' then return 0; else return 1;fi;end);
    Add(str,CODEKEY[Sum(List([0..5],x->2^x*chunk[x+1]))+1]);
  od;
  return Concatenation(str,bitstr{[6*k+1..Length(bitstr)]});
end);

InstallGlobalFunction(DecodeBitString,
function(str)
  local bitstr,c,p,i,l;
  bitstr := "";
  for c in str do
    if c in "01" then
      Add(bitstr, c);
    else
      p := Position(CODEKEY,c);
      l := "";
      for i in Reversed([0..5]) do
        if p > 2^i then
          Add(l,'1');
          p := p - 2^i;
        else
          Add(l,'0');
        fi;
      od;
      Append(bitstr, Reversed(l));
    fi;
  od;
  return bitstr;
end);

InstallGlobalFunction(AsBitString,
function(blist)
  return List(blist,
              function(x)
                if x then
                  return '1';
                else
                  return '0';
                fi;
              end);
end);

InstallGlobalFunction(AsBlist,
function(bitstr)
  return BlistList([1..Size(bitstr)],Positions(bitstr,'1'));
end);

### CONVERTING TO SET ELEMENTS #################################################
InstallGlobalFunction(ElementsByIndicatorSet,
function(indset, elements)
  return List(ListBlist([1..Size(indset)],indset),x->elements[x]);
end);

InstallGlobalFunction(IndicatorSetOfElements,
function(elms, universe)
  local blist;
  blist := BlistList([1..Size(universe)],[]);
  Perform(elms, function(t) blist[Position(universe,t)]:=true;end);
  return blist;
end);

#from one multab  to another (for subs and supers)
#indicatorset in source to indicatorset in destination
InstallGlobalFunction(ReCodeIndicatorSet,
function(indset,src, dest)
  return IndicatorSetOfElements(ElementsByIndicatorSet(indset,src),dest);
end);
