-- Blue Circle

local item = Item.new("blueCircle")

item:set_sprite(Sprite.new("blueCircle", PATH.."Items/Sprites/blueCircle.png", 1, 16, 16))
item:set_tier(ItemTier.COMMON)

ItemLog.new_from_item(item)

Callback.add(item.on_acquired, function(actor, stack)
    print("Picked up 'blueCircle'")
    print(actor, stack)
end)