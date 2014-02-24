#a semigroup of order 42 that can be cut fully in ~3 minutes
# it appears to have 33275 subsemigroups
S42 := Semigroup([ Transformation( [ 2, 1, 2, 1 ] ),
               Transformation( [ 3, 1, 4, 3 ] ),
               Transformation( [ 3, 1, 4, 4 ] ) ]);
SetName(S42,"Sgp42");
