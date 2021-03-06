state=require("lib.stateswitcher")
state.clear()
bump = require 'lib.bump'
world = bump.newWorld(64)
print('loading game...')
local transform = love.math.newTransform()
local Concord = require("lib").init({
    useEvents = false
})

Component = require("src.components")
System = require("src.systems")
Entity = require("src.entities") --for reusable entities
DynEnt = Concord.entity

--- Customize Below ---
-- Declare Instnace (Menu, Level, etc)
Game = Concord.instance() --this world

KEYS = {}

ground = {
    name="ground",
    mode = "line",
    x = 0,
    y = love.graphics.getHeight()-love.graphics.getHeight()/10,
    w =  love.graphics.getWidth()*10,
    h =  love.graphics.getHeight()/10,
    rx = nil,
    ry = nil,
    seg = nil 
}


Game:addSystem(System.CameraController(), "update")
Game:addSystem(System.CameraController(), "draw")
Game:addSystem(System.PlayerManager(), "draw")
Game:addSystem(System.PlayerManager(), "update")
Game:addSystem(System.PlayerController(), "update")
Game:addSystem(System.ProjectileController(), "update")
Game:addSystem(System.ProjectileController(), "draw")
Game:addSystem(System.PlayerController(), "keypressed")
Game:addSystem(System.PlayerController(), "mousepressed")
Game:addSystem(System.Gravity(), "update")


world:add(ground,ground.x,ground.y,ground.w,ground.h)

function love.load()


    


end


function love.update(dt)
    Game:emit("update",dt)
end

function love.draw()
    --love.graphics.applyTransform(transform)
    Game:emit("draw")
    draw_rec(ground)
    
end

function love.mousepressed(x,y,button,istouch,presses)
   Game:emit("mousepressed", x,y,button,istouch,presses)
end

function instantiatePlayer(x,y,sprite_file_name)
    local p
    --Add the player
    p = DynEnt() -- need a way to add this dynamically... a spawn sytem?
    -- Assin Components
    p:give(Component.Player,"Charzi",100,100,true)
        :give(Component.Position, x,y,0,0,10,10)
        :give(Component.Sprite, sprite_file_name )
        :give(Component.Bindings)
        :give(Component.Gravity, 10)
        :apply()
    local c = p[Component.Sprite]
    world:add(p,x,y,c.w,c.h)
    Game:addEntity(p)
    return p
end


function love.keypressed(key)
    if(key == 'p') then
        Player = instantiatePlayer(100,100,"src/imgs/default.png")
    else
        --add to keys table
        table.insert(KEYS,key)
    end
    Game:emit("keypressed",key)
end


function love.keyreleased(key)
    if(key == 'escape') then
     state.switch("src/states/main_menu")
    end
    for i=1, #KEYS do
        if(KEYS[i]==key) then
            table.remove(KEYS,i)
            break
        end
    end
    
end

function draw_rec(t)
    love.graphics.rectangle( t.mode or "line", t.x, t.y, t.w, t.h, t.rx or 0, t.ry or 0, t.seg or 0 )
end

print('game.lua loaded')