local player = {}

function player:load()
  -- setting the location, measurements and speed for the player
  self.x = 50
  self.y = 298
  self.startX = self.x
  self.startY = self.y
  self.width = 22
  self.height = 40
  self.xVelocity = 0
  self.yVelocity = 0
  self.maxSpeedRun = 180
  self.maxSpeedWalk = 100
  self.acceleration = 4000
  self.resistance = 3000
  self.gravity = 1000
  self.grounded = false
  self.jumpAmount = -400
  self.doubleJumpAmount = -300
  self.doubleJump = true  -- if true you can doublejump
  self.jumpTimer = 0  -- the extra time to jump when walked off a ledge.
  self.jumpTimerReset = 0.1
  self.direction = "right"
  self.state = "idle"
  self.coins = 0
  self.health = {current = 3, max = 3}
  self.alive = true

  self:loadAssets()
  -- using the love physics table to create a physics body for the player
  self.physics = {}
  self.physics.body = love.physics.newBody(world, self.x, self.y, "dynamic")
  self.physics.body:setFixedRotation(true) -- makes the player not rotate.

  -- making the physics rectangle(body) for the player and connect it with the actual body
  self.physics.shape = love.physics.newRectangleShape(self.width, self.height)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape)
end

function player:loadAssets()
  self.animation = {timer = 0, rate = 0.1}

  self.animation.idle = {total = 8, current = 1, img = {}}
  for i=1,self.animation.idle.total do
    self.animation.idle.img[i] = love.graphics.newImage("assets/player/idle/idle"..i..".png")
  end

  self.animation.run = {total = 4, current = 1, img = {}}
  for i=1,self.animation.run.total do
    self.animation.run.img[i] = love.graphics.newImage("assets/player/run/run"..i..".png")
  end

  self.animation.air = {total = 2, current = 1, img = {}}
  for i=1,self.animation.air.total do
    self.animation.air.img[i] = love.graphics.newImage("assets/player/air/air"..i..".png")
  end

  self.animation.walk = {total = 4, current = 1, img = {}}
  for i=1,self.animation.walk.total do
    self.animation.walk.img[i] = love.graphics.newImage("assets/player/walk/walk"..i..".png")
  end

  self.animation.duck = {total = 1, current = 1, img = {}}
  for i=1,self.animation.duck.total do
    self.animation.duck.img[i] = love.graphics.newImage("assets/player/duck/duck"..i..".png")
  end

  self.animation.draw = self.animation.idle.img[1]
  self.animation.width = self.animation.draw:getWidth()
  self.animation.height = self.animation.draw:getHeight()
end

function player:update(dt)
  self:respawn()
  self:animate(dt)
  self:setState()
  self:setDirection()
  self:decreaseJumpTimer(dt)
  self:syncPhysics()
  self:move(dt)
  self:applyGravity(dt)
end

function player:animate(dt)
  self.animation.timer = self.animation.timer + dt
  if self.animation.timer > self.animation.rate then
    self.animation.timer = 0
    self:setNewFrame()
  end
end

function player:setNewFrame()
  anim = self.animation[self.state]
  if anim.current < anim.total then
    anim.current = anim.current + 1
  else
    anim.current = 1
  end
  self.animation.draw = anim.img[anim.current]
end

function player:setDirection()
  if self.xVelocity > 0 then
    self.direction = "right"
  elseif self.xVelocity < 0 then
    self.direction = "left"
  end
end

function player:setState()
  if self.grounded == false then
    self.state = "air"
  elseif love.keyboard.isDown("down", "s") then
    self.state = "duck"
    self.xVelocity = 0
  elseif self.xVelocity == 0 then
    self.state = "idle"
  elseif self.xVelocity > self.maxSpeedWalk or self.xVelocity < -self.maxSpeedWalk then
    self.state = "run"
  else
    self.state = "walk"
  end
  --print(self.state)
end

function player:move(dt)
  if love.keyboard.isDown("lshift", "rshift") and love.keyboard.isDown("left", "a") then
    self.xVelocity = math.max(self.xVelocity - self.acceleration * dt, -self.maxSpeedRun)
  elseif love.keyboard.isDown("lshift", "rshift") and love.keyboard.isDown("right", "d") then
    self.xVelocity = math.min(self.xVelocity + self.acceleration * dt, self.maxSpeedRun)
  elseif love.keyboard.isDown("left", "a") then
    self.xVelocity = math.max(self.xVelocity - self.acceleration * dt, -self.maxSpeedWalk)
  elseif love.keyboard.isDown("right", "d") then
    self.xVelocity = math.min(self.xVelocity + self.acceleration * dt, self.maxSpeedWalk)
  else
    self:applyResistance(dt)
  end
end

function player:applyResistance(dt) -- makes the player slow down
  if self.xVelocity > 0 then
    self.xVelocity = math.max(self.xVelocity - self.resistance * dt, 0)
  elseif self.xVelocity < 0 then
    self.xVelocity = math.min(self.xVelocity + self.resistance * dt, 0)
  end
end

function player:syncPhysics()
  self.x, self.y = self.physics.body:getPosition()
  self.physics.body:setLinearVelocity(self.xVelocity, self.yVelocity)
end

function player:applyGravity(dt)
  if self.grounded == false then
    self.yVelocity = self.yVelocity + self.gravity * dt
  end
end

function player:beginContact(a, b, collision)
  if self.grounded == false then
    local nx, ny = collision:getNormal()
    if a == self.physics.fixture then
      if ny > 0 then
        self:land(collision)
      elseif ny < 0 then
        self.yVelocity = 0
      end
    elseif b == self.physics.fixture then
      if ny < 0 then
        self:land(collision)
      elseif ny > 0 then
        self.yVelocity = 0
      end
    end
  else
    return
  end
end

function player:endContact(a, b, collision)
  if a == self.physics.fixture or b == self.physics.fixture then
    if self.groundcontact == collision then
      self.grounded = false
    end
  end
end

function player:jump(key)
  if (key == "up" or key == "w") then
    if self.grounded or self.jumpTimer > 0 then
      self.yVelocity = self.jumpAmount
      self.grounded = false
      self.jumpTimer = 0
    elseif self.doubleJump == true then
      self.yVelocity = self.doubleJumpAmount
      self.doubleJump = false
    end
  end
end

function player:land(collision)
  self.groundcontact = collision
  self.yVelocity = 0
  self.grounded = true
  self.doubleJump = true
  self.jumpTimer = self.jumpTimerReset
end

function player:decreaseJumpTimer(dt)
  if self.grounded == false then
    self.jumpTimer = self.jumpTimer - dt
  end
end

function player:pickCoins()
  self.coins = self.coins + 1
end

function player:damage(hit)
  if self.health.current - hit > 0 then
    self.health.current = self.health.current - hit
  else
    self.health.current = 0
    self.alive = false
    print("you died")
  end
end

function player:respawn()
  if self.alive == false then
    self.physics.body:setPosition(self.startX, self.startY)
    self.health.current = self.health.max
    self.coins = 0
    self.alive = true
  end
end

function player:draw()
  scaleX = 0.7
  scaleY = 0.7
  if self.direction == "right" then
    scaleX = -0.7
  end
  if self.state == "duck" then
    self.y = self.y + 19
  elseif self.state == "run" then
    self.y = self.y + 3
  end
  love.graphics.draw(self.animation.draw, self.x, self.y, 0, scaleX, scaleY,
  self.animation.width / 2, self.animation.height / 2)
end

return player
