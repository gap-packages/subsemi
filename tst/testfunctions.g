SubSemiTestInstall := function()
local test,infolevel;
  infolevel := InfoLevel(SubSemiInfoClass);
  SetInfoLevel(SubSemiInfoClass, 0);
  for test in [
          "T3"
          ] do
    Test(Concatenation(
            PackageInfo("subsemi")[1]!.InstallationPath,
            "/tst/",test,
            ".tst"));;
  od;
  SetInfoLevel(SubSemiInfoClass, infolevel);
end;
MakeReadOnlyGlobal("SubSemiTestInstall");

SubSemiTestAll := function()
local test,infolevel;
  infolevel := InfoLevel(SubSemiInfoClass);
  SetInfoLevel(SubSemiInfoClass, 0);
  for test in [
          "util",
          "ui",
          "sgptag",
          "bruteforce",
          "indexperiod",
          "closures",
          "gensets",
          "invariants",
          "isomorphism",
          "embedding",
          "conjugacy",
          "minextensions",
          "classifier",
          "is",
          "T3",
          "I3",
          "J4"
      ] do
    Test(Concatenation(
            PackageInfo("subsemi")[1]!.InstallationPath,
            "/tst/",test,
            ".tst"));;
  od;
  SetInfoLevel(SubSemiInfoClass, infolevel);
end;
MakeReadOnlyGlobal("SubSemiTestAll");
