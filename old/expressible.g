#taken from v0.52

# using global tables, trying to figure out whether a given element is
# expressible as a product of generators

# processed - true if already calculated
# result - the value of calculation
Expressible := function(elt,gens,mt)
  local result, processed,f;
  f := function(elt)
    if processed[elt] then
      return result[elt];
    fi;
    if elt in gens then
      result[elt] := true;
      processed[elt] := true;  
    else
      result[elt] := ForAny(GlobalTables(mt)[elt],
                            x-> f(x[1]) and ForAny(x[2],f));
      processed[elt] := true;
    fi;

    return result[elt];
  end;
  result := BlistList(Indices(mt),[]);
  processed := BlistList(Indices(mt),[]);
  return f(elt);
end;

