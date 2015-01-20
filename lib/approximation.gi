#p, q : discrete frequency distributions (same size)
KullbackLeiblerDistance := function(p, q)
  local dp, dq; #density functions
  if Length(p) <> Length(q) then return fail; fi;
  dp := List(p, x-> Float(x/Sum(p)));
  dq := List(q, x-> Float(x/Sum(q)));
  
  if ForAny([1..Length(dp)], i -> dp[i]> 0.0 and dq[i]=0.0) then
    return infinity;
  fi;
  return List([1..Length(dp)],
              function(i)
    if dp[i] = 0.0 then
      return 0.0;
    else
      return dp[i]*Log2(dp[i]/dq[i]);
    fi;    
  end);
end;
