--[[
	Level Service

	Handles the loading & execution of levels
--]]

local LevelService = {Client = {}}
LevelService.Client.Server = LevelService

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the service module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelService:Init()
	self:DebugLog("[Level Service] Initializing...")

	self:DebugLog("[Level Service] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all services are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelService:Start()

	self:DebugLog("[Level Service] Running!")
end

return LevelService