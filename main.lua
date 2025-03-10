-- ExampleMod

mods["LuaENVY-ENVY"].auto()
mods["ReturnsAPI-ReturnsAPI"].auto()

PATH = _ENV["!plugins_mod_folder_path"].."/"


-- Load directories
local dirs = path.get_directories(PATH)
for _, dir in ipairs(dirs) do
    local files = path.get_files(dir)
    for _, file in ipairs(files) do
        require(file)
    end
end