SgpTag := function (sgp)
  return Concatenation("S_",String(Size(sgp)),"_",
                 "LRD_",
                 String(NrLClasses( sgp)),"_",
                 String(NrRClasses( sgp)),"_",
                 String(NrDClasses(sgp)));
end;

#isf - only one dot is allowed in the filename
FilingSemigroupIndicatorSets := function(isf,mt)
  local sets,filename, extension, files, tag,s,sgp;
  filename :=  isf{[1..Position(isf,'.')-1]};
  extension := isf{[Position(isf,'.')..Size(isf)]};
  sets := LoadIndicatorSets(isf);
  Remove(sets, Position(sets,EmptySet(mt)));
  files := AssociativeList(); # tags to open files
  for s in sets do
    sgp := Semigroup(ElementsByIndicatorSet(s,mt));
    tag := SgpTag(sgp);
    if not ContainsKey(files, tag) then
      Assign(files, tag, OutputTextFile( Concatenation(filename,"_",tag,extension), false));
    fi;
    AppendTo(files[tag], EncodeBitString(AsBitString(s)),"\n");
  od;
  Perform(Keys(files),function(key)CloseStream(files[key]);end);
end;
