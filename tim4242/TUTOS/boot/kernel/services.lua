local serviceTypes = {

  modules = {

    getModule = "function",
    setModule = "function",
    loadModule = "function",
    addSearchPath = "function",
    getSearchPaths = "function",

  },

  filesystem = {

    exists = "function",
    open = "function",
    makeDirectory = "function",
    delete = "function",
    isDirectory = "function",
    isFile = "function",
    isMount = "function",
    mount = "function",
    unmount = "function",

  },

  component = {

    getMain = "function",
    setMain = "function",
    getAll = "function",
    getType = "function",
    hasType = "function",
    getData = "function",
    exists = "function",

  }

}

local defaultServicePath = "/boot/kernel/"

local services = {}

local function loadService(_path, _type)

  if type(_type) == "table" then

  elseif type(_type) == "string" and serviceTypes[_type] ~= nil then

    _type = serviceTypes[_type]

  end

  if type(_type) ~= "table" then return nil, "Arg #2 has to be a string or a table" end

  local loaded, err = dofile(_path)

  if err then return nil, err end

  if type(loaded) ~= "table" then return nil, "Modules have to be a table, but was a "..type(loaded) end

  for k, v in pairs(_type) do

    if type(loaded[k]) ~= v then return nil, "Module part "..k.." is "..type(loaded[k]).." instead of "..v end

  end

  return loaded

end

--Load service locations

for k, v in pairs(serviceTypes) do

  if not services[k] then

    services[k], err = loadService(defaultServicePath..k..".lua", k)

    if not services[k] then

      error("Failed to load default service \""..k.."\": "..tostring(err))

    end

    status("Loaded service \""..k.."\" from "..defaultServicePath..k..".lua", "success")

  end

end

_G.getService = function(_type)

  return services[_type]

end

local modules = getService("modules")

modules.addSearchPath("/lib/!.lua")
modules.addSearchPath("/lib/!/main.lua")
modules.addSearchPath("/lib/!/!.lua")

modules.addSearchPath("/home/lib/!.lua")
modules.addSearchPath("/home/lib/!/main.lua")
modules.addSearchPath("/home/lib/!/!.lua")

return nil
