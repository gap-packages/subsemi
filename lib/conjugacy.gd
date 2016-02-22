################################################################################
##
## SubSemi
##
## Conjugation for sets of multab elements.
##
## Copyright (C) 2013-2016  Attila Egri-Nagy
##

# precomputed tables in multab for calculating the minimum of conj class
DeclareAttribute("MinimumConjugates", IsMulTab);
DeclareAttribute("MinimumConjugators", IsMulTab);

# generic function to compute minimal elements of an orbit
DeclareGlobalFunction("MinimumOfOrbit");
DeclareGlobalFunction("MinimumOfOrbitOp");

# conjugacy classes/reps for sets of multab elements (position integers)
DeclareGlobalFunction("PosIntSetConjClass");
DeclareGlobalFunction("PosIntSetConjClassRep");
DeclareGlobalFunction("PosIntSetConjClassRepOp");

# conjugcy classes/reps for boolean lists
DeclareGlobalFunction("BlistConjClassRep");
DeclareGlobalFunction("BlistConjClass");
