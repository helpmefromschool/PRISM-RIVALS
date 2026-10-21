-- Original visual test prop for your own Roblox Studio place.
-- Install as a Script in ServerScriptService.
local Players = game:GetService("Players")

local function giveTestTool(player)
    local backpack = player:WaitForChild("Backpack")
    if backpack:FindFirstChild("ATELIER Test Tool") then return end
    local tool = Instance.new("Tool")
    tool.Name = "ATELIER Test Tool"
    tool.ToolTip = "Original cosmetic test prop"
    tool.CanBeDropped = false
    tool.RequiresHandle = true

    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(0.35, 0.4, 2)
    handle.Color = Color3.fromRGB(65, 73, 84)
    handle.Material = Enum.Material.Metal
    handle.CanCollide = false
    handle.Massless = true
    handle.Parent = tool

    local accent = Instance.new("Part")
    accent.Name = "Accent"
    accent.Size = Vector3.new(0.42, 0.1, 1.3)
    accent.Color = Color3.fromRGB(199, 176, 105)
    accent.Material = Enum.Material.Metal
    accent.CanCollide = false
    accent.Massless = true
    accent.CFrame = handle.CFrame * CFrame.new(0, 0.25, 0)
    accent.Parent = tool

    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = accent
    weld.Parent = accent
    tool.Parent = backpack
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        giveTestTool(player)
    end)
end)