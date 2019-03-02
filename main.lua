function love.load()
  require("Game")
  game = Game.new()
  game.setBasics()
  game.loadAssets()
end

function love.draw()
  game.draw()
end

function love.update(dt)
  game.update(dt)
end

function love.keypressed(key)
  game.keyPressed(key)
end
