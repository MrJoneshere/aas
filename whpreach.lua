local sound = Instance.new("Sound")
sound.SoundId = "rbxassetid://413861777"
sound.Parent = game:GetService("SoundService")
sound:Play()

wait()

for i,v in pairs(game:GetService'Players'.LocalPlayer.Character:GetChildren()) do
    if v:isA("Tool") then
        local a = Instance.new("SelectionBox",v.Handle)
        v.Handle.Massless = true
        v.Handle.Transparency = 1
        a.Adornee = v.Handle
        v.Handle.Size = Vector3.new(999, 999 , 999)
        local selectionBox = Instance.new("SelectionBox",v.Handle)
        selectionBox.Adornee = v.Handle
        selectionBox.Color3 = Color3.new(0, 0.313725, 0.47451)
    end
end
