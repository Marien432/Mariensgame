local camera = { x = 0, y = 0, scale = 2 }

function camera:apply()
  love.graphics.push() -- everything between push and pop, under scale, will be scaled by 2
  love.graphics.scale(self.scale, self.scale)
  love.graphics.translate(-self.x, -self.y) -- when you want to move to the right, the world should go to the left
end

function camera:clear()
  love.graphics.pop()
end

function camera:setposition(x, y)
  self.x = x - love.graphics.getWidth() / 2 / self.scale  -- set to center of screen
  self.y = y

  if self.x < 0 then
    self.x = 0
  end

  if self.x + love.graphics.getWidth() / 2 > mapwidth then
    self.x = mapwidth - love.graphics.getWidth() / 2
  end
end

return camera
