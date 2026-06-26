local enemy = {}



function enemy.load()
    --player death state
    player_death = false
    --enemy values
    enemy.reseting_countdown = 5 --countdown for restaring game
    enemy.restart_timer = 0 --countdown for display
    enemy.speed = 80 --speed of enemy
    enemy.sprite = love.graphics.newImage("Sprites/enemy_spaceship.png") --loads in sprite
    enemy.width = enemy.sprite:getWidth() --gets sprite width
    enemy.height = enemy.sprite:getHeight() --gets sprite height
    enemy.x = (love.graphics.getWidth() / 2) - (enemy.width / 2) --tries its very hardest to put the enemy spaceship somewhat in the middle
    enemy.y = 50 --y cords

    enemy_listOfLasers = {}

    --enemy laser timer starter
    enemy_laserTimer = 1
end


function enemy.createLaser()
    --enemy lasers values
    enemy_laser = {}
    enemy_laser.speed = 150 --enemy laser speed
    enemy_laser.sprite = love.graphics.newImage("Sprites/enemy_spaceship_laser.png") --loads enemy laser sprite
    enemy_laser.width = enemy_laser.sprite:getWidth() / 2 --gets enemy laser sprite width
    enemy_laser.height = enemy_laser.sprite:getHeight() / 2 --gets enemy laser sprite height
    enemy_laser.x = enemy.x + 60 --lasers x cords
    enemy_laser.y = enemy.y + 110 -- lasers y cords


    --puts new laser in list of lasers
    table.insert(enemy_listOfLasers, enemy_laser)
end



--function for checking collisions...... or is it
function checkCollision(x1, y1, w1, h1, x2, y2, w2, h2)
    return x1<x2+w2 and
    x2< x1 + w1 and
    y1<y2+h2 and
    y2<y1+h1
end


--enemy movement function
function enemy.Movement(dt)
    local player = require("player")

    --makes enemy go right of player
    if player.x > enemy.x then
        enemy.x = enemy.x + enemy.speed * dt
    end

    --makes enemy go left of player
    if player.x < enemy.x then
        enemy.x = enemy.x - enemy.speed * dt
    end
end


--restarting game function
function enemy.restartGame(dt)
    if enemy_death == true then

        --timer for restarting game
        enemy.restart_timer = enemy.restart_timer + dt

        --timer for displaying countdown
        if enemy_death == true then
            enemy.reseting_countdown = enemy.reseting_countdown - dt
        end

        --actually restarts the game
        if enemy.restart_timer > 5 then
            love.event.quit("restart")
        end
    end
end



function enemy.update(dt)
    --handles enemy movement
    enemy.Movement(dt)

    --handles restarting game
    enemy.restartGame(dt)

    --updates enemy laser timer
    enemy_laserTimer = enemy_laserTimer + dt * 1.8

    for i, enemy_laser in ipairs(enemy_listOfLasers) do
        enemy_laser.y = enemy_laser.y + enemy_laser.speed * dt
        local player = require("player")

        --removes enemy bullet when hitting player hitbox
        if checkCollision(enemy_laser.x, enemy_laser.y, enemy_laser.width, enemy_laser.height, player.x, player.y, player.width, player.height) then
           table.remove(enemy_listOfLasers, i) --removes enemy laser on collision
           player_death = true --player lowk dead
        end

        --removes enemy laser when leaving window
        if enemy_laser.y > 800 then
            table.remove(enemy_listOfLasers, i)
        end
    end
end



function enemy.draw()
    local player = require("player")

    if enemy_death == false then
        --draws enemy spaceship
        love.graphics.draw(enemy.sprite, enemy.x, enemy.y)

        --draw hitbox outline
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle("line", enemy.x, enemy.y, enemy.width, enemy.height)
        love.graphics.setColor(1, 1, 1)
    else
        enemy.speed = 0
        table.remove(enemy_listOfLasers) --removes lasers of enemy
        table.remove(enemy) --removes enemy
        table.remove(player_listOfLasers) --remvoes player lasers

        --shows you win
        love.graphics.print("YOU WIN", 0, 0, 0, 5, 5)

        --shows countdown for restart
        love.graphics.print("restarting in " .. enemy.reseting_countdown, 40, 600)
   end



    for i, enemy_laser in ipairs(enemy_listOfLasers) do
        love.graphics.draw(enemy_laser.sprite, enemy_laser.x, enemy_laser.y, 0, 0.5, 0.5)
        love.graphics.rectangle("line", enemy_laser.x, enemy_laser.y, enemy_laser.width, enemy_laser.height)
    end

    --draws laser every 2 seconds
    if enemy_laserTimer > 2 then
        enemy.createLaser()
        enemy_laserTimer = 0
    end

end




return enemy