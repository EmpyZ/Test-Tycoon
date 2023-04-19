local PlayerData = {}

local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local UpdateUI: RemoteEvent = game.ReplicatedStorage.Remotes.UpdateUI
local data = {}


local GPS = {
	["2x Coins"] = 165117261,
	["Auto Collect"] = 165116425,
}

local ost = os.time

local defaultData = {
	money = 0,
	paycheck = 100,
	paycheckWithdrawAmount = 0,
	serverDebouncer = 0,
	gamepasses = {
		["Two Times Coins"] = false,
		["Auto Collect"] = false,
	},
	padsPurchased = {}
}

function PlayerData:GetPaycheckWithdrawAmount(player)
	local data = PlayerData:GetPlayerData(player)
	return data.paycheckWithdrawAmount
end

function PlayerData:SetPaycheckWithdrawAmount(player, amount)
	local data = PlayerData:GetPlayerData(player)
	--data.money = if PlayerData:GetGamepassInfo(player, "Auto Collect") then data.money + amount else data.money data.paycheckWithdrawAmount = amount
	if PlayerData:GetGamepassInfo(player, "Auto Collect") then
		data.money += amount
		data.paycheckWithdrawAmount = 0
		UpdateUI:FireClient(player, data.money)
	else
		data.paycheckWithdrawAmount = amount
	end
end

function PlayerData:GetPlayerData(player)
	return data[player.UserId]
end

function PlayerData:GetMoney(player, amount)
	local data = PlayerData:GetPlayerData(player)
	return data.money
end

function PlayerData:SetMoney(player, amount)
	local data = PlayerData:GetPlayerData(player)
	data.money = amount
	UpdateUI:FireClient(player, data.money)
end

function PlayerData:GetPaycheck(player)
	local data = PlayerData:GetPlayerData(player)
	return data.paycheck
end

function PlayerData:SetPaycheck(player, amount)
	local data = PlayerData:GetPlayerData(player)
	data.paycheck = amount
end

function PlayerData:AddMoney(player, amount)
	local data = PlayerData:GetPlayerData(player)
	data.money += amount
	--print(data.money)
	UpdateUI:FireClient(player, data.money)
end

function PlayerData:SubtractMoney(player, amount)
	local data = PlayerData:GetPlayerData(player)
	data.money -= amount
	UpdateUI:FireClient(player, data.money)
end

function PlayerData:CheckPadsPurchasedTable(player:Player): IntValue
	local data = PlayerData:GetPlayerData(player)
	return data.padsPurchased
end

function PlayerData:AddPadPurchased(player,padNumber)
	local data = PlayerData:GetPlayerData(player)
	table.insert(data.padsPurchased,padNumber)
end

function PlayerData:CheckDebounce(player): DateTime
	local data = PlayerData:GetPlayerData(player)
	return data.serverDebouncer
end

function PlayerData:SetDebounce(player, dbTime)
	local data = PlayerData:GetPlayerData(player)
	data.serverDebouncer = dbTime
end

function PlayerData:GetGamepassInfo(player,gp)
	local data = PlayerData:GetPlayerData(player)
	return data.gamepasses[gp]
end

function PlayerData:SetGamepassInfo(player,gp)
	local data = PlayerData:GetPlayerData(player)
	data.gamepasses[gp] = true
	print(data.gamepasses[gp])
end

MarketplaceService.PromptGamePassPurchaseFinished:Connect(function(player, purchasedPassID, purchaseSuccess)
	for index, passID in GPS do
		if purchasedPassID == passID then -- and purchaseSuccess
			print(player.Name .. " purchased the Pass with ID " .. passID)
			PlayerData:SetGamepassInfo(player,index)
		end
	end	
end)

Players.PlayerAdded:Connect(function(player)
	data[player.UserId] = defaultData
	
	player.CharacterAdded:Connect(function(character)
		local data = PlayerData:GetPlayerData(player)
		PlayerData:SetMoney(player,data.money)
	end)

end)

return PlayerData
