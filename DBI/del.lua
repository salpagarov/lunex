function del (self,row)
  row = row or {}
  local where = {}
  for k,v in pairs (row) do
    if self.scheme[self.name][k] == 'string' then table.insert(where,k..' = '..enquote(v)) end
    if self.scheme[self.name][k] == 'number' then table.insert(where,k..' = '..v) end
    if string.find(self.scheme[self.name][k],':') then  table.insert(where,k..' IN '..inline(self.scheme,self.scheme[self.name][k],row[k])) end  
  end
  local SQL = "DELETE FROM "..self.name
  if #where > 0 then SQL = SQL.." WHERE "..table.concat(where," AND ") end
  self.driver.query(SQL)
  return self.driver.state()
end
