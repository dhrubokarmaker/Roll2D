Base = Class{}

function Base:init()
    self.image = love.graphics.newImage('base.png')
    self.height = self.image:getHeight()
    self.width = self.image:getWidth() - 7
    self.x = math.random(0,VIRTUAL_WIDTH - self.width)
    self.y = VIRTUAL_HEIGHT
end

function Base:update(dt)
    self.y = self.y - SCROLL_SPEED * dt
end

function Base:render()
    love.graphics.draw(self.image,self.x,self.y)
end