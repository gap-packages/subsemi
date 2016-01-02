################################################################################
##
## SubSemi
##
## Functions for putting subsets, subsgps into separate files according to
## some classification.
##
## Copyright (C) 2015-2016  Attila Egri-Nagy
##

# filing - to separate bitlists into different classes based on the output
# of some given function
# the tagging function gives a string, that goes into
# the filename, thus we get separate files for the classes


################################################################################
### FILING INDICATOR FUNCTIONS #################################################
################################################################################

#still generic
#tagger function : indicator set -> string (should work in all cases)
#separating IndicatorFunctions into files by their tags
# the memory usage is minimal, but puts strain on the kernel I/O
FilingIndicatorFunctions := function(infile,taggerfunc)
  TextFileProcessor(infile,
          function(s)
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

RecodeIndicatorFunctionFile := function(infile, outfile, mt, MT)
  local otf;
  otf := OutputTextFile(outfile,false);
  TextFileProcessor(infile,
          function(s)
            local indfunc;
            indfunc := AsBlist(DecodeBitString(s));
            return WriteLine(otf,EncodeBitString(AsBitString(
                           RecodeIndicatorFunction(indfunc,
                                   Elts(mt),Elts(MT)))));
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
ClassProcessor := function(filename, mt, classifierfunc, ext)
  local prefix, sgps, digits, counter,sgpclasses,class;
  prefix := filename{[1..Maximum(Positions(filename,'.'))-1]};
  counter:=1;
  sgps := List(LoadIndicatorFunctions(filename),
               x-> Semigroup(SetByIndicatorFunction(x,mt)));
  sgpclasses := classifierfunc(sgps);
  digits := Size(String(Maximum(List(sgpclasses,Size))));
  for class in sgpclasses do
    if not SaveIndicatorFunctions(
               List(class,x->IndicatorFunction(AsList(x),mt)),
               Concatenation(prefix,"_",
                       PaddedNumString(counter,digits),ext)) then
      Error(Concatenation("Failure when processing ",filename));
    fi;
    counter := counter + 1;
  od;
end;

GensFileIsomClasses := function(filename,mt)
  ClassProcessor(filename, mt, sgps->Classify(sgps, MulTab, IsIsomorphicMulTab),
          ".isom");
end;

GensFileAntiAndIsomClasses := function(filename,mt)
  local f;
  f := sgps -> Classify(sgps, MulTab,
               function(x,y)
                 return IsIsomorphicMulTab(x,y)
                        or IsIsomorphicMulTab(x,CopyMulTab(y,true));end);
  ClassProcessor(filename, mt, f, ".ais");
end;

# assume .ais files as input
AntiAndIsomClassToIsomClasses := function(filename,mt)
  ClassProcessor(filename, mt, sgps->Classify(sgps, MulTab, IsIsomorphicMulTab),
          ".isom");
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
# assuming no zero size value
GNUPlotDataFromSizeVector := function(sizes, filename)
  local N, l, i, p;
  N := Maximum(sizes);
  l := List([1..N], x->0);
  Perform(Collected(sizes), function(x) l[x[1]] := x[2];end);
  PrintTo(filename,""); # erasing
  for i in [1..N] do
    AppendTo(filename, String(i)," ",String(l[i]),"\n");
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
  preimgs := List(Elts(mtT),x->PreImages(rfh,x));
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
  gens := IndicatorFunction(AsList(J), Elts(mt));
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

# S semigroup, G automorphism group, prefix filename begins with this
InstallGlobalFunction(FileSubsemigroups,
function(S, G , prefix)
  local mt,subreps,ndigits, repsfile, tagger;
  ndigits := Size(String(Size(S)));
  mt := MulTab(S,G);
  WriteGenerators(Concatenation(prefix,".elts"), Elts(mt));
  Print("Calculating and classifying ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  repsfile := Concatenation(prefix,".reps");
  SaveIndicatorFunctions(subreps, repsfile);
  tagger := function(indfunc)
    return Concatenation(prefix, "_",
             SgpTag(Semigroup(SetByIndicatorFunction(indfunc,mt)),ndigits),
             ".set");
  end;
  FilingIndicatorFunctions(repsfile,tagger);
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixPostfixMatchedListDir(".",prefix,"set"),
          function(x)GensFileAntiAndIsomClasses(x,mt);end);
  Perform(PrefixPostfixMatchedListDir(".",prefix,"ais"),
          function(x)AntiAndIsomClassToIsomClasses(x,mt);end);
  GNUPlotDataFromSizeVector(List(subreps, SizeBlist),
          Concatenation(prefix,"sizedist.dat"));
end);

SaveTaggedSgps := function(sgps, mt, outfile)
  local otf, s, nrdigits;
  otf := OutputTextFile(outfile, false);
  nrdigits := Size(String(Size(mt)));
  for s in sgps do
    WriteLine(otf,Concatenation(
            EncodeBitString(AsBitString(s)),
            " ",
            SgpTag(Semigroup(SetByIndicatorFunction(s,mt)),nrdigits)));
  od;
  CloseStream(otf);
end;

TagSgpsFromFile := function(infile, outfile, mt)
  local outf, f, nrdigits;
  nrdigits := Size(String(Size(mt)));
  outf := OutputTextFile(outfile, false);
  f := function(s)
    WriteLine(outf,Concatenation(
            s,
            " ",
            SgpTag(Semigroup(SetByIndicatorFunction(
                    AsBlist(DecodeBitString(s)),mt)),
                   nrdigits)));
    return true;
  end;
  TextFileProcessor(infile, f);
  CloseStream(outf);
end;
