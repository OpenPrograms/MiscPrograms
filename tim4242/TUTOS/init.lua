--[[Init file if the default BIOS is used]]

--[[API FUNCTION DEFINITION]]

--[[

  Low level load file implementation.

  @arg _addr : The address of the file system to use.
  @arg _path : Path to the file to load.

]]
_G.loadfile = function(_addr, _path)

  local fil, err = component.invoke(_addr, "open", _path) --Open the file

  if not fil then return nil, err end --If an error occured: Return nil and the error

  local buf = "" --The string buffer to write the contents of the file to

  repeat --Read until nothing is left to read

    local dat, err = component.invoke(_addr, "read", fil, math.huge) --Read data from file

    if not dat and err then return nil, err end --If an error occured: Return nil and the error

    buf = buf..(dat or "") --Write the read data or an empty string to the buffer

  until not dat

  component.invoke(_addr, "close", fil) --Close the file

  local chunk, err = load(buf, "=".._path) --Load the chunk from the file

  if not chunk then return nil, err end --If an error occured: Return nil and the error

  return chunk, nil --Return The loaded chunk (and nil for the error)

end

local res, err = loadfile(component.invoke(component.list("eeprom")(), "getData"), "boot/kernel/boot.lua") --Load boot.lua

if res == nil then error(err) end --If an error occured: Error the error

res() --Run the boot file
