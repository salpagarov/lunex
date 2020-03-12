require "DBI.utils"
require "DBI.inline"

local DBI = {
  add = require "DBI.add", get = require "DBI.get", put = require "DBI.put", del = require "DBI.del",
  where  = require "DBI.where", limit  = require "DBI.limit", offset = require "DBI.offset"
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