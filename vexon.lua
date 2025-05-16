loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/VexonHub", true))()
setclipboard(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/Key", true))
local key = loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/Key", true))()
game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "Paralyz Hub",
    Text = "✅ Key copied: " .. tostring(key),
    Duration = 5
})
