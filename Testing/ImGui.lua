-- ImGui

gui.add_imgui(function()
    if ImGui.Begin("ExampleMod") then

        if ImGui.Button("Collect garbage") then
            collectgarbage()
        end

        if ImGui.Button("array __gc test") then
            for i = 1, 10000 do
                Array.new()
            end
        end

        if ImGui.Button("struct __gc test") then
            for i = 1, 10000 do
                Struct.new()
            end
        end

        if ImGui.Button("#__ref_map") then
            Map.print_refmap_count()
        end

        if ImGui.Button("map test") then
            local map = Map.new()
            print(map.abc)
            map.abc = 123
            print(map.abc, type(map))
            map.def = 456
            map.ghi = 789
            for k, v in pairs(map) do
                print(k, v)
            end

            local foo = function()
                for k, v in pairs(map) do
                    -- print(k, v)
                end
            end
            Util.benchmark(10000, foo)

            map:destroy()
        end

        if ImGui.Button("hotload proxy preservation") then
            if not p then p = Proxy.new(); p.abc = 123 end
            print(p.abc)
        end
    
    end
    ImGui.End()
end)

-- Return status
return true