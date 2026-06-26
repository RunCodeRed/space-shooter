local enemy = require("enemy")
local player = {}




function player.load()
    enemy_death = false
    --player values
    player.restart_timer = 0 --countdown for restaring game
    player.reseting_countdown = 5 --countdown for display
    player.speed = 200 --player speed
    player.sprite = love.graphics.newImage("Sprites/spaceship.png") --loads player sprite
    player.width = player.sprite:getWidth() --gets player sprite width
    player.height = player.sprite:getHeight() --gets player sprite height
    player.x = (love.graphics.getWidth() / 2) - (player.width / 2)  --tries its very hardest to put the player somewhat in the middle
    player.y = 500 --player y cords


    player_listOfLasers = {}

    --player laser timer starter
    player_laserTimer = 1
end


function player.createLaser()
    --player lasers values
    player_laser = {}
    player_laser.speed = 100 --player laser speed
    player_laser.sprite = love.graphics.newImage("Sprites/spaceship_laser.png") --loads player laser sprite
    player_laser.width = player_laser.sprite:getWidth() / 2 --gets player laser sprite width
    player_laser.height = player_laser.sprite:getHeight() / 2 --gets player laser sprite height
    player_laser.x = player.x + 60 --lasers x cords
    player_laser.y = player.y - 10 -- lasers y cords


    --puts new laser in list of lasers
    table.insert(player_listOfLasers, player_laser)
end

--player movement function
function player.Movement(dt)
    --makes player local player_laser = {}move to the right
    if love.keyboard.isDown("right", "d") then
        player.x = player.x + player.speed * dt
    end

    --makes player move to the left
    if love.keyboard.isDown("left", "a") then
        player.x = player.x - player.speed * dt
    end

    --makes player move up
    if love.keyboard.isDown("up", "w") then
        player.y = player.y - player.speed * dt
    end

    --makes player move down
    if love.keyboard.isDown("down", "s") then
        player.y = player.y + player.speed * dt
    end
end

--player boundry functionality
function player.Boundry(dt)
    --gets winow width
    winWidth = love.graphics.getWidth()

    --gets window height
    winHeight = love.graphics.getHeight()

    --makes sure player can't go left or right off the window
    player.x = math.min(math.max(0 ,player.x), winWidth - player.width)

    --makes sure player can't go up or down off the window
    player.y = math.min(math.max(350 ,player.y), winHeight - player.height)
end



--function for checking collisions...... or is it
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1<x2+w2 and
    x2< x1 + w1 and
    y1<y2+h2 and
    y2<y1+h1
end


--function for restarting game
function player.restartGame(dt)
    if player_death == true then
        
        player.restart_timer = player.restart_timer + dt

        if player_death == true then
            player.reseting_countdown = player.reseting_countdown - dt
        end

        if player.restart_timer > 5 then
            love.event.quit("restart")
        end
    end
end



function player.update(dt)
    --makes player move
    player.Movement(dt)

    --makes player unable to leave boundry
    player.Boundry(dt)

    --restarts game after a bit
    player.restartGame(dt)

    --updates player laser timer
    player_laserTimer = player_laserTimer + dt




    for i, player_laser in ipairs(player_listOfLasers) do
        player_laser.y = player_laser.y - player_laser.speed * dt 

        --removes player bullet when hitting enemy hitbox
        if checkCollision(player_laser.x, player_laser.y, player_laser.width, player_laser.height, enemy.x, enemy.y, enemy.width, enemy.height) then
            table.remove(player_listOfLasers, i) --removes player laser on collision
            enemy_death = true --enemy lowk dead
        end

        --removes player laser when leaving window
        if player_laser.y < -50 then
            table.remove(player_listOfLasers, i)
        end
    end
end



function player.draw()
    if player_death == false then
        --draws player sprite
        love.graphics.draw(player.sprite, player.x, player.y)
        --draws player hitbox
        love.graphics.rectangle("line", player.x, player.y, player.width, player.height)
    else
        player.speed = 0 --stops player movement
        table.remove(player_listOfLasers) --removes player lasers
        table.remove(enemy_listOfLasers) --remoes enemy lasers
        table.remove(player)

        --shows you losse
        love.graphics.print("YOU LOSE", 0, 0, 0, 5, 5)

        --shows countdown for restart
        love.graphics.print("restarting in " .. player.reseting_countdown, 40, 600)
    end


    for i, player_laser in ipairs(player_listOfLasers) do
        love.graphics.draw(player_laser.sprite, player_laser.x, player_laser.y, 0, 0.5, 0.5)
        love.graphics.rectangle("line", player_laser.x, player_laser.y, player_laser.width, player_laser.height)
    end

    --draws laser every 2 seconds
    if player_laserTimer > 2 then
        player.createLaser()
        player_laserTimer = 0
    end
end



return player