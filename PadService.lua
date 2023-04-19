local PadPurchase: BindableEvent = game.ReplicatedStorage.Remotes.PadPurchase

local UpdateUI: RemoteEvent = game.ReplicatedStorage.Remotes.UpdateUI
local PadTouched: RemoteEvent = game.ReplicatedStorage.Remotes.PadTouched

local PlayerData = require(script.Parent.PlayerData)

local padsFolder = workspace.Pads
local pads = padsFolder:GetChildren()

local ost = os.time

local buildingsFolder = workspace.Buildings
buildingsFolder.Parent = game.ReplicatedStorage

local function onPadTouch(player, pad, padNumber)
	PlayerData:SubtractMoney(player, pad:GetAttribute("Price"))
	local buildingClone = pad.Target.Value:Clone()
	buildingClone.Parent = workspace.ClonedBuilds

	pad.Skin:Destroy()
	pad.Pad:Destroy()
	pad.BillboardGui:Destroy()

	PadPurchase:Fire(player,pad, padNumber)
end

local function onPadPurchased(player, pad, padNumber)
	local message = ("Pad %s was purchased!"):format(pad.Name)
	PlayerData:AddPadPurchased(player, padNumber)
	--print(PlayerData:CheckPadsPurchasedTable(player))
	UpdateUI:FireClient(player, nil, message)
end

PadPurchase.Event:Connect(onPadPurchased)

PadTouched.OnServerInvoke = function(player, pad, padNumber)
	local pad = padsFolder:FindFirstChild(pad.Name)
	if not pad then return end
	
	local padsPurchasedHighestNumber = if table.unpack(PlayerData:CheckPadsPurchasedTable(player)) == nil then nil else 0 
	
	if padsPurchasedHighestNumber == 0 then
		padsPurchasedHighestNumber = math.max(table.unpack(PlayerData:CheckPadsPurchasedTable(player)))
		--print(padsPurchasedHighestNumber)
		pad = padsFolder["Entrance_"..padsPurchasedHighestNumber + 1]
	else
		pad = padsFolder["Entrance_1"]
	end	
	
	padsPurchasedHighestNumber = nil
	
	if PlayerData:GetMoney(player) < pad:GetAttribute("Price") or pad:GetAttribute("isFinished") or ost() - PlayerData:CheckDebounce(player) < 1 then return pad.Name end
	
	local dependency = pad.Dependency.Value

	if dependency then
		if not dependency:GetAttribute("isFinished") then return pad.Name end				
	end
	
	local debounce = PlayerData:SetDebounce(player, ost())

	pad:SetAttribute("isFinished", true)

	onPadTouch(player, pad, padNumber)
	
	return pad.Next.Value
end
