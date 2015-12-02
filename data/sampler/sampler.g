TimeSeed := function()
  local time;
  time := IO_gettimeofday();
  return time.tv_sec + time.tv_usec;
end;

RandomBlist := function(n)
local bl, f;
  bl := ListWithIdenticalEntries(n,false);
  f := function(x)
    if Random(GlobalMersenneTwister,[false, true]) then bl[x]:=true;fi;
  end;
  Perform([1..n],f);
  return bl;
end;

IsSubSgp := function(bl, mt)
  return SizeBlist(bl) = SizeBlist(SgpInMulTab(bl,mt));
end;

SampleSubSgps := function(mt,N)
  local i, subset, seed, outfilename;
  seed := TimeSeed();
  Reset(GlobalMersenneTwister, seed);
  outfilename := Concatenation(OriginalName(mt),
                         "_",
                         ReplacedString(FormattedBigNumberString(N)," ","_"),
                         "_",
                         String(seed));
  PrintTo(outfilename,"");
  for i in [1..N] do
    subset := RandomBlist(Size(mt));
    if SizeBlist(subset) = SizeBlist(SgpInMulTab(subset,mt)) then
      AppendTo(outfilename, EncodeBitString(AsBitString(subset)), "\n");
    fi;
  od;
end;
