-- ImGUI

gui.add_imgui(function()
    if ImGui.Begin("DataStructures") then

        if ImGui.Button("Array") then ArrayTest() end
        if ImGui.Button("List") then ListTest() end
        if ImGui.Button("Struct") then StructTest() end
    
    end
    ImGui.End()
end)