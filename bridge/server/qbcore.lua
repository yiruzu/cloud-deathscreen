local Cloud <const> = require("config")

if Cloud.Framework == "qbcore" then
	local QBCore = exports["qb-core"]:GetCoreObject()

	GetPlayer = function(id)
		return QBCore.Functions.GetPlayer(id)
	end

	SetDeathStatus = function(isDead)
		TriggerClientEvent("cloud-deathscreen:client:onPlayerDeath", source, isDead)
	end

	ServerNotify = function(src, msg, type)
		TriggerClientEvent("QBCore:Notify", src, msg, type)
	end

	local CanAfford = function(source)
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)

		if Player then
			local moneyAvailable <const> = Player.Functions.GetMoney("cash")
			local bankAvailable <const> = Player.Functions.GetMoney("bank")

			if moneyAvailable >= Cloud.PriceForDeath then
				return "cash"
			elseif bankAvailable >= Cloud.PriceForDeath then
				return "bank"
			else
				ServerNotify(src, Cloud.Locales.NoMoney, "error")
				return false
			end
		end
		return false
	end

	local RemoveMoney = function(source, payMethod)
		local src = source
		local Player = QBCore.Functions.GetPlayer(src)

		if Player then
			if payMethod == "cash" then
				Player.Functions.RemoveMoney("cash", Cloud.PriceForDeath)
			elseif payMethod == "bank" then
				Player.Functions.RemoveMoney("bank", Cloud.PriceForDeath)
			end
			local msg <const> = (Cloud.Locales.MoneyRemoved):format(Cloud.PriceForDeath)
			ServerNotify(src, msg, "success")
			return true
		end
		return false
	end

	lib.callback.register("cloud-deathscreen:server:CanAfford", CanAfford)
	lib.callback.register("cloud-deathscreen:server:RemoveMoney", RemoveMoney)

	--! the removal of items after death is managed by the qb-ambulancejob resource
end
