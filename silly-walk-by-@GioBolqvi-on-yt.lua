local animationId = "rbxassetid://28488254"
local animationStart = 0.2
local animationLength = 0.9
local player = game.Players.LocalPlayer
local walkSpeed = 20
local defaultWalkSpeed = 16
 
local guiName = "AnimationGui"
local isGuiVisible = true
local wasAnimationEnabled = false
 
local function createGUI()
    if isGuiVisible then
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local walkAnimation = Instance.new("Animation")
        walkAnimation.AnimationId = animationId
 
        local existingGui = player:FindFirstChild(guiName)
        if existingGui then
            existingGui:Destroy()
        end
 
        local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
        screenGui.Name = guiName
 
        local toggleButton = Instance.new("TextButton", screenGui)
        toggleButton.Size = UDim2.new(0, 150, 0, 60)
        toggleButton.Position = UDim2.new(1, -160, 0.5, -60)
        toggleButton.Text = "Toggle Walk Animation"
        toggleButton.BackgroundColor3 = Color3.fromRGB(169, 169, 169)
        toggleButton.BackgroundTransparency = 0.5
 
        local closeButton = Instance.new("TextButton", screenGui)
        closeButton.Size = UDim2.new(0, 30, 0, 30)
        closeButton.Position = UDim2.new(1, -40, 0.5, -60)
        closeButton.Text = "X"
        closeButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        closeButton.BackgroundTransparency = 0.5
 
        local dragFrame = Instance.new("Frame", screenGui)
        dragFrame.Size = UDim2.new(0, 150, 0, 20)
        dragFrame.Position = UDim2.new(1, -160, 0.5, 0)  -- Positioned below the toggle button
        dragFrame.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        dragFrame.BackgroundTransparency = 0.3
 
        local isWalking = false
        local isAnimationEnabled = wasAnimationEnabled
        local animationTrack
 
        local dragging = false
        local dragStart = nil
        local startPos = nil
 
        -- Plays the walk animation when enabled
        local function playWalkAnimation()
            if animationTrack and animationTrack.IsPlaying then
                animationTrack:Stop()  -- Stop any currently playing animation first
            end
 
            animationTrack = humanoid:LoadAnimation(walkAnimation)
            animationTrack.Looped = true
            animationTrack:Play()
            animationTrack.TimePosition = animationStart
        end
 
        local function stopWalkAnimation()
            if animationTrack then
                animationTrack:Stop()
            end
        end
 
        local function onWalk()
            if isAnimationEnabled and not isWalking then
                isWalking = true
                playWalkAnimation()
                while isWalking do
                    if animationTrack.TimePosition >= animationStart + animationLength then
                        animationTrack.TimePosition = animationStart
                    end
                    wait(0.05)
                end
            end
        end
 
        humanoid.Running:Connect(function(speed)
            -- Play animation only if walking, ignoring jumping/falling
            if speed > 0 then
                onWalk()
            else
                isWalking = false
                stopWalkAnimation()
            end
        end)
 
        -- Keep walk speed locked at 20 if the animation is enabled
        game:GetService("RunService").Heartbeat:Connect(function()
            if isAnimationEnabled then
                humanoid.WalkSpeed = walkSpeed
            end
        end)
 
        dragFrame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = dragFrame.Position
            end
        end)
 
        dragFrame.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - dragStart
                dragFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                toggleButton.Position = dragFrame.Position - UDim2.new(0, 0, 0, 60)
                closeButton.Position = dragFrame.Position - UDim2.new(0, -120, 0, 60)
            end
        end)
 
        dragFrame.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = false
            end
        end)
 
        toggleButton.MouseButton1Click:Connect(function()
            isAnimationEnabled = not isAnimationEnabled
            toggleButton.Text = isAnimationEnabled and "Disable Walk Animation" or "Enable Walk Animation"
            if isAnimationEnabled then
                humanoid.WalkSpeed = walkSpeed
                playWalkAnimation()  -- Ensure walk animation is played every time it's enabled
            else
                humanoid.WalkSpeed = defaultWalkSpeed
                stopWalkAnimation()
            end
            wasAnimationEnabled = isAnimationEnabled
        end)
 
        closeButton.MouseButton1Click:Connect(function()
            isGuiVisible = false
            wasAnimationEnabled = false
            screenGui:Destroy()
        end)
    end
end
 
player.CharacterAdded:Connect(function()
    if isGuiVisible then
        createGUI()
        player.Character:WaitForChild("Humanoid").WalkSpeed = wasAnimationEnabled and walkSpeed or defaultWalkSpeed
    end
end)
 
if player.Character then
    createGUI()
    player.Character:WaitForChild("Humanoid").WalkSpeed = wasAnimationEnabled and walkSpeed or defaultWalkSpeed
end
