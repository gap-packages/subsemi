################################################################################
##
## SubSemi
##
## Util functions
##
## Copyright (C) 2013  Attila Egri-Nagy
##

#time related #should go to SGPDEC!
InstallGlobalFunction(TimeInSeconds,
        function() return IO_gettimeofday().tv_sec; end);

#this does not work TODO
InstallGlobalFunction(RandomizeBySystemClock,
function()
  Reset(GlobalMersenneTwister, TimeInSeconds);
  Print("#Random seed:", State(GlobalMersenneTwister), "\n");
end);

InvertedCutAsList := function(mt, cut)
  return mt.sortedts{Difference(mt.rn,
                 ListBlist(mt.rn,cut))
                 };
end;

ConvertToSgps := function(mt,cuts)
  local invcuts;
  invcuts := List(cuts, x -> InvertedCutAsList(mt,x) );
  Remove(invcuts,Position(invcuts,[]));#removing the empty set
  return  List(invcuts, ic -> Semigroup(ic));
end;

