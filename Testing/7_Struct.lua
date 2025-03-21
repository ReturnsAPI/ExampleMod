-- Struct tests

local exit = true

local s1 = Struct.new()
if s1.abc ~= nil then log.warning("7_Struct: s1.abc is "..tostring(s1.abc).."; expected nil"); exit = false end
s1.abc = 123
s1.def = "ghi"
s1.guh = 1000
if s1.abc ~= 123 then log.warning("7_Struct: s1.abc is "..tostring(s1.abc).."; expected 123"); exit = false end
if s1.def ~= "ghi" then log.warning("7_Struct: s1.def is "..tostring(s1.def).."; expected \"ghi\""); exit = false end
if s1.guh ~= 1000 then log.warning("7_Struct: s1.guh is "..tostring(s1.guh).."; expected 1000"); exit = false end
local goal = {abc = 123, def = "ghi", guh = 1000}
for k, v in pairs(s1) do
    if v ~= goal[k] then log.warning("7_Struct: s1."..k.." is "..tostring(v).."; expected "..tostring(goal[k])); exit = false end
end
local keys = s1:get_keys()
local goal = {abc = true, def = true, guh = true}
for _, key in ipairs(keys) do
    if not goal[key] then log.warning("7_Struct: "..key.." does not exist in s1"); exit = false end
end
if #s1 ~= 3 then log.warning("7_Struct: #s1 is "..#s1.."; expected 3"); exit = false end

local s2 = Struct.wrap(s1)
if not Struct.is(s1) then log.warning("7_Struct: s1 is not a Struct"); exit = false end
if not Struct.is(s2) then log.warning("7_Struct: s2 is not a Struct"); exit = false end

return exit



-- Expected output from prints:
--[[
        -- empty (nil)
123
ghi
1000
abc 123
def ghi
guh 1000
abc
def
guh
true true
]]