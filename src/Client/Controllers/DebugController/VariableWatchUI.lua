--[[
	Manages the variable watch UI
--]]

local VariableWatchUI = {}

---------------------
-- Roblox Services --
---------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-------------
-- Defines --
-------------
local UI = ReplicatedStorage.Assets.UIs.VariableWatch_UI:Clone()

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : AddVariable
-- @Description : Adds a variable to the watch UI
-- @Params : string "VariableName" : The name of the variable to add
--           Variant "Value" : The value of the variable to add
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VariableWatchUI:AddVariable(VariableName,Value)
	local VariableLabel = UI.Variables.BaseVariableLabel:Clone()
	VariableLabel.Name = VariableName
	VariableLabel.Text = VariableName .. " : " .. tostring(Value)
	VariableLabel.Visible = true
	VariableLabel.Parent = UI.Variables
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : RemoveVariable
-- @Description : Removes a variable from the watch UI
-- @Params : string "VariableName" : The name of the variable to remove
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VariableWatchUI:RemoveVariable(VariableName)
	local VariableLabel = UI.Variables:FindFirstChild(VariableName)

	if VariableLabel ~= nil then
		VariableLabel:Destroy()
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : UpdateVariable
-- @Description : Updates a variable label in the watch UI
-- @Params : string "VariableName" : The name of the variable to update
--           Variant "Value" : The value of the variable to update
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VariableWatchUI:UpdateVariable(VariableName,Value)
	local VariableLabel = UI.Variables:FindFirstChild(VariableName)

	if VariableLabel ~= nil then
		VariableLabel.Text = VariableName .. " : " .. tostring(Value)
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Show
-- @Description : Shows the watch UI
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VariableWatchUI:Show()
	UI.Enabled = true
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Hide
-- @Description : Hides the watch UI
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VariableWatchUI:Hide()
	UI.Enabled = false
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Initializes the module.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function VariableWatchUI:Init()
	UI.Variables.BaseVariableLabel.Visible = false
	UI.Enabled = false
	UI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

	self:Hide()
end

return VariableWatchUI