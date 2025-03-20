-- ReadOnly test

local exit = true

local t = {100, 200, 350}
t.abc = "def"
t[4] = 12

local read = ReadOnly.new(t)

-- Tests
if read[1] ~= 100 then log.warning("1_ReadOnly: read[1] is "..tostring(read[1]).."; expected 100"); exit = false end
if read[2] ~= 200 then log.warning("1_ReadOnly: read[2] is "..tostring(read[2]).."; expected 200"); exit = false end
if read[3] ~= 350 then log.warning("1_ReadOnly: read[3] is "..tostring(read[3]).."; expected 350"); exit = false end
if read[4] ~= 12 then log.warning("1_ReadOnly: read[4] is "..tostring(read[4]).."; expected 12"); exit = false end
if read.abc ~= "def" then log.warning("1_ReadOnly: read.abc is "..tostring(read.abc).."; expected \"def\""); exit = false end

local status, err = pcall(function()
    read[2] = 1000
end)
if status then log.warning("Setting worked somehow; read[2] is now "..tostring(read[2])); exit = false end

local read2 = ReadOnly.new(t)
if read ~= read2 then log.warning("1_ReadOnly: read ~= read2"); exit = false end

-- Return exit
return exit