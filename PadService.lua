local PadPurchase: BindableEvent = game.ReplicatedStorage.Remotes.PadPurchase

local UpdateUI: RemoteEvent = game.ReplicatedStorage.Remotes.UpdateUI
local PadTouched: RemoteEvent = game.ReplicatedStorage.Remotes.PadTouched

local PlayerData = require(script.Parent.PlayerData)

local padsFolder = workspace.Pads
local pads = padsFolder:GetChildren()

local buildingsFolder = workspace.Buildings
buildingsFolder.Parent = game.ReplicatedStorage

local function onPadTouch(player, pad)
	PlayerData:SubtractMoney(player, pad:GetAttribute("Price"))
	local buildingClone = pad.Target.Value:Clone()
	buildingClone.Parent = workspace

	pad.Skin:Destroy()
	pad.Pad:Destroy()
	pad.BillboardGui:Destroy()

	PadPurchase:Fire(player,pad)
end

local function onPadPurchased(player,pad)
	local message = ("Pad %s was purchased!"):format(pad.Name)
	UpdateUI:FireClient(player, nil, message)
end

PadPurchase.Event:Connect(onPadPurchased)

PadTouched.OnServerInvoke = function(player,pad)
	local pad = padsFolder:FindFirstChild(pad.Name)
	if not pad then return end
	if PlayerData:GetMoney(player) < pad:GetAttribute("Price") or pad:GetAttribute("isFinished") then return pad.Name end

	local dependency = pad.Dependency.Value

	if dependency then
		if not dependency:GetAttribute("isFinished") then return pad.Name end				
	end

	pad:SetAttribute("isFinished", true)

	onPadTouch(player, pad)
	return pad.Next.Value
end
