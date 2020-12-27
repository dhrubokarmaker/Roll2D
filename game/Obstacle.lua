Obstacle = Class{}


function Obstacle:init()
    self.image = love.graphics.newImage('obstacle.png')
    self.height = self.image:getHeight() 
    self.width = self.image:getWidth() - 10
    self.x = math.random(0,VIRTUAL_WIDTH - self.width)
    self.y = math.random(VIRTUAL_HEIGHT + 30, VIRTUAL_HEIGHT + 100)
end

function Obstacle:update(dt)
    self.y = self.y - SCROLL_SPEED * dt
end

function Obstacle:render()
    love.graphics.draw(self.image,self.x,self.y+2)
end