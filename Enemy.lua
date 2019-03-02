Enemy = {}

Enemy.new = function()
  local self = {}
  self.img = love.graphics.newImage("assets/imgs/enemy.png")
  self.x = love.math.random(game.WW)
  self.y = love.math.random(game.WH)
  self.oof = 1
  self.oof2 = 1
  self.xv = love.math.random(300)
  self.yv = love.math.random(300)

  self.draw = function()
    love.graphics.draw(self.img, self.x, self.y, 0, game.scale, game.scale)
  end

  self.update = function(dt)
    self.x = self.x + self.xv * self.oof * dt
    self.y = self.y + self.yv * self.oof2 * dt

    if self.x < 0 then
      self.oof = 1
    end

    if self.x + self.img:getWidth() * game.scale > game.WW then
      self.oof = -1
    end

    if self.y < 0 then
      self.oof2 = 1
    end

    if self.y + self.img:getHeight() * game.scale > game.WH then
      self.oof2 = -1
    end

    if self.x + self.img:getWidth() * game.scale > game.playerx and self.x < game.playerx + game.playerimg:getWidth() * game.scale and self.y + self.img:getWidth() * game.scale > game.playery and self.y < game.playery + game.playerimg:getWidth() * game.scale and game.playing then
      game.playing = false
      sound = love.audio.newSource("assets/music/lost.wav", "stream")
      love.audio.play(sound)
    end
  end

  return self
end
