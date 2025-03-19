-- ExampleMod

-- mods["LuaENVY-ENVY"].auto()  -- Seems to break hotloading
mods["ReturnsAPI-ReturnsAPI"].auto()

PATH = _ENV["!plugins_mod_folder_path"].."/"


local testing_status = {}

-- Load directories
local files = path.get_files(PATH.."Testing")
for _, file in ipairs(files) do
    local status = require(file)
    table.insert(testing_status, {path.filename(file), status})
end

-- Print testing status
log.info("========== Testing Log ==========")
for _, status in ipairs(testing_status) do
    if status[2] then   log.info("✓ "..path.filename(status[1]).." passed")
    else                log.info("✗ "..path.filename(status[1]).." failed")
    end
end
log.info("=================================")


-- Symbols: ✓ ✗

-- gui.add_imgui(function()
--     if ImGui.Begin("Testing") then

--         if ImGui.Button("Spawn a Lemurian") then
            
--         end
    
--     end
--     ImGui.End()
-- end)