--[[
	Debug Controller
	Handles the client-sided aspects of the game's debugging system
--]]

local DebugController = {}

---------------------
-- Roblox Services --
---------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

------------------
-- Dependencies --
------------------
local DebugService;
local Cmdr;
local VariableWatchUI = require(script.VariableWatchUI)

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : AddDebugVariableLabel
-- @Description : Adds a debug variable label to the variable watch UI
-- @Params : string "VariableName" : The name of the variable to add
--           Variant "Value" : The value of the variable to add
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugController:AddDebugVariableLabel(VariableName,Value)
	VariableWatchUI:AddVariable(VariableName,Value)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : RemoveDebugVariableLabel
-- @Description : Removes a debug variable label from the variable watch UI
-- @Params : string "VariableName" : The name of the variable to remove
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugController:RemoveDebugVariableLabel(VariableName)
	VariableWatchUI:RemoveVariable(VariableName)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : UpdateDebugVariableLabel
-- @Description : Updates a debug variable label in the variable watch UI
-- @Params : string "VariableName" : The name of the variable to update
--           Variant "Value" : The value of the variable to update
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugController:UpdateDebugVariableLabel(VariableName,Value)
	VariableWatchUI:UpdateVariable(VariableName,Value)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the service module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugController:Init()
	self:DebugLog("[Debug Controller] Initializing...")

	DebugService = self:GetService("DebugService")
	Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))

	VariableWatchUI:Init()

	if RunService:IsStudio() or game.GameId == 2022463223 then
		VariableWatchUI:Show()
	end

	self:DebugLog("[Debug Controller] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all services are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugController:Start()
	self:DebugLog("[Debug Controller] Running!")

	if (not DebugService:CanUseConsole()) and (not RunService:IsStudio()) then
		Cmdr:SetEnabled(false)
	end
end

return DebugController