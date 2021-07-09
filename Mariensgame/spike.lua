local spike = {img = love.graphics.newImage("assets/spike/spike.png")}
spike.__index = spike
spike.width = spike.img:getWidth()
spike.height = spike.img:getHeight()
local activespikes = {}
local player = require("player")

function spike.new(x,y)
  local instance = setmetatable({}, spike)
  instance.x = x
  instance.y = y
  instance.physics = {}
  instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "static")
  instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
  instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
  instance.physics.fixture:setSensor(true)
  table.insert(activespikes, instance)
end

function spike:update(dt)

end

function spike:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, 1, 1, self.width / 2, self.height / 2)
end

function spike.updateall(dt)
  for i,instance in ipairs(activespikes) do
    instance:update(dt)
  end
end

function spike.drawall()
  for i,instance in ipairs(activespikes) do
    instance:draw()
  end
end

function spike.beginContact(a, b, collision)
  for i,instance in ipairs(activespikes) do
    if a == instance.physics.fixture or b == instance.physics.fixture then
       if a == player.physics.fixture or b == player.physics.fixture then
          player:damage(1)
          return true
       end
    end
  end
end

return spike
