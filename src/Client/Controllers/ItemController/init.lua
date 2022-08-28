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
local ItemEquipped; -- Fired when the player equips an item

-------------
-- Defines --
-------------
local LocalPlayer = Players.LocalPlayer
local TriggerDebounce = false
local ChildAdded_Connection;

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function HandleLeftClick(_,UserInputState)
	if UserInputState == Enum.UserInputState.Begin then
		if not TriggerDebounce then
			TriggerDebounce = true

			if LocalPlayer.Character ~= nil then
				for _,Object in pairs(LocalPlayer.Character:GetChildren()) do
					if Object:IsA("Tool") then
						warn(Object.Name)
						ItemUsed:Fire(Object.Name,Object)
					end
				end
			end
			task.wait(2)
			TriggerDebounce = false
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
	ItemEquipped = self:RegisterControllerClientEvent("ItemEquipped")
	
	self:DebugLog("[Item Controller] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all controllers are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemController:Start()
	self:DebugLog("[Item Controller] Running!")

	ContextActionService:BindAction("UseHelditem",HandleLeftClick,true,Enum.UserInputType.MouseButton1)

	LocalPlayer.CharacterAdded:connect(function(Character)
		if ChildAdded_Connection ~= nil then
			if ChildAdded_Connection.Connected then
				ChildAdded_Connection:Disconnect()
			end
		end

		ChildAdded_Connection = Character.ChildAdded:connect(function(Object)
			if Object:IsA("Tool") then
				warn(Object.Name)
				ItemEquipped:Fire(Object.Name,Object)
			end
		end)
	end)
end

return ItemController