-- GM test

local exit = true

if Initialize then
    Initialize.add(function()
        print("ExampleMod priority -2")
    end, -2)

    Initialize.add(function()
        print("ExampleMod priority 10")
    end, 10)

    Initialize.add(function()
        print("ExampleMod priority -100")
    end, -100)

    Initialize.add(function()
        print("ExampleMod priority 0")
    end)
else log.warning("10_Initialize: Initialize does not exist"); exit = false
end

return exit