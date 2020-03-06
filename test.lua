local scheme = require "scheme",
local driver = require "echo",
local connection = require "connection"

local db = require "DBI" ({scheme = scheme, driver = driver, connection = connection})


db.diff:limit(10):offset(5):get({user = {name = "root", password = "p@ssw0rd", group = {name = "Admins"}}})
db.user:del({password = "p@ssword", group = {name = "Admins"}})
db.diff:where({user = {group = {name = "Admins"}}}):put({insert = "hack you!", offset = 0})
db.user:add({name = "root", password = "p@ssw0rd", group = {name = "Admin"}})