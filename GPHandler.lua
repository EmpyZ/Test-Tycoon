local UIActions = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("Folder").UIActions)

local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

local PlayerGui = player:WaitForChild('PlayerGui')
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")

local gp = workspace.GP:GetDescendants()

-- Function to prompt purchase of the Pass
local function promptPurchase(passID, passName)
	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, passID)
	end)

	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		return
	end

	if hasPass then
		UIActions:CloneText(("You already own the %s Gamepass"):format(passName),ScreenGui)
	else
		-- Player does NOT own the Pass; prompt them to purchase
		MarketplaceService:PromptGamePassPurchase(player, passID)
	end
end

for _, prompt in gp do
	if prompt:IsA("ProximityPrompt") then
		prompt.Triggered:Connect(function(plr)
			promptPurchase(prompt:FindFirstAncestor("Gamepass"):FindFirstChild("GameProduct").Value ,prompt:FindFirstAncestor("Gamepass").Parent.Name)
		end)
	end
end
