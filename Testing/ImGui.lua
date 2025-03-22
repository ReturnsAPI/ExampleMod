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

        if ImGui.Button("player count") then
            print(GM.instance_number(gm.constants.oP))
        end

        if ImGui.Button("instance_number benchmark") then
            Util.benchmark(10000, GM.instance_number, gm.constants.oP)

            local foo = function(obj)
                local holder = RValue.new_holder(1)
                holder[0] = RValue.new(obj)
                local out = RValue.new(0)
                gmf.instance_number(out, nil, nil, 1, holder)
                return RValue.to_wrapper(out)
            end

            local bar = function(obj)
                local holder = RValue.new_holder(1)
                holder[0] = RValue.from_wrapper(obj)
                local out = RValue.new(0)
                gmf.instance_number(out, nil, nil, 1, holder)
                return RValue.to_wrapper(out)
            end
            
            Util.benchmark(10000, foo, gm.constants.oP)
            Util.benchmark(10000, bar, gm.constants.oP)
            Util.benchmark(10000, foo, gm.constants.oP)
            Util.benchmark(10000, bar, gm.constants.oP)

            print(foo(gm.constants.oP))
            print(bar(gm.constants.oP))
        end

        if ImGui.Button("Find player") then
            local p = Instance.find(gm.constants.oP)
            print(p)
            print(p.value, p.id, type(p))
            print("hp", p.hp)
            p:actor_kill()
            print("new hp", p.hp)
        end

        if ImGui.Button("Spawn 10 Lemurians on the player") then
            local p = Player.get_local()
            print(p, p.value)
            if p:exists() then
                local obj = Object.find("lizard")
                print(obj, obj.value)
                for i = 1, 10 do obj:create(p.x, p.y) end
            end
        end

        if ImGui.Button("Spawn 100 Lemurians on the player") then
            local p = Player.get_local()
            if p:exists() then
                local obj = Object.find("lizard")
                for i = 1, 100 do obj:create(p.x, p.y) end
            end
        end

        if ImGui.Button("Kill all Lemurians") then
            -- GM.instance_destroy(gm.constants.oLizard)
            local lems = Instance.find_all(gm.constants.oLizard)
            for _, lem in ipairs(lems) do
                lem:actor_kill()
            end
        end

        if ImGui.Button("Get Barbed Wire item (and give 1 to player if they exist)") then
            local item = Item.find("barbedWire")
            print(item, item.value)
            print(item.namespace, item.identifier)

            item:show_properties()

            local p = Player.get_local()
            if p:exists() then p:item_give(item, 2) end
            if p:exists() then p:item_take(item, 1) end
        end

        -- if ImGui.Button("New item test") then
        --     local item = Item.new("myItem")
        --     item:set_sprite(Sprite.new("blueCircle", "~/blueCircle.png", 1, 16, 16))
        --     item:set_tier(0)
        --     ItemLog.new_from_item(item)

        --     print(item.value)
        --     item:show_properties()
        -- end

        if ImGui.Button("Spawn all crates") then
            local player = Player.get_local()
            if player:exists() then
                gm.instance_create(player.x - 80, player.y, gm.object_find("ror-generated_CommandCrate_0"))
                gm.instance_create(player.x - 40, player.y, gm.object_find("ror-generated_CommandCrate_1"))
                gm.instance_create(player.x, player.y, gm.object_find("ror-generated_CommandCrate_2"))
                gm.instance_create(player.x + 40, player.y, gm.object_find("ror-generated_CommandCrate_3"))
                gm.instance_create(player.x + 80, player.y, gm.object_find("ror-generated_CommandCrate_4"))
            end
        end

        if ImGui.Button("Benchmark actor:item_count") then
            local player = Player.get_local()
            if player:exists() then
                Util.benchmark(100000, player.item_count, player, 0)
            end
        end

        if ImGui.Button("Benchmark actor:buff_count") then
            local player = Player.get_local()
            if player:exists() then
                Util.benchmark(100000, player.buff_count, player, 0)
                -- Util.benchmark(100000, player.buff_count2, player, 0)
            end
        end

        if ImGui.Button("player.buff_stack?") then
            local player = Player.get_local()
            if player:exists() then
                print(player.buff_stack)
            end
        end

        if ImGui.Button("Apply buff 0 to player") then
            local player = Player.get_local()
            if player:exists() then
                player:buff_apply(0, 300)
                print(player:buff_count(0))
            end
        end

        if ImGui.Button("Apply buff banditSkull to player") then
            local player = Player.get_local()
            if player:exists() then
                player:buff_apply(Buff.find("banditSkull"), 300)
                print(player:buff_count(Buff.find("banditSkull")))
            end
        end

        if ImGui.Button("Get buff banditSkull stack count") then
            local player = Player.get_local()
            if player:exists() then
                print(player:buff_count(Buff.find("banditSkull")))
            end
        end

        if ImGui.Button("Apply buff blueCircle to player") then
            local player = Player.get_local()
            if player:exists() then
                player:buff_apply(Buff.find("blueCircle"), 300)
                print(Buff.find("blueCircle").value)
            end
        end

        if ImGui.Button("Log these buffs") then
            local buffs = Class.Buff
            for i, v in ipairs(buffs) do
                print(i, v[1], v[2])
            end
        end
    
    end
    ImGui.End()
end)

-- Return status
return true