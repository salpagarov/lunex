local db = require "DBI" {
  driver = "echo",
  connection = {
    hostname = "localhost", database = "lunex", username = "user", password = "p@ssw0rd", codepage = "utf8"
  },
  scheme = {
    user  = {
      id = "number", name = "string", password = "string", group = "group:id"
    },
    group = {
      id = "number", name = "string"
    },
    doc = {
      id = "number", name = "string", owner = "user:id"
    },
    diff = {
      id = "number", doc = "doc:id", user = "user:id", offset = "number", delete = "number", insert = "string", date = "datetime"
    }
  }
}


db.diff:limit(10):offset(5):get({user = {name = "root", password = "p@ssw0rd", group = {name = "Admins"}}})
db.user:del({password = "p@ssword", group = {name = "Admins"}})
db.diff:where({user = {group = {name = "Admins"}}}):put({insert = "hack you!", offset = 0})
db.user:add({name = "root", password = "p@ssw0rd", group = {name = "Admin"}})