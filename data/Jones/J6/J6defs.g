# for calculating the subs of J6

J6 := JonesMonoid(6);
S6 := SymmetricGroup(IsPermGroup,6);
G := Group(Filtered(S6, g -> AsSet(J6) = Set(J6, x->x^g)));
DClassesJ6 := DClasses(J6);



