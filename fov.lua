-- Path: StarterGui -> ScreenGui -> Slider GUI

-- Create a ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FOVSliderGui"
screenGui.ResetOnSpawn = false -- Prevents GUI from vanishing on respawn
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create a Frame for the slider background
local sliderFrame = Instance.new("Frame")
sliderFrame.Size = UDim2.new(0, 300, 0, 20)
sliderFrame.Position = UDim2.new(0, 10, 1, -40) -- Bottom-left corner
sliderFrame.BackgroundColor3 = Color3.new(0.3, 0.3, 0.3)
sliderFrame.BorderSizePixel = 0
sliderFrame.Parent = screenGui

-- Create a TextLabel to display the FOV value
local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 100, 0, 20)
fovLabel.Position = UDim2.new(0, 10, 1, -70) -- Above the slider in the bottom-left
fovLabel.Text = "FOV: 100"
fovLabel.TextColor3 = Color3.new(1, 1, 1)
fovLabel.BackgroundTransparency = 1
fovLabel.Font = Enum.Font.GothamBold -- Use GothamBold font
fovLabel.TextSize = 18
fovLabel.Parent = screenGui

-- Create a Frame to act as the draggable handle
local handle = Instance.new("Frame")
handle.Size = UDim2.new(0, 20, 1, 0)
handle.Position = UDim2.new(0.5, -10, 0, 0) -- Centered initially
handle.BackgroundColor3 = Color3.new(1, 0.6, 0)
handle.BorderSizePixel = 0
handle.Parent = sliderFrame

-- Create UI corner instances for rounded corners
local sliderUICorner = Instance.new("UICorner")
sliderUICorner.CornerRadius = UDim.new(0, 10)
sliderUICorner.Parent = sliderFrame

local handleUICorner = Instance.new("UICorner")
handleUICorner.CornerRadius = UDim.new(0, 10)
handleUICorner.Parent = handle

-- Variables to store slider min and max positions
local sliderMin = 0
local sliderMax = sliderFrame.Size.X.Offset - handle.Size.X.Offset

-- Function to update FOV and label based on handle position
local function updateFOV()
    local xOffset = handle.Position.X.Offset
    xOffset = math.clamp(xOffset, sliderMin, sliderMax)
    handle.Position = UDim2.new(0, xOffset, 0, 0)

    local fov = math.floor(20 + (xOffset / sliderMax) * 120) -- Range: 20 to 140
    game.Workspace.Camera.FieldOfView = fov
    fovLabel.Text = "FOV: " .. fov
end

-- Make the handle draggable
local userInputService = game:GetService("UserInputService")

local dragging = false
local guiInteraction = false -- Flag to check if GUI is being interacted with
local dragInput, dragStart, startPos

local function updateInput(input)
    local delta = input.Position - dragStart
    local newX = math.clamp(startPos.X.Offset + delta.X, sliderMin, sliderMax)
    handle.Position = UDim2.new(0, newX, 0, 0)
    updateFOV()
end

handle.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        guiInteraction = true -- Set flag indicating GUI interaction
        dragStart = input.Position
        startPos = handle.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
                guiInteraction = false -- Reset flag when dragging ends
            end
        end)
    end
end)

handle.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

userInputService.InputChanged:Connect(function(input)
    if dragging and input == dragInput then
        updateInput(input)
    end
end)

-- Optional: Set initial handle position to reflect the current FOV
local initialFOV = game.Workspace.Camera.FieldOfView
local initialXOffset = ((initialFOV - 20) / 120) * sliderMax
handle.Position = UDim2.new(0, initialXOffset, 0, 0)

-- Continuous loop to keep FOV updated based on the slider's position
local runService = game:GetService("RunService")
runService.RenderStepped:Connect(updateFOV)

-- Ensure GUI resets properly if it's already created and persists through respawns
local function ensureGUIExists()
    local existingGui = game.Players.LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("FOVSliderGui")
    if not existingGui then
        local newScreenGui = screenGui:Clone()
        newScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    end
end

-- Listen for the player's character respawn event to ensure GUI persistence
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(1) -- Short delay to ensure character is fully loaded
    ensureGUIExists()

    -- Reset the initial handle position based on current FOV
    local currentFOV = game.Workspace.Camera.FieldOfView
    local newInitialXOffset = ((currentFOV - 20) / 120) * sliderMax
    handle.Position = UDim2.new(0, newInitialXOffset, 0, 0)
end)

-- Initial check in case of immediate script execution
ensureGUIExists()

-- Prevent slowness effect when clicking the GUI handle
local function preventGameActionsDuringGUIInteraction(input)
    if guiInteraction and input.UserInputType == Enum.UserInputType.MouseButton1 then
        -- Prevent other actions, like slowness or attacks, while interacting with the GUI
        -- No need to execute game actions during GUI interaction
        input.UserInputState = Enum.UserInputState.End -- Ignore this input event for game actions
        return true -- This stops the game from processing this input
    end
    return false -- Allow the game to process this input
end

-- Capture global input events to prevent unwanted actions during GUI interaction
userInputService.InputBegan:Connect(function(input)
    if preventGameActionsDuringGUIInteraction(input) then
        -- Do nothing if we're preventing the action
        return
    end

    -- Perform any actions needed if the click is outside the GUI (optional)
    -- Example: Apply slowness effect or attack if not interacting with the GUI
end)
