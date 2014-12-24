matrices := Tuples(Tuples([0*Z(2),Z(2)^0],2),2);

S := Semigroup(matrices);

G := Filtered(S, x->fail <> Inverse(x));

Filtered(G, x->Set(S) = Set(S, y-> Inverse(x)*y*x));
