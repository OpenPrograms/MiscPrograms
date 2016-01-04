local users = {}

local native = {

  getUsers = computer.users,
  addUser = computer.addUser,
  removeUser = computer.removeUser,

}

users.getUsers = native.getUsers

users.addUsers = function(...)

  for k, v in pairs({...}) do

    native.addUser(v)

  end

end

users.removeUsers = function(...)

  for k, v in pairs({...}) do

    native.removeUser(v)

  end

end

users.hasUsers = function(...)

  for k, v in pairs({...}) do

    if users.getUsers()[v] == nil then return false end

  end

  return true

end

return users
