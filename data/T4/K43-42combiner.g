mtSing4 := MulTab(SingularTransformationSemigroup(4));

itf := InputTextFile("K43-K42torsos");

K43_42subs := [];

s := ReadLine(itf);
repeat
  NormalizeWhitespace(s);
  Add(K43_42subs,AsBlist(DecodeBitString(s)));

  s := ReadLine(itf);
until s=fail;

Display(FormattedMemoryString(MemoryUsage(K43_42subs)));

itf := InputTextFile("K42subs");

K42subs := [];

s := ReadLine(itf);
repeat
  NormalizeWhitespace(s);
  Add(K42subs,AsBlist(DecodeBitString(s)));
  s := ReadLine(itf);
until s=fail;

Display(FormattedMemoryString(MemoryUsage(K42subs)));

A := K42subs{[1..200]};
B := K43_42subs{[1..10]};

Display(Size(Combiner(A,B,mtSing4)));
     
