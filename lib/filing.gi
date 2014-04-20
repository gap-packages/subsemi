# filing - to separate bitlists into different files based on the output
# of some given function, the function gives a string, that goes into 
# the filename, thus we get separate files for the classes

# just to have padded zeros
PaddedNumString := function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end;
  
# semigroup -> string containing green info
GreenTag := function (sgp,ndigits)
  return Concatenation("L",PaddedNumString(NrLClasses(sgp),ndigits),
                 "_R",PaddedNumString(NrRClasses(sgp),ndigits),
                 "_D",PaddedNumString(NrDClasses(sgp),ndigits));
end;

# tagging semigroup by size and Greens
SgpTag := function (sgp,ndigits)
  return Concatenation("S",PaddedNumString(Size(sgp),ndigits),
                 "_",GreenTag(sgp,ndigits));
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

# convert the raw bitlists to set of small generators
BlistToTSGens := function(indsetfile,mt)
  WriteGenerators(Concatenation(indsetfile,".gens"),
          List(LoadIndicatorSets(indsetfile),
               x->SmallSemigroupGeneratingSet(
                       Semigroup(ElementsByIndicatorSet(x,mt)))));
end;

# implementing ls <dir>/<prefix>*
PrefixMatchedListDir := function(dir, prefix)
  return Filtered(IO_ListDir(dir),
                 x->ForAll([1..Length(prefix)], y->x[y]=prefix[y]));
end;
