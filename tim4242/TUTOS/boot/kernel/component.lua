local component = {}

local native = _G.component

local comps = {}
local mains = {}

component.getMain = function(_type)

  if not component.hasType() then return nil end

  if not mains[_type] or not comps[_type][mains[_type]] then

    mains[_type] = pairs(comps[_type])()

  end

  return comps[_type][mains[_type]]

end

component.setMain = function(_addr)

  local type = component.getType(_adr)

  if type and comps[type] and comps[type][_addr] then

    mains[_type] = _addr

  end

end

component.getAll = function(_type)

  return comps[_type]

end

component.hasType = function(_type)

  return type(comps[_types]) == "table"

end

component.getType = function(_addr)

  return native.type(_addr)

end

component.getData = function(_addr)

  if not component.getType(_addr) then return nil end

  local res = {}

  res.adress = _addr

  res.type = component.getType(_addr)

  res.methods = native.methods(_addr)

  res.docs = {}

  for k, v in pairs(res.methods) do

    docs[k] = res.doc(_addr, k)

  end

  return res

end

component.exists = function(_addr)

  return component.getType(_addr) ~= nil

end

return component
