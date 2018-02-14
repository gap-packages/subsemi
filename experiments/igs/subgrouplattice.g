
# a function to get part of the subgroup lattice spanned by a generating set
subsgpsignature := igs -> SortedList(Set(List(Filtered(Combinations(igs), x->not(IsEmpty(x))), Group), StructureDescription));
