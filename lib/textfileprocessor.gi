################################################################################
##
## SubSemi
##
## Processing textfiles line by line.
##
## Copyright (C) 2015  Attila Egri-Nagy
##

#generic function for processing a textfile line by line
#infile - the name of the input file
#processor - a function that takes a line of infile and returns true if it was
#properly processed
InstallGlobalFunction(TextFileProcessor,
function(infile, processor)
  local s,counter,itf;
  counter := 0;
  itf := InputTextFile(infile);
  s := ReadLine(itf);
  repeat
    NormalizeWhitespace(s);
    counter := counter + 1;
    if not processor(s) then
      Error(s);
    fi;
    if InfoLevel(SubSemiInfoClass)>0 ###########################################
       and (counter mod SubSemiOptions.LOGFREQ)=0 then
      Info(SubSemiInfoClass,1,FormattedBigNumberString(counter)," of ",infile);
    fi; ########################################################################
    s := ReadLine(itf);
  until s=fail;
  CloseStream(itf);
end);
