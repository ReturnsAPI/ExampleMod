-- ReadOnly test

local t = {100, 200, 350}
t.abc = "def"
t[4] = 12

local read = ReadOnly.new(t)

-- Tests
if read[1] ~= 100 then log.warning("read[1] is "..tostring(read[1]).."; expected 100") end
if read[2] ~= 200 then log.warning("read[2] is "..tostring(read[2]).."; expected 200") end
if read[3] ~= 350 then log.warning("read[3] is "..tostring(read[3]).."; expected 350") end
if read[4] ~= 12 then log.warning("read[4] is "..tostring(read[4]).."; expected 12") end
if read.abc ~= "def" then log.warning("read.abc is "..tostring(read.abc).."; expected \"def\"") end

status, err = pcall(function()
    read[2] = 1000
end)
if status then log.warning("Setting worked somehow; read[2] is now "..tostring(read[2])) end

-- Return status
return true