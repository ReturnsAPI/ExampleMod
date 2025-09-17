-- Networking

if not Initialize then return false end

local packet, packet2

gui.add_imgui(function()
    if ImGui.Begin("ExampleMod Networking") then

        if ImGui.Button("Host: Send to clients") then
            packet:send_to_all("Testing!")
        end

        if ImGui.Button("Client: Send to host") then
            packet:send_to_host("Testing!")
        end

        if ImGui.Button("Host: Send to clients inst") then
            local p = Player.get_local()
            if not Instance.exists(p) then return end
            packet2:send_to_all(p)
        end

        if ImGui.Button("Client: Send to host inst") then
            local p = Player.get_local()
            if not Instance.exists(p) then return end
            packet2:send_to_host(p)
        end

        if ImGui.Button("Fire bullet") then
            local p = Player.get_local()
            if not Instance.exists(p) then return end
            p:fire_bullet(p.x, p.y, 1000, 90 - (p.image_xscale * 90), 1, nil, nil, Tracer.BANDIT1)
        end

    end
    ImGui.End()
end)

-- DamageCalculate.add(function(api)
--     if not Net.is_online() then return end

--     local hook_args_names = {
--         "hit_info",
--         "true_hit",
--         "hit",
--         "damage",
--         "critical",
--         "parent",
--         "proc",
--         "attack_flags",
--         "damage_col",
--         "team",
--         "climb",
--         "percent_hp",
--         "xscale",
--         "hit_x",
--         "hit_y",
--     }
    
--     print("")
--     for _, k in ipairs(hook_args_names) do
--         print(k, api[k])
--     end
-- end)

local function init()
    network_hotloaded = true

    packet = Packet.new()
    packet:set_serializers(
        function(buffer, str)
            buffer:write_string(str)
        end,

        function(buffer)
            local str = buffer:read_string()
            print(str)
        end
    )

    packet2 = Packet.new()
    packet2:set_serializers(
        function(buffer, inst)
            buffer:write_instance(inst)
        end,

        function(buffer)
            local inst = buffer:read_instance()
            print(inst, inst.m_id)
        end
    )
end
Initialize.add(init)
if network_hotloaded then init() end

-- Return status
return true