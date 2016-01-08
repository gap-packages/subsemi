# heatmaps from based on classified filenames

# input: classified .gens files having the same prefix
# key1, key2: which data items to plot agains, e.g "S", "D" produces heatmap
# showing the distribution of subsemigroups of all possible size and #D-class pairs
# gnuplot> set palette defined (0 1 1 1, 0 0 0 0.5, 1 0 0 1, 2 0 0.5 1, 3 0 1 1, 4 0.5 1 0.5, 5 1 1 0, 6 1 0.5 0, 7 1 0 0, 8 0.5 0 0)
# gnuplot> set xlab "size"
# gnuplot> set ylab "#D-classes"
# gnuplot> plot "J5SvsD.dat" with image title "J5"
SgpHeatMap := function(prefix, key1, key2)
local tag1,tag2,is,s,sum, filename, al, alltags, maxi,maxj, i ,j, bl;
  sum := 0; maxi := 0; maxj := 0;
  al := AssociativeList(); # truncated .gens filename -> number of lines
  bl := AssociativeList(); # [int,int] -> int (sparse matrix)
  Perform(PrefixPostfixMatchedListDir(".", prefix, ".gens"),
          function(x)
            local file;
            file := IO_File(x);
            Assign(al, x, Size(IO_ReadLines(file)));
            IO_Close(file);
          end);
  TransformKeys(al, x-> x{[Length(prefix)..Length(x)-4]}); # in general this is super crazy, but here keys will remain unique
  filename := Concatenation(prefix,key1,"vs",key2,".dat");
  PrintTo(filename,""); #erasing
  alltags := Set(Concatenation(List(Keys(al), x->Set(SplitString(x,"_.")))));
  for tag1 in Filtered(alltags, x->key1=Maximum(SplitString(x,"0123456789"))) do
    for tag2 in Filtered(alltags, x->key2=Maximum(SplitString(x,"0123456789"))) do
      is := Intersection(Filtered(Keys(al), x->fail<>PositionSublist(x,Concatenation("_",tag1))) ,
                    Filtered(Keys(al), x->fail<>PositionSublist(x,Concatenation("_",tag2))));
      if not IsEmpty(is) then Display(is); fi;
      s := Sum(List(is,x->al[x]));
      sum := sum + s;
      i := Int(Filtered(tag1, IsDigitChar));
      if i > maxi then maxi := i; fi;
      j := Int(Filtered(tag2, IsDigitChar));
      if j > maxj then maxj := j; fi;
      Assign(bl, [i,j], s);

    od;
  od;
  for i in [1..maxi] do
    for j in [1..maxj] do
      if ContainsKey(bl,[i,j]) then
        AppendTo(filename,i," ",j," ", bl[[i,j]], "\n");
      else
        AppendTo(filename,i," ",j," 0\n");
      fi;
    od;
  od;
  Display(sum);
end;
