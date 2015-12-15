local streams = {}

local fs = require("filesystem");

local _stdout = io.stdout
local _stdin = io.stdin
local _stderr = io.stderr

local function makeDefaultStream()

    local res = {}

    res.write = function(self, ...)end
    res.read = function(self, ...)end
    res.setvbuf = function(self, ...)end
    res.flush = function(self, ...)end
    res.seek = function(self, ...)end
    res.close = function(self, ...)end

    return res

end

local function makePartnerStreams()

    local resI, resO = makeDefaultStream(), makeDefaultStream()

    resI.partner = resO

    resI.bufPos = 0

    resI.buffer = ""

    resI._readS = function(self, _end)

      _end = _end or 1

      local res = self.buffer:sub(self.bufPos, self.bufPos + _end)

      self.bufPos = self.bufPos + _end

      return res

    end

    resI.read = function(self, ...)

      local vargs = {...}

      vargs[1] = vargs[1] or ""

      for form in ipairs(vargs) do

        if form == "*n" then

          local val = nil

          local tmp = nil

          while true do

            local tmpS = self:_readS()

            if val == nil then

              tmp = tonumber(tmpS)

            else

              tmp = tonumber(val:cat(tmpS))

            end

            if tmp == nil then

              break

            else

              if val == nil then

                val = tmpS

              else

                val:cat(tmpS)

              end

            end

          end

          return tonumber(val)

        elseif form == "*a" then

          return self:_readS(#self.buffer)

        elseif tonumber(form) ~= nil then

          return self:_readS(tonumber(form))

        else

          local val = ""

          while true do

            local tmp = self:_readS()

            if tmp == "\n" then break else val:cat(tmp) end

          end

          return val

        end

      end

    end

    resI.seek = function(self, whence, offset)

      offset = offset or 0

      local pos = -1

      if whence == "set" then

        pos = 0

      elseif whence == "end" then

        pos = #self.buffer

      else

        pos = bufPos

      end

      pos = pos + offset

      if pos < 0 then pos = 0 elseif pos > #self.buffer then #self.buffer end

      self.bufPos = pos

      return self.bufPos

    end

    resI.flush = function(self)

      self.buffer = ""

    end

    resO.partner = resI

    resO.bufMode = 0

    resO.bufSize = 0

    resO.buffer = ""

    resO._writeToBufFullOrSig = function(self, _str, _signal)

      for i=1, #_str do

        if #self.buffer + 1 > self.bufSize then self.flush() end

        if _signal == _str:sub(i, i) then

          self.flush()

        else

          self.buffer = self.buffer.._str:sub(i, i)

        end

      end

    end

    resO.write = function(self, ...)

      if self.bufMode == 0 then

        for k, v in ipairs({...}) do

          self.partner.buffer = self.partner.buffer..tostring(v)

        end

      elseif self.bufMode == 1 then

        for k, v in ipairs({...}) do

          self._writeToBufFullOrSig(self, tostring(v))

        end

      elseif self.bufMode == 2 then

        for k, v in ipairs({...}) do

          self._writeToBufFullOrSig(self, tostring(v), '\n')

        end

      end

    end

    resO.setvbuf = function(self, _mode, _size)

      if _mode == "line" then

        self.bufMode = 2

        local len = tonumber(_size)

        if len == nil then self.bufLen = 128 else self.bufLen = len end

      elseif _mode == "full" then

        self.bufMode = 1

        local len = tonumber(_size)

        if len == nil then self.bufLen = 128 else self.bufLen = len end

      else

        self.bufMode = 0

      end

    end

    resO.flush = function(self)

      self.partner.buffer = self.partner.buffer..tostring(self.buffer)

      self.buffer = ""

    end

    return resI, resO

end

local function makeFileStreams(_file)

    local resI, resO = makeDefaultStream(), makeDefaultStream()

    resI.file = fs.open(_file, "r")

    resI.res

    return resI, resO

end

streams.streamFuncs = {

  "partners" = makePartnerStreams,
  "file" = makeFileStreams,
  "default" = makePartnerStreams

}

streams.mkStreams = function(self, ...)

    local vargs = {...}

    local i = 0

    local func = nil

    if type(vargs[1]) == "string" then

      i = 1

      func = self.streamFuncs[vargs[1]] or self.streamFuncs["default"]

    end

    local args = {}

    for j = 1, #vargs do args[j - i] = vargs[j] end

    return func(table.unpack(args))

end

return streams
