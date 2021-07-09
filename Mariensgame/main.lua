local STI = require("sti") -- Simple Tile Implementation(STI) to load the map in löve2d.
love.graphics.setDefaultFilter("nearest","nearest")
local player = require("player")
local coin = require("coin")
local gui = require("gui")
local spike = require("spike")
local camera = require("camera")

function love.load()
  map = STI("map/1.lua", {"box2d"})
  world = love.physics.newWorld(0,0)  -- world x,y velocity = 0
  world:setCallbacks(beginContact, endContact)
  map:box2d_init(world) -- to load colidables from map
  map.layers.solid.visible = false  -- when true you will see the colidables in white
  map.layers.entity.visible = false
  mapwidth = map.layers.ground.width * 16 -- get map with from tiled in pixels, tilesize = 16
  background = love.graphics.newImage("assets/background1.png")
  player:load()
  gui:load()
  spawnEntities()
end

-- update in deltatime, the time it takes for 1 frame
function love.update(dt)
  world:update(dt)
  player:update(dt)
  coin.updateall(dt)
  gui:update(dt)
  spike:updateall(dt)
  camera:setposition(player.x, 0)
end


function love.draw()
  love.graphics.draw(background)
  map:draw(-camera.x,-camera.y,2,2)   -- map scaled by 2
  camera:apply()
  player:draw()
  coin.drawall()
  spike.drawall()
  camera:clear()
  gui:draw()
end

function beginContact(a, b, collision)
  if coin.beginContact(a, b, collision) == true then
    return
  end
  if spike.beginContact(a, b, collision) == true then
    return
  end
  player:beginContact(a, b, collision)
end

function endContact(a, b, collision)
  player:endContact(a, b, collision)
end

function love.keypressed(key)
  player:jump(key)
end

function spawnEntities()
  for i,v in ipairs(map.layers.entity.objects) do
    if v.type == "spike" then
      spike.new(v.x + v.width / 2, v.y + v.height / 2) -- rectangle origin point is top left
    elseif v.type == "coin" then
      coin.new(v.x, v.y) -- circle origin point is center
    end
  end
end
