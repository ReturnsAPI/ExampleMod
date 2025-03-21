-- Util.type test

local exit = true

if Util then
    local ro = ReadOnly.new()
    if Util.type(ro) ~= "ReadOnly" then log.warning("3_Util_type: Util.type(ro) is not ReadOnly"); exit = false end
    if type(ro) ~= "ReadOnly" then log.warning("3_Util_type: type(ro) is not ReadOnly"); exit = false end
else log.warning("3_Util_type: Util does not exist"); exit = false
end

-- Return status
return exit