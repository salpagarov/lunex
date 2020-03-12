function where (self,row)
  self.params.where = {}
  for k,v in pairs(row) do
    if self.scheme[self.name][k] then
      if self.scheme[self.name][k] == 'number' then table.insert(self.params.where,k..' = '..v) end
      if self.scheme[self.name][k] == 'string' then table.insert(self.params.where,k..' = '..enquote(v)) end
      if string.find(self.scheme[self.name][k],':') then 
        table.insert(self.params.where,k..' IN '..inline(self.scheme,self.scheme[self.name][k],v))
      end
    end
  end
  return self
end
