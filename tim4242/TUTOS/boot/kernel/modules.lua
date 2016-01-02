local modules = {}


local searchPaths = {}
local loaded = {}


modules.getModule = function(_name)

  return loaded[_name]

end

modules.setModule = function(_name, _module)

  loaded[_name] = _module

end

modules.loadModule = function(_name)

  local fs = getService("filesystem")

  for _, v in pairs(searchPaths) do

    local rPath = v:gsub("!", _name)

      if fs.exists(rPath) then

        res, err = dofile(rPath)

        if not res then return nil, err end

        modules.setModule(_name, res)

        return res, nil

      end

  end

  return nil, "Could not find any pussible files"

end

modules.addSearchPath = function(_path)

  if type(_path) ~= "string" then return end

  table.insert(searchPaths, _path)

end

modules.getSearchPaths = function()

  return searchPaths

end

return modules
