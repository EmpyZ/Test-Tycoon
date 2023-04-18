local soundMod = require(game.ReplicatedStorage.Modules.SoundMod)

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
				soundMod:PlaySound("Pads","Deny")
			end	
			return
		end
		
		touchedConn = disconnect(touchedConn)
		debounce = ost()
		
		local player = game:GetService("Players"):GetPlayerFromCharacter(hit.Parent)
		
		currentPad = PadTouched:InvokeServer(pad)
		soundMod:PlaySound("Pads","Sound")
	end)
end
