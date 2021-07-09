local gui = {}
local player = require("player")

function gui:load()
  self.coins = {}
  self.coins.x = 30
  self.coins.y = 20
  self.coins.img = love.graphics.newImage("assets/coin/coin2.png")
  self.coins.width = self.coins.img:getWidth()
  self.coins.height = self.coins.img:getHeight()
  self.coins.scale = 1.8
  self.font = love.graphics.newFont(36)

  self.health = {}
  self.health.img = love.graphics.newImage("assets/player/health/health3.png")
  self.health.width = self.health.img:getWidth()
  self.health.height = self.health.img:getHeight()
  self.health.scale = 0.3
  self.health.x = (love.graphics.getWidth() / 2) - (self.health.img:getWidth() * self.health.scale / 2)
  self.health.y = 20

end

function gui:update(dt)
  self.health.img = love.graphics.newImage("assets/player/health/health"..player.health.current..".png")
end

function gui:draw()
  -- draw coin image
  love.graphics.setColor(0,0,0,0.5) -- make shadow with setColor
  love.graphics.draw(self.coins.img, self.coins.x + 2, self.coins.y + 2, 0,
  self.coins.scale, self.coins.scale)
  love.graphics.setColor(1,1,1,1)
  love.graphics.draw(self.coins.img, self.coins.x, self.coins.y, 0,
  self.coins.scale, self.coins.scale)

  -- draw coin count
  love.graphics.setFont(self.font)
  love.graphics.setColor(0,0,0,0.5)
  love.graphics.print(" : "..player.coins, self.coins.x + 2 + self.coins.width *
  self.coins.scale, self.coins.y + 2 + self.coins.height / 2 * self.coins.scale -
  self.font:getHeight()/2)
  love.graphics.setColor(1,1,1,1)
  love.graphics.print(" : "..player.coins, self.coins.x + self.coins.width *
  self.coins.scale, self.coins.y + self.coins.height / 2 * self.coins.scale -
  self.font:getHeight()/2)

  -- draw healthbar
  love.graphics.draw(self.health.img, self.health.x, self.health.y, 0 ,
  self.health.scale, self.health.scale)
end

return gui
