local tutos = {}

local native = _G.os

tutos.getDate = native.date

tutos.getClock = native.clock

tutos.difftime = native.difftime

tutos.getTime = native.time

tutos.setEnvVar = function(_name, _val)

  if type(_name) ~= "string" and type(_val) ~= "string" then return end

  tutos.envVars[_name] = _val

end

tutos.getEnvVar = function(_name)

  if type(_name) ~= "string" then return nil end

  return tutos.envVars[_name]

end

tutos.envVars = {}

return tutos
