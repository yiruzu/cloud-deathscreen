local Config = require("shared.sh_config")

lib.versionCheck("yiruzu/cloud-deathscreen")

if not Config.Voice == "saltychat" then return end
RegisterNetEvent("cloud-deathscreen:server:IsDeadSaltyChat", function(isDead)
	exports["saltychat"]:SetPlayerAlive(cache.playerId, isDead)
end)
