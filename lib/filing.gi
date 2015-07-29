# filing - to separate bitlists into different classes based on the output
# of some given function
# the tagging function gives a string, that goes into 
# the filename, thus we get separate files for the classes

################################################################################
### TAGGING ####################################################################
################################################################################
# just to have padded zeros
PaddedNumString := function(n,ndigits)
  return ReplacedString(String(n,ndigits)," ","0");
end;

ReflexiveReduction := function(rel)
  return List([1..Length(rel)], x -> Filtered(rel[x], y -> not x = y));
end;

TransitiveReduction := function(rel)
  return List([1..Length(rel)], x -> Difference(rel[x], Union(rel{rel[x]})));
end;

NrEdgesInHasseDiagramOfDClasses := function(sgp)
  #getting the 1s out of the longest distances in the digraph
  return Size(Positions(Flat(DigraphLongestDistances(
                 Digraph(PartialOrderOfDClasses(sgp)))),1));
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
  return GreenTag(Semigroup(SetByIndicatorFunction(bl,mt)),ndigits);
end;

# tagging indicator set - includes converting to semigroup
BLSgpTag := function(bl,mt,ndigits)
  return SgpTag(Semigroup(SetByIndicatorFunction(bl,mt)),ndigits);
end;

################################################################################
### FILING INDICATOR FUNCTIONS #################################################
################################################################################

#generic function for processing a textfile line by line
#infile - the name of the input file
#processor - a function that takes a line of infile and returns true if it was 
#properly processed
TextProcessor := function(infile, processor)
  local s,counter,itf;
  counter := 0;
  itf := InputTextFile(infile);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    counter := counter + 1;
    if not processor(s) then
      Error(s);
    fi;
    if InfoLevel(SubSemiInfoClass)>0 ###########################################
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter)," of ",infile);
    fi; ########################################################################
    s := ReadLine(itf);
  until s=fail; #TODO any check for failing before end of file?
  CloseStream(itf);
end;

#still generic
#tagger function : indicator set -> string (should work in all cases)
#separating IndicatorFunctions into files by their tags
# the memory usage is minimal, but puts strain on the kernel I/O
FilingIndicatorFunctions := function(infile,taggerfunc)
  TextProcessor(infile, function(s)
                          local indfunc,otf;
                          indfunc := AsBlist(DecodeBitString(s));
                          otf := OutputTextFile(taggerfunc(indfunc),true); 
                          if not WriteLine(otf,s) then return false; fi;
                          CloseStream(otf);
                          return true;
                        end);
end;

FilingIndicatorFunctionsBySize := function(infile,ndigits)
  FilingIndicatorFunctions(infile,
          x->Concatenation("S",PaddedNumString(SizeBlist(x),ndigits)));
end;

FilingIndicatorFunctionsBySgpTag := function(infile,mt,prefix,ndigits)
  TextProcessor(infile,
          function(s)
             local sgp, tag;
             sgp := Semigroup(SetByIndicatorFunction(
                            AsBlist(DecodeBitString(s)),mt));
             tag := SgpTag(sgp,ndigits);
             if not WriteGenerators(Concatenation(prefix,tag,".gens"),
                        SmallSemigroupGeneratingSet(sgp),"a") then
               return false;
             fi;
             return true;
           end);
end;  

RecodeIndicatorFunctionFile := function(infile, outfile, mt, MT)
  local otf;  
  otf := OutputTextFile(outfile,false);
  TextProcessor(infile,
          function(s)
            local indfunc;
            indfunc := AsBlist(DecodeBitString(s));
            if not  WriteLine(otf,EncodeBitString(AsBitString(
                       RecodeIndicatorFunction(indfunc,
                               SortedElements(mt),
                               SortedElements(MT))))) then
              return false;
            fi;
            return true;
          end);
  CloseStream(otf);
end;

#used in ui.gi
BlistToSmallGenSet := function(indfunc, mt)
  return SmallSemigroupGeneratingSet(SetByIndicatorFunction(indfunc,mt));
end;

################################################################################
### ISOMORPHISM ################################################################
################################################################################

#generic function
ClassProcessor := function(filename, classifierfunc, ext, preprocess)
  local prefix, sgps, idpclasses, digits,i,al,iso, counter,sgpclasses,class;
  prefix := filename{[1..Maximum(Positions(filename,'.'))-1]};
  counter:=1;  
  #memory saving idea - not storing all semigroups
  # frequency profiles -> generator sets
  if preprocess then
    al := AssociativeList();
    Perform(ReadGenerators(filename),function(x)
      Collect(al,IdempotentFrequencies(MulTab(Semigroup(x))),x);end);
    idpclasses := Filtered(ValueSet(al),x->Size(x)>1);
    if IsEmpty(idpclasses) then return; fi;
  else
    idpclasses := [ReadGenerators(filename)];
  fi;
  #now going through the prefiltered classes
  digits := Size(String(Maximum(List(idpclasses,Size))));
  counter:=1;  
  for class in idpclasses do
    sgps := List(class, Semigroup);
    sgpclasses := Filtered(classifierfunc(sgps),x->Size(x)>1);
    for iso in sgpclasses do
      if not WriteGenerators(
                 Concatenation(prefix,"_",
                         PaddedNumString(counter,digits),ext),
                 iso,"w") then
        Error(Concatenation("Failure when processing ",filename));
      fi;
      counter := counter + 1;
    od;
  od;
end;

GensFileIsomClasses := function(filename)
  ClassProcessor(filename, sgps->Classify(sgps, MulTab, IsIsomorphicMulTab),
          ".iso", true);
end;

GensFileAntiAndIsomClasses := function(filename)
  local f;
  f := sgps -> Classify(sgps, MulTab,
               function(x,y)
                 return IsIsomorphicMulTab(x,y)
                        or IsIsomorphicMulTab(x,CopyMulTab(y,true));end);
  ClassProcessor(filename, f, ".ais", true);
end;

# assume .ais files as input
AntiAndIsomClassToIsomClasses := function(filename)
  ClassProcessor(filename, sgps->Classify(sgps, MulTab, IsIsomorphicMulTab),
          ".iso", false);
end;

################################################################################
### GNUPLOT ####################################################################
################################################################################

#the frequency distribution vector
# gnuplot code:
# set terminal tikz size 14cm,7cm
# set style fill transparent solid 0.5 border
# set output "T4size6peaks.tikz"
# set xlab "size of semigroup"
# set xrange [-1:140]
# set grid
# plot "T4sizedist.dat" with boxes lc rgb"black" title "Sub(T4)"
GNUPlotDataFromSizeVector := function(sizes, filename)
  local N, al, i; 
  N := Maximum(sizes);
  al := AssociativeList();
  Perform(Collected(sizes), function(x) Assign(al, x[1], x[2]);end);
  PrintTo(filename,""); # erasing
  for i in [0..N] do
    if ContainsKey(al, i) then
      AppendTo(filename, String(i)," ",String(al[i]),"\n");
    else
      AppendTo(filename, String(i)," 0\n");
    fi;
  od;
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

# input: classified .gens files having the same prefix
# key1, key2: which data items to plot agains, e.g "S", "D" produces heatmap
# showing the distribution of subsemigroups of all possible size and #D-class pairs
# gnuplot> set palette defined (0 1 1 1, 0 0 0 0.5, 1 0 0 1, 2 0 0.5 1, 3 0 1 1, 4 0.5 1 0.5, 5 1 1 0, 6 1 0.5 0, 7 1 0 0, 8 0.5 0 0)
# gnuplot> set xlab "size"
# gnuplot> set ylab "#D-classes"
# gnuplot> plot "J5SvsD.dat" with image title "J5"
SgpHeatMap := function(prefix, key1, key2)
local tag1,tag2,is,s,sum, filename, al, alltags, maxi,maxj, i ,j, bl;
  sum := 0; maxi := 0; maxj := 0; 
  al := AssociativeList(); # truncated .gens filename -> number of lines
  bl := AssociativeList(); # [int,int] -> int (sparse matrix)
  Perform(PrefixPostfixMatchedListDir(".", prefix, ".gens"),
          function(x)
            local file;
            file := IO_File(x);
            Assign(al, x, Size(IO_ReadLines(file)));
            IO_Close(file);
          end);
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
      i := Int(Filtered(tag1, IsDigitChar));
      if i > maxi then maxi := i; fi;
      j := Int(Filtered(tag2, IsDigitChar));
      if j > maxj then maxj := j; fi;
      Assign(bl, [i,j], s);

    od;
  od;
  for i in [1..maxi] do
    for j in [1..maxj] do
      if ContainsKey(bl,[i,j]) then
        AppendTo(filename,i," ",j," ", bl[[i,j]], "\n");
      else
        AppendTo(filename,i," ",j," 0\n");
      fi;
    od;
  od;
  Display(sum);
end;

# I semigroup or ideal, J an ideal of I
# output: .reps file containing Sub(I/J), also as upper torsos
# G - the symmetries
ImodJSubs := function(I,J,Iname, Jname,G)
local rfh, T, mtT, reps,mtI, preimgs, elts, itf, otf, s, indfunc, torso;
  rfh := ReesFactorHomomorphism(J);
  T := Range(rfh);
  SetName(T,Concatenation(Iname,"mod",Jname));
  mtT := MulTab(T,G,rfh);
  reps := SubSgpsByMinExtensions(mtT);
  SaveIndicatorFunctions(reps, Concatenation(Name(T),".reps"));
  mtI := MulTab(I);
  preimgs := List(SortedElements(mtT),x->PreImages(rfh,x));
  elts := List(preimgs,
               function(x) 
                 if Size(x)> 1 then return fail;else return x[1];fi;end);
  itf := InputTextFile(Concatenation(Name(T),".reps"));
  otf := OutputTextFile(Concatenation(Name(T),".uppertorsos"),false);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    indfunc := AsBlist(DecodeBitString(s));
    torso := SetByIndicatorFunction(indfunc,elts);
    if fail in torso then Remove(torso,Position(torso,fail));fi;
    if not IsEmpty(torso) then
      WriteLine(otf,EncodeBitString(AsBitString(
              IndicatorFunction(torso,mtI))));
    fi;
    s := ReadLine(itf);
  until s=fail;
end;

ISubsFromJUpperTorsos := function(I,J,uppertorsosfile,G)
  local U, result, mt, gens, time, torsos;
  SetInfoLevel(SubSemiInfoClass,0);#because this is used in parallel
  time := TimeInSeconds();
  result := [];
  mt := MulTab(I,G);
  gens := IndicatorFunction(AsList(J), SortedElements(mt));
  torsos := LoadIndicatorFunctions(uppertorsosfile);
  for U in torsos do
    Append(result, AsList(
            SubSgpsByMinExtensionsParametrized(mt, U, gens, Stack(),[])));
  od;
  SaveIndicatorFunctions(result,Concatenation(uppertorsosfile,"M"));;
  PrintTo(Concatenation(uppertorsosfile,"F"),String(TimeInSeconds()-time));
end;

################################################################################
### COMPREHENSIVE ##############################################################
################################################################################

ClassifySubsemigroups := function(S, G , prefix) 
  local mt,subreps,ndigits, repsfile;
  ndigits := Size(String(Size(S)));
  #SemigroupsOptionsRec.hashlen := NextPrimeInt(2*Size(S)); 
  mt := MulTab(S,G);
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  repsfile := Concatenation(prefix{[1..Size(prefix)-1]},".reps");
  SaveIndicatorFunctions(subreps, repsfile);
  FilingIndicatorFunctionsBySgpTag(repsfile,mt,prefix,ndigits);
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixMatchedListDir(".",prefix),GensFileAntiAndIsomClasses);
  Perform(PrefixPostfixMatchedListDir(".",prefix,"ais"),
          AntiAndIsomClassToIsomClasses);
  GNUPlotDataFromSizeVector(List(subreps, SizeBlist),
          Concatenation(prefix,"sizedist.dat"));
end;
