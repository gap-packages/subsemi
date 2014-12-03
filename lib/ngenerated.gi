# collects all the distinct semigroups generated by n-tuples
# returns an n-generating set for each, not necessarily minimal
NSubsets := function(mt,n)
  local ntuple, db, counter;
  counter := 0;
  db := LightBlistContainer();
  for ntuple in IteratorOfCombinations(Indices(mt),n) do
    AddSet(db,ConjugacyClassRep(BlistList(Indices(mt),ntuple),mt));
    if InfoLevel(SubSemiInfoClass)>0
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Print("#", FormattedPercentageString(counter, Binomial(Size(Indices(mt)),n)),
            " ",Size(db),"\n");
    fi;
    counter := counter + 1;
  od;
  Info(SubSemiInfoClass,1,Size(db), " generator set reps of size ", n);
  return AsList(db);
end;

# collects all the distinct semigroups generated by n-tuples
# returns an n-generating set for each, not necessarily minimal
NGeneratedSubSgps := function(mt,n)
  return Set(NSubsets(mt,n),
             x->ConjugacyClassRep(SgpInMulTab(x,mt),mt));
end;


#put the first n layers together, and find the layers
InstallGlobalFunction(SubSgpsByMinimalGenSets,
function(mt)
  local layers,i;
  layers := [AsSortedList(NGeneratedSubSgps(mt,1))];
  i := 1;
  Info(SubSemiInfoClass,1,String(i), " generators ", String(Size(layers[i])), " sgps");
  while Size(layers[i]) > 0 do
    i := i+1;
    Add(layers, Difference(AsSortedList(NGeneratedSubSgps(mt,i)), Union(layers)));
    Info(SubSemiInfoClass,1,String(i), " generators ", String(Size(layers[i])), " sgps");
  od;
  return layers;
end);
