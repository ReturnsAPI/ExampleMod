-- List tests

gui.add_imgui(function()
    if ImGui.Begin("List") then

        if ImGui.Button("Run tests") then
            print("=== List tests ===")
            local list = List.new()
            list:add(1, 2, 100, 456)     -- [1, 2, 100, 456]
            list:delete(2)               -- [1, 2, 456]
            print(list:get(2))           -- > 456
            print(list[3])               -- > 456
            print(list[4])               -- > nil  (doing this with list:get() will print an error instead)
            print(list[-1])              -- > nil
            list:add("abc", 123, "de")   -- [1, 2, 456, "abc", 123, "de"]
            list:insert(4, 1000)         -- [1, 2, 456, "abc", 1000, 123, "de"]
            list:delete_value(123)       -- [1, 2, 456, "abc", 1000, "de"]
            print(list:contains(456))    -- > true
            print(list:contains(999))    -- > false
            list:sort(true)              -- [1000, 456, 2, "de", "abc", 1]
            print(list[5])               -- > "abc"
            for i, v in ipairs(list) do  -- > Print array line-by-line -- [1000, 456, 2, "de", "abc", 1]
                print(i, v)
            end
            print(list[6])               -- > 1
            list:delete(5)               -- [1000, 456, 2, "de", "abc"]
            print(#list)                 -- > 5
            print(list:size())           -- > 5
            list:set(2, 200)             -- [1000, 456, 200, "de", "abc"]
            list[4] = "defg"             -- [1000, 456, 200, "defg", "abc"]
            for i, v in ipairs(list) do  -- > Print array line-by-line -- [1000, 456, 200, "defg", "abc"]
                print(i, v)
            end
            list:clear()                 -- []
            print(#list)                 -- > 0
        end
    
    end
    ImGui.End()
end)

-- Expected output from prints:
--[[
456
456
nil
nil
true
false
abc
1       1000
2       456
3       2
4       de
5       abc
6       1
1
5
5
1       1000
2       456
3       200
4       defg
5       abc
0
]]