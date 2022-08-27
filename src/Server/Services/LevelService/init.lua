--[[
	Level Service

	Handles the loading & execution of levels
--]]

local LevelService = {Client = {}}
LevelService.Client.Server = LevelService

---------------------
-- Roblox Services --
---------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ServerStorage = game:GetService("ServerStorage")

------------------
-- Dependencies --
------------------
local AvatarService;

-------------
-- Defines --
-------------
local LevelConfigs = ReplicatedStorage.Modules.LevelConfigs
local Maps = ServerStorage.Assets.Maps

------------
-- Events --
------------
local LevelLoaded; -- Fired to the client when a level is loaded

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Client.RunLevel
-- @Description : Runs the specified level
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelService.Client:RunLevel(Player,LevelName)
	local LevelConfig = require(LevelConfigs[LevelName])
	local Map = Maps[LevelConfig.Map]:Clone()

	Map.Parent = Workspace
	Map:MoveTo(Vector3.new(5000,0,0))
	AvatarService:LoadPlayerCharacter(Player)
	Player.Character:SetPrimaryPartCFrame(Map.Spawn.CFrame)

	LevelLoaded:FireClient(Player,LevelName,Map)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the service module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelService:Init()
	self:DebugLog("[Level Service] Initializing...")

	LevelLoaded = self:RegisterServiceClientEvent("LevelLoaded")

	self:DebugLog("[Level Service] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all services are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelService:Start()
	self:DebugLog("[Level Service] Running!")

	AvatarService = self:GetService("AvatarService")
end

return LevelService