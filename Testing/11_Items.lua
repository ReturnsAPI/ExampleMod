-- Blue Circle

local init = function()
    item_hotloaded = true
    
    -- Item 1
    local item = Item.new("blueCircle")

    item:set_sprite(Sprite.new("blueCircle", "~/blueCircle.png", 1, 16, 16))
    item:set_tier(ItemTier.COMMON)

    ItemLog.new_from_item(item)

    item:print_properties()

    Callback.add(item.on_acquired, function(actor, stack)
        print(actor)

        print("'blueCircle' on_acquired")
        print(actor, actor.value)
        print("Stack: "..stack)
    end)

    Callback.add(item.on_removed, function(actor, stack)
        print(actor)
    end)
    
    -- RecalculateStats.add(function(actor, api)
    --     -- Add 10 maxhp per stack
    --     local stack = actor:item_count(item)
    --     api.maxhp_add(10 * stack)

    --     -- Cut secondary skill cooldown in half per stack
    --     api.skill_secondary.cooldown_mult(0.5^stack)
    -- end)

    -- Flawed RecalcStat
    RecalculateStats.add(function(actor)
        -- Add 10 maxhp per stack
        actor.maxhp = actor.maxhp + (10 * actor:item_count(item))
    end)
    
    Callback.add(Callback.ON_HIT_PROC, function(actor, victim, hit_info)
        if actor:item_count(item) <= 0 then return end
    
        print("'blueCircle' ON_HIT_PROC")
        print("Stack count: "..actor:item_count(item))
        print("Victim: "..tostring(victim), gm.object_get_name(victim.object_index))
    end)

    local angle = 0
    local dist = 48
    item.effect_display = EffectDisplay.func(function(actor, draw_x, draw_y)
        angle = angle + 0.025
        Draw.circle(draw_x + math.cos(angle)*dist, draw_y - math.sin(angle)*dist, 12, false, Color.AQUA)
    end, EffectDisplay.DrawPriority.ABOVE_BODY)

    -- Hook.post("skill_activate", function(self, other, result, args)
    --     if self:item_count(item) <= 0 then return end

    --     print(self)
    --     print(other)
    --     print(result.value)
    --     for i, v in ipairs(args) do
    --         print(i, v)
    --     end
    -- end)



    -- Item 2
    local item = Item.new("greenSquare")

    item:set_sprite(Sprite.new("greenSquare", "~/greenSquare.png", 1, 16, 16))
    item:set_tier(ItemTier.UNCOMMON)

    ItemLog.new_from_item(item)

    item:print_properties()

    Callback.add(item.on_acquired, function(actor, stack)
        print("'greenSquare' on_acquired")
        print(actor, actor.value)
        print("Stack: "..stack)
    end)
    
    -- RecalculateStats.add(function(actor, api)
    --     -- Shaped Glass
    --     local stack = actor:item_count(item)
    --     for i = 1, stack do
    --         api.maxhp_mult(0.5)
    --         api.damage_mult(2)
    --     end
    -- end)
end
Initialize.add(init)
if item_hotloaded then init() end

-- Return status
return true