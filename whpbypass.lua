local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")

local targetModel = workspace:GetChildren()[10]
local importantPart = targetModel and targetModel:GetChildren()[6]
local maxSize = Vector3.new(2048, 100, 2048)

local function deleteUnwantedParts()
    if not targetModel or not importantPart then return end
    
    local partsToDelete = {
        targetModel:GetChildren()[19],
        targetModel.Part,
        targetModel:GetChildren()[9],
        targetModel:GetChildren()[2],
        targetModel:GetChildren()[17],
        targetModel:GetChildren()[16],
        targetModel:GetChildren()[15],
        targetModel:GetChildren()[14],
        targetModel:GetChildren()[12],
        targetModel:GetChildren()[11],
        targetModel:GetChildren()[10],
        targetModel:GetChildren()[18],
        targetModel:GetChildren()[8],
        targetModel:GetChildren()[7],
        targetModel:GetChildren()[5],
        targetModel:GetChildren()[4],
        targetModel:GetChildren()[3]
    }
    
    for _, part in ipairs(partsToDelete) do
        if part and part:IsA("BasePart") and part ~= importantPart then
            part:Destroy()
        end
    end
    
    for _, child in ipairs(targetModel:GetChildren()) do
        if child:IsA("BasePart") and child ~= importantPart then
            local shouldDelete = true
            for _, keep in ipairs(partsToDelete) do
                if child == keep then
                    shouldDelete = false
                    break
                end
            end
            if shouldDelete then
                child:Destroy()
            end
        end
    end
end

local function resizeImportantPart()
    if importantPart then
        importantPart.Size = maxSize
    end
end

local function notify(msg)
    StarterGui:SetCore("SendNotification", {
        Title = "WHP Bypass",
        Text = msg,
        Duration = 3
    })
end

local function startProtection()
    if not targetModel or not importantPart then
        notify("Error: Target not found")
        return
    end
    
    notify("Protection Active")
    resizeImportantPart()
    deleteUnwantedParts()
    
    RunService.Heartbeat:Connect(function()
        deleteUnwantedParts()
        if importantPart.Size ~= maxSize then
            resizeImportantPart()
        end
    end)
end

startProtection()
