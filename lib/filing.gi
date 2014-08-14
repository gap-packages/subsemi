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
  local s;
  if GroupOfUnits(sgp) <> fail then
    s := Concatenation("_G", Size(GroupOfUnits(sgp)));
  else
    s := "";
  fi;
  return Concatenation("L",PaddedNumString(NrLClasses(sgp),ndigits),
                 "_R",PaddedNumString(NrRClasses(sgp),ndigits),
                 "_D",PaddedNumString(NrDClasses(sgp),ndigits),
                 "_RD",PaddedNumString(NrRegularDClasses(sgp),ndigits),
                 "_M",PaddedNumString(Size(MaximalDClasses(sgp)),ndigits),s);
end;

# tagging semigroup by size and Greens
SgpTag := function (sgp,ndigits)
  local tag;
  tag := Concatenation("S",PaddedNumString(Size(sgp),ndigits),
                 "_",GreenTag(sgp,ndigits),
                 "_I",PaddedNumString(NrIdempotents(sgp),ndigits),
                 "_");
  if IsBand(sgp) then Append(tag,"b");fi;
  if IsCommutativeSemigroup(sgp) then Append(tag,"c");fi;
  if IsRegularSemigroup(sgp) then Append(tag,"r");fi;
  if IsMonoid(sgp) or IsMonoidAsSemigroup(sgp) then Append(tag,"m");fi;
  if tag[Size(tag)] = '_' then Remove(tag); fi;
  return tag;
end;

# tagging indicator set - includes converting to semigroup
BLGreenTag := function(bl,mt,ndigits)
  return GreenTag(Semigroup(ElementsByIndicatorSet(bl,mt)),ndigits);
end;

# tagging indicator set - includes converting to semigroup
BLSgpTag := function(bl,mt,ndigits)
  return SgpTag(Semigroup(ElementsByIndicatorSet(bl,mt)),ndigits);
end;

#list of indicatorsets,
#tagger function : indicator set -> string (should work in all cases)
#filename
#separating indicatorsets into files by their tags
FilingIndicatorSets := function(sets,taggerfunc,filename)
  local classes, tag,s,sgp,counter;
  counter := 0;
  classes := AssociativeList(); # tags to open classes
  for s in sets do
    counter := counter +1;
    tag := taggerfunc(s);
    Collect(classes, tag, s);
    if InfoLevel(SubSemiInfoClass)>0 ###########################################
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter)," ",
           FormattedMemoryString(MemoryUsage(classes))," ",
           FormattedBigNumberString(String(Size(Keys(classes))))," ",
           FormattedPercentageString(Size(Keys(classes)),counter));
    fi; ########################################################################
  od;
  #writing the classes out to files
  Perform(Keys(classes), function(x)
    SaveIndicatorSets(classes[x],Concatenation(filename,x));end);
end;

# a set of indicatorsets converted to small generating sets, classified
# there is a file operation for each semigroup - this seems ok, probably
# caching by to OS takes away the strain on the drive
IndicatorSetsTOClassifiedSmallGenSet := function(sets,mt,filename,ndigits)
  local tag,s,sgp,counter;
  counter := 0;
  for s in sets do
    counter := counter +1;
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := SgpTag(sgp,ndigits);
    if not WriteGenerators(Concatenation(filename,tag,".gens"),
               SmallSemigroupGeneratingSet(sgp),"a") then
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
  local prefix, sgps, classes, digits,i;
  prefix := filename{[1..Size(filename)-5]};
  sgps := List(ReadGenerators(filename), Semigroup);
  classes := SgpIsomorphismClasses(sgps);
  classes := Filtered(classes, x -> Size(x) > 1);
  digits := Size(String(Size(classes)));
  for i in [1..Size(classes)] do
    if not WriteGenerators(
               Concatenation(prefix,"_",PaddedNumString(i,digits),".isos"),
               classes[i],
               "w") then
      Error(Concatenation("Failure when processing ",filename));
    fi;
  od;
end;

# implementing ls <dir>/<prefix>*
PrefixMatchedListDir := function(dir, prefix)
  return Filtered(IO_ListDir(dir),
                 x->ForAll([1..Length(prefix)], y->x[y]=prefix[y]));
end;
