Ball = Class {}
local GRAVITY = 3.25


function Ball:init()
    self.image = love.graphics.newImage('ball.png')
    self.height = self.image:getHeight()
    self.width = self.image:getWidth()
    self.state = 'moving'
    self.x = VIRTUAL_WIDTH / 2 - self.width
    self.y = 50 - (self.height/2)
    self.dy = 0
    self.dx = 0
end

function Ball:collides(object)
    if self.x > object.x + object.width  or object.x > self.x + self.width then
        return false
    end
    if self.y > object.y + object.height or object.y > self.y + self.height then
        return false
    end 
    return true
end

function Ball:update(dt)
    if self.state == 'moving' then 
        self.dy = self.dy +  GRAVITY * dt
        self.y = self.y + self.dy
    end
    if self.dx < 0 then 
        self.x = math.max(0,self.x + self.dx * dt)
    else
        self.x = math.min(self.x + self.dx * dt,VIRTUAL_WIDTH - self.width)
    end
end

function Ball:reset()
    self.state = 'moving'
    self.x = VIRTUAL_WIDTH / 2 - self.width
    self.y = 50 - (self.height/2)
    self.dy = 0
    self.dx = 0
end

    function Ball:render()
    love.graphics.draw(self.image,self.x,self.y)
end
