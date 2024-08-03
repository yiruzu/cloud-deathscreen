local Cloud <const> = require("config")

if Cloud.Framework == "qbcore" then
	local QBCore = exports["qb-core"]:GetCoreObject()

	RevivePed = function()
		TriggerServerEvent("hospital:server:RespawnAtHospital")
	end

	SetDeathStatus = function(bool)
		TriggerServerEvent("hospital:server:SetDeathStatus", bool)
		TriggerServerEvent("hospital:server:SetLaststandStatus", bool)
	end

	SendDistressSignal = function()
		TriggerServerEvent("hospital:server:ambulanceAlert", "Unconscious Person")
	end

	ClientNotify = function(msg)
		QBCore.Functions.Notify(msg)
	end
end
