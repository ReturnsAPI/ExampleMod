-- ImGui

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


gui.add_imgui(function()
    if ImGui.Begin("ExampleMod") then

        if ImGui.Button("Skip teleporter") then
            local p = Player.get_local()
            local tp = Instance.find(gm.constants.oTeleporter)
            if not tp:exists() then tp = Instance.find(gm.constants.oTeleporterEpic) end
            if p:exists() and tp:exists() then
                p.x, p.y = tp.x, tp.y - 12
                tp.active = 3
            end
        end

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

        if ImGui.Button("create 100000 holders and rvalues at once") then
            local function foo()
                RValue.new_holder(1)
                RValue.new(0)
            end

            Util.benchmark(100000, foo)
        end

        if ImGui.Button("player count") then
            print(GM.instance_number(gm.constants.oP))
        end

        if ImGui.Button("player count benchmark") then
            -- Util.benchmark(100000, gm.instance_number, gm.constants.oP)
            -- Util.benchmark(100000, GM.instance_number, gm.constants.oP)

            -- jit.on(gmf.instance_number)

            local foo = function(obj)
                local holder = RValue.new_holder_scr(1)
                holder[0] = RValue.new(obj)
                local out = RValue.new(0)
                gmf._mod_instance_number(nil, nil, out, 1, holder)
                return RValue.to_wrapper(out)
            end

            local bar = function(obj)
                local holder = RValue.new_holder_scr(1)
                holder[0] = RValue.new(obj)
                local out = RValue.new(0)
                gmf._mod_instance_number_func_ptr(nil, nil, out, 1, holder)
                return RValue.to_wrapper(out)
            end

            benchmark("milliseconds", 5, 10000, gm._mod_instance_number, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, GM._mod_instance_number, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, foo, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, bar, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, Instance.count, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, Instance.count, gm.constants.oP)
        end

        if ImGui.Button("player count benchmark 2") then
            local foo = function(obj)
                local holder = RValue.new_holder(1)
                holder[0] = RValue.new(obj)
                local out = RValue.new(0)
                gmf.instance_number(out, nil, nil, 1, holder)
                return RValue.to_wrapper(out)
            end
            
            local holder = RValue.new_holder(1)
            local out = RValue.new(0)
            local bar = function(obj)
                holder[0] = RValue.new(obj)
                gmf.instance_number(out, nil, nil, 1, holder)
                return RValue.to_wrapper(out)
            end

            -- print(jit.status())

            -- jit.on(gmf.instance_number)

            benchmark("milliseconds", 5, 10000, gm.instance_number, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, GM.instance_number, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, foo, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, bar, gm.constants.oP)
            benchmark("milliseconds", 5, 10000, gm.instance_number, gm.constants.oP)
        end

        if ImGui.Button("instance find player") then
            benchmark("milliseconds", 5, 10000, gm.instance_find, gm.constants.oP, 0)
            benchmark("milliseconds", 5, 10000, GM.instance_find, gm.constants.oP, 0)
            -- benchmark("milliseconds", 5, 100000, foo, gm.constants.oP)
        end

        if ImGui.Button("instance find player 2") then
            benchmark("milliseconds", 5, 10000, gm._mod_instance_find, gm.constants.oP, 0)
            benchmark("milliseconds", 5, 10000, GM._mod_instance_find, gm.constants.oP, 0)
            -- benchmark("milliseconds", 5, 100000, foo, gm.constants.oP)
            print(gm._mod_instance_find(gm.constants.oP, 0))
        end

        if ImGui.Button("item find") then
            benchmark("milliseconds", 5, 100000, gm.item_find, "ror-meatNugget")
            benchmark("milliseconds", 5, 100000, GM.item_find, "ror-meatNugget")
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

        if ImGui.Button("Find and kill player") then
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

                print(Object.find("lizard"))
                print(Object.find("lizard", "~"))
                print(Object.find("lizard", "ror"))
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

        if ImGui.Button("gm.CInstance.instance_id_to_CInstance_ffi size") then
            print(#gm.CInstance.instance_id_to_CInstance_ffi)
            local player = Player.get_local()
            if player:exists() then
                local v = gm.CInstance.instance_id_to_CInstance_ffi[player.value]
                print(v)
                print(gm.CInstance.instance_id_to_CInstance_ffi[v])
            end
        end

        if ImGui.Button("player get object index self") then
            local player = Player.get_local()
            if player:exists() then
                local script = player.get_object_index_self
                print(script)
                print(player:get_object_index_self())
            end
        end

        if ImGui.Button("print entire player.buff_stack") then
            local player = Player.get_local()
            if player:exists() then
                local arr = player.buff_stack
                for i, v in ipairs(arr) do
                    print(i - 1, v)
                end
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

        if ImGui.Button("Log all vanilla particles") then
            local player = Player.get_local()
            local parts = Particle.find_all("ror")
            for i, part in ipairs(parts) do
                print(part:get_identifier(), part.value)
                if player:exists() then
                    part:create(player.x, player.y)
                end
            end
        end

        if ImGui.Button("Item.find_all common") then
            local items = Item.find_all(ItemTier.COMMON, Item.Property.TIER)
            for _, v in ipairs(items) do
                print(v.value, v.identifier, v.namespace)
            end
        end

        if ImGui.Button("Benchmark Item.find_all") then
            Util.benchmark(1000, Item.find_all)
            Util.benchmark(1000, Item.find_all, ItemTier.COMMON, Item.Property.TIER)
        end

        if ImGui.Button("Buff.find_all") then
            local buffs = Buff.find_all()
            for _, v in ipairs(buffs) do
                print(v.value, v.identifier, v.namespace)
            end
        end

        -- if ImGui.Button("jit.on draw_circle") then
        --     jit.on(gmf.draw_circle)
        -- end

        -- if ImGui.Button("jit.off draw_circle") then
        --     jit.off(gmf.draw_circle)
        -- end
        
        if ImGui.Button("Benchmark drawing") then
            local foo = function(x, y, r, outline)
                local holder = RValue.new_holder(4)
                holder[0] = RValue.new(x)
                holder[1] = RValue.new(y)
                holder[2] = RValue.new(r)
                holder[3] = RValue.new(outline)
                gmf.draw_circle(RValue.new(0), nil, nil, 4, holder)
            end

            print("gm")
            Util.benchmark(10000, gm.draw_circle, 0, 0, 10, false)
            print("GM")
            Util.benchmark(10000, GM.draw_circle, 0, 0, 10, false)
            print("foo")
            Util.benchmark(10000, foo, 0, 0, 10, false)
            print("Draw")
            Util.benchmark(10000, Draw.circle, 0, 0, 10, false)
            print("gm")
            Util.benchmark(10000, gm.draw_circle, 0, 0, 10, false)
        end

        if ImGui.Button("GM.instance_find") then
            local inst = GM.instance_find(gm.constants.oP, 0)
            print(inst)
            -- print(inst, getmetatable(inst).__name, inst.id)
            -- print(memory.get_usertype_pointer(inst))

            local struct = gm.struct_create()
            print(struct, getmetatable(struct).__name)
            local pointer = memory.get_usertype_pointer(struct)
            print(pointer)
            local yyobj = ffi.cast("struct YYObjectBase*", pointer)
            print("yyobj", yyobj)
            local s1 = Struct.wrap_yyobjectbase(yyobj)
            print("abc", s1.abc)
            s1.abc = 1234
            print("new abc", s1.abc)

            local s2 = Struct.new()
            print(s2.value)

            local arr = gm.array_create(5, 10)
            print(arr[1])
            local pointer = memory.get_usertype_pointer(arr)
            print(pointer)
            local arr2 = Array.wrap_i64(pointer)
            print(arr2[1])
        end

        if ImGui.Button("Give player 1 greenSquare") then
            local p = Player.get_local()
            if p:exists() then
                p:item_give(Item.find("greenSquare"), 1)
            end
        end

        if ImGui.Button("Give player 126 greenSquare") then
            local p = Player.get_local()
            if p:exists() then
                p:item_give(Item.find("greenSquare"), 126)
            end
        end

        if ImGui.Button("Move all t1 stages to t2 (error stream)") then
            Stage.find("desolateForest"):set_tier(2)
            Stage.find("driedLake"):set_tier(2)
        end

        if ImGui.Button("Move all t2 stages to t3") then
            Stage.find("dampCaverns"):set_tier(3)
            Stage.find("skyMeadow"):set_tier(3)
        end

        if ImGui.Button("Move Dried Lake to new tier 6") then
            Stage.find("driedLake"):set_tier(6)
        end

        if ImGui.Button("Move Dried Lake back to tier 1") then
            Stage.find("driedLake"):set_tier(1)
        end

        if ImGui.Button("Move Dried Lake to tier 100") then
            Stage.find("driedLake"):set_tier(100)
        end

        if ImGui.Button("Stage.show_tiers") then
            Stage.show_tiers()
        end

        if ImGui.Button("Instance set benchmark") then
            local p = Player.get_local()
            if not p:exists() then return end
            local cinst = gm.instance_find(gm.constants.oP, 0)
            if cinst == -4 then return end

            print(p, cinst)

            local function foo()
                p.abc = 123
            end

            local function bar()
                cinst.abc = 123
            end

            Util.benchmark(100000, foo)
            Util.benchmark(100000, bar)
        end

    end
    ImGui.End()
end)

-- Return status
return true