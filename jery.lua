local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid")

if humanoid then
    if humanoid.RigType == Enum.HumanoidRigType.R15 then
        print("Character is R15")
        loadstring(game:HttpGet("https://pastefy.app/wa3v2Vgm/raw"))()
    elseif humanoid.RigType == Enum.HumanoidRigType.R6 then
        print("Character is R6")
        loadstring(game:HttpGet("https://pastefy.app/YZoglOyJ/raw"))()
    end
else
    warn("Humanoid not found!")
end
