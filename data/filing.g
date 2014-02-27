PaddedNumString := function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end;
  
  # semigroup -> string containing green info
GreenTag := function (sgp,ndigits)
  return Concatenation("LRD_",
                 PaddedNumString(NrLClasses(sgp),ndigits),"_",
                 PaddedNumString(NrRClasses(sgp),ndigits),"_",
                 PaddedNumString(NrDClasses(sgp),ndigits));
end;

SgpTag := function (sgp,ndigits)
  return Concatenation("S_",PaddedNumString(Size(sgp),ndigits),
                 "_",GreenTag(sgp));
end;

BLGreenTag := function(bl,mt,ndigits)
local sgp;
  sgp := Semigroup(ElementsByIndicatorSet(bl,mt));
  return GreenTag(sgp,ndigits);
end;

#to make this into a function use: x->BLSizeTag(bl,3);
BLSizeTag := function(bl,digits)
  return Concatenation("size", PaddedNumString(SizeBlist(bl),digits));
end;

#list of indicatorsets,
#multab
#tagger function : indicator set -> string (should work in all cases)
#filename
#separating indicatorsets into files by their tags
FilingIndicatorSets := function(sets,mt,taggerfunc,filename)
  local classes, tag,s,sgp,counter;
  counter := 0;
  classes := AssociativeList(); # tags to open classes
  for s in sets do
    counter := counter +1;
    #sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := taggerfunc(s);#SgpTag(sgp,3);
    Collect(classes, tag, s);
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter)," ",
           FormattedMemoryString(MemoryUsage(classes))," ",
           FormattedBigNumberString(String(Size(Keys(classes))))," ",
           FormattedPercentageString(Size(Keys(classes)),counter));
    fi;
  od;
  #writing the classes out to files
  Perform(Keys(classes), function(x)
    SaveIndicatorSets(classes[x],Concatenation(filename,x));end);
end;

Konv := function(filename,mt)
  WriteGenerators(Concatenation(filename,".smallgens"),
          List(LoadIndicatorSets(filename),
          x->SmallGeneratingSet(Semigroup(ElementsByIndicatorSet(x,mt)))));
end;
