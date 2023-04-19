local SoundMod = require(game.ReplicatedStorage.Modules.SoundMod)

local paycheckMachinesFolder = workspace.PaycheckMachines
local paycheckMachines = paycheckMachinesFolder:GetChildren()

local RequestPaycheck: RemoteFunction = game.ReplicatedStorage.Remotes.RequestPaycheck
local UpdatePaycheckMachines: RemoteEvent = game.ReplicatedStorage.Remotes.UpdatePaycheckMachines

local nextPaymentValue = 0

local ost = os.time
local debouncer = 0

local function addMoneyParticles(paycheckMachine)
	local particle = game.ReplicatedStorage.Assets.Effects.Library.Confetti_1:Clone()
	particle.Enabled = true
	particle.Parent = paycheckMachine.ParticleAnchor
	game:GetService("Debris"):AddItem(particle,1.25)
end

for _, paycheckMachine in paycheckMachines do
	local pad: BasePart = paycheckMachine.PadComponents.Pad
	
	pad.Touched:Connect(function(hit)
		local humanoid = hit.Parent:FindFirstChild("Humanoid")
		if not humanoid or paycheckMachine:GetAttribute("Disabled") then return end
		if ost() - debouncer < 1 then
			return
		end
		
		debouncer = ost()
		local paycheck, enableSound = RequestPaycheck:InvokeServer(nextPaymentValue)
		
		if not paycheckMachine:GetAttribute("Disabled") and enableSound then
			addMoneyParticles(paycheckMachine)
			SoundMod:PlaySound("JanglingCoins","COINS!!!")
		end	
	end)
end

UpdatePaycheckMachines.OnClientEvent:Connect(function(amount)
	nextPaymentValue = amount
	for _, paycheckMachine in paycheckMachines do
		local moneyLabel = paycheckMachine:FindFirstChild("MoneyLabel", true)
		if moneyLabel then
			moneyLabel.Text = tostring(amount)
		end	
	end
end)
