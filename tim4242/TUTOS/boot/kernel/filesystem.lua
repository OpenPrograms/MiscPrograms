local filesystem = {}

local comp_call = component.invoke

local mounts = {}

local function getAddrAndPath(_path)

  if _path:sub(1, 1) ~= "/" then _path = "/".._path end

  if mounts[_path] ~= nil then return mounts[_path], "/" end

  local parts = {}

  table.insert(parts, "")

  for part in string.gmatch(_path, "([^/]+)") do

    table.insert(parts, part)

  end

  local i = #parts

  repeat

    local joined = ""

    for j=1,i do joined = joined.."/"..parts[j] end

    if mounts[joined] ~= nil then

      local resPath = ""

      for j=i + 1,#parts do resPath = resPath.."/"..parts[j] end

      return mounts[joined], resPath

    end

    i = i - 1

  until i == 0

  return

end

local function OPonPath(_path, _type, ...)

  local addr, path = getAddrAndPath(_path)

  return comp_call(addr, _type, path, ...)

end

filesystem.exists = function(_path)

  return OPonPath(_path, "exists")

end

filesystem.open = function(_path, _mode)

  local addr, path = getAddrAndPath(_path)

  if not filesystem.isFile(_path) then return nil, _path.." is a directory" end

  local handle, err = comp_call(addr, "open", _path, _mode)

  if not handle then return nil, err end

  local res = {}

  res.addr = addr
  res.handle = handle

  res.seek = function(self, _whence, _offset)

    return comp_call(self.addr, "seek", self.handle, _whence, _offset)

  end

  res.read = function(self, _count)

    return comp_call(self.addr, "read", self.handle, _count)

  end

  res.write = function(self, _value)

    return comp_call(self.addr, "write", self.handle, _value)

  end

  res.close = function(self)

    return comp_call(self.addr, "close", self.handle)

  end

  return res

end

filesystem.list = function(_path)

  return OPonPath(_path, "list")

end

filesystem.rename = function(_path, _name)

  return OPonPath(_path, "rename", _name)

end

filesystem.makeDirectory = function(_path)

  return OPonPath(_path, "makeDirectory")

end

filesystem.delete = function(_path)

  return OPonPath(_path, "delete")

end

filesystem.size = function(_path)

  return OPonPath(_path, "size")

end

filesystem.space = function(_path)

  return comp_call(getAddrAndPath(_path), "space")

end

filesystem.isDirectory = function(_path)

  return OPonPath(_path, "isDirectory")

end

filesystem.isMount = function(_path)

  return mounts[_path] ~= nil

end

filesystem.isFile = function(_path)

  return not filesystem.isDirectory(_path)

end

filesystem.mount = function(_path, _addr)

  mounts[_path] = _addr

end

filesystem.unmount = function(_path)

  if not filesystem.isMount(_path) then return end

  mounts[_path] = nil

end

for fs in component.list("filesystem") do

  filesystem.mount("/mnt/"..fs:sub(1, 3), fs)

end

filesystem.mount("/", component.invoke(component.list("eeprom")(), "getData"))

return filesystem
