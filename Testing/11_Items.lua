-- Blue Circle

local init = function()
    -- Item 1
    local item = Item.new("blueCircle")

    item:set_sprite(Sprite.new("blueCircle", "~/blueCircle.png", 1, 16, 16))
    item:set_tier(ItemTier.COMMON)

    ItemLog.new_from_item(item)

    item:show_properties()

    Callback.add(item.on_acquired, function(actor, stack)
        print("'blueCircle' on_acquired")
        print(actor, actor.value)
        print("Stack: "..stack)
    end)
    
    RecalculateStats.add(function(actor, api)
        -- Add 10 maxhp per stack
        local stack = actor:item_count(item)
        api.maxhp_add(10 * stack)
    end)
    
    Callback.add(Callback.ON_HIT_PROC, function(actor, victim, hit_info)
        if actor:item_count(item) <= 0 then return end
    
        print("'blueCircle' ON_HIT_PROC")
    end)

    local angle = 0
    local dist = 48
    item.effect_display = EffectDisplay.func(function(actor, draw_x, draw_y)
        angle = angle + 0.025
        gm.draw_circle(draw_x + math.cos(angle)*dist, draw_y - math.sin(angle)*dist, 12, false)
    end, EffectDisplay.DrawPriority.ABOVE_BODY)



    -- Item 2
    local item = Item.new("greenSquare")

    item:set_sprite(Sprite.new("greenSquare", "~/greenSquare.png", 1, 16, 16))
    item:set_tier(ItemTier.UNCOMMON)

    ItemLog.new_from_item(item)

    item:show_properties()

    Callback.add(item.on_acquired, function(actor, stack)
        print("'greenSquare' on_acquired")
        print(actor, actor.value)
        print("Stack: "..stack)
    end)
    
    RecalculateStats.add(function(actor, api)
        -- Shaped Glass
        local stack = actor:item_count(item)
        for i = 1, stack do
            api.maxhp_mult(0.5)
            api.damage_mult(2)
        end
    end)



    item_hotloaded = true
end
Initialize(init)
if item_hotloaded then init() end

-- Return status
return true