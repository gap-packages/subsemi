################################################################################
##
## SubSemi package
##
## Some utility methods for printing information in logs.
##
## Copyright (C) 2013-2017  Attila Egri-Nagy
##

# the time of day in seconds
InstallGlobalFunction(TimeInSeconds,
        function() return IO_gettimeofday().tv_sec; end);

################################################################################
### Float ###########################################################
#when printing Floats the precision causes lots of trouble
InstallGlobalFunction(FloatString,
function(f)
local i,d,s;
  i := Int(f * 100);
  d := i mod 100;
  s := "";
  if d < 10 then s := "0";fi;
  return Concatenation(String(Int(i/100)),".",s,String(d));
end);

################################################################################
### PERCENTAGESTRING ###########################################################

InstallGlobalFunction(PercentageString,
function(n,N)
  return Concatenation(FloatString((Float(n)/Float(N)) * 100),"%");
end);

################################################################################
#### TIMESTRING ################################################################

util_timeunits@ := ["d","h","m","s","ms"];
MakeReadOnlyGlobal("util_timeunits@");
util_durations@ := [24*60*60*1000, 60*60*1000, 60*1000, 1000, 1];
MakeReadOnlyGlobal("util_durations@");

InstallGlobalFunction(TimeString,
function(t)
local vals,k,s;
  if t = 0 then return "-";fi; #not measurable
  vals := [];
  for k in util_durations@ do
    Add(vals, Int(t/k));
    t := t - vals[Length(vals)] * k;
  od;
  s := "";
  k := 1;
  while vals[k] = 0 do k := k+1; od;
  while k <= Length(util_durations@) do
    s := Concatenation(s, String(vals[k]),util_timeunits@[k]);
    k := k+1;
  od;
  return s;
end);

################################################################################
### MEMORYSTRING ###############################################################

#returns the readable string representation of the number of bytes
InstallGlobalFunction(MemoryString,
function(numofbytes)
  if numofbytes < 1024 then
    return Concatenation(String(numofbytes),"B");
  elif numofbytes >= 1024 and numofbytes < 1024^2 then
    return Concatenation(FloatString(Float(numofbytes/1024)),"KB");
  elif numofbytes >= 1024^2 and numofbytes < 1024^3 then
    return Concatenation(FloatString(Float(numofbytes/(1024^2))),"MB");
  elif numofbytes >= 1024^3 and numofbytes < 1024^4 then
    return Concatenation(FloatString(Float(numofbytes/(1024^3))),"GB");
  fi;
end);

# more readable format for big numbers
# when bigger then a thousand only thousands are displayed
# beyond 1000 septillions it gives up pretty printing
InstallGlobalFunction(BigNumberString,
function(num)
  local str,codes,i,n;  
  str := "";
  codes := ["K","M","B","T","Q","QUI","SEX","SEP"];
  #K, million, billion, trillion, quadrillion, quantillion, sextillion,septillion
  if num < 1000 or num > 1000^(Size(codes)+1) then
    str := String(num);
  else    
    for i in [1..Size(codes)] do
      n := Int(Float(num/(1000^i))) mod 1000 ;
      if n <> 0 then
        str := Concatenation(String(n), codes[i]," ",str);
      fi;
    od;
  fi;
  NormalizeWhitespace(str);
  return str;
end);
