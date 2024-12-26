local Config = require("shared.sh_config")
local Locales = require("shared.sh_locales")

if Config.Framework ~= "esx" then return end

local ESX = exports["es_extended"]:getSharedObject()

local function PayFine(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	if not xPlayer then return false end

	local amount = Config.PriceForDeath
	local moneyAvailable = xPlayer.getAccount("money").money
	local bankAvailable = xPlayer.getAccount("bank").money

	if moneyAvailable >= amount then
		xPlayer.removeAccountMoney("money", amount)
		ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
		return true
	elseif bankAvailable >= amount then
		xPlayer.removeAccountMoney("bank", amount)
		ServerNotify(source, Locales.Notify.PaidFine:format(amount), "info")
		return true
	else
		ServerNotify(source, Locales.Notify.NoMoney, "error")
		return false
	end
end

lib.callback.register("cloud-deathscreen:server:PayFine", PayFine)
