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

        if ImGui.Button("Spawn 1 Lemurian on the player") then
            local p = Player.get_local()
            if p:exists() then
                local obj = Object.find("lizard")
                obj:create(p.x, p.y)
            end
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

        if ImGui.Button("What is the type for ref?") then
            local holder = RValue.new_holder(2)
            holder[0] = RValue.new(gm.constants.oP)
            holder[1] = RValue.new(0)
            local out = RValue.new(0)
            gmf.instance_find(out, nil, nil, 2, holder)
            print(out, out.i32, out.i64, out.type)  -- cdata<struct RValue>: 0x0155d91a7e20 101153  9221120237041192480LL   15
                                                    -- Existn't:  cdata<struct RValue>: 0x0155d91a7e98  -4  -4607182418800017408LL  0
        end

        if ImGui.Button("CInstance vs Instance") then
            local holder = RValue.new_holder(2)
            holder[0] = RValue.new(gm.constants.oP)
            holder[1] = RValue.new(0)
            local out = RValue.new(0)
            gmf.instance_find(out, nil, nil, 2, holder)
            
            local inst = RValue.to_wrapper(out)
            -- local inst2 = ffi.cast("struct CInstance*", out.i64)
            local what = gm.CInstance.instance_id_to_CInstance_ffi[inst.id]
            -- print(out.i64, what)
            local inst2 = ffi.cast("struct CInstance*", what)
            local inst3 = gm.instance_find(gm.constants.oP, 0)

            function foo()
                local a = inst.x
                -- inst.x = inst.x + 0.001
            end
            function bar()
                local a = inst2.x
                -- inst2.x = inst2.x + 0.001
            end
            function bar2()
                local a = inst3.x
                -- inst3.x = inst3.x + 0.001
            end

            print(inst, inst2, inst3)

            print(inst.x, inst2.x)
            Util.benchmark(100000, foo)
            Util.benchmark(100000, bar)
            Util.benchmark(100000, bar2)
            print(inst.x, inst2.x)
        end

        if ImGui.Button("a") then
            print("=== a ===")
            Util.benchmark(100000, Instance.find, gm.constants.oP)
            Util.benchmark(100000, GM.instance_find, gm.constants.oP, 0)
            Util.benchmark(100000, gm.instance_find, gm.constants.oP, 0)
            Util.benchmark(100000, GM.instance_find, gm.constants.oLizard, 0)
            Util.benchmark(100000, gm.instance_find, gm.constants.oLizard, 0)
        end


        if ImGui.Button("b") then
            print("=== b ===")
            Util.benchmark(100000, Instance.exists, -4)
            Util.benchmark(100000, GM.instance_exists, -4)
            Util.benchmark(100000, gm.instance_exists, -4)
        end


        if ImGui.Button("c - item_count") then
            local p = Instance.find(gm.constants.oP)
            if not p:exists() then return end
            print(p:item_count(0, 3))

            print("=== c ===")
            Util.benchmark(100000, p.item_count, p, 0, 3)
        end


        if ImGui.Button("d") then
            local p = Instance.find(gm.constants.oP)
            if not p:exists() then return end
            
            local foo = function(p)
                return p.CInstance
            end

            local bar = function(p)
                return ffi.cast("struct CInstance*", gm.CInstance.instance_id_to_CInstance_ffi[p.value])
            end

            print("=== d ===")
            Util.benchmark(100000, foo, p)
            Util.benchmark(100000, bar, p)
        end


        if ImGui.Button("give a meatNugget") then
            local p = Instance.find(gm.constants.oP)
            if not p:exists() then return end
            p:item_give(0, 1, Item.StackKind.TEMPORARY_BLUE)
        end


        if ImGui.Button("take a meatNugget") then
            local p = Instance.find(gm.constants.oP)
            if not p:exists() then return end
            p:item_take(0, 1, 0)
        end


        if ImGui.Button("give 5 ghearts") then
            local p = Instance.find(gm.constants.oP)
            if not p:exists() then return end
            p:item_give(Item.find("guardiansHeart"), 5)
        end

        
        if ImGui.Button("create like 100000 tables") then
            for i = 1, 100000 do
                local a = {}
            end
            print("done")
        end


        if ImGui.Button("add callback") then
            var1 = Callback.add(Callback.ON_DEATH, function(actor, died_to_void)
                print("2", actor, died_to_void)
            end, -10)
            var2 = Callback.add(Callback.ON_DEATH, function(actor, died_to_void)
                print("1", actor, died_to_void)
            end)
        end


        if ImGui.Button("remove callbacks") then
            Callback.remove(var1)
            Callback.remove(var2)
        end


        if ImGui.Button("print meatNugget properties") then
            Item.find("meatNugget"):show_properties()
        end


        if ImGui.Button("filter items by tier 0") then
            local commons = Item.find_all(0, Item.Property.TIER)
            for _, v in ipairs(commons) do
                print(v.identifier)
            end
        end


        if ImGui.Button("Benchmark Item.find_all 2") then
            Util.benchmark(10000, Item.find_all, "ror")
            Util.benchmark(10000, Item.find_all, 0, Item.Property.TIER)
        end


        if ImGui.Button("print tier/pool properties") then
            ItemTier.find("uncommon"):show_properties()
            LootPool.find("uncommon"):show_properties()

            local arr = ItemTier.find("uncommon").pickup_head_shape
            for i, v in ipairs(arr) do
                print(i, v)
                for j, w in ipairs(v) do
                    print(" ", j, w)
                end
            end

            -- Set common lootpool to be uncommon loot pool
            -- LootPool.find("common").drop_pool = LootPool.find("uncommon").drop_pool
        end


        if ImGui.Button("Script.bind test to var1") then
            local foo = function()
                print("Bound function run!")
            end

            var1 = Script.bind(foo)
            Util.print(var1, var1.self, var1.other)
            var1()
        end


        if ImGui.Button("Run var1") then
            var1()
        end


        if ImGui.Button("Struct.print test") then
            local struct = Struct.new()
            struct.def = 123
            struct.ghi = 456
            struct:print()

            local array = Array.new(10)
            array[4] = 123
            array:print()
        end


        if ImGui.Button("instance_number once (1)") then
            print(GM.instance_number(gm.constants.oP))
        end

        
        if ImGui.Button("_mod_instance_number once (1)") then
            print(GM._mod_instance_number(gm.constants.oP))
        end


        if ImGui.Button("_mod_net_message_begin") then
            local b = GM._mod_net_message_begin()
            print(b)    -- is a number

            -- local b = Buffer._mod_net_message_begin()
            -- print(b)

            local holder = RValue.new_holder(1)
            holder[0] = RValue.new(10000)
            local out = RValue.new(0)
            gmf.buffer_exists(out, nil, nil, 1, holder)
            RValue.peek(out)
        end


        if ImGui.Button("Player fire bullet") then
            local p = Player.get_local()
            if not p:exists() then return end
            p:fire_bullet(p.x, p.y, 1000, 90 - (p.image_xscale * 90), 1)

            print(p:is_grounded())
            print(p:is_climbing())
        end


        if ImGui.Button("Player fire bullet benchmark") then
            local p = Player.get_local()
            if not p:exists() then return end
            Util.benchmark(500, p.fire_bullet,
                p, p.x, p.y, 1000, 90 - (p.image_xscale * 90), 1, 0.5
            )
        end


        if ImGui.Button("recalc stats") then
            local p = Player.get_local()
            if not p:exists() then return end
            for i = 1, 100 do p:recalculate_stats() end
        end


        if ImGui.Button("save player for hotload") then
            if not saved_player then
                local p = Player.get_local()
                if not p:exists() then return end
                saved_player = p
            end

            if saved_player then
                print(saved_player)
                print(saved_player:test())
            end
        end


        if ImGui.Button("call new Actor.test") then
            Actor.test()
        end


        if ImGui.Button("Make and store new array") then
            var3 = Array.new()
            var3[1] = 1234

            for k, v in pairs(var3) do
                print(k, v)
            end
        end


        if ImGui.Button("Check if array exists") then
            print(var3, var3[1])
        end


        if ImGui.Button("map:set test") then
            local m = Map.new()
            Util.benchmark(10000, m.set, m, "abc", 123)
            m:destroy()
        end


        if ImGui.Button("Spawn 1 target dummy") then
            local player = Player.get_local()
            if player:exists() then
                local obj = Object.find("dummy")
                local inst = obj:create(player.x, player.y)
                inst.depth = 2
                inst.hp = 1000000000
                inst.maxhp, inst.maxhp_base = inst.hp, inst.hp
            end
        end


        if ImGui.Button("what") then
            local res = GM.team_canhit(3, 3)   -- attacking_team, target_team
            print(res)
            print(GM.team_get_name(3))
            print(GM.actor_canhit(Player.get_local(), Player.get_local()))  -- attacker, target
        end


        if ImGui.Button("get_collisions benchmark") then
            local p = Player.get_local()
            if not p:exists() then return end
            Util.benchmark(1000, p.get_collisions, p, gm.constants.oDummy)
        end


        if ImGui.Button("give player 1 whimstar") then
            local p = Player.get_local()
            if not p:exists() then return end
            p:item_give(Item.find("whimsicalStar", "aphelion"))
        end


        if ImGui.Button("_mod_instance_find") then
            -- local p = GM._mod_instance_find(gm.constants.oP, 1)
            -- print(p)

            -- local i = GM._mod_instance_find(Object.find("whimsicalStarObject", "aphelion"), 1)
            -- print(i)
            -- i.y = i.y - 100

            local star = Instance.find(Object.find("whimsicalStarObject", "aphelion"))
            if star:exists() then
                star.y = star.y - 100
            end

            print(Instance.count(Object.find("whimsicalStarObject", "aphelion")))
            
            -- local p = GM._mod_instance_findAll(gm.constants.oP)
            -- print(p)

            -- local p = GM._mod_instance_nearest(gm.constants.oP, 0, 0)
            -- print(p)

            -- local i = GM._mod_instance_nearest(Object.find("whimsicalStarObject", "aphelion"), 0, 0)
            -- print(i)

            -- local i = GM.instance_find(Object.find("whimsicalStarObject", "aphelion"), 0)
            -- print(i)

            -- local arr = Array.new()
            -- print(#arr)
            -- GM.instance_nearest_array(gm.constants.oP, 0, 0, arr)
            -- print(#arr)
        end


        if ImGui.Button("instance find benchmark!!") then
            print(GM.instance_find(gm.constants.oP, 0))
            print(GM._mod_instance_nearest(gm.constants.oP, 0, 0))

            Util.benchmark(10000, GM.instance_find, gm.constants.oP, 0) -- instance_find is faster so use for non-custom objs
            Util.benchmark(10000, GM._mod_instance_nearest, gm.constants.oP, 0, 0)
            Util.benchmark(10000, GM.instance_find, gm.constants.oP, 0)
            Util.benchmark(10000, GM._mod_instance_nearest, gm.constants.oP, 0, 0)
        end


        if ImGui.Button("lua_place_meeting") then
            local p = Player.get_local()
            print(GM.SO.lua_place_meeting(p, nil, p.x, p.y, gm.constants.oLizard))
            print(GM.SO.lua_place_meeting(p, nil, p.x, p.y, Object.find("whimsicalStarObject", "aphelion")))

            -- print(GM.SO.lua_instance_place(p, nil, p.x, p.y, gm.constants.oLizard, gm.constants.oLizard))    -- crash
            
            -- works?? but always returns the instance
            print(GM.SO.lua_instance_place(p, nil, p.x, p.y, Object.find("whimsicalStarObject", "aphelion"), Object.find("whimsicalStarObject", "aphelion")))
            
            -- print(GM.SO.lua_instance_place(p, nil, p.x, p.y, Object.find("whimsicalStarObject", "aphelion"), 1)) -- crash
        end


        if ImGui.Button("Instance.find") then
            print(Instance.find(gm.constants.oP))

            local star = Instance.find(Object.find("whimsicalStarObject", "aphelion"))
            print(star)
            if star:exists() then
                star.y = star.y - 10
            end
            
            print(Instance.find(10000).value)
        end

        if ImGui.Button("Instance.find_all benchmark") then
            -- local insts = Instance.find_all(Object.find("whimsicalStarObject", "aphelion"))
            -- for _, inst in ipairs(insts) do
            --     inst.y = inst.y - 20
            -- end

            -- local obj = Object.find("whimsicalStarObject", "aphelion")
            -- Util.benchmark(10000, Instance.find_all, obj)

            -- Given 100 Lemurians, logically the first benchmark
            -- should run about 100x faster (give or take) than the second
            Util.benchmark(10000, Instance.find, gm.constants.oLizard)
            Util.benchmark(10000, Instance.find_all, gm.constants.oLizard)
        end

        if ImGui.Button("get_collisions benchmarks") then
            local p = Player.get_local()
            if not p:exists() then return end
            Util.benchmark(10000, p.get_collisions, p, gm.constants.oLizard)
            -- Util.benchmark(10000, p.get_collisions_2, p, gm.constants.oLizard)
            -- Util.benchmark(10000, p.get_collisions, p, gm.constants.oLizard)
            -- Util.benchmark(10000, p.get_collisions_2, p, gm.constants.oLizard)
            print(#p:get_collisions(gm.constants.oLizard))
            -- print(#p:get_collisions_2(gm.constants.oLizard))
        end

        if ImGui.Button("get_collisions custom test") then
            local p = Player.get_local()
            if not p:exists() then return end

            local obj = Object.find("whimsicalStarObject", "aphelion")
            local insts = p:get_collisions(obj)
            print(#insts)

            Util.benchmark(10000, p.get_collisions, p, obj)
        end

        if ImGui.Button("is_colliding tests") then
            local p = Player.get_local()
            if not p:exists() then return end

            print(p:is_colliding(gm.constants.oLizard))

            local obj = Object.find("whimsicalStarObject", "aphelion")
            local bool = p:is_colliding(obj)
            print(bool)

            Util.benchmark(10000, p.is_colliding, p, gm.constants.oLizard)
            Util.benchmark(10000, p.is_colliding, p, obj)
        end

        if ImGui.Button("_mod_instance_findAll test") then
            -- local obj = Object.find("whimsicalStarObject", "aphelion")
            -- GM._mod_instance_findAll(obj)
            GM._mod_instance_findAll(gm.constants.oLizard)
            -- print("a", gm.constants.oLizard)
            
            -- print("a", GM._mod_instance_findAll(gm.constants.oJelly))
            -- print("a", gm.constants.oJelly)
        end

        if ImGui.Button("print balls") then
            -- print(balls)

            Util.benchmark(10000, GM._mod_instance_findAll, gm.constants.oLizard)   -- lower than should be since
                                                                                    -- calling GM instead of dedicated
        end

        if ImGui.Button("spawn magma worm") then
            local p = Player.get_local()
            if not p:exists() then return end
            Object.find("worm"):create(p.x, p.y)
        end

        -- if ImGui.Button("Instance.find_all benchmark 2") then
        --     print(#Instance.find_all(gm.constants.oLizard))
        --     print(#Instance.find_all_2(gm.constants.oLizard))

        --     Util.benchmark(1000, Instance.find_all, gm.constants.oLizard)
        --     Util.benchmark(1000, Instance.find_all_2, gm.constants.oLizard)
        --     Util.benchmark(1000, Instance.find_all, gm.constants.oLizard)
        --     Util.benchmark(1000, Instance.find_all_2, gm.constants.oLizard)
        -- end

    end
    ImGui.End()
end)

Hook.add("damager_calculate_damage", Hook.PRE,
    function(self, other, result, args)
        for i, v in ipairs(args) do
            print(i, v)
        end
        print("-----")

        -- `true_hit` is the actual instance hit
        -- `hit` is the actor hit (which `true_hit` might be a part of, like with worm segments)
    end
)

local ptr = gm.get_script_function_address(gm.constants.damager_calculate_damage)
-- memory.dynamic_hook_mid("_mod_instance_findAll_vanilla", {"rax"}, {"RValue*"}, 0, ptr:add(0x3BE), Util.jit_off(function(args)
--     -- print(args[1].value, args[1].type, getmetatable(args[1]).__name)
--     args[1].value = 1000000
--     -- print(args[1].value.id)
--     -- print(GM.object_get_name(args[1].value.object_index))
-- end))

memory.dynamic_hook_mid("_mod_instance_findAll_vanilla", {"r14", "rsp+128h", "rbp+20h"}, {"RValue**", "RValue**", "RValue*"}, 0, ptr:add(0x438D), Util.jit_off(function(args)
    -- Get argument array (stored in register `r14` of type `RValue**`)
    local args_typed = ffi.cast("struct RValue**", args[1]:get_address())
    args_typed[3].value = 1000000   -- arg 3 is `damage`

    -- print("args_typed_2")
    -- local args_typed_2 = ffi.cast("struct RValue**", args[2]:get_address())
    -- print(args_typed_2[0], getmetatable(args_typed_2[0]).__name)
    -- print(GM.object_get_name(Instance.wrap(args_typed_2[1].i32).object_index))  -- oP
    -- print(GM.object_get_name(Instance.wrap(args_typed_2[2].i32).object_index))  -- oDummy
    -- print(args_typed_2[3], getmetatable(args_typed_2[3]).__name)
    -- print(args_typed_2[4], getmetatable(args_typed_2[4]).__name)
    
    -- print("args_typed_3")
    -- local args_typed_3 = ffi.cast("struct RValue**", args[3]:get_address())
    -- print(args_typed_3[0], getmetatable(args_typed_3[0]).__name)
    -- print(args_typed_3[1], getmetatable(args_typed_3[1]).__name)
    -- print(args_typed_3[2], getmetatable(args_typed_3[2]).__name)
    -- print(args_typed_3[3], getmetatable(args_typed_3[3]).__name)
    -- print(args_typed_3[4], getmetatable(args_typed_3[4]).__name)
    -- print(args_typed_3[5], getmetatable(args_typed_3[5]).__name)
    -- print(args_typed_3[6], getmetatable(args_typed_3[6]).__name)
    -- print(args_typed_3[7], getmetatable(args_typed_3[7]).__name)
    -- print(args_typed_3[8], getmetatable(args_typed_3[8]).__name)
    
    args[3].value = 1000000
    print(args[3].value)    -- damage_fake !!!

    -- print("args_typed_4")
    -- local args_typed_4 = ffi.cast("struct RValue**", args[3]:get_address())
    -- print(args_typed_4[0], getmetatable(args_typed_4[0]).__name)
end))

-- local ptr = gm.get_script_function_address(gm.constants._mod_instance_findAll)
-- 
-- Memory.dynamic_hook("_mod_instance_findAll", "void*", {"void*", "void*", "void*", "int", "void*"}, ptr,
--     -- Pre-hook
--     {function(ret_val, self, other, result, arg_count, args)
--         print("pre")
--         -- insts = {}
--     end,

--     -- Post-hook
--     function(ret_val, self, other, result, arg_count, args)
--         -- Return this somehow for actual fn
--         print("post")
--         -- for _, inst in ipairs(insts) do
--         --     print(inst)
--         -- end
--     end}
-- )

-- -- -- TODO

-- -- -- local fn = function(args)
-- -- --     print("find custom")
-- -- --     print(args[1].value)
-- -- -- end
-- -- -- jit.off(fn)
-- -- -- memory.dynamic_hook_mid("ExampleMod._mod_instance_findAll_custom", {"rdi"}, {"RValue*"}, 0, ptr:add(0x304), fn)

-- Memory.dynamic_hook_mid("_mod_instance_findAll_vanilla", {"rsp+50h"}, {"RValue*"}, 0, ptr:add(0x44E), function(args)
--     print("find vanilla")

--     -- -- print(args[1].value, getmetatable(args[1].value).__name)    -- sol.CInstance*
--     -- -- print(args[1].value.id)

--     -- table.insert(insts, Instance.wrap(args[1].value.id))    -- might be slow since sol
-- end)



-- local fn = function(args)
--     print("find vanilla 2")
--     print(args[1].value)
--     print(args[1].type)
-- end
-- jit.off(fn)
-- memory.dynamic_hook_mid("ExampleMod._mod_instance_findAll.25", {"rsp+88h"}, {"RValue*"}, 0, ptr:add(0x474), fn)

-- local fn = function(args)
--     print("find vanilla 123")
--     print(args[1].value, getmetatable(args[1].value).__name)
-- end
-- jit.off(fn)
-- memory.dynamic_hook_mid("Examp123213", {"rsp+138h"}, {"RValue*"}, 0, ptr:add(0x474), fn)

-- memory.dynamic_hook_mid("ExampleMod._mod_instance_findAll.25", {"^32.8"}, {"RValue*"}, 0, ptr:add(0x474), function(args)
--     print("find vanilla")
--     print(args[1].value)
-- end)

-- memory.dynamic_hook_mid("ExampleMod._mod_instance_findAll.2", {}, {}, 0, ptr:add(0x474), function(args)
--     print("find vanilla plsss")
-- end)

Hook.add("gml_Object_oInit_Draw_73", Hook.POST, function(self, other)
    -- print("gml_Object_oInit_Draw_73 - post")
    -- print(self)
    -- print(other)
    Draw.circle(200, 200, 50)
end)

Hook.add("team_canhit", Hook.POST, function(self, other, result, args)
    print("team_canhit - post")
    print(self)
    print(other)
    print(result.value)
    print(args)
end)

-- Hook.add("instance_number", Hook.PRE, function(self, other, result, args)
--     print("instance_number - pre")
--     print(self)
--     print(other)
--     print(result.value)
--     print(args)

--     result.value = 1
-- end)

Hook.add("instance_number", Hook.POST, function(self, other, result, args)
    print("instance_number - post")
    print(self)
    print(other)
    print(result.value)
    print(args)

    -- result.value = 1
end)

-- Hook.add("damager_calculate_damage", Hook.POST, function(self, other, result, args)
--     Util.gm_trace()
-- end)

-- Hook.add("instance_create", Hook.PRE, function(self, other, result, args)
--     print("instance_create - pre")
--     print(self)
--     print(other)
--     print(result)
--     for i, v in ipairs(args) do
--         print(i, v)
--     end

--     args[2] = args[2] - 100
-- end)

-- Hook.add("_mod_instance_number", Hook.PRE, function(self, other, result, args)
--     print("_mod_instance_number - pre")
--     print(self)
--     print(other)
--     print(result)
--     print(args)
-- end)

-- Hook.add("_mod_instance_number", Hook.POST, function(self, other, result, args)
--     print("_mod_instance_number - post")
--     print(self)
--     print(other)
--     print(result)
--     print(args)
-- end)

-- memory.dynamic_hook("examplemod.instance_number", "void*", {"void*", "void*", "void*", "int", "void*"}, gm.get_script_function_address(gm.constants.instance_number),
--     -- Pre-hook
--     {function(ret_val, result, self, other, arg_count, args)
--         local arg_count = arg_count:get()
--         local args_typed = ffi.cast("struct RValue*", args:get_address())

--         print("args_typed[0]", args_typed[0])
--         print(args_typed[0].type)
--         print(args_typed[0].value)
--     end,

--     -- Post-hook
--     function(ret_val, result, self, other, arg_count, args)
--         local arg_count = arg_count:get()
--         local args_typed = ffi.cast("struct RValue*", args:get_address())

--         print("post args_typed[0]", args_typed[0])
--         print(args_typed[0].type)
--         print(args_typed[0].value)
--     end}
-- )

-- memory.dynamic_hook("examplemod._mod_instance_number", "void*", {"void*", "void*", "void*", "int", "void*"}, gm.get_script_function_address(gm.constants._mod_instance_number),
--     -- Pre-hook
--     {function(ret_val, self, other, result, arg_count, args)
--         local arg_count = arg_count:get()
--         local args_typed = ffi.cast("struct RValue**", args:get_address())

--         -- Cast and wrap `self`
--         local self_address = self:get_address()
--         print("self_address", self_address)
--         local self_cdata = ffi.cast("YYObjectBase *", self_address)
--         print("self_cdata", self_cdata)
--     end,

--     -- Post-hook
--     nil}
-- )

-- memory.dynamic_hook("examplemod_find", "void*", {"void*", "void*", "void*", "int", "void*"}, gm.get_script_function_address(gm.constants.instance_find),
--     -- Pre-hook
--     {nil,

--     -- Post-hook
--     function(ret_val, self, other, result, arg_count, args)
--         local res = nil
--         local address = result:get_address()
--         print(address)
--         if address ~= 0 then res = ffi.cast("CInstance*", address) end
--         if res then print("res", res.hp) end
--     end}
-- )

-- Hook.add("instance_find", Hook.POST, function(self, other, result, args)
--     print("instance_find")
--     print(self)
--     print(other)
--     print(result)
--     for i, v in ipairs(args) do
--         print(i, v)
--     end
-- end)

-- Hook.add("instance_create", Hook.POST, function(self, other, result, args)
--     print("instance_create")
--     print(self)
--     print(other)
--     print(result)
--     for i, v in ipairs(args) do
--         print(i, v)
--     end
-- end)

-- memory.dynamic_hook("ExampleMod.instance_create", "void*", {"void*", "void*", "void*", "int", "void*"}, gm.get_script_function_address(gm.constants.instance_create),
--     -- Pre-hook
--     {function(ret_val, self, other, result, arg_count, args)
--         print("Create!")
--     end,

--     -- Post-hook
--     function(ret_val, self, other, result, arg_count, args)
--         -- print("Create!")
--     end}
-- )

-- memory.dynamic_hook("ExampleMod.skill_recalculate_stats", "void*", {"void*", "void*", "void*", "int", "void*"}, gm.get_script_function_address(gm.constants.anon_ActorSkill_gml_GlobalScript_scr_actor_skills_83921016_ActorSkill_gml_GlobalScript_scr_actor_skills),
--     -- Pre-hook
--     {function(ret_val, self, other, result, arg_count, args)
--         -- self = nil  -- Does nothing?
--     end,

--     -- Post-hook
--     function(ret_val, self, other, result, arg_count, args)
        
--     end}
-- )

-- Return status
return true