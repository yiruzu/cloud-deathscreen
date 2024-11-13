local Config = require("shared.sh_config")

lib.versionCheck("yiruzu/cloud-deathscreen")

if Config.Voice == "saltychat" then
	local player = GetPlayerId(source)

	RegisterNetEvent("cloud-deathscreen:server:IsDeadSaltyChat")
	AddEventHandler("cloud-deathscreen:server:IsDeadSaltyChat", function(isDead)
		exports["saltychat"]:SetPlayerAlive(player, isDead)
	end)
end
