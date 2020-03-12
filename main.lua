local db = require "DBI" ({
  driver = "echo", 
  connection = {
    hostname = "localhost", database = "lunex", username = "user", password = "p@ssw0rd", codepage = "utf8"
  },
  scheme = {
    position = {
      id = "number", x = "number", y = "number", z = "number"
    },
    system = {
      id = "number", name = "string", position = "position:id"
    },
    star = {
      id = "number", name = "string", position = "position:id", system = "system:id"
    },
    asteroid = {
      id = "number", name = "string", position = "position:id", system = "system:id"
    },
    planet = {
      id = "number", name = "string", position = "position:id", system = "system:id"
    },
    satelite = {
      id = "number", name = "string", position = "position:id", planet = "planet:id"
    }
  }
})
moonbaseA = db.satelite:get({planet = {name = "Earth", system = {name = "Solar System"}}})