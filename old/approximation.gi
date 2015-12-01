#p, q : discrete frequency distributions (same size)
KullbackLeiblerDistance := function(p, q)
  local dp, dq; #density functions
  if Length(p) <> Length(q) then return fail; fi;
  dp := List(p, x-> Float(x/Sum(p)));
  dq := List(q, x-> Float(x/Sum(q)));
  
  if ForAny([1..Length(dp)], i -> dp[i]> 0.0 and dq[i]=0.0) then
    return infinity;
  fi;
  return Sum(List([1..Length(dp)],
              function(i)
    if dp[i] = 0.0 then
      return 0.0;
    else
      return dp[i]*Log2(dp[i]/dq[i]);
    fi;    
  end));
end;

#p, q : discrete frequency distributions (same size)
RestrictedDomainKullbackLeiblerDistance := function(p, q)
  local rp, rq, #restricted domains
        dp, dq; #density functions
  if Length(p) <> Length(q) then return fail; fi;
  rp := [];
  rq := [];
  Perform([1..Size(p)], function(i) if p[i]>0 and q[i] > 0 then
      Add(rp, p[i]);
      Add(rq, q[i]);
    fi;
    end);
      Display(rp);
            Display(rq);
      
  dp := List(rp, x-> Float(x/Sum(rp)));
  dq := List(rq, x-> Float(x/Sum(rq)));
  
  if ForAny([1..Length(dp)], i -> dp[i]> 0.0 and dq[i]=0.0) then
    return infinity;
  fi;
  return Sum(List([1..Length(dp)],
              function(i)
    if dp[i] = 0.0 then
      return 0.0;
    else
      return dp[i]*Log2(dp[i]/dq[i]);
    fi;    
  end));
end;

SizeDist := function(l, N)
  local result;
  result := ListWithIdenticalEntries(N,0);
  Perform(Collected(l), function(x) result[x[1]]:=x[2];end);
  return result;
end;
