local Cloud <const> = require("config")

if Cloud.Framework == "esx" then
	local ESX = exports["es_extended"]:getSharedObject()

	GetPlayer = function(id)
		return ESX.GetPlayerFromId(id)
	end

	ServerNotify = function(src, msg, type)
		TriggerClientEvent("esx:showNotification", src, msg, type)
	end

	local CanAfford = function(source)
		local src = source
		local xPlayer = ESX.GetPlayerFromId(src)

		if xPlayer then
			local moneyAvailable <const> = xPlayer.getMoney()
			local bankAvailable <const> = xPlayer.getAccount("bank").money

			if moneyAvailable >= Cloud.PriceForDeath then
				return "money"
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
		local xPlayer = ESX.GetPlayerFromId(src)

		if xPlayer then
			if payMethod == "money" then
				xPlayer.removeMoney(Cloud.PriceForDeath)
			elseif payMethod == "bank" then
				xPlayer.removeAccountMoney("bank", Cloud.PriceForDeath)
			end
			local msg <const> = (Cloud.Locales.MoneyRemoved):format(Cloud.PriceForDeath)
			ServerNotify(src, msg, "success")
			return true
		end
		return false
	end

	lib.callback.register("cloud-deathscreen:server:CanAfford", CanAfford)
	lib.callback.register("cloud-deathscreen:server:RemoveMoney", RemoveMoney)

	--! the removal of items after death is managed by the esx_ambulancejob resource
end
