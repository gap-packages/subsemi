gap> START_TEST("SubSemi package: indexperiod.tst");
gap> LoadPackage("SubSemi", false);;
gap> SemigroupsStartTest();
gap> IndPer := function(t)
> local orbit, set, u, i;
>  orbit := [t];
>  set := [];
>  u := t;
>  repeat
>    AddSet(set,u);
>    u := u*t;
>    Add(orbit,u);
>  until u in set;
>  i := Position(orbit,u);
>  return [i,Size(orbit)-i];
> end;;
gap> CheckAIP := function(mt)
>  return ForAll(Indices(mt),
>                i->AbstractIndexPeriod(Rows(mt),i)=IndPer(SortedElements(mt)[i]));
> end;;
gap> CheckAIP(MulTab(FullTransformationSemigroup(4)));
true

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: indexperiod.tst", 10000);