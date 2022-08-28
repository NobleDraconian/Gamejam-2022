--[[
	Item Controller

	Handles the loading & execution of levels
--]]

local ItemController = {}

---------------------
-- Roblox Services --
---------------------
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")

------------
-- Events --
------------
local ItemUsed; -- Fired when the player left clicks while holding an item

-------------
-- Defines --
-------------
local LocalPlayer = Players.LocalPlayer

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HandleLeftClick(_,UserInputState)
	if UserInputState == Enum.UserInputState.Begin then
		if LocalPlayer.Character ~= nil then
			for _,Object in pairs(LocalPlayer.Character:GetChildren()) do
				if Object:IsA("Tool") then
					warn(Object.Name)
					ItemUsed:Fire(Object.Name)
				end
			end
		end
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the controller module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemController:Init()
	self:DebugLog("[Item Controller] Initializing...")

	ItemUsed = self:RegisterControllerClientEvent("ItemUsed")
	
	self:DebugLog("[Item Controller] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all controllers are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemController:Start()
	self:DebugLog("[Item Controller] Running!")

	ContextActionService:BindAction("UseHelditem",HandleLeftClick,true,Enum.UserInputType.MouseButton1)
end

return ItemController