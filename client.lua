local Cloud <const> = require("config")

local uiOpen = false
local isDead = false

local DisableControls = function()
	CreateThread(function()
		while uiOpen do
			DisableAllControlActions(0)
			for _, keyCode in ipairs(Cloud.EnabledControls) do
				EnableControlAction(0, keyCode, true)
			end
			Wait(0)
		end
	end)
end

local ShowUI = function()
	SendNUIMessage({ action = "show", status = true })
	SetNuiFocus(true, true)
	SetNuiFocusKeepInput(true)
	uiOpen = true
	DisableControls()
	if Cloud.BlurUIBackground then TriggerScreenblurFadeIn(0) end
end

local HideUI = function()
	SendNUIMessage({ action = "show", status = false })
	SetNuiFocus(false, false)
	uiOpen = false
	if Cloud.BlurUIBackground then TriggerScreenblurFadeOut(0) end
end

local HandleVoiceState = function(isActive)
	if Cloud.Voice == "pma-voice" then
		MumbleSetActive(isActive)
	elseif Cloud.Voice == "saltychat" then
		TriggerServerEvent("cloud-deathscreen:server:IsPlayerAliveSaltyChat", isActive)
	end
end

local RemovePlayerItems = function()
	if Cloud.Framework == "esx" then
		ESX.TriggerServerCallback("esx_ambulancejob:removeItemsAfterRPDeath")
		ESX.SetPlayerData("loadout", {})
	end
end

local LoadAnimDict = function(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(10)
	end
end

local onPlayerDeath = function()
	isDead = true
	CreateThread(function()
		SetDeathStatus(true)
		ShowUI()
		SendNUIMessage({
			action = "setTimers",
			timers = { mainTimer = Cloud.MainTimer, faceDeathTimer = Cloud.FaceDeathTimer },
		})
	end)
	HandleVoiceState(false)

	if Cloud.DeathAnim.enabled then
		Wait(750) -- slight delay before doing animation
		local playerPed <const> = cache.ped
		local maxHealth <const> = GetPedMaxHealth(playerPed)
		local coords <const> = GetEntityCoords(playerPed)
		local heading <const> = GetEntityHeading(playerPed)

		-- revive player to make animations work
		NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, 0, false)
		Wait(100)
		SetEntityHealth(playerPed, maxHealth)
		SetEntityInvincible(playerPed, true)

		local animDict <const> = Cloud.DeathAnim.animDict
		local animName <const> = Cloud.DeathAnim.animName

		LoadAnimDict(animDict)
		CreateThread(function()
			while isDead do
				if not IsEntityPlayingAnim(playerPed, animDict, animName, 3) then
					ClearPedTasks(playerPed)
					TaskPlayAnim(playerPed, animDict, animName, 8.0, 8.0, -1, 33, 0, false, false, false)
				end
				Wait(1000)
			end
		end)
	end
end

RegisterNetEvent("cloud-deathscreen:client:onPlayerDeath", onPlayerDeath)

if Cloud.Framework == "esx" then
	AddEventHandler("esx:onPlayerDeath", onPlayerDeath)
	AddEventHandler("esx:onPlayerSpawn", function()
		isDead = false
		HideUI()
		HandleVoiceState(true)
	end)
elseif Cloud.Framework == "qbcore" then
	RegisterNetEvent("QBCore:Player:SetPlayerData", function(data)
		if data.metadata.isdead or data.metadata.inlaststand then
			onPlayerDeath()
		else
			isDead = false
			HideUI()
			HandleVoiceState(true)
		end
	end)
end

RegisterNuiCallback("send_distress_signal", function(data)
	SendDistressSignal()
end)

local ReviveActions = function()
	isDead = false
	SetDeathStatus(false)
	HideUI()
	RevivePed()
	HandleVoiceState(true)
	RemovePlayerItems()
end

RegisterNuiCallback("face_death", function(data, cb)
	local soundName <const> = "CHECKPOINT_MISSED"
	local soundSet <const> = "HUD_MINI_GAME_SOUNDSET"
	local paymentMethod <const> = lib.callback.await("cloud-deathscreen:server:CanAfford", false)

	if paymentMethod then
		ReviveActions()
		lib.callback.await("cloud-deathscreen:server:RemoveMoney", false, paymentMethod)
		cb(true)
	else
		ClientNotify(Cloud.Locales.NoMoney)
		PlaySoundFrontend(-1, soundName, soundSet, true)
		cb(false)
	end
end)

RegisterNuiCallback("time_expired", function(data)
	ReviveActions()
end)
