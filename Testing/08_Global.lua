-- Global test

local exit = true

if Global then
    if Global.time_stop ~= 0 then log.warning("8_Global: 'time_stop' is "..tostring(Global.time_stop).."; expected 0"); exit = false end
    if Global.pPoison ~= 10 then log.warning("8_Global: 'pPoison' is "..tostring(Global.pPoison).."; expected 10"); exit = false end
    Global.ExampleMod_test = "abcdefg"
    if Global.ExampleMod_test ~= "abcdefg" then log.warning("8_Global: 'ExampleMod_test' is "..tostring(Global.ExampleMod_test).."; expected \"abcdefg\""); exit = false end
else log.warning("8_Global: Global does not exist"); exit = false
end

return exit