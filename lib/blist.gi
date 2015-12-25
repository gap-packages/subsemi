################################################################################
##
## SubSemi
##
## Extra functions for boolean lists. Indexing, encoding.
##
## Copyright (C) 2013  Attila Egri-Nagy
##

InstallGlobalFunction(BlistStorage,
function(n)
  local sample;
  sample := BlistList([1..3], [1,2,3]); #just a sample blist object
  return List([1..n], x-> HTCreate(sample)); 
end);

InstallGlobalFunction(StoreBlist,
function(bls, bl)
  HTAdd(bls[(HASH_FUNC_FOR_BLIST(bl,101) mod Size(bls))+1], bl, true);
end);

InstallGlobalFunction(IsInBlistStorage,
function(bls, bl)
  return true = HTValue(bls[(HASH_FUNC_FOR_BLIST(bl,101) mod Size(bls))+1], bl);
end);

### BITLIST - BITSTRING - COMPRESSED STRING ####################################
#the idea is to pack 6 bits into a single character by using this lookup string
#trailing bits are just written out (that is why no 1s and 0s in the key)
CODEKEY := SortedList(
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz23456789_-+=");
MakeReadOnlyGlobal("CODEKEY");
EXPONENTS := [5,4,3,2,1,0];
MakeReadOnlyGlobal("EXPONENTS");

InstallGlobalFunction(EncodeBitString,
function (bitstr)
  local str,k,i,chunk;
  k := Int(Length(bitstr)/6);
  str := "";
  for i in [1..k] do
    chunk := List(bitstr{[(6*(i-1))+1..6*i]},
                  function(x)if x='0' then return 0; else return 1;fi;end);
    Add(str,CODEKEY[Sum(List(EXPONENTS,x->2^x*chunk[x+1]))+1]);
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
      l := EmptyPlist(6);
      for i in EXPONENTS do
        if p > 2^i then
          l[i+1] := '1';
          p := p - 2^i;
        else
          l[i+1] := '0';
        fi;
      od;
      Append(bitstr,l);
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
InstallMethod(SetByIndicatorFunction, "for boolean list and a list of elements",
        [IsList, IsList],
function(indset, elements)
  if IsBlist(indset) then
    return List(ListBlist([1..Size(indset)],indset),x->elements[x]);
  else
    return List(indset,x->elements[x]);
  fi;
end);

InstallMethod(IndicatorFunction,
        "for a list of elements and a list (of the universe)",
        [IsList,IsList],
function(elms, universe)
  local blist;
  blist := BlistList([1..Size(universe)],[]);
  Perform(elms, function(t) blist[Position(universe,t)]:=true;end);
  return blist;
end);

#from one multab  to another (for subs and supers)
#IndicatorFunction in source to IndicatorFunction in destination
InstallMethod(RecodeIndicatorFunction,
        "for a boolean list, a source and destiantion list of elements",
        [IsList,IsList,IsList],
function(indset,src, dest)
  return IndicatorFunction(SetByIndicatorFunction(indset,src),dest);
end);

InstallGlobalFunction(LoadIndicatorFunctions,
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

InstallGlobalFunction(SaveIndicatorFunctions,
function(indsets, filename)
  local output,r;
  output := OutputTextFile(filename, false);
  SetPrintFormattingStatus(output,false); #no formatting, line breaks
  for r in indsets do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
  return true;
end);
