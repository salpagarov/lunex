function inline (scheme,name,data)
  local where,rt,rc = {},string.match(name,"(%w+):(%w+)")
  local SQL = "SELECT "..rc.." FROM "..rt
  for k,_ in pairs (data) do
    if scheme[rt][k] == 'number' then table.insert(where,k..' = '..data[k]) end
    if scheme[rt][k] == 'string' then table.insert(where,k..' = '..enquote(data[k])) end
    if string.find(scheme[rt][k],':') then table.insert(where,k..' IN '..inline(scheme,scheme[rt][k],data[k])) end
  end
  if #where > 0 then SQL = SQL.." WHERE "..table.concat(where," AND ") end
  return '('..SQL..')'
end
