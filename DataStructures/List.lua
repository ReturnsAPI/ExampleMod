-- List test

function ListTest()
    local output = "\n"
    function add_to_output(...)
        for _, s in ipairs{...} do
            output = output..tostring(s).." "
        end
        output = output.."\n"
    end


    add_to_output("=== List tests ===")
    
    local list1 = List.new()
    list1:add(1, 200, 345, "abc", 1000, "def")
    list1:delete(3)
    add_to_output("list1: ", list1:get(3), list1[4], "\n")   -- list1: 1000 1000

    local list2 = List.new({5, 4, 3, 2, 100})
    list2:set(0, 500)
    list2[2] = list2[2] * 100
    list2:delete_value(3)
    add_to_output("list2 size: ", list2:size(), #list2)
    for i, v in ipairs(list2) do
        add_to_output(i, v)
    end
    add_to_output()

    local list3 = List.new({10, 10, 10, 10, 10})
    local n = list3[5]
    list3:delete(4)
    list3:insert(2, 45)
    add_to_output("list3: ", n, list3:get(2))
    list3:clear()
    add_to_output("list3 new size: ", list3:size(), "\n")

    local list4 = List.new({1, 6, 4, 5, 2, 9, 3, 8, 7, 0})
    add_to_output("list4 pos of 9: ", list4:find(9))
    add_to_output("contains 2? 73?: ", list4:contains(2), list4:contains(73))
    list4:sort()
    for i, v in ipairs(list4) do
        add_to_output(i, v)
    end
    
    list1:destroy()
    list2:destroy()
    list3:destroy()
    list4:destroy()


    print(output)
end

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