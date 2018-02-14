# #distinct independent generator sets of the cyclic groups
l := List([1..13],
          function(x)
            local G, mt;
            G := CyclicGroup(IsPermGroup,x);
            mt := MulTab(G,SymmGroupOfSetOfPerms(AsList(G),SymmetricGroup(IsPermGroup,x)));
            return Size(IGS(mt, Indices(mt)).igss);
          end);
