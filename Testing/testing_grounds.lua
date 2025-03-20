-- -- Playing around with Lua 5.1's newproxy

-- local proxy = newproxy(true)

-- print(type(proxy))
-- local mt = getmetatable(proxy)
-- -- mt.abc = "def"
-- mt.__index = function(t, k)
--     return getmetatable(t)[k]
-- end
-- mt.__newindex = function(t, k, v)
--     getmetatable(t)[k] = v
-- end
-- mt.__metatable = "nope :)"
-- mt.__gc = function(t) print("Collect me !!") end
-- print(getmetatable(proxy))

-- local table = {abc = "def"}

-- local foo = function()
--     local a = proxy.abc
-- end

-- local bar = function()
--     local a = table.abc
-- end

-- local px = Proxy.new()
-- px.abc = "def"

-- local bar2 = function()
--     local a = px.abc
-- end

-- -- local p2 = Proxy2.new({abc = "def"}, {})

-- -- local bar3 = function()
-- --     local a = p2.abc
-- -- end

-- benchmark(10000000, foo)
-- benchmark(10000000, bar)
-- benchmark(10000000, bar2)
-- benchmark(10000000, bar)
-- benchmark(10000000, bar2)
-- -- benchmark(10000000, bar3)
-- -- benchmark(10000000, bar2)

-- log.info("metatable", getmetatable(proxy))

-- -- print(proxy.abc)
-- -- proxy.abc = "ghi"
-- -- print(proxy.abc)
-- -- print(proxy.abcd)
-- -- proxy.abcd = "jkl"
-- -- print(proxy.abcd)

-- -- Metatable nesting test
-- -- local t = {}
-- -- local mt = {__index = {}}
-- -- local mt2 = {__index = {abc = "def"}}
-- -- setmetatable(t, mt)
-- -- setmetatable(mt.__index, mt2)
-- -- print(t.abc)

-- -- -- internal gc test
-- -- function setmetatable_gc(t, mt)
-- --     -- `setmetatable` but with `__gc` metamethod enabled
-- --     local prox = newproxy(true)
-- --     getmetatable(prox).__gc = function() mt.__gc(t) end
-- --     t[prox] = true
-- --     return setmetatable(t, mt)
-- -- end

-- -- setmetatable_gc({}, {
-- --     __gc = function(t)
-- --         print("I'm collected!")
-- --     end
-- -- })

-- -- collectgarbage("collect")

-- Return status
return true