function enquote (str) 
  return "'"..escape(str).."'" 
end

function escape (str)
  for k,v in pairs ({['\n'] = '\\n',["\'"] = "\\'",['\"'] = '\\"',['%%'] = '\\%%'}) do 
    str = string.gsub(str,k,v) 
  end
  return str
end

function enstructurar (raw,prefix)
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