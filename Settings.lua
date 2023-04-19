local Settings = {}
local Lighting = game:GetService("Lighting")
local SoundService = game:GetService("SoundService")

local modules = script.Parent


function Settings:Shadows(bool)
	Lighting.GlobalShadows = bool
end

function Settings:BackgroundSounds(bool)
	SoundService.Background.Volume = if bool == true then 0.5 else 0
end

function Settings:EffectSounds(bool)
	SoundService.Effects.Volume = if bool == true then 0.5 else 0
end

function Settings:BuildingVisuals(bool)
	modules.BuildingVisuals:SetAttribute("BuildVisuals", bool)
end


return Settings
