-- Services
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "RemoteEventFinderMobileRainbow"
screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 25)

-- Rainbow border
local border = Instance.new("UIStroke", mainFrame)
border.Thickness = 3
border.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
border.Color = Color3.fromHSV(0,1,1)
border.Transparency = 0

spawn(function()
    local hue = 0
    while true do
        hue = (hue + 0.005) % 1
        border.Color = Color3.fromHSV(hue,1,1)
        RunService.Heartbeat:Wait()
    end
end)

-- Top Bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
topBar.Parent = mainFrame
Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 25)

local topText = Instance.new("TextLabel")
topText.Size = UDim2.new(1, -50, 1, 0)
topText.Position = UDim2.new(0, 10, 0, 0)
topText.Text = "RemoteEvent Finder"
topText.TextColor3 = Color3.fromRGB(255, 255, 255)
topText.TextScaled = true
topText.BackgroundTransparency = 1
topText.Font = Enum.Font.GothamBold
topText.Parent = topBar

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 25, 0, 25)
closeBtn.Position = UDim2.new(1, -30, 0, 7)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.BackgroundTransparency = 0.7
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeBtn.BorderSizePixel = 0
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextScaled = true
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 12)
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Enhanced Dragging System (works for both mouse and touch)
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(
        startPos.X.Scale, 
        startPos.X.Offset + delta.X,
        startPos.Y.Scale, 
        startPos.Y.Offset + delta.Y
    )
end

-- Start dragging when clicking on topBar (better user experience)
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

-- Also allow dragging from main frame (original behavior)
mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                connection:Disconnect()
            end
        end)
    end
end)

topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input == dragInput) then
        update(input)
    end
end)

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 50)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.ScrollBarThickness = 8
scroll.BackgroundTransparency = 1
scroll.Parent = mainFrame

local uiList = Instance.new("UIListLayout", scroll)
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Padding = UDim.new(0, 5)

-- Loading Frame
local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0.8, 0, 0, 80)
loadingFrame.Position = UDim2.new(0.1, 0, 0.5, -40)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Parent = mainFrame

-- Loading Text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, 0, 0.4, 0)
loadingText.Position = UDim2.new(0, 0, 0, 0)
loadingText.BackgroundTransparency = 1
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.GothamBold
loadingText.Text = "Loading"
loadingText.Parent = loadingFrame

-- Progress bar background
local progressBarBG = Instance.new("Frame")
progressBarBG.Size = UDim2.new(1, 0, 0.3, 0)
progressBarBG.Position = UDim2.new(0, 0, 0.45, 0)
progressBarBG.BackgroundColor3 = Color3.fromRGB(50,50,50)
progressBarBG.BorderSizePixel = 0
progressBarBG.Parent = loadingFrame
Instance.new("UICorner", progressBarBG).CornerRadius = UDim.new(0, 12)

-- Progress bar fill
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(0,255,255)
progressBar.BorderSizePixel = 0
progressBar.Parent = progressBarBG
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(0, 12)

-- Searching text below bar
local searchingText = Instance.new("TextLabel")
searchingText.Size = UDim2.new(1,0,0.3,0)
searchingText.Position = UDim2.new(0,0,0.8,0)
searchingText.BackgroundTransparency = 1
searchingText.TextColor3 = Color3.fromRGB(255,255,255)
searchingText.TextScaled = true
searchingText.Font = Enum.Font.GothamBold
searchingText.Text = "Searching..."
searchingText.Parent = loadingFrame

-- Animate loading text dots
spawn(function()
    local dots = 0
    while loadingFrame.Parent do
        dots = (dots + 1) % 4
        loadingText.Text = "Loading" .. string.rep(".", dots)
        wait(0.5)
    end
end)

-- Fixed 5 second loading
spawn(function()
    local duration = 5
    local startTime = tick()
    while tick() - startTime < duration do
        local progress = (tick() - startTime)/duration
        progressBar.Size = UDim2.new(progress,0,1,0)
        RunService.RenderStepped:Wait()
    end
    progressBar.Size = UDim2.new(1,0,1,0)

    -- Remove loading frame
    loadingFrame:Destroy()

    -- Populate RemoteEvents
    local remotes = {}
    for _, container in pairs({workspace, ReplicatedStorage}) do
        for _, obj in pairs(container:GetDescendants()) do
            if obj:IsA("RemoteEvent") then
                table.insert(remotes,obj)
            end
        end
    end

    for _, v in pairs(remotes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1,0,0,40)
        btn.Text = v.Name
        btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
        btn.TextColor3 = Color3.fromRGB(255,255,255)
        btn.BorderSizePixel = 0
        btn.Parent = scroll
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,15)

        btn.MouseButton1Click:Connect(function()
            -- Fire the RemoteEvent with some sample data
            local success, errorMsg = pcall(function()
                -- Try different common argument patterns
                v:FireServer()
                v:FireServer(1)
                v:FireServer("test")
                v:FireServer({data = "test"})
                v:FireServer(LocalPlayer)
            end)
            
            if not success then
                warn("Failed to fire RemoteEvent " .. v.Name .. ": " .. tostring(errorMsg))
            else
                print("Successfully fired RemoteEvent: " .. v.Name)
            end
            
            -- Also copy to clipboard (original functionality)
            if setclipboard then
                setclipboard(v:GetFullName())
            end
        end)
    end

    scroll.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y+10)
end)
