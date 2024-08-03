local Cloud <const> = require("config")

lib.versionCheck("yiruzu/cloud-deathscreen")

if Cloud.Voice == "saltychat" then
	local src = source
	local Player = GetPlayer(src)

	RegisterNetEvent("cloud-deathscreen:server:IsPlayerAliveSaltyChat")
	AddEventHandler("cloud-deathscreen:server:IsPlayerAliveSaltyChat", function(bool)
		exports["saltychat"]:SetPlayerAlive(Player, bool)
	end)
end
