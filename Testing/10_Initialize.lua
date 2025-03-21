-- GM test

local exit = true

if Initialize then
    Initialize(function()
        print("ExampleMod priority -2")
    end, -2)

    Initialize(function()
        print("ExampleMod priority 10")
    end, 10)

    Initialize(function()
        print("ExampleMod priority -100")
    end, -100)

    Initialize(function()
        print("ExampleMod priority 0")
    end)
else log.warning("10_Initialize: Initialize does not exist"); exit = false
end

return exit