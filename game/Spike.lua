Spike = Class{}

function Spike:init(image,height,width,ending)
    self.height = height
    self.width = width
    self.image = image
    self.ending = ending
end

function Spike:update(dt)

end

function Spike:render()
    for x = 0, self.ending - 16, 16 do
        love.graphics.draw(self.image,x,0)
    end
end