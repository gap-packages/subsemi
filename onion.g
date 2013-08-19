ConvertCutDataUp := function(mt1, mt2, dat1)
  local f,diff;

  if not IsSubset(mt2.sortedts, mt1.sortedts) then
    Print("#W not a superset, cannot convert");
    return fail;
  fi;
  diff := BlistList(mt2.rn,List(Difference(mt2.sortedts, mt1.sortedts),x->Position(mt2.sortedts,x)));
  f := cut -> BlistList(mt2.rn,
               List(ListBlist(mt1.rn,cut),
                    x->Position(mt2.sortedts, mt1.sortedts[x])));
  return List(List(dat1,f), b-> UnionBlist(b,diff));
end;

ConvertCutDataDown := function(mt1, mt2, dat2)
local f;
  if not IsSubset(mt2.sortedts, mt1.sortedts) then
    Print("#W not a superset, cannot convert");
    return fail;
  fi;
  f := cut -> BlistList(mt1.rn,
               List(ListBlist(mt2.rn,cut),
                    x->Position(mt1.sortedts, mt2.sortedts[x])));
  return List(dat2,f);
end;


OnionReduceSgp := function(arg)
  local gc,sgps,mts,i,res,log,sum,n,tag,writefiles,subs;
  Print("ONION PEELING#####################################################\n");
  gc := arg[1];
  writefiles := false;
  if IsBound(arg[2]) then tag:=arg[2]; writefiles:= true;fi;
  #gc := RandomMinimalGeneratorSetChain(S);
  n := Size(gc);
  sgps := List([1..n], x -> Semigroup(gc{[1..x]}));
  Print("#LAYERS", n, " ", List(sgps,Size),"\n");
  mts := List(sgps, MulTab);
  Print(mts[1].sortedts,"\n");
  res := ReduceMulTab(mts[1]);
  Add(res[1], BlistList(mts[1].rn,[]));
  Print("local result: ", res[1], "\n");
  sum := ConvertCutDataUp(mts[1],mts[n],res[1]);
  for i in [1..n-1] do
    Print(mts[i+1].sortedts,"\n");
    Print("#JUMPING from ", Size(sgps[i]), " to ", Size(sgps[i+1]),"\n");
    res := ReduceMulTab(mts[i+1],[],sgps[i]);
    Add(res[1], BlistList(mts[i+1].rn,[]));
    sum := Concatenation(sum,ConvertCutDataUp(mts[i+1],mts[n],res[1]));
    Print("#################################SO FAR WE HAVE  ", Size(sum), "\n");
    subs := ConvertToSgps(mts[n],sum);
    if writefiles then
      WriteSemigroups(
              Concatenation(tag,"_S",String(Size(sgps[i+1])),".subs.gz")
              ,subs);
    fi;
  od;
  Display(sgps[n]);
  return sum;DuplicateFreeList(sum);
end;
