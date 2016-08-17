LoadPackage("subsemi");
SubSemiOptions.LOGFREQ:=1000000;
SubSemiOptions.CHECKPOINTFREQ:=10000;
SetInfoLevel(SubSemiInfoClass,0);


mt := MulTab(FullTransformationSemigroup(3),SymmetricGroup(IsPermGroup,3));

label := "T3_";

cleaner := function(subsfile,mt)
  local set;
  set := [];
  TextFileProcessor(subsfile,
                   function(x) 
                     AddSet(set, BlistConjClassRep(AsBlist(DecodeBitString(x)),mt)); 
                     return true; 
                   end);
  SaveIndicatorFunctions(set,subsfile);
end;

inc := function(mt, label, range)
  local finalfile, tmpfile, comparef, namef, storef,queuef,i,st,prevfile,subs, j;
  
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
  
  for i in range do
    Print(i);
    st := queuef(i);
    prevfile:= tmpfile(i);
    if IsExistingFile(prevfile) then
      Print(" reading from ",prevfile);
      subs := LoadIndicatorFunctions(prevfile);
      Print(" ",Size(subs), " subs,");
      subs := Set(List(subs, x->BlistConjClassRep(x,mt)));
      Print(" writing to", finalfile(i));
      SaveIndicatorFunctions(subs, finalfile(i));    
      Print(" ", Size(subs), " elements to process");
      Perform(subs, function(x)
               Print("#\c");
               return SubSgpsByMinExtensionsParametrized( mt, x,
                                                          DistinctGenerators( FullSet( mt ), mt ), st,
                                                          BlistStorage(2), [  ] );
             end);
    fi;
    Print("cleaning...\c");
    for j in [i+2..Size(mt)] do
      prevfile := tmpfile(j);
      if IsExistingFile(prevfile) then
        cleaner(prevfile, mt);
      fi;
    od;
    Print("\n");
  od;
end;

inc(mt, label, [0..Size(mt)]);


