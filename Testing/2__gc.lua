-- __gc test

local exit = true

local sum = 0

local mt = {
    __index = function(t, k) return Proxy.get(t)[k] end,
    __newindex = function(t, k, v) Proxy.get(t)[k] = v end,
    __gc = function(t) sum = sum + Proxy.get(t).abc end
}

local p = Proxy.new({}, mt)
p.abc = 123

local p2 = Proxy.new({}, mt)
p2.abc = 456

collectgarbage()

if sum ~= 579 then log.warning("2__gc: sum is "..tostring(sum).."; expected 579"); exit = false end

-- Return status
return exit