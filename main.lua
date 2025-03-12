-- ExampleMod

-- mods["LuaENVY-ENVY"].auto()  -- Seems to break hotloading
mods["ReturnsAPI-ReturnsAPI"].auto()

PATH = _ENV["!plugins_mod_folder_path"].."/"


-- Load directories
local init = function()
    local dirs = path.get_directories(PATH)
    for _, dir in ipairs(dirs) do
        local files = path.get_files(dir)
        for _, file in ipairs(files) do
            require(file)
        end
    end
end
init()
-- Initialize(init)
-- if hotload then init() end
-- hotload = true