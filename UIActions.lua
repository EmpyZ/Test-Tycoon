local Tweens = require(script.Parent.Tweens)

local Actions = {}

function Actions:CloneText(msg, parentTo, timeToWait)
	local text = script.TextLabel:Clone()
	text.Text = msg
	text.Parent = parentTo
	game:GetService("Debris"):AddItem(text,5)
	Tweens:MoveUI(text, 1.25, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut, UDim2.new(0.5,0,0.35,0), text.Size,0,false,0,true)
	task.wait(timeToWait)
	Tweens:MoveUI(text, .25, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, UDim2.new(-0.5,0,0.35,0), text.Size,0,false,0,false)
end

return Actions
