--[[
	Level Controller

	Handles the loading & execution of levels
--]]

local LevelController = {}

---------------------
-- Roblox Services --
---------------------
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")

------------------
-- Dependencies --
------------------
local LevelService;
local AvatarController;
local LightingController;
local TransitionUI = require(script.TransitionUI)

-------------
-- Defines --
-------------
local LocalPlayer = Players.LocalPlayer
local LevelConfigs = ReplicatedStorage.Modules.LevelConfigs

local LevelMusic_Sound = Instance.new('Sound')
LevelMusic_Sound.Parent = script
LevelMusic_Sound.Looped = true

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : StopLevel
-- @Description : Stops the current level
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelController:StopLevel()
	LevelMusic_Sound:Stop()
	TransitionUI:Show()
	LevelService:StopLevel()
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the controller module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelController:Init()
	self:DebugLog("[Level Controller] Initializing...")

	LevelService = self:GetService("LevelService")

	self:DebugLog("[Level Controller] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all controllers are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function LevelController:Start()
	self:DebugLog("[Level Controller] Running!")

	AvatarController = self:GetController("AvatarController")
	LightingController = self:GetController("LightingController")

	------------------------------------------------------
	-- Registering lighting states with lighting system --
	------------------------------------------------------
	for _,LightingModule in pairs(LocalPlayer.PlayerScripts.Modules.LightingConfigs:GetChildren()) do
		LightingController:RegisterLightingState(LightingModule.Name,require(LightingModule))
	end

	-------------------------------------------------------
	-- Executing a level when it is loaded on the server --
	-------------------------------------------------------
	LevelService.LevelLoaded:connect(function(LevelName,Map)
		local LevelConfig = require(LevelConfigs[LevelName])
		local FinishTouched_Connection;
		local DeathTouched_Connection;

		LevelMusic_Sound.SoundId = "rbxassetid://" .. LevelConfig.MusicID
		
		LightingController:LoadLightingState(LevelConfig.LightingState)
		LevelMusic_Sound:Play()
		TransitionUI:Hide()

		----------------------------
		-- Handling player deaths --
		----------------------------
		DeathTouched_Connection = LocalPlayer.Character:WaitForChild("Humanoid").Touched:connect(function(TouchingPart)
			if CollectionService:HasTag(TouchingPart,"Kill") then
				DeathTouched_Connection:Disconnect()
				LocalPlayer.Character.Humanoid.Health = 0
				AvatarController:SetRagdolled(true)
				task.wait(1)

				self:StopLevel()
				LevelService:RunLevel(LevelName)
			end
		end)

		--------------------------------
		-- Handling level end reached --
		--------------------------------
		FinishTouched_Connection = Map.Finish.Touched:connect(function(TouchingPart)
			if TouchingPart:IsDescendantOf(LocalPlayer.Character) then
				FinishTouched_Connection:Disconnect()
				self:StopLevel()
				LevelService:RunLevel("TestLevel2")
			end
		end)
	end)

	TransitionUI:Show()
	LevelService:RunLevel("TestLevel1")
end

return LevelController