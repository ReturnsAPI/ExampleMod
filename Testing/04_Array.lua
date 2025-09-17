-- Array test

local exit = true

local arr1 = Array.new()
arr1:push(1, 200, 345, "abc", 1000, "def")
arr1:delete(3)
if arr1:get(3) ~= 1000 then log.warning("4_Array: arr1:get(3) is "..tostring(arr1:get(3)).."; expected 1000"); exit = false end
if arr1[4] ~= 1000 then log.warning("4_Array: arr1[4] is "..tostring(arr1[4]).."; expected 1000"); exit = false end

local arr2 = Array.new({5, 4, 3, 2, 100})
arr2:set(0, 500)
arr2[2] = arr2[2] * 100
arr2:delete_value(3)
if arr2:size() ~= 4 then log.warning("4_Array: arr2:size() is "..tostring(arr2:size()).."; expected 4"); exit = false end
if #arr2 ~= 4 then log.warning("4_Array: #arr2 is "..tostring(#arr2).."; expected 4"); exit = false end
local goal = {500, 400, 2, 100}
for i, v in ipairs(arr2) do
    if v ~= goal[i] then log.warning("4_Array: arr2["..i.."] is "..tostring(v).."; expected "..goal[i]); exit = false end
end

local arr3 = Array.new(5, 10)
local n = arr3:pop()
arr3:insert(2, 45)
if n ~= 10 then log.warning("4_Array: n is "..tostring(n).."; expected 10"); exit = false end
if arr3:get(2) ~= 45 then log.warning("4_Array: arr3:get(2) is "..tostring(arr3:get(2)).."; expected 45"); exit = false end
arr3:clear()
if arr3:size() ~= 0 then log.warning("4_Array: arr3:size() is "..tostring(arr3:size()).."; expected 0"); exit = false end

local arr4 = Array.new({1, 6, 4, 5, 2, 9, 3, 8, 7, 0})
if arr4:find(9) ~= 5 then log.warning("4_Array: arr4:find(9) is "..tostring(arr4:find(9)).."; expected 5"); exit = false end
if arr4:contains(2) ~= true then log.warning("4_Array: arr4:contains(2) is "..tostring(arr4:contains(2)).."; expected true"); exit = false end
if arr4:contains(73) ~= false then log.warning("4_Array: arr4:contains(73) is "..tostring(arr4:contains(73)).."; expected false"); exit = false end
arr4:sort()
local goal = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
for i, v in ipairs(arr4) do
    if v ~= goal[i] then log.warning("4_Array: arr4["..i.."] is "..tostring(v).."; expected "..goal[i]); exit = false end
end

local arr5 = Array.wrap(arr4)
-- if Array.is(arr4) ~= true then log.warning("4_Array: Array.is(arr4) is "..tostring(Array.is(arr4)).."; expected true"); exit = false end
-- if Array.is(arr5) ~= true then log.warning("4_Array: Array.is(arr5) is "..tostring(Array.is(arr5)).."; expected true"); exit = false end

-- Return status
return exit



-- if  ~=  then log.warning("4_Array:  is "..tostring().."; expected "); exit = false end

-- Expected output from prints:
--[[
arr1:  1000 1000

arr2 size:  4 4
1 500
2 400
3 2
4 100

arr3:  10 45
arr3 new size:  0

arr4 pos of 9:  5
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
true true
]]