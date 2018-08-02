-- Light Controller Network Service
-- This script will provide an open port and service for tablets.
-- The service will wait for incoming messages or broadcasts, providing remote light control.
-- Requires: Redstone Card, Wireless Card

local colors = require("colors")
local component = require("component")
local shell = require("shell")
local sides = require("sides")
local event = require("event")

-- Configuration
local port = 43255
local side = sides.right
local kill = "kill"
local on = "on"
local off = "off"
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
print("*   Remote Light Service   *")
print("****************************")

print("Starting service...")

-- Start Service

m.open(port)

if m.isOpen(port) then print("Light service is listening on port => " .. port.."\n") end

local running = nil

while running ~= kill do
  local _, _, from, port, _, message = event.pull("modem_message")

  message = tostring(message)
  running = message

  if message == on then
    rs.setOutput(side, strength)
    print("[+] : [" .. from .. "] : "Turning on lights")
  end

  if message == off then
    rs.setOutput(side, 0)
    print("[-] : [" .. from .. "] : Turning off lights")
  end

  if message ~= on and message ~= off  and message ~= kill then
    print("[-] : [" .. from .. "] : " .. message)
  end

  if message == kill then
    print("[!] : [" .. from .. "] : "Killing service")
  end

end