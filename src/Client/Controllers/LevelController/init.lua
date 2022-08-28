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
local Workspace = game:GetService("Workspace")

------------------
-- Dependencies --
------------------
local LevelService;
local AvatarController;
local LightingController;
local ItemController;
local TransitionUI = require(script.TransitionUI)

-------------
-- Defines --
-------------
local BASE_STATE = {
	Area1 = {
		SaplingFertilized = false,
		SaplingWatered = false,
		SaplingIsGrown = false,
		GrownSaplingChopped = false
	},
	Area2 = {
		StickLit = false,
		TreesLit = false
	}
}

local LocalPlayer = Players.LocalPlayer
local LevelConfigs = ReplicatedStorage.Modules.LevelConfigs
local IsInFuture = false
local CurrentState = {}

local CurrentMap;
local LevelMusic_Sound = Instance.new('Sound')
LevelMusic_Sound.Parent = script
LevelMusic_Sound.Looped = true

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Helper functions
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
local function ShowModel(Model)
	for _,Object in pairs(Model:GetDescendants()) do
		if Object:IsA("BasePart") then
			Object.Transparency = Object:GetAttribute("OriginalTransparency")
			Object.CanCollide = Object:GetAttribute("OriginalCanCollide")
			Object.CanTouch = Object:GetAttribute("OriginalCanTouch")
		elseif Object:IsA("ParticleEmitter") then
			Object.Enabled = true
		end
	end
end

local function HideModel(Model)
	for _,Object in pairs(Model:GetDescendants()) do
		if Object:IsA("BasePart") then
			Object:SetAttribute("OriginalTransparency",Object.Transparency)
			Object:SetAttribute("OriginalCanCollide",Object.CanCollide)
			Object:SetAttribute("OriginalCanTouch",Object.CanTouch)

			Object.Transparency = 1
			Object.CanCollide = false
			Object.CanTouch = false
		elseif Object:IsA("ParticleEmitter") then
			Object.Enabled = false
		end
	end
end

local function GetPartWithTag(Tag)
	for _,Object in pairs(Workspace:GetDescendants()) do
		if CollectionService:HasTag(Object,Tag) then
			return Object
		end
	end
end

local function CopyTable(original)
	local copy = {}
	for k, v in pairs(original) do
		if type(v) == "table" then
			v = CopyTable(v)
		end
		copy[k] = v
	end
	return copy
end

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
	ItemController = self:GetController("ItemController")

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
		warn("LEVEL LOADED")
		local LevelConfig = require(LevelConfigs[LevelName])
		local FinishTouched_Connection;
		local DeathTouched_Connection;
		CurrentMap = Map
		IsInFuture = false
		CurrentState = CopyTable(BASE_STATE)

		LevelMusic_Sound.SoundId = "rbxassetid://" .. LevelConfig.MusicID
		
		LightingController:LoadLightingState(LevelConfig.LightingState)
		LevelMusic_Sound:Play()

		for _,ShiftableModel in pairs(CollectionService:GetTagged("TimeShiftable")) do
			HideModel(ShiftableModel.Future)
			HideModel(ShiftableModel.Present)

			if ShiftableModel:GetAttribute("Visible") ~= false then
				ShowModel(ShiftableModel.Present)
			end
		end
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

	----------------------------
	-- Handling gear triggers --
	----------------------------
	ItemController.ItemUsed:connect(function(ItemName)
		if ItemName == "TimeLantern" then
			IsInFuture = not IsInFuture

			for _,ShiftableModel in pairs(CollectionService:GetTagged("TimeShiftable")) do
				if ShiftableModel:GetAttribute("Visible") ~= false then
					if IsInFuture then
						ShowModel(ShiftableModel.Future)
						HideModel(ShiftableModel.Present)
					else
						ShowModel(ShiftableModel.Present)
						HideModel(ShiftableModel.Future)
					end
				end
			end
		end
	end)

	ItemController.ItemEquipped:connect(function(ItemName,Item)
		if ItemName == "FertilizerBag" then
			if not CurrentState.Area1.SaplingFertilized and not IsInFuture then
				local FertilizePart = GetPartWithTag("L1A1_Sapling")
				local OldPrompt = FertilizePart:FindFirstChildWhichIsA("ProximityPrompt")
				local ProximityPrompt = Instance.new('ProximityPrompt')
				ProximityPrompt.ActionText = "Fertilize the Sapling"
				ProximityPrompt.Parent = FertilizePart
				local PromptTriggered_Connection;

				if OldPrompt ~= nil then
					OldPrompt:Destroy()
				end

				PromptTriggered_Connection = ProximityPrompt.Triggered:connect(function()
					warn("TRIGGERED")
					PromptTriggered_Connection:Disconnect()
					ProximityPrompt:Destroy()
					Item:Destroy()

					CurrentState.Area1.SaplingFertilized = true

					if CurrentState.Area1.SaplingFertilized and CurrentState.Area1.SaplingWatered and not CurrentState.Area1.SaplingIsGrown then
						CurrentState.Area1.SaplingIsGrown = true
						HideModel(CurrentMap.Course.Area1.Sapling_BadOutcome)
						ShowModel(CurrentMap.Course.Area1.Sapling_GoodOutcome.Present)
						CurrentMap.Course.Area1.Sapling_BadOutcome:SetAttribute("Visible",false)
						CurrentMap.Course.Area1.Sapling_GoodOutcome:SetAttribute("Visible",true)
					end
				end)
			end
		elseif ItemName == "WateringCan" then
			if not CurrentState.Area1.SaplingWatered and not IsInFuture then
				local WaterPart = GetPartWithTag("L1A1_Sapling")
				local OldPrompt = WaterPart:FindFirstChildWhichIsA("ProximityPrompt")
				local ProximityPrompt = Instance.new('ProximityPrompt')
				ProximityPrompt.ActionText = "Water the Sapling"
				ProximityPrompt.Parent = WaterPart
				local PromptTriggered_Connection;

				if OldPrompt ~= nil then
					OldPrompt:Destroy()
				end

				PromptTriggered_Connection = ProximityPrompt.Triggered:connect(function()
					warn("TRIGGERED")
					PromptTriggered_Connection:Disconnect()
					ProximityPrompt:Destroy()
					Item:Destroy()

					CurrentState.Area1.SaplingWatered = true

					if CurrentState.Area1.SaplingFertilized and CurrentState.Area1.SaplingWatered and not CurrentState.Area1.SaplingIsGrown then
						CurrentState.Area1.SaplingIsGrown = true
						HideModel(CurrentMap.Course.Area1.Sapling_BadOutcome)
						ShowModel(CurrentMap.Course.Area1.Sapling_GoodOutcome.Present)
						CurrentMap.Course.Area1.Sapling_BadOutcome:SetAttribute("Visible",false)
						CurrentMap.Course.Area1.Sapling_GoodOutcome:SetAttribute("Visible",true)
					end
				end)
			end
		elseif ItemName == "Axe" then
			warn(CurrentState)
			if CurrentState.Area1.SaplingIsGrown and IsInFuture then
				local AxePart = GetPartWithTag("L1A1_Sapling")
				local OldPrompt = AxePart:FindFirstChildWhichIsA("ProximityPrompt")
				local ProximityPrompt = Instance.new('ProximityPrompt')
				ProximityPrompt.ActionText = "Chop the tree"
				ProximityPrompt.RequiresLineOfSight = false
				ProximityPrompt.Parent = AxePart
				local PromptTriggered_Connection;

				if OldPrompt ~= nil then
					OldPrompt:Destroy()
				end

				PromptTriggered_Connection = ProximityPrompt.Triggered:connect(function()
					warn("TRIGGERED")
					PromptTriggered_Connection:Disconnect()
					ProximityPrompt:Destroy()
					Item:Destroy()

					CurrentState.Area1.GrownSaplingChopped = true
				end)
			end
		elseif ItemName == "Stick" then
			if not CurrentState.Area2.StickLit and not IsInFuture then
				local FirePart = GetPartWithTag("L2A2_Campfire")
				local OldPrompt = FirePart:FindFirstChildWhichIsA("ProximityPrompt")
				local ProximityPrompt = Instance.new('ProximityPrompt')
				ProximityPrompt.ActionText = "Set on fire"
				ProximityPrompt.RequiresLineOfSight = false
				ProximityPrompt.Parent = FirePart
				local PromptTriggered_Connection;

				if OldPrompt ~= nil then
					OldPrompt:Destroy()
				end

				PromptTriggered_Connection = ProximityPrompt.Triggered:connect(function()
					warn("TRIGGERED")
					PromptTriggered_Connection:Disconnect()
					ProximityPrompt:Destroy()

					Instance.new('Fire',Item.Handle)

					CurrentState.Area2.StickLit = true
				end)
			end

			if CurrentState.Area2.StickLit and (not CurrentState.Area2.TreesLit) and not IsInFuture then
				local FirePart = GetPartWithTag("L2A2_FireTrees")
				local OldPrompt = FirePart:FindFirstChildWhichIsA("ProximityPrompt")
				local ProximityPrompt = Instance.new('ProximityPrompt')
				ProximityPrompt.ActionText = "Set on fire"
				ProximityPrompt.RequiresLineOfSight = false
				ProximityPrompt.Parent = FirePart
				local PromptTriggered_Connection;

				if OldPrompt ~= nil then
					OldPrompt:Destroy()
				end

				PromptTriggered_Connection = ProximityPrompt.Triggered:connect(function()
					warn("TRIGGERED")
					PromptTriggered_Connection:Disconnect()
					ProximityPrompt:Destroy()
					Item:Destroy()

					ShowModel(CurrentMap.Course.Area2.BlockingTrees_Fire.Present)
					HideModel(CurrentMap.Course.Area2.BlockingTrees_NoFire)

					CurrentMap.Course.Area2.BlockingTrees_Fire:SetAttribute("Visible",true)
					CurrentMap.Course.Area2.BlockingTrees_NoFire:SetAttribute("Visible",false)

					CurrentState.Area2.TreesLit = true
				end)
			end
		end
	end)

	TransitionUI:Show()
	LevelService:RunLevel("TestLevelFull")
end

return LevelController