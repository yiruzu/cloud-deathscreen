local Config = require("shared.sh_config")

if Config.Framework ~= "qbcore" then return end

function CallEmergency()
	TriggerServerEvent("hospital:server:ambulanceAlert", "Unconscious Person")
end

function RevivePed()
	TriggerServerEvent("hospital:server:RespawnAtHospital")
end

RegisterNetEvent("QBCore:Player:SetPlayerData", function(data)
	if data.metadata.isdead or data.metadata.inlaststand then
		TriggerEvent("cloud-deathscreen:client:OnPlayerDeath")
	else
		TriggerEvent("cloud-deathscreen:client:OnPlayerSpawn")
	end
end)
