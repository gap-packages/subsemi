# filing - to separate bitlists into different classes based on the output
# of some given function
# the tagging function gives a string, that goes into 
# the filename, thus we get separate files for the classes

# just to have padded zeros
PaddedNumString := function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end;
  
# semigroup -> string containing green info
GreenTag := function (sgp,ndigits)
  return Concatenation("L",PaddedNumString(NrLClasses(sgp),ndigits),
                 "_R",PaddedNumString(NrRClasses(sgp),ndigits),
                 "_D",PaddedNumString(NrDClasses(sgp),ndigits),
                 "_I",PaddedNumString(Size(Idempotents(sgp)),ndigits));
end;

# tagging semigroup by size and Greens
SgpTag := function (sgp,ndigits)
  return Concatenation("S",PaddedNumString(Size(sgp),ndigits),
                 "_",GreenTag(sgp,ndigits));
end;

# tagging indicator set - includes converting to semigroup
BLGreenTag := function(bl,mt,ndigits)
  return GreenTag(Semigroup(ElementsByIndicatorSet(bl,mt)),ndigits);
end;

# tagging indicator set - includes converting to semigroup
BLSgpTag := function(bl,mt,ndigits)
  return SgpTag(Semigroup(ElementsByIndicatorSet(bl,mt)),ndigits);
end;

# a set of indicatorsets converted to small generating sets, classified
# there is a file operation for each semigroup
IndicatorSetsTOClassifiedSmallGenSet := function(sets,mt,filename,ndigits)
  local tag,s,sgp,counter;
  counter := 0;
  for s in sets do
    counter := counter +1;
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := taggerfunc(sgp,ndigits);
    if not WriteGenerators(Concatenation(filename,tag,".gens"),
               SmallGeneratingSet(sgp),"a") then
      Error(tag);
    fi;
    if InfoLevel(SubSemiInfoClass)>0 ###########################################
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter));
    fi; ########################################################################
  od;
end;

# convert the raw bitlists to set of small generators
BlistToTSGens := function(indsetfile,mt)
  WriteGenerators(Concatenation(indsetfile,".gens"),
          List(LoadIndicatorSets(indsetfile),
               x->SmallSemigroupGeneratingSet(
                       Semigroup(ElementsByIndicatorSet(x,mt)))));
end;

GensFileIsomClasses := function(filename)
  local prefix, sgps, classes, digits,i,al,k,kdigits;
  prefix := filename{[1..Size(filename)-5]};
  sgps := List(ReadGenerators(filename), Semigroup);
  #classifying by #idempotents
  al := AssociativeList();
  Perform(sgps, function(x) Collect(al, Size(Idempotents(x)),x);end);
  kdigits := Size(String(Maximum(Keys(al))));
  for k in Keys(al) do
    classes := SgpIsomorphismClasses(al[k]);
    classes := Filtered(classes, x -> Size(x) > 1);
    digits := Size(String(Size(classes)));
    for i in [1..Size(classes)] do
      if not WriteGenerators(
                 Concatenation(prefix,"_I",PaddedNumString(k,kdigits),"_",
                         PaddedNumString(i,digits),".isos"),
                 classes[i],
                 "w") then
        Error(Concatenation("Failure when processing ",filename));
      fi;
    od;
  od;
end;

# implementing ls <dir>/<prefix>*
PrefixMatchedListDir := function(dir, prefix)
  return Filtered(IO_ListDir(dir),
                 x->ForAll([1..Length(prefix)], y->x[y]=prefix[y]));
end;
