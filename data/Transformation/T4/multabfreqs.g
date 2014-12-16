for deg in [1..5] do
  mt := MulTab(FullTransformationSemigroup(deg));
  Print(deg," ");
  Display( Unique(List(Collected(Flat(Rows(mt))) ,x->x[2])));
od;
