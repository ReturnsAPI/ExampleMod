-- Blue Circle (buff)

local init = function()
    local buff = Buff.new("blueCircle")

    buff.icon_sprite = Sprite.new("blueCircle", "~/blueCircle.png", 1, 16, 16)
    buff.max_stack = 5

    buff:show_properties()

    Callback.add(buff.on_apply, function(actor)
        print("'blueCircle (buff)' on_apply")
        print(actor, actor.value)
        print("Stack: "..actor:buff_count(buff))
    end)
    
    Callback.add(Callback.ON_HIT_PROC, function(actor, victim, hit_info)
        if actor:buff_count(buff) <= 0 then return end
    
        print("'blueCircle (buff)' ON_HIT_PROC")
        print("Stack: "..actor:buff_count(buff))
    end)

    buff_hotloaded = true
end
Initialize.add(init)
if buff_hotloaded then init() end

-- Return status
return true