local event = require("event")
local interface = require("interface")
local screen = 1

function screen1()
    screen = 1
    interface.clearAllObjects()
    interface.newLabel("s1-1","Screen 1",1,1,8,3,0x00FF00)
    interface.newButton("s1-2","Screen 2",9,1,8,3,screen2,nil,0x00FF00,0x0000FF,1)
    interface.newBar("s1-3",1,5,10,2,0x00FF00,0xFF0000,50)
    interface.updateAll()
end

function screen2()
    screen = 2
    interface.clearAllObjects()
    interface.newButton("s2-1","Screen 1",1,1,8,3,screen1,nil,0x00FF00,0x0000FF,1)
    interface.newLabel("s2-2","Screen 2",9,1,8,3,0x00FF00)
    interface.updateAll()
end

screen1()

while true do
    local _,_,x,y = event.pull("touch")
    interface.processClick(x,y)
    if screen == 1 then
        
    end
end