local Config = require("shared.sh_config")

function CallEmergency()
	if Config.Framework == "esx" then
		TriggerServerEvent("esx_ambulancejob:onPlayerDistress")
	elseif Config.Framework == "qbcore" then
		TriggerServerEvent("hospital:server:ambulanceAlert", "Unconscious Person")
	elseif Config.Framework == "custom" then
		-- Your custom logic here
	end
end

--- Handles the voice state (mute/unmute) based on the configured voice system.
---@param isActive boolean  -- true to activate voice, false to deactivate
function HandleVoiceState(isActive)
	if Config.Voice == "pma-voice" then
		MumbleSetActive(isActive)
	elseif Config.Voice == "saltychat" then
		TriggerServerEvent("cloud-deathscreen:server:IsDeadSaltyChat", isActive)
	end
end

---@param msg string  -- The message content for the notification
---@param type string  -- The type of notification (e.g., "info", "error", "success")
function ClientNotify(msg, type)
	lib.notify({
		title = "Information",
		description = msg,
		type = type,
		position = "top-left",
		duration = 5000,
	})
end

---@param source number  -- The player source ID to whom the notification is sent
---@param msg string  -- The message content for the notification
---@param type string  -- The type of notification (e.g., "info", "error", "success")
function ServerNotify(source, msg, type)
	TriggerClientEvent("ox_lib:notify", source, {
		title = "Information",
		description = msg,
		type = type,
		position = "top-left",
		duration = 5000,
	})
end
