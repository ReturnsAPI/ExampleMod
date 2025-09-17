-- ExampleMod

PATH = _ENV["!plugins_mod_folder_path"].."/"

mods["LuaENVY-ENVY"].auto()  -- Seems to break hotloading
mods["ReturnsAPI-ReturnsAPI"].auto()


-- Load directories
local init = function()
    hotload = true

    local dirs = path.get_directories(PATH)
    for _, dir in ipairs(dirs) do
        local files = path.get_files(dir)
        for _, file in ipairs(files) do
            require(file)
        end
    end
end
Initialize.add(init)
if hotload then init() end