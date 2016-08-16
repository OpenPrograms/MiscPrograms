--[[
	A hastebin program 
	wich can download and upload things from/ to hastebin.com
	via the hastebin.com/documents POST API
	
	This program based on the pastebin program
	
	Author: Gurkengewuerz
]]--

local component = require("component")
local fs = require("filesystem")
local shell = require("shell")

if not component.isAvailable("internet") then
  print("This program requires an internet card to run.")
  return
end

local internet = require("internet")
local args, options = shell.parse(...)


local function get(hastebinId, filename)
  local f, reason = io.open(filename, "w")
  if not f then
    print("Failed opening file for writing: " .. reason)
    return
  end

  io.write("Downloading from hastebin.com... ")
  local url = "http://hastebin.com/raw/" .. hastebinId
  local result, response = pcall(internet.request, url)
  if result then
    io.write("success.\n")
    for chunk in response do
      if not options.k then
        string.gsub(chunk, "\r\n", "\n")
      end
      f:write(chunk)
    end

    f:close()
    io.write("Saved data to " .. filename .. "\n")
  else
    io.write("failed.\n")
    f:close()
    fs.remove(filename)
    print("HTTP request failed: " .. response)
  end
end

function run(hastebinId, ...)
  local tmpFile = os.tmpname()
  get(hastebinId, tmpFile)
  print("Running...")

  local success, reason = shell.execute(tmpFile, nil, ...)
  if not success then
    print(reason)
  end
  fs.remove(tmpFile)
end

function split(pString, pPattern)
  local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
  local fpat = "(.-)" .. pPattern
  local last_end = 1
  local s, e, cap = pString:find(fpat, 1)
  while s do
    if s ~= 1 or cap ~= "" then
      table.insert(Table,cap)
    end
    last_end = e+1
    s, e, cap = pString:find(fpat, last_end)
  end
  if last_end <= #pString then
    cap = pString:sub(last_end)
    table.insert(Table, cap)
  end
  return Table
end


local function parse(str)
  local id = split(str, ":")
  id = split(id[2], '"')
  return id[1]
end

function put(path)
  local file, reason = io.open(path, "r")

  if not file then
    print("Failed opening file for reading: " .. reason)
    return
  end

  local data = file:read("*a")
  file:close()

  io.write("Uploading to hastebin.com... ")
  local result, response = pcall(internet.request,
        "http://hastebin.com/documents", 
        data)

  if result then
    local info = ""
    for chunk in response do
      info = info .. chunk
    end
	  io.write("success.\n")
	  local hastebinId = parse(info)
	  print("Uploaded as hastebin.com/" .. hastebinId)
  else
    io.write("failed.\n")
    print(response)
  end
end

local command = args[1]
if command == "put" then
  if #args == 2 then
    put(shell.resolve(args[2]))
    return
  end
elseif command == "get" then
  if #args == 3 then
    local path = shell.resolve(args[3])
    if fs.exists(path) then
      if not options.f or not os.remove(path) then
        print("file already exists")
        return
      end
    end
    get(args[2], path)
    return
  end
elseif command == "run" then
  if #args >= 2 then
    run(args[2], table.unpack(args, 3))
    return
  end
end

print("Usages:")
print("hastebin put [-f] <file>")
print("hastebin get [-f] <id> <file>")
print("hastebin run [-f] <id> [<arguments...>]")
print(" -f: Force overwriting existing files.")
print(" -k: keep line endings as-is (will convert")
print("     Windows line endings to Unix otherwise).")