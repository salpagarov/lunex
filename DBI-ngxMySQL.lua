return function (config)
  local mysql = require "resty.mysql"
  
  local ngxDB, err = mysql:new()
  if not ngxDB then 
    ngx.log(ngx.ERR, "Failed to instantiate mysql: " .. err) 
  end
  
  local ok, errmessage, errcode, sqlstate = ngxDB:connect{
      host = config.hostname,
      database = config.database,
      user = config.username,
      password = config.password,
      charset = config.codepage and config.codepage or "utf8",
      port = 3306,
      max_packet_size = 1024 * 1024
  }
  if not ok then 
    ngx.log(ngx.ERR, "Failed to connect: ".. errmessage.. ": ".. errcode.. " ".. sqlstate) 
  end
  
  return  {
    _ngxDB = ngxDB,
    
    query = function (self, SQL)
      local bytes, err = self._ngxDB:send_query(SQL)
      if not bytes then 
        ngx.log(ngx.ERR, "Failed to send query: " .. err) 
      end
      local res, err_text, err_code, sqlstate = self._ngxDB:read_result()
      self._data = res
    end,
    
    state = function (self)
      return {
        affected = 0,
        inserted = 0,
        err_code = 0,
        err_text = nil
      }
    end
    
    fetch = function (self)
      return self._data
    end,
  }
end