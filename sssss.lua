game:GetService("UserInputService").InputBegan:Connect(
    function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.E and not gameProcessedEvent then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position.x,
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position.y + 70,
                game.Players.LocalPlayer.Character.HumanoidRootPart.Position.z
            )
        end
    end
)
game:GetService("UserInputService").InputBegan:Connect(
    function(input, gameProcessedEvent)
        if input.KeyCode == Enum.KeyCode.V and not gameProcessedEvent then
            if not originalPosition then
                originalPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                CFrame.new(10000000000000000, 10000000000000000, 10000000000000000)
            wait(2) -- Wait for 2 seconds before teleporting back
            if originalPosition then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(originalPosition)
                originalPosition = nil
            end
        end
    end
)

