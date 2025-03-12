-- Array tests

gui.add_imgui(function()
    if ImGui.Begin("Array") then

        if ImGui.Button("Run tests") then
            print("=== Array tests ===")
            local arr = Array.new()
            arr:push(1, 2, 100, 456)    -- [1, 2, 100, 456]
            arr:delete(2)               -- [1, 2, 456]
            print(arr:get(2))           -- > 456
            print(arr[3])               -- > 456
            print(arr[4])               -- > nil  (doing this with arr:get() will print an error instead)
            print(arr[-1])              -- > nil
            arr:push("abc", 123, "de")  -- [1, 2, 456, "abc", 123, "de"]
            arr:insert(4, 1000)         -- [1, 2, 456, "abc", 1000, 123, "de"]
            arr:delete_value(123)       -- [1, 2, 456, "abc", 1000, "de"]
            print(arr:contains(456))    -- > true
            print(arr:contains(999))    -- > false
            arr:sort(true)              -- [1000, 456, 2, "de", "abc", 1]
            print(arr[5])               -- > "abc"
            for i, v in ipairs(arr) do  -- > Print array line-by-line -- [1000, 456, 2, "de", "abc", 1]
                print(i, v)
            end
            local c = arr:pop()         -- [1000, 456, 2, "de", "abc"], c = 1
            print(c)                    -- > 1
            print(#arr)                 -- > 5
            print(arr:size())           -- > 5
            arr:set(2, 200)             -- [1000, 456, 200, "de", "abc"]
            arr[4] = "defg"             -- [1000, 456, 200, "defg", "abc"]
            for i, v in ipairs(arr) do  -- > Print array line-by-line -- [1000, 456, 200, "defg", "abc"]
                print(i, v)
            end
            arr:clear()                 -- []
            print(#arr)                 -- > 0
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