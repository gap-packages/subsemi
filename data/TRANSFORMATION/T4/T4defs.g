LoadPackage("subsemi");

SEMIGROUPS_DefaultOptionsRec.hashlen:=rec(L:=257,M:=257, S:=257);

# VARIABLES for T4 and its subs
S4 := SymmetricGroup(IsPermGroup,4);
T4 := FullTransformationSemigroup(4);
K43 := SemigroupIdeal(T4, [Transformation([1,2,3,3])]);
SetName(K43,"K43");
K42 := SemigroupIdeal(K43,[Transformation([1,2,2,2])]);
SetName(K42,"K42");
K41 := SemigroupIdeal(K42,[Transformation([2,2,2,2])]);
SetName(K41,"K41");
mtT4 := MulTab(T4,S4);
mtK43 := MulTab(K43,S4);
mtK42 := MulTab(K42,S4);

# FUNCTIONS for the calculations
# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3} and T4
K42Subs := function()
  local subs;
  subs := SubSgpsByMinExtensions(mtK42);
  SaveIndicatorFunctions(List(subs, x-> RecodeIndicatorFunction(x,mtK42,mtT4)),
          Concatenation("K42",SUBS@SubSemi));
end;

K42Subs2 := function()
  local subs;
  subs := SubSgpsByIdeals(K41,S4);
  SaveIndicatorFunctions(List(subs, x-> RecodeIndicatorFunction(x,mtK42,mtT4)),
          Concatenation("K42i",SUBS@SubSemi));
end;


#takes couple of days, requires at least 4GB RAM
#there are a few more reps than uppertorsos
  K43modK42subs := function() ImodJSubs(K43, K42, Name(K43),Name(K42),S4); end;

K43SubsFromUpperTorsos := function(filename)
  ISubsFromJUpperTorsos(K43,K42,filename,S4);
end;

# does the T4 conversion as well
K43sharp := function()
local mtK43, mtT4, K43reps, K43_T4reps, id;
  mtK43 := MulTab(K43);
  mtT4 := MulTab(T4);
  K43reps := LoadIndicatorFunctions("K43.reps");
  K43_T4reps := List(K43reps, x->RecodeIndicatorFunction(x,mtK43,mtT4));
  SaveIndicatorFunctions(K43_T4reps,"K43_T4.reps");
  id := Position(Elts(mtT4), IdentityTransformation);
  Perform(K43_T4reps, function(x) x[id]:=true;end);
  SaveIndicatorFunctions(K43_T4reps,"K43sharp_T4.reps");
end;

#it would be nice to calculate this as a control recalc
K43SubsOneShot := function()
  local mtT4, mtK43;
  mtT4 := MulTab(T4,S4);
  mtK43 := MulTab(K43,S4);
  SaveIndicatorFunctions(SubSgpsByMinExtensions(mtK43),
                         Concatenation("K43",SUBS@SubSemi));
  RecodeIndicatorFunctionFile(Concatenation("K43",SUBS@SubSemi),
                              Concatenation("K43_T4",SUBS@SubSemi),
                              mtK43,
                              mtT4);
end;

P_T4 := function()
local mtT4, I, uts, id, result;
  mtT4 := MulTab(T4,S4);
  uts := UpperTorsos(K43,S4);
  #remove trivial group
  id := BlistList(Indices(mtT4), [Position(Elts(mtT4),IdentityTransformation)]);
  Remove(uts, Position(uts, id));
  result := SubSgpsByUpperTorsos(I,S4,uts);
  Add(result,id);
  SaveIndicatorFunctions(result,"P_T4.reps");
end;

P_T4_2 := function()
  local subs;
  subs := SubSgpsByUpperTorsos(K43,
                               S4,
                               Filtered(UpperTorsos(K43,S4), x -> Size(x)>1));
  SaveIndicatorFunctions(subs, Concatenation("P_T4",SUBS@SubSemi));
end;
