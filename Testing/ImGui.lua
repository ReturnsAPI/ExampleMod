-- ImGui

gui.add_imgui(function()
    if ImGui.Begin("GC") then

        if ImGui.Button("Collect") then
            collectgarbage("collect")
        end

        if ImGui.Button("m") then
            if not guhh then guhh = Proxy.new(); guhh.abc = 123 end
            print(guhh.abc)
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
    
    end
    ImGui.End()
end)

-- Return status
return true