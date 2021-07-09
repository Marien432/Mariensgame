local coin = {img = love.graphics.newImage("assets/coin/coin.png")}
coin.__index = coin
coin.width = coin.img:getWidth()
coin.height = coin.img:getHeight()
local activecoins = {}
local player = require("player")

function coin.new(x,y)
  local instance = setmetatable({}, coin)
  instance.x = x
  instance.y = y
  instance.randomTimeOffset = math.random(0, 50)
  instance.scaleX = 0.7
  instance.toRemove = false
  instance.physics = {}
  instance.physics.body = love.physics.newBody(world, instance.x, instance.y, "static")
  instance.physics.shape = love.physics.newRectangleShape(instance.width, instance.height)
  instance.physics.fixture = love.physics.newFixture(instance.physics.body, instance.physics.shape)
  instance.physics.fixture:setSensor(true)
  table.insert(activecoins, instance)
end

function coin:update(dt)
  self:spin(dt)
  self:checkRemove()
end

function coin:draw()
  love.graphics.draw(self.img, self.x, self.y, 0, self.scaleX, 0.7, self.width/2, self.height/2)
end

function coin.drawall()
  -- loop through each coin inside activecoins table and draw each coin
  for i,instance in ipairs(activecoins) do
    instance:draw()
  end
end

function coin.updateall(dt)
  for i,instance in ipairs(activecoins) do
    instance:update(dt)
  end
end

function coin:spin(dt)
   self.scaleX = math.sin(love.timer.getTime() *2 + self.randomTimeOffset)/1.4
   --print(self.scaleX)
end

function coin.beginContact(a, b, collision)
  for i,instance in ipairs(activecoins) do
    -- loop to keep checking if object a or b is a coin and if the other object is the player
    -- if both are true then there is a collision with a coin
    if a == instance.physics.fixture or b == instance.physics.fixture then
      if a == player.physics.fixture or b == player.physics.fixture then
        instance.toRemove = true
        return true
      end
    end
  end
end

function coin:checkRemove()
  if self.toRemove == true then
    self:removeCoin()
  end
end

function coin:removeCoin()
  for i,instance in ipairs(activecoins) do
    if instance == self then -- the coin that called this function
      self.physics.body:destroy()
      table.remove(activecoins, i)
      player:pickCoins()
      --print("coins: "..player.coins)
      --player:damage(1)
    end
  end
end

return coin
