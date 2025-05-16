loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/VexonHub", true))()

local key = game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/Key", true)
setclipboard(key)

game:GetService("StarterGui"):SetCore("SendNotification", {
    Title = "VexonHub",
    Text = "✅ Key copied!",
    Duration = 5
})
