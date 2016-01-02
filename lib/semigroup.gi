################################################################################
##
## SubSemi
##
## General functions for semigroups
##
## Copyright (C) 2013-2015  Attila Egri-Nagy
##

InstallGlobalFunction(Is3Nilpotent,
function(S)
  local zero,L;
  L := AsList(S);
  zero := L[1] * L[1] * L[1]; #assuming 3-nilpotency
  if ForAll(EnumeratorOfTuples(L, 3), tup -> Product(tup)=zero) then
    return ForAll(L, t -> (t*zero=zero) and (zero*t=zero));
  fi;
  return false;
end);

InstallGlobalFunction(Is3NilpotentInMulTab,
function(subsgp, mt)
  local zero, rows, s;
  rows := Rows(mt);
  s := subsgp[1];
  zero := rows[rows[s][s]][s]; #assuming 3-nilpotency
  if ForAll(EnumeratorOfTuples(subsgp, 3),
            tup -> rows[rows[tup[1]][tup[2]]][tup[3]]=zero) then
    return ForAll(subsgp,
                  t -> (rows[t][zero]=zero) and (rows[zero][t]=zero));
  fi;
  return false;
end);
