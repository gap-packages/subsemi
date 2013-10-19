#record containing options to change the behaviour of the reduction algorithm
BindGlobal("MTROptions",
        rec(LOGFREQ:=10000,
            DUMPFREQ:=10000000,
            RESCUE:=true,
            DIAGONAL:=true,
            EXHAUSTIVE:=true));
MakeReadWriteGlobal("MTROptions");

# 0 nothing
# 1 log info
# 2 new cuts
DeclareInfoClass("MulTabInfoClass");

SetInfoLevel(MulTabInfoClass,2);

#gives info on the parameters and the multab in a short string
AlgorithmIDString := function(mt)
local str;
  str := "";
  if mt.CONJUGACY then str := Concatenation(str,"C");fi;
  if MTROptions.DIAGONAL then str := Concatenation(str,"D");fi;
  if MTROptions.EXHAUSTIVE then str := Concatenation(str,"E");fi;
  if MTROptions.RESCUE then str := Concatenation(str,"R");fi;
  return str;
end;
