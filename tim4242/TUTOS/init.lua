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

local res, err = loadfile(computer.getBootAddress(), "boot/kernel/boot.lua")

if res == nil then error(err) end

res()
