################################################################################
##
## SubSemi
##
## Extra functions for boolean lists. Indexing, encoding.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

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

InstallGlobalFunction(HeavyBlistContainer,
function()
  return DynamicIndexedHashSet([x->SizeBlist(x)+1,FirstEntryPosOr1,LastEntryPosOr1]);
end);

InstallGlobalFunction(LightBlistContainer,
function()
  return DynamicIndexedHashSet([x->SizeBlist(x)+1,FirstEntryPosOr1]);
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

# converting a boolean list to a bitstring, writing 1 for true, 0 for false
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

# converting a bitstring to a boolean list,
# the true values are coded by the positions of 1s
InstallGlobalFunction(AsBlist,
function(bitstr)
  return BlistList([1..Size(bitstr)],Positions(bitstr,'1'));
end);

### CONVERTING TO SET ELEMENTS #################################################
InstallMethod(ElementsByIndicatorSet, "for boolean list and a list of elements",
        [IsList, IsList],
function(indset, elements)
  if IsBlist(indset) then
    return List(ListBlist([1..Size(indset)],indset),x->elements[x]);
  else
    return List(indset,x->elements[x]);
  fi;
end);

InstallMethod(IndicatorSetOfElements,
        "for a list of elements and a list (of the universe)",
        [IsList,IsList],
function(elms, universe)
  local blist;
  blist := BlistList([1..Size(universe)],[]);
  Perform(elms, function(t) blist[Position(universe,t)]:=true;end);
  return blist;
end);

#from one multab  to another (for subs and supers)
#indicatorset in source to indicatorset in destination
InstallMethod(ReCodeIndicatorSet,
        "for a boolean list, a source and destiantion list of elements",
        [IsList,IsList,IsList],
function(indset,src, dest)
  return IndicatorSetOfElements(ElementsByIndicatorSet(indset,src),dest);
end);

InstallGlobalFunction(LoadIndicatorSets,
function(filename)
  local result,itf,s;
  itf := InputTextFile(filename);
  result := [];
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    Add(result,AsBlist(DecodeBitString(s)));    
    s := ReadLine(itf);
  until s=fail;
  CloseStream(itf);
  return result;
end);

InstallGlobalFunction(SaveIndicatorSets,
function(indsets, filename)
  local output,r;
  output := OutputTextFile(filename, false);
  for r in indsets do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
end);
