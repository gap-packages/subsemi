LoadPackage("subsemi");
SubSemiOptions.LOGFREQ:=1;
SubSemiOptions.CHECKPOINTFREQ:=1000;
st := PriorityQueue(function(A,B) return SizeBlist(A) > SizeBlist(B); end,
                   A->SizeBlist(A)>5);
mt := MulTab(FullTransformationSemigroup(5),SymmetricGroup(IsPermGroup,5));
result := SubSgpsByMinExtensionsParametrized( mt, EmptySet( mt ),
        DistinctGenerators( FullSet( mt ), mt ), st,
        BlistStorage(11 ), [  ] );
