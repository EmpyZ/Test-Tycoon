local ts = game:GetService("TweenService")
local Tweens = {}

function Tweens:MoveUI(gui, tt, sty, dir, pos, size, rpc, bool, timeAfter, runComplete)
	local screentweenIn = ts:Create(
		gui,
		TweenInfo.new(tt,sty,dir,rpc,bool,timeAfter),
		{
			Size = size,
			Position = pos
		}
	)
	screentweenIn:Play()
	if runComplete then
		screentweenIn.Completed:Wait()
	end
end

return Tweens
