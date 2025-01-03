local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui", PlayerGui)
screenGui.Name = "ChatMessengerGUI"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 300, 0, 150)
frame.Position = UDim2.new(0.5, -150, 0.5, -75)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 1
frame.BorderSizePixel = 0
frame.AnchorPoint = Vector2.new(0.5, 0.5)

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 12)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 20))
}
gradient.Rotation = 45

task.spawn(function()
    while true do
        for i = 0, 360, 1 do
            gradient.Rotation = i
            task.wait(0.02)
        end
    end
end)

local shadow = Instance.new("UIStroke", frame)
shadow.Thickness = 5
shadow.Transparency = 0.8
shadow.Color = Color3.fromRGB(0, 0, 0)

local titleLabel = Instance.new("TextLabel", frame)
titleLabel.Size = UDim2.new(0, 150, 0, 30)
titleLabel.Position = UDim2.new(0, 10, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Chat Messenger"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left

local function animateOpen()
    frame.BackgroundTransparency = 1
    frame.Size = UDim2.new(0, 0, 0, 0)
    frame.Rotation = 45

    local tween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.1,
        Size = UDim2.new(0, 300, 0, 150),
        Rotation = 0
    })
    tween:Play()
end

animateOpen()

local textBox = Instance.new("TextBox", frame)
textBox.Size = UDim2.new(0.8, 0, 0, 30)
textBox.Position = UDim2.new(0.1, 0, 0.4, 0)
textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
textBox.BorderSizePixel = 0
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 14
textBox.PlaceholderText = "Write Something..."
textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
textBox.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)

local textBoxCorner = Instance.new("UICorner", textBox)
textBoxCorner.CornerRadius = UDim.new(0, 8)

local sendButton = Instance.new("TextButton", frame)
sendButton.Size = UDim2.new(0.25, 0, 0, 25)
sendButton.Position = UDim2.new(0.7, 0, 0.8, 0)
sendButton.BackgroundColor3 = Color3.fromRGB(0, 122, 255)
sendButton.BorderSizePixel = 0
sendButton.Font = Enum.Font.GothamBold
sendButton.Text = "Send"
sendButton.TextSize = 12
sendButton.TextColor3 = Color3.fromRGB(0, 0, 0)

local sendButtonCorner = Instance.new("UICorner", sendButton)
sendButtonCorner.CornerRadius = UDim.new(0, 8)

local buttonGradient = Instance.new("UIGradient", sendButton)
buttonGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 150, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 100, 200))
}

sendButton.MouseButton1Click:Connect(function()
    local message = textBox.Text
    if message ~= "" then
        ReplicatedStorage:WaitForChild("DefaultChatSystemChatEvents"):WaitForChild("SayMessageRequest"):FireServer(message, "All")
        textBox.Text = ""
    end
end)

local dragging = false
local dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
        UserInputService.ModalEnabled = true

        local shadowTween = TweenService:Create(shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Transparency = 0.4,
            Thickness = 8
        })
        shadowTween:Play()

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                UserInputService.ModalEnabled = false

                local resetShadowTween = TweenService:Create(shadow, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Transparency = 0.8,
                    Thickness = 5
                })
                resetShadowTween:Play()
            end
        end)
    end
end)

frame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)
