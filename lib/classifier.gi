################################################################################
##
## SubSemi
##
## General functions for finding classes by some equivalence relation.
##
## Copyright (C) 2015  Attila Egri-Nagy
##

#TODO OPTIMIZE as we put more and more load on this

# elts - the elements to be classified
# f - function that constructs derived data for deciding equivalence
# eq - function that decides the equivalence based on data by f
InstallGlobalFunction(Classify,
function(elts, f, eq)
  local e, #an elemenet from elts 
        d, #data constructed from e, f(e)
        data, #precalculated data for each class representative
        classes, #the resulting classes
        pos; #the position of the matching class
  data := [];
  classes := [];
  for e in elts do
    d := f(e);
    pos := First([1..Size(classes)], x -> eq(data[x],d));
    if pos = fail then
      Add(classes, [e]);
      Add(data, d);
    else
      Add(classes[pos],e);
    fi;
  od;
  return classes;
end);

#Print(Classify([1..10], IsEvenInt, \=));
