function add (self,row)
  local COLs,VALs = {},{}
  for k,v in pairs(row) do
    if self.scheme[self.name][k] then
      table.insert(COLs,k)
      if self.scheme[self.name][k] == 'number' then table.insert(VALs,v) end
      if self.scheme[self.name][k] == 'string' then table.insert(VALs,enquote(v)) end
      if string.find(self.scheme[self.name][k],':') then 
        table.insert(VALs,inline(self.scheme,self.scheme[self.name][k],row[k])) 
      end
    end
  end
  self.driver.query('INSERT INFO '..self.name..' ('..table.concat(COLs,',')..') VALUES ('..table.concat(VALs,',')..')')
  return self.driver.state()    
end