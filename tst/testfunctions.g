SubSemiTestInstall := function()
local test,infolevel;
  infolevel := InfoLevel(SubSemiInfoClass);
  SetInfoLevel(SubSemiInfoClass, 0);
  for test in [
          "6packedbitstrings",
          "indicatorset",
          "indexperiod",
          "closures",
          "gensets",
          "invariants",
          "isomorphism"
          ] do
    Test(Concatenation(
            PackageInfo("subsemi")[1]!.InstallationPath,
            "/tst/",test,
            ".tst"));;
  od;
  SetInfoLevel(SubSemiInfoClass, infolevel);
end;
MakeReadOnlyGlobal("SubSemiTestInstall");
