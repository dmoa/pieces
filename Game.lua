Game = {}

Game.new = function()
  local self = {}

  self.setBasics = function()
    love.graphics.setDefaultFilter("nearest", "nearest", 1)
    self.WW = love.graphics.getWidth()
    self.WH = love.graphics.getHeight()
    self.scale = 3
    require("gameData")
    require("Enemy")
    love.mouse.setVisible(false)
  end

  self.loadAssets = function()
    -- i rushed this and realised i could have made a piece class, oh well
    self.alphabet = getAlphabetData()
    self.playing = false
    self.playerimg = love.graphics.newImage("assets/imgs/playerBroken.png")
    self.playerxv = 400
    self.playeryv = 400
    self.piece1 = love.graphics.newImage("assets/imgs/piece1.png")
    self.px = 100
    self.py = 400
    self.pvisible = true
    self.piece2 = love.graphics.newImage("assets/imgs/piece2.png")
    self.p2x = 650
    self.p2y = 550
    self.pvisible2 = true
    self.piece3 = love.graphics.newImage("assets/imgs/piece3.png")
    self.p3x = 350
    self.pvisible3 = true
    self.p3y = 100
    self.won = false
    self.enemies = {}
    for i = 1, 25 do
      table.insert(self.enemies, Enemy.new())
    end
  end

  self.draw = function()
    if self.playing then
      love.graphics.draw(self.playerimg, self.playerx, self.playery, 0, self.scale, self.scale)
      if self.pvisible then
        love.graphics.draw(self.piece1, self.px, self.py, 0, self.scale, self.scale)
      else
        love.graphics.draw(self.piece1, self.playerx, self.playery, 0, self.scale, self.scale)
      end
      if self.pvisible2 then
        love.graphics.draw(self.piece2, self.p2x, self.p2y, 0, self.scale, self.scale)
      else
        love.graphics.draw(self.piece2, self.playerx, self.playery, 0, self.scale, self.scale)
      end
      if self.pvisible3 then
        love.graphics.draw(self.piece3, self.p3x, self.p3y, 0, self.scale, self.scale)
      else
        love.graphics.draw(self.piece3, self.playerx, self.playery, 0, self.scale, self.scale)
      end
      for i = 1, 25 do
        self.enemies[i].draw()
      end
    else
      if self.won then
        self.drawText("you won", self.WW / 2, 150, true)
      else
        self.drawText("pieces", self.WW / 2, 0, true)
        self.drawText("space to start", self.WW / 2, 150, true)
        self.drawText("wasd to move", self.WW / 2, 250, true)
        self.drawText("collect pieces", self.WW / 2, 350, true)
      end
      self.drawText("by dmoa", self.WW / 2, 550, true)
    end
  end

  self.update = function(dt)
    if self.playing then
      if love.keyboard.isDown("a") and self.playerx > 0 then
        self.playerx = self.playerx - self.playerxv * dt
      end
      if love.keyboard.isDown("d") and self.playerx + self.playerimg:getWidth() * self.scale < self.WW then
        self.playerx = self.playerx + self.playerxv * dt
      end
      if love.keyboard.isDown("w") and self.playery > 0 then
        self.playery = self.playery - self.playeryv * dt
      end
      if love.keyboard.isDown("s") and self.playery + self.playerimg:getHeight() * self.scale < self.WH then
        self.playery = self.playery + self.playeryv * dt
      end
      if self.playerx < self.px + 48 and self.playerx + self.playerimg:getWidth() * self.scale > self.px and self.playery < self.py + 48 and self.playery + self.playerimg:getHeight() * self.scale > self.py and self.pvisible then
        self.pvisible = false
        sound = love.audio.newSource("assets/music/collect.wav", "stream")
        love.audio.play(sound)
      end
      if self.playerx < self.p2x + 48 and self.playerx + self.playerimg:getWidth() * self.scale > self.p2x and self.playery < self.p2y + 48 and self.playery + self.playerimg:getHeight() * self.scale > self.p2y and self.pvisible2 then
        self.pvisible2 = false
        sound = love.audio.newSource("assets/music/collect.wav", "stream")
        love.audio.play(sound)
      end
      if self.playerx < self.p3x + 48 and self.playerx + self.playerimg:getWidth() * self.scale > self.p3x and self.playery < self.p3y + 48 and self.playery + self.playerimg:getHeight() * self.scale > self.p3y and self.pvisible3 then
        self.pvisible3 = false
        sound = love.audio.newSource("assets/music/collect.wav", "stream")
        love.audio.play(sound)
      end
      for i = 1, 25 do
        self.enemies[i].update(dt)
      end
    end
    if not self.pvisbile and not self.pvisible2 and not self.pvisible3 and not self.won then
      self.won = true
      self.playing = false
      sound = love.audio.newSource("assets/music/won.wav", "stream")
      love.audio.play(sound)
    end

  end

  self.keyPressed = function(key)
    if key == "escape" then
      love.event.quit()
    end
    if key == "space" and not self.playing and not self.won then
      self.playing = true
      self.playerx = 0
      self.playery = 0
      self.enemies = {}
      for i = 1, 25 do
        table.insert(self.enemies, Enemy.new())
      end
      self.pvisible = true
      self.pvisible2 = true
      self.pvisible3 = true
    end
  end

  self.drawText = function(string, x, y, center)
    local offset = 0
    if center then
      offset = - (select(3, self.alphabet.quads[1]:getViewport()) * #string * game.scale / 2)
    end
    for i = 1, #string do
      if not (string:sub(i, i) == " ") then
        love.graphics.draw(self.alphabet.img, self.alphabet.quads[self.alphabet.characterindex[string:sub(i, i)]], x + offset + (select(3, self.alphabet.quads[1]:getViewport()) * game.scale * (i - 1)), y, 0, self.scale, self.scale)
      end
    end
  end

  return self
end
