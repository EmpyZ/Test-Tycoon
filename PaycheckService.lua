local Players = game:GetService("Players")
local PlayerData = require(script.Parent.PlayerData)

local RequestPaycheck: RemoteFunction = game.ReplicatedStorage.Remotes.RequestPaycheck
local UpdatePaycheckMachines: RemoteEvent = game.ReplicatedStorage.Remotes.UpdatePaycheckMachines

local PAYCHECK_UPDATE_INTERVAL = 1
local PAYCHECK_INCREMENTAL_VALUE = 100

local ost = os.time

local playersPaychecks = {}
local playerWallets = {}

local function onPlayerAdded(player)
	task.wait(2)
	local gamepass_addition_coins = 0
	
	while true do
		if PlayerData:GetGamepassInfo(player, "2x Coins") then
			gamepass_addition_coins = 100
		end
		PlayerData:SetPaycheckWithdrawAmount(player, PlayerData:GetPaycheckWithdrawAmount(player) + PAYCHECK_INCREMENTAL_VALUE + gamepass_addition_coins)
		UpdatePaycheckMachines:FireClient(player, PlayerData:GetPaycheckWithdrawAmount(player))
		task.wait(PAYCHECK_UPDATE_INTERVAL)
	end
end

Players.PlayerAdded:Connect(onPlayerAdded)

RequestPaycheck.OnServerInvoke = function(player, amount)
	if ost() - PlayerData:CheckDebounce(player) < 1 or PlayerData:GetPaycheckWithdrawAmount(player) == 0 then return 0,false end
	if PlayerData:GetGamepassInfo(player,"Auto Collect") then
		workspace.PaycheckMachines.PaycheckMachine:SetAttribute("Disabled", true)
		return 0, false
	end
	
	if amount > PlayerData:GetPaycheckWithdrawAmount(player) then warn("looks like someone is tampering with the local scripts, possibly ban or kick them")
		PlayerData:SetPaycheckWithdrawAmount(player, -100000000000)
		return 0, false
	end
	local debounce = PlayerData:SetDebounce(player, ost())
	PlayerData:AddMoney(player, PlayerData:GetPaycheckWithdrawAmount(player))
	--print(PlayerData:GetPaycheckWithdrawAmount(player))
	--print(PlayerData:GetMoney(player))
	local paycheck = PlayerData:SetPaycheckWithdrawAmount(player, 0)
	UpdatePaycheckMachines:FireClient(player, PlayerData:GetPaycheckWithdrawAmount(player))
	
	return amount, true
end
