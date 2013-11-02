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
>  return ForAll(mt.rn,
>                i->AbstractIndexPeriod(mt,i)=IndPer(mt.sortedts[i]));
> end;;
gap> CheckAIP(MulTab(FullTransformationSemigroup(4)));
true

#
gap> SemigroupsStopTest();
gap> STOP_TEST( "SubSemi package: indexperiof.tst", 10000);