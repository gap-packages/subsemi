GreenTag := function (sgp)
  return Concatenation("LRD_",
                 String(NrLClasses(sgp)),"_",
                 String(NrRClasses(sgp)),"_",
                 String(NrDClasses(sgp)));
end;

SgpTag := function (sgp)
  return Concatenation("S_",String(Size(sgp)),"_",GreenTag(sgp));
end;

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


#isf - only one dot is allowed in the filename
FilingSemigroupIndicatorSets := function(isf,mt)
  local sets,filename, extension, files, tag,s,sgp;
  filename :=  isf{[1..Position(isf,'.')-1]};
  extension := isf{[Position(isf,'.')..Size(isf)]};
  sets := LoadIndicatorSets(isf);
  Remove(sets, Position(sets,EmptySet(mt)));
  files := AssociativeList(); # tags to open files
  for s in sets do
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := SgpTag(sgp);
    if not ContainsKey(files, tag) then
      Assign(files, tag, OutputTextFile( Concatenation(filename,"_",tag,extension), false));
    fi;
    AppendTo(files[tag], EncodeBitString(AsBitString(s)),"\n");
  od;
  Perform(Keys(files),function(key)CloseStream(files[key]);end);
end;

#isf - only one dot is allowed in the filename
FilingSemigroupIndicatorSetsPreloaded := function(sets,mt,filename, extension)
  local files, tag,s,sgp;
  Remove(sets, Position(sets,EmptySet(mt)));
  files := AssociativeList(); # tags to open files
  for s in sets do
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := SgpTag(sgp);
    if not ContainsKey(files, tag) then
      Assign(files, tag, OutputTextFile( Concatenation(filename,"_",tag,extension), false));
    fi;
    AppendTo(files[tag], EncodeBitString(AsBitString(s)),"\n");
  od;
  Perform(Keys(files),function(key)CloseStream(files[key]);end);
end;


SoftFilingSemigroupIndicatorSetsPreloaded := function(sets,mt)
  local files, tag,s,sgp,counter;
  counter := 0;
  if EmptySet(mt) in sets then 
    Remove(sets, Position(sets,EmptySet(mt)));
  fi;
  files := AssociativeList(); # tags to open files
  for s in sets do
    counter := counter +1;
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := SgpTag(sgp);
    Collect(files, tag, s);
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter)," ",FormattedMemoryString(MemoryUsage(files))," ",FormattedBigNumberString(String(Size(Keys(files))))," ",FormattedPercentageString(Size(Keys(files)),counter));
    fi;

    #AppendTo(files[tag], EncodeBitString(AsBitString(s)),"\n");
  od;
  return files;#Perform(Keys(files),function(key)CloseStream(files[key]);end);
end;
