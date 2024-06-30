-- credits to reda.3 on discord for making this script
-- Load the OrionLib
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Function to load the additional script
local function loadAdditionalScript()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/ZawTheChawMan/Obfuscator/main/The_Strongest_Battlegrounds_Script'))()
end

-- Define the window
local Window = OrionLib:MakeWindow({Name = "Reda's ui", HidePremium = false, SaveConfig = true, ConfigFolder = "OrionTest"})

-- Notification
OrionLib:MakeNotification({
    Name = "loaded",
    Content = "Reda's Cheats",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Define the Tabs and Buttons
local Tab1 = Window:MakeTab({
    Name = "Tutorial",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add buttons to the Tutorial tab
Tab1:AddButton({
    Name = "Tutorial how to use:",
    Callback = function()
        print("nan")
    end
})

Tab1:AddButton({
    Name = "Activate any of these skills and press the keybind!",
    Callback = function()
        print("nan")
    end
})

Tab1:AddButton({
    Name = "Flowing water, beatdown, lethal whirlwind stream, scatter",
    Callback = function()
        print("nan")
    end
})

-- Create a new tab for Teleports
local Tab2 = Window:MakeTab({
    Name = "Teleports",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add buttons to the Teleports tab
Tab2:AddButton({
    Name = "Death Counter Place (C)",
    Callback = function()
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.C and not gameProcessedEvent then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-98.76111602783203, 29.253990173339844, 20371.73828125)
            end
        end)
    end
})

Tab2:AddButton({
    Name = "Atomic Samurai (V)",
    Callback = function()
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(915.4558715820312, 40.409475326538086, 23070.3828125)
            end
        end)
    end
})

Tab2:AddButton({
    Name = "Map Middle (X)",
    Callback = function()
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.X and not gameProcessedEvent then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(142.19883728027344, 440.7559814453125, 35.69136428833008)
            end
        end)
    end
})

Tab2:AddButton({
    Name = "Lethal Whirlwind Max damage (E)",
    Callback = function()
        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position.x,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y + 70,
                    game.Players.LocalPlayer.Character.HumanoidRootPart.Position.z
                )
            end
        end)
    end
})

-- Create a new tab for AutoTP
local Tab3 = Window:MakeTab({
    Name = "AutoTP",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Add components to the AutoTP tab
local Section1 = Tab3:AddSection({
    Name = "Select Player"
})

plr = {}
for i, v in pairs(workspace.Live:GetChildren()) do
    table.insert(plr, v.Name)
end

local dropplayer = Section1:AddDropdown({
    Name = "Sel Player",
    Default = "",
    Options = plr,
    Callback = function(tplr)
        tp = tplr
    end
})

Section1:AddButton({
    Name = "Refresh Players",
    Callback = function()
        plr = {}
        for i, v in pairs(workspace.Live:GetChildren()) do
            table.insert(plr, v.Name)
        end
        dropplayer:Refresh(plr)
    end
})

Section1:AddToggle({
    Name = "TP",
    Default = false,
    Callback = function(state)
        if state then
            _G.AutoTP = true
            while _G.AutoTP do
                wait()
                pcall(function()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[tp].Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                end)
            end
        else
            _G.AutoTP = false
        end
    end
})

local Section2 = Tab3:AddSection({
    Name = "AutoFIGHT"
})

Section2:AddToggle({
    Name = "AUTOHIT",
    Default = false,
    Callback = function(state)
        if state then
            _G.AutoTP = true
            while _G.AutoTP do
                wait()
                local args = {
                    [1] = {
                        ["Goal"] = "LeftClick"
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
            end
        else
            _G.AutoTP = false
        end
    end
})

Section2:AddToggle({
    Name = "AUTOSKILL",
    Default = false,
    Callback = function(state)
        if state then
            _G.AutoTP = true
            while _G.AutoTP do
                wait()
                -- Script generated by SimpleSpy - credits to exx#9394
                local args = {
                    [1] = {
                        ["Goal"] = "KeyRelease",
                        ["Key"] = Enum.KeyCode.One
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
                wait(1)
                args = {
                    [1] = {
                        ["Goal"] = "KeyPress",
                        ["Key"] = Enum.KeyCode.Two
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
                wait(1)
                args = {
                    [1] = {
                        ["Goal"] = "KeyPress",
                        ["Key"] = Enum.KeyCode.Three
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
                wait(1)
                args = {
                    [1] = {
                        ["Goal"] = "KeyPress",
                        ["Key"] = Enum.KeyCode.Four
                    }
                }
                game:GetService("Players").LocalPlayer.Character.Communicate:FireServer(unpack(args))
            end
        else
            _G.AutoTP = false
        end
    end
})

-- Additional Tabs and Buttons
local Tab4 = Window:MakeTab({
    Name = "Reda's Extras",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

Tab2:AddButton({
    Name = "Void tp (V)",
    Callback = function()
        local originalPosition

        game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessedEvent)
            if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
                if not originalPosition then
                    originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                end
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(10000000000000000, 10000000000000000, 10000000000000000)
                wait(2)  -- Wait for 2 seconds before teleporting back
                if originalPosition then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
                    originalPosition = nil
                end
            end
        end)
    end
})
Tab4:AddButton({
	Name = "Speed",
	Callback = function()
      		function isNumber(str) if tonumber(str) ~= nil or str == 'inf' then return true end end local tspeed = 1 local hb = game:GetService("RunService").Heartbeat local tpwalking = true local player = game:GetService("Players") local lplr = player.LocalPlayer local chr = lplr.Character local hum = chr and chr:FindFirstChildWhichIsA("Humanoid") while tpwalking and hb:Wait() and chr and hum and hum.Parent do if hum.MoveDirection.Magnitude > 0 then if tspeed and isNumber(tspeed) then chr:TranslateBy(hum.MoveDirection * tonumber(tspeed)) else chr:TranslateBy(hum.MoveDirection) end end end
  	
      end

})
Tab2:AddButton({
    Name = "Teleport Menu",
    Callback = function()
        loadAdditionalScript()
    end
})
Tab4:AddButton({
   Name = "Premium Pannel",
   Callback = function()
   loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
   end,
})
