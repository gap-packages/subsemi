

InstallOtherMethod(POW, "for a transformation collection and perm",
[IsTransformationCollection, IsPerm],
function(coll, x)
  return Set(coll, y-> y^x);
end);

HashFunctionForTransColl:=function(v,data)
  return (Sum(List(v, x-> ORB_HashFunctionForTransformations(x, data))) mod
  data) + 1;
end;

InstallMethod(ChooseHashFunction, "for trans. coll. and pos. int.",
[IsTransformationCollection, IsInt],
function(p, hashlen)
  return rec(func := HashFunctionForTransColl, data := hashlen);
end);

ConjugateTransformations:=function(G, deg)
  local l, reps, nr, hashlen, p, t, o, x;

  l := BlistList([1..deg^deg],[]);;
  reps:=[]; 
  nr:=0;
  hashlen:=Size(G);

  p := Position(l,false,0);
  while p<>fail do  
    t := TransformationNumber(p, deg);
    o := Orb(G, t, POW, rec(treehashsize:=hashlen));
    Enumerate(o, hashlen);
    for x in o do
      l[NumberTransformation(x, deg)]:=true;
    od;
    nr:=nr+1;
    reps[nr]:=o[1]; #o[1] is lex-least
    p := Position(l,false,p);
  od;
  return reps;
end;

Subsemigroups:=function(deg)
  local S, G, out, nr, reps, ht, opts, V, dfs, x;

  S:=Elements(FullTransformationSemigroup(deg));
  G:=SymmetricGroup(deg);
  out:=[];
  nr:=0;
  reps:=ConjugateTransformations(G, deg);
  ht:=HTCreate([reps[1]]);

  for x in reps do 
    V:=Semigroup(x);
    HTAdd(ht, V, true);
    Add(out, V);
  od;
 
  dfs:=function(U)
    local SS, conj, V, C, x;
    SS:=Normalizer(G, U);
    
    if not IsTrivial(SS) then 
      conj:=ConjugateTransformations(SS, deg);
    else
      conj:=S;
    fi;

    for x in conj do 
      if not x in U then 
        V:=Semigroup(U, x);
        C:=RightTransversal(G, Normalizer(G, V));
        if ForAll(C, x-> HTValue(ht, V^x)=fail) then 
          nr:=nr+1;
          HTAdd(ht, V, nr);
          out[nr]:=V;
          dfs(V);
        fi;
      fi;
    od;
    return;
  end;

  for x in reps do 
    dfs(Semigroup(x));
  od;

  return out;
end;

