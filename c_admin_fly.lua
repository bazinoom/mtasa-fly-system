-- bazinoom.ir
addCommandHandler("fly", function(cmd)
    if exports.integration:isPlayerSupporter(localPlayer) or  exports.integration:isPlayerTrialAdmin(localPlayer) then
        toggleFly();
    end
end)


function playerPressedKey ( button, press ) 
    if ( button == "lshift" ) then 
        setElementData ( localPlayer, "lshift", press and true or false ); 
    end 
    if ( button == "f" and press ) then 
        local pressed = getElementData ( localPlayer, "lshift" ); 
        if ( pressed ) then 
            if exports.integration:isPlayerSupporter(localPlayer) or  exports.integration:isPlayerTrialAdmin(localPlayer) then
                toggleFly();
            end
        end 
    end 
end 
addEventHandler ( "onClientKey", root, playerPressedKey ); 


    
local flyingState = false
local keys = {}
keys.up = "up"
keys.down = "up"
keys.f = "up"
keys.b = "up"
keys.l = "up"
keys.r = "up"
keys.a = "up"
keys.s = "up"
keys.m = "up"
    
function toggleFly()
    flyingState = not flyingState   
    if flyingState then
        addEventHandler("onClientRender",getRootElement(),flyingRender, true, "low-5")
        bindKey("lshift","both",keyH)
        bindKey("rshift","both",keyH)
        bindKey("lctrl","both",keyH)
        bindKey("rctrl","both",keyH)
        
        bindKey("forwards","both",keyH)
        bindKey("backwards","both",keyH)
        bindKey("left","both",keyH)
        bindKey("right","both",keyH)
        
        bindKey("lalt","both",keyH)
        bindKey("space","both",keyH)
        bindKey("ralt","both",keyH)
        bindKey("mouse1","both",keyH)
        setElementCollisionsEnabled(getLocalPlayer(),false)
        setElementData(localPlayer, "keysDenied", true)
    else
        removeEventHandler("onClientRender",getRootElement(),flyingRender)
        unbindKey("mouse1","both",keyH)
        unbindKey("lshift","both",keyH)
        unbindKey("rshift","both",keyH)
        unbindKey("lctrl","both",keyH)
        unbindKey("rctrl","both",keyH)
        
        unbindKey("forwards","both",keyH)
        unbindKey("backwards","both",keyH)
        unbindKey("left","both",keyH)
        unbindKey("right","both",keyH)
        
        unbindKey("space","both",keyH)
        
        keys.up = "up"
        keys.down = "up"
        keys.f = "up"
        keys.b = "up"
        keys.l = "up"
        keys.r = "up"
        keys.a = "up"
        keys.s = "up"
        setElementCollisionsEnabled(getLocalPlayer(),true)
        setElementData(localPlayer, "keysDenied", false)
    end
end

function flyingRender()
    local x,y,z = getElementPosition(getLocalPlayer())
    local speed = 10
    if keys.a=="down" then
        speed = 3
    elseif keys.s=="down" then
        speed = 50
    elseif keys.m=="down" then
        speed = 300
    end
    
    if keys.f=="down" then
        local a = rotFromCam(0)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    elseif keys.b=="down" then
        local a = rotFromCam(180)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    end
    
    if keys.l=="down" then
        local a = rotFromCam(-90)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    elseif keys.r=="down" then
        local a = rotFromCam(90)
        setElementRotation(getLocalPlayer(),0,0,a)
        local ox,oy = dirMove(a)
        x = x + ox * 0.1 * speed
        y = y + oy * 0.1 * speed
    end
    
    if keys.up=="down" then
        z = z + 0.1*speed
    elseif keys.down=="down" then
        z = z - 0.1*speed
    end
    
    setElementPosition(getLocalPlayer(),x,y,z)
end

function keyH(key,state)
    if key=="lshift" or key=="rshift" then
        keys.s = state
    end 
    if key=="lctrl" or key=="rctrl" then
        keys.down = state
    end 
    if key=="forwards" then
        keys.f = state
    end 
    if key=="backwards" then
        keys.b = state
    end 
    if key=="left" then
        keys.l = state
    end 
    if key=="right" then
        keys.r = state
    end 
    if key=="lalt" or key=="ralt" then
        keys.a = state
    end 
    if key=="space" then
        keys.up = state
    end 
    if key=="mouse1" then
        keys.m = state
    end 
end

function rotFromCam(rzOffset)
    local cx,cy,_,fx,fy = getCameraMatrix(getLocalPlayer())
    local deltaY,deltaX = fy-cy,fx-cx
    local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
    if deltaY >= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    elseif deltaY <= 0 and deltaX <= 0 then
        rotZ = rotZ+180
    end
    return -rotZ+90 + rzOffset
end

function dirMove(a)
    local x = math.sin(math.rad(a))
    local y = math.cos(math.rad(a))
    return x,y
end
