local Gamepasses = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("Modules").GPHandler)

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PlayerGui = player:WaitForChild('PlayerGui')
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")

local gp = workspace.GP:GetDescendants()

for _, prompt in gp do
	if prompt:IsA("ProximityPrompt") then
		prompt.Triggered:Connect(function(plr)
			Gamepasses:PromptPurchase(player, ScreenGui, prompt:FindFirstAncestor("Gamepass"):FindFirstChild("GameProduct").Value ,prompt:FindFirstAncestor("Gamepass").Parent.Name)
		end)
	end
end
