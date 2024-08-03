local Cloud <const> = require("config")

if Cloud.Framework == "esx" then
	ESX = exports["es_extended"]:getSharedObject()

	RevivePed = function() -- for some reason esx doesnt have a simple event we could trigger to revive the ped like in qbcore thats why we have to use this
		CreateThread(function()
			local playerPed <const> = cache.ped
			local coords <const> = Cloud.RespawnCoords
			-- wait for collision
			RequestCollisionAtCoord(coords.x, coords.y, coords.z)
			while not HasCollisionLoadedAroundEntity(playerPed) do
				Wait(0)
			end
			DoScreenFadeOut(0)
			-- revive player
			SetEntityCoordsNoOffset(playerPed, coords.x, coords.y, coords.z, false, false, false)
			NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w, 0, false)
			SetPlayerInvincible(playerPed, false)
			ClearPedBloodDamage(playerPed)
			-- trigger esx events
			TriggerEvent("esx_basicneeds:resetStatus")
			TriggerServerEvent("esx:onPlayerSpawn")
			TriggerEvent("esx:onPlayerSpawn")
			TriggerEvent("playerSpawned")
			while not IsScreenFadedOut() do
				Wait(0)
			end
			DoScreenFadeIn(2000)
		end)
	end

	SetDeathStatus = function(bool)
		TriggerServerEvent("esx_ambulancejob:setDeathStatus", bool)
	end

	AddEventHandler("esx:onPlayerDeath", function(data)
		TriggerEvent("cloud-deathscreen:client:onPlayerDeath", true)
	end)

	SendDistressSignal = function()
		TriggerServerEvent("esx_ambulancejob:onPlayerDistress")
	end

	ClientNotify = function(msg)
		ESX.ShowNotification(msg)
	end
end
