-- GM test

local exit = true

if GM then
    if GM.instance_number(gm.constants.oP) ~= 0 then log.warning("9_GM: 'instance_number(gm.constants.oP)' is "..tostring(GM.instance_number(gm.constants.oP)).."; expected 0"); exit = false end
else log.warning("9_GM: GM does not exist"); exit = false
end

return exit