loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/VexonHub"))()
local key = game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/Key")
setclipboard(key)
if game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui") then
    game:GetService("Players").LocalPlayer.PlayerGui:SetTopbarTransparency(1)
    game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Notification"):Fire(
        "✅ Key copied to clipboard!",
    )
end
print("✅ Key copied to clipboard! | " .. key)
