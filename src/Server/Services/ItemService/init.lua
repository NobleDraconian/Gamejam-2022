--[[
	Item Service

	Handles the interactions with items (such as the lantern)
--]]

local ItemService = {Client = {}}
ItemService.Client.Server = ItemService

---------------------
-- Roblox Services --
---------------------
local ServerStorage = game:GetService("ServerStorage")
local CollectionService = game:GetService("CollectionService")
local Workspace = game:GetService("Workspace")

-------------
-- Defines --
-------------
local Items = ServerStorage.Assets.Items

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : DestroySpawnedItems
-- @Description : Destroys all currently spawned items
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemService:DestroySpawnedItems()
	for _,ItemModel in pairs(CollectionService:GetTagged("ItemModel")) do
		ItemModel:Destroy()
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : SpawnItem
-- @Description : Spawns the specified item at the given location
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemService:SpawnItem(ItemName,CF)
	local Item = Items[ItemName]
	local ItemModel = Instance.new('Model')
	local ProximityPrompt = Instance.new('ProximityPrompt')
	ProximityPrompt.ActionText = "Grab Item"
	ProximityPrompt.Parent = ItemModel
	local PromptTriggered_Connection;

	CollectionService:AddTag(ItemModel,"ItemModel")

	PromptTriggered_Connection = ProximityPrompt.Triggered:connect(function(Player)
		PromptTriggered_Connection:Disconnect()

		local NewItem = Item:Clone()
		NewItem.Parent = Player.Backpack
		ItemModel:Destroy()
	end)
	for _,Object in pairs(Item:GetChildren()) do
		local NewObject = Object:Clone()
		NewObject.Parent = ItemModel

		if NewObject:IsA("BasePart") then
			NewObject.Anchored = true
			NewObject.CanCollide = false
		end

		if NewObject.Name == "Handle" then
			ItemModel.PrimaryPart = NewObject
		end

		NewObject.Parent = ItemModel
	end
	ItemModel.Parent = Workspace
	ItemModel:SetPrimaryPartCFrame(CF)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the service module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemService:Init()
	self:DebugLog("[Item Service] Initializing...")

	self:DebugLog("[Item Service] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all services are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function ItemService:Start()
	self:DebugLog("[Item Service] Running!")

end

return ItemService