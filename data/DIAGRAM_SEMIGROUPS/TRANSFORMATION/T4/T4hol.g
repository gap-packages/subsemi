T4Holonomy := function(infile, outfile)
  local outf, f, nrdigits, mt;
  mt := MulTab(T4);
  nrdigits := Size(String(Size(mt)));
  outf := OutputTextFile(outfile, false);
  f := function(s)
    local S, bl;
    bl := AsBlist(DecodeBitString(s));
    S := Semigroup(SetByIndicatorFunction(bl,mt));
    WriteLine(outf, HolonomyInfoString(Skeleton(S)));
    return true;
  end;
  TextFileProcessor(infile, f);
  CloseStream(outf);
end;
