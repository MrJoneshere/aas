local HttpService = game:GetService("HttpService")
HttpService.HttpEnabled = true
local url = "https://raw.githubusercontent.com/DiosDi/VexonHub/refs/heads/main/Key"
local key = HttpService:GetAsync(url)
loadstring(game:HttpGet("https://raw.githubusercontent.com/DiosDi/VexonHub/refs/heads/main/VexonHub"))()
setclipboard(key)
