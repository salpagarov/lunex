function get (self,row)
  self.params.columns,self.params.join,self.params.where = {},{},{}
  prepare (self,self.name,self.name,row or {})
  local SQL = "SELECT\n  "..table.concat(self.params.columns,",\n  ").."\nFROM "..self.name
  if self.params.join   then SQL = SQL..'\n'..table.concat(self.params.join,"\n") end
  if self.params.where  then SQL = SQL.."\nWHERE\n  "..table.concat(self.params.where," AND\n  ") end
  if self.params.limit  then SQL = SQL.."\nLIMIT "..self.params.limit end
  if self.params.offset then SQL = SQL.."\nOFFSET "..self.params.offset end
  self.params = {}
  local ROWs = {}
  self.driver.query(SQL)
  for _,ROW in pairs(self.driver.fetch()) do
    table.insert(ROWs,enstructurar(ROW)[self.name])
  end
  return ROWs
end