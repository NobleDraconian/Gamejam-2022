--[[
	Debug Service

	This services handles various debugging tasks for the game, such as forcing a mingigame.
	It utilizes the Cmdr package.
]]

local DebugService={Client = {}}
DebugService.Client.Server = DebugService

---------------------
-- Roblox Services --
---------------------
local Players=game:GetService("Players")
local RunService = game:GetService("RunService")

-------------
-- DEFINES --
-------------
local Cmdr; --The cmdr package

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : RegisterDebugCommandsIn
-- @Description : Registers all debug commands in the specified container. Useful for when services want to register
--                their own debug commands.
-- @Params : Instance Variant "Container" - The container containing all of the commands to register.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugService:RegisterDebugCommandsIn(Container)
	Cmdr:RegisterCommandsIn(Container)
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Client.CanUseConsole
-- @Description : Returns whether or not the calling client can use the console.
-- @Returns : boolean "CanUseConsole" - Whether or not the client can use the console.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugService.Client:CanUseConsole(Player)
	return Player:GetRankInGroup(4446965) >= 250
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the service module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugService:Init()

	-----------------
	-- Set up Cmdr --
	-----------------
	Cmdr=self:GetModule("Cmdr")
	Cmdr.Registry:RegisterCommandsIn(script.Commands)
	Cmdr.Registry:RegisterHooksIn(script.Hooks)

	--[[ Authorization hook ]]--
	Cmdr.Registry:RegisterHook("BeforeRun",function(Context)
		if Context.Group=="Developer" then
			if (not RunService:IsStudio()) and Context.Executor:GetRankInGroup(4446965)<252 then
				return "You are not authorized to run this command!"
			end
		end
	end)

	-- TODO : Add command logging

	self:DebugLog("[Debug Service] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all services are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function DebugService:Start()
	self:DebugLog("[Debug Service] Started!")

	--[[ Giving devs DragonEngine perms on join ]]--
	local function PlayerAdded(Player)
		local GroupRank = 0

		local Success,_ = pcall(function()
			GroupRank = Player:GetRankInGroup(4446965)
		end)

		if not Success then
			GroupRank = 0
		end

		if RunService:IsStudio() or GroupRank >= 252 then
			local Whitelist=self:GetService("EngineDebugService"):GetCommandWhitelist()
			for _,CommandWhitelist in pairs(Whitelist) do
				table.insert(CommandWhitelist,Player.UserId)
			end
			self:GetService("EngineDebugService"):SetCommandWhitelist(Whitelist)
		end
	end
	Players.PlayerAdded:connect(PlayerAdded)
	if #Players:GetPlayers() > 0 then
		for _,Player in pairs(Players:GetPlayers()) do
			PlayerAdded(Player)
		end
	end


	--[[ Removing DragonEngine perms from devs on leave to prevent memleak ]]--
	Players.PlayerRemoving:connect(function(Player)
		local GroupRank = 0

		local Success,_ = pcall(function()
			GroupRank = Player:GetRankInGroup(4446965)
		end)

		if not Success then
			GroupRank = 0
		end

		if RunService:IsStudio() or GroupRank >= 252 then
			local Whitelist=self:GetService("EngineDebugService"):GetCommandWhitelist()
			for _,CommandWhitelist in pairs(Whitelist) do
				for Index=1,#CommandWhitelist do
					if CommandWhitelist[Index]==Player.UserId then
						table.remove(CommandWhitelist,Index)
					end
				end
			end
			self:GetService("EngineDebugService"):SetCommandWhitelist(Whitelist)
		end
	end)

end

return DebugService