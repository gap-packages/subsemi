#COPY THIS OVER AS 'config.g'
#record containing options to change the behaviour of the reduction algorithm
BindGlobal("SubSemiOptions",
        rec(LOGFREQ:=10000,
            DUMPFREQ:=10000000,
            RESCUE:=true,
            DIAGONAL:=true,
            EXHAUSTIVE:=true));
MakeReadWriteGlobal("SubSemiOptions");

# 0 nothing
# 1 log info
# 2 new cuts
DeclareInfoClass("SubSemiInfoClass");

SetInfoLevel(SubSemiInfoClass,1);

#gives info on the parameters and the multab in a short string
AlgorithmIDString := function(mt)
local str;
  str := "";
  if mt.CONJUGACY then str := Concatenation(str,"C");fi;
  if SubSemiOptions.DIAGONAL then str := Concatenation(str,"D");fi;
  if SubSemiOptions.EXHAUSTIVE then str := Concatenation(str,"E");fi;
  if SubSemiOptions.RESCUE then str := Concatenation(str,"R");fi;
  return str;
end;
