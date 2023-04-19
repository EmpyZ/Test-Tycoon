local SoundMod = require(game.ReplicatedStorage.Modules.SoundMod)

local modules = script.Parent:WaitForChild("Modules")

local UIActions = require(modules.UIActions)
local BuildingVisuals = require(modules.BuildingVisuals)

local player = game:GetService("Players").LocalPlayer

local PlayerGui = player:WaitForChild('PlayerGui')
local ScreenGui = PlayerGui:WaitForChild("ScreenGui")
local HUD = ScreenGui:WaitForChild("Frame")
local coinLabel = HUD.TextLabel

local PadTouched = game.ReplicatedStorage.Remotes.PadTouched

local padsFolder = workspace.Pads
local pads = padsFolder:GetChildren()

local ost,toS,toN = os.time, tostring, tonumber
local debounce = 0
local currentPad = "Entrance_1"

local function disconnect(touchedConn)
	touchedConn:Disconnect()
	touchedConn = nil
	return touchedConn
end

local function addFirework(pad)
	local fireworks = game.ReplicatedStorage.Assets.Effects.Library.Fireworks_1:Clone()
	fireworks.Enabled = true
	fireworks.Parent = pad.PreviewArea
	game:GetService("Debris"):AddItem(fireworks,2)
end

for index, pad in pads do
	if pad:GetAttribute("isFinished") then return end
	
	local billboard = pad.BillboardGui; local bottomL = billboard:FindFirstChild("BottomLabel", true); local title = billboard:FindFirstChild("TitleLabel", true)
	bottomL.Text = pad:GetAttribute("Price"); title.Text = string.gsub(pad.Name,"_"," ")
	
	local touchedConn = nil
	local touchingArea: BasePart = pad.Pad
	
	touchedConn = touchingArea.Touched:Connect(function(hit)
		if ost() - debounce < 1 then 
			return
		end
		
		local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
		
		if not humanoid or padsFolder[currentPad].Name ~= pad.Name or toN(coinLabel.Text) < pad:GetAttribute("Price") then
			if not game.ReplicatedStorage.Assets.Sounds["Pads"]["Deny"].IsPlaying then
				SoundMod:PlaySound("Pads","Deny")
				local msg = if toN(coinLabel.Text) > pad:GetAttribute("Price") and toS(pad.Dependency.Value) == "nil" then ("You need to purchase Entrance_1 first!") else if toN(coinLabel.Text) < pad:GetAttribute("Price") then "Not enough Coins!" else ("You need to purchase %s first!"):format(toS(pad.Dependency.Value))
				UIActions:CloneText(msg, ScreenGui, Color3.fromRGB(255, 121, 121), 1.75)
				msg = nil
			end	
			return
		end
		
		local padNumber = string.gsub(pad.Name,"%D","")
		padNumber = tonumber(padNumber)
		
		touchedConn = disconnect(touchedConn)
		debounce = ost()
		
		currentPad = PadTouched:InvokeServer(pad,padNumber)
		padNumber = nil
		addFirework(pad)
		SoundMod:PlaySound("Pads","Sound")
		SoundMod:PlaySound("Fireworks","Firework")
	end)
end

workspace.ClonedBuilds.ChildAdded:Connect(function(add)
	if script.Parent.Modules.BuildingVisuals:GetAttribute("BuildVisuals") == true then
		task.wait()
		BuildingVisuals:animateBuildingIn(add, TweenInfo.new(1, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out)):Wait()
	end	
end)
