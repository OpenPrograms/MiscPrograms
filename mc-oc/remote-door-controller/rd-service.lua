-- Remote Door Network Service
-- This script will provide an open port and service for tablets.
-- The service will wait for incoming messages or broadcasts, providing remote door control.
-- Requires: Redstone Card, Wireless Card

local colors = require("colors")
local component = require("component")
local shell = require("shell")
local sides = require("sides")
local event = require("event")

-- Configuration
local port = 43254
local side = sides.right
local kill = "kill"
local open = "open"
local close = "close"
local strength = 15

-- Component Verification

if not component.isAvailable("redstone") then
  io.stderr:write("This program requires a redstone card or redstone I/O block.\n")
  return 1
end
local rs = component.redstone

if not component.isAvailable("modem") then
  io.stderr:write("This program requires a network or wireless card.")
  return 1
end
local m = component.modem

-- Intro

print("****************************")
print("* Remote Iron Door Service *")
print("****************************")

print("Starting service...")

-- Start Service

m.open(port)

if m.isOpen(port) then print("Door service is listening on port => " .. port.."\n") end

local running = nil

while running ~= kill do
  local _, _, from, port, _, message = event.pull("modem_message")

  message = tostring(message)
  running = message

  if message == open then
    rs.setOutput(side, strength)
    print("[+] : [" .. from .. "] : "Opening door")
  end

  if message == close then
    rs.setOutput(side, 0)
    print("[-] : [" .. from .. "] : "Closing door")
  end

  if message ~= open and message ~= close  and message ~= kill then
    print("[-] : [" .. from .. "] : " .. message)
  end

  if message == kill then
    print("[!] : [" .. from .. "] : "Killing service")
  end

end