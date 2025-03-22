-- Blue Circle

local init = function()
    local item = Item.find("barbedWire")
    if not item then log.warning("13_Item_find: item does not exist") end
    if item.value ~= 7 then log.warning("13_Item_find: item.value is not equal to 7") end

    item_gind_hotloaded = true
end
Initialize(init)
if item_find_hotloaded then init() end

-- Return status
return true