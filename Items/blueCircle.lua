-- Blue Circle

local item = Item.new("blueCircle")

item:set_sprite(Sprite.new("blueCircle", "~/Items/Sprites/blueCircle.png", 1, 16, 16))
item:set_tier(ItemTier.COMMON)

ItemLog.new_from_item(item)

Callback.add(item.on_acquired, function(actor, stack)
    print("'blueCircle' on_acquired")
    print("Stack: "..stack)
end)

RecalculateStats.add(function(actor, api)
    -- Add 10 maxhp per stack
    local stack = actor:item_count(item)
    api.maxhp_add(10 * stack)
end)

Callback.add(Callback.ON_HIT_PROC, function(actor, victim, hit_info)
    print("'blueCircle' ON_HIT_PROC")
    print(victim.hp)
    print("Stack: "..actor:item_count(item))

    print(hit_info, hit_info.value, hit_info.RAPI)
    print(hit_info.x)

    local inf = hit_info.inflictor
    print(inf)
    print(inf.value, inf.RAPI)
end)