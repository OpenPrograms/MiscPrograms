--[[FILE FOR SERVICE DEFINITION AND LOADING]]

local serviceTypes = { --Table of all services

  modules = { --Definition for the modules service

    --[[

      Function for getting a module instance, doesn't load it.

      @arg _name (string) : The name / identification of the module.

      @return (boolean) The module if it is loaded or nil.

    ]]
    getModule = "function",

    --[[

      Function for setting a module instance.

      @arg _name string : The name / identificatiom of the module to set.
      @arg _module table : The instance to set it to.

    ]]
    setModule = "function",

    --[[

      Function for loading a module.

      @arg _name (string) : The name / identification of the module to load.

      @return (table / nil, string) The loaded module or nil and the error.

    ]]
    loadModule = "function",

    --[[SEARCH PATHS]]
    --Search paths have to be paths from root.
    --If they include "!" they will be replaced with the module name / identification

    --[[

      Function to add a search path.

      @arg _path (string) : The path to add.

    ]]
    addSearchPath = "function",

    --[[

      Function for getting all paths.

      @return (table) All paths in a table, indecies are rising integers.

    ]]
    getSearchPaths = "function",

  },

  filesystem = { --Definition for the filesystem module

    --[[PATHS]]
    --All paths have to start with a "/" at root

    --[[

      Function for checking if a file or folder exists.

      @arg _path (string) : The path to check for.

      @return (boolean) If something exists at this path.

    ]]
    exists = "function",

    --[[

      Function for creating a file object containing the following methods:

        Method for reading data from the file

        [

          Function for reading data from ther file.

          @arg _count (number) : The number of pieces of dat ato be read.

          @return (value) The read data

        ]
        function read(self, _count)

        [

          Function for setting the FP offset.



        ]
        function seek(self, _whence, _offset)

        [

          Function for writing data to the file.

          @arg _value (value) : The value to write.

        ]
        function write(self, _value)

        [

          Closes the file, any other file access will be rejected.

        ]
        function close(self)

        @arg _path (string) : The path to the file to be opened.

        @arg _mode (string) : The way to open a file, can be:
                     - "r": Read only.
                     - "w": Write only, can also create a file, overrides all contents of the file.
                     - "a": Appends to the current contents of the file.

        @return (table / nil, string) A file object.
    ]]
    open = "function",
    --[[

      Lists all files and directories in a directory, only one layer.

      @arg _path (string) : The path to the directory to be listed.

      @return (table) A table of the names of all objects in the directory.

    ]]
    list = "function",
    --[[

      Function to rename an object.

      @arg _path (string) : The path to the object.
      @arg _name (string): The new name of the object.

    ]]
    rename = "function",
    --[[

      Function to create new directories.
      Any missing parent directories will also be created.

      @arg _path (string) : The path to the directory.

    ]]
    makeDirectory = "function",
    --[[

      Function for deleting objects from the file system.

      @arg _path (string) : The path to the object that should be deleted.

    ]]
    delete = "function",
    --[[

      Function for getting the size of an object.

      @arg _path (string) : The path to the object that should be mesured.

      @return (number) The size of the object.

    ]]
    size = "function",
    --[[

      Function for getting the space in the entire file system.

      @arg _path (string) : The path to the file system to be measured.

      @return (number) The size of the file system the path points to.

    ]]
    space = "function",
    --[[

      Function to check if a path points to a directory.

      @arg _path (string) : The path to check.

      @return (boolean) If the path points to a directory.

    ]]
    isDirectory = "function",
    --[[

      Function to check if a path points to a file.

      @arg _path (string) : The path to check.

      @return (boolean) If the path points to a file.

    ]]
    isFile = "function",
    --[[

      Function checks if a path points to a mount.

      @arg _path (string) : The path to check.

      @return (boolean) If the path points to a mount.

    ]]
    isMount = "function",
    --[[

      Function to mount a file system.

      @arg _path (string) : The path to mount the file system to.
      @arg _addr (string) : The address of the file system to mount.

    ]]
    mount = "function",
    --[[

      Function to unmount a file system.

      @arg _path (string) : The path to unmount a file system from.

    ]]
    unmount = "function",

  },

  component = { --Definition fore the component service

    --[[

      Function for getting the main component.
      The main component is randomly assigned to
      set it to one that you see fit use "setMain".

      @arg _type (string) : The type of component you want to get the main from.

      @return (table) The main component of the given type.

    ]]
    getMain = "function",
    --[[

      Function to set the main component.

      @arg _addr (string) : The address of the component to set to main of its type.

    ]]
    setMain = "function",
    --[[

      Function to get all components of a type.

      @arg _type (string): The type to get components from.

      @return (table) All components of that type.

    ]]
    getAll = "function",
    --[[

      Function to get the type of a component.

      @arg _addr (string) : The address of the component to check.

      @return (string) The type of the component.

    ]]
    getType = "function",
    --[[

      Function to check if any of a specific component are available.

      @arg _type (string) : The type to check for.

      @return (string) The type of the given component.

    ]]
    hasType = "function",
    --[[

      Function for getting data about a component.

      The data is returned in a table in this format:

        |
        +-address (string) = "Address of the component"
        |
        +-type (string) = "Type of the component"
        |
        +-methods (table) = +
        |                   |
        |                   +-"Method 1" (string)
        |                   |
        |                   +-"Method 2" (string)
        |                   |
        |                   ...
        |
        |
        +-docs (table) = +
                         |
                         +-"Method 1" (string) = "Method 1 doc" (string)
                         |
                         +-"Method 2" (string) = "Method 2 doc" (string)
                         |
                         ...


      @arg _addr (string) : The address of the component to build data for.

      @return (table) the build data.

    ]]
    getData = "function",
    --[[

      Function to check if a component exists.

      @arg _addr (string) : The address of the component to check.

      @return (boolean) If the component is attached.

    ]]
    exists = "function",
    --[[

      Function to proxy a component.

      @arg _addr (string) : The component to create a proxy for.

      @return (table) The proxy for the given component.

    ]]
    getProxy = "function",
    --[[

      Function to call on a component.

      @arg _addr (string) : The address to call a function on.

      @arg _func (string) : The function to call.

      @vararg (value) : The function arguments.

      @return (value) The return value of the function.

    ]]
    callFunc = "function",

  },

  computer = { --Definition for computer service

    --[[

      Function to shut down the computer.

    ]]
    shutdown = "function",
    --[[

      Function to restart the computer.

    ]]
    restart = "function",
    --[[

      Function to make the computer make a sound.

      @arg _pitch (number) : The pitch to play.
      @arg _duration (number) : The duration of the beep.

    ]]
    beep = "function",
    --[[

      Function to get the total memory available to the computer.

      @return (number) The memory available to the computer.

    ]]
    getTotalMemory = "function",
    --[[

      Function to get the total amount of free memory available to the computer.

      @return (number) The free memory available to the computer.

    ]]
    freeMemory = "function",
    --[[

      Function to get the architecture of the cpu.

      @return (string) The architecture of the cpu.

    ]]
    getArchitecture = "function",
    --[[

      Function to set the architecture of the cpu.

      @arg _arch (string) : The architacture to set.

    ]]
    setArchitecture = "function",
    --[[

      Function to get all available architectures.

      @return (table) A numbered table of all architectures.

    ]]
    getArchitectures = "function",
    --[[

      Function to get the time the computer has been on at a time.

      @return (number) The current uptime of the conmputer.

    ]]
    getUptime = "function",
    --[[

      Function to push a signal into the system.

      @arg _name (string) : The name of the signal to push.

      @vararg (basic value) : Values to be attached to the signal.

    ]]
    pushSignal = "function",
    --[[

      Function to pull signals from the signal queue.

      @arg _timeout (number) : The timeout in seconds, if it is nil the function waits forever,

      @return (string, basic values) It first return the name of the signall pulled from the queue and then any arguments attqached to it.

    ]]
    pullSignal = "function",
    --[[

      Function for getting the energy stored in the computer.

      @return (number) The amount of energy currently stored.

    ]]
    getEnergy = "function",
    --[[

      Function for getting the maximal energy stored in the computer.

      @return (number) The maximal energy stored in the computer.

    ]]
    getMaxEnergy = "function",
    --[[

      Function for getting the address of the temporary file system.

      @return (string) The component address of a temporary file system.

    ]]
    getTempAddress = "function",

  },

  users = {

    getUsers = "function",
    addUsers = "function",
    removeUsers = "function",
    hasUsers = "function"

  },

  tutos = {

    getDate = "function",
    getClock = "function",
    difftime = "function",
    getTime = "function",
    setEnvVar = "function",
    getEnvVar = "function",
    envVars = "table",

  }

}

local defaultServicePath = "/boot/kernel/" --Convenience variable for the path to the default service implementations.

local services = {} --A table of all services.

--[[

  Function for loading and checking a service.

  @arg _path (string) : The path to the file lo load, has to be on the boot system.
  @arg _type (string / table) : The type of the service to load either as the string name or the definition table.

  @return (table / nil, string) Either the service table or nil and the error message.

]]
local function loadService(_path, _type)

if type(_type) == "string" and serviceTypes[_type] ~= nil then --Test if the type is a name or a definition table.

    _type = serviceTypes[_type] --If it is a name set it to a definition table.

  end

  if type(_type) ~= "table" then return nil, "Arg #2 has to be a string or a table" end --If _type is wrong, error.

  local loaded, err = dofile(_path) --Load the file.

  if err then return nil, err end --If loading failed error.

  if type(loaded) ~= "table" then return nil, "Modules have to be a table, but was a "..type(loaded) end --If the return type of the file isn't a table, error.

  --[[

    Check if ever value in the table has the right type.

  ]]
  for k, v in pairs(_type) do

    if type(loaded[k]) ~= v then return nil, "Module part "..k.." is "..type(loaded[k]).." instead of "..v end --If not, error.

  end

  return loaded

end

--Load service locations

--[[

  Load all not yet loaded services from the standard implementations.

]]
for k, v in pairs(serviceTypes) do

  if not services[k] then --If no service has been laoded for this.

    services[k], err = loadService(defaultServicePath..k..".lua", k) --Load the standard service.

    if not services[k] then --If it failed, error.

      error("Failed to load default service \""..k.."\": "..tostring(err))

    end

    status("Loaded service \""..k.."\" from "..defaultServicePath..k..".lua", "info") --Output that it worked.

  end

end

_G.getService = function(_type) --Global function to load services.

  return services[_type]

end

_G.services = setmetatable({}, { --Global table for syntactic sugar access.

  __index = function(_table, _key) --Index meta method

    return _G.getService(_key) --Get service of the given name.
    
  end

})

return nil
