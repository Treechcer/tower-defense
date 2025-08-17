local map = require("map")
local defenseValues = require("defenses.defenseValues")

defenses = {
    pickedDefenses = {
        "shooter",
        "generator",
        "tank",
        "iceShooter",
        "fireShooter"
    },

    built = { -- it's table of tables, every table in it has X Y position and other things

    },

    UIsize = 70,
    selected = 0,

    coolDowns = {},
}

function defenses.reset()
    defenses.built = {}
    defenses.init()
end

function defenses.damagePlant(plant, damage)
    --print(defenses.built[plant])

    defenses.built[plant].hp = defenses.built[plant].hp - damage

    if defenses.built[plant].hp <= 0 then
        table.remove(defenses.built, plant)
    end
end

function defenses.init()
    for key, value in pairs(defenses.pickedDefenses) do
        defenses.coolDowns[value] = defenseValues[value].plantCoolDown
    end
end

function defenses.buyDraw()
    local offset = 5 + 80
    for i = 0, #defenses.pickedDefenses - 1 do
        if i + 1 == defenses.selected then
            love.graphics.setColor(1,1,1, game.levelTransition)
        else
            love.graphics.setColor(0.3,0.3,0.3, game.levelTransition)
        end

        love.graphics.rectangle("fill", 5, i * defenses.UIsize + offset, defenses.UIsize, defenses.UIsize)

        local p = defenseValues[defenses.pickedDefenses[i+1]].plantCoolDown / defenses.coolDowns[defenses.pickedDefenses[i+1]]
        love.graphics.setColor(0.1,0.1,0.1, 0.4)
        love.graphics.rectangle("fill", 5, i * defenses.UIsize + offset, defenses.UIsize, defenses.UIsize / p)

        offset = offset + 5
    end
end

function defenses.draw()
    for key, value in pairs(defenses.built) do
        love.graphics.setColor(defenseValues[value.defense].sprite, game.levelTransition)
        love.graphics.rectangle("fill", (value.x - 1) * map.blockSize + map.blockSize * 1.75, (value.y - 1) * map.blockSize, map.blockSize, map.blockSize)
    end
end

function defenses.colldownReset(dt)
    for key, value in pairs(defenses.coolDowns) do
        defenses.coolDowns[key] = value + dt
        if defenses.coolDowns[key] > defenseValues[key].plantCoolDown then
            defenses.coolDowns[key] = defenseValues[key].plantCoolDown
        end
    end

    for i = 1, #defenses.built do
        if defenses.built[i].defense == "generator" then
            if defenses.built[i].cooldown == nil then
                defenses.built[i].cooldown = 0
            end

            --for key, value in pairs(defenses.built[i]) do
            --    print(i, key, " : ", value)
            --end

            defenses.built[i].cooldown = defenses.built[i].cooldown + dt
        else
            defenses.built[i].cooldown = defenses.built[i].cooldown + dt
        end
    end
end

return defenses