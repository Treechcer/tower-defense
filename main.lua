love = require("love")

function love.load()
    game = require("game")
    levelReader = require("levels.levelReader")
    map = require("map")
    map.generateSpecialTiles()
    levelReader.readLevel("world" .. game.world .. "/" .. "level" .. game.level)
    defenses = require("defenses.defenses")
    defenseValues = require("defenses.defenseValues")
    enemy = require("enemy.enemy")

    -- funcitons to init values and needed things

    defenses.init()
end

function love.draw()
    map.draw()
    defenses.buyDraw()
    defenses.draw()
    enemy.draw()
    projectile.draw()
    levelReader.drawBar()

    love.graphics.setColor(1, 1, 1, game.levelTransition)
    love.graphics.print(game.money, 100, 100)
end

function love.update(dt)
    dt = dt * 2

    game.isRunning = levelReader.transition(dt)

    if game.isRunning then
        enemy.move(dt)
        enemy.cooldownAdd(dt)
        defenses.colldownReset(dt)
        projectile.move(dt)
        levelReader.logic(dt)
        projectile.collisionCheck()

        enemy.delaySpawner(dt)
    end

    for i = 1, #defenses.built do
        if defenseValues[defenses.built[i].defense].type == "generator" then
            defenseValues.generator.generate(defenses.built[i])
        elseif defenseValues[defenses.built[i].defense].type == "shooter" then
            defenseValues.shooter.shoot(defenses.built[i])
        end

        --print(defenseValues[defenses.built[i].defense].type)
    end
end

function love.mousepressed(x, y, button, isTouch)
    local defensePicked = defenses.pickedDefenses[defenses.selected]
    if button == 1 then
        local bonus = {}
        if (x >= 5 and x <= 5 + defenses.UIsize) and (y >= 5 + 80 and y <= 5 + 80 + (#defenses.pickedDefenses * (defenses.UIsize + 5))) then
            defenses.selected = math.floor((y - 85) / (defenses.UIsize + 5)) + 1
        elseif x >= map.blockSize * 1.75 and defenses.selected ~= 0 then
            local tileX = math.floor((x - map.blockSize * 1.75) / map.blockSize) + 1
            local tileY = math.floor((y) / map.blockSize) + 1

            if map.specialTilesAbility[tileY][tileX] == "plant" then
                for index, value in ipairs(defenses.built) do
                    if value.x == tileX and value.y == tileY then
                        game.money = game.money + math.floor((defenseValues[value.defense].cost / 3) * 2)

                        table.remove(defenses.built, index)
                        break
                    end
                end
                
                map.specialTilesAbility[tileY][tileX] = nil
            end

            local abilities = map.doAbilityOfTile("else")
            
            if map.specialTiles[tileY][tileX] then
                abilities = map.doAbilityOfTile(map.specialTilesAbility[tileY][tileX])
            end

            if not abilities.place or map.disabledLanes[tileY] then
                return
            end

            local canPlace = false
            local defValuesPickedDefense = defenseValues[defensePicked]
            local isCooledDown = defenses.coolDowns[defensePicked] >= defValuesPickedDefense.plantCoolDown

            if defensePicked == "generator" and defValuesPickedDefense.count == 0 and isCooledDown then
                canPlace = true
                defValuesPickedDefense.count = defValuesPickedDefense.count + 1
                defenses.coolDowns[defensePicked] = 0

                table.insert(bonus, 0)
                
            --elseif defensePicked == "shooter" and game.money >= defValuesPickedDefense.cost and isCooledDown then
            --    game.money = game.money - defValuesPickedDefense.cost
            --    defValuesPickedDefense.count = defValuesPickedDefense.count + 1
            --    canPlace = true
            --    defenses.coolDowns[defensePicked] = 0
            --
            --    table.insert(bonus, 0)

            elseif game.money >= defValuesPickedDefense.cost and isCooledDown then
                game.money = game.money - defValuesPickedDefense.cost
                defValuesPickedDefense.count = defValuesPickedDefense.count + 1
                canPlace = true
                defenses.coolDowns[defensePicked] = 0

                table.insert(bonus, 0)
            end

            if canPlace then
                exists = false

                for key, value in pairs(defenses.built) do
                    if value.x == tileX and value.y == tileY then
                        exists = true
                        break
                    end
                end

                if not exists and bonus == {} then
                    table.insert(defenses.built, { x = tileX, y = tileY, defense = defensePicked, hp = defenseValues[defensePicked].hp })
                    map.makeSpecialTile({x = tileX, y = tileY, ability = "plant"})
                elseif not exists then
                    table.insert(defenses.built, { x = tileX, y = tileY, defense = defensePicked, hp = defenseValues[defensePicked].hp })
                    defenses.built[#defenses.built].cooldown = bonus[1]
                    map.makeSpecialTile({x = tileX, y = tileY, ability = "plant"})
                end
            end
        end
    end
end
