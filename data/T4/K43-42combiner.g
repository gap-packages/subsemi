Loader := function(filename)
  local result,itf,s;
  itf := InputTextFile(filename);
  result := [];
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    Add(result,AsBlist(DecodeBitString(s)));    
    s := ReadLine(itf);
  until s=fail;
  return result;
end;

Writer := function(indsets, filename)
  local output,r;
  output := OutputTextFile(filename, false);
  for r in indsets do
    AppendTo(output, EncodeBitString(AsBitString(r)),"\n");
  od;
  CloseStream(output);
end;

mtSing4 := MulTab(SingularTransformationSemigroup(4),S4);

K43_42subs := Loader("K43-K42torsos");
Display(FormattedMemoryString(MemoryUsage(K43_42subs)));

#K42subs := Loader("K42ccs");
#Display(FormattedMemoryString(MemoryUsage(K42subs)));

# A := K42subs{[22]};
# B := K43_42subs{[9999]};

#Writer(AsList(ConjugacyClassCombiner(A,A,mtSing4)), "xyz");

Writer(Unique(List(K43_42subs,x->SgpInMulTab(x,mtSing4))),"K43-K42torsosG");
