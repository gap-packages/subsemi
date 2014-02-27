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

# file of indicatorsets, multab -> separating into files with greentag classes
GreenFilingSemigroupIndicatorSets := function(filename,mt)
  local sets, classes, tag,s,sgp;
  sets := LoadIndicatorSets(filename);
  if EmptySet(mt) in sets then 
    Remove(sets, Position(sets,EmptySet(mt)));
  fi;
  classes := AssociativeList();
  for s in sets do
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := GreenTag(sgp);
    Collect(classes, tag, s);
  od;
  Perform(Keys(classes), function(x)
    SaveIndicatorSets(classes[x],Concatenation(filename,x));end);
end;

#list of indicatorsets, multab -> associative list: greentag -> indicatorset
FilingSemigroupIndicatorSetsPreloaded := function(sets,mt,filename)
  local classes, tag,s,sgp,counter;
  counter := 0;
  if EmptySet(mt) in sets then 
    Remove(sets, Position(sets,EmptySet(mt)));
  fi;
  classes := AssociativeList(); # tags to open classes
  for s in sets do
    counter := counter +1;
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := SgpTag(sgp,3);
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
