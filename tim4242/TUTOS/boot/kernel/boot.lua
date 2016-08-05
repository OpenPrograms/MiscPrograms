do


  --I really don't like this function just laying around, therefore I have to destroy it
  _G.boot_invoke = nil --(Literally the first line I wrote)

  --[[OS_DATA SETUP]]

  _G.OS_DATA = {}

  _G.OS_DATA.NAME = "TUTOS" --Name / identification
  _G.OS_DATA.VERSION = "0.0.3-\"KOMMENTARE\"" --Printable version
  _G.OS_DATA.FULL_WRITE = _G.OS_DATA.NAME.." ".._G.OS_DATA.VERSION --Full writable name / version string

  _G.OS_DATA.VERSION_COMP = 002 --Comparable version

  --[[OUTPUT SETUP]]

  --Setting up the main screen
  local screen = component.list("screen", true)() --One screen if no screen has a keyboard

  for addr in component.list("screen", true) do --Iterate over all available screens

    if #component.invoke(addr, "getKeyboards") > 0 then --If it has at least one keyboard...

      screen = addr --...Set it as main screen

      break

    end

  end

  local gpu = component.list("gpu", true)() --Get the first gpu

  for addr in component.list("gpu") do

    if component.invoke(addr, "maxResolution") > component.invoke(gpu, "maxResolution") then --If the gpu has a bigger resolution...

      gpu = addr --...Set it as main gpu

    end

  end

  local w, h --Convenient variables

  if gpu and screen then --If the system has a gpu and a screen

    component.invoke(gpu, "bind", screen) --Bind the gpu to the screen
    w, h = component.invoke(gpu, "maxResolution") --Getting the maximal resolution of the current gpu
    component.invoke(gpu, "setResolution", w, h) --Maximise the resolution
    component.invoke(gpu, "setBackground", 0x000000) --Set background color to black
    component.invoke(gpu, "setForeground", 0xFFFFFF) --Set foreground (text) color to white
    component.invoke(gpu, "fill", 1, 1, w, h, " ") --Clear the screen / gpu buffer

  end

  local y = 1 --Variable to keep track of the current offset

  --[[

    Convenience function to log boot progress.

    @arg _msg : The message to display
    @arg _type : The type of the message. Can be one of the following
                 - "nothing": Prints no prefix and in white
                 - "info" (standard): Sets the prefix to "[INFO]" and the text to white
                 - "error": Sets the prefix to "[ERROR]" and the text to read
                 - "success": Sets the prefix to "[OK]" and the text to green

  ]]
  function status(_msg, _type)

    if gpu and screen then

      if _type == "error" then --When the type is error

        _msg = "[ERROR] "..tostring(_msg) --Set the prefix to "[ERROR]"
        component.invoke(gpu, "setForeground", 0xFF0000) --Set the color to red

      elseif _type == "success" then --When the type is sucess

        _msg = "[OK] "..tostring(_msg) --Set the prefix to "[OK]"
        component.invoke(gpu, "setForeground", 0x00FF00) --Set the color to green

      elseif _type == "nothing" then --When the type is nothing

        component.invoke(gpu, "setForeground", 0xFFFFFF) --Set the color to white

      else --Otherwise ("info" or no value)

        _msg = "[INFO] "..tostring(_msg) --Set the prefix to "[INFO]"
        component.invoke(gpu, "setForeground", 0xFFFFFF) --Set the color to white

      end

        component.invoke(gpu, "set", 1, y, tostring(_msg)) --Write the text on screen
        component.invoke(gpu, "setForeground", 0xFFFFFF) --Reset text color

      if y == h then --If the offset has reached the screen height

        component.invoke(gpu, "copy", 1, 2, w, h - 1, 0, -1) --Move the screen content up by one
        component.invoke(gpu, "fill", 1, h, w, 1, " ") --Clear last line

      else

        y = y + 1 --Add one to the offset

      end

    end

  end

  --[[FILE LOADING]]

  local bootAddr = component.invoke(component.list("eeprom")(), "getData") --Convenience variable containing the address of the boot filesystem


  --[[

    Low level dofile implementation (executes a file).
    Automatically outputs log messages.

    @arg _path : The path to the file to execute, has to be on the boot file system.

    @return The loaded chunk of nil with the error

  ]]
  function dofile(_path)

    if not component.invoke(bootAddr, "exists", _path) then --If the file doesn't exist

      status("File ".._path.." doesn't exist", "error") --Output that the file doesn't exist
      return nil, "File ".._path.." not found" --Return nil and the error

    end

    local data, err = loadfile(bootAddr, _path) --Load the file or get errors in the file

    if data == nil then --If an error occured

      status(err, "error") --Output the error
      return nil, err --Return nil and the error

    end

    status("Loaded file: ".._path, "success") --Output taht the file was loaded

    local stat, err = pcall(data) --Execute the loaded chunk

    if not stat then --If an error occured

      status(err, "error") --Output the error
      return nil, err --Return nil and the error

    end

    status("Executed file: ".._path, "success") --Output that the execution was successful

    return err, nil --Return the chunks return value (and nil for the error)

  end

  --Output the name and version of the OS boxed in
  status("+"..string.rep("-", OS_DATA.FULL_WRITE:len()).."+", "nothing")
  status("|"..OS_DATA.FULL_WRITE.."|", "nothing")
  status("+"..string.rep("-", OS_DATA.FULL_WRITE:len()).."+", "nothing")
  status("", "nothing")

  status("Loading system services") --Output that the system is now loading the services

  local _, err = dofile("/boot/kernel/services.lua") --Execute the service loader

  if err then error("Failed to load service.lua: "..tostring(err)) end --If an error occured: Output it

  local env_func, err = loadfile(bootAddr, "/boot/kernel/env_setup.lua") --Load env_setup.lua (needs better name)

  if not env_func then error("Error loading env_setup.lua: "..tostring(err)) end --If an error occured: Output it

  status("Loaded env_setup.lua", "success") --Output that the file was loaded successful

  local stat, env_set = pcall(env_func) --Set up the enviroment by executing env_setup.lua (needs better name)

  if not stat then error("Error setting up enviroment: "..env_set) end --If an error occured during execution: Output it

  --[[TESTS]]

  while true do --Keep the screen alive

    coroutine.yield()
    services.computer.shutdown()

  end

end
