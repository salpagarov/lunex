local function escape (str)
  for k,v in pairs ({['\n'] = '\\n',["\'"] = "\\'",['\"'] = '\\"',['%%'] = '\\%%'}) do str = string.gsub(str,k,v) end
  return str
end

local function enquote (str) 
  return "'"..escape(str).."'" 
end

local function enstructurar (raw,prefix)
  prefix = prefix or ''
  local row,name,related = {},nil,nil
  for column,value in pairs(raw) do
    name = string.match(column,'^'..prefix.."(.+)")
    if name then
      related = string.match(name,"^(%w+)_.+")
      if related then
        row[related] = enstructurar (raw,prefix..related..'_')
      else
        row[name] = value
      end
    end
  end
  return row
end

local function inline (scheme,name,data)
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

local function prepare (self,prefix,name,row)
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

local function del (self,row)
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

local function add (self,row)
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

local function where (self,row)
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

local function put (self,row) 
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

local function limit (self,n)
  self.params.limit = n
  return self
end

local function offset (self,n)
  self.params.offset = n
  return self
end

local function get (self,row)
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

return function (config)
  local DB     = {}
  local params = {}
  
  local scheme = config.scheme
  local driver = require('DBI-'..config.driver)(config.connection)
  
  for name,_ in pairs(config.scheme) do
    DB[name] = {}
    setmetatable(DB[name],{
      __index = function (_,k)
        if k == "name"   then return name end
        if k == "scheme" then return scheme end
        if k == "driver" then return driver end
        if k == "params" then return params end
        if k == "get"    then return get end
        if k == "put"    then return put end
        if k == "add"    then return add end
        if k == "del"    then return del end
        if k == "where"  then return where end
        if k == "limit"  then return limit end
        if k == "offset" then return offset end
      end
    })
  end
  return DB
end