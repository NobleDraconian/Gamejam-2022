--[[
	Avatar Controller

	Handles any functionality regarding player avatars
--]]

local AvatarController = {}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : SetRagdolled
-- @Description : Ragdolls or unragdolls the player's avatar
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AvatarController:SetRagdolled(ShouldRagdoll)
	shared.SetRagdolled(ShouldRagdoll)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the controller module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AvatarController:Init()
	self:DebugLog("[Avatar Controller] Initializing...")

	self:DebugLog("[Avatar Controller] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all controllers are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AvatarController:Start()

	self:DebugLog("[Avatar Controller] Running!")
end

return AvatarController