function escape (str)
  for k,v in pairs ({['\n'] = '\\n',["\'"] = "\\'",['\"'] = '\\"',['%%'] = '\\%%'}) do 
    str = string.gsub(str,k,v) 
  end
  return str
end
