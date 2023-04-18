local UpdateUI: RemoteEvent = game.ReplicatedStorage.Remotes.UpdateUI
local UIActions = require(game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("Folder").UIActions)

local PlayerGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local HUD = ScreenGui:WaitForChild("Frame")

local moneyLabel = HUD:WaitForChild("TextLabel")

UpdateUI.OnClientEvent:Connect(function(amount, msg)
	if msg then
		UIActions:CloneText(msg,ScreenGui)
	end
	if amount then
		moneyLabel.Text = tostring(amount)
	end	
end)
