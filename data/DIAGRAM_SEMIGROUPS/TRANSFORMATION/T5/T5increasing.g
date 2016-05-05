LoadPackage("subsemi");
SubSemiOptions.LOGFREQ=1;
SubSemiOptions.CHECKPOINTFREQ=100;
st := SortedSet(function(A,B) return SizeBlist(A) > SizeBlist(B); end);
mt := MulTab(FullTransformationSemigroup(5),SymmetricGroup(IsPermGroup,5));
SubSgpsByMinExtensionsParametrized( mt, EmptySet( mt ),
        DistinctGenerators( FullSet( mt ), mt ), st,
        BlistStorage(11 ), [  ] );
