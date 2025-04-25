local Area = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local MyView = Area.CurrentCamera
local Lock = false
local Target = nil

_G.AimPart = "HumanoidRootPart"
_G.CircleColor = Color3.fromRGB(255, 0, 130)
_G.CircleRadius = 200
_G.CircleSides = 64
_G.CircleTransparency = 0
_G.CircleFilled = false
_G.CircleVisible = true
_G.CircleThickness = 1

local FOVCircle = Drawing.new("Circle")
FOVCircle.Position = Vector2.new(MyView.ViewportSize.X / 2, MyView.ViewportSize.Y / 2)
FOVCircle.Radius = _G.CircleRadius
FOVCircle.Filled = _G.CircleFilled
FOVCircle.Color = _G.CircleColor
FOVCircle.Visible = _G.CircleVisible
FOVCircle.Transparency = _G.CircleTransparency
FOVCircle.NumSides = _G.CircleSides
FOVCircle.Thickness = _G.CircleThickness

local function CursorLock()
	UIS.MouseBehavior = Enum.MouseBehavior.LockCenter
end

local function UnLockCursor()
	UIS.MouseBehavior = Enum.MouseBehavior.Default
end

local function FindNearestPlayer()
	local dist = math.huge
	local found = nil
	for _, v in pairs(Players:GetPlayers()) do
		if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("Humanoid").Health > 0 and v.Character:FindFirstChild("HumanoidRootPart") then
			local pos, visible = MyView:WorldToViewportPoint(v.Character[_G.AimPart].Position)
			if visible then
				local mag = (Vector2.new(Mouse.X, Mouse.Y) - Vector2.new(pos.X, pos.Y)).Magnitude
				if mag < dist and mag < _G.CircleRadius then
					dist = mag
					found = v.Character
				end
			end
		end
	end
	return found
end

task.spawn(function()
	while true do
		task.wait()
		if Lock and Target then
			local part = Target:FindFirstChild(_G.AimPart)
			if part then
				MyView.CFrame = CFrame.lookAt(MyView.CFrame.Position, part.Position)
				CursorLock()
			end
		end
	end
end)

UIS.InputBegan:Connect(function(Input)
	if Input.KeyCode == Enum.KeyCode.H then
		Lock = not Lock
		if Lock then
			Target = FindNearestPlayer()
		else
			Target = nil
			UnLockCursor()
		end
	end
end)

game.StarterGui:SetCore("SendNotification", {
	Title = "Raw Lock Enabled",
	Text = "No prediction. No smoothing. Toggle with H.",
	Duration = 4
})
