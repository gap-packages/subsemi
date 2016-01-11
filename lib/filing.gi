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

# I semigroup or ideal, J an ideal of I
# output: .reps file containing Sub(I/J), also as upper torsos
# G - the symmetries
ImodJSubs := function(I, J, Iname, Jname, G)
local rfh, T, mtT, reps,mtI, preimgs, elts, otf, f;
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
  otf := OutputTextFile(Concatenation(Name(T),".uppertorsos"),false);
  f := function(s)
    local indfunc, torso;
    NormalizeWhitespace(s);
    indfunc := AsBlist(DecodeBitString(s));
    torso := SetByIndicatorFunction(indfunc,elts);
    if fail in torso then Remove(torso,Position(torso,fail));fi;
    if not IsEmpty(torso) then
      WriteLine(otf,EncodeBitString(AsBitString(
              IndicatorFunction(torso,mtI))));
    fi;
    return true;
  end;
  TextFileProcessor(Concatenation(Name(T),".reps"), f);
end;

ISubsFromJUpperTorsos := function(I, J, uppertorsosfile, G)
  local U, result, mt, gens, time, torsos;
  SetInfoLevel(SubSemiInfoClass,0);#because this is used in parallel
  time := TimeInSeconds();
  result := [];
  mt := MulTab(I,G);
  gens := IndicatorFunction(AsList(J), Elts(mt));
  torsos := LoadIndicatorFunctions(uppertorsosfile);
  for U in torsos do
    Append(result, AsList(
            SubSgpsByMinExtensionsParametrized(mt, U, gens, Stack(),
                    BlistStorage(Size(mt)),[])));
  od;
  SaveIndicatorFunctions(result,Concatenation(uppertorsosfile,"M"));;
  PrintTo(Concatenation(uppertorsosfile,"F"),String(TimeInSeconds()-time));
end;

################################################################################
### COMPREHENSIVE ##############################################################
################################################################################

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

# short string tag for groups
GrpTag := function(G)
  return JoinStringsWithSeparator([StructureDescription(G:short),
                                   String(IdSmallGroup(G)[1]),
                                   String(IdSmallGroup(G)[2])],
                                  "_");
end;

TagSgpsFromFile := function(infile, outfile, mt)
  local outf, f, nrdigits;
  nrdigits := Size(String(Size(mt)));
  outf := OutputTextFile(outfile, false);
  f := function(s)
    local S, bl;
    bl := AsBlist(DecodeBitString(s));
    S := Semigroup(SetByIndicatorFunction(bl,mt));
    WriteLine(outf,
            JoinStringsWithSeparator(
            [s, SgpTag(S,nrdigits), GrpTag(AutomorphismGroup(S)),
             GrpTag(Stabilizer(SymmetryGroup(mt),bl,OnFiniteSet))],
                    " "));
    return true;
  end;
  TextFileProcessor(infile, f);
  CloseStream(outf);
end;

SgpsDatabase := function(infile, mt)
  TagSgpsFromFile(infile, Concatenation(infile,DB@),mt);
end;

SgpsDatabaseToClassFiles := function(infile, prefix)
  TextFileProcessor(infile,
    function(s)
    local otf, l;
    l := SplitString(s," ");
    otf := OutputTextFile(Concatenation(prefix,"_",l[2],".reps"),true);
    if not WriteLine(otf,l[1]) then return false; fi;
    CloseStream(otf);
    return true;
  end);
end;

IsomClasses := function(filename, mt)
  local prefix, sgps, digits, counter,sgpclasses,class, cf;
  prefix := filename{[1..Maximum(Positions(filename,'.'))-1]};
  counter:=1;
  sgps := List(LoadIndicatorFunctions(filename),
               x-> Semigroup(SetByIndicatorFunction(x,mt)));
  cf := x->Classify(x, MulTab, IsIsomorphicMulTab);
  sgpclasses := cf(sgps);
  if Size(sgpclasses) = 1 then return; fi;
  digits := Size(String(Maximum(List(sgpclasses,Size))));
  for class in sgpclasses do
    if not SaveIndicatorFunctions(
               List(class,x->IndicatorFunction(AsList(x),mt)),
               Concatenation(prefix,".",
                       PaddedNumString(counter,digits),".isom")) then
      Error(Concatenation("Failure when processing ",filename));
    fi;
    counter := counter + 1;
  od;
end;

DetectAntiIsomClasses := function(prefix, mt)
  local indices, classes, eqf, f, c;
  indices := List(PrefixPostfixMatchedListDir(".", prefix, ".isom"),
                  x -> SplitString(x,".")[2]);
  f := x -> MulTab(
               Semigroup(
                       SetByIndicatorFunction(
                               LoadIndicatorFunctions(
                                       Concatenation(prefix,".",
                                               x,".isom"))[1],mt)));
  eqf := function(mt1, mt2)
          return IsIsomorphicMulTab(mt1, CopyMulTab(mt2, true));
        end;
  classes := Filtered(Classify(indices, f, eqf), x-> Size(x)>1);
  for c in classes do
    PrintTo(Concatenation(prefix, ".", JoinStringsWithSeparator(c,"+")),"");
  od;
end;

# S semigroup, G automorphism group, prefix filename begins with this
InstallGlobalFunction(FileSubsemigroups,
function(S, G , prefix)
  local mt,subreps,ndigits, repsfile, isomcls;
  mt := MulTab(S,G);
  #generators for the record
  WriteGenerators(Concatenation(prefix,ELTS@), Elts(mt));
  Print("Calculating subsgps of ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  repsfile := Concatenation(prefix,".set");
  SaveIndicatorFunctions(subreps, repsfile);
  Print("Classifying subsgps of ",prefix,"\n\c");
  SgpsDatabase(repsfile, mt);
  SgpsDatabaseToClassFiles(Concatenation(repsfile, DB@),prefix);
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  Perform(PrefixPostfixMatchedListDir(".",prefix,"reps"),
          function(x) IsomClasses(x,mt);end);
  isomcls := Set(PrefixPostfixMatchedListDir(".", prefix, ".isom"),
                 x->SplitString(x,".")[1]);
  Perform(isomcls, function(x) DetectAntiIsomClasses(x,mt);end);
  GNUPlotDataFromSizeVector(List(subreps, SizeBlist),
          Concatenation(prefix,"sizedist.dat"));
end);
