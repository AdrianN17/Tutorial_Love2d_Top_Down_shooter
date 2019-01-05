local Gamestate = require "libs.gamestate"
pausa = Gamestate.new()

function pausa:init()

end

function pausa:enter(from)
  self.from = from 

end

function pausa:draw()
  local w, h = love.graphics.getWidth(), love.graphics.getHeight()

  self.from:draw()


  love.graphics.printf('PAUSE', 0, h/2, w, 'center') 
end

function pausa:keypressed(key)
  if key == 'p' then
    return Gamestate.pop() 
  end
end


return pausa