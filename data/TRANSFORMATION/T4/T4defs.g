LoadPackage("subsemi");

SEMIGROUPS_DefaultOptionsRec.hashlen:=rec(L:=257,M:=257, S:=257);

# VARIABLES for T4 and its subs
S4 := SymmetricGroup(IsPermGroup,4);
S4_T4 := Semigroup([Transformation([2,1,3,4]),Transformation([2,3,4,1])]);
T4 := FullTransformationSemigroup(4);
K43 := SingularTransformationSemigroup(4);
#GeneratorsOfSemigroup(K43);
SetName(K43,"K43");
K42 := SemigroupIdeal(K43,[Transformation([1,2,2,2])]);
#GeneratorsOfSemigroup(K42);
SetName(K42,"K42");

# FUNCTIONS for the calculations
# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3} and T4
K42SubReps := function()
  local output, mtT4, mtK43, mtK42, reps, r;
  mtT4 := MulTab(T4,S4);
  mtK43 := MulTab(K43,S4);
  mtK42 := MulTab(K42,S4);
  reps := AsList(SubSgpsByMinExtensions(mtK42));
  SaveIndicatorFunctions(reps, "K42.reps");
  RecodeIndicatorFunctionFile("K42.reps","K42_K43.reps", mtK42, mtK43);
  RecodeIndicatorFunctionFile("K42.reps","K42_T4.reps", mtK42, mtT4);
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
  I := SemigroupIdeal(T4, [Transformation([1,2,3,3])]); #K43
  uts := UpperTorsos(I,S4);
  #remove emptyset
  Remove(uts, Position(uts, EmptySet(mtT4)));
  #remove trivial group
  id := BlistList(Indices(mtT4), [Position(Elts(mtT4),IdentityTransformation)]);
  Remove(uts, Position(uts, id));
  result := SubSgpsByUpperTorsos(I,S4,uts);
  Add(result,id);
  SaveIndicatorFunctions(result,"P_T4.reps");
end;

P_T4_2 := function()
  SaveIndicatorFunctions(SubSgpsByUpperTorsos(K43,S4,UpperTorsos(K43,S4)),
          Concatenation("P_T4",SUBS@SubSemi));
end;

P_T4_Sorter := function()
  local sgps, reps, al, mtT4;
  reps := LoadIndicatorFunctions("P_T4.reps");
  Display("# Loading P_T4.reps DONE");
  mtT4 := MulTab(T4,S4);
  sgps := List(reps, x-> Semigroup(SetByIndicatorFunction(x,mtT4)));
  Display("# Converting to semigroups DONE");
  al := AssociativeList();
  Perform(sgps, function(sgp)
    Collect(al,
            StructureDescription(Group(
                    List( Filtered(AsList(sgp),
                            y -> PermList(ImageListOfTransformation(y,4)) <>fail),
                          z->PermList(ImageListOfTransformation(z,4)) ) ) ) ,sgp); end );
  return al;
end;
