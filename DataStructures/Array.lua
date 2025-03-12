-- Array test

function ArrayTest()
    local output = "\n"
    function add_to_output(...)
        for _, s in ipairs{...} do
            output = output..tostring(s).." "
        end
        output = output.."\n"
    end


    add_to_output("=== Array tests ===")
    
    local arr1 = Array.new()
    arr1:push(1, 200, 345, "abc", 1000, "def")
    arr1:delete(3)
    add_to_output("arr1: ", arr1:get(3), arr1[4], "\n")   -- arr1: 1000 1000

    local arr2 = Array.new({5, 4, 3, 2, 100})
    arr2:set(0, 500)
    arr2[2] = arr2[2] * 100
    arr2:delete_value(3)
    add_to_output("arr2 size: ", arr2:size(), #arr2)
    for i, v in ipairs(arr2) do
        add_to_output(i, v)
    end
    add_to_output()

    local arr3 = Array.new(5, 10)
    local n = arr3:pop()
    arr3:insert(2, 45)
    add_to_output("arr3: ", n, arr3:get(2))
    arr3:clear()
    add_to_output("arr3 new size: ", arr3:size(), "\n")

    local arr4 = Array.new({1, 6, 4, 5, 2, 9, 3, 8, 7, 0})
    add_to_output("arr4 pos of 9: ", arr4:find(9))
    add_to_output("contains 2? 73?: ", arr4:contains(2), arr4:contains(73))
    arr4:sort()
    for i, v in ipairs(arr4) do
        add_to_output(i, v)
    end


    print(output)
end

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
]]