status("Cleaning up global namespace") --Inform the user

--[[CLEANUP]]

--Removal of global libraries
_G.computer = nil
_G.component = nil
_G.os = nil

--Removal of depricated functionality
_G.getBootAddress = nil
_G.setBootAddress = nil

--[[

  Global function for reading text files from the file system.

  @arg _path (string) : The path to the file.

  @return (string / nil, string) The loaded string or nil and the error.

]]
_G.readfile = function(_path)

  if not services.filesystem.exists(_path) then return nil, "File ".._path.." not found" end --Test if the file exists

  local file, err = services.filesystem.open(_path, "r") --Open the file

  if not file then return nil, err end --If an error occured, error

  local buf = "" --Return buffer

  while true do --Loop...

    local data = file:read(math.huge) --Read data from the file

    if not data then break end --...Until there is no more data to read

    buf = buf..data --Add the read data to the buffer

  end

  file:close() --Close the file

  return buf, nil --Return the buffer

end

--[[

  Global function to load a chunk from a file in the file system.

  @arg _path (string) : The path to load from.

  @return (function / nil, string) The loaded chunk or nil and the error.

]]
_G.loadfile = function(_path)

  local file, err = readfile(_path) --Read the file from the system

  if not file then return nil, err end --If an error occured, error

  local chunk, err = load(file, "=".._path) --Load the chunk from the loaded text

  if not chunk then return nil, err end --If an error occured, error

  return chunk, nil --Return loaded chunk

end

--[[

  Global function to run a file in the file system.

  @arg _path (string) : Path to the file to execute.

  @return (value / nil, string) : The return value of the given file or nil and the error.

]]
_G.dofile = function(_path)

  local chunk, err = loadfile(_path) --Load the chunk from the file system

  if not chunk then return nil, err end --If an error occured, error

  local stat, res = pcall(chunk) --Call the chunk, safely

  if not stat then return nil, res end --If an error occured, error

  return res --Return value

end

--[[

  Global function to load libraries or modules from the file system.

  @arg _name (string) : The module / library name / identification.

  @return (table / nil, error) THe library / module or nil and the error.

]]
_G.require = function(_name)

  local res, err = services.modules.getModule(_name) --Try to get already loaded module

  if not res then --If none are found

    res, err = services.modules.loadModule(_name) --Try to load it

    if not res then return nil, err or "No module / library of that name found" end --If there is none or an error occured, error

  end

  return res, nil --Return loaded library / module

end

_G.print = function(_msg)

end

return true
