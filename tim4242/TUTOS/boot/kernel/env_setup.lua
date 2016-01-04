status("Cleaning up global namespace")

_G.computer = nil
_G.component = nil
_G.os = nil

_G.getBootAddress = nil
_G.setBootAddress = nil

local fs = getService("filesystem")

_G.readfile = function(_path)

  if not fs.exists(_path) then return nil, "File ".._path.." not found" end

  local file, err = fs.open(_path, "r")

  if not file then return nil, err end

  local buf = ""

  while true do

    local data = file:read(math.huge)

    if not data then break end

    buf = buf..data

  end

  file:close()

  return buf, nil

end

_G.loadfile = function(_path)

  local file, err = readfile(_path)

  if not file then return nil, err end

  local chunk, err = load(file, "=".._path)

  if not chunk then return nil, err end

  return chunk, nil

end

_G.dofile = function(_path)

  local chunk, err = loadfile(_path)

  if not chunk then return nil, err end

  local stat, res = pcall(chunk)

  if not stat then return nil, res end

  return res

end

_G.require = function(_name)

  local res, err = getService("modules").getModule(_name)

  if not res then

    res, err = getService("modules").loadModule(_name)

    if not res then return nil, err end

  end

  return res, nil

end

_G.print = function(_msg)

end

return true
