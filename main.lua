love = require("love")

function love.load()
   map = require("map")
   defenses = require("defenses")
   defenseValues = require("defenseValues")
   game = require("game")
end

function love.draw()
    map.draw()
    defenses.buyDraw()
    defenses.draw()

    love.graphics.print(game.money, 100, 100)
end

function love.update(dt)
    
end

function love.mousepressed(x, y, button, isTouch)
    if button == 1 then
        if (x >= 5 and x <= 5 + defenses.UIsize) and (y >= 5 + 80 and y <= 5 + 80 + (#defenses.pickedDefenses * (defenses.UIsize + 5))) then
            defenses.selected = math.floor((y - 85) / (defenses.UIsize + 5)) + 1
        elseif x >= map.blockSize * 1.75 and defenses.selected ~= 0 then

            local canPlace = false

            if defenses.pickedDefenses[defenses.selected] == "generator" and defenseValues[defenses.pickedDefenses[defenses.selected]].count == 0 then
                canPlace = true
                defenseValues[defenses.pickedDefenses[defenses.selected]].count = defenseValues[defenses.pickedDefenses[defenses.selected]].count + 1
            elseif game.money >= defenseValues[defenses.pickedDefenses[defenses.selected]].cost then
                game.money = game.money - defenseValues[defenses.pickedDefenses[defenses.selected]].cost
                defenseValues[defenses.pickedDefenses[defenses.selected]].count = defenseValues[defenses.pickedDefenses[defenses.selected]].count + 1
                canPlace = true
            end

            if canPlace then
                tileX = math.floor((x - map.blockSize * 1.75) / map.blockSize) + 1
                tileY = math.floor((y) / map.blockSize) + 1

                exists = false

                for key, value in pairs(defenses.built) do
                    if value.x == tileX and value.y == tileY then
                        exists = true
                        break
                    end
                end
                
                if not exists then
                    table.insert(defenses.built, {x = tileX, y = tileY, defense = defenses.pickedDefenses[defenses.selected]})
                end

            end
        end
    end
end