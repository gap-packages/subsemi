SubSemiTestInstall := function()
local test;
  for test in [
          "6packedbitstrings",
          "indicatorset",
          "indexperiod",
          "1extensions",
          "invariants",
          "isomorphism"
          ] do
    Test(Concatenation(
            PackageInfo("subsemi")[1]!.InstallationPath,
            "/tst/",test,
            ".tst"));;
  od;
end;
MakeReadOnlyGlobal("SubSemiTestInstall");
