LoadPackage("subsemi");

# We need to limit hashtable sizes since we only deal with semigroups smaller
# than or equal to size 256, but we have lots of them.
SEMIGROUPS_DefaultOptionsRec.hashlen:=rec(L:=263,M:=263, S:=263);

# VARIABLES for T4 and its subs
S4 := SymmetricGroup(IsPermGroup,4);
T4 := FullTransformationSemigroup(4);
K43 := SemigroupIdeal(T4, [Transformation([1,2,3,3])]);
SetName(K43,"K43");
K42 := SemigroupIdeal(K43,[Transformation([1,2,2,2])]);
SetName(K42,"K42");
K41 := SemigroupIdeal(K42,[Transformation([1,1,1,1])]);
SetName(K41,"K41");
mtT4 := MulTab(T4,S4);
mtK43 := MulTab(K43,S4);
mtK42 := MulTab(K42,S4);

################################################################################
# FUNCTIONS for the calculations in enumeration.sh #############################

#1
# subsemigroups of T4 that contain non-trivial permutations
P_T4 := function()
  local subs;
  #we need to filter out the identity as well, simple size check is enough
  subs := SubSgpsByUpperTorsos(K43,
                               S4,
                               Filtered(UpperTorsos(K43,S4),x->SizeBlist(x)>1));
  Add(subs,
      BlistList(Indices(mtT4), [Position(Elts(mtT4),IdentityTransformation)]));
  SaveIndicatorFunctions(subs, Concatenation("P_T4",SUBS@SubSemi));
end;

#2
K42Subs := function()
  local subs;
  subs := SubSgpsByIdeals(K41,S4);
  SaveIndicatorFunctions(List(subs, x-> RecodeIndicatorFunction(x,mtK42,mtT4)),
          Concatenation("K42",SUBS@SubSemi));
end;

#3
#takes couple of days, requires at least 4GB RAM
#there are a few more reps than uppertorsos
K43modK42subs := function()
  SaveIndicatorFunctions(UpperTorsos(K42,S4),
          Concatenation("K43modK42",SUBS@SubSemi) );
end;

#4
K43SubsFromUpperTorsos := function(filename)
  local subs;
  subs := SubSgpsByUpperTorsos(K42,S4, LoadIndicatorFunctions(filename));
  SaveIndicatorFunctions(List(subs, x-> RecodeIndicatorFunction(x,mtK43,mtT4)),
          Concatenation(filename,SUBS@SubSemi));
end;

#5
# adding the identity
K43sharp := function()
local K43subs, id;
  K43subs := LoadIndicatorFunctions(Concatenation("K43", SUBS@SubSemi));
  id := Position(Elts(mtT4), IdentityTransformation);
  Perform(K43subs, function(x) x[id]:=true;end);
  SaveIndicatorFunctions(K43subs,Concatenation("K43sharp",SUBS@SubSemi));
end;

################################################################################
# alternative methods ##########################################################
#very slow control recalc of all subs of the singular part
K43SubsOneShot := function()
  SaveIndicatorFunctions(SubSgpsByMinExtensions(mtK43),
                         Concatenation("K43",SUBS@SubSemi));
  RecodeIndicatorFunctionFile(Concatenation("K43",SUBS@SubSemi),
                              Concatenation("K43_T4",SUBS@SubSemi),
                              mtK43,
                              mtT4);
end;

# calculating all subsemigroups of the K_{4,2} ideal within K_{4,3}
# and recoding to T4
K42SubsOneShot := function()
  local subs;
  subs := SubSgpsByMinExtensions(mtK42);
  SaveIndicatorFunctions(List(subs, x-> RecodeIndicatorFunction(x,mtK42,mtT4)),
          Concatenation("K42oneshot",SUBS@SubSemi));
end;
