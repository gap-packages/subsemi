SetInfoLevel(SubSemiInfoClass, 2);
T3 := FullTransformationSemigroup(3);
T4 := FullTransformationSemigroup(4);

S3 := SymmetricGroup(IsPermGroup, 3);
S4 := SymmetricGroup(IsPermGroup, 4);

mtT4 := MulTab(T4,S4);

T3subs := ConjugacyClassRepSubsemigroups(T3,S3);

l := Set(T3subs, x->Set(MulTabEmbeddings(MulTab(Semigroup(x)), mtT4),
             y->ConjugacyClassRep(BlistList(Indices(mtT4),y),mtT4)));
