-- Array test

local exit = true

local list1 = List.new()
list1:add(1, 200, 345, "abc", 1000, "def")
list1:delete(3)
if list1:get(3) ~= 1000 then log.warning("5_List: list1:get(3) is "..tostring(list1:get(3)).."; expected 1000"); exit = false end
if list1[4] ~= 1000 then log.warning("5_List: list1[4] is "..tostring(list1[4]).."; expected 1000"); exit = false end

local list2 = List.new({5, 4, 3, 2, 100})
list2:set(0, 500)
list2[2] = list2[2] * 100
list2:delete_value(3)
if list2:size() ~= 4 then log.warning("5_List: list2:size() is "..tostring(list2:size()).."; expected 4"); exit = false end
if #list2 ~= 4 then log.warning("5_List: #list2 is "..tostring(#list2).."; expected 4"); exit = false end
local goal = {500, 400, 2, 100}
for i, v in ipairs(list2) do
    if v ~= goal[i] then log.warning("5_List: list2["..i.."] is "..tostring(v).."; expected "..goal[i]); exit = false end
end

local list3 = List.new({10, 10, 10, 10, 10})
local n = list3[5]
list3:delete(4)
list3:insert(2, 45)
if n ~= 10 then log.warning("5_List: n is "..tostring(n).."; expected 10"); exit = false end
if list3:get(2) ~= 45 then log.warning("5_List: list3:get(2) is "..tostring(list3:get(2)).."; expected 45"); exit = false end
list3:clear()
if list3:size() ~= 0 then log.warning("5_List: list3:size() is "..tostring(list3:size()).."; expected 0"); exit = false end

local list4 = List.new({1, 6, 4, 5, 2, 9, 3, 8, 7, 0})
if list4:find(9) ~= 5 then log.warning("5_List: list4:find(9) is "..tostring(list4:find(9)).."; expected 5"); exit = false end
if list4:contains(2) ~= true then log.warning("5_List: list4:contains(2) is "..tostring(list4:contains(2)).."; expected true"); exit = false end
if list4:contains(73) ~= false then log.warning("5_List: list4:contains(73) is "..tostring(list4:contains(73)).."; expected false"); exit = false end
list4:sort()
local goal = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
for i, v in ipairs(list4) do
    if v ~= goal[i] then log.warning("5_List: list4["..i.."] is "..tostring(v).."; expected "..goal[i]); exit = false end
end

list1:destroy()
list2:destroy()
list3:destroy()
list4:destroy()

-- Return status
return exit



-- if  ~=  then log.warning("5_List:  is "..tostring().."; expected "); exit = false end

-- Expected output from prints:
--[[
list1:  1000 1000

list2 size:  4 4
1 500
2 400
3 2
4 100

list3:  10 45
list3 new size:  0

list4 pos of 9:  5
contains 2? 73?:  true false
1 0
2 1
3 2
4 3
5 4
6 5
7 6
8 7
9 8
10 9
]]