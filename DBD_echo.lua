return function (connetion)
  return {
    query = function (SQL)
      print ('[echo]',SQL)
    end,
    
    state = function ()
      return {
        affected = 0, inserted = 0, err_code = 0, err_text = nil
      }
    end,
    
    fetch = function ()
      return {}
    end
  }
end