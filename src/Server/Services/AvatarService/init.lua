--[[
	Avatar Service
	Handles any functionality regarding player avatars
--]]

local AvatarService = {Client = {}}
AvatarService.Client.Server = AvatarService

---------------------
-- Roblox Services --
---------------------
local RunService = game:GetService("RunService")

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : LoadPlayerCharacter
-- @Description : Loads the specified player's character
-- @Params : Instance <Player> "PLayer" - The player to load the character of
--           OPTIONAL bool "Timeout" - The time to wait until failing the operation. Defaults to 10 seconds.
-- @Returns : bool "LoadSuccessful" - Whether or not the player's character was loaded successfully
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AvatarService:LoadPlayerCharacter(Player,Timeout)
	local LoadSuccess = false
	local TimeoutReached = false
	local LoadOperation_Completed = false
	Timeout = Timeout or 10

	coroutine.wrap(function()
		local LoadCharacter_Success,LoadCharacter_Error = pcall(function()
			Player:LoadCharacter()
		end)

		if not LoadCharacter_Success then
			self:Log("[Avatar Service] Failed to load chararacter for player '" .. Player.Name .. "' : " .. LoadCharacter_Error,"Warning")

			LoadOperation_Completed = true
		else
			LoadSuccess = true
			LoadOperation_Completed = true
		end
	end)()

	coroutine.wrap(function()
		task.wait(Timeout)

		if not LoadOperation_Completed then
			self:Log("[Avatar Service] Failed to load character for player '" .. Player.Name .. "' : Timeout reached","Warning")

			TimeoutReached = true
		end
	end)()

	while true do
		if LoadOperation_Completed then
			return LoadSuccess
		elseif TimeoutReached then
			return false
		end
		RunService.Stepped:wait()
	end
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Init
-- @Description : Called when the service module is first loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AvatarService:Init()
	self:DebugLog("[Avatar Service] Initializing...")

	self:DebugLog("[Avatar Service] Initialized!")
end

----------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- @Name : Start
-- @Description : Called after all services are loaded.
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
function AvatarService:Start()

	self:DebugLog("[Avatar Service] Running!")
end

return AvatarService