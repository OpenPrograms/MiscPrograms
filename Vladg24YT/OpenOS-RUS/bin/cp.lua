local shell = require("shell")
local transfer = require("tools/transfer")

local args, options = shell.parse(...)
options.h = options.h or options.help
if #args < 2 or options.h then
  io.write([[Использование: cp [ОПЦИИ] <из...> <в>
 -i: prompt перед перезаписыванием (пр=ереопределяет -n опцию).
 -n: не переписывать существующий файл.
 -r: скопировать директории recursively.
 -u: скопировать только когда ИСХОДНЫЙ файл отличается от конечного файла
     или когда конечный файл отсутствует.
 -P: preserve аттрибуты, т.е. символические ссылки.
 -v: verbose вывод.
 -x: остаться на оригинальной исходной файловой системе.
 --skip=P: пропустить файлы совпадающие с lua regex P
]])
  return not not options.h
end

-- clean options for copy (as opposed to move)
options =
{
  cmd = "cp",
  i = options.i,
  n = options.n,
  r = options.r,
  u = options.u,
  P = options.P,
  v = options.v,
  x = options.x,
  skip = options.skip,
}

return transfer.batch(args, options)
