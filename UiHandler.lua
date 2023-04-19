local UpdateUI: RemoteEvent = game.ReplicatedStorage.Remotes.UpdateUI

local modules = game:GetService("Players").LocalPlayer.PlayerScripts:WaitForChild("Modules")

local SoundMod = require(game.ReplicatedStorage.Modules.SoundMod)

local Gamepasses = require(modules.GPHandler)
local SettingsMod = require(modules.Settings)
local UIActions = require(modules.UIActions)

local player = game:GetService("Players").LocalPlayer

local UIS = game:GetService("UserInputService")
local PlayerGui = game:GetService('Players').LocalPlayer:WaitForChild('PlayerGui')
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local HUD = ScreenGui:WaitForChild("Frame")

local settingsButton = ScreenGui.Settings
local gamepassesButton = ScreenGui.Gamepasses
local settingsFrame = ScreenGui.SettingsFrame
local gamepassFrame = ScreenGui.GamepassFrame

local moneyLabel = HUD:WaitForChild("TextLabel")

local lightGreen = Color3.fromRGB(99, 255, 130)
local lightRed = Color3.fromRGB(125, 37, 37)

local ost = os.time
local debounce = 0

UpdateUI.OnClientEvent:Connect(function(amount, msg)
	if msg then
		UIActions:CloneText(msg, ScreenGui, Color3.fromRGB(250, 255, 207), 2.75)
	end
	if amount then
		moneyLabel.Text = tostring(amount)
	end	
end)


settingsButton.MouseButton1Click:Connect(function()
	settingsFrame.Visible = not settingsFrame.Visible
	gamepassFrame.Visible = false
	SoundMod:PlaySound("UI","UIClickOn")
end)

gamepassesButton.MouseButton1Click:Connect(function()
	gamepassFrame.Visible = not gamepassFrame.Visible
	settingsFrame.Visible = false
	SoundMod:PlaySound("UI","UIClickOn")
end)

for _, buttons in settingsFrame:GetDescendants() do
	if buttons:IsA("TextButton") then
		buttons.InputBegan:Connect(function(input,GPE)
			if GPE then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.Begin then
				if buttons.BackgroundColor3 == lightGreen then
					buttons.BackgroundColor3 = lightRed
					buttons.Text = "Off"
					SettingsMod[buttons.Parent.Name](SettingsMod, false)
					SoundMod:PlaySound("UI","UIClickOff")
				else
					buttons.BackgroundColor3 = lightGreen
					buttons.Text = "On"
					SettingsMod[buttons.Parent.Name](SettingsMod, true)
					SoundMod:PlaySound("UI","UIClickOn")
				end
			end	
		end)
	end
end

for _, buttons in gamepassFrame:GetDescendants() do
	if buttons:IsA("TextButton") then
		buttons.InputBegan:Connect(function(input,GPE)
			if GPE then return end
			if input.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputState == Enum.UserInputState.Begin then
				SoundMod:PlaySound("UI","UIClickOn")
				if ost() - debounce < 2.75 then return end
				debounce = ost()
				Gamepasses:PromptPurchase(player, ScreenGui, buttons.Parent.GameProduct.Value ,buttons.Parent.Name)
			end
		end)
	end
end
