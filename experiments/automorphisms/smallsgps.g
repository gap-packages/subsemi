# recreating results of the paper 'Computing automorphisms of semigroups'
for n in [1..7] do
  Display(Collected(List(EnumeratorOfSmallSemigroups(n),
          x->StructureDescription(AutGrpOfMulTab(MulTab(x))))));
od;
