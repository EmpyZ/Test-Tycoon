local MarketplaceService = game:GetService("MarketplaceService")

local UIActions = require(script.Parent.UIActions)

local Gamepasses = {}

-- Function to prompt purchase of the Pass
function Gamepasses:PromptPurchase(player, ScreenGui, passID, passName)
	local hasPass = false

	local success, message = pcall(function()
		hasPass = MarketplaceService:UserOwnsGamePassAsync(player.UserId, passID)
	end)

	if not success then
		warn("Error while checking if player has pass: " .. tostring(message))
		return
	end

	if hasPass then
		UIActions:CloneText(("You already own the %s Gamepass"):format(passName) , ScreenGui, Color3.fromRGB(250, 255, 207), 1.5)
	else
		-- Player does NOT own the Pass; prompt them to purchase
		MarketplaceService:PromptGamePassPurchase(player, passID)
	end
end

return Gamepasses
