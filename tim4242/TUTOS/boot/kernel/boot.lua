do

  _G.boot_invoke = nil

  _G.OS_DATA = {}

  _G.OS_DATA.NAME = "TUTOS"
  _G.OS_DATA.VERSION = "0.0.1-\"booting up...\""
  _G.OS_DATA.FULL_WRITE = _G.OS_DATA.NAME.." ".._G.OS_DATA.VERSION

  _G.OS_DATA.VERSION_COMP = 001

  local screen = component.list('screen', true)()

  for address in component.list('screen', true) do

    if #component.invoke(address, 'getKeyboards') > 0 then

      screen = address

    end

  end

  local gpu = component.list("gpu", true)()

  local w, h

  if gpu and screen then

    component.invoke(gpu, "bind", screen)
    w, h = component.invoke(gpu, "getResolution")
    component.invoke(gpu, "setResolution", w, h)
    component.invoke(gpu, "setBackground", 0x000000)
    component.invoke(gpu, "setForeground", 0xFFFFFF)
    component.invoke(gpu, "fill", 1, 1, w, h, " ")

  end

  local y = 1

  function status(_msg, _type)

    if _type == "error" then

      _msg = "[ERROR] "..tostring(_msg)
      component.invoke(gpu, "setForeground", 0xFF0000)

    elseif _type == "success" then

      _msg = "[OK] "..tostring(_msg)
      component.invoke(gpu, "setForeground", 0x00FF00)

    elseif _type == "nothing" then

      component.invoke(gpu, "setForeground", 0xFFFFFF)

    else

      _msg = "[INFO] "..tostring(_msg)
      component.invoke(gpu, "setForeground", 0xFFFFFF)

    end

    if gpu and screen then

      component.invoke(gpu, "set", 1, y, tostring(_msg))
      component.invoke(gpu, "setForeground", 0xFFFFFF)

      if y == h then

        component.invoke(gpu, "copy", 1, 2, w, h - 1, 0, -1)
        component.invoke(gpu, "fill", 1, h, w, 1, " ")

      else

        y = y + 1

      end

    end

  end

  local bootAddr = component.invoke(component.list("eeprom")(), "getData")

  function dofile(_path)

    if not component.invoke(bootAddr, "exists", _path) then

      status("File ".._path.." doesn't exist", "error")
      return nil, "File ".._path.." not found"

    end

    local data, err = loadfile(bootAddr, _path)

    if data == nil then

      status(err, "error")
      return nil, err

    end

    status("Loaded file: ".._path, "success")

    local stat, err = pcall(data)

    if not stat then

      status(err, "error")
      return nil, err

    end

    status("Executed file: ".._path, "success")

    return err, nil

  end

  status("+"..string.rep("-", OS_DATA.FULL_WRITE:len()).."+", "nothing")
  status("|"..OS_DATA.FULL_WRITE.."|", "nothing")
  status("+"..string.rep("-", OS_DATA.FULL_WRITE:len()).."+", "nothing")
  status("", "nothing")

  local services, err = dofile("/boot/kernel/services.lua")

  if err then error("Failed to load service.lua: "..tostring(err)) end

  _G.component = nil
  --_G.computer = nil

  while true do

    coroutine.yield()
    computer.shutdown()

  end

end
