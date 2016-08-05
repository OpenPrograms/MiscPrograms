local component = {}

local native = _G.component

local comps = {}
local mains = {}

component.getMain = function(_type)

  if not component.hasType(_type) then return nil end

  if not mains[_type] or not comps[_type][mains[_type]] then

    component.setMain(next(comps[_type]))

  end

  return comps[_type][mains[_type]]

end

component.setMain = function(_addr)

  local type = component.getType(_addr)

  if type and comps[type] and comps[type][_addr] then

    mains[type] = _addr

  end

end

component.getAll = function(_type)

  return comps[_type]

end

component.hasType = function(_type)

  return type(comps[_type]) == "table"

end

component.getType = native.type

component.getData = function(_addr)

  if not component.getType(_addr) then return nil end

  local res = {}

  res.adress = _addr

  res.type = component.getType(_addr)

  res.methods = native.methods(_addr)

  res.docs = {}

  for k, v in pairs(res.methods) do

    res.docs[k] = native.doc(_addr, k)

  end

  return res

end

component.exists = function(_addr)

  return component.getType(_addr) ~= nil

end

component.getProxy = native.proxy

component.callFunc = native.invoke

setmetatable(component, {

  __index = function(_table, _key)

    return _table.getMain(_key)

  end

})

for comp in native.list() do

  local t = component.getType(comp)

  if comps[t] == nil then comps[t] = {} end

  comps[t][comp] = component.getProxy(comp)

end

return component
