# filing - to separate bitlists into different classes based on the output
# of some given function
# the tagging function gives a string, that goes into 
# the filename, thus we get separate files for the classes

# just to have padded zeros
PaddedNumString := function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end;

NrEdgesInHasseDiagramOfDClasses := function(sgp)
  local hd;
  #producing the Hasse diagram of DClasses
  hd := HasseDiagramBinaryRelation(
                BinaryRelationByListOfImages(
                        DirectedGraphReflexiveTransitiveClosure(
                                PartialOrderOfDClasses(sgp))));
  #calculating the number of edges (summing the sizes of the image sets)
  return Sum(List(Source(hd), x-> Size(Images(hd,x))));;
end;

# semigroup -> string containing green info
GreenTag := function (sgp,ndigits)
  local s;
  if GroupOfUnits(sgp) <> fail then
    s := Concatenation("_G", PaddedNumString(Size(GroupOfUnits(sgp)),ndigits));
  else
    s := "";
  fi;

  return Concatenation("L",PaddedNumString(NrLClasses(sgp),ndigits),
                 "_R",PaddedNumString(NrRClasses(sgp),ndigits),
                 "_D",PaddedNumString(NrDClasses(sgp),ndigits),
                 "_RD",PaddedNumString(NrRegularDClasses(sgp),ndigits),
                 "_M",PaddedNumString(Size(MaximalDClasses(sgp)),ndigits),
                 "_E",PaddedNumString(NrEdgesInHasseDiagramOfDClasses(sgp),
                         ndigits),s);
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
    DisplayString(sgp); #to avoid GroupOfUnits crashing #101 
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

BlistToSmallGenSet := function(indset, mt)
  return SmallSemigroupGeneratingSet(ElementsByIndicatorSet(indset,mt));
end;

#TODO the two functions below are copy-paste twins, better abstraction needed
#assumed input is .ais files
GensFileIsomClasses := function(filename)
  local prefix, sgps, idpclasses, digits,i,al,iso, counter,sgpclasses,class;
  prefix := filename{[1..Size(filename)-4]};
  counter:=1;
  al := AssociativeList();
  #memory saving idea - not storing all semigroups
  # frequency profiles -> generator sets
  Perform(ReadGenerators(filename),function(x)
    Collect(al,IdempotentFrequencies(MulTab(Semigroup(x))),x);end);
  idpclasses := Filtered(ValueSet(al),x->Size(x)>1);
  digits := Size(String(Size(idpclasses))); #just an upper bound  
  for class in idpclasses do
    sgps := List(class, Semigroup);
    sgpclasses := Filtered(SgpIsomorphismClasses(sgps),x->Size(x)>1);
    for iso in sgpclasses do
      if not WriteGenerators(
                 Concatenation(prefix,"_",
                         PaddedNumString(counter,digits),".iso"),
                 iso,"w") then
        Error(Concatenation("Failure when processing ",filename));
      fi;
      counter := counter + 1;
    od;
  od;
end;

#assumed input is .gens files
GensFileAntiAndIsomClasses := function(filename)
  local prefix,sgps,idpclasses,digits,i,al,iso,counter,sgpclasses,class,gensets;
  gensets := ReadGenerators(filename); 
  if Size(gensets)=1 then return; fi; #nothing to do
  prefix := filename{[1..Size(filename)-5]};
  counter:=1;
  al := AssociativeList();
  #memory saving idea - not storing all semigroups
  # frequency profiles -> generator sets
  Perform(gensets,function(x)
    Collect(al,IdempotentFrequencies(MulTab(Semigroup(x))),x);end);
  idpclasses := Filtered(ValueSet(al),x->Size(x)>1);
  digits := Size(String(Size(idpclasses))); #just an upper bound  
  for class in idpclasses do
    sgps := List(class, Semigroup);
    sgpclasses := Filtered(SgpAntiAndIsomorphismClasses(sgps),x->Size(x)>1);
    for iso in sgpclasses do
      if not WriteGenerators(
                 Concatenation(prefix,"_",
                         PaddedNumString(counter,digits),".ais"),
                 iso,"w") then
        Error(Concatenation("Failure when processing ",filename));
      fi;
      counter := counter + 1;
    od;
  od;
end;

#assumed input is an .ais file
AntiAndIsomClassToIsomClasses := function(filename)
  local prefix, sgps, digits,i,iso,sgpclasses, counter;
  prefix := filename{[1..Size(filename)-4]};
  sgps := List(ReadGenerators(filename), Semigroup);
  sgpclasses := SgpIsomorphismClasses(sgps);
  if Size(sgpclasses) = 1 then return; fi; #no anti-isomorphism
  digits := Size(String(Size(sgpclasses))); #just an upper bound  
  counter:=1;
  for iso in sgpclasses do
    if not WriteGenerators(
               Concatenation(prefix,"_",
                       PaddedNumString(counter,digits),".iso"),
               iso,"w") then
      Error(Concatenation("Failure when processing ",filename));
    fi;
    counter := counter + 1;
  od;  
end;

#the frequency distribution vector
SizeDistDataOfSgpIndicatorSets := function(subreps)
  local collected, sizes, N, result; 
  sizes := List(subreps, SizeBlist);
  N := Maximum(sizes);
  collected := Collected(sizes);
  result := ListWithIdenticalEntries(N,0);
  Perform(collected, function(x) result[x[1]]:=x[2];end);
  Add(result, 1,1); # for the empty set
  return result;
end;

### getting some file lists - bit clumsy methods TODO check io package for this
# implementing ls <dir>/<prefix>*
PrefixMatchedListDir := function(dir, prefix)
  return Filtered(IO_ListDir(dir), x->1=PositionSublist(x,prefix));
end;

PostfixMatchedListDir := function(dir, postfix)
  return Filtered(IO_ListDir(dir),x-> x = postfix or (Size(x)>=Size(postfix)
                 and Size(x)-Size(postfix)+1
                     =PositionSublist(x, postfix, Size(x)-Size(postfix))));
end;

PrefixPostfixMatchedListDir := function(dir, prefix, postfix)
  return Intersection(PrefixMatchedListDir(dir,prefix),
                 PostfixMatchedListDir(dir,postfix));
end;

ClassifySubsemigroups := function(S, G , prefix) 
  local mt,subreps,ndigits;
  ndigits := Size(String(Size(S)));
  SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  mt := MulTab(S,G);
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  SaveIndicatorSets(subreps,Concatenation(prefix{[1..Size(prefix)-1]},".reps"));
  IndicatorSetsTOClassifiedSmallGenSet(subreps,mt,prefix,ndigits);#,
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileAntiAndIsomClasses);
  Perform(PrefixPostfixMatchedListDir(".",prefix,"ais"),
          AntiAndIsomClassToIsomClasses);
end;

SgpHeatMap := function(prefix, key1, key2)
local tag1,tag2,is,s,sum, filename, al, alltags;
  sum := 0;
  al := AssociativeList();
  Perform(PrefixPostfixMatchedListDir(".", prefix, ".gens"),
          function(x) Assign(al, x, Size(ReadGenerators(x)));end);
  TransformKeys(al, x-> x{[Length(prefix)..Length(x)-4]}); # in general this is super crazy, but here keys will remain unique
  filename := Concatenation(prefix,key1,"vs",key2,".dat");
  PrintTo(filename,""); #erasing
  alltags := Set(Concatenation(List(Keys(al), x->Set(SplitString(x,"_.")))));
  for tag1 in Filtered(alltags, x->key1=Maximum(SplitString(x,"0123456789"))) do 
    for tag2 in Filtered(alltags, x->key2=Maximum(SplitString(x,"0123456789"))) do
      is := Intersection(Filtered(Keys(al), x->fail<>PositionSublist(x,Concatenation("_",tag1))) ,
                    Filtered(Keys(al), x->fail<>PositionSublist(x,Concatenation("_",tag2))));
      if not IsEmpty(is) then Display(is); fi;
      s := Sum(List(is,x->al[x]));
      sum := sum + s;
      AppendTo(filename,Filtered(tag1, IsDigitChar)," ",Filtered(tag2, IsDigitChar)," ", s, "\n");
    od;
  od;
  Display(sum);
end;
