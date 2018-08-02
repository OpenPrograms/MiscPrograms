-- Lights Standalone Controller
-- Run this from a machine that has a Redstone Card

local component = require("component")
local shell = require("shell")
local sides = require("sides")

-- Configuration

local side = sides.top
local strength = 24
local on = "on"
local off = "off"

-- Application

local args, options = shell.parse(...)

local cmd = args[1]

if not cmd then
  print("Usage: lights <on/off>")
  return 1
end

-- Component Verification

if not component.isAvailable("redstone") then
  io.stderr:write("This program requires a redstone card or redstone I/O block.\n")
  return 1
end
local rs = component.redstone

if cmd == on then
    rs.setOutput(side, strength)
end

if cmd == off then
 rs.setOutput(side, 0)
end