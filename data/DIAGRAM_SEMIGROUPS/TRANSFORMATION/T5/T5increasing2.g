LoadPackage("subsemi");
SubSemiOptions.LOGFREQ:=1000000;
SubSemiOptions.CHECKPOINTFREQ:=10000;
SetInfoLevel(SubSemiInfoClass,0);


mt := MulTab(FullTransformationSemigroup(5),SymmetricGroup(IsPermGroup,5));

label := "T5_";

finalfile := x->Concatenation(label,String(x),SUBS@SubSemi);
tmpfile := x -> Concatenation("tmp",label, String(x));
comparef := function(A,B) return SizeBlist(A) > SizeBlist(B); end;
namef := x->tmpfile(SizeBlist(x));
storef := x->EncodeBitString(AsBitString(x));
queuef := n -> PriorityQueueLossless(comparef,
                                     A->SizeBlist(A)>n,
                                     namef,
                                     storef);

SaveIndicatorFunctions([EmptySet(mt)], tmpfile(0));
st := queuef(0);
SaveIndicatorFunctions(SubSgpsByMinExtensionsParametrized( mt, EmptySet(mt),
        DistinctGenerators( FullSet( mt ), mt ), st,
        BlistStorage(2), [  ] ), finalfile(0));

for i in [1..Size(mt)] do
  Print(i);
  st := queuef(i);
  prevfile:= tmpfile(i);
  if IsExistingFile(prevfile) then
    Print(" reading from",prevfile);
    set := Set(List(LoadIndicatorFunctions(prevfile), x->BlistConjClassRep(x,mt)));
    Print(" writing to", finalfile(i));
    SaveIndicatorFunctions(set, finalfile(i));    
    Print(" ", Size(set), " elements to process");
    Perform(set, function(x)
      Print("#\c");
      return SubSgpsByMinExtensionsParametrized( mt, x,
                     DistinctGenerators( FullSet( mt ), mt ), st,
                     BlistStorage(2), [  ] );
    end);
  fi;
  Print("\n");
od;



