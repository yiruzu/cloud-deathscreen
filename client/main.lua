local Config = require("shared.sh_config")
local Locales = require("shared.sh_locales")

local isDead = false

local function DisableControls()
	CreateThread(function()
		while isDead do
			DisableAllControlActions(0) -- This will disable in-game controls (e.g., movement, actions) but will not prevent menus or UIs that open via key mappings from appearing.
			for _, keyCode in ipairs(Config.EnabledControls) do
				EnableControlAction(0, keyCode, true)
			end
			Wait(0)
		end
	end)
end

local function ToggleUI(isVisible)
	SendNUIMessage({ action = "toggleDeathscreen", showDeathscreen = isVisible })
	SetNuiFocus(isVisible, isVisible)
	SetNuiFocusKeepInput(isVisible)
	DisableControls()
	if Config.BlurUIBackground then (isVisible and TriggerScreenblurFadeIn or TriggerScreenblurFadeOut)(0) end
end

-- Credits to qb-ambulancejob for some parts of this function
local function DoDeathAnim()
	local playerPed = cache.ped

	while GetEntitySpeed(playerPed) > 0.5 or IsPedRagdoll(playerPed) do
		Wait(10)
	end

	if isDead then
		local coords = GetEntityCoords(playerPed)
		local heading = GetEntityHeading(playerPed)

		if IsPedInAnyVehicle(playerPed, false) then
			local playerVeh = GetVehiclePedIsIn(playerPed, false)
			local vehSeats = GetVehicleModelNumberOfSeats(joaat(GetEntityModel(playerVeh)))
			for i = -1, vehSeats do
				local vehSeatPed = GetPedInVehicleSeat(playerVeh, i)
				if vehSeatPed == playerPed then
					NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z + 0.5, heading, 0, false)
					SetPedIntoVehicle(playerPed, playerVeh, i)
				end
			end
		else
			NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z + 0.5, heading, 0, false)
		end

		local maxHealth = GetPedMaxHealth(playerPed)
		SetEntityInvincible(playerPed, true)
		SetEntityHealth(playerPed, maxHealth)

		local animDict = IsPedInAnyVehicle(playerPed, false) and "veh@low@front_ps@idle_duck" or Config.DeathAnim.animDict
		local animName = IsPedInAnyVehicle(playerPed, false) and "sit" or Config.DeathAnim.animName

		while not HasAnimDictLoaded(animDict) do
			RequestAnimDict(animDict)
			Wait(50)
		end

		while isDead do
			if not IsEntityPlayingAnim(playerPed, animDict, animName, 8) then TaskPlayAnim(playerPed, animDict, animName, 1.0, 1.0, -1, 8, 0, false, false, false) end
			Wait(1000)
		end
	end
end

local function ReviveActions()
	isDead = false
	ToggleUI(false)
	RevivePed()
	HandleVoiceState(true)
end

local function OnPlayerDeath()
	isDead = true
	if IsPauseMenuActive() then SetFrontendActive(false) end
	ToggleUI(true)
	HandleVoiceState(false)
	if Config.DeathAnim.enabled then DoDeathAnim() end
end
RegisterNetEvent("cloud-deathscreen:client:OnPlayerDeath", OnPlayerDeath)

local function OnPlayerSpawn()
	isDead = false
	ToggleUI(false)
	HandleVoiceState(true)
end
RegisterNetEvent("cloud-deathscreen:client:OnPlayerSpawn", OnPlayerSpawn)

RegisterNUICallback("deathscreen:fetchData", function(data, cb)
	local label = data.label
	if not type(label) == "string" then return end

	local actions = {
		initData = function()
			cb({ locales = Locales.UI, soundVolume = Config.SoundVolume, mainTimer = Config.MainTimer, faceDeathTimer = Config.FaceDeathTimer })
		end,
		callEmergency = function()
			PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
			local success = pcall(CallEmergency)
			cb(success)
		end,
		faceDeath = function()
			local paymentSuccess = lib.callback.await("cloud-deathscreen:server:PayFine", false)

			if paymentSuccess then
				PlaySoundFrontend(-1, "Click", "DLC_HEIST_HACKING_SNAKE_SOUNDS", true)
				ReviveActions()
				cb(paymentSuccess)
			else
				PlaySoundFrontend(-1, "CHECKPOINT_MISSED", "HUD_MINI_GAME_SOUNDSET", true)
				cb(paymentSuccess)
			end
		end,
		timeExpired = function()
			local success = pcall(ReviveActions)
			cb(success)
		end,
	}

	local actionFunction = actions[label]
	if actionFunction then actionFunction() end
end)
