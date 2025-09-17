-- ImGui

-- if true then return true end    -- debug

do
    local units = {
        ['seconds'] = 1,
        ['milliseconds'] = 1000,
        ['microseconds'] = 1000000,
        ['nanoseconds'] = 1000000000
    }

    function benchmark(unit, decPlaces, n, f, ...)
        local elapsed = 0
        local multiplier = units[unit]
        for i = 1, n do
            local now = os.clock()
            f(...)
            elapsed = elapsed + (os.clock() - now)
        end
        print(string.format('Benchmark results:\n  - %d function calls\n  - %.'.. decPlaces ..'f %s elapsed\n  - %.'.. decPlaces ..'f %s avg execution time.\n  - Leeway: '..(16.66 / ((elapsed / n) * multiplier)), n, elapsed * multiplier, unit, (elapsed / n) * multiplier, unit))
    end
end


gui.add_imgui(Util.jit_off(function()
    if ImGui.Begin("ExampleMod") then

        if ImGui.Button("a") then
            local a = Array.new()

            local fn = function()
                a:set(0, 123)
            end

            Util.benchmark(10000, fn)
        end
        
        if ImGui.Button("make perma array") then
            array = Array.new()
            array[1] = 123
            print(array[1])
        end

        if ImGui.Button("set perma array") then
            array[1] = 123
            print(array[1])
        end

        if ImGui.Button("b") then
            local a = Array.new()
            local s = Struct.new()
            print(Wrap.wrap(a.value))
            print(Wrap.wrap(s.value))
        end

        if ImGui.Button("p") then
            local p = Player.get_local()
            print(p, p.value)
            print(p.CInstance)
            -- print(p.hp)
            -- p.hp = 50

            -- p:print_variables()

            local c = p:get_collisions(gm.constants.oLizard)
            for _, inst in ipairs(c) do
                print(inst.value)
            end
        end

        if ImGui.Button("Player.get_local benchmark") then
            Util.benchmark(10000, Player.get_local)
        end

        if ImGui.Button("Global test") then
            -- print(Global.mouse_x)
            Global.abcdef = 123456
            -- gm.variable_global_set("abcdef", 1234)
            -- gm.call("variable_global_set", "abcdef", 1234)
            -- print(gm.variable_global_get("abcdef"))
            print(Global.abcdef)

            -- print(Global.pPoison)
            -- Global.pPoison = 4
            -- print(Global.pPoison)
            -- Global.pPoison = 10
        end

        if ImGui.Button("gm vs GM instance_find") then
            Util.benchmark(10000, gm.instance_find, gm.constants.oP, 0)
            Util.benchmark(10000, GM.instance_find, gm.constants.oP, 0)
            Util.benchmark(10000, gm.instance_find, gm.constants.oP, 0)
            Util.benchmark(10000, GM.instance_find, gm.constants.oP, 0)
        end

        if ImGui.Button("gm vs GM _mod_instance_find") then
            Util.benchmark(10000, gm._mod_instance_find, gm.constants.oP, 1)
            Util.benchmark(10000, GM._mod_instance_find, gm.constants.oP, 1)
            Util.benchmark(10000, gm._mod_instance_find, gm.constants.oP, 1)
            Util.benchmark(10000, GM._mod_instance_find, gm.constants.oP, 1)

            -- local p = GM._mod_instance_find(gm.constants.oP, 1)
            -- print(p)
            -- if p then p.hp = 50 end
        end

        if ImGui.Button("benchmark instance_create") then
            local obj = Object.wrap(gm.constants.oLizard)
            Util.benchmark(200, gm.instance_create, 0, 0, gm.constants.oLizard)
            Util.benchmark(200, GM.instance_create, 0, 0, gm.constants.oLizard)
            Util.benchmark(200, obj.create, obj, 0, 0)
            Util.benchmark(200, gm.instance_create, 0, 0, gm.constants.oLizard)
            Util.benchmark(200, GM.instance_create, 0, 0, gm.constants.oLizard)
            Util.benchmark(200, obj.create, obj, 0, 0)
        end

        if ImGui.Button("set inst test") then
            local p = Player.get_local()
            print(p.value, p.CInstance)

            local a = Array.new()
            a:push(p, p.value)
            print(a[1], a[2])
        end

        if ImGui.Button("spawn 100 lem") then
            local p = Player.get_local()
            for i = 1, 100 do
                Object.find("lizard"):create(p.x, p.y)
            end
        end

        if ImGui.Button("print item properties") then
            Item.find("barbedWire"):print_properties()
        end

        if ImGui.Button("Spawn all crates") then
            local player = Player.get_local()
            if Instance.exists(player) then
                gm.instance_create(player.x - 80, player.y, gm.object_find("ror-generated_CommandCrate_0"))
                gm.instance_create(player.x - 40, player.y, gm.object_find("ror-generated_CommandCrate_1"))
                gm.instance_create(player.x,      player.y, gm.object_find("ror-generated_CommandCrate_2"))
                gm.instance_create(player.x + 40, player.y, gm.object_find("ror-generated_CommandCrate_3"))
                gm.instance_create(player.x + 80, player.y, gm.object_find("ror-generated_CommandCrate_4"))
            end
        end

    end
    ImGui.End()
end))


-- gm.post_script_hook(gm.constants.step_actor, function(self, other, result, args)

-- end)


-- Return status
return true