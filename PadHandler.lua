local SoundMod = require(game.ReplicatedStorage.Modules.SoundMod)
local BuildingVisuals = require(script.Parent:WaitForChild("Modules").BuildingVisuals)

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
	fireworks.Parent = pad.PreviewArea
	game:GetService("Debris"):AddItem(fireworks,2)
end

for index, pad in pads do
	if pad:GetAttribute("isFinished") then return end
	
	local billboard = pad.BillboardGui; local bottomL = billboard:FindFirstChild("BottomLabel", true)
	bottomL.Text = pad:GetAttribute("Price")
	
	local touchedConn = nil
	local touchingArea: BasePart = pad.Pad
	
	touchedConn = touchingArea.Touched:Connect(function(hit)
		if padsFolder[currentPad].Name ~= pad.Name then return end
		local humanoid = hit.Parent:FindFirstChildOfClass("Humanoid")
		
		if not humanoid or ost() - debounce < 1 or toN(coinLabel.Text) < pad:GetAttribute("Price") then
			if not game.ReplicatedStorage.Assets.Sounds["Pads"]["Deny"].IsPlaying then
				SoundMod:PlaySound("Pads","Deny")
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
