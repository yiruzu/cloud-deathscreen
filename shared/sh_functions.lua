local Config = require("shared.sh_config")

--- Sends a notification to a specific player on the client.
---@param msg string -- Notification message
---@param type string -- Notification type (e.g., "success", "error", "info")
function ClientNotify(msg, type)
	lib.notify({
		title = "Information",
		description = msg,
		type = type,
		position = "top-left",
		duration = 5000,
	})
end

--- Sends a notification to a specific player on the server.
---@param source number -- Player's source ID
---@param msg string -- Notification message
---@param type string -- Notification type (e.g., "success", "error", "info")
function ServerNotify(source, msg, type)
	TriggerClientEvent("ox_lib:notify", source, {
		title = "Information",
		description = msg,
		type = type,
		position = "top-left",
		duration = 5000,
	})
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
