#COPY THIS OVER AS 'config.g'
BindGlobal("SubSemiOptions",
        rec(LOGFREQ:=10000,
            CHECKPOINTFREQ:=10000000));
MakeReadWriteGlobal("SubSemiOptions");

# 0 nothing
# 1 log info
# 2 data dump
DeclareInfoClass("SubSemiInfoClass");

SetInfoLevel(SubSemiInfoClass,1);
