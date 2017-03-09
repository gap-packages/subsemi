################################################################################
##
## SubSemi
##
## Functions for putting subsets, subsgps into separate files according to
## some classification.
##
## Copyright (C) 2015-2017  Attila Egri-Nagy
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
  # todo: ID_AVAILABLE is undocumented in the small groups library
  if ID_AVAILABLE(Size(G)) <> fail then
    return JoinStringsWithSeparator([StructureDescription(G:short),
                                     String(IdSmallGroup(G)[1]),
                                     String(IdSmallGroup(G)[2])],
                                    "_");
  fi;
  return JoinStringsWithSeparator(["g", String(Size(G))], "_");
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
             GrpTag(Stabilizer(SymmetryGroup(mt),bl,OnBlist))],
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
    otf := OutputTextFile(Concatenation(prefix,"_",l[2],SUBS@),true);
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
                       PaddedNumString(counter,digits),ISOM@)) then
      Error(Concatenation("Failure when processing ",filename));
    fi;
    counter := counter + 1;
  od;
end;

DetectAntiIsomClasses := function(prefix, mt)
  local indices, classes, eqf, f, c;
  indices := List(PrefixPostfixMatchedListDir(".", prefix, ISOM@),
                  x -> SplitString(x,".")[2]);
  f := x -> MulTab(
               Semigroup(
                       SetByIndicatorFunction(
                               LoadIndicatorFunctions(
                                       Concatenation(prefix,".",
                                               x,ISOM@))[1],mt)));
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
  local mt,subreps,ndigits, repsfile, isomcls, files;
  mt := MulTab(S,G);
  #generators for the record
  WriteGenerators(Concatenation(prefix,ELTS@), Elts(mt));
  Print("Calculating subsgps of ",prefix,"\n\c");
  subreps := AsList(SubSgpsByMinExtensions(mt));
  repsfile := Concatenation(prefix,SUBS@);
  SaveIndicatorFunctions(subreps, repsfile);
  Print("Classifying subsgps of ",prefix,"\n\c");
  SgpsDatabase(repsfile, mt);
  SgpsDatabaseToClassFiles(Concatenation(repsfile, DB@),prefix);
  Print("Detecting nontrivial isomorphism classes  ",prefix, "\n\c");
  files := PrefixPostfixMatchedListDir(".", Concatenation(prefix,"_S"),SUBS@);
  Perform(files, function(x) IsomClasses(x,mt);end);
  files := PrefixPostfixMatchedListDir(".", Concatenation(prefix,"_S"),ISOM@);
  isomcls := Set(files, x->SplitString(x,".")[1]);
  Perform(isomcls, function(x) DetectAntiIsomClasses(x,mt);end);
end);

################################################################################
FileSubsemigroupsInDecreasingOrder := function(mt)
  local st, next, nextsize, size;
  st := PriorityQueue(function(A,B) return SizeBlist(A) < SizeBlist(B); end,
                     x->false);
  Store(st,FullSet(mt));
  repeat
    next := NextOrderClassSubSgps(st,mt);
    if not IsEmpty(next) then
      size := SizeBlist(Representative(next));
      SaveIndicatorFunctions(next,
              JoinStringsWithSeparator([OriginalName(mt),
                      PaddedNumString(size,Size(String(Size(mt)))),
                      SUBS@SubSemi],
                      "_"));
      if IsEmpty(st) then
        nextsize := 0;
      else
        nextsize := SizeBlist(Peek(st));
      fi;
      Info(SubSemiInfoClass, 1, Size(next), " of size ", size, ", ",
           Size(Filtered(AsList(st),x->nextsize=SizeBlist(x))), " next, ",
           Size(st), " in total");
    fi;
  until IsEmpty(next);
end;
