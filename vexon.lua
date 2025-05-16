local vexonHubScript = "https://raw.githubusercontent.com/DiosDi/VexonHub/main/VexonHub"
local keyUrl = "https://raw.githubusercontent.com/DiosDi/VexonHub/main/Key"

if not pcall(function() readfile("__temp_vexon.lua") end) then
    loadstring(game:HttpGet(vexonHubScript, true))()
    
    if syn then
        local key = syn.request({Url = keyUrl, Method = "GET"}).Body
        setclipboard(key)
        syn.toast_notification("VexonHub", "✅ Key copied: "..string.sub(key, 1, 5).."...", 5)
    else
        warn("HTTP engellendi! Key'i manuel al: "..keyUrl)
    end
end
