for i in [1..7] do
  G := SymmetricGroup(IsPermGroup, i);
  mt := MulTab(G,G);
  Display(Size(IGS(mt, List(Filtered(G, x->2=NrMovedPoints(x)), x->Position(SortedElements(mt),x)))));
od;
