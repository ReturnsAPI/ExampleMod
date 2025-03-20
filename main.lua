-- ExampleMod

-- mods["LuaENVY-ENVY"].auto()  -- Seems to break hotloading
mods["ReturnsAPI-ReturnsAPI"].auto()
gmf = require("ReturnOfModding-GLOBAL/gmf")

PATH = _ENV["!plugins_mod_folder_path"].."/"


local testing_status = {}

-- Load directories
local files = path.get_files(PATH.."Testing")
for _, file in ipairs(files) do
    local status = require(file)
    table.insert(testing_status, {path.filename(file), status})
    if status then  log.info("✓  "..path.filename(file).." passed")
    else            log.info(" ✗ "..path.filename(file).." failed")
    end
end

-- Print testing status
log.info("========== Testing Log ==========")
for _, status in ipairs(testing_status) do
    if status[2] then   log.info("✓  "..path.filename(status[1]).." passed")
    else                log.info(" ✗ "..path.filename(status[1]).." failed")
    end
end
log.info("=================================")


-- Symbols: ✓ ✗

-- gui.add_imgui(function()
--     if ImGui.Begin("GC") then

--         if ImGui.Button("Collect") then
--             collectgarbage("collect")
--         end
            
--         if ImGui.Button("the") then
--             local proxy = Proxy.new()
--             rawget(proxy, "abc")
--             rawget(getmetatable(proxy), "abc")
--         end

--         if ImGui.Button("global ud set") then
--             local proxy = Proxy.new()
--             print(proxy)
--             -- gm.variable_global_set("myGlobal", proxy)

--             local holder = ffi.new("struct RValue[2]")
--             local rvalue = ffi.new("struct RValue[1]")
--             gmf.yysetstring(rvalue, "myGlobal")
--             holder[0] = rvalue[0]
--             holder[1] = ffi.new("struct RValue")
--             holder[1].type = 3
--             holder[1].i64 = proxy
--             local out = ffi.new("struct RValue")
--             gmf.variable_global_set(out, nil, nil, 2, holder)
--         end

--         if ImGui.Button("global ud get") then
--             -- local proxy = gm.variable_global_get("myGlobal")
--             -- print(proxy)

--             local holder = ffi.new("struct RValue[1]")
--             local rvalue = ffi.new("struct RValue[1]")
--             gmf.yysetstring(rvalue, "myGlobal")
--             holder[0] = rvalue[0]
--             local out = ffi.new("struct RValue")
--             gmf.variable_global_get(out, nil, nil, 1, holder)
--             print(out.value)
--         end
    
--     end
--     ImGui.End()
-- end)