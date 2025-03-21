-- GM test

local exit = true

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

return exit