love = require("love")

function love.load()
    map = require("map")
    defenses = require("defenses")
    defenseValues = require("defenseValues")
    game = require("game")
    enemy = require("enemy")

    defenses.init()
end

function love.draw()
    map.draw()
    defenses.buyDraw()
    defenses.draw()
    enemy.draw()

    love.graphics.setColor(1,1,1)
    love.graphics.print(game.money, 100, 100)
end

function love.update(dt)
    enemy.move(dt)
    defenses.colldownReset(dt)

    for i = 1, #defenses.built do
        if defenses.built[i].defense == "generator" then
            defenseValues.generator.generate(defenses.built[i])
        end
    end
end

function love.mousepressed(x, y, button, isTouch)
    local defensePicked = defenses.pickedDefenses[defenses.selected]
    if button == 1 then
        local bonus = {}
        if (x >= 5 and x <= 5 + defenses.UIsize) and (y >= 5 + 80 and y <= 5 + 80 + (#defenses.pickedDefenses * (defenses.UIsize + 5))) then
            defenses.selected = math.floor((y - 85) / (defenses.UIsize + 5)) + 1
        elseif x >= map.blockSize * 1.75 and defenses.selected ~= 0 then

            local canPlace = false
            local defValuesPickedDefense = defenseValues[defensePicked]
            local isCooledDown = defenses.coolDowns[defensePicked] >= defValuesPickedDefense.plantCoolDown

            if defensePicked == "generator" and defValuesPickedDefense.count == 0 and isCooledDown then
                canPlace = true
                defValuesPickedDefense.count = defValuesPickedDefense.count + 1
                defenses.coolDowns[defensePicked] = 0

                table.insert(bonus, 0)
            elseif game.money >= defValuesPickedDefense.cost and isCooledDown then
                game.money = game.money - defValuesPickedDefense.cost
                defValuesPickedDefense.count = defValuesPickedDefense.count + 1
                canPlace = true
                defenses.coolDowns[defensePicked] = 0
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
                
                if not exists and bonus == {} then
                    table.insert(defenses.built, {x = tileX, y = tileY, defense = defensePicked})
                elseif not exists then
                    table.insert(defenses.built, {x = tileX, y = tileY, defense = defensePicked})
                    defenses.built[#defenses.built].cooldown = bonus[1]
                end

            end
        end
    end
end