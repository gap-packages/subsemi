SubsintoT := function(subs, mtT)
  return List(subs,
              S -> [Size(S),
                    Size(MulTabEmbeddingsUpToConjugation(MulTab(S), mtT))]);  
end;

EmbeddingsCalculator := function(infile, outfile, mtS, mtT)
  local outf, f;
  outf := OutputTextFile(outfile, false);
  f := function(s)
    local S, bl;
    bl := AsBlist(DecodeBitString(s));
    S := Semigroup(SetByIndicatorFunction(bl,mtS));
    WriteLine(outf, JoinStringsWithSeparator(
                      [String(Size(S)),
                       String(Size(MulTabEmbeddingsUpToConjugation(MulTab(S), mtT)))],
                      " "));
    return true;
  end;
  TextFileProcessor(infile, f);
  CloseStream(outf);
end;

