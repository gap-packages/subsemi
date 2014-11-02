################################################################################
# VISUALIZATION ################################################################
################################################################################

#colors for printing multabs
RED := "\033\[01;31m";
BLACK := "\033[00;30m";

ShowMulTab := function(mt, cut)
local row, col, v,isfirst;
  for row in [1..mt.n] do
    isfirst := true;
    Print("[");
    for col in [1..mt.n] do
      if isfirst then
        isfirst := false;
      else
        Print(",");
      fi;
      if (row in cut) or (col in cut) then
        Print(" ");
      else
        if mt.mt[row][col] in cut then
          Print(RED,StringPrint(mt.mt[row][col]),BLACK);
        else
          Print(StringPrint(mt.mt[row][col]));
        fi;
      fi;
    od;
    Print("]\n");
  od;
  if not IsBlist(cut) then # TODO is this needed?
    cut := BlistList([1..mt.n],cut);
  fi;
  Display(Completion(mt.mt,mt.n, cut));
end;

Pattern := function(mt, cut)
local row, col, v,isfirst;
  for row in [1..mt.n] do

    #Print("|");
    for col in [1..mt.n] do
      if (row in cut) and (col in cut) then
        Print("+");
      elif (row in cut) then
        Print("-");
      elif (col in cut) then
        Print("|");
      elif mt.mt[row][col] in cut then
        Print("x");
      else
        Print(" ");
      fi;
    od;
    Print("\n");
  od;
  #Display(Completion(mt, cut));
end;

LatexMulTab := function(mt, cut)
  local row, col, v,isfirst, str;
  str := "\\begin{tabular}{@{}c@{}c@{}c@{}c@{}c@{}c@{}}\n";
  for row in [1..mt.n] do
    isfirst := true;
    for col in [1..mt.n] do
      if isfirst then
        isfirst := false;
      else
        Append(str,"\&");
      fi;
      if (row in cut) or (col in cut) then
        Append(str,"\\color{lgr}");
        Append(str,StringPrint(mt.mt[row][col]));
      elif (mt.mt[row][col] in cut) then
        Append(str,"\\color{white}\\colorbox{black}{");
        Append(str,StringPrint(mt.mt[row][col]));
        Append(str,"}");
      else
        Append(str,StringPrint(mt.mt[row][col]));
      fi;

    od;
    Append(str,"\\\\\n");
  od;
  Append(str,"\\end{tabular}");
  return str;
end;
