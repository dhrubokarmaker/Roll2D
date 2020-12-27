WINDOW_WIDTH = 600
WINDOW_HEIGHT = 800

VIRTUAL_WIDTH = 320
VIRTUAL_HEIGHT = 427
ball_speed = 255


push = require 'push'
Class = require 'class'
require 'Spike'
require 'Ball'
require 'Base'
require 'Obstacle'

local spike_sprite = love.graphics.newImage('spke.png')
local background = love.graphics.newImage('starbgrnd.png')
local backgroundScroll = 0
local BG_SCROLL_SPEED = 40
local BG_LOOPING_POINT = 480
local bases = {}
local obstacles = {}
local spwanTimer = 0

function love.load()
    SCROLL_SPEED = 85
    math.randomseed(os.time())
    love.graphics.setDefaultFilter('nearest','nearest')
    b_music = love.audio.newSource('background.mp3','static')
    text = love.graphics.newFont('Pixeled.ttf',15)
    scoretext = love.graphics.newFont('Pixeled.ttf',10)
    scoretext_d = love.graphics.newFont('Pixeled.ttf',15)
    love.window.setTitle('Roll')
    spike = Spike(spike_sprite,16,16,VIRTUAL_WIDTH)
    ball = Ball()
    start = Base()
    push:setupScreen(VIRTUAL_WIDTH,VIRTUAL_HEIGHT,WINDOW_WIDTH,WINDOW_HEIGHT,
    {
        fullscreen = false,
        resizable = false,
        vsync = true
    }
    )
    sounds = {
        ['death'] = love.audio.newSource('death.wav', 'static'),
        ['start'] = love.audio.newSource('start.wav', 'static')
    }
    score = 1
    gameState = 'start'
end

function love.update(dt)
    if gameState == 'play' then
        backgroundScroll = (backgroundScroll + BG_SCROLL_SPEED* dt) 
        % BG_LOOPING_POINT
        score = score + (dt * SCROLL_SPEED)/40
        timer = math.floor(score)
        if timer % 40 == 0 then
            SCROLL_SPEED = SCROLL_SPEED + 1
        end
        if love.keyboard.isDown('a') then
            ball.dx = -ball_speed
        elseif love.keyboard.isDown('d') then
            ball.dx = ball_speed
        else
            ball.dx = 0
        end
        spwanTimer = spwanTimer + dt
        if spwanTimer > 2 then
            table.insert(bases, Base())
            table.insert(obstacles,Obstacle())
            spwanTimer = 0
        end
        start:update(dt)
        if ball:collides(start) then
            ball.state = 'idle'
            ball.dy = 0
            ball.y = start.y - ball.height
        else
            ball.state = 'moving'
        end
        for k, base in pairs(bases) do
            base:update(dt)
            if ball:collides(base) then 
                ball.state =  'idle'
                ball.dy = 0
                ball.y = base.y - ball.height
            else
                ball.state = 'moving'
            end
            if base.y < -base.height then
                table.remove(bases,k)
            end
        end
        for l, obstacle in pairs(obstacles) do
            obstacle:update(dt)
            if ball:collides(obstacle) then 
                sounds['death']:play()
                gameState = 'death'
            end
            if obstacle.y < -obstacle.height then
                table.remove(obstacles,l)
            end
        end
        if ball.y > VIRTUAL_HEIGHT + ball.height or ball.y < spike.height then
            sounds['death']:play()
            gameState = 'death'
        end
        ball:update(dt)
    else
        b_music:stop()
    end
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
    if key == 'return' then 
        if gameState == 'start' then
            b_music:setLooping(true)
            b_music:setVolume(0.5)
            b_music:play()
            gameState = 'play'
        elseif gameState == 'death' then
            b_music:setLooping(true)
            b_music:setVolume(0.5)
            b_music:play()
            start.x = VIRTUAL_WIDTH / 2 - start.width/2
            start.y = VIRTUAL_HEIGHT / 2 - start.height/2
            score = 1
            obstacles = {}
            bases = {}
            SCROLL_SPEED = 85
            ball:reset()
            gameState = 'play'
        end
    end
end

function love.draw()
    push:apply('start')
    love.graphics.draw(background,0,-backgroundScroll)
    start:render()
    for k, base in pairs(bases) do
        base:render()
    end
    for l, obstacle in pairs(obstacles) do
        obstacle:render()
    end
    ball:render()
    spike:render()
    if gameState == 'play' then
        DisplayScore()
    end
    if gameState == 'start' then
        love.graphics.setFont(text)
        love.graphics.printf('Press Enter to begin!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'death' then
        love.graphics.draw(background,0,-backgroundScroll)
        love.graphics.setFont(text)
        love.graphics.rectangle('fill', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 70)
        love.graphics.setColor(1,0,0,1)
        love.graphics.printf('You died!', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press Enter to Restart!', 0, VIRTUAL_HEIGHT/3 + 25 , VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(1,1,0,1)
        love.graphics.setFont(scoretext_d)
        love.graphics.printf('Score:' .. tostring(math.floor(score)), 0, VIRTUAL_HEIGHT/2 + 30 , VIRTUAL_WIDTH, 'center')
    end
    push:apply('end')
end

function DisplayScore()
    love.graphics.setFont(scoretext)
    love.graphics.print(tostring(math.floor(score)), VIRTUAL_WIDTH - 40, 18)
end