local computer = {}

local native = _G.computer

computer.shutdown = function()

  return native.shutdown(false)

end

computer.restart = function()

  return native.shutdown(true)

end

computer.getTotalMemory = native.totalMemory

computer.freeMemory = native.freeMemory

computer.beep = native.beep

computer.getArchitecture = native.getArchitecture

computer.setArchitecture = native.setArchitecture

computer.getArchitectures = native.getArchitectures

computer.getUptime = native.uptime

computer.pushSignal = native.pushSignal

computer.pullSignal = native.pullSignal

computer.getEnergy = native.energy

computer.getMaxEnergy = native.maxEnergy

computer.getTempAddress = native.tmpAddress

return computer
