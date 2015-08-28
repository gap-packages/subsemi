OnSetOfPermsByConj := function(P, g)
  return Set(P, x->x^g);
end;

SymmGroupOfSetOfPerms := function(S,Sn)
  return Stabilizer(Sn, Set(S), OnSetOfPermsByConj);
end;
                      
