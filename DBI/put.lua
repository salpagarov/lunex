function put (self,row) 
  local EXPRs = {}
  for k,v in pairs(row) do
    if self.scheme[self.name][k] == 'number' then table.insert(EXPRs,k..' = '..v) end
    if self.scheme[self.name][k] == 'string' then table.insert(EXPRs,k..' = '..enquote(v)) end
    if string.find(self.scheme[self.name][k],':') then table.insert(EXPRs,k..' = '..inline(self.scheme,self.scheme[self.name][k],v)) end
  end
  local SQL = "UPDATE "..self.name.." SET "..table.concat(EXPRs,',')
  if self.params.where then SQL = SQL..' WHERE '..table.concat(self.params.where,' AND ') end
  self.params.where = nil
  self.driver.query (SQL)
  return self.driver.state ()
end