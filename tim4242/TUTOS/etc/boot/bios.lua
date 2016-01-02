local bootPath = "/boot/kernel/boot.lua"

do

  local screen = component.list("screen")()
  local gpu = component.list("gpu")()

  if gpu and screen then component.invoke(gpu, "bind", screen) end

end

local eeprom = component.list("eeprom")()

local function getData() return component.invoke(eeprom, "getData") end
local function setData(_data) return component.invoke(eeprom, "setData", _data) end

_G.loadfile = function(_addr, _path)

  local fil, err = component.invoke(_addr, "open", _path)

  if not fil then return nil, err; end

  local buf = ""

  repeat

    local dat, err = component.invoke(_addr, "read", fil, math.huge)

    if not dat and err then return nil, err end

    buf = buf..(dat or "")

  until not dat

  component.invoke(_addr, "close", fil)

  return load(buf, "=".._path)

end

local boot, err

local data = getData()

if data and type(data) == "string" and #data > 0 then

  boot, err = loadfile(data, bootPath)

end

if not boot then

  setData("")

  for addr in component.list("filesystem") do

    boot, err = loadfile(addr, bootPath)

    if boot then

      setData(addr)
      break

    end

  end

end

if not boot or err then

  error("no bootable medium found" .. (err and (": " .. tostring(err)) or ""), 0)

end

computer.beep(1000, 0.2)
boot()
