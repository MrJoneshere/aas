-- Service metatable for on-demand service retrieval
local Services = setmetatable({}, {
    __index = function(self, index)
        local service = game:GetService(index)
        if service then
            self[index] = service
        end
        return service
    end
})

-- Function to prevent fling exploits
local function AntiFling()
    local LocalPlayer = Services.Players.LocalPlayer
    local LastPosition = nil

    local function NeutralizeVelocity(part)
        part.AssemblyAngularVelocity = Vector3.zero
        part.AssemblyLinearVelocity = Vector3.zero
        part.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
    end

    local function DisableCollisions(character)
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                NeutralizeVelocity(part)
            end
        end
    end

    local function MonitorFling(character)
        local PrimaryPart = character.PrimaryPart
        if not PrimaryPart then return end

        Services.RunService.Heartbeat:Connect(function()
            local isFlinging = PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 
                            or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250

            if isFlinging then
                DisableCollisions(character)
                Services.StarterGui:SetCore("ChatMakeSystemMessage", {
                    Text = "Fling Exploit detected!",
                    Color = Color3.fromRGB(255, 200, 0)
                })
            else
                LastPosition = PrimaryPart.CFrame
            end
        end)

        Services.RunService.Heartbeat:Connect(function()
            pcall(function()
                if PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 
                or PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
                    NeutralizeVelocity(PrimaryPart)
                    PrimaryPart.CFrame = LastPosition

                    Services.StarterGui:SetCore("ChatMakeSystemMessage", {
                        Text = "You were flung. Neutralizing velocity.",
                        Color = Color3.fromRGB(255, 0, 0)
                    })
                end
            end)
        end)
    end

    local function MonitorAllPlayers()
        for _, player in ipairs(Services.Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character or player.CharacterAdded:Wait()
                MonitorFling(character)
                player.CharacterAdded:Connect(MonitorFling)
            end
        end
    end

    -- Monitor existing and new players
    MonitorAllPlayers()
    Services.Players.PlayerAdded:Connect(function(player)
        local character = player.Character or player.CharacterAdded:Wait()
        MonitorFling(character)
        player.CharacterAdded:Connect(MonitorFling)
    end)
end

-- Start the anti-fling system
AntiFling()
