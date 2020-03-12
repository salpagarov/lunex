require "DBI.escape"
require "DBI.enquote"
require "DBI.enstructurar"
require "DBI.inline"
require "DBI.prepare"
require "DBI.add"
require "DBI.get"
require "DBI.put"
require "DBI.del"
require "DBI.where"
require "DBI.limit"
require "DBI.offset"

local DBI = {
  add = add,
  get = get,
  put = put,
  del = del,
  where = where,
  limit = limit,
  offset = offset
}

return function (config)
  local driver = require('DBI.driver.'..config.driver)(config.connection)
  local DB = {}
  local params = {}
  
  for name,_ in pairs(config.scheme) do
    DB[name] = {}
    setmetatable(DB[name],{
      __index = function (_,k)
        if k == "name"   then return name end
        if k == "scheme" then return config.scheme end
        if k == "driver" then return driver end
        if k == "params" then return params end
        return DBI[k]
      end
    })
  end
  return DB
end