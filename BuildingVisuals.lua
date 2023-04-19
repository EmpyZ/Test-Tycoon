local BuildingVisuals = {}

local TweenS = game:GetService("TweenService")

local BUILDING_ANIMATION_POSITION_OFFSET_AMOUNT = 2
local BUILDING_ANIMATION_PART_DELAY = 0.00125

local rand = Random.new()

function BuildingVisuals:hasProperty(instance, property)
	assert(typeof(instance) == "Instance")
	assert(typeof(property) == "string")

	local hasProperty = false

	pcall(function()
		local v = instance[property] 
		hasProperty = true -- This line only runs if the previous line didn't error
	end)

	return hasProperty
end

function BuildingVisuals:instanceListToPropertyDict(instances, propertyList)
	assert(typeof(instances) == "table")
	assert(typeof(propertyList) == "table")

  --[[Given a list of instances and a list of properties, construct a dictionary like so:
  dict = {
      [instance1] = {property1 = instance1.property1, property2 = instance1.property2, ...},
      [instance2] = {property1 = instance2.property1, property2 = instance2.property2, ...},
      ...
  }]]
	local dict = {}

	for _, instance in ipairs(instances) do
		local dictEntry = {}

		for _, property in pairs(propertyList) do
			assert(BuildingVisuals:hasProperty(instance, property), string.format(
				[[Instance '%s' (a %s) doesn't have property '%s'.]], 
				tostring(instance), instance.ClassName, property)
			)
			dictEntry[property] = instance[property]
		end

		dict[instance] = dictEntry
	end

	return dict
end

function BuildingVisuals:getDescendantsWhichAre(ancestor, className)
	assert(typeof(ancestor) == "Instance")
	assert(typeof(className) == "string")

	--[[Returns all descendants of ancestor which are of class className or a class that inherits from className]]
	local descendants = {}

	for _, descendant in pairs(ancestor:GetDescendants()) do
		if descendant:IsA(className) then
			table.insert(descendants, descendant)
		end
	end

	return descendants
end

function BuildingVisuals:animateBuildingIn(buildingModel, tweenInfo)
	assert(typeof(buildingModel) == "Instance" and buildingModel.ClassName == "Model", string.format(
		"Invalid argument #1 to 'animateBuildingIn' (Model expected, got %s)", 
		typeof(buildingModel) == "Instance" and buildingModel.ClassName or typeof(buildingModel)
		))
	assert(typeof(tweenInfo) == "TweenInfo", string.format(
		"Invalid argument #1 to 'animateBuildingIn' (TweenInfo expected, got %s)",
		typeof(tweenInfo)
		))
	--Collect BaseParts and original properties
	local parts = BuildingVisuals:getDescendantsWhichAre(buildingModel, "BasePart")
	local originalProperties = BuildingVisuals:instanceListToPropertyDict(parts, {"Transparency", "CFrame", "Color", "Size"})

	--Make parts invisible and randomly move them
	for _, part in pairs(parts) do
		part.Transparency = 1
		part.Color = Color3.fromRGB(255, 255, 255)
		part.Size = Vector3.new()

		local positionOffset = Vector3.new(rand:NextNumber(-1, 1), rand:NextNumber(-0.25, 1.75), rand:NextNumber(-1, 1)) * BUILDING_ANIMATION_POSITION_OFFSET_AMOUNT
		local rotationOffset = CFrame.Angles(rand:NextNumber(-math.pi, math.pi), rand:NextNumber(-math.pi, math.pi), rand:NextNumber(-math.pi, math.pi))
		part.CFrame *= CFrame.new(positionOffset) * rotationOffset
	end

	--Tween them back to their original state, one at a time
	local lastTween --Return this so the caller can do animateBuilding(...):Wait() to wait for the animation to complete
	for _, part in pairs(parts) do
		local tween = TweenS:Create(part, tweenInfo, originalProperties[part])
		lastTween = tween

		tween.Completed:Connect(function(playbackState)
			--  Make sure each Part is *exactly* how it was before.
			part.Transparency = originalProperties[part].Transparency
			part.CFrame = originalProperties[part].CFrame
		end)

		tween:Play()

		task.wait(BUILDING_ANIMATION_PART_DELAY)
	end

	return lastTween.Completed
end	

return BuildingVisuals
