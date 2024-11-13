local Config = require("shared.sh_config")

if Config.Framework ~= "esx" then return end

function RevivePed()
	TriggerEvent("esx_ambulancejob:RespawnAtHospital") --! Don't forget to check the documentation to ensure this works properly.
end

AddEventHandler("esx:onPlayerDeath", function()
	TriggerEvent("cloud-deathscreen:client:OnPlayerDeath")
end)
AddEventHandler("esx:onPlayerSpawn", function()
	TriggerEvent("cloud-deathscreen:client:OnPlayerSpawn")
end)
