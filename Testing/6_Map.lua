-- Map test

local exit = true

local map1 = Map.new()
map1:set("abc", 123)
map1.def = 456
if map1.abc ~= 123 then log.warning("6_Map: map1.abc is "..tostring(map1.abc).."; expected 123"); exit = false end
if map1:get("def") ~= 456 then log.warning("6_Map: map1:get(\"def\") is "..tostring(map1:get("def")).."; expected 456"); exit = false end

local goal = {foo = 1000, bar = 42069, werl = "zyxw", boolValue = true, deleteMe = 1}
local map2 = Map.new(goal)
map2:delete("deleteMe")
for k, v in pairs(map2) do
    if v ~= goal[k] then log.warning("6_Map: map2."..k.." is "..tostring(v).."; expected "..tostring(goal[k])); exit = false end
end
if map2:size() ~= 4 then log.warning("6_Map: map2:size() is "..map2:size().."; expected 4"); exit = false end
if #map2 ~= 4 then log.warning("6_Map: #map2 is "..#map2.."; expected 4"); exit = false end
map2:clear()
if #map2 ~= 0 then log.warning("6_Map: #map2 is "..#map2.."; expected 0"); exit = false end

map1:destroy()
map2:destroy()

-- Return status
return exit