Ugens := [Transformation([2,1,3,4,5]),
          Transformation([2,2,3,4,5]),
          Transformation([2,3,4,1,5])];
U := Semigroup(Ugens);

Vgens := [Transformation([2,1,3,4,4]),
          Transformation([2,2,3,4,4]),
          Transformation([2,3,4,1,1])];
V := Semigroup(Vgens);

U4V321 := Semigroup(Concatenation(AsList(DClasses(U)[1]),
                  AsList(DClasses(V)[2]),
                  AsList(DClasses(V)[3]),
                  AsList(DClasses(V)[4])));
#gap> Size(U4V321);
#628

V43U21 := Semigroup(Concatenation(AsList(DClasses(V)[1]),
                  AsList(DClasses(V)[2]),
                  AsList(DClasses(U)[3]),
                  AsList(DClasses(U)[4])));

#gap> Size(AsList(V43U21));
#608
