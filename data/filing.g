# semigroup -> string containing green info
GreenTag := function (sgp)
  return Concatenation("LRD_",
                 String(NrLClasses(sgp)),"_",
                 String(NrRClasses(sgp)),"_",
                 String(NrDClasses(sgp)));
end;

SgpTag := function (sgp,ndigits)
  return Concatenation("S_",ReplacedString(String(Size(sgp),ndigits)," ","0"),"_",GreenTag(sgp));
end;

#list of indicatorsets,
#multab
#tagger function : indicator set -> string
#filename
#separating indicatorsets into files by their tags
FilingIndicatorSets := function(sets,mt,taggerfunc,filename)
  local classes, tag,s,sgp,counter;
  counter := 0;
  if EmptySet(mt) in sets then 
    Remove(sets, Position(sets,EmptySet(mt)));
  fi;
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
  Perform(Keys(classes), function(x)
    SaveIndicatorSets(classes[x],Concatenation(filename,"_",x));end);
  #return classes;
end;

Konv := function(filename,mt)
  WriteGenerators(Concatenation(filename,".smallgens"),
          List(LoadIndicatorSets(filename),
          x->SmallGeneratingSet(Semigroup(ElementsByIndicatorSet(x,mt)))));
end;
