loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/VexonHub", true))()
local key = game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/main/Key", true):match("^%s*(.-)%s*$")
setclipboard(key)
wait(0.2)
game.StarterGui:SetCore("SendNotification", {
    Title = "Paralyz Hub",
    Text = "✅ Key copied: " .. key,
    Duration = 5
})
