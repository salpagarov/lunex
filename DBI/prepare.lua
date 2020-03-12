function prepare (self,prefix,name,row)
  for k,v in pairs(self.scheme[name]) do
    if string.find(v,':') then
      local rt,rc = string.match(v,"(%w+):(%w+)")
      table.insert(self.params.join,"JOIN "..rt.." AS "..(prefix..'_'..k).." ON "..(prefix..'_'..k)..'.'..rc.." = "..prefix..'.'..k)
      prepare(self,prefix..'_'..k,rt,row[k] and row[k] or {})
    else
      table.insert(self.params.columns,prefix..'.'..k.." AS "..(prefix..'_'..k))
      if row[k] then
        table.insert(self.params.where,prefix..'.'..k.." = "..((self.scheme[name][k] ~= "number") and enquote(row[k]) or row[k]))
      end
    end
  end
end
