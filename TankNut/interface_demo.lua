local event = require("event")
local interface = require("interface")
local screen = 1
local rand = 0

function screen1()
    screen = 1
    interface.clearAllObjects()
    interface.newLabel("s1-1","Screen 1",1,1,8,3,0x00FF00)
    interface.newButton("s1-2","Screen 2",9,1,8,3,screen2,nil,0x00FF00,0x0000FF,1)
    interface.newLabel("s1-3","Bar example",1,5,13,3,0x000000)
    interface.newBar("s1-4",14,5,20,3,0x00FF00,0xFF0000,rand)
    interface.newLabel("s1-5","Amount: "..rand,34,5,13,3,0x0000FF)
    interface.updateAll()
end

function screen2()
    screen = 2
    interface.clearAllObjects()
    interface.newButton("s2-1","Screen 1",1,1,8,3,screen1,nil,0x00FF00,0x0000FF,1)
    interface.newLabel("s2-2","Screen 2",9,1,8,3,0x00FF00)
    interface.newLabel("s2-3","Multiple lines aren't supported for now,",2,5,40,1,0x0000FF)
    interface.newLabel("s2-4","But you can always do this.",2,6,40,1,0x0000FF)
    interface.updateAll()
end

screen1()

while true do
    local _,_,x,y = event.pull(1,"touch")
    if x and y then
        interface.processClick(x,y)
    end
    rand = math.random(1,100)
    if screen == 1 then
        interface.setBarValue("s1-4",rand)
        interface.setLabelText("s1-5","Amount: "..rand)
    end
end