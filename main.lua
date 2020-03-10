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
      name = "string", position = "position:id"
    },
    star = {
      name = "string", position = "position:id", system = "system:name"
    },
    asteroid = {
      name = "string", position = "position:id", star = "star:name"
    },
    planet = {
      name = "string", position = "position:id", star = "star:name"
    },
    satelite = {
      name = "string", position = "position:id", planet = "planet:name"
    }
  }
})
