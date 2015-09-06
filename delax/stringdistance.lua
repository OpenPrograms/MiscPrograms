local math=require("math")
local string=require("unicode")

-- Levenshtein distance between two strings
-- aka number of insertions, deletions, or
-- substitutions required to change one word
-- to another
function lev(str1, str2)
  -- short circuit cases
  if str1==str2 then return 0 end
  if #str1==0 then return #str2 end
  if #str2==0 then return #str1 end

  local v0 = {}
  local v1 = {}

  -- initialize v0
  -- this row is d[0][j]
  for j=0,#str2 do v0[j] = j end

  for i=1,#str1 do
    -- calculate v1 (current row distances) from
    -- the previous row v0

    -- first element of v1 is d[i+1][0]
    v1[0] = i

    -- use formula to fill rest of row
    for j=1,#str2 do
      local cost
      if string.sub(str1,i,i)==string.sub(str2,j,j) then
        cost=0
      else
        cost=1
      end
      v1[j] = math.min(
        v1[j-1] + 1,
        v0[j] + 1,
        v0[j-1] + cost
        )
    end
    
    -- copy v1 to v0 for next iteration
    for j=0,#v0-1 do v0[j] = v1[j] end
  end
  
  return v1[#str2]
end

-- Damerau-Levenshtein distance
-- aka the number of insertions,
-- substitutions, or transpositions
-- of adjacent characters need to transform
-- one string to another             
function dam(str1, str2)
  -- short circuit cases
  if str1==str2 then return 0 end
  if #str1==0 then return #str2 end
  if #str2==0 then return #str1 end

  local N = #str1
  local M = #str2
  local INF = N+M
  local d = {}
  local DS = {}

  d[0] = INF

  for i=0,N do
    d[N+2 + i+1] = i
    d[i+1] = INF
  end
  for j=0,M do
    d[(N+2)*(j+1) + 1] = j
    d[(N+2)*(j+1)] = INF
  end

  for i=1,N do
    local DT = 0
    for j=1,M do
      local cost 
      local i1 = DS[string.sub(str2,j,j)] or 0
      local j1 = DT
      if string.sub(str1,i,i)==string.sub(str2,j,j) then
        cost = 0
        DT = j
      else
        cost=1
      end

      d[(N+2)*(j+1) + i+1] = math.min(
        d[(N+2)*j +i] + cost,
        d[(N+2)*j + i+1] + 1,
        d[(N+2)*(j+1) + i] + 1,
        d[(N+2)*j1 + i1] + i-i1-1 + 1 + j-j1-1
        )
    end
    DS[string.sub(str1,i,i)] = i
  end

  return d[(N+2)*(M+1) + N+1]
end
