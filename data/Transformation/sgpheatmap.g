SgpHeatMap := function(l,key1,key2,ndigits)
local i,j,is,s,sum;
  sum := 0;
  PrintTo("y.dat","");
  for i in [1..27] do 
    for j in [1..10] do
      is := Intersection(Filtered(l, x->fail<>PositionSublist(x,Concatenation(key1, PaddedNumString(i,2)))) ,
                    Filtered(l, x->fail<>PositionSublist(x,Concatenation(key2, PaddedNumString(j,2)))));
        #Display(is);
      s := Sum(List(is,
                   x->Size(ReadGenerators(x))));
      sum := sum + s;
      AppendTo("y.dat",i," ",j," ", s, "\n");
    od;
  od;
  Display(sum);
end;

# gnuplot> set palette defined (0 1 1 1, 0 0 0 0.5, 1 0 0 1, 2 0 0.5 1, 3 0 1 1, 4 0.5 1 0.5, 5 1 1 0, 6 1 0.5 0, 7 1 0 0, 8 0.5 0 0)
# gnuplot> set xlab "size"
# gnuplot> set ylab "#D-classes"
# gnuplot> plot "y.dat" with image title "J5"
