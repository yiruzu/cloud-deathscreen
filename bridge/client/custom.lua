local Config = require("shared.sh_config")

if Config.Framework ~= "custom" then return end

--- Handles the "CALL EMERGENCY" button action.
function CallEmergency()
	-- Your custom logic here
end

--- Revives the player character
function RevivePed()
	-- Add event or logic to revive the player character
end

--- Triggers player death functions
AddEventHandler("Your_Framework:OnPlayerDeath", function()
	TriggerEvent("cloud-deathscreen:client:OnPlayerDeath")
end)

--- Triggers player spawn functions
AddEventHandler("Your_Framework:OnPlayerSpawn", function()
	TriggerEvent("cloud-deathscreen:client:OnPlayerSpawn")
end)
