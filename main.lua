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

data = {
  system = {
    {
      name = "Solar system",
      position = {
        x = 0, y = 0, z = 0
      },
      star = {
        {
          name = "Sol",
          position = {
            x = 0, y = 0, z = 0
          }
        }
      },
      planet = {
        {
          name = "Earth",
          position = {
            x = 0, y = 0, z = 0
          },
          satellite = {
            {
              name = "Moon",
              position = {
                x = 0, y = 0, z = 0
              }
            }
          }
        },
        {
          name = "Mars",
          position = {
            x = 0, y = 0, z = 0
          },
          satellite = {
            {
              name = "Phobos",
              position = {
                x = 0, y = 0, z = 0
              }
            },
            {
              name = "Deimos",
              position = {
                x = 0, y = 0, z = 0
              }
            }
          }
        }
      }
    }
  }
}

-- db:put (data)

moonbaseA = db.satelite:get({planet = {name = "Earth", system = {name = "Solar System"}}})