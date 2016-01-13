mt := MulTab(FullTransformationSemigroup(4),SymmetricGroup(IsPermGroup,4));

st := SortedSet(function(A,B) return SizeBlist(A) < SizeBlist(B); end);

Store(st,FullSet(mt));

repeat
  next := NextOrderClassSubSgps(st,mt);
  if not IsEmpty(next) then
    size := SizeBlist(Representative(next));
    nextsize := SizeBlist(Peek(st));
    SaveIndicatorFunctions(next,
            JoinStringsWithSeparator(["T4",
                    PaddedNumString(size,3),
                    SUBS@SubSemi],
                    "_"));
    Info(SubSemiInfoClass, 1, Size(next), " of size ", size, ", ", 
         Size(Filtered(AsList(st),x->nextsize=SizeBlist(x))), " next ",
              Size(st), " in total");
  fi;
until IsEmpty(next);
