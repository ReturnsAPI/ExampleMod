-- Struct tests

function StructTest()
    local output = "\n"
    function add_to_output(...)
        for _, s in ipairs{...} do
            output = output..tostring(s).." "
        end
        output = output.."\n"
    end


    add_to_output("=== Struct tests ===")

    local s1 = Struct.new()
    add_to_output(s1.abc)
    s1.abc = 123
    s1.def = "ghi"
    s1.guh = 1000
    add_to_output(s1.abc)
    add_to_output(s1.def)
    add_to_output(s1.guh)
    for k, v in pairs(s1) do
        add_to_output(k, v)
    end
    local keys = s1:get_keys()
    for _, key in pairs(keys) do
        add_to_output(key)
    end


    print(output)
end

-- Expected output from prints:
--[[
        -- empty (nil)
123
ghi
1000
abc 123
def ghi
guh 1000
abc
def
guh
]]