-- Blue Circle

local item = Item.new("blueCircle")

item:set_sprite(Sprite.new("blueCircle", "~/sprites/blueCircle.png", 1, 16, 16))
item:set_tier(ItemTier.COMMON)

ItemLog.new_from_item(item)

Callback.add(item.on_acquired, function(actor, stack)
    print("'blueCircle' on_acquired")
    print("Actor: "..tostring(actor))
    print("Stack: "..tostring(stack))
end)

Callback.add(item.on_removed, function(actor, stack)
    print("'blueCircle' on_removed")
    print("Actor: "..tostring(actor))
    print("Stack: "..tostring(stack))
end)

RecalculateStats.add(function(actor)
    -- Add 10 maxhp per stack
    actor.maxhp = actor.maxhp + (10 * actor:item_count(item))
end)

Callback.add(Callback.ON_HIT_PROC, function(actor, victim, hit_info)
    local stack = actor:item_count(item)
    if stack <= 0 then return end

    -- 25% chance on hit to create lightning
    if Util.chance(0.25) then
        local obj = Object.find("chainLightning")
        local lightning = obj:create(victim.x, victim.y)
        lightning.damage = hit_info.damage * (stack * 0.2)
        lightning.bounce = 3
        lightning.range = 80
    end
end)

Callback.add(Callback.ON_STEP, function()
    local actors = item:get_holding_actors()
    
    -- Create lightning on self every 1 second
    for _, actor in ipairs(actors) do
        local actor_data = Instance.get_data(actor, "blueCircle")
        actor_data.timer = actor_data.timer or 0

        if actor_data.timer > 0 then
            actor_data.timer = actor_data.timer - 1
        else
            actor_data.timer = 60

            local obj = Object.find("chainLightning")
            local lightning = obj:create(actor.x, actor.y)
            lightning.damage = actor.damage * (actor:item_count(item) * 0.3)
            lightning.bounce = 3
            lightning.range = 120
        end
    end
end)

-- Draw orbiting blue circle (does nothing)
local angle = 0
local dist = 48
item.effect_display = EffectDisplay.func(function(actor, draw_x, draw_y)
    angle = angle + 0.025
    Draw.circle(draw_x + (math.cos(angle) * dist),
                draw_y - (math.sin(angle) * dist),
                12, false, Color.AQUA)
end, EffectDisplay.DrawPriority.ABOVE_BODY)