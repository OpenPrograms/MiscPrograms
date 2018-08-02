-- Remote Door Network Client
-- Most commonly used with tablets
-- Requires: rd-service hosting machine

local colors = require("colors")
local component = require("component")
local shell = require("shell")

-- Remote requirements
local event = require("event")

if not component.modem then
  io.stderr:write("This program requires a modem.\n")
  return 1
end
local m = component.modem

local args, options = shell.parse(...)

local port = args[1]
local cmd = args[2]
local strength = args[3]

if not port or not cmd or not strength then
  print("Usage: rd-cli <port> <cmd> <strength>")
  return 1
end

m.setStrength(tonumber(strength))
m.broadcast(tonumber(port), tostring(cmd))