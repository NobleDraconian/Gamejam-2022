--[[
	Level Controller

	Handles the loading & execution of levels
--]]

local LevelController = {}

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the controller module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelController:Init()
	self:DebugLog("[Level Controller] Initializing...")

	self:DebugLog("[Level Controller] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all controllers are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelController:Start()

	self:DebugLog("[Level Controller] Running!")
end

return LevelController