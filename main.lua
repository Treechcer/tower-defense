love = require("love")

function love.load()
   map = require("map")
   defenses = require("defenses")
end

function love.draw()
    map.draw()
    defenses.buyDraw()
    defenses.draw()
end

function love.update(dt)
    
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        if (x >= 5 and x <= defenses.UIsize + 5) and (y >= 5 and y <= (defenses.UIsize + 5) * #defenses.pickedDefenses) then
            defenses.selected = math.ceil(y / (defenses.UIsize + 5))
        elseif x >= map.blockSize * 1.75 and defenses.selected ~= 0 then

            tileX = math.floor((x - map.blockSize * 1.75) / map.blockSize) + 1
            tileY = math.floor(y / map.blockSize) + 1

            table.insert(defenses.built, {x = tileX, y = tileY, defense = defenses.pickedDefenses[defenses.selected]})
        end
    end
end