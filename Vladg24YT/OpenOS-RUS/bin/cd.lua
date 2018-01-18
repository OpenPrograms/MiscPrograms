local shell = require("shell")
local fs = require("filesystem")

local args, ops = shell.parse(...)
local path = nil
local verbose = false

if ops.help then
  print(
[[Использование cd [директроия]
Для большей информации, напишите: man cd]])
  return
end

if #args == 0 then
  local home = os.getenv("HOME")
  if not home then
    io.stderr:write("cd: HOME не установлен\n")
    return 1
  end
  path = home
elseif args[1] == '-' then
  verbose = true
  local oldpwd = os.getenv("OLDPWD");
  if not oldpwd then
    io.stderr:write("cd: OLDPWD не установлен\n")
    return 1
  end
  path = oldpwd
else
  path = args[1]
end

local resolved = shell.resolve(path)
if not fs.exists(resolved) then
  io.stderr:write("cd: ",path,": нет такого файла или директории\n")
  return 1
end

path = resolved
local oldpwd = shell.getWorkingDirectory()
local result, reason = shell.setWorkingDirectory(path)
if not result then
  io.stderr:write("cd: ", path, ": ", reason)
  return 1
else
  os.setenv("OLDPWD", oldpwd)
end
if verbose then
  os.execute("pwd")
end
