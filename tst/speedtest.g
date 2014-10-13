SubSemiOptions.LOGFREQ:=1000000;;
SubSgpsByMinExtensions(MulTab(BrauerMonoid(4),S4));
NGeneratedSubSgpGenSets(MulTab(T4,S4),2);;Print(FormattedTimeString(time),"\n");

# v0.31 2GB
# Pentium G3420 Haswell @ 3.2 GHz  116.63,  7.34
# AMD FX-8320 @ 3.5 GHz             90.87,  9.22 
# i7-2635QM Sandy @ 2 GHz           84.97, 10.43
