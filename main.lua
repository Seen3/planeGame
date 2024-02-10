push = require 'push'
Class = require 'class'

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 384*2
VIRTUAL_HEIGHT = 216*2

bgm = love.audio.newSource("resources/sounds/bgm.ogg", "stream")
shot = love.audio.newSource("resources/sounds/shot.ogg", "static")

function love.load()
    change=-1
    love.window.setTitle('2D Shooter')
    --love.graphics.setDefaultFilter('nearest','nearest')
    math.randomseed(os.time())

    sky=love.graphics.newImage('resources/Glacial-mountains/Layers/sky.png')
    cloudsbg=love.graphics.newImage('resources/Glacial-mountains/Layers/clouds_bg.png')
    lone_cloud=love.graphics.newImage('resources/Glacial-mountains/Layers/cloud_lonely.png')
    mountains=love.graphics.newImage('resources/Glacial-mountains/Layers/glacial_mountains.png')
    cloud_front=love.graphics.newImage('resources/Glacial-mountains/Layers/clouds_mg_1.png')
    plane_fly_1=love.graphics.newImage('resources/png/Plane/Fly (1).png')
    plane_fly_2=love.graphics.newImage('resources/png/Plane/Fly (2).png')
    plane_shoot_1=love.graphics.newImage('resources/png/Plane/Shoot (1).png')
    plane=plane_fly_1

    bullet1=love.graphics.newImage('resources/png/Bullet/Bullet (1).png')
    bullet2=love.graphics.newImage('resources/png/Bullet/Bullet (2).png')
    bullet3=love.graphics.newImage('resources/png/Bullet/Bullet (3).png')
    bullet4=love.graphics.newImage('resources/png/Bullet/Bullet (4).png')
    bullet5=love.graphics.newImage('resources/png/Bullet/Bullet (5).png')
    bulletImage=bullet1
    bullets={}
    isShooting=false

    bgm:setLooping(true)
    bgm:setVolume(0.1)
    bgm:play()
    enemies={}
    shot:setVolume(1)

    coords={['bgcloud']={0,0},['cloud_lonely']={0,0},['mountains']={0,0},['cloud_front']={0,0},['plane']={0,0,1}}
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

end

function love.resize(w, h)
    push:resize(w, h)
end


function love.update(dt)
    coords['bgcloud'][1]=coords['bgcloud'][1]-(dt*20)
    coords['cloud_lonely'][1]=coords['cloud_lonely'][1]-(dt*25)
    coords['mountains'][1]=coords['mountains'][1]-(dt*23)
    coords['cloud_front'][1]=coords['cloud_front'][1]-(dt*30)

    if coords['plane'][3]>=25 then
        change=-change
        if change==1 then
            plane=plane_fly_2
            bulletImage=bullet3
        else
            plane=plane_fly_1
            bulletImage=bullet1
        end
        coords['plane'][3]=0
    end
    coords['plane'][3]=coords['plane'][3]+math.abs(change)
    if coords['bgcloud'][1]<=-(cloudsbg:getWidth()*2) then
        coords['bgcloud'][1]=0
    end
    if coords['mountains'][1]<=-(mountains:getWidth()*2) then
        coords['mountains'][1]=0
    end
    if coords['cloud_front'][1]<=-(cloud_front:getWidth()*2) then
        coords['cloud_front'][1]=0
    end
    if coords['cloud_lonely'][1]<=-5*VIRTUAL_WIDTH then
        coords['cloud_lonely'][1]=0
    end
    if love.keyboard.isDown('space') and not isShooting then
        isShooting=true
        local newBull={
            x=coords['plane'][1]+plane:getWidth()*0.2,
            y=coords['plane'][2]+plane:getHeight()*0.07,
            velocity=500
        }
        table.insert(bullets,newBull)
        plane=plane_shoot_1
        shot:play()


    end


    for i, bullet in ipairs(bullets) do
        bullet.x = bullet.x + bullet.velocity * dt
        if bullet.x > VIRTUAL_WIDTH then
            table.remove(bullets, i)
            isShooting=false
        end
    end


    if love.keyboard.isDown('s') then
        coords['plane'][2]=math.min(coords['plane'][2]+(100*dt),VIRTUAL_HEIGHT-(0.3*plane:getHeight()))
    end
    if love.keyboard.isDown('w') then
        coords['plane'][2]=math.max(coords['plane'][2]-(100*dt),0)
    end

end

function love.draw()
    push:apply('start')
    love.graphics.clear(0.53,0.81,0.92)
    love.graphics.draw(sky,0,0,0,2,2)
    love.graphics.draw(cloudsbg,coords['bgcloud'][1],coords['bgcloud'][2],0,2,2)
    love.graphics.draw(cloudsbg,coords['bgcloud'][1]+VIRTUAL_WIDTH,coords['bgcloud'][2],0,2,2)
    love.graphics.draw(mountains,coords['mountains'][1],coords['mountains'][2],0,2,2)
    love.graphics.draw(mountains,coords['mountains'][1]+VIRTUAL_WIDTH,coords['mountains'][2],0,2,2)
    love.graphics.draw(lone_cloud,coords['cloud_lonely'][1]+VIRTUAL_WIDTH,coords['cloud_lonely'][2],0,2,2)
    love.graphics.draw(cloud_front,coords['cloud_front'][1],coords['cloud_front'][2],0,2,2)
    love.graphics.draw(cloud_front,coords['cloud_front'][1]+VIRTUAL_WIDTH,coords['cloud_front'][2],0,2,2)
    love.graphics.draw(plane,coords['plane'][1],coords['plane'][2],0,0.2,0.2)
    for _, bullet in ipairs(bullets) do
        love.graphics.draw(bulletImage, bullet.x, bullet.y,0.2,0.2)
    end
    displayFPS()
    push:apply('end')
end

function displayFPS()
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 10, 10)
end
